Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab1C1PK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:10:29 -0400
Received: from kroah.org ([198.145.64.141]:58843 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539Ab1C1PKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:10:14 -0400
Date: Mon, 28 Mar 2011 08:10:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.33.9
Message-ID: <20110328151004.GB26598@kroah.com>
References: <20110328150948.GA26598@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328150948.GA26598@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Documentation/i2c/instantiating-devices b/Documentation/i2c/instantiating-devices
index e894902..ed1779c 100644
--- a/Documentation/i2c/instantiating-devices
+++ b/Documentation/i2c/instantiating-devices
@@ -100,7 +100,7 @@ static int __devinit usb_hcd_pnx4008_probe(struct platform_device *pdev)
 	(...)
 	i2c_adap = i2c_get_adapter(2);
 	memset(&i2c_info, 0, sizeof(struct i2c_board_info));
-	strlcpy(i2c_info.name, "isp1301_pnx", I2C_NAME_SIZE);
+	strlcpy(i2c_info.type, "isp1301_pnx", I2C_NAME_SIZE);
 	isp1301_i2c_client = i2c_new_probed_device(i2c_adap, &i2c_info,
 						   normal_i2c);
 	i2c_put_adapter(i2c_adap);
diff --git a/Makefile b/Makefile
index 2de8294..8d9db6a 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 33
-EXTRAVERSION = .8
+EXTRAVERSION = .9
 NAME = Man-Eating Seals of Antiquity
 
 # *DOCUMENTATION*
diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index efbcee5..e13fc3f 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -117,7 +117,7 @@ int cpu_check_affinity(unsigned int irq, const struct cpumask *dest)
 	int cpu_dest;
 
 	/* timer and ipi have to always be received on all CPUs */
-	if (CHECK_IRQ_PER_CPU(irq)) {
+	if (CHECK_IRQ_PER_CPU(irq_to_desc(irq)->status)) {
 		/* Bad linux design decision.  The mask has already
 		 * been set; we must reset it */
 		cpumask_setall(irq_desc[irq].affinity);
diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index cca7c8f..8c066d6 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -162,6 +162,32 @@ static void crash_kexec_prepare_cpus(int cpu)
 	/* Leave the IPI callback set */
 }
 
+/* wait for all the CPUs to hit real mode but timeout if they don't come in */
+static void crash_kexec_wait_realmode(int cpu)
+{
+	unsigned int msecs;
+	int i;
+
+	msecs = 10000;
+	for (i=0; i < NR_CPUS && msecs > 0; i++) {
+		if (i == cpu)
+			continue;
+
+		while (paca[i].kexec_state < KEXEC_STATE_REAL_MODE) {
+			barrier();
+			if (!cpu_possible(i)) {
+				break;
+			}
+			if (!cpu_online(i)) {
+				break;
+			}
+			msecs--;
+			mdelay(1);
+		}
+	}
+	mb();
+}
+
 /*
  * This function will be called by secondary cpus or by kexec cpu
  * if soft-reset is activated to stop some CPUs.
@@ -419,6 +445,7 @@ void default_machine_crash_shutdown(struct pt_regs *regs)
 	crash_kexec_prepare_cpus(crashing_cpu);
 	cpu_set(crashing_cpu, cpus_in_crash);
 	crash_kexec_stop_spus();
+	crash_kexec_wait_realmode(crashing_cpu);
 	if (ppc_md.kexec_cpu_down)
 		ppc_md.kexec_cpu_down(1, 0);
 }
diff --git a/arch/powerpc/kernel/rtas_flash.c b/arch/powerpc/kernel/rtas_flash.c
index a85117d..1191765 100644
--- a/arch/powerpc/kernel/rtas_flash.c
+++ b/arch/powerpc/kernel/rtas_flash.c
@@ -93,12 +93,8 @@ struct flash_block_list {
 	struct flash_block_list *next;
 	struct flash_block blocks[FLASH_BLOCKS_PER_NODE];
 };
-struct flash_block_list_header { /* just the header of flash_block_list */
-	unsigned long num_blocks;
-	struct flash_block_list *next;
-};
 
-static struct flash_block_list_header rtas_firmware_flash_list = {0, NULL};
+static struct flash_block_list *rtas_firmware_flash_list;
 
 /* Use slab cache to guarantee 4k alignment */
 static struct kmem_cache *flash_block_cache = NULL;
@@ -107,13 +103,14 @@ static struct kmem_cache *flash_block_cache = NULL;
 
 /* Local copy of the flash block list.
  * We only allow one open of the flash proc file and create this
- * list as we go.  This list will be put in the
- * rtas_firmware_flash_list var once it is fully read.
+ * list as we go.  The rtas_firmware_flash_list varable will be
+ * set once the data is fully read.
  *
  * For convenience as we build the list we use virtual addrs,
  * we do not fill in the version number, and the length field
  * is treated as the number of entries currently in the block
- * (i.e. not a byte count).  This is all fixed on release.
+ * (i.e. not a byte count).  This is all fixed when calling
+ * the flash routine.
  */
 
 /* Status int must be first member of struct */
@@ -200,16 +197,16 @@ static int rtas_flash_release(struct inode *inode, struct file *file)
 	if (uf->flist) {    
 		/* File was opened in write mode for a new flash attempt */
 		/* Clear saved list */
-		if (rtas_firmware_flash_list.next) {
-			free_flash_list(rtas_firmware_flash_list.next);
-			rtas_firmware_flash_list.next = NULL;
+		if (rtas_firmware_flash_list) {
+			free_flash_list(rtas_firmware_flash_list);
+			rtas_firmware_flash_list = NULL;
 		}
 
 		if (uf->status != FLASH_AUTH)  
 			uf->status = flash_list_valid(uf->flist);
 
 		if (uf->status == FLASH_IMG_READY) 
-			rtas_firmware_flash_list.next = uf->flist;
+			rtas_firmware_flash_list = uf->flist;
 		else
 			free_flash_list(uf->flist);
 
@@ -592,7 +589,7 @@ static void rtas_flash_firmware(int reboot_type)
 	unsigned long rtas_block_list;
 	int i, status, update_token;
 
-	if (rtas_firmware_flash_list.next == NULL)
+	if (rtas_firmware_flash_list == NULL)
 		return;		/* nothing to do */
 
 	if (reboot_type != SYS_RESTART) {
@@ -609,20 +606,25 @@ static void rtas_flash_firmware(int reboot_type)
 		return;
 	}
 
-	/* NOTE: the "first" block list is a global var with no data
-	 * blocks in the kernel data segment.  We do this because
-	 * we want to ensure this block_list addr is under 4GB.
+	/*
+	 * NOTE: the "first" block must be under 4GB, so we create
+	 * an entry with no data blocks in the reserved buffer in
+	 * the kernel data segment.
 	 */
-	rtas_firmware_flash_list.num_blocks = 0;
-	flist = (struct flash_block_list *)&rtas_firmware_flash_list;
+	spin_lock(&rtas_data_buf_lock);
+	flist = (struct flash_block_list *)&rtas_data_buf[0];
+	flist->num_blocks = 0;
+	flist->next = rtas_firmware_flash_list;
 	rtas_block_list = virt_to_abs(flist);
 	if (rtas_block_list >= 4UL*1024*1024*1024) {
 		printk(KERN_ALERT "FLASH: kernel bug...flash list header addr above 4GB\n");
+		spin_unlock(&rtas_data_buf_lock);
 		return;
 	}
 
 	printk(KERN_ALERT "FLASH: preparing saved firmware image for flash\n");
 	/* Update the block_list in place. */
+	rtas_firmware_flash_list = NULL; /* too hard to backout on error */
 	image_size = 0;
 	for (f = flist; f; f = next) {
 		/* Translate data addrs to absolute */
@@ -663,6 +665,7 @@ static void rtas_flash_firmware(int reboot_type)
 		printk(KERN_ALERT "FLASH: unknown flash return code %d\n", status);
 		break;
 	}
+	spin_unlock(&rtas_data_buf_lock);
 }
 
 static void remove_flash_pde(struct proc_dir_entry *dp)
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 0697ff1..a50b6cd 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1268,7 +1268,7 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
 	decl PER_CPU_VAR(irq_count)
 	jmp  error_exit
 	CFI_ENDPROC
-END(do_hypervisor_callback)
+END(xen_do_hypervisor_callback)
 
 /*
  * Hypervisor uses this for application faults while it executes.
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index b5a9896..9ea4f81 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -76,9 +76,6 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	/* Make NULL pointers segfault */
 	zap_identity_mappings();
 
-	/* Cleanup the over mapped high alias */
-	cleanup_highmap();
-
 	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
 #ifdef CONFIG_EARLY_PRINTK
 		set_intr_gate(i, &early_idt_handlers[i]);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9243586..45fd3d0 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -295,6 +295,9 @@ static void __init init_gbpages(void)
 static inline void init_gbpages(void)
 {
 }
+static void __init cleanup_highmap(void)
+{
+}
 #endif
 
 static void __init reserve_brk(void)
@@ -895,6 +898,8 @@ void __init setup_arch(char **cmdline_p)
 
 	reserve_brk();
 
+	cleanup_highmap();
+
 	/*
 	 * Find and reserve possible boot-time SMP configuration:
 	 */
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index d406c52..e7e432f 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -283,25 +283,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	load_cr3(swapper_pg_dir);
 #endif
 
-#ifdef CONFIG_X86_64
-	if (!after_bootmem && !start) {
-		pud_t *pud;
-		pmd_t *pmd;
-
-		mmu_cr4_features = read_cr4();
-
-		/*
-		 * _brk_end cannot change anymore, but it and _end may be
-		 * located on different 2M pages. cleanup_highmap(), however,
-		 * can only consider _end when it runs, so destroy any
-		 * mappings beyond _brk_end here.
-		 */
-		pud = pud_offset(pgd_offset_k(_brk_end), _brk_end);
-		pmd = pmd_offset(pud, _brk_end - 1);
-		while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1))
-			pmd_clear(pmd);
-	}
-#endif
 	__flush_tlb_all();
 
 	if (!after_bootmem && e820_table_end > e820_table_start)
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 69ddfbd..19c9ed4 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -49,6 +49,7 @@
 #include <asm/numa.h>
 #include <asm/cacheflush.h>
 #include <asm/init.h>
+#include <asm/setup.h>
 #include <linux/bootmem.h>
 
 static unsigned long dma_reserve __initdata;
@@ -257,18 +258,18 @@ void __init init_extra_mapping_uc(unsigned long phys, unsigned long size)
  * to the compile time generated pmds. This results in invalid pmds up
  * to the point where we hit the physaddr 0 mapping.
  *
- * We limit the mappings to the region from _text to _end.  _end is
- * rounded up to the 2MB boundary. This catches the invalid pmds as
+ * We limit the mappings to the region from _text to _brk_end.  _brk_end
+ * is rounded up to the 2MB boundary. This catches the invalid pmds as
  * well, as they are located before _text:
  */
 void __init cleanup_highmap(void)
 {
 	unsigned long vaddr = __START_KERNEL_map;
-	unsigned long end = roundup((unsigned long)_end, PMD_SIZE) - 1;
+	unsigned long vaddr_end = __START_KERNEL_map + (max_pfn_mapped << PAGE_SHIFT);
+	unsigned long end = roundup((unsigned long)_brk_end, PMD_SIZE) - 1;
 	pmd_t *pmd = level2_kernel_pgt;
-	pmd_t *last_pmd = pmd + PTRS_PER_PMD;
 
-	for (; pmd < last_pmd; pmd++, vaddr += PMD_SIZE) {
+	for (; vaddr + PMD_SIZE - 1 < vaddr_end; pmd++, vaddr += PMD_SIZE) {
 		if (pmd_none(*pmd))
 			continue;
 		if (vaddr < (unsigned long) _text || vaddr > end)
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 350a3de..6ec047d 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1658,9 +1658,6 @@ static __init void xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
 		for (pteidx = 0; pteidx < PTRS_PER_PTE; pteidx++, pfn++) {
 			pte_t pte;
 
-			if (pfn > max_pfn_mapped)
-				max_pfn_mapped = pfn;
-
 			if (!pte_none(pte_page[pteidx]))
 				continue;
 
@@ -1704,6 +1701,12 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 	pud_t *l3;
 	pmd_t *l2;
 
+	/* max_pfn_mapped is the last pfn mapped in the initial memory
+	 * mappings. Considering that on Xen after the kernel mappings we
+	 * have the mappings of some pages that don't exist in pfn space, we
+	 * set max_pfn_mapped to the last real pfn mapped. */
+	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->mfn_list));
+
 	/* Zap identity mapping */
 	init_level4_pgt[0] = __pgd(0);
 
@@ -1767,9 +1770,7 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 {
 	pmd_t *kernel_pmd;
 
-	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->pt_base) +
-				  xen_start_info->nr_pt_frames * PAGE_SIZE +
-				  512*1024);
+	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->mfn_list));
 
 	kernel_pmd = m2v(pgd[KERNEL_PGD_BOUNDARY].pgd);
 	memcpy(level2_kernel_pgt, kernel_pmd, sizeof(pmd_t) * PTRS_PER_PMD);
diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index 18d65fb..3abb515 100644
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -267,8 +267,10 @@ int dcdbas_smi_request(struct smi_cmd *smi_cmd)
 	}
 
 	/* generate SMI */
+	/* inb to force posted write through and make SMI happen now */
 	asm volatile (
-		"outb %b0,%w1"
+		"outb %b0,%w1\n"
+		"inb %w1"
 		: /* no output args */
 		: "a" (smi_cmd->command_code),
 		  "d" (smi_cmd->command_address),
diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index fbc997e..2040507 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -332,11 +332,11 @@ static inline int sht15_calc_humid(struct sht15_data *data)
 
 	const int c1 = -4;
 	const int c2 = 40500; /* x 10 ^ -6 */
-	const int c3 = -2800; /* x10 ^ -9 */
+	const int c3 = -28; /* x 10 ^ -7 */
 
 	RHlinear = c1*1000
 		+ c2 * data->val_humid/1000
-		+ (data->val_humid * data->val_humid * c3)/1000000;
+		+ (data->val_humid * data->val_humid * c3) / 10000;
 	return (temp - 25000) * (10000 + 80 * data->val_humid)
 		/ 1000000 + RHlinear;
 }
diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index c721c0a..40a8cfd 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -108,7 +108,7 @@ static irqreturn_t input_handler(int rq, void *dev_id)
 static int __devinit xenkbd_probe(struct xenbus_device *dev,
 				  const struct xenbus_device_id *id)
 {
-	int ret, i;
+	int ret, i, abs;
 	struct xenkbd_info *info;
 	struct input_dev *kbd, *ptr;
 
@@ -126,6 +126,11 @@ static int __devinit xenkbd_probe(struct xenbus_device *dev,
 	if (!info->page)
 		goto error_nomem;
 
+	if (xenbus_scanf(XBT_NIL, dev->otherend, "feature-abs-pointer", "%d", &abs) < 0)
+		abs = 0;
+	if (abs)
+		xenbus_printf(XBT_NIL, dev->nodename, "request-abs-pointer", "1");
+
 	/* keyboard */
 	kbd = input_allocate_device();
 	if (!kbd)
@@ -135,11 +140,12 @@ static int __devinit xenkbd_probe(struct xenbus_device *dev,
 	kbd->id.bustype = BUS_PCI;
 	kbd->id.vendor = 0x5853;
 	kbd->id.product = 0xffff;
-	kbd->evbit[0] = BIT(EV_KEY);
+
+	__set_bit(EV_KEY, kbd->evbit);
 	for (i = KEY_ESC; i < KEY_UNKNOWN; i++)
-		set_bit(i, kbd->keybit);
+		__set_bit(i, kbd->keybit);
 	for (i = KEY_OK; i < KEY_MAX; i++)
-		set_bit(i, kbd->keybit);
+		__set_bit(i, kbd->keybit);
 
 	ret = input_register_device(kbd);
 	if (ret) {
@@ -158,12 +164,20 @@ static int __devinit xenkbd_probe(struct xenbus_device *dev,
 	ptr->id.bustype = BUS_PCI;
 	ptr->id.vendor = 0x5853;
 	ptr->id.product = 0xfffe;
-	ptr->evbit[0] = BIT(EV_KEY) | BIT(EV_REL) | BIT(EV_ABS);
+
+	if (abs) {
+		__set_bit(EV_ABS, ptr->evbit);
+		input_set_abs_params(ptr, ABS_X, 0, XENFB_WIDTH, 0, 0);
+		input_set_abs_params(ptr, ABS_Y, 0, XENFB_HEIGHT, 0, 0);
+	} else {
+		input_set_capability(ptr, EV_REL, REL_X);
+		input_set_capability(ptr, EV_REL, REL_Y);
+	}
+	input_set_capability(ptr, EV_REL, REL_WHEEL);
+
+	__set_bit(EV_KEY, ptr->evbit);
 	for (i = BTN_LEFT; i <= BTN_TASK; i++)
-		set_bit(i, ptr->keybit);
-	ptr->relbit[0] = BIT(REL_X) | BIT(REL_Y) | BIT(REL_WHEEL);
-	input_set_abs_params(ptr, ABS_X, 0, XENFB_WIDTH, 0, 0);
-	input_set_abs_params(ptr, ABS_Y, 0, XENFB_HEIGHT, 0, 0);
+		__set_bit(i, ptr->keybit);
 
 	ret = input_register_device(ptr);
 	if (ret) {
@@ -270,7 +284,7 @@ static void xenkbd_backend_changed(struct xenbus_device *dev,
 				   enum xenbus_state backend_state)
 {
 	struct xenkbd_info *info = dev_get_drvdata(&dev->dev);
-	int ret, val;
+	int val;
 
 	switch (backend_state) {
 	case XenbusStateInitialising:
@@ -281,17 +295,6 @@ static void xenkbd_backend_changed(struct xenbus_device *dev,
 
 	case XenbusStateInitWait:
 InitWait:
-		ret = xenbus_scanf(XBT_NIL, info->xbdev->otherend,
-				   "feature-abs-pointer", "%d", &val);
-		if (ret < 0)
-			val = 0;
-		if (val) {
-			ret = xenbus_printf(XBT_NIL, info->xbdev->nodename,
-					    "request-abs-pointer", "1");
-			if (ret)
-				printk(KERN_WARNING
-				       "xenkbd: can't request abs-pointer");
-		}
 		xenbus_switch_state(dev, XenbusStateConnected);
 		break;
 
diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index b42e845..86699b1 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -1260,6 +1260,14 @@ static int uvc_scan_chain_entity(struct uvc_video_chain *chain,
 
 		break;
 
+	case UVC_OTT_VENDOR_SPECIFIC:
+	case UVC_OTT_DISPLAY:
+	case UVC_OTT_MEDIA_TRANSPORT_OUTPUT:
+		if (uvc_trace_param & UVC_TRACE_PROBE)
+			printk(" OT %d", entity->id);
+
+		break;
+
 	case UVC_TT_STREAMING:
 		if (UVC_ENTITY_IS_ITERM(entity)) {
 			if (uvc_trace_param & UVC_TRACE_PROBE)
diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 7dcf534..253eed8 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -64,15 +64,19 @@ int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
 static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
 	struct uvc_streaming_control *ctrl)
 {
-	struct uvc_format *format;
+	struct uvc_format *format = NULL;
 	struct uvc_frame *frame = NULL;
 	unsigned int i;
 
-	if (ctrl->bFormatIndex <= 0 ||
-	    ctrl->bFormatIndex > stream->nformats)
-		return;
+	for (i = 0; i < stream->nformats; ++i) {
+		if (stream->format[i].index == ctrl->bFormatIndex) {
+			format = &stream->format[i];
+			break;
+		}
+	}
 
-	format = &stream->format[ctrl->bFormatIndex - 1];
+	if (format == NULL)
+		return;
 
 	for (i = 0; i < format->nframes; ++i) {
 		if (format->frame[i].bFrameIndex == ctrl->bFrameIndex) {
diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 06b6408..f4cae48 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -267,6 +267,14 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 		if (err)
 			goto remove;
 
+		/*
+		 * Update oldcard with the new RCA received from the SDIO
+		 * device -- we're doing this so that it's updated in the
+		 * "card" struct when oldcard overwrites that later.
+		 */
+		if (oldcard)
+			oldcard->rca = card->rca;
+
 		mmc_set_bus_mode(host, MMC_BUSMODE_PUSHPULL);
 	}
 
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index cb2fd01..fa84ac9 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -211,6 +211,7 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 
 	pdev = pci_get_slot(pbus, PCI_DEVFN(device, function));
 	if (pdev) {
+		pdev->current_state = PCI_D0;
 		slot->flags |= (SLOT_ENABLED | SLOT_POWEREDON);
 		pci_dev_put(pdev);
 	}
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index e189722..f7bfd6f 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -966,7 +966,12 @@ static ssize_t reset_store(struct device *dev,
 
 	if (val != 1)
 		return -EINVAL;
-	return pci_reset_function(pdev);
+
+	result = pci_reset_function(pdev);
+	if (result < 0)
+		return result;
+
+	return count;
 }
 
 static struct device_attribute reset_attr = __ATTR(reset, 0200, NULL, reset_store);
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 3cf6ef6..3eb4a3d 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -155,26 +155,6 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NEC,	PCI_DEVICE_ID_NEC_CBUS_2,	quirk_isa_d
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NEC,	PCI_DEVICE_ID_NEC_CBUS_3,	quirk_isa_dma_hangs);
 
 /*
- * Intel NM10 "TigerPoint" LPC PM1a_STS.BM_STS must be clear
- * for some HT machines to use C4 w/o hanging.
- */
-static void __devinit quirk_tigerpoint_bm_sts(struct pci_dev *dev)
-{
-	u32 pmbase;
-	u16 pm1a;
-
-	pci_read_config_dword(dev, 0x40, &pmbase);
-	pmbase = pmbase & 0xff80;
-	pm1a = inw(pmbase);
-
-	if (pm1a & 0x10) {
-		dev_info(&dev->dev, FW_BUG "TigerPoint LPC.BM_STS cleared\n");
-		outw(0x10, pmbase);
-	}
-}
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_TGP_LPC, quirk_tigerpoint_bm_sts);
-
-/*
  *	Chipsets where PCI->PCI transfers vanish or hang
  */
 static void __devinit quirk_nopcipci(struct pci_dev *dev)
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index d1c2108..61b1e73 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -297,6 +297,8 @@ static void acm_ctrl_irq(struct urb *urb)
 	if (!ACM_READY(acm))
 		goto exit;
 
+	usb_mark_last_busy(acm->dev);
+
 	data = (unsigned char *)(dr + 1);
 	switch (dr->bNotificationType) {
 	case USB_CDC_NOTIFY_NETWORK_CONNECTION:
@@ -336,7 +338,6 @@ static void acm_ctrl_irq(struct urb *urb)
 		break;
 	}
 exit:
-	usb_mark_last_busy(acm->dev);
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
 		dev_err(&urb->dev->dev, "%s - usb_submit_urb failed with "
@@ -534,6 +535,8 @@ static void acm_softint(struct work_struct *work)
 	if (!ACM_READY(acm))
 		return;
 	tty = tty_port_tty_get(&acm->port);
+	if (!tty)
+		return;
 	tty_wakeup(tty);
 	tty_kref_put(tty);
 }
@@ -652,8 +655,10 @@ static void acm_port_down(struct acm *acm, int drain)
 		usb_kill_urb(acm->ctrlurb);
 		for (i = 0; i < ACM_NW; i++)
 			usb_kill_urb(acm->wb[i].urb);
+		tasklet_disable(&acm->urb_task);
 		for (i = 0; i < nr; i++)
 			usb_kill_urb(acm->ru[i].urb);
+		tasklet_enable(&acm->urb_task);
 		acm->control->needs_remote_wakeup = 0;
 		usb_autopm_put_interface(acm->control);
 	}
diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index 8952177..d1d4bb1 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -315,7 +315,6 @@ qh_completions (struct ehci_hcd *ehci, struct ehci_qh *qh)
 	int			stopped;
 	unsigned		count = 0;
 	u8			state;
-	const __le32		halt = HALT_BIT(ehci);
 	struct ehci_qh_hw	*hw = qh->hw;
 
 	if (unlikely (list_empty (&qh->qtd_list)))
@@ -422,7 +421,6 @@ qh_completions (struct ehci_hcd *ehci, struct ehci_qh *qh)
 					&& !(qtd->hw_alt_next
 						& EHCI_LIST_END(ehci))) {
 				stopped = 1;
-				goto halt;
 			}
 
 		/* stop scanning when we reach qtds the hc is using */
@@ -456,16 +454,6 @@ qh_completions (struct ehci_hcd *ehci, struct ehci_qh *qh)
 				 */
 				ehci_clear_tt_buffer(ehci, qh, urb, token);
 			}
-
-			/* force halt for unlinked or blocked qh, so we'll
-			 * patch the qh later and so that completions can't
-			 * activate it while we "know" it's stopped.
-			 */
-			if ((halt & hw->hw_token) == 0) {
-halt:
-				hw->hw_token |= halt;
-				wmb ();
-			}
 		}
 
 		/* unless we already know the urb's status, collect qtd status
diff --git a/drivers/usb/misc/uss720.c b/drivers/usb/misc/uss720.c
index 5a03b2e..56b1e73 100644
--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -176,12 +176,11 @@ static struct uss720_async_request *submit_async_request(struct parport_uss720_p
 	spin_lock_irqsave(&priv->asynclock, flags);
 	list_add_tail(&rq->asynclist, &priv->asynclist);
 	spin_unlock_irqrestore(&priv->asynclock, flags);
+	kref_get(&rq->ref_count);
 	ret = usb_submit_urb(rq->urb, mem_flags);
-	if (!ret) {
-		kref_get(&rq->ref_count);
+	if (!ret)
 		return rq;
-	}
-	kref_put(&rq->ref_count, destroy_async);
+	destroy_async(&rq->ref_count);
 	err("submit_async_request submit_urb failed with %d", ret);
 	return NULL;
 }
diff --git a/drivers/video/console/tileblit.c b/drivers/video/console/tileblit.c
index 0056a41..15e8e1a 100644
--- a/drivers/video/console/tileblit.c
+++ b/drivers/video/console/tileblit.c
@@ -83,7 +83,7 @@ static void tile_cursor(struct vc_data *vc, struct fb_info *info, int mode,
 			int softback_lines, int fg, int bg)
 {
 	struct fb_tilecursor cursor;
-	int use_sw = (vc->vc_cursor_type & 0x01);
+	int use_sw = (vc->vc_cursor_type & 0x10);
 
 	cursor.sx = vc->vc_x;
 	cursor.sy = vc->vc_y;
diff --git a/fs/aio.c b/fs/aio.c
index 4e58cd4..da21e05 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -511,7 +511,7 @@ static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
 	ctx->reqs_active--;
 
 	if (unlikely(!ctx->reqs_active && ctx->dead))
-		wake_up(&ctx->wait);
+		wake_up_all(&ctx->wait);
 }
 
 static void aio_fput_routine(struct work_struct *data)
@@ -1224,7 +1224,7 @@ static void io_destroy(struct kioctx *ioctx)
 	 * by other CPUs at this point.  Right now, we rely on the
 	 * locking done by the above calls to ensure this consistency.
 	 */
-	wake_up(&ioctx->wait);
+	wake_up_all(&ioctx->wait);
 	put_ioctx(ioctx);	/* once for the lookup */
 }
 
diff --git a/fs/dcache.c b/fs/dcache.c
index 953173a..b6f6abb 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1176,9 +1176,12 @@ struct dentry *d_obtain_alias(struct inode *inode)
 	spin_unlock(&tmp->d_lock);
 
 	spin_unlock(&dcache_lock);
+	security_d_instantiate(tmp, inode);
 	return tmp;
 
  out_iput:
+	if (res && !IS_ERR(res))
+		security_d_instantiate(res, inode);
 	iput(inode);
 	return res;
 }
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index afa2b56..76f5d57 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1440,6 +1440,13 @@ static void ext3_orphan_cleanup (struct super_block * sb,
 		return;
 	}
 
+	/* Check if feature set allows readwrite operations */
+	if (EXT3_HAS_RO_COMPAT_FEATURE(sb, ~EXT3_FEATURE_RO_COMPAT_SUPP)) {
+		ext3_msg(sb, KERN_INFO, "Skipping orphan cleanup due to "
+			 "unknown ROCOMPAT features");
+		return;
+	}
+
 	if (EXT3_SB(sb)->s_mount_state & EXT3_ERROR_FS) {
 		if (es->s_last_orphan)
 			jbd_debug(1, "Errors on filesystem, "
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 37514c4..3db35a4 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -953,8 +953,8 @@ typedef __be32(*nfsd4op_func)(struct svc_rqst *, struct nfsd4_compound_state *,
 			      void *);
 enum nfsd4_op_flags {
 	ALLOWED_WITHOUT_FH = 1 << 0,	/* No current filehandle required */
-	ALLOWED_ON_ABSENT_FS = 2 << 0,	/* ops processed on absent fs */
-	ALLOWED_AS_FIRST_OP = 3 << 0,	/* ops reqired first in compound */
+	ALLOWED_ON_ABSENT_FS = 1 << 1,	/* ops processed on absent fs */
+	ALLOWED_AS_FIRST_OP = 1 << 2,	/* ops reqired first in compound */
 };
 
 struct nfsd4_operation {
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index f226172..4de2837 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1106,7 +1106,7 @@ nfsd4_decode_create_session(struct nfsd4_compoundargs *argp,
 
 	u32 dummy;
 	char *machine_name;
-	int i, j;
+	int i;
 	int nr_secflavs;
 
 	READ_BUF(16);
@@ -1179,8 +1179,6 @@ nfsd4_decode_create_session(struct nfsd4_compoundargs *argp,
 			READ_BUF(4);
 			READ32(dummy);
 			READ_BUF(dummy * 4);
-			for (j = 0; j < dummy; ++j)
-				READ32(dummy);
 			break;
 		case RPC_AUTH_GSS:
 			dprintk("RPC_AUTH_GSS callback secflavor "
@@ -1196,7 +1194,6 @@ nfsd4_decode_create_session(struct nfsd4_compoundargs *argp,
 			READ_BUF(4);
 			READ32(dummy);
 			READ_BUF(dummy);
-			p += XDR_QUADLEN(dummy);
 			break;
 		default:
 			dprintk("Illegal callback secflavor\n");
diff --git a/fs/proc/array.c b/fs/proc/array.c
index e804967..2ede41e 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -488,8 +488,8 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		vsize,
 		mm ? get_mm_rss(mm) : 0,
 		rsslim,
-		mm ? mm->start_code : 0,
-		mm ? mm->end_code : 0,
+		mm ? (permitted ? mm->start_code : 1) : 0,
+		mm ? (permitted ? mm->end_code : 1) : 0,
 		(permitted && mm) ? mm->start_stack : 0,
 		esp,
 		eip,
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d41b474..24b6bf8 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -243,8 +243,8 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 		const char *name = arch_vma_name(vma);
 		if (!name) {
 			if (mm) {
-				if (vma->vm_start <= mm->start_brk &&
-						vma->vm_end >= mm->brk) {
+				if (vma->vm_start <= mm->brk &&
+						vma->vm_end >= mm->start_brk) {
 					name = "[heap]";
 				} else if (vma->vm_start <= mm->start_stack &&
 					   vma->vm_end >= mm->start_stack) {
diff --git a/kernel/signal.c b/kernel/signal.c
index f156b48..49c2676 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2406,9 +2406,13 @@ SYSCALL_DEFINE3(rt_sigqueueinfo, pid_t, pid, int, sig,
 		return -EFAULT;
 
 	/* Not even root can pretend to send signals from the kernel.
-	   Nor can they impersonate a kill(), which adds source info.  */
-	if (info.si_code >= 0)
+	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
+	 */
+	if (info.si_code != SI_QUEUE) {
+		/* We used to allow any < 0 si_code */
+		WARN_ON_ONCE(info.si_code < 0);
 		return -EPERM;
+	}
 	info.si_signo = sig;
 
 	/* POSIX.1b doesn't mention process groups.  */
@@ -2422,9 +2426,13 @@ long do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig, siginfo_t *info)
 		return -EINVAL;
 
 	/* Not even root can pretend to send signals from the kernel.
-	   Nor can they impersonate a kill(), which adds source info.  */
-	if (info->si_code >= 0)
+	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
+	 */
+	if (info->si_code != SI_QUEUE) {
+		/* We used to allow any < 0 si_code */
+		WARN_ON_ONCE(info->si_code < 0);
 		return -EPERM;
+	}
 	info->si_signo = sig;
 
 	return do_send_specific(tgid, pid, sig, info);
diff --git a/kernel/smp.c b/kernel/smp.c
index b1490b9..90a3c26 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -428,7 +428,7 @@ void smp_call_function_many(const struct cpumask *mask,
 {
 	struct call_function_data *data;
 	unsigned long flags;
-	int cpu, next_cpu, this_cpu = smp_processor_id();
+	int refs, cpu, next_cpu, this_cpu = smp_processor_id();
 
 	/*
 	 * Can deadlock when called with interrupts disabled.
@@ -439,7 +439,7 @@ void smp_call_function_many(const struct cpumask *mask,
 	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
 		     && !oops_in_progress);
 
-	/* So, what's a CPU they want? Ignoring this one. */
+	/* Try to fastpath.  So, what's a CPU they want? Ignoring this one. */
 	cpu = cpumask_first_and(mask, cpu_online_mask);
 	if (cpu == this_cpu)
 		cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
@@ -497,6 +497,13 @@ void smp_call_function_many(const struct cpumask *mask,
 	/* We rely on the "and" being processed before the store */
 	cpumask_and(data->cpumask, mask, cpu_online_mask);
 	cpumask_clear_cpu(this_cpu, data->cpumask);
+	refs = cpumask_weight(data->cpumask);
+
+	/* Some callers race with other cpus changing the passed mask */
+	if (unlikely(!refs)) {
+		csd_unlock(&data->csd);
+		return;
+	}
 
 	raw_spin_lock_irqsave(&call_function.lock, flags);
 	/*
@@ -510,7 +517,7 @@ void smp_call_function_many(const struct cpumask *mask,
 	 * to the cpumask before this write to refs, which indicates
 	 * data is on the list and is ready to be processed.
 	 */
-	atomic_set(&data->refs, cpumask_weight(data->cpumask));
+	atomic_set(&data->refs, refs);
 	raw_spin_unlock_irqrestore(&call_function.lock, flags);
 
 	/*
diff --git a/mm/shmem.c b/mm/shmem.c
index eef4ebe..0203cda 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2701,5 +2701,6 @@ int shmem_zero_setup(struct vm_area_struct *vma)
 		fput(vma->vm_file);
 	vma->vm_file = file;
 	vma->vm_ops = &shmem_vm_ops;
+	vma->vm_flags |= VM_CAN_NONLINEAR;
 	return 0;
 }
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 2334279..60d1653 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -729,6 +729,8 @@ static void xs_reset_transport(struct sock_xprt *transport)
 	if (sk == NULL)
 		return;
 
+	transport->srcport = 0;
+
 	write_lock_bh(&sk->sk_callback_lock);
 	transport->inet = NULL;
 	transport->sock = NULL;
diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index b70e26a..7221a62d 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -1060,6 +1060,7 @@ static int via_mux_enum_put(struct snd_kcontrol *kcontrol,
 	struct hda_codec *codec = snd_kcontrol_chip(kcontrol);
 	struct via_spec *spec = codec->spec;
 	unsigned int adc_idx = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id);
+	int ret;
 
 	if (!spec->mux_nids[adc_idx])
 		return -EINVAL;
@@ -1068,12 +1069,14 @@ static int via_mux_enum_put(struct snd_kcontrol *kcontrol,
 			       AC_VERB_GET_POWER_STATE, 0x00) != AC_PWRST_D0)
 		snd_hda_codec_write(codec, spec->mux_nids[adc_idx], 0,
 				    AC_VERB_SET_POWER_STATE, AC_PWRST_D0);
-	/* update jack power state */
-	set_jack_power_state(codec);
 
-	return snd_hda_input_mux_put(codec, spec->input_mux, ucontrol,
+	ret = snd_hda_input_mux_put(codec, spec->input_mux, ucontrol,
 				     spec->mux_nids[adc_idx],
 				     &spec->cur_mux[adc_idx]);
+	/* update jack power state */
+	set_jack_power_state(codec);
+
+	return ret;
 }
 
 static int via_independent_hp_info(struct snd_kcontrol *kcontrol,
@@ -1262,6 +1265,11 @@ static void mute_aa_path(struct hda_codec *codec, int mute)
 		start_idx = 2;
 		end_idx = 4;
 		break;
+	case VT1718S:
+		nid_mixer = 0x21;
+		start_idx = 1;
+		end_idx = 3;
+		break;
 	default:
 		return;
 	}
