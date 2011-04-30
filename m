Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab1D3PJq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 11:09:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:44044 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab1D3PJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 11:09:40 -0400
Date: Sat, 30 Apr 2011 15:09:32 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Linux 2.6.27.59
Message-ID: <20110430150932.GA11884@hera.kernel.org>
References: <20110430150846.GA11600@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110430150846.GA11600@hera.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 30 Apr 2011 15:09:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 792be86..2b26915 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -811,6 +811,7 @@ and is between 256 and 4096 characters. It is defined in the file
 	i8042.panicblink=
 			[HW] Frequency with which keyboard LEDs should blink
 			     when kernel panics (default is 0.5 sec)
+	i8042.notimeout	[HW] Ignore timeout condition signalled by conroller
 	i8042.reset	[HW] Reset the controller during init and cleanup
 	i8042.unlock	[HW] Unlock (ignore) the keylock
 
diff --git a/MAINTAINERS b/MAINTAINERS
index ff24d01..69b10ea 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3857,8 +3857,6 @@ S:	Supported
 STABLE BRANCH:
 P:	Greg Kroah-Hartman
 M:	greg@kroah.com
-P:	Chris Wright
-M:	chrisw@sous-sol.org
 L:	stable@kernel.org
 S:	Maintained
 
diff --git a/Makefile b/Makefile
index e690b11..988dff7 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .58
+EXTRAVERSION = .59
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index ef2f86a..dcf60d7 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -410,7 +410,9 @@ setup_return(struct pt_regs *regs, struct k_sigaction *ka,
 	unsigned long handler = (unsigned long)ka->sa.sa_handler;
 	unsigned long retcode;
 	int thumb = 0;
-	unsigned long cpsr = regs->ARM_cpsr & ~PSR_f;
+	unsigned long cpsr = regs->ARM_cpsr & ~(PSR_f | PSR_E_BIT);
+
+	cpsr |= PSR_ENDSTATE;
 
 	/*
 	 * Maybe we need to deliver a 32-bit signal to a 26-bit task.
diff --git a/arch/ia64/sn/pci/tioca_provider.c b/arch/ia64/sn/pci/tioca_provider.c
index 79165122..92b191b 100644
--- a/arch/ia64/sn/pci/tioca_provider.c
+++ b/arch/ia64/sn/pci/tioca_provider.c
@@ -517,7 +517,7 @@ tioca_dma_unmap(struct pci_dev *pdev, dma_addr_t bus_addr, int dir)
  * use the GART mapped mode.
  */
 static u64
-tioca_dma_map(struct pci_dev *pdev, u64 paddr, size_t byte_count, int dma_flags)
+tioca_dma_map(struct pci_dev *pdev, unsigned long paddr, size_t byte_count, int dma_flags)
 {
 	u64 mapaddr;
 
diff --git a/arch/parisc/kernel/firmware.c b/arch/parisc/kernel/firmware.c
index 7177a6c..dfecc65 100644
--- a/arch/parisc/kernel/firmware.c
+++ b/arch/parisc/kernel/firmware.c
@@ -1096,42 +1096,23 @@ static char __attribute__((aligned(64))) iodc_dbuf[4096];
  */
 int pdc_iodc_print(const unsigned char *str, unsigned count)
 {
-	static int posx;        /* for simple TAB-Simulation... */
 	unsigned int i;
 	unsigned long flags;
 
-	for (i = 0; i < count && i < 79;) {
+	for (i = 0; i < count;) {
 		switch(str[i]) {
 		case '\n':
 			iodc_dbuf[i+0] = '\r';
 			iodc_dbuf[i+1] = '\n';
 			i += 2;
-			posx = 0;
 			goto print;
-		case '\t':
-			while (posx & 7) {
-				iodc_dbuf[i] = ' ';
-				i++, posx++;
-			}
-			break;
-		case '\b':	/* BS */
-			posx -= 2;
 		default:
 			iodc_dbuf[i] = str[i];
-			i++, posx++;
+			i++;
 			break;
 		}
 	}
 
-	/* if we're at the end of line, and not already inserting a newline,
-	 * insert one anyway. iodc console doesn't claim to support >79 char
-	 * lines. don't account for this in the return value.
-	 */
-	if (i == 79 && iodc_dbuf[i-1] != '\n') {
-		iodc_dbuf[i+0] = '\r';
-		iodc_dbuf[i+1] = '\n';
-	}
-
 print:
         spin_lock_irqsave(&pdc_lock, flags);
         real32_call(PAGE0->mem_cons.iodc_io,
diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index 23ef950..0b95ac5 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -117,7 +117,7 @@ int cpu_check_affinity(unsigned int irq, cpumask_t *dest)
 	int cpu_dest;
 
 	/* timer and ipi have to always be received on all CPUs */
-	if (CHECK_IRQ_PER_CPU(irq)) {
+	if (CHECK_IRQ_PER_CPU(irq_to_desc(irq)->status)) {
 		/* Bad linux design decision.  The mask has already
 		 * been set; we must reset it */
 		irq_desc[irq].affinity = CPU_MASK_ALL;
diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
index 6251a4b..c9dd94f 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -268,6 +268,7 @@ long plpar_hcall_raw(unsigned long opcode, unsigned long *retbuf, ...);
  */
 #define PLPAR_HCALL9_BUFSIZE 9
 long plpar_hcall9(unsigned long opcode, unsigned long *retbuf, ...);
+long plpar_hcall9_raw(unsigned long opcode, unsigned long *retbuf, ...);
 
 /* For hcall instrumentation.  One structure per-hcall, per-CPU */
 struct hcall_stats {
diff --git a/arch/powerpc/kernel/cpu_setup_6xx.S b/arch/powerpc/kernel/cpu_setup_6xx.S
index 72d1d73..fdb488c 100644
--- a/arch/powerpc/kernel/cpu_setup_6xx.S
+++ b/arch/powerpc/kernel/cpu_setup_6xx.S
@@ -17,65 +17,65 @@
 #include <asm/cache.h>
 
 _GLOBAL(__setup_cpu_603)
-	mflr	r4
+	mflr	r5
 BEGIN_FTR_SECTION
 	bl	__init_fpu_registers
 END_FTR_SECTION_IFCLR(CPU_FTR_FPU_UNAVAILABLE)
 	bl	setup_common_caches
-	mtlr	r4
+	mtlr	r5
 	blr
 _GLOBAL(__setup_cpu_604)
-	mflr	r4
+	mflr	r5
 	bl	setup_common_caches
 	bl	setup_604_hid0
-	mtlr	r4
+	mtlr	r5
 	blr
 _GLOBAL(__setup_cpu_750)
-	mflr	r4
+	mflr	r5
 	bl	__init_fpu_registers
 	bl	setup_common_caches
 	bl	setup_750_7400_hid0
-	mtlr	r4
+	mtlr	r5
 	blr
 _GLOBAL(__setup_cpu_750cx)
-	mflr	r4
+	mflr	r5
 	bl	__init_fpu_registers
 	bl	setup_common_caches
 	bl	setup_750_7400_hid0
 	bl	setup_750cx
-	mtlr	r4
+	mtlr	r5
 	blr
 _GLOBAL(__setup_cpu_750fx)
-	mflr	r4
+	mflr	r5
 	bl	__init_fpu_registers
 	bl	setup_common_caches
 	bl	setup_750_7400_hid0
 	bl	setup_750fx
-	mtlr	r4
+	mtlr	r5
 	blr
 _GLOBAL(__setup_cpu_7400)
-	mflr	r4
+	mflr	r5
 	bl	__init_fpu_registers
 	bl	setup_7400_workarounds
 	bl	setup_common_caches
 	bl	setup_750_7400_hid0
-	mtlr	r4
+	mtlr	r5
 	blr
 _GLOBAL(__setup_cpu_7410)
-	mflr	r4
+	mflr	r5
 	bl	__init_fpu_registers
 	bl	setup_7410_workarounds
 	bl	setup_common_caches
 	bl	setup_750_7400_hid0
 	li	r3,0
 	mtspr	SPRN_L2CR2,r3
-	mtlr	r4
+	mtlr	r5
 	blr
 _GLOBAL(__setup_cpu_745x)
-	mflr	r4
+	mflr	r5
 	bl	setup_common_caches
 	bl	setup_745x_specifics
-	mtlr	r4
+	mtlr	r5
 	blr
 
 /* Enable caches for 603's, 604, 750 & 7400 */
@@ -189,10 +189,10 @@ setup_750cx:
 	cror	4*cr0+eq,4*cr0+eq,4*cr1+eq
 	cror	4*cr0+eq,4*cr0+eq,4*cr2+eq
 	bnelr
-	lwz	r6,CPU_SPEC_FEATURES(r5)
+	lwz	r6,CPU_SPEC_FEATURES(r4)
 	li	r7,CPU_FTR_CAN_NAP
 	andc	r6,r6,r7
-	stw	r6,CPU_SPEC_FEATURES(r5)
+	stw	r6,CPU_SPEC_FEATURES(r4)
 	blr
 
 /* 750fx specific
@@ -220,12 +220,12 @@ BEGIN_FTR_SECTION
 	andis.	r11,r11,L3CR_L3E@h
 	beq	1f
 END_FTR_SECTION_IFSET(CPU_FTR_L3CR)
-	lwz	r6,CPU_SPEC_FEATURES(r5)
+	lwz	r6,CPU_SPEC_FEATURES(r4)
 	andi.	r0,r6,CPU_FTR_L3_DISABLE_NAP
 	beq	1f
 	li	r7,CPU_FTR_CAN_NAP
 	andc	r6,r6,r7
-	stw	r6,CPU_SPEC_FEATURES(r5)
+	stw	r6,CPU_SPEC_FEATURES(r4)
 1:
 	mfspr	r11,SPRN_HID0
 
diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index 0a8439a..5009198 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -162,6 +162,34 @@ static void crash_kexec_prepare_cpus(int cpu)
 	/* Leave the IPI callback set */
 }
 
+/* wait for all the CPUs to hit real mode but timeout if they don't come in */
+#ifdef CONFIG_PPC_STD_MMU_64
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
+#endif
+
 /*
  * This function will be called by secondary cpus or by kexec cpu
  * if soft-reset is activated to stop some CPUs.
@@ -347,10 +375,12 @@ int crash_shutdown_unregister(crash_shutdown_t handler)
 EXPORT_SYMBOL(crash_shutdown_unregister);
 
 static unsigned long crash_shutdown_buf[JMP_BUF_LEN];
+static int crash_shutdown_cpu = -1;
 
 static int handle_fault(struct pt_regs *regs)
 {
-	longjmp(crash_shutdown_buf, 1);
+	if (crash_shutdown_cpu == smp_processor_id())
+		longjmp(crash_shutdown_buf, 1);
 	return 0;
 }
 
@@ -375,11 +405,14 @@ void default_machine_crash_shutdown(struct pt_regs *regs)
 	for_each_irq(i) {
 		struct irq_desc *desc = irq_desc + i;
 
+		if (!desc || !desc->chip || !desc->chip->eoi)
+			continue;
+
 		if (desc->status & IRQ_INPROGRESS)
 			desc->chip->eoi(i);
 
 		if (!(desc->status & IRQ_DISABLED))
-			desc->chip->disable(i);
+			desc->chip->shutdown(i);
 	}
 
 	/*
@@ -388,6 +421,7 @@ void default_machine_crash_shutdown(struct pt_regs *regs)
 	 */
 	old_handler = __debugger_fault_handler;
 	__debugger_fault_handler = handle_fault;
+	crash_shutdown_cpu = smp_processor_id();
 	for (i = 0; crash_shutdown_handles[i]; i++) {
 		if (setjmp(crash_shutdown_buf) == 0) {
 			/*
@@ -401,6 +435,7 @@ void default_machine_crash_shutdown(struct pt_regs *regs)
 			asm volatile("sync; isync");
 		}
 	}
+	crash_shutdown_cpu = -1;
 	__debugger_fault_handler = old_handler;
 
 	/*
@@ -412,6 +447,9 @@ void default_machine_crash_shutdown(struct pt_regs *regs)
 	crash_kexec_prepare_cpus(crashing_cpu);
 	cpu_set(crashing_cpu, cpus_in_crash);
 	crash_kexec_stop_spus();
+#if defined(CONFIG_PPC_STD_MMU_64) && defined(CONFIG_SMP)
+	crash_kexec_wait_realmode(crashing_cpu);
+#endif
 	if (ppc_md.kexec_cpu_down)
 		ppc_md.kexec_cpu_down(1, 0);
 }
diff --git a/arch/powerpc/kernel/machine_kexec_64.c b/arch/powerpc/kernel/machine_kexec_64.c
index a168514..a7cebf3 100644
--- a/arch/powerpc/kernel/machine_kexec_64.c
+++ b/arch/powerpc/kernel/machine_kexec_64.c
@@ -14,6 +14,7 @@
 #include <linux/smp.h>
 #include <linux/thread_info.h>
 #include <linux/errno.h>
+#include <linux/cpu.h>
 
 #include <asm/page.h>
 #include <asm/current.h>
@@ -168,10 +169,34 @@ static void kexec_smp_down(void *arg)
 	/* NOTREACHED */
 }
 
+/*
+ * We need to make sure each present CPU is online.  The next kernel will scan
+ * the device tree and assume primary threads are online and query secondary
+ * threads via RTAS to online them if required.  If we don't online primary
+ * threads, they will be stuck.  However, we also online secondary threads as we
+ * may be using 'cede offline'.  In this case RTAS doesn't see the secondary
+ * threads as offline -- and again, these CPUs will be stuck.
+ *
+ * So, we online all CPUs that should be running, including secondary threads.
+ */
+static void wake_offline_cpus(void)
+{
+	int cpu = 0;
+
+	for_each_present_cpu(cpu) {
+		if (!cpu_online(cpu)) {
+			printk(KERN_INFO "kexec: Waking offline cpu %d.\n",
+					cpu);
+			cpu_up(cpu);
+		}
+	}
+}
+
 static void kexec_prepare_cpus(void)
 {
 	int my_cpu, i, notified=-1;
 
+	wake_offline_cpus();
 	smp_call_function(kexec_smp_down, NULL, /* wait */0);
 	my_cpu = get_cpu();
 
diff --git a/arch/powerpc/kernel/rtas_flash.c b/arch/powerpc/kernel/rtas_flash.c
index 149cb11..0a9a98f 100644
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
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 8b25f51..fc09beb 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -451,9 +451,18 @@ void __init setup_system(void)
 	DBG(" <- setup_system()\n");
 }
 
+static u64 slb0_limit(void)
+{
+	if (cpu_has_feature(CPU_FTR_1T_SEGMENT)) {
+		return 1UL << SID_SHIFT_1T;
+	}
+	return 1UL << SID_SHIFT;
+}
+
 #ifdef CONFIG_IRQSTACKS
 static void __init irqstack_early_init(void)
 {
+	u64 limit = slb0_limit();
 	unsigned int i;
 
 	/*
@@ -463,10 +472,10 @@ static void __init irqstack_early_init(void)
 	for_each_possible_cpu(i) {
 		softirq_ctx[i] = (struct thread_info *)
 			__va(lmb_alloc_base(THREAD_SIZE,
-					    THREAD_SIZE, 0x10000000));
+					    THREAD_SIZE, limit));
 		hardirq_ctx[i] = (struct thread_info *)
 			__va(lmb_alloc_base(THREAD_SIZE,
-					    THREAD_SIZE, 0x10000000));
+					    THREAD_SIZE, limit));
 	}
 }
 #else
@@ -479,7 +488,7 @@ static void __init irqstack_early_init(void)
  */
 static void __init emergency_stack_init(void)
 {
-	unsigned long limit;
+	u64 limit;
 	unsigned int i;
 
 	/*
@@ -491,7 +500,7 @@ static void __init emergency_stack_init(void)
 	 * bringup, we need to get at them in real mode. This means they
 	 * must also be within the RMO region.
 	 */
-	limit = min(0x10000000UL, lmb.rmo_size);
+	limit = min(slb0_limit(), lmb.rmo_size);
 
 	for_each_possible_cpu(i) {
 		unsigned long sp;
diff --git a/arch/powerpc/platforms/pseries/hvCall.S b/arch/powerpc/platforms/pseries/hvCall.S
index c1427b3..34c76a52 100644
--- a/arch/powerpc/platforms/pseries/hvCall.S
+++ b/arch/powerpc/platforms/pseries/hvCall.S
@@ -202,3 +202,41 @@ _GLOBAL(plpar_hcall9)
 	mtcrf	0xff,r0
 
 	blr				/* return r3 = status */
+
+/* See plpar_hcall_raw to see why this is needed */
+_GLOBAL(plpar_hcall9_raw)
+	HMT_MEDIUM
+
+	mfcr	r0
+	stw	r0,8(r1)
+
+	std     r4,STK_PARM(r4)(r1)     /* Save ret buffer */
+
+	mr	r4,r5
+	mr	r5,r6
+	mr	r6,r7
+	mr	r7,r8
+	mr	r8,r9
+	mr	r9,r10
+	ld	r10,STK_PARM(r11)(r1)	 /* put arg7 in R10 */
+	ld	r11,STK_PARM(r12)(r1)	 /* put arg8 in R11 */
+	ld	r12,STK_PARM(r13)(r1)    /* put arg9 in R12 */
+
+	HVSC				/* invoke the hypervisor */
+
+	mr	r0,r12
+	ld	r12,STK_PARM(r4)(r1)
+	std	r4,  0(r12)
+	std	r5,  8(r12)
+	std	r6, 16(r12)
+	std	r7, 24(r12)
+	std	r8, 32(r12)
+	std	r9, 40(r12)
+	std	r10,48(r12)
+	std	r11,56(r12)
+	std	r0, 64(r12)
+
+	lwz	r0,8(r1)
+	mtcrf	0xff,r0
+
+	blr				/* return r3 = status */
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 52a80e5..2f1ff34 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -366,21 +366,28 @@ static void pSeries_lpar_hptab_clear(void)
 {
 	unsigned long size_bytes = 1UL << ppc64_pft_size;
 	unsigned long hpte_count = size_bytes >> 4;
-	unsigned long dummy1, dummy2, dword0;
+	struct {
+		unsigned long pteh;
+		unsigned long ptel;
+	} ptes[4];
 	long lpar_rc;
-	int i;
-
-	/* TODO: Use bulk call */
-	for (i = 0; i < hpte_count; i++) {
-		/* dont remove HPTEs with VRMA mappings */
-		lpar_rc = plpar_pte_remove_raw(H_ANDCOND, i, HPTE_V_1TB_SEG,
-						&dummy1, &dummy2);
-		if (lpar_rc == H_NOT_FOUND) {
-			lpar_rc = plpar_pte_read_raw(0, i, &dword0, &dummy1);
-			if (!lpar_rc && ((dword0 & HPTE_V_VRMA_MASK)
-				!= HPTE_V_VRMA_MASK))
-				/* Can be hpte for 1TB Seg. So remove it */
-				plpar_pte_remove_raw(0, i, 0, &dummy1, &dummy2);
+	int i, j;
+
+	/* Read in batches of 4,
+	 * invalidate only valid entries not in the VRMA
+	 * hpte_count will be a multiple of 4
+         */
+	for (i = 0; i < hpte_count; i += 4) {
+		lpar_rc = plpar_pte_read_4_raw(0, i, (void *)ptes);
+		if (lpar_rc != H_SUCCESS)
+			continue;
+		for (j = 0; j < 4; j++){
+			if ((ptes[j].pteh & HPTE_V_VRMA_MASK) ==
+				HPTE_V_VRMA_MASK)
+				continue;
+			if (ptes[j].pteh & HPTE_V_VALID)
+				plpar_pte_remove_raw(0, i + j, 0,
+					&(ptes[j].pteh), &(ptes[j].ptel));
 		}
 	}
 }
diff --git a/arch/powerpc/platforms/pseries/plpar_wrappers.h b/arch/powerpc/platforms/pseries/plpar_wrappers.h
index 1adef11..ff4f149 100644
--- a/arch/powerpc/platforms/pseries/plpar_wrappers.h
+++ b/arch/powerpc/platforms/pseries/plpar_wrappers.h
@@ -159,6 +159,24 @@ static inline long plpar_pte_read_raw(unsigned long flags, unsigned long ptex,
 	return rc;
 }
 
+/*
+ * plpar_pte_read_4_raw can be called in real mode.
+ * ptes must be 8*sizeof(unsigned long)
+ */
+static inline long plpar_pte_read_4_raw(unsigned long flags, unsigned long ptex,
+					unsigned long *ptes)
+
+{
+	long rc;
+	unsigned long retbuf[PLPAR_HCALL9_BUFSIZE];
+
+	rc = plpar_hcall9_raw(H_READ, retbuf, flags | H_READ_4, ptex);
+
+	memcpy(ptes, retbuf, 8*sizeof(unsigned long));
+
+	return rc;
+}
+
 static inline long plpar_pte_protect(unsigned long flags, unsigned long ptex,
 		unsigned long avpn)
 {
diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index a0fa4eb..3d9cb2e 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -828,7 +828,6 @@ fsl_rio_dbell_handler(int irq, void *dev_instance)
 	if (dsr & DOORBELL_DSR_QFI) {
 		pr_info("RIO: doorbell queue full\n");
 		out_be32(&priv->msg_regs->dsr, DOORBELL_DSR_QFI);
-		goto out;
 	}
 
 	/* XXX Need to check/dispatch until queue empty */
diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index 4af80af..11ee3dd 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -175,11 +175,6 @@ extern int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
  */
 extern unsigned long thread_saved_pc(struct task_struct *t);
 
-/*
- * Print register of task into buffer. Used in fs/proc/array.c.
- */
-extern void task_show_regs(struct seq_file *m, struct task_struct *task);
-
 extern void show_code(struct pt_regs *regs);
 
 unsigned long get_wchan(struct task_struct *p);
diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
index 4584d81..dc4f574f 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -241,43 +241,6 @@ void show_regs(struct pt_regs *regs)
 	show_last_breaking_event(regs);
 }
 
-/* This is called from fs/proc/array.c */
-void task_show_regs(struct seq_file *m, struct task_struct *task)
-{
-	struct pt_regs *regs;
-
-	regs = task_pt_regs(task);
-	seq_printf(m, "task: %p, ksp: %p\n",
-		       task, (void *)task->thread.ksp);
-	seq_printf(m, "User PSW : %p %p\n",
-		       (void *) regs->psw.mask, (void *)regs->psw.addr);
-
-	seq_printf(m, "User GPRS: " FOURLONG,
-			  regs->gprs[0], regs->gprs[1],
-			  regs->gprs[2], regs->gprs[3]);
-	seq_printf(m, "           " FOURLONG,
-			  regs->gprs[4], regs->gprs[5],
-			  regs->gprs[6], regs->gprs[7]);
-	seq_printf(m, "           " FOURLONG,
-			  regs->gprs[8], regs->gprs[9],
-			  regs->gprs[10], regs->gprs[11]);
-	seq_printf(m, "           " FOURLONG,
-			  regs->gprs[12], regs->gprs[13],
-			  regs->gprs[14], regs->gprs[15]);
-	seq_printf(m, "User ACRS: %08x %08x %08x %08x\n",
-			  task->thread.acrs[0], task->thread.acrs[1],
-			  task->thread.acrs[2], task->thread.acrs[3]);
-	seq_printf(m, "           %08x %08x %08x %08x\n",
-			  task->thread.acrs[4], task->thread.acrs[5],
-			  task->thread.acrs[6], task->thread.acrs[7]);
-	seq_printf(m, "           %08x %08x %08x %08x\n",
-			  task->thread.acrs[8], task->thread.acrs[9],
-			  task->thread.acrs[10], task->thread.acrs[11]);
-	seq_printf(m, "           %08x %08x %08x %08x\n",
-			  task->thread.acrs[12], task->thread.acrs[13],
-			  task->thread.acrs[14], task->thread.acrs[15]);
-}
-
 static DEFINE_SPINLOCK(die_lock);
 
 void die(const char * str, struct pt_regs * regs, long err)
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 66e48aa..f7db631 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1189,6 +1189,9 @@ static int __init parse_memopt(char *p)
 
 	userdef = 1;
 	mem_size = memparse(p, &p);
+	/* don't remove all of memory when handling "mem={invalid}" param */
+	if (mem_size == 0)
+		return -EINVAL;
 	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
 
 	return 0;
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 1b894b7..67a3a3d 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -163,7 +163,12 @@ static void __init ati_bugs_contd(int num, int slot, int func)
 		return;
 
 	rev = ati_sbx00_rev(num, slot, func);
-	if (rev > 0x13)
+	/*
+	 * SB600: revisions 0x11, 0x12, 0x13, 0x14, ...
+	 * SB700: revisions 0x39, 0x3a, ...
+	 * SB800: revisions 0x40, 0x41, ...
+	 */
+	if (rev >= 0x39)
 		return;
 
 	/* check for IRQ0 interrupt swap */
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 89434d4..b575911 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1404,7 +1404,7 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
 	decl %gs:pda_irqcount
 	jmp  error_exit
 	CFI_ENDPROC
-END(do_hypervisor_callback)
+END(xen_do_hypervisor_callback)
 
 /*
 # Hypervisor uses this for application faults while it executes.
diff --git a/arch/x86/lib/semaphore_32.S b/arch/x86/lib/semaphore_32.S
index 648fe47..f35eec7 100644
--- a/arch/x86/lib/semaphore_32.S
+++ b/arch/x86/lib/semaphore_32.S
@@ -36,7 +36,7 @@
  */
 #ifdef CONFIG_SMP
 ENTRY(__write_lock_failed)
-	CFI_STARTPROC simple
+	CFI_STARTPROC
 	FRAME
 2: 	LOCK_PREFIX
 	addl	$ RW_LOCK_BIAS,(%eax)
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index d503027..cf95584 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -138,8 +138,7 @@ void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd)
 	 * section 8.1: in PAE mode we explicitly have to flush the
 	 * TLB via cr3 if the top-level pgd is changed...
 	 */
-	if (mm == current->active_mm)
-		write_cr3(read_cr3());
+	flush_tlb_mm(mm);
 }
 #else  /* !CONFIG_X86_PAE */
 
diff --git a/drivers/acpi/asus_acpi.c b/drivers/acpi/asus_acpi.c
index e2ab023..0037320 100644
--- a/drivers/acpi/asus_acpi.c
+++ b/drivers/acpi/asus_acpi.c
@@ -985,14 +985,8 @@ static int asus_hotk_add_fs(struct acpi_device *device)
 	struct proc_dir_entry *proc;
 	mode_t mode;
 
-	/*
-	 * If parameter uid or gid is not changed, keep the default setting for
-	 * our proc entries (-rw-rw-rw-) else, it means we care about security,
-	 * and then set to -rw-rw----
-	 */
-
 	if ((asus_uid == 0) && (asus_gid == 0)) {
-		mode = S_IFREG | S_IRUGO | S_IWUGO;
+		mode = S_IFREG | S_IRUGO | S_IWUSR | S_IWGRP;
 	} else {
 		mode = S_IFREG | S_IRUSR | S_IRGRP | S_IWUSR | S_IWGRP;
 		printk(KERN_WARNING "  asus_uid and asus_gid parameters are "
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 2e1a7cb..2e0a3d0 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -486,10 +486,25 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x502b), board_ahci }, /* Tolapai */
 	{ PCI_VDEVICE(INTEL, 0x3a05), board_ahci }, /* ICH10 */
 	{ PCI_VDEVICE(INTEL, 0x3a25), board_ahci }, /* ICH10 */
+	{ PCI_VDEVICE(INTEL, 0x3b22), board_ahci }, /* PCH AHCI */
+	{ PCI_VDEVICE(INTEL, 0x3b23), board_ahci }, /* PCH AHCI */
 	{ PCI_VDEVICE(INTEL, 0x3b24), board_ahci }, /* PCH RAID */
 	{ PCI_VDEVICE(INTEL, 0x3b25), board_ahci }, /* PCH RAID */
+	{ PCI_VDEVICE(INTEL, 0x3b29), board_ahci }, /* PCH AHCI */
 	{ PCI_VDEVICE(INTEL, 0x3b2b), board_ahci }, /* PCH RAID */
 	{ PCI_VDEVICE(INTEL, 0x3b2c), board_ahci }, /* PCH RAID */
+	{ PCI_VDEVICE(INTEL, 0x3b2f), board_ahci }, /* PCH AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1c02), board_ahci }, /* CPT AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1c03), board_ahci }, /* CPT AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1c04), board_ahci }, /* CPT RAID */
+	{ PCI_VDEVICE(INTEL, 0x1c05), board_ahci }, /* CPT RAID */
+	{ PCI_VDEVICE(INTEL, 0x1c06), board_ahci }, /* CPT RAID */
+	{ PCI_VDEVICE(INTEL, 0x1c07), board_ahci }, /* CPT RAID */
+	{ PCI_VDEVICE(INTEL, 0x1d02), board_ahci }, /* PBG AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1d04), board_ahci }, /* PBG RAID */
+	{ PCI_VDEVICE(INTEL, 0x1d06), board_ahci }, /* PBG RAID */
+	{ PCI_VDEVICE(INTEL, 0x2826), board_ahci }, /* PBG RAID */
+	{ PCI_VDEVICE(INTEL, 0x2323), board_ahci }, /* DH89xxCC AHCI */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 512c281..8c5fad1 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4702,9 +4702,6 @@ static void ata_verify_xfer(struct ata_queued_cmd *qc)
 {
 	struct ata_device *dev = qc->dev;
 
-	if (ata_tag_internal(qc->tag))
-		return;
-
 	if (ata_is_nodata(qc->tf.protocol))
 		return;
 
@@ -4751,14 +4748,23 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
 		if (unlikely(qc->err_mask))
 			qc->flags |= ATA_QCFLAG_FAILED;
 
-		if (unlikely(qc->flags & ATA_QCFLAG_FAILED)) {
-			/* always fill result TF for failed qc */
+		/*
+		 * Finish internal commands without any further processing
+		 * and always with the result TF filled.
+		 */
+		if (unlikely(ata_tag_internal(qc->tag))) {
 			fill_result_tf(qc);
+			__ata_qc_complete(qc);
+			return;
+		}
 
-			if (!ata_tag_internal(qc->tag))
-				ata_qc_schedule_eh(qc);
-			else
-				__ata_qc_complete(qc);
+		/*
+		 * Non-internal qc has failed.  Fill the result TF and
+		 * summon EH.
+		 */
+		if (unlikely(qc->flags & ATA_QCFLAG_FAILED)) {
+			fill_result_tf(qc);
+			ata_qc_schedule_eh(qc);
 			return;
 		}
 
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 24a7efa..2e5816c 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -157,6 +157,7 @@ static void SA5_submit_command( ctlr_info_t *h, CommandList_struct *c)
 	 printk("Sending %x - down to controller\n", c->busaddr );
 #endif /* CCISS_DEBUG */ 
          writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
+	readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
 	 h->commands_outstanding++;
 	 if ( h->commands_outstanding > h->max_outstanding)
 		h->max_outstanding = h->commands_outstanding;
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 29b7a64..88c3b33 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2405,7 +2405,7 @@ static void pkt_release_dev(struct pktcdvd_device *pd, int flush)
 	pkt_shrink_pktlist(pd);
 }
 
-static struct pktcdvd_device *pkt_find_dev_from_minor(int dev_minor)
+static struct pktcdvd_device *pkt_find_dev_from_minor(unsigned int dev_minor)
 {
 	if (dev_minor >= MAX_WRITERS)
 		return NULL;
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index af472e0..b5b2928 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -65,6 +65,9 @@ static struct usb_device_id btusb_table[] = {
 	/* Generic Bluetooth USB device */
 	{ USB_DEVICE_INFO(0xe0, 0x01, 0x01) },
 
+	/* Apple MacBookPro8,2 */
+	{ USB_DEVICE(0x05ac, 0x821a) },
+
 	/* AVM BlueFRITZ! USB v2.0 */
 	{ USB_DEVICE(0x057c, 0x3800) },
 
diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index ae766d8..cc4f177 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -354,12 +354,14 @@ unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip,
 		    tpm_protected_ordinal_duration[ordinal &
 						   TPM_PROTECTED_ORDINAL_MASK];
 
-	if (duration_idx != TPM_UNDEFINED)
+	if (duration_idx != TPM_UNDEFINED) {
 		duration = chip->vendor.duration[duration_idx];
-	if (duration <= 0)
+		/* if duration is 0, it's because chip->vendor.duration wasn't */
+		/* filled yet, so we set the lowest timeout just to give enough */
+		/* time for tpm_get_timeouts() to succeed */
+		return (duration <= 0 ? HZ : duration);
+	} else
 		return 2 * 60 * HZ;
-	else
-		return duration;
 }
 EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
 
@@ -986,7 +988,7 @@ int tpm_open(struct inode *inode, struct file *file)
 
 	spin_unlock(&driver_lock);
 
-	chip->data_buffer = kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
+	chip->data_buffer = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
 	if (chip->data_buffer == NULL) {
 		chip->num_opens--;
 		put_device(chip->dev);
diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index 50a071f..bfec899 100644
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -264,8 +264,10 @@ static int smi_request(struct smi_cmd *smi_cmd)
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
diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
index 71556e6..03a0161 100644
--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -808,7 +808,6 @@ static int __devexit f71882fg_remove(struct platform_device *pdev)
 	int i;
 	struct f71882fg_data *data = platform_get_drvdata(pdev);
 
-	platform_set_drvdata(pdev, NULL);
 	hwmon_device_unregister(data->hwmon_dev);
 
 	for (i = 0; i < ARRAY_SIZE(f71882fg_dev_attr); i++)
@@ -821,6 +820,7 @@ static int __devexit f71882fg_remove(struct platform_device *pdev)
 	for (i = 0; i < ARRAY_SIZE(f71882fg_fan_attr); i++)
 		device_remove_file(&pdev->dev, &f71882fg_fan_attr[i].dev_attr);
 
+	platform_set_drvdata(pdev, NULL);
 	kfree(data);
 
 	return 0;
diff --git a/drivers/hwmon/via686a.c b/drivers/hwmon/via686a.c
index f1ee5e7..088fa23 100644
--- a/drivers/hwmon/via686a.c
+++ b/drivers/hwmon/via686a.c
@@ -686,6 +686,13 @@ static int __devexit via686a_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void via686a_update_fan_div(struct via686a_data *data)
+{
+	int reg = via686a_read_value(data, VIA686A_REG_FANDIV);
+	data->fan_div[0] = (reg >> 4) & 0x03;
+	data->fan_div[1] = reg >> 6;
+}
+
 static void __devinit via686a_init_device(struct via686a_data *data)
 {
 	u8 reg;
@@ -699,6 +706,9 @@ static void __devinit via686a_init_device(struct via686a_data *data)
 	via686a_write_value(data, VIA686A_REG_TEMP_MODE,
 			    (reg & ~VIA686A_TEMP_MODE_MASK)
 			    | VIA686A_TEMP_MODE_CONTINUOUS);
+
+	/* Pre-read fan clock divisor values */
+	via686a_update_fan_div(data);
 }
 
 static struct via686a_data *via686a_update_device(struct device *dev)
@@ -750,9 +760,7 @@ static struct via686a_data *via686a_update_device(struct device *dev)
 		    (via686a_read_value(data, VIA686A_REG_TEMP_LOW23) &
 		     0xc0) >> 6;
 
-		i = via686a_read_value(data, VIA686A_REG_FANDIV);
-		data->fan_div[0] = (i >> 4) & 0x03;
-		data->fan_div[1] = i >> 6;
+		via686a_update_fan_div(data);
 		data->alarms =
 		    via686a_read_value(data,
 				       VIA686A_REG_ALARM1) |
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 922d35f..29deac3 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -2987,6 +2987,7 @@ static int cm_sidr_req_handler(struct cm_work *work)
 		goto out; /* No match. */
 	}
 	atomic_inc(&cur_cm_id_priv->refcount);
+	atomic_inc(&cm_id_priv->refcount);
 	spin_unlock_irq(&cm.lock);
 
 	cm_id_priv->id.cm_handler = cur_cm_id_priv->id.cm_handler;
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index d951896..25fd55cb 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1129,6 +1129,11 @@ static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 	cm_id->context = conn_id;
 	cm_id->cm_handler = cma_ib_handler;
 
+	/*
+	 * Protect against the user destroying conn_id from another thread
+	 * until we're done accessing it.
+	 */
+	atomic_inc(&conn_id->refcount);
 	ret = conn_id->id.event_handler(&conn_id->id, &event);
 	if (!ret) {
 		/*
@@ -1141,8 +1146,10 @@ static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 			ib_send_cm_mra(cm_id, CMA_CM_MRA_SETTING, NULL, 0);
 		mutex_unlock(&lock);
 		mutex_unlock(&conn_id->handler_mutex);
+		cma_deref_id(conn_id);
 		goto out;
 	}
+	cma_deref_id(conn_id);
 
 	/* Destroy the CM ID by returning a non-zero value. */
 	conn_id->cm_id.ib = NULL;
@@ -1344,17 +1351,25 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 	event.param.conn.private_data_len = iw_event->private_data_len;
 	event.param.conn.initiator_depth = attr.max_qp_init_rd_atom;
 	event.param.conn.responder_resources = attr.max_qp_rd_atom;
+
+	/*
+	 * Protect against the user destroying conn_id from another thread
+	 * until we're done accessing it.
+	 */
+	atomic_inc(&conn_id->refcount);
 	ret = conn_id->id.event_handler(&conn_id->id, &event);
 	if (ret) {
 		/* User wants to destroy the CM ID */
 		conn_id->cm_id.iw = NULL;
 		cma_exch(conn_id, CMA_DESTROYING);
 		mutex_unlock(&conn_id->handler_mutex);
+		cma_deref_id(conn_id);
 		rdma_destroy_id(&conn_id->id);
 		goto out;
 	}
 
 	mutex_unlock(&conn_id->handler_mutex);
+	cma_deref_id(conn_id);
 
 out:
 	if (dev)
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 29e6863..6afa77df 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -430,6 +430,13 @@ static struct dmi_system_id __initdata i8042_dmi_dritek_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 4280"),
 		},
 	},
+	{
+		/* Dell Vostro V13 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro V13"),
+		},
+	},
 	{ }
 };
 
@@ -655,6 +662,17 @@ static int __init i8042_platform_init(void)
 {
 	int retval;
 
+static const struct dmi_system_id __initconst i8042_dmi_notimeout_table[] = {
+	{
+		/* Dell Vostro V13 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro V13"),
+		},
+	},
+	{ }
+};
+
 /*
  * On ix86 platforms touching the i8042 data register region can do really
  * bad things. Because of this the region is always reserved on ix86 boxes.
@@ -681,6 +699,9 @@ static int __init i8042_platform_init(void)
 	if (dmi_check_system(i8042_dmi_nomux_table))
 		i8042_nomux = 1;
 
+	if (dmi_check_system(i8042_dmi_notimeout_table))
+		i8042_notimeout = true;
+
 	if (dmi_check_system(i8042_dmi_dritek_table))
 		i8042_dritek = 1;
 #endif /* CONFIG_X86 */
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 170f71e..008da66 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -63,6 +63,10 @@ static unsigned int i8042_blink_frequency = 500;
 module_param_named(panicblink, i8042_blink_frequency, uint, 0600);
 MODULE_PARM_DESC(panicblink, "Frequency with which keyboard LEDs should blink when kernel panics");
 
+static unsigned int i8042_notimeout;
+module_param_named(notimeout, i8042_notimeout, bool, 0);
+MODULE_PARM_DESC(notimeout, "Ignore timeouts signalled by i8042");
+
 #ifdef CONFIG_X86
 static unsigned int i8042_dritek;
 module_param_named(dritek, i8042_dritek, bool, 0);
@@ -362,7 +366,7 @@ static irqreturn_t i8042_interrupt(int irq, void *dev_id)
 	} else {
 
 		dfl = ((str & I8042_STR_PARITY) ? SERIO_PARITY : 0) |
-		      ((str & I8042_STR_TIMEOUT) ? SERIO_TIMEOUT : 0);
+		      ((str & I8042_STR_TIMEOUT && !i8042_notimeout) ? SERIO_TIMEOUT : 0);
 
 		port_no = (str & I8042_STR_AUXDATA) ?
 				I8042_AUX_PORT_NO : I8042_KBD_PORT_NO;
diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index 9ce3b3b..4d93576 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -105,7 +105,7 @@ static irqreturn_t input_handler(int rq, void *dev_id)
 static int __devinit xenkbd_probe(struct xenbus_device *dev,
 				  const struct xenbus_device_id *id)
 {
-	int ret, i;
+	int ret, i, abs;
 	struct xenkbd_info *info;
 	struct input_dev *kbd, *ptr;
 
@@ -123,6 +123,11 @@ static int __devinit xenkbd_probe(struct xenbus_device *dev,
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
@@ -132,11 +137,12 @@ static int __devinit xenkbd_probe(struct xenbus_device *dev,
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
@@ -155,12 +161,20 @@ static int __devinit xenkbd_probe(struct xenbus_device *dev,
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
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index 84d75a3..4b9f6b0 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -806,6 +806,16 @@ static void closecard(int cardnr)
 	ll_unload(csta);
 }
 
+static irqreturn_t card_irq(int intno, void *dev_id)
+{
+	struct IsdnCardState *cs = dev_id;
+	irqreturn_t ret = cs->irq_func(intno, cs);
+
+	if (ret == IRQ_HANDLED)
+		cs->irq_cnt++;
+	return ret;
+}
+
 static int init_card(struct IsdnCardState *cs)
 {
 	int 	irq_cnt, cnt = 3, ret;
@@ -814,10 +824,10 @@ static int init_card(struct IsdnCardState *cs)
 		ret = cs->cardmsg(cs, CARD_INIT, NULL);
 		return(ret);
 	}
-	irq_cnt = kstat_irqs(cs->irq);
+	irq_cnt = cs->irq_cnt = 0;
 	printk(KERN_INFO "%s: IRQ %d count %d\n", CardType[cs->typ],
 	       cs->irq, irq_cnt);
-	if (request_irq(cs->irq, cs->irq_func, cs->irq_flags, "HiSax", cs)) {
+	if (request_irq(cs->irq, card_irq, cs->irq_flags, "HiSax", cs)) {
 		printk(KERN_WARNING "HiSax: couldn't get interrupt %d\n",
 		       cs->irq);
 		return 1;
@@ -827,8 +837,8 @@ static int init_card(struct IsdnCardState *cs)
 		/* Timeout 10ms */
 		msleep(10);
 		printk(KERN_INFO "%s: IRQ %d count %d\n",
-		       CardType[cs->typ], cs->irq, kstat_irqs(cs->irq));
-		if (kstat_irqs(cs->irq) == irq_cnt) {
+		       CardType[cs->typ], cs->irq, cs->irq_cnt);
+		if (cs->irq_cnt == irq_cnt) {
 			printk(KERN_WARNING
 			       "%s: IRQ(%d) getting no interrupts during init %d\n",
 			       CardType[cs->typ], cs->irq, 4 - cnt);
diff --git a/drivers/isdn/hisax/hisax.h b/drivers/isdn/hisax/hisax.h
index f1a828b..bbcee6d 100644
--- a/drivers/isdn/hisax/hisax.h
+++ b/drivers/isdn/hisax/hisax.h
@@ -950,6 +950,7 @@ struct IsdnCardState {
 	u_long		event;
 	struct work_struct tqueue;
 	struct timer_list dbusytimer;
+	unsigned int	irq_cnt;
 #ifdef ERROR_STATISTIC
 	int		err_crc;
 	int		err_tx;
diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index 1a2222c..0d01a71 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -2634,12 +2634,6 @@ isdn_tty_modem_result(int code, modem_info * info)
 		if ((info->flags & ISDN_ASYNC_CLOSING) || (!info->tty)) {
 			return;
 		}
-#ifdef CONFIG_ISDN_AUDIO
-		if ( !info->vonline )
-			tty_ldisc_flush(info->tty);
-#else
-		tty_ldisc_flush(info->tty);
-#endif
 		if ((info->flags & ISDN_ASYNC_CHECK_CD) &&
 		    (!((info->flags & ISDN_ASYNC_CALLOUT_ACTIVE) &&
 		       (info->flags & ISDN_ASYNC_CALLOUT_NOHUP)))) {
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 8fe418b..3520607 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1198,7 +1198,7 @@ static void do_writes(struct mirror_set *ms, struct bio_list *writes)
 	/*
 	 * Dispatch io.
 	 */
-	if (unlikely(ms->log_failure)) {
+	if (unlikely(ms->log_failure) && errors_handled(ms)) {
 		spin_lock_irq(&ms->lock);
 		bio_list_merge(&ms->failures, &sync);
 		spin_unlock_irq(&ms->lock);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2c84cc9..d7bb62d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -241,6 +241,9 @@ static mddev_t * mddev_find(dev_t unit)
 {
 	mddev_t *mddev, *new = NULL;
 
+	if (unit && MAJOR(unit) != MD_MAJOR)
+		unit &= ~((1<<MdpMinorShift)-1);
+
  retry:
 	spin_lock(&all_mddevs_lock);
 	list_for_each_entry(mddev, &all_mddevs, all_mddevs)
@@ -4303,9 +4306,10 @@ static int add_new_disk(mddev_t * mddev, mdu_disk_info_t *info)
 		/* set saved_raid_disk if appropriate */
 		if (!mddev->persistent) {
 			if (info->state & (1<<MD_DISK_SYNC)  &&
-			    info->raid_disk < mddev->raid_disks)
+			    info->raid_disk < mddev->raid_disks) {
 				rdev->raid_disk = info->raid_disk;
-			else
+				set_bit(In_sync, &rdev->flags);
+			} else
 				rdev->raid_disk = -1;
 		} else
 			super_types[mddev->major_version].
diff --git a/drivers/media/dvb/ttpci/av7110_ca.c b/drivers/media/dvb/ttpci/av7110_ca.c
index 261135d..2dcd6c1 100644
--- a/drivers/media/dvb/ttpci/av7110_ca.c
+++ b/drivers/media/dvb/ttpci/av7110_ca.c
@@ -277,7 +277,7 @@ static int dvb_ca_ioctl(struct inode *inode, struct file *file,
 	{
 		ca_slot_info_t *info=(ca_slot_info_t *)parg;
 
-		if (info->num > 1)
+		if (info->num < 0 || info->num > 1)
 			return -EINVAL;
 		av7110->ci_slot[info->num].num = info->num;
 		av7110->ci_slot[info->num].type = FW_CI_LL_SUPPORT(av7110->arm_app) ?
diff --git a/drivers/media/radio/radio-aimslab.c b/drivers/media/radio/radio-aimslab.c
index 1f064f4..f068f9b 100644
--- a/drivers/media/radio/radio-aimslab.c
+++ b/drivers/media/radio/radio-aimslab.c
@@ -31,9 +31,9 @@
 #include <linux/module.h>	/* Modules 			*/
 #include <linux/init.h>		/* Initdata			*/
 #include <linux/ioport.h>	/* request_region		*/
-#include <linux/delay.h>	/* udelay			*/
 #include <asm/io.h>		/* outb, outb_p			*/
 #include <asm/uaccess.h>	/* copy to/from user		*/
+#include <linux/delay.h>	/* msleep			*/
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
@@ -60,27 +60,17 @@ struct rt_device
 
 /* local things */
 
-static void sleep_delay(long n)
-{
-	/* Sleep nicely for 'n' uS */
-	int d=n/msecs_to_jiffies(1000);
-	if(!d)
-		udelay(n);
-	else
-		msleep(jiffies_to_msecs(d));
-}
-
 static void rt_decvol(void)
 {
 	outb(0x58, io);		/* volume down + sigstr + on	*/
-	sleep_delay(100000);
+	msleep(100);
 	outb(0xd8, io);		/* volume steady + sigstr + on	*/
 }
 
 static void rt_incvol(void)
 {
 	outb(0x98, io);		/* volume up + sigstr + on	*/
-	sleep_delay(100000);
+	msleep(100);
 	outb(0xd8, io);		/* volume steady + sigstr + on	*/
 }
 
@@ -109,7 +99,7 @@ static int rt_setvol(struct rt_device *dev, int vol)
 
 	if(vol == 0) {			/* volume = 0 means mute the card */
 		outb(0x48, io);		/* volume down but still "on"	*/
-		sleep_delay(2000000);	/* make sure it's totally down	*/
+		msleep(2000);		/* make sure it's totally down	*/
 		outb(0xd0, io);		/* volume steady, off		*/
 		dev->curvol = 0;	/* track the volume state!	*/
 		mutex_unlock(&lock);
@@ -144,7 +134,7 @@ static void send_0_byte(int port, struct rt_device *dev)
 		outb_p(128+64+16+8+  1, port);  /* on + wr-enable + data low */
 		outb_p(128+64+16+8+2+1, port);  /* clock */
 	}
-	sleep_delay(1000);
+	msleep(1);
 }
 
 static void send_1_byte(int port, struct rt_device *dev)
@@ -158,7 +148,7 @@ static void send_1_byte(int port, struct rt_device *dev)
 		outb_p(128+64+16+8+4+2+1, port); /* clock */
 	}
 
-	sleep_delay(1000);
+	msleep(1);
 }
 
 static int rt_setfreq(struct rt_device *dev, unsigned long freq)
@@ -440,7 +430,7 @@ static int __init rtrack_init(void)
 
 	/* this ensures that the volume is all the way down  */
 	outb(0x48, io);		/* volume down but still "on"	*/
-	sleep_delay(2000000);	/* make sure it's totally down	*/
+	msleep(2000);		/* make sure it's totally down	*/
 	outb(0xc0, io);		/* steady volume, mute card	*/
 	rtrack_unit.curvol = 0;
 
diff --git a/drivers/media/video/sn9c102/sn9c102_core.c b/drivers/media/video/sn9c102/sn9c102_core.c
index 2da6938..d776370 100644
--- a/drivers/media/video/sn9c102/sn9c102_core.c
+++ b/drivers/media/video/sn9c102/sn9c102_core.c
@@ -1410,9 +1410,9 @@ static DEVICE_ATTR(i2c_reg, S_IRUGO | S_IWUSR,
 		   sn9c102_show_i2c_reg, sn9c102_store_i2c_reg);
 static DEVICE_ATTR(i2c_val, S_IRUGO | S_IWUSR,
 		   sn9c102_show_i2c_val, sn9c102_store_i2c_val);
-static DEVICE_ATTR(green, S_IWUGO, NULL, sn9c102_store_green);
-static DEVICE_ATTR(blue, S_IWUGO, NULL, sn9c102_store_blue);
-static DEVICE_ATTR(red, S_IWUGO, NULL, sn9c102_store_red);
+static DEVICE_ATTR(green, S_IWUSR, NULL, sn9c102_store_green);
+static DEVICE_ATTR(blue, S_IWUSR, NULL, sn9c102_store_blue);
+static DEVICE_ATTR(red, S_IWUSR, NULL, sn9c102_store_red);
 static DEVICE_ATTR(frame_header, S_IRUGO, sn9c102_show_frame_header, NULL);
 
 
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 9f9354f..3e8c538 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2469,6 +2469,8 @@ mptscsih_slave_configure(struct scsi_device *sdev)
 		ioc->name,sdev->tagged_supported, sdev->simple_tags,
 		sdev->ordered_tags));
 
+	blk_queue_dma_alignment (sdev->request_queue, 512 - 1);
+
 	return 0;
 }
 
diff --git a/drivers/mfd/ucb1x00-ts.c b/drivers/mfd/ucb1x00-ts.c
index 44762ca..477eacb 100644
--- a/drivers/mfd/ucb1x00-ts.c
+++ b/drivers/mfd/ucb1x00-ts.c
@@ -385,12 +385,18 @@ static int ucb1x00_ts_add(struct ucb1x00_dev *dev)
 	idev->close      = ucb1x00_ts_close;
 
 	__set_bit(EV_ABS, idev->evbit);
-	__set_bit(ABS_X, idev->absbit);
-	__set_bit(ABS_Y, idev->absbit);
-	__set_bit(ABS_PRESSURE, idev->absbit);
 
 	input_set_drvdata(idev, ts);
 
+	ucb1x00_adc_enable(ts->ucb);
+	ts->x_res = ucb1x00_ts_read_xres(ts);
+	ts->y_res = ucb1x00_ts_read_yres(ts);
+	ucb1x00_adc_disable(ts->ucb);
+
+	input_set_abs_params(idev, ABS_X, 0, ts->x_res, 0, 0);
+	input_set_abs_params(idev, ABS_Y, 0, ts->y_res, 0, 0);
+	input_set_abs_params(idev, ABS_PRESSURE, 0, 0, 0, 0);
+
 	err = input_register_device(idev);
 	if (err)
 		goto fail;
diff --git a/drivers/misc/acer-wmi.c b/drivers/misc/acer-wmi.c
index d8b0d32..aca21f7 100644
--- a/drivers/misc/acer-wmi.c
+++ b/drivers/misc/acer-wmi.c
@@ -957,7 +957,7 @@ set_bool_##value(struct device *dev, struct device_attribute *attr, \
 			return -EINVAL; \
 	return count; \
 } \
-static DEVICE_ATTR(value, S_IWUGO | S_IRUGO | S_IWUSR, \
+static DEVICE_ATTR(value, S_IRUGO | S_IWUSR, \
 	show_bool_##value, set_bool_##value);
 
 show_set_bool(wireless, ACER_CAP_WIRELESS);
@@ -982,7 +982,7 @@ static ssize_t show_interface(struct device *dev, struct device_attribute *attr,
 	}
 }
 
-static DEVICE_ATTR(interface, S_IWUGO | S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(interface, S_IRUGO | S_IWUSR,
 	show_interface, NULL);
 
 /*
diff --git a/drivers/misc/tc1100-wmi.c b/drivers/misc/tc1100-wmi.c
index f25e4c9..84733f3 100644
--- a/drivers/misc/tc1100-wmi.c
+++ b/drivers/misc/tc1100-wmi.c
@@ -179,7 +179,7 @@ set_bool_##value(struct device *dev, struct device_attribute *attr, \
 			return -EINVAL; \
 	return count; \
 } \
-static DEVICE_ATTR(value, S_IWUGO | S_IRUGO | S_IWUSR, \
+static DEVICE_ATTR(value, S_IRUGO | S_IWUSR, \
 	show_bool_##value, set_bool_##value);
 
 show_set_bool(wireless, TC1100_INSTANCE_WIRELESS);
diff --git a/drivers/net/myri10ge/myri10ge.c b/drivers/net/myri10ge/myri10ge.c
index 7d41ec8..91216a5 100644
--- a/drivers/net/myri10ge/myri10ge.c
+++ b/drivers/net/myri10ge/myri10ge.c
@@ -3480,6 +3480,7 @@ static void myri10ge_free_slices(struct myri10ge_priv *mgp)
 			dma_free_coherent(&pdev->dev, bytes,
 					  ss->fw_stats, ss->fw_stats_bus);
 			ss->fw_stats = NULL;
+			netif_napi_del(&ss->napi);
 		}
 	}
 	kfree(mgp->ss);
diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 68bba7f..7bb5e55 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -23,6 +23,7 @@
 #include <linux/tcp.h>
 #include <linux/init.h>
 #include <linux/dma-mapping.h>
+#include <linux/pci-aspm.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -1618,6 +1619,11 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	mii->reg_num_mask = 0x1f;
 	mii->supports_gmii = !!(cfg->features & RTL_FEATURE_GMII);
 
+	/* disable ASPM completely as that cause random device stop working
+	 * problems as well as full system hangs for some PCIe devices users */
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
+				     PCIE_LINK_STATE_CLKPM);
+
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
 	rc = pci_enable_device(pdev);
 	if (rc < 0) {
diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index 055e991..598d1a6 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -689,12 +689,6 @@ static int prism2_config(struct pcmcia_device *link)
 	link->dev_node = &hw_priv->node;
 
 	/*
-	 * Make sure the IRQ handler cannot proceed until at least
-	 * dev->base_addr is initialized.
-	 */
-	spin_lock_irqsave(&local->irq_init_lock, flags);
-
-	/*
 	 * Allocate an interrupt line.  Note that this does not assign a
 	 * handler to the interrupt, unless the 'Handler' member of the
 	 * irq structure is initialized.
@@ -716,9 +710,10 @@ static int prism2_config(struct pcmcia_device *link)
 	CS_CHECK(RequestConfiguration,
 		 pcmcia_request_configuration(link, &link->conf));
 
+	/* IRQ handler cannot proceed until at dev->base_addr is initialized */
+	spin_lock_irqsave(&local->irq_init_lock, flags);
 	dev->irq = link->irq.AssignedIRQ;
 	dev->base_addr = link->io.BasePort1;
-
 	spin_unlock_irqrestore(&local->irq_init_lock, flags);
 
 	/* Finally, report what we've done */
@@ -751,7 +746,6 @@ static int prism2_config(struct pcmcia_device *link)
 	return ret;
 
  cs_failed:
-	spin_unlock_irqrestore(&local->irq_init_lock, flags);
 	cs_error(link, last_fn, last_ret);
 
  failed:
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 45bf8f7..590bcfb 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2122,6 +2122,7 @@ static struct usb_device_id rt73usb_device_table[] = {
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2671), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x0812, 0x3101), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Qcom */
 	{ USB_DEVICE(0x18e8, 0x6196), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x18e8, 0x6229), USB_DEVICE_DATA(&rt73usb_ops) },
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e09684e..53345e7 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -420,6 +420,17 @@ static void __devinit quirk_piix4_acpi(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82371AB_3,	quirk_piix4_acpi);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82443MX_3,	quirk_piix4_acpi);
 
+#define ICH_PMBASE	0x40
+#define ICH_ACPI_CNTL	0x44
+#define  ICH4_ACPI_EN	0x10
+#define  ICH6_ACPI_EN	0x80
+#define ICH4_GPIOBASE	0x58
+#define ICH4_GPIO_CNTL	0x5c
+#define  ICH4_GPIO_EN	0x10
+#define ICH6_GPIOBASE	0x48
+#define ICH6_GPIO_CNTL	0x4c
+#define  ICH6_GPIO_EN	0x10
+
 /*
  * ICH4, ICH4-M, ICH5, ICH5-M ACPI: Three IO regions pointed to by longwords at
  *	0x40 (128 bytes of ACPI, GPIO & TCO registers)
@@ -428,12 +439,33 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82443MX_3,	qui
 static void __devinit quirk_ich4_lpc_acpi(struct pci_dev *dev)
 {
 	u32 region;
+	u8 enable;
 
-	pci_read_config_dword(dev, 0x40, &region);
-	quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES, "ICH4 ACPI/GPIO/TCO");
+	/*
+	 * The check for PCIBIOS_MIN_IO is to ensure we won't create a conflict
+	 * with low legacy (and fixed) ports. We don't know the decoding
+	 * priority and can't tell whether the legacy device or the one created
+	 * here is really at that address.  This happens on boards with broken
+	 * BIOSes.
+	*/
+
+	pci_read_config_byte(dev, ICH_ACPI_CNTL, &enable);
+	if (enable & ICH4_ACPI_EN) {
+		pci_read_config_dword(dev, ICH_PMBASE, &region);
+		region &= PCI_BASE_ADDRESS_IO_MASK;
+		if (region >= PCIBIOS_MIN_IO)
+			quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES,
+					"ICH4 ACPI/GPIO/TCO");
+	}
 
-	pci_read_config_dword(dev, 0x58, &region);
-	quirk_io_region(dev, region, 64, PCI_BRIDGE_RESOURCES+1, "ICH4 GPIO");
+	pci_read_config_byte(dev, ICH4_GPIO_CNTL, &enable);
+	if (enable & ICH4_GPIO_EN) {
+		pci_read_config_dword(dev, ICH4_GPIOBASE, &region);
+		region &= PCI_BASE_ADDRESS_IO_MASK;
+		if (region >= PCIBIOS_MIN_IO)
+			quirk_io_region(dev, region, 64,
+					PCI_BRIDGE_RESOURCES + 1, "ICH4 GPIO");
+	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_82801AA_0,		quirk_ich4_lpc_acpi);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_82801AB_0,		quirk_ich4_lpc_acpi);
@@ -449,12 +481,25 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_ESB_1,		qui
 static void __devinit quirk_ich6_lpc_acpi(struct pci_dev *dev)
 {
 	u32 region;
+	u8 enable;
 
-	pci_read_config_dword(dev, 0x40, &region);
-	quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES, "ICH6 ACPI/GPIO/TCO");
+	pci_read_config_byte(dev, ICH_ACPI_CNTL, &enable);
+	if (enable & ICH6_ACPI_EN) {
+		pci_read_config_dword(dev, ICH_PMBASE, &region);
+		region &= PCI_BASE_ADDRESS_IO_MASK;
+		if (region >= PCIBIOS_MIN_IO)
+			quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES,
+					"ICH6 ACPI/GPIO/TCO");
+	}
 
-	pci_read_config_dword(dev, 0x48, &region);
-	quirk_io_region(dev, region, 64, PCI_BRIDGE_RESOURCES+1, "ICH6 GPIO");
+	pci_read_config_byte(dev, ICH6_GPIO_CNTL, &enable);
+	if (enable & ICH4_GPIO_EN) {
+		pci_read_config_dword(dev, ICH6_GPIOBASE, &region);
+		region &= PCI_BASE_ADDRESS_IO_MASK;
+		if (region >= PCIBIOS_MIN_IO)
+			quirk_io_region(dev, region, 64,
+					PCI_BRIDGE_RESOURCES + 1, "ICH6 GPIO");
+	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH6_0, quirk_ich6_lpc_acpi);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH6_1, quirk_ich6_lpc_acpi);
diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
index 0f0d27d..9a768e3 100644
--- a/drivers/rtc/rtc-ds1511.c
+++ b/drivers/rtc/rtc-ds1511.c
@@ -493,7 +493,7 @@ ds1511_nvram_write(struct kobject *kobj, struct bin_attribute *bin_attr,
 static struct bin_attribute ds1511_nvram_attr = {
 	.attr = {
 		.name = "nvram",
-		.mode = S_IRUGO | S_IWUGO,
+		.mode = S_IRUGO | S_IWUSR,
 		.owner = THIS_MODULE,
 	},
 	.size = DS1511_RAM_MAX,
diff --git a/drivers/s390/char/keyboard.c b/drivers/s390/char/keyboard.c
index cee4d4e..1160fca 100644
--- a/drivers/s390/char/keyboard.c
+++ b/drivers/s390/char/keyboard.c
@@ -462,7 +462,8 @@ kbd_ioctl(struct kbd_data *kbd, struct file *file,
 	  unsigned int cmd, unsigned long arg)
 {
 	void __user *argp;
-	int ct, perm;
+	unsigned int ct;
+	int perm;
 
 	argp = (void __user *)arg;
 
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index a8e3ef3..c8508ca 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -648,6 +648,7 @@ void sas_scsi_recover_host(struct Scsi_Host *shost)
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_splice_init(&shost->eh_cmd_q, &eh_work_q);
+	shost->host_eh_scheduled = 0;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	SAS_DPRINTK("Enter %s\n", __func__);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0353e8bf..00751a1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -971,6 +971,12 @@ static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
 	u64 end_lba = scmd->request->sector + (scsi_bufflen(scmd) / 512);
 	u64 bad_lba;
 	int info_valid;
+	/*
+	 * resid is optional but mostly filled in.  When it's unused,
+	 * its value is zero, so we assume the whole buffer transferred
+	 */
+	unsigned int transferred = scsi_bufflen(scmd) - scsi_get_resid(scmd);
+	unsigned int good_bytes;
 
 	if (!blk_fs_request(scmd->request))
 		return 0;
@@ -1004,7 +1010,8 @@ static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
 	/* This computation should always be done in terms of
 	 * the resolution of the device's medium.
 	 */
-	return (bad_lba - start_lba) * scmd->device->sector_size;
+	good_bytes = (bad_lba - start_lba) * scmd->device->sector_size;
+	return min(good_bytes, transferred);
 }
 
 /**
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 1bcf3c3..86ee979 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -558,9 +558,9 @@ static int ses_intf_add(struct device *cdev,
 		len = (desc_ptr[2] << 8) + desc_ptr[3];
 		/* skip past overall descriptor */
 		desc_ptr += len + 4;
-		if (ses_dev->page10)
-			addl_desc_ptr = ses_dev->page10 + 8;
 	}
+	if (ses_dev->page10)
+		addl_desc_ptr = ses_dev->page10 + 8;
 	type_ptr = ses_dev->page1 + 12 + ses_dev->page1[11];
 	components = 0;
 	for (i = 0; i < types; i++, type_ptr += 4) {
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index f84f068..acb0ab4 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -237,7 +237,8 @@ static const struct serial8250_config uart_config[] = {
 		.fifo_size	= 128,
 		.tx_loadsz	= 128,
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
-		.flags		= UART_CAP_FIFO | UART_CAP_EFR | UART_CAP_SLEEP,
+		/* UART_CAP_EFR breaks billionon CF bluetooth card. */
+		.flags		= UART_CAP_FIFO | UART_CAP_SLEEP,
 	},
 	[PORT_RSA] = {
 		.name		= "RSA",
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index a250cae..ee80c5d 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -285,6 +285,8 @@ static void acm_ctrl_irq(struct urb *urb)
 	if (!ACM_READY(acm))
 		goto exit;
 
+	usb_mark_last_busy(acm->dev);
+
 	data = (unsigned char *)(dr + 1);
 	switch (dr->bNotificationType) {
 
@@ -319,7 +321,6 @@ static void acm_ctrl_irq(struct urb *urb)
 			break;
 	}
 exit:
-	usb_mark_last_busy(acm->dev);
 	retval = usb_submit_urb (urb, GFP_ATOMIC);
 	if (retval)
 		err ("%s - usb_submit_urb failed with result %d",
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 3240519..9cd7311 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2430,6 +2430,11 @@ hub_port_init (struct usb_hub *hub, struct usb_device *udev, int port1,
 		udev->ttport = hdev->ttport;
 	} else if (udev->speed != USB_SPEED_HIGH
 			&& hdev->speed == USB_SPEED_HIGH) {
+		if (!hub->tt.hub) {
+			dev_err(&udev->dev, "parent hub has no TT\n");
+			retval = -EINVAL;
+			goto fail;
+		}
 		udev->tt = &hub->tt;
 		udev->ttport = port1;
 	}
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index e009008..8df9292 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -116,31 +116,31 @@ static struct printer_dev usb_printer_gadget;
  * parameters are in UTF-8 (superset of ASCII's 7 bit characters).
  */
 
-static ushort __initdata idVendor;
+static ushort idVendor;
 module_param(idVendor, ushort, S_IRUGO);
 MODULE_PARM_DESC(idVendor, "USB Vendor ID");
 
-static ushort __initdata idProduct;
+static ushort idProduct;
 module_param(idProduct, ushort, S_IRUGO);
 MODULE_PARM_DESC(idProduct, "USB Product ID");
 
-static ushort __initdata bcdDevice;
+static ushort bcdDevice;
 module_param(bcdDevice, ushort, S_IRUGO);
 MODULE_PARM_DESC(bcdDevice, "USB Device version (BCD)");
 
-static char *__initdata iManufacturer;
+static char *iManufacturer;
 module_param(iManufacturer, charp, S_IRUGO);
 MODULE_PARM_DESC(iManufacturer, "USB Manufacturer string");
 
-static char *__initdata iProduct;
+static char *iProduct;
 module_param(iProduct, charp, S_IRUGO);
 MODULE_PARM_DESC(iProduct, "USB Product string");
 
-static char *__initdata iSerialNum;
+static char *iSerialNum;
 module_param(iSerialNum, charp, S_IRUGO);
 MODULE_PARM_DESC(iSerialNum, "1");
 
-static char *__initdata iPNPstring;
+static char *iPNPstring;
 module_param(iPNPstring, charp, S_IRUGO);
 MODULE_PARM_DESC(iPNPstring, "MFG:linux;MDL:g_printer;CLS:PRINTER;SN:1;");
 
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index b1690ba..35edf02 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -103,6 +103,9 @@ MODULE_PARM_DESC (ignore_oc, "ignore bogus hardware overcurrent indications");
 
 #define	INTR_MASK (STS_IAA | STS_FATAL | STS_PCD | STS_ERR | STS_INT)
 
+/* for ASPM quirk of ISOC on AMD SB800 */
+static struct pci_dev *amd_nb_dev;
+
 /*-------------------------------------------------------------------------*/
 
 #include "ehci.h"
@@ -450,6 +453,11 @@ static void ehci_stop (struct usb_hcd *hcd)
 	spin_unlock_irq (&ehci->lock);
 	ehci_mem_cleanup (ehci);
 
+	if (amd_nb_dev) {
+		pci_dev_put(amd_nb_dev);
+		amd_nb_dev = NULL;
+	}
+
 #ifdef	EHCI_STATS
 	ehci_dbg (ehci, "irq normal %ld err %ld reclaim %ld (lost %ld)\n",
 		ehci->stats.normal, ehci->stats.error, ehci->stats.reclaim,
@@ -480,17 +488,29 @@ static int ehci_init(struct usb_hcd *hcd)
 	ehci->iaa_watchdog.function = ehci_iaa_watchdog;
 	ehci->iaa_watchdog.data = (unsigned long) ehci;
 
+	hcc_params = ehci_readl(ehci, &ehci->caps->hcc_params);
+
 	/*
 	 * hw default: 1K periodic list heads, one per frame.
 	 * periodic_size can shrink by USBCMD update if hcc_params allows.
 	 */
 	ehci->periodic_size = DEFAULT_I_TDPS;
 	INIT_LIST_HEAD(&ehci->cached_itd_list);
+
+	if (HCC_PGM_FRAMELISTLEN(hcc_params)) {
+		/* periodic schedule size can be smaller than default */
+		switch (EHCI_TUNE_FLS) {
+		case 0: ehci->periodic_size = 1024; break;
+		case 1: ehci->periodic_size = 512; break;
+		case 2: ehci->periodic_size = 256; break;
+		default:        BUG();
+		}
+	}
+
 	if ((retval = ehci_mem_init(ehci, GFP_KERNEL)) < 0)
 		return retval;
 
 	/* controllers may cache some of the periodic schedule ... */
-	hcc_params = ehci_readl(ehci, &ehci->caps->hcc_params);
 	if (HCC_ISOC_CACHE(hcc_params))		// full frame cache
 		ehci->i_thresh = 8;
 	else					// N microframes cached
@@ -538,12 +558,6 @@ static int ehci_init(struct usb_hcd *hcd)
 		/* periodic schedule size can be smaller than default */
 		temp &= ~(3 << 2);
 		temp |= (EHCI_TUNE_FLS << 2);
-		switch (EHCI_TUNE_FLS) {
-		case 0: ehci->periodic_size = 1024; break;
-		case 1: ehci->periodic_size = 512; break;
-		case 2: ehci->periodic_size = 256; break;
-		default:	BUG();
-		}
 	}
 	ehci->command = temp;
 
diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index 36864f9..a732471 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -61,6 +61,42 @@ static int ehci_pci_reinit(struct ehci_hcd *ehci, struct pci_dev *pdev)
 	return 0;
 }
 
+static int ehci_quirk_amd_hudson(struct ehci_hcd *ehci)
+{
+	struct pci_dev *amd_smbus_dev;
+	u8 rev = 0;
+
+	amd_smbus_dev = pci_get_device(PCI_VENDOR_ID_ATI, 0x4385, NULL);
+	if (amd_smbus_dev) {
+		pci_read_config_byte(amd_smbus_dev, PCI_REVISION_ID, &rev);
+		if (rev < 0x40) {
+			pci_dev_put(amd_smbus_dev);
+			amd_smbus_dev = NULL;
+			return 0;
+		}
+	} else {
+		amd_smbus_dev = pci_get_device(PCI_VENDOR_ID_AMD, 0x780b, NULL);
+		if (!amd_smbus_dev)
+			return 0;
+		pci_read_config_byte(amd_smbus_dev, PCI_REVISION_ID, &rev);
+		if (rev < 0x11 || rev > 0x18) {
+			pci_dev_put(amd_smbus_dev);
+			amd_smbus_dev = NULL;
+			return 0;
+		}
+	}
+
+	if (!amd_nb_dev)
+		amd_nb_dev = pci_get_device(PCI_VENDOR_ID_AMD, 0x1510, NULL);
+
+	ehci_info(ehci, "QUIRK: Enable exception for AMD Hudson ASPM\n");
+
+	pci_dev_put(amd_smbus_dev);
+	amd_smbus_dev = NULL;
+
+	return 1;
+}
+
 /* called during probe() after chip reset completes */
 static int ehci_pci_setup(struct usb_hcd *hcd)
 {
@@ -119,6 +155,9 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
 	/* cache this readonly data; minimize chip reads */
 	ehci->hcs_params = ehci_readl(ehci, &ehci->caps->hcs_params);
 
+	if (ehci_quirk_amd_hudson(ehci))
+		ehci->amd_l1_fix = 1;
+
 	retval = ehci_halt(ehci);
 	if (retval)
 		return retval;
diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index da88a80..753f882 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -285,7 +285,6 @@ qh_completions (struct ehci_hcd *ehci, struct ehci_qh *qh)
 	int			stopped;
 	unsigned		count = 0;
 	u8			state;
-	__le32			halt = HALT_BIT(ehci);
 
 	if (unlikely (list_empty (&qh->qtd_list)))
 		return count;
@@ -381,7 +380,6 @@ qh_completions (struct ehci_hcd *ehci, struct ehci_qh *qh)
 					&& !(qtd->hw_alt_next
 						& EHCI_LIST_END(ehci))) {
 				stopped = 1;
-				goto halt;
 			}
 
 		/* stop scanning when we reach qtds the hc is using */
@@ -408,16 +406,6 @@ qh_completions (struct ehci_hcd *ehci, struct ehci_qh *qh)
 					&& cpu_to_hc32(ehci, qtd->qtd_dma)
 						== qh->hw_current)
 				token = hc32_to_cpu(ehci, qh->hw_token);
-
-			/* force halt for unlinked or blocked qh, so we'll
-			 * patch the qh later and so that completions can't
-			 * activate it while we "know" it's stopped.
-			 */
-			if ((halt & qh->hw_token) == 0) {
-halt:
-				qh->hw_token |= halt;
-				wmb ();
-			}
 		}
 
 		/* unless we already know the urb's status, collect qtd status
@@ -1150,24 +1138,27 @@ static void start_unlink_async (struct ehci_hcd *ehci, struct ehci_qh *qh)
 
 static void scan_async (struct ehci_hcd *ehci)
 {
+	bool			stopped;
 	struct ehci_qh		*qh;
 	enum ehci_timer_action	action = TIMER_IO_WATCHDOG;
 
 	ehci->stamp = ehci_readl(ehci, &ehci->regs->frame_index);
 	timer_action_done (ehci, TIMER_ASYNC_SHRINK);
 rescan:
+	stopped = !HC_IS_RUNNING(ehci_to_hcd(ehci)->state);
 	qh = ehci->async->qh_next.qh;
 	if (likely (qh != NULL)) {
 		do {
 			/* clean any finished work for this qh */
-			if (!list_empty (&qh->qtd_list)
-					&& qh->stamp != ehci->stamp) {
+			if (!list_empty(&qh->qtd_list) && (stopped ||
+					qh->stamp != ehci->stamp)) {
 				int temp;
 
 				/* unlinks could happen here; completion
 				 * reporting drops the lock.  rescan using
 				 * the latest schedule, but don't rescan
-				 * qhs we already finished (no looping).
+				 * qhs we already finished (no looping)
+				 * unless the controller is stopped.
 				 */
 				qh = qh_get (qh);
 				qh->stamp = ehci->stamp;
@@ -1186,9 +1177,9 @@ rescan:
 			 */
 			if (list_empty(&qh->qtd_list)
 					&& qh->qh_state == QH_STATE_LINKED) {
-				if (!ehci->reclaim
-					&& ((ehci->stamp - qh->stamp) & 0x1fff)
-						>= (EHCI_SHRINK_FRAMES * 8))
+				if (!ehci->reclaim && (stopped ||
+					((ehci->stamp - qh->stamp) & 0x1fff)
+						>= EHCI_SHRINK_FRAMES * 8))
 					start_unlink_async(ehci, qh);
 				else
 					action = TIMER_ASYNC_SHRINK;
diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index e813ca8..9b799eb 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1496,6 +1496,63 @@ itd_link (struct ehci_hcd *ehci, unsigned frame, struct ehci_itd *itd)
 	ehci->periodic[frame] = cpu_to_hc32(ehci, itd->itd_dma | Q_TYPE_ITD);
 }
 
+#define AB_REG_BAR_LOW 0xe0
+#define AB_REG_BAR_HIGH 0xe1
+#define AB_INDX(addr) ((addr) + 0x00)
+#define AB_DATA(addr) ((addr) + 0x04)
+#define NB_PCIE_INDX_ADDR 0xe0
+#define NB_PCIE_INDX_DATA 0xe4
+#define NB_PIF0_PWRDOWN_0 0x01100012
+#define NB_PIF0_PWRDOWN_1 0x01100013
+
+static void ehci_quirk_amd_L1(struct ehci_hcd *ehci, int disable)
+{
+	u32 addr, addr_low, addr_high, val;
+
+	outb_p(AB_REG_BAR_LOW, 0xcd6);
+	addr_low = inb_p(0xcd7);
+	outb_p(AB_REG_BAR_HIGH, 0xcd6);
+	addr_high = inb_p(0xcd7);
+	addr = addr_high << 8 | addr_low;
+	outl_p(0x30, AB_INDX(addr));
+	outl_p(0x40, AB_DATA(addr));
+	outl_p(0x34, AB_INDX(addr));
+	val = inl_p(AB_DATA(addr));
+
+	if (disable) {
+		val &= ~0x8;
+		val |= (1 << 4) | (1 << 9);
+	} else {
+		val |= 0x8;
+		val &= ~((1 << 4) | (1 << 9));
+	}
+	outl_p(val, AB_DATA(addr));
+
+	if (amd_nb_dev) {
+		addr = NB_PIF0_PWRDOWN_0;
+		pci_write_config_dword(amd_nb_dev, NB_PCIE_INDX_ADDR, addr);
+		pci_read_config_dword(amd_nb_dev, NB_PCIE_INDX_DATA, &val);
+		if (disable)
+			val &= ~(0x3f << 7);
+		else
+			val |= 0x3f << 7;
+
+		pci_write_config_dword(amd_nb_dev, NB_PCIE_INDX_DATA, val);
+
+		addr = NB_PIF0_PWRDOWN_1;
+		pci_write_config_dword(amd_nb_dev, NB_PCIE_INDX_ADDR, addr);
+		pci_read_config_dword(amd_nb_dev, NB_PCIE_INDX_DATA, &val);
+		if (disable)
+			val &= ~(0x3f << 7);
+		else
+			val |= 0x3f << 7;
+
+		pci_write_config_dword(amd_nb_dev, NB_PCIE_INDX_DATA, val);
+	}
+
+	return;
+}
+
 /* fit urb's itds into the selected schedule slot; activate as needed */
 static int
 itd_link_urb (
@@ -1523,6 +1580,12 @@ itd_link_urb (
 			next_uframe >> 3, next_uframe & 0x7);
 		stream->start = jiffies;
 	}
+
+	if (ehci_to_hcd(ehci)->self.bandwidth_isoc_reqs == 0) {
+		if (ehci->amd_l1_fix == 1)
+			ehci_quirk_amd_L1(ehci, 1);
+	}
+
 	ehci_to_hcd(ehci)->self.bandwidth_isoc_reqs++;
 
 	/* fill iTDs uframe by uframe */
@@ -1649,6 +1712,11 @@ itd_complete (
 	(void) disable_periodic(ehci);
 	ehci_to_hcd(ehci)->self.bandwidth_isoc_reqs--;
 
+	if (ehci_to_hcd(ehci)->self.bandwidth_isoc_reqs == 0) {
+		if (ehci->amd_l1_fix == 1)
+			ehci_quirk_amd_L1(ehci, 0);
+	}
+
 	if (unlikely(list_is_singular(&stream->td_list))) {
 		ehci_to_hcd(ehci)->self.bandwidth_allocated
 				-= stream->bandwidth;
@@ -1936,6 +2004,12 @@ sitd_link_urb (
 			stream->interval, hc32_to_cpu(ehci, stream->splits));
 		stream->start = jiffies;
 	}
+
+	if (ehci_to_hcd(ehci)->self.bandwidth_isoc_reqs == 0) {
+		if (ehci->amd_l1_fix == 1)
+			ehci_quirk_amd_L1(ehci, 1);
+	}
+
 	ehci_to_hcd(ehci)->self.bandwidth_isoc_reqs++;
 
 	/* fill sITDs frame by frame */
@@ -2038,6 +2112,11 @@ sitd_complete (
 	(void) disable_periodic(ehci);
 	ehci_to_hcd(ehci)->self.bandwidth_isoc_reqs--;
 
+	if (ehci_to_hcd(ehci)->self.bandwidth_isoc_reqs == 0) {
+		if (ehci->amd_l1_fix == 1)
+			ehci_quirk_amd_L1(ehci, 0);
+	}
+
 	if (list_is_singular(&stream->td_list)) {
 		ehci_to_hcd(ehci)->self.bandwidth_allocated
 				-= stream->bandwidth;
diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index c165fe4..0d342d1 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -122,6 +122,7 @@ struct ehci_hcd {			/* one per controller */
 	unsigned		has_fsl_port_bug:1; /* FreeScale */
 	unsigned		big_endian_mmio:1;
 	unsigned		big_endian_desc:1;
+	unsigned		amd_l1_fix:1;
 
 	u8			sbrn;		/* packed release number */
 
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 2f75bb0..82eee65 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -372,7 +372,7 @@ static ssize_t iowarrior_write(struct file *file,
 	case USB_DEVICE_ID_CODEMERCS_IOWPV2:
 	case USB_DEVICE_ID_CODEMERCS_IOW40:
 		/* IOW24 and IOW40 use a synchronous call */
-		buf = kmalloc(8, GFP_KERNEL);	/* 8 bytes are enough for both products */
+		buf = kmalloc(count, GFP_KERNEL);
 		if (!buf) {
 			retval = -ENOMEM;
 			goto exit;
diff --git a/drivers/usb/misc/uss720.c b/drivers/usb/misc/uss720.c
index e225a95..f4fce0b 100644
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
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 9d2dcb1..ecfcd17 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -312,6 +312,7 @@ static int musb_platform_resume(struct musb *musb)
 
 int musb_platform_exit(struct musb *musb)
 {
+	del_timer_sync(&musb_idle_timer);
 
 	omap_vbus_power(musb, 0 /*off*/, 1);
 
diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index f61e3ca..7234b93 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -29,6 +29,7 @@ static int debug;
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x4348, 0x5523) },
 	{ USB_DEVICE(0x1a86, 0x7523) },
+	{ USB_DEVICE(0x1a86, 0x5523) },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);
diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index 167c2f1..e108625 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -2924,8 +2924,8 @@ static void load_application_firmware(struct edgeport_serial *edge_serial)
 
 	dbg("%s %d.%d.%d", fw_info, rec->data[0], rec->data[1], build);
 
-	edge_serial->product_info.FirmwareMajorVersion = fw->data[0];
-	edge_serial->product_info.FirmwareMinorVersion = fw->data[1];
+	edge_serial->product_info.FirmwareMajorVersion = rec->data[0];
+	edge_serial->product_info.FirmwareMinorVersion = rec->data[1];
 	edge_serial->product_info.FirmwareBuildNumber = cpu_to_le16(build);
 
 	for (rec = ihex_next_binrec(rec); rec;
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 70536c1..63e598a 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -59,6 +59,8 @@ static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_ALDIGA) },
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_MMX) },
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_GPRS) },
+	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_HCR331) },
+	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_MOTOROLA) },
 	{ USB_DEVICE(IODATA_VENDOR_ID, IODATA_PRODUCT_ID) },
 	{ USB_DEVICE(IODATA_VENDOR_ID, IODATA_PRODUCT_ID_RSAQ5) },
 	{ USB_DEVICE(ATEN_VENDOR_ID, ATEN_PRODUCT_ID) },
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index a3bd039..9a0413c 100644
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -16,6 +16,8 @@
 #define PL2303_PRODUCT_ID_ALDIGA	0x0611
 #define PL2303_PRODUCT_ID_MMX		0x0612
 #define PL2303_PRODUCT_ID_GPRS		0x0609
+#define PL2303_PRODUCT_ID_HCR331	0x331a
+#define PL2303_PRODUCT_ID_MOTOROLA	0x0307
 
 #define ATEN_VENDOR_ID		0x0557
 #define ATEN_VENDOR_ID2		0x0547
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index efe3bf2..6e5962d 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -398,9 +398,9 @@ failed_1port:
 
 static void __exit ti_exit(void)
 {
+	usb_deregister(&ti_usb_driver);
 	usb_serial_deregister(&ti_1port_device);
 	usb_serial_deregister(&ti_2port_device);
-	usb_deregister(&ti_usb_driver);
 }
 
 
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 41f8d2a..5c86413 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1314,6 +1314,15 @@ UNUSUAL_DEV(  0x084d, 0x0011, 0x0110, 0x0110,
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_BULK32),
 
+/* Reported by <ttkspam@free.fr>
+ * The device reports a vendor-specific device class, requiring an
+ * explicit vendor/product match.
+ */
+UNUSUAL_DEV(  0x0851, 0x1542, 0x0002, 0x0002,
+		"MagicPixel",
+		"FW_Omega2",
+		US_SC_DEVICE, US_PR_DEVICE, NULL, 0),
+
 /* Andrew Lunn <andrew@lunn.ch>
  * PanDigital Digital Picture Frame. Does not like ALLOW_MEDIUM_REMOVAL
  * on LUN 4.
@@ -1607,6 +1616,13 @@ UNUSUAL_DEV(  0x0fca, 0x0006, 0x0001, 0x0001,
 		US_FL_IGNORE_DEVICE ),
 #endif
 
+/* Submitted by Nick Holloway */
+UNUSUAL_DEV( 0x0f88, 0x042e, 0x0100, 0x0100,
+		"VTech",
+		"Kidizoom",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_FIX_CAPACITY ),
+
 /* Reported by Michael Stattmann <michael@stattmann.com> */
 UNUSUAL_DEV(  0x0fce, 0xd008, 0x0000, 0x0000,
 		"Sony Ericsson",
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
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index c7dc37c..19150e7 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -347,6 +347,7 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 		goto out_req_regions;
 
 	pci_set_drvdata(pci_dev, vp_dev);
+	pci_set_master(pci_dev);
 
 	/* we use the subsystem vendor/device id as the virtio vendor/device
 	 * id.  this allows us to use the same PCI vendor/device id for all
diff --git a/fs/aio.c b/fs/aio.c
index 0f65453..8a3fb62 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -478,7 +478,7 @@ static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
 	ctx->reqs_active--;
 
 	if (unlikely(!ctx->reqs_active && ctx->dead))
-		wake_up(&ctx->wait);
+		wake_up_all(&ctx->wait);
 }
 
 static void aio_fput_routine(struct work_struct *data)
@@ -1257,7 +1257,7 @@ static void io_destroy(struct kioctx *ioctx)
 	 * by other CPUs at this point.  Right now, we rely on the
 	 * locking done by the above calls to ensure this consistency.
 	 */
-	wake_up(&ioctx->wait);
+	wake_up_all(&ioctx->wait);
 	put_ioctx(ioctx);	/* once for the lookup */
 }
 
diff --git a/fs/compat.c b/fs/compat.c
index a53216d..93b8ebf 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1241,6 +1241,10 @@ static int compat_count(compat_uptr_t __user *argv, int max)
 			argv++;
 			if(++i > max)
 				return -E2BIG;
+
+			if (fatal_signal_pending(current))
+				return -ERESTARTNOHAND;
+			cond_resched();
 		}
 	}
 	return i;
@@ -1282,6 +1286,12 @@ static int compat_copy_strings(int argc, compat_uptr_t __user *argv,
 		while (len > 0) {
 			int offset, bytes_to_copy;
 
+			if (fatal_signal_pending(current)) {
+				ret = -ERESTARTNOHAND;
+				goto out;
+			}
+			cond_resched();
+
 			offset = pos % PAGE_SIZE;
 			if (offset == 0)
 				offset = PAGE_SIZE;
@@ -1298,18 +1308,8 @@ static int compat_copy_strings(int argc, compat_uptr_t __user *argv,
 			if (!kmapped_page || kpos != (pos & PAGE_MASK)) {
 				struct page *page;
 
-#ifdef CONFIG_STACK_GROWSUP
-				ret = expand_stack_downwards(bprm->vma, pos);
-				if (ret < 0) {
-					/* We've exceed the stack rlimit. */
-					ret = -E2BIG;
-					goto out;
-				}
-#endif
-				ret = get_user_pages(current, bprm->mm, pos,
-						     1, 1, 1, &page, NULL);
-				if (ret <= 0) {
-					/* We've exceed the stack rlimit. */
+				page = get_arg_page(bprm, pos, 1);
+				if (!page) {
 					ret = -E2BIG;
 					goto out;
 				}
@@ -1425,8 +1425,10 @@ out:
 		security_bprm_free(bprm);
 
 out_mm:
-	if (bprm->mm)
+	if (bprm->mm) {
+		acct_arg_size(bprm, 0);
 		mmput(bprm->mm);
+	}
 
 out_file:
 	if (bprm->file) {
diff --git a/fs/dquot.c b/fs/dquot.c
index 150fc96..38f5f60 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -365,7 +365,7 @@ out_iolock:
  */
 int dquot_commit(struct dquot *dquot)
 {
-	int ret = 0, ret2 = 0;
+	int ret = 0;
 	struct quota_info *dqopt = sb_dqopt(dquot->dq_sb);
 
 	mutex_lock(&dqopt->dqio_mutex);
@@ -377,13 +377,10 @@ int dquot_commit(struct dquot *dquot)
 	spin_unlock(&dq_list_lock);
 	/* Inactive dquot can be only if there was error during read/init
 	 * => we have better not writing it */
-	if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags)) {
+	if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags))
 		ret = dqopt->ops[dquot->dq_type]->commit_dqblk(dquot);
-		if (info_dirty(&dqopt->info[dquot->dq_type]))
-			ret2 = dqopt->ops[dquot->dq_type]->write_file_info(dquot->dq_sb, dquot->dq_type);
-		if (ret >= 0)
-			ret = ret2;
-	}
+	else
+		ret = -EIO;
 out_sem:
 	mutex_unlock(&dqopt->dqio_mutex);
 	return ret;
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 247c0d4..acc16ff 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -977,6 +977,7 @@ int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
 		printk(KERN_ERR "Could not find key with description: [%s]\n",
 		       sig);
 		rc = process_request_key_err(PTR_ERR(*auth_tok_key));
+		(*auth_tok_key) = NULL;
 		goto out;
 	}
 	(*auth_tok) = ecryptfs_get_key_payload_data(*auth_tok_key);
diff --git a/fs/exec.c b/fs/exec.c
index 12e7ad2..56313f6 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -168,7 +168,22 @@ exit:
 
 #ifdef CONFIG_MMU
 
-static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
+void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
+{
+	struct mm_struct *mm = current->mm;
+	long diff = (long)(pages - bprm->vma_pages);
+
+	if (!mm || !diff)
+		return;
+
+	bprm->vma_pages = pages;
+
+	down_write(&mm->mmap_sem);
+	mm->total_vm += diff;
+	up_write(&mm->mmap_sem);
+}
+
+struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 		int write)
 {
 	struct page *page;
@@ -190,6 +205,8 @@ static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 		unsigned long size = bprm->vma->vm_end - bprm->vma->vm_start;
 		struct rlimit *rlim;
 
+		acct_arg_size(bprm, size / PAGE_SIZE);
+
 		/*
 		 * We've historically supported up to 32 pages (ARG_MAX)
 		 * of argument strings even with small stacks
@@ -291,7 +308,11 @@ static bool valid_arg_len(struct linux_binprm *bprm, long len)
 
 #else
 
-static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
+void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
+{
+}
+
+struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 		int write)
 {
 	struct page *page;
@@ -995,6 +1016,7 @@ int flush_old_exec(struct linux_binprm * bprm)
 	/*
 	 * Release all of the old mmap stuff
 	 */
+	acct_arg_size(bprm, 0);
 	retval = exec_mmap(bprm->mm);
 	if (retval)
 		goto out;
@@ -1378,8 +1400,10 @@ out:
 		security_bprm_free(bprm);
 
 out_mm:
-	if (bprm->mm)
+	if (bprm->mm) {
+		acct_arg_size(bprm, 0);
 		mmput (bprm->mm);
+	}
 
 out_file:
 	if (bprm->file) {
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 80c97fd..fba953d 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -322,7 +322,6 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 		new_de = ext2_find_entry (new_dir, new_dentry, &new_page);
 		if (!new_de)
 			goto out_dir;
-		inode_inc_link_count(old_inode);
 		ext2_set_link(new_dir, new_de, new_page, old_inode);
 		new_inode->i_ctime = CURRENT_TIME_SEC;
 		if (dir_de)
@@ -334,12 +333,9 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 			if (new_dir->i_nlink >= EXT2_LINK_MAX)
 				goto out_dir;
 		}
-		inode_inc_link_count(old_inode);
 		err = ext2_add_link(new_dentry, old_inode);
-		if (err) {
-			inode_dec_link_count(old_inode);
+		if (err)
 			goto out_dir;
-		}
 		if (dir_de)
 			inode_inc_link_count(new_dir);
 	}
@@ -347,12 +343,11 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 	/*
 	 * Like most other Unix systems, set the ctime for inodes on a
  	 * rename.
-	 * inode_dec_link_count() will mark the inode dirty.
 	 */
 	old_inode->i_ctime = CURRENT_TIME_SEC;
+	mark_inode_dirty(old_inode);
 
 	ext2_delete_entry (old_de, old_page);
-	inode_dec_link_count(old_inode);
 
 	if (dir_de) {
 		ext2_set_link(old_inode, dir_de, dir_page, new_dir);
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 89b1c93..a215ab7 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1555,8 +1555,8 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			goto cleanup;
 		node2 = (struct dx_node *)(bh2->b_data);
 		entries2 = node2->entries;
+		memset(&node2->fake, 0, sizeof(struct fake_dirent));
 		node2->fake.rec_len = ext3_rec_len_to_disk(sb->s_blocksize);
-		node2->fake.inode = 0;
 		BUFFER_TRACE(frame->bh, "get_write_access");
 		err = ext3_journal_get_write_access(handle, frame->bh);
 		if (err)
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 810bf7c..d7c5c6b 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1362,6 +1362,13 @@ static void ext3_orphan_cleanup (struct super_block * sb,
 		return;
 	}
 
+	/* Check if feature set allows readwrite operations */
+	if (EXT3_HAS_RO_COMPAT_FEATURE(sb, ~EXT3_FEATURE_RO_COMPAT_SUPP)) {
+		printk(KERN_INFO "EXT3-fs: %s: Skipping orphan cleanup due to "
+			 "unknown ROCOMPAT features\n", sb->s_id);
+		return;
+	}
+
 	if (EXT3_SB(sb)->s_mount_state & EXT3_ERROR_FS) {
 		if (es->s_last_orphan)
 			jbd_debug(1, "Errors on filesystem, "
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 536e392..3eb4672 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4818,13 +4818,12 @@ static int ext4_indirect_trans_blocks(struct inode *inode, int nrblocks,
 	/* if nrblocks are contiguous */
 	if (chunk) {
 		/*
-		 * With N contiguous data blocks, it need at most
-		 * N/EXT4_ADDR_PER_BLOCK(inode->i_sb) indirect blocks
-		 * 2 dindirect blocks
-		 * 1 tindirect block
+		 * With N contiguous data blocks, we need at most
+		 * N/EXT4_ADDR_PER_BLOCK(inode->i_sb) + 1 indirect blocks,
+		 * 2 dindirect blocks, and 1 tindirect block
 		 */
-		indirects = nrblocks / EXT4_ADDR_PER_BLOCK(inode->i_sb);
-		return indirects + 3;
+		return DIV_ROUND_UP(nrblocks,
+				    EXT4_ADDR_PER_BLOCK(inode->i_sb)) + 4;
 	}
 	/*
 	 * if nrblocks are not contiguous, worse case, each block touch
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index bec76b1..581b14e 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -537,7 +537,7 @@ static int gfs2_bmap_alloc(struct inode *inode, const sector_t lblock,
 				*ptr++ = cpu_to_be64(bn++);
 			break;
 		}
-	} while (state != ALLOC_DATA);
+	} while ((state != ALLOC_DATA) || !dblock);
 
 	ip->i_height = height;
 	gfs2_add_inode_blocks(&ip->i_inode, alloced);
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 8a5c1d5..72204b8 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -397,15 +397,18 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
 		pos += vec->iov_len;
 	}
 
+	/*
+	 * If no bytes were started, return the error, and let the
+	 * generic layer handle the completion.
+	 */
+	if (requested_bytes == 0) {
+		nfs_direct_req_release(dreq);
+		return result < 0 ? result : -EIO;
+	}
+
 	if (put_dreq(dreq))
 		nfs_direct_complete(dreq);
-
-	if (requested_bytes != 0)
-		return 0;
-
-	if (result < 0)
-		return result;
-	return -EIO;
+	return 0;
 }
 
 static ssize_t nfs_direct_read(struct kiocb *iocb, const struct iovec *iov,
@@ -817,15 +820,18 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 		pos += vec->iov_len;
 	}
 
+	/*
+	 * If no bytes were started, return the error, and let the
+	 * generic layer handle the completion.
+	 */
+	if (requested_bytes == 0) {
+		nfs_direct_req_release(dreq);
+		return result < 0 ? result : -EIO;
+	}
+
 	if (put_dreq(dreq))
 		nfs_direct_write_complete(dreq, dreq->inode);
-
-	if (requested_bytes != 0)
-		return 0;
-
-	if (result < 0)
-		return result;
-	return -EIO;
+	return 0;
 }
 
 static ssize_t nfs_direct_write(struct kiocb *iocb, const struct iovec *iov,
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index e5a0874..7e11f13 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -218,7 +218,7 @@ static int nfs_do_fsync(struct nfs_open_context *ctx, struct inode *inode)
 	have_error |= test_bit(NFS_CONTEXT_ERROR_WRITE, &ctx->flags);
 	if (have_error)
 		ret = xchg(&ctx->error, 0);
-	if (!ret)
+	if (!ret && status < 0)
 		ret = status;
 	return ret;
 }
diff --git a/fs/nfsd/lockd.c b/fs/nfsd/lockd.c
index 15c6fae..baf5a24 100644
--- a/fs/nfsd/lockd.c
+++ b/fs/nfsd/lockd.c
@@ -44,7 +44,6 @@ nlm_fopen(struct svc_rqst *rqstp, struct nfs_fh *f, struct file **filp)
 	exp_readlock();
 	nfserr = nfsd_open(rqstp, &fh, S_IFREG, NFSD_MAY_LOCK, filp);
 	fh_put(&fh);
-	rqstp->rq_client = NULL;
 	exp_readunlock();
  	/* We return nlm error codes as nlm doesn't know
 	 * about nfsd, but nfsd does know about nlm..
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 6203c81..0df5a9e 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -335,8 +335,8 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval, struct iattr *ia
 		READ_BUF(dummy32);
 		len += (XDR_QUADLEN(dummy32) << 2);
 		READMEM(buf, dummy32);
-		if ((host_err = nfsd_map_name_to_uid(argp->rqstp, buf, dummy32, &iattr->ia_uid)))
-			goto out_nfserr;
+		if ((status = nfsd_map_name_to_uid(argp->rqstp, buf, dummy32, &iattr->ia_uid)))
+			return status;
 		iattr->ia_valid |= ATTR_UID;
 	}
 	if (bmval[1] & FATTR4_WORD1_OWNER_GROUP) {
@@ -346,8 +346,8 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval, struct iattr *ia
 		READ_BUF(dummy32);
 		len += (XDR_QUADLEN(dummy32) << 2);
 		READMEM(buf, dummy32);
-		if ((host_err = nfsd_map_name_to_gid(argp->rqstp, buf, dummy32, &iattr->ia_gid)))
-			goto out_nfserr;
+		if ((status = nfsd_map_name_to_gid(argp->rqstp, buf, dummy32, &iattr->ia_gid)))
+			return status;
 		iattr->ia_valid |= ATTR_GID;
 	}
 	if (bmval[1] & FATTR4_WORD1_TIME_ACCESS_SET) {
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index ac31e0c..81284c6 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -805,7 +805,7 @@ nfsd_get_raparms(dev_t dev, ino_t ino)
 		if (ra->p_count == 0)
 			frap = rap;
 	}
-	depth = nfsdstats.ra_size*11/10;
+	depth = nfsdstats.ra_size;
 	if (!frap) {	
 		spin_unlock(&rab->pb_lock);
 		return NULL;
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 4039637..2fa5183 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1099,6 +1099,12 @@ static int ocfs2_prepare_page_for_write(struct inode *inode, u64 *p_blkno,
 	ocfs2_figure_cluster_boundaries(OCFS2_SB(inode->i_sb), cpos,
 					&cluster_start, &cluster_end);
 
+	/* treat the write as new if the a hole/lseek spanned across
+	 * the page boundary.
+	 */
+	new = new | ((i_size_read(inode) <= page_offset(page)) &&
+			(page_offset(page) <= user_pos));
+
 	if (page == wc->w_target_page) {
 		map_from = user_pos & (PAGE_CACHE_SIZE - 1);
 		map_to = map_from + user_len;
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 353fc35..2179c7d 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -190,7 +190,7 @@ static struct ocfs2_live_connection *ocfs2_connection_find(const char *name)
 			return c;
 	}
 
-	return c;
+	return NULL;
 }
 
 /*
diff --git a/fs/partitions/ldm.c b/fs/partitions/ldm.c
index 8652fb9..2cd9e43 100644
--- a/fs/partitions/ldm.c
+++ b/fs/partitions/ldm.c
@@ -251,6 +251,11 @@ static bool ldm_parse_vmdb (const u8 *data, struct vmdb *vm)
 	}
 
 	vm->vblk_size     = get_unaligned_be32(data + 0x08);
+	if (vm->vblk_size == 0) {
+		ldm_error ("Illegal VBLK size");
+		return false;
+	}
+
 	vm->vblk_offset   = get_unaligned_be32(data + 0x0C);
 	vm->last_vblk_seq = get_unaligned_be32(data + 0x04);
 
diff --git a/fs/partitions/mac.c b/fs/partitions/mac.c
index d4a0fad..dcd3f9d 100644
--- a/fs/partitions/mac.c
+++ b/fs/partitions/mac.c
@@ -29,10 +29,9 @@ static inline void mac_fix_string(char *stg, int len)
 
 int mac_partition(struct parsed_partitions *state, struct block_device *bdev)
 {
-	int slot = 1;
 	Sector sect;
 	unsigned char *data;
-	int blk, blocks_in_map;
+	int slot, blocks_in_map;
 	unsigned secsize;
 #ifdef CONFIG_PPC_PMAC
 	int found_root = 0;
@@ -59,10 +58,14 @@ int mac_partition(struct parsed_partitions *state, struct block_device *bdev)
 		put_dev_sector(sect);
 		return 0;		/* not a MacOS disk */
 	}
-	printk(" [mac]");
 	blocks_in_map = be32_to_cpu(part->map_count);
-	for (blk = 1; blk <= blocks_in_map; ++blk) {
-		int pos = blk * secsize;
+	if (blocks_in_map < 0 || blocks_in_map >= MAX_PART) {
+		put_dev_sector(sect);
+		return 0;
+	}
+	printk(" [mac]");
+	for (slot = 1; slot <= blocks_in_map; ++slot) {
+		int pos = slot * secsize;
 		put_dev_sector(sect);
 		data = read_dev_sector(bdev, pos/512, &sect);
 		if (!data)
@@ -113,13 +116,11 @@ int mac_partition(struct parsed_partitions *state, struct block_device *bdev)
 			}
 
 			if (goodness > found_root_goodness) {
-				found_root = blk;
+				found_root = slot;
 				found_root_goodness = goodness;
 			}
 		}
 #endif /* CONFIG_PPC_PMAC */
-
-		++slot;
 	}
 #ifdef CONFIG_PPC_PMAC
 	if (found_root_goodness)
diff --git a/fs/proc/array.c b/fs/proc/array.c
index c0cf3bf..4f6e323 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -331,9 +331,6 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 	task_sig(m, task);
 	task_cap(m, task);
 	cpuset_task_status_allowed(m, task);
-#if defined(CONFIG_S390)
-	task_show_regs(m, task);
-#endif
 	task_context_switch_counts(m, task);
 	return 0;
 }
@@ -474,8 +471,8 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
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
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 76f9ffc..1a38d90 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2734,11 +2734,16 @@ static int proc_pid_fill_cache(struct file *filp, void *dirent, filldir_t filldi
 /* for the /proc/ directory itself, after non-process stuff has been done */
 int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
 {
-	unsigned int nr = filp->f_pos - FIRST_PROCESS_ENTRY;
-	struct task_struct *reaper = get_proc_task(filp->f_path.dentry->d_inode);
+	unsigned int nr;
+	struct task_struct *reaper;
 	struct tgid_iter iter;
 	struct pid_namespace *ns;
 
+	if (filp->f_pos >= PID_MAX_LIMIT + TGID_OFFSET)
+		goto out_no_task;
+	nr = filp->f_pos - FIRST_PROCESS_ENTRY;
+
+	reaper = get_proc_task(filp->f_path.dentry->d_inode);
 	if (!reaper)
 		goto out_no_task;
 
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 0325100..7d74d68 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -241,8 +241,8 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
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
diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index 5145cb9..c72efb3 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -114,6 +114,9 @@ int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
 		if (!pagevec_add(&lru_pvec, page))
 			__pagevec_lru_add(&lru_pvec);
 
+		/* prevent the page from being discarded on memory pressure */
+		SetPageDirty(page);
+
 		unlock_page(page);
 	}
 
diff --git a/fs/ubifs/commit.c b/fs/ubifs/commit.c
index 0a6aa2c..bcb2d29 100644
--- a/fs/ubifs/commit.c
+++ b/fs/ubifs/commit.c
@@ -517,7 +517,7 @@ int dbg_check_old_index(struct ubifs_info *c, struct ubifs_zbranch *zroot)
 	size_t sz;
 
 	if (!(ubifs_chk_flags & UBIFS_CHK_OLD_IDX))
-		goto out;
+		return 0;
 
 	INIT_LIST_HEAD(&list);
 
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 82b1c4a..b31e30d 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1009,6 +1009,9 @@ int ubifs_fsync(struct file *file, struct dentry *dentry, int datasync)
 
 	dbg_gen("syncing inode %lu", inode->i_ino);
 
+	if (inode->i_sb->s_flags & MS_RDONLY)
+		return 0;
+
 	/*
 	 * VFS has already synchronized dirty pages for this inode. Synchronize
 	 * the inode unless this is a 'datasync()' call.
diff --git a/fs/ubifs/lpt.c b/fs/ubifs/lpt.c
index 9ff2463..700a925 100644
--- a/fs/ubifs/lpt.c
+++ b/fs/ubifs/lpt.c
@@ -1240,10 +1240,9 @@ static int read_pnode(struct ubifs_info *c, struct ubifs_nnode *parent, int iip)
 	lnum = branch->lnum;
 	offs = branch->offs;
 	pnode = kzalloc(sizeof(struct ubifs_pnode), GFP_NOFS);
-	if (!pnode) {
-		err = -ENOMEM;
-		goto out;
-	}
+	if (!pnode)
+		return -ENOMEM;
+
 	if (lnum == 0) {
 		/*
 		 * This pnode was not written which just means that the LEB
diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index 48799ba..eb5daf53 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -762,14 +762,19 @@ xfs_ioc_fsgeometry_v1(
 	xfs_mount_t		*mp,
 	void			__user *arg)
 {
-	xfs_fsop_geom_v1_t	fsgeo;
+	xfs_fsop_geom_t         fsgeo;
 	int			error;
 
-	error = xfs_fs_geometry(mp, (xfs_fsop_geom_t *)&fsgeo, 3);
+	error = xfs_fs_geometry(mp, &fsgeo, 3);
 	if (error)
 		return -error;
 
-	if (copy_to_user(arg, &fsgeo, sizeof(fsgeo)))
+	/*
+	 * Caller should have passed an argument of type
+	 * xfs_fsop_geom_v1_t.  This is a proper subset of the
+	 * xfs_fsop_geom_t that xfs_fs_geometry() fills in.
+	 */
+	if (copy_to_user(arg, &fsgeo, sizeof(xfs_fsop_geom_v1_t)))
 		return -XFS_ERROR(EFAULT);
 	return 0;
 }
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 84583cf..f269c20 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -56,6 +56,9 @@ xfs_fs_geometry(
 	xfs_fsop_geom_t		*geo,
 	int			new_version)
 {
+
+	memset(geo, 0, sizeof(*geo));
+
 	geo->blocksize = mp->m_sb.sb_blocksize;
 	geo->rtextsize = mp->m_sb.sb_rextsize;
 	geo->agblocks = mp->m_sb.sb_agblocks;
diff --git a/include/asm-x86/mach-default/smpboot_hooks.h b/include/asm-x86/mach-default/smpboot_hooks.h
index dbab36d..4e767be 100644
--- a/include/asm-x86/mach-default/smpboot_hooks.h
+++ b/include/asm-x86/mach-default/smpboot_hooks.h
@@ -32,7 +32,7 @@ static inline void smpboot_restore_warm_reset_vector(void)
 	 */
 	CMOS_WRITE(0, 0xf);
 
-	*((volatile long *) phys_to_virt(0x467)) = 0;
+	*((volatile u32 *) phys_to_virt(0x467)) = 0;
 }
 
 static inline void __init smpboot_setup_io_apic(void)
diff --git a/include/asm-x86/mmu_context_32.h b/include/asm-x86/mmu_context_32.h
index 824fc57..d275232 100644
--- a/include/asm-x86/mmu_context_32.h
+++ b/include/asm-x86/mmu_context_32.h
@@ -17,8 +17,6 @@ static inline void switch_mm(struct mm_struct *prev,
 	int cpu = smp_processor_id();
 
 	if (likely(prev != next)) {
-		/* stop flush ipis for the previous mm */
-		cpu_clear(cpu, prev->cpu_vm_mask);
 #ifdef CONFIG_SMP
 		per_cpu(cpu_tlbstate, cpu).state = TLBSTATE_OK;
 		per_cpu(cpu_tlbstate, cpu).active_mm = next;
@@ -28,6 +26,9 @@ static inline void switch_mm(struct mm_struct *prev,
 		/* Re-load page tables */
 		load_cr3(next->pgd);
 
+		/* stop flush ipis for the previous mm */
+		cpu_clear(cpu, prev->cpu_vm_mask);
+
 		/*
 		 * load the LDT, if the LDT is different:
 		 */
diff --git a/include/asm-x86/mmu_context_64.h b/include/asm-x86/mmu_context_64.h
index c700063..ffa3a24 100644
--- a/include/asm-x86/mmu_context_64.h
+++ b/include/asm-x86/mmu_context_64.h
@@ -16,8 +16,6 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 {
 	unsigned cpu = smp_processor_id();
 	if (likely(prev != next)) {
-		/* stop flush ipis for the previous mm */
-		cpu_clear(cpu, prev->cpu_vm_mask);
 #ifdef CONFIG_SMP
 		write_pda(mmu_state, TLBSTATE_OK);
 		write_pda(active_mm, next);
@@ -25,6 +23,9 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		cpu_set(cpu, next->cpu_vm_mask);
 		load_cr3(next->pgd);
 
+		/* stop flush ipis for the previous mm */
+		cpu_clear(cpu, prev->cpu_vm_mask);
+
 		if (unlikely(next->context.ldt != prev->context.ldt))
 			load_LDT_nolock(&next->context);
 	}
diff --git a/include/asm-x86/pgtable-3level.h b/include/asm-x86/pgtable-3level.h
index 105057f..a1ed879 100644
--- a/include/asm-x86/pgtable-3level.h
+++ b/include/asm-x86/pgtable-3level.h
@@ -101,8 +101,6 @@ static inline void native_pmd_clear(pmd_t *pmd)
 
 static inline void pud_clear(pud_t *pudp)
 {
-	unsigned long pgd;
-
 	set_pud(pudp, __pud(0));
 
 	/*
@@ -111,13 +109,10 @@ static inline void pud_clear(pud_t *pudp)
 	 * section 8.1: in PAE mode we explicitly have to flush the
 	 * TLB via cr3 if the top-level pgd is changed...
 	 *
-	 * Make sure the pud entry we're updating is within the
-	 * current pgd to avoid unnecessary TLB flushes.
+	 * Currently all places where pud_clear() is called either have
+	 * flush_tlb_mm() followed or don't need TLB flush (x86_64 code or
+	 * pud_clear_bad()), so we don't need TLB flush here.
 	 */
-	pgd = read_cr3();
-	if (__pa(pudp) >= pgd && __pa(pudp) <
-	    (pgd + sizeof(pgd_t)*PTRS_PER_PGD))
-		write_cr3(pgd);
 }
 
 #define pud_page(pud) ((struct page *) __va(pud_val(pud) & PTE_PFN_MASK))
diff --git a/include/drm/drm_pciids.h b/include/drm/drm_pciids.h
index 0d97c90..c5e116f 100644
--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -27,7 +27,6 @@
 	{0x1002, 0x4156, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV350}, \
 	{0x1002, 0x4237, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS200|RADEON_IS_IGP}, \
 	{0x1002, 0x4242, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R200}, \
-	{0x1002, 0x4243, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R200}, \
 	{0x1002, 0x4336, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS100|RADEON_IS_IGP|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x4337, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS200|RADEON_IS_IGP|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x4437, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS200|RADEON_IS_IGP|RADEON_IS_MOBILITY}, \
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 12413a1..b79b901 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -28,6 +28,7 @@ struct linux_binprm{
 	char buf[BINPRM_BUF_SIZE];
 #ifdef CONFIG_MMU
 	struct vm_area_struct *vma;
+	unsigned long vma_pages;
 #else
 # define MAX_ARG_PAGES	32
 	struct page *page[MAX_ARG_PAGES];
@@ -52,6 +53,10 @@ struct linux_binprm{
 	unsigned long loader, exec;
 };
 
+extern void acct_arg_size(struct linux_binprm *bprm, unsigned long pages);
+extern struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
+					int write);
+
 #define BINPRM_FLAGS_ENFORCE_NONDUMP_BIT 0
 #define BINPRM_FLAGS_ENFORCE_NONDUMP (1 << BINPRM_FLAGS_ENFORCE_NONDUMP_BIT)
 
diff --git a/include/linux/pid.h b/include/linux/pid.h
index 93997c9..8f7ea81 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -117,7 +117,7 @@ extern struct pid *find_vpid(int nr);
  */
 extern struct pid *find_get_pid(int nr);
 extern struct pid *find_ge_pid(int nr, struct pid_namespace *);
-int next_pidmap(struct pid_namespace *pid_ns, int last);
+int next_pidmap(struct pid_namespace *pid_ns, unsigned int last);
 
 extern struct pid *alloc_pid(struct pid_namespace *ns);
 extern void free_pid(struct pid *pid);
diff --git a/include/net/sctp/command.h b/include/net/sctp/command.h
index 88988ab..4199839 100644
--- a/include/net/sctp/command.h
+++ b/include/net/sctp/command.h
@@ -105,6 +105,7 @@ typedef enum {
 	SCTP_CMD_ASSOC_SHKEY,    /* generate the association shared keys */
 	SCTP_CMD_T1_RETRAN,	 /* Mark for retransmission after T1 timeout  */
 	SCTP_CMD_UPDATE_INITTAG, /* Update peer inittag */
+	SCTP_CMD_SEND_NEXT_ASCONF, /* Send the next ASCONF after ACK */
 	SCTP_CMD_LAST
 } sctp_verb_t;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 80b2e93..76c111b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -422,7 +422,7 @@ static inline int scsi_device_qas(struct scsi_device *sdev)
 }
 static inline int scsi_device_enclosure(struct scsi_device *sdev)
 {
-	return sdev->inquiry[6] & (1<<6);
+	return sdev->inquiry ? (sdev->inquiry[6] & (1<<6)) : 1;
 }
 
 static inline int scsi_device_protection(struct scsi_device *sdev)
diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index c1b26fc..1da34b1 100644
--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -46,25 +46,25 @@
 /* platform domain */
 #define SND_SOC_DAPM_INPUT(wname) \
 {	.id = snd_soc_dapm_input, .name = wname, .kcontrols = NULL, \
-	.num_kcontrols = 0}
+	.num_kcontrols = 0, .reg = SND_SOC_NOPM }
 #define SND_SOC_DAPM_OUTPUT(wname) \
 {	.id = snd_soc_dapm_output, .name = wname, .kcontrols = NULL, \
-	.num_kcontrols = 0}
+	.num_kcontrols = 0, .reg = SND_SOC_NOPM }
 #define SND_SOC_DAPM_MIC(wname, wevent) \
 {	.id = snd_soc_dapm_mic, .name = wname, .kcontrols = NULL, \
-	.num_kcontrols = 0, .event = wevent, \
+	.num_kcontrols = 0, .reg = SND_SOC_NOPM, .event = wevent, \
 	.event_flags = SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMD}
 #define SND_SOC_DAPM_HP(wname, wevent) \
 {	.id = snd_soc_dapm_hp, .name = wname, .kcontrols = NULL, \
-	.num_kcontrols = 0, .event = wevent, \
+	.num_kcontrols = 0, .reg = SND_SOC_NOPM, .event = wevent, \
 	.event_flags = SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD}
 #define SND_SOC_DAPM_SPK(wname, wevent) \
 {	.id = snd_soc_dapm_spk, .name = wname, .kcontrols = NULL, \
-	.num_kcontrols = 0, .event = wevent, \
+	.num_kcontrols = 0, .reg = SND_SOC_NOPM, .event = wevent, \
 	.event_flags = SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD}
 #define SND_SOC_DAPM_LINE(wname, wevent) \
 {	.id = snd_soc_dapm_line, .name = wname, .kcontrols = NULL, \
-	.num_kcontrols = 0, .event = wevent, \
+	.num_kcontrols = 0, .reg = SND_SOC_NOPM, .event = wevent, \
 	.event_flags = SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD}
 
 /* path domain */
@@ -115,11 +115,11 @@
 /* events that are pre and post DAPM */
 #define SND_SOC_DAPM_PRE(wname, wevent) \
 {	.id = snd_soc_dapm_pre, .name = wname, .kcontrols = NULL, \
-	.num_kcontrols = 0, .event = wevent, \
+	.num_kcontrols = 0, .reg = SND_SOC_NOPM, .event = wevent, \
 	.event_flags = SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_PRE_PMD}
 #define SND_SOC_DAPM_POST(wname, wevent) \
 {	.id = snd_soc_dapm_post, .name = wname, .kcontrols = NULL, \
-	.num_kcontrols = 0, .event = wevent, \
+	.num_kcontrols = 0, .reg = SND_SOC_NOPM, .event = wevent, \
 	.event_flags = SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD}
 
 /* stream domain */
diff --git a/init/calibrate.c b/init/calibrate.c
index a379c90..4003321 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -66,7 +66,7 @@ static unsigned long __cpuinit calibrate_delay_direct(void)
 		pre_start = 0;
 		read_current_timer(&start);
 		start_jiffies = jiffies;
-		while (jiffies <= (start_jiffies + 1)) {
+		while (time_before_eq(jiffies, start_jiffies + 1)) {
 			pre_start = start;
 			read_current_timer(&start);
 		}
@@ -74,8 +74,8 @@ static unsigned long __cpuinit calibrate_delay_direct(void)
 
 		pre_end = 0;
 		end = post_start;
-		while (jiffies <=
-		       (start_jiffies + 1 + DELAY_CALIBRATION_TICKS)) {
+		while (time_before_eq(jiffies, start_jiffies + 1 +
+					       DELAY_CALIBRATION_TICKS)) {
 			pre_end = end;
 			read_current_timer(&end);
 		}
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0314074..b7606ba 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -629,7 +629,7 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 	action->next = NULL;
 	action->dev_id = dev_id;
 
-#ifdef CONFIG_DEBUG_SHIRQ
+#ifdef CONFIG_DEBUG_SHIRQ_FIXME
 	if (irqflags & IRQF_SHARED) {
 		/*
 		 * It's a shared IRQ -- the driver ought to be prepared for it
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index e4dcfb2..a67d6c4 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -1001,10 +1001,8 @@ static void gdb_cmd_query(struct kgdb_state *ks)
 	switch (remcom_in_buffer[1]) {
 	case 's':
 	case 'f':
-		if (memcmp(remcom_in_buffer + 2, "ThreadInfo", 10)) {
-			error_packet(remcom_out_buffer, -EINVAL);
+		if (memcmp(remcom_in_buffer + 2, "ThreadInfo", 10))
 			break;
-		}
 
 		i = 0;
 		remcom_out_buffer[0] = 'm';
@@ -1045,10 +1043,9 @@ static void gdb_cmd_query(struct kgdb_state *ks)
 		pack_threadid(remcom_out_buffer + 2, thref);
 		break;
 	case 'T':
-		if (memcmp(remcom_in_buffer + 1, "ThreadExtraInfo,", 16)) {
-			error_packet(remcom_out_buffer, -EINVAL);
+		if (memcmp(remcom_in_buffer + 1, "ThreadExtraInfo,", 16))
 			break;
-		}
+
 		ks->threadid = 0;
 		ptr = remcom_in_buffer + 17;
 		kgdb_hex2long(&ptr, &ks->threadid);
diff --git a/kernel/pid.c b/kernel/pid.c
index 064e76a..c19879f 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -182,11 +182,14 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 	return -1;
 }
 
-int next_pidmap(struct pid_namespace *pid_ns, int last)
+int next_pidmap(struct pid_namespace *pid_ns, unsigned int last)
 {
 	int offset;
 	struct pidmap *map, *end;
 
+	if (last >= PID_MAX_LIMIT)
+		return -1;
+
 	offset = (last + 1) & BITS_PER_PAGE_MASK;
 	map = &pid_ns->pidmap[(last + 1)/BITS_PER_PAGE];
 	end = &pid_ns->pidmap[PIDMAP_ENTRIES];
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 85c1983..e194cd1 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -213,7 +213,7 @@ static inline void __ptrace_detach(struct task_struct *child, unsigned int data)
 	__ptrace_unlink(child);
 	/* .. and wake it up. */
 	if (child->exit_state != EXIT_ZOMBIE)
-		wake_up_process(child);
+		wake_up_state(child, TASK_TRACED | TASK_STOPPED);
 }
 
 int ptrace_detach(struct task_struct *child, unsigned int data)
diff --git a/kernel/signal.c b/kernel/signal.c
index efcdc95..b1506fb 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2294,9 +2294,13 @@ SYSCALL_DEFINE3(rt_sigqueueinfo, pid_t, pid, int, sig,
 		return -EFAULT;
 
 	/* Not even root can pretend to send signals from the kernel.
-	   Nor can they impersonate a kill(), which adds source info.  */
-	if (info.si_code >= 0)
+	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
+	 */
+	if (info.si_code >= 0 || info.si_code == SI_TKILL) {
+		/* We used to allow any < 0 si_code */
+		WARN_ON_ONCE(info.si_code < 0);
 		return -EPERM;
+	}
 	info.si_signo = sig;
 
 	/* POSIX.1b doesn't mention process groups.  */
diff --git a/mm/mremap.c b/mm/mremap.c
index cfdeed9..a27c007 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -89,9 +89,7 @@ static void move_ptes(struct vm_area_struct *vma, pmd_t *old_pmd,
 		 */
 		mapping = vma->vm_file->f_mapping;
 		spin_lock(&mapping->i_mmap_lock);
-		if (new_vma->vm_truncate_count &&
-		    new_vma->vm_truncate_count != vma->vm_truncate_count)
-			new_vma->vm_truncate_count = 0;
+		new_vma->vm_truncate_count = 0;
 	}
 
 	/*
@@ -335,10 +333,21 @@ unsigned long do_mremap(unsigned long addr,
 	/* We can't remap across vm area boundaries */
 	if (old_len > vma->vm_end - addr)
 		goto out;
-	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP)) {
-		if (new_len > old_len)
+
+	/* Need to be careful about a growing mapping */
+	if (new_len > old_len) {
+		unsigned long pgoff;
+
+		if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
 			goto out;
+		pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
+		pgoff += vma->vm_pgoff;
+		if (pgoff + (new_len >> PAGE_SHIFT) < pgoff) {
+			ret = -EINVAL;
+			goto out;
+		}
 	}
+
 	if (vma->vm_flags & VM_LOCKED) {
 		unsigned long locked, lock_limit;
 		locked = mm->locked_vm << PAGE_SHIFT;
diff --git a/mm/shmem.c b/mm/shmem.c
index c088da1..1abe5b7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2600,5 +2600,6 @@ int shmem_zero_setup(struct vm_area_struct *vma)
 		fput(vma->vm_file);
 	vma->vm_file = file;
 	vma->vm_ops = &shmem_vm_ops;
+	vma->vm_flags |= VM_CAN_NONLINEAR;
 	return 0;
 }
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 2268a7e..e85b959 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1384,6 +1384,7 @@ static int ax25_getname(struct socket *sock, struct sockaddr *uaddr,
 	ax25_cb *ax25;
 	int err = 0;
 
+	memset(fsa, 0, sizeof(*fsa));
 	lock_sock(sk);
 	ax25 = ax25_sk(sk);
 
@@ -1395,7 +1396,6 @@ static int ax25_getname(struct socket *sock, struct sockaddr *uaddr,
 
 		fsa->fsa_ax25.sax25_family = AF_AX25;
 		fsa->fsa_ax25.sax25_call   = ax25->dest_addr;
-		fsa->fsa_ax25.sax25_ndigis = 0;
 
 		if (ax25->digipeat != NULL) {
 			ndigi = ax25->digipeat->ndigi;
diff --git a/net/bluetooth/bnep/sock.c b/net/bluetooth/bnep/sock.c
index 8ffb57f..9a04d13 100644
--- a/net/bluetooth/bnep/sock.c
+++ b/net/bluetooth/bnep/sock.c
@@ -93,6 +93,7 @@ static int bnep_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long
 			sockfd_put(nsock);
 			return -EBADFD;
 		}
+		ca.device[sizeof(ca.device)-1] = 0;
 
 		err = bnep_add_connection(&ca, nsock);
 		if (!err) {
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 0cc91e6..49cd2e7 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -710,6 +710,7 @@ static int sco_sock_getsockopt(struct socket *sock, int level, int optname, char
 			break;
 		}
 
+		memset(&cinfo, 0, sizeof(cinfo));
 		cinfo.hci_handle = sco_pi(sk)->conn->hcon->handle;
 		memcpy(cinfo.dev_class, sco_pi(sk)->conn->hcon->dev_class, 3);
 
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index d6beca9..4d07250 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -944,6 +944,8 @@ static int do_replace(void __user *user, unsigned int len)
 	if (tmp.num_counters >= INT_MAX / sizeof(struct ebt_counter))
 		return -ENOMEM;
 
+	tmp.name[sizeof(tmp.name) - 1] = 0;
+
 	countersize = COUNTER_OFFSET(tmp.nentries) * nr_cpu_ids;
 	newinfo = vmalloc(sizeof(*newinfo) + countersize);
 	if (!newinfo)
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 7a4c818..f735292 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -121,7 +121,7 @@ struct bcm_sock {
 	struct list_head tx_ops;
 	unsigned long dropped_usr_msgs;
 	struct proc_dir_entry *bcm_proc_read;
-	char procname [20]; /* pointer printed in ASCII with \0 */
+	char procname [32]; /* inode number in decimal with \0 */
 };
 
 static inline struct bcm_sock *bcm_sk(const struct sock *sk)
@@ -1479,7 +1479,7 @@ static int bcm_connect(struct socket *sock, struct sockaddr *uaddr, int len,
 
 	if (proc_dir) {
 		/* unique socket address as filename */
-		sprintf(bo->procname, "%p", sock);
+		sprintf(bo->procname, "%lu", sock_i_ino(sk));
 		bo->bcm_proc_read = create_proc_read_entry(bo->procname, 0644,
 							   proc_dir,
 							   bcm_read_proc, sk);
diff --git a/net/core/filter.c b/net/core/filter.c
index df37443..506a7d1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -111,39 +111,41 @@ EXPORT_SYMBOL(sk_filter);
  */
 unsigned int sk_run_filter(struct sk_buff *skb, struct sock_filter *filter, int flen)
 {
-	struct sock_filter *fentry;	/* We walk down these */
 	void *ptr;
 	u32 A = 0;			/* Accumulator */
 	u32 X = 0;			/* Index Register */
 	u32 mem[BPF_MEMWORDS];		/* Scratch Memory Store */
+	unsigned long memvalid = 0;
 	u32 tmp;
 	int k;
 	int pc;
 
+	BUILD_BUG_ON(BPF_MEMWORDS > BITS_PER_LONG);
 	/*
 	 * Process array of filter instructions.
 	 */
 	for (pc = 0; pc < flen; pc++) {
-		fentry = &filter[pc];
+		const struct sock_filter *fentry = &filter[pc];
+		u32 f_k = fentry->k;
 
 		switch (fentry->code) {
 		case BPF_ALU|BPF_ADD|BPF_X:
 			A += X;
 			continue;
 		case BPF_ALU|BPF_ADD|BPF_K:
-			A += fentry->k;
+			A += f_k;
 			continue;
 		case BPF_ALU|BPF_SUB|BPF_X:
 			A -= X;
 			continue;
 		case BPF_ALU|BPF_SUB|BPF_K:
-			A -= fentry->k;
+			A -= f_k;
 			continue;
 		case BPF_ALU|BPF_MUL|BPF_X:
 			A *= X;
 			continue;
 		case BPF_ALU|BPF_MUL|BPF_K:
-			A *= fentry->k;
+			A *= f_k;
 			continue;
 		case BPF_ALU|BPF_DIV|BPF_X:
 			if (X == 0)
@@ -151,49 +153,49 @@ unsigned int sk_run_filter(struct sk_buff *skb, struct sock_filter *filter, int
 			A /= X;
 			continue;
 		case BPF_ALU|BPF_DIV|BPF_K:
-			A /= fentry->k;
+			A /= f_k;
 			continue;
 		case BPF_ALU|BPF_AND|BPF_X:
 			A &= X;
 			continue;
 		case BPF_ALU|BPF_AND|BPF_K:
-			A &= fentry->k;
+			A &= f_k;
 			continue;
 		case BPF_ALU|BPF_OR|BPF_X:
 			A |= X;
 			continue;
 		case BPF_ALU|BPF_OR|BPF_K:
-			A |= fentry->k;
+			A |= f_k;
 			continue;
 		case BPF_ALU|BPF_LSH|BPF_X:
 			A <<= X;
 			continue;
 		case BPF_ALU|BPF_LSH|BPF_K:
-			A <<= fentry->k;
+			A <<= f_k;
 			continue;
 		case BPF_ALU|BPF_RSH|BPF_X:
 			A >>= X;
 			continue;
 		case BPF_ALU|BPF_RSH|BPF_K:
-			A >>= fentry->k;
+			A >>= f_k;
 			continue;
 		case BPF_ALU|BPF_NEG:
 			A = -A;
 			continue;
 		case BPF_JMP|BPF_JA:
-			pc += fentry->k;
+			pc += f_k;
 			continue;
 		case BPF_JMP|BPF_JGT|BPF_K:
-			pc += (A > fentry->k) ? fentry->jt : fentry->jf;
+			pc += (A > f_k) ? fentry->jt : fentry->jf;
 			continue;
 		case BPF_JMP|BPF_JGE|BPF_K:
-			pc += (A >= fentry->k) ? fentry->jt : fentry->jf;
+			pc += (A >= f_k) ? fentry->jt : fentry->jf;
 			continue;
 		case BPF_JMP|BPF_JEQ|BPF_K:
-			pc += (A == fentry->k) ? fentry->jt : fentry->jf;
+			pc += (A == f_k) ? fentry->jt : fentry->jf;
 			continue;
 		case BPF_JMP|BPF_JSET|BPF_K:
-			pc += (A & fentry->k) ? fentry->jt : fentry->jf;
+			pc += (A & f_k) ? fentry->jt : fentry->jf;
 			continue;
 		case BPF_JMP|BPF_JGT|BPF_X:
 			pc += (A > X) ? fentry->jt : fentry->jf;
@@ -208,7 +210,7 @@ unsigned int sk_run_filter(struct sk_buff *skb, struct sock_filter *filter, int
 			pc += (A & X) ? fentry->jt : fentry->jf;
 			continue;
 		case BPF_LD|BPF_W|BPF_ABS:
-			k = fentry->k;
+			k = f_k;
 load_w:
 			ptr = load_pointer(skb, k, 4, &tmp);
 			if (ptr != NULL) {
@@ -217,7 +219,7 @@ load_w:
 			}
 			break;
 		case BPF_LD|BPF_H|BPF_ABS:
-			k = fentry->k;
+			k = f_k;
 load_h:
 			ptr = load_pointer(skb, k, 2, &tmp);
 			if (ptr != NULL) {
@@ -226,7 +228,7 @@ load_h:
 			}
 			break;
 		case BPF_LD|BPF_B|BPF_ABS:
-			k = fentry->k;
+			k = f_k;
 load_b:
 			ptr = load_pointer(skb, k, 1, &tmp);
 			if (ptr != NULL) {
@@ -241,32 +243,34 @@ load_b:
 			X = skb->len;
 			continue;
 		case BPF_LD|BPF_W|BPF_IND:
-			k = X + fentry->k;
+			k = X + f_k;
 			goto load_w;
 		case BPF_LD|BPF_H|BPF_IND:
-			k = X + fentry->k;
+			k = X + f_k;
 			goto load_h;
 		case BPF_LD|BPF_B|BPF_IND:
-			k = X + fentry->k;
+			k = X + f_k;
 			goto load_b;
 		case BPF_LDX|BPF_B|BPF_MSH:
-			ptr = load_pointer(skb, fentry->k, 1, &tmp);
+			ptr = load_pointer(skb, f_k, 1, &tmp);
 			if (ptr != NULL) {
 				X = (*(u8 *)ptr & 0xf) << 2;
 				continue;
 			}
 			return 0;
 		case BPF_LD|BPF_IMM:
-			A = fentry->k;
+			A = f_k;
 			continue;
 		case BPF_LDX|BPF_IMM:
-			X = fentry->k;
+			X = f_k;
 			continue;
 		case BPF_LD|BPF_MEM:
-			A = mem[fentry->k];
+			A = (memvalid & (1UL << f_k)) ?
+				mem[f_k] : 0;
 			continue;
 		case BPF_LDX|BPF_MEM:
-			X = mem[fentry->k];
+			X = (memvalid & (1UL << f_k)) ?
+				mem[f_k] : 0;
 			continue;
 		case BPF_MISC|BPF_TAX:
 			X = A;
@@ -275,14 +279,16 @@ load_b:
 			A = X;
 			continue;
 		case BPF_RET|BPF_K:
-			return fentry->k;
+			return f_k;
 		case BPF_RET|BPF_A:
 			return A;
 		case BPF_ST:
-			mem[fentry->k] = A;
+			memvalid |= 1UL << f_k;
+			mem[f_k] = A;
 			continue;
 		case BPF_STX:
-			mem[fentry->k] = X;
+			memvalid |= 1UL << f_k;
+			mem[f_k] = X;
 			continue;
 		default:
 			WARN_ON(1);
diff --git a/net/dccp/input.c b/net/dccp/input.c
index 803933a..cff41c3 100644
--- a/net/dccp/input.c
+++ b/net/dccp/input.c
@@ -600,6 +600,9 @@ int dccp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 		/* Caller (dccp_v4_do_rcv) will send Reset */
 		dcb->dccpd_reset_code = DCCP_RESET_CODE_NO_CONNECTION;
 		return 1;
+	} else if (sk->sk_state == DCCP_CLOSED) {
+		dcb->dccpd_reset_code = DCCP_RESET_CODE_NO_CONNECTION;
+		return 1;
 	}
 
 	if (sk->sk_state != DCCP_REQUESTING) {
@@ -662,10 +665,6 @@ int dccp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 	}
 
 	switch (sk->sk_state) {
-	case DCCP_CLOSED:
-		dcb->dccpd_reset_code = DCCP_RESET_CODE_NO_CONNECTION;
-		return 1;
-
 	case DCCP_REQUESTING:
 		/* FIXME: do congestion control initialization */
 
diff --git a/net/econet/af_econet.c b/net/econet/af_econet.c
index 2aa1786..3b863a3 100644
--- a/net/econet/af_econet.c
+++ b/net/econet/af_econet.c
@@ -428,10 +428,10 @@ static int econet_sendmsg(struct kiocb *iocb, struct socket *sock,
 		udpdest.sin_addr.s_addr = htonl(network | addr.station);
 	}
 
+	memset(&ah, 0, sizeof(ah));
 	ah.port = port;
 	ah.cb = cb & 0x7f;
 	ah.code = 2;		/* magic */
-	ah.pad = 0;
 
 	/* tack our header on the front of the iovec */
 	size = sizeof(struct aunhdr);
@@ -845,9 +845,13 @@ static void aun_incoming(struct sk_buff *skb, struct aunhdr *ah, size_t len)
 {
 	struct iphdr *ip = ip_hdr(skb);
 	unsigned char stn = ntohl(ip->saddr) & 0xff;
+	struct dst_entry *dst = skb->dst;
+	struct ec_device *edev = NULL;
 	struct sock *sk;
 	struct sk_buff *newskb;
-	struct ec_device *edev = skb->dev->ec_ptr;
+
+	if (dst)
+		edev = dst->dev->ec_ptr;
 
 	if (! edev)
 		goto bad;
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index c10036e..1522b06 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -493,9 +493,11 @@ static int inet_csk_diag_dump(struct sock *sk,
 {
 	struct inet_diag_req *r = NLMSG_DATA(cb->nlh);
 
-	if (cb->nlh->nlmsg_len > 4 + NLMSG_SPACE(sizeof(*r))) {
+	if (nlmsg_attrlen(cb->nlh, sizeof(*r))) {
 		struct inet_diag_entry entry;
-		struct rtattr *bc = (struct rtattr *)(r + 1);
+		const struct nlattr *bc = nlmsg_find_attr(cb->nlh,
+							  sizeof(*r),
+							  INET_DIAG_REQ_BYTECODE);
 		struct inet_sock *inet = inet_sk(sk);
 
 		entry.family = sk->sk_family;
@@ -515,7 +517,7 @@ static int inet_csk_diag_dump(struct sock *sk,
 		entry.dport = ntohs(inet->dport);
 		entry.userlocks = sk->sk_userlocks;
 
-		if (!inet_diag_bc_run(RTA_DATA(bc), RTA_PAYLOAD(bc), &entry))
+		if (!inet_diag_bc_run(nla_data(bc), nla_len(bc), &entry))
 			return 0;
 	}
 
@@ -530,9 +532,11 @@ static int inet_twsk_diag_dump(struct inet_timewait_sock *tw,
 {
 	struct inet_diag_req *r = NLMSG_DATA(cb->nlh);
 
-	if (cb->nlh->nlmsg_len > 4 + NLMSG_SPACE(sizeof(*r))) {
+	if (nlmsg_attrlen(cb->nlh, sizeof(*r))) {
 		struct inet_diag_entry entry;
-		struct rtattr *bc = (struct rtattr *)(r + 1);
+		const struct nlattr *bc = nlmsg_find_attr(cb->nlh,
+							  sizeof(*r),
+							  INET_DIAG_REQ_BYTECODE);
 
 		entry.family = tw->tw_family;
 #if defined(CONFIG_IPV6) || defined (CONFIG_IPV6_MODULE)
@@ -551,7 +555,7 @@ static int inet_twsk_diag_dump(struct inet_timewait_sock *tw,
 		entry.dport = ntohs(tw->tw_dport);
 		entry.userlocks = 0;
 
-		if (!inet_diag_bc_run(RTA_DATA(bc), RTA_PAYLOAD(bc), &entry))
+		if (!inet_diag_bc_run(nla_data(bc), nla_len(bc), &entry))
 			return 0;
 	}
 
@@ -621,7 +625,7 @@ static int inet_diag_dump_reqs(struct sk_buff *skb, struct sock *sk,
 	struct inet_diag_req *r = NLMSG_DATA(cb->nlh);
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct listen_sock *lopt;
-	struct rtattr *bc = NULL;
+	const struct nlattr *bc = NULL;
 	struct inet_sock *inet = inet_sk(sk);
 	int j, s_j;
 	int reqnum, s_reqnum;
@@ -641,8 +645,9 @@ static int inet_diag_dump_reqs(struct sk_buff *skb, struct sock *sk,
 	if (!lopt || !lopt->qlen)
 		goto out;
 
-	if (cb->nlh->nlmsg_len > 4 + NLMSG_SPACE(sizeof(*r))) {
-		bc = (struct rtattr *)(r + 1);
+	if (nlmsg_attrlen(cb->nlh, sizeof(*r))) {
+		bc = nlmsg_find_attr(cb->nlh, sizeof(*r),
+				     INET_DIAG_REQ_BYTECODE);
 		entry.sport = inet->num;
 		entry.userlocks = sk->sk_userlocks;
 	}
@@ -675,8 +680,8 @@ static int inet_diag_dump_reqs(struct sk_buff *skb, struct sock *sk,
 					&ireq->rmt_addr;
 				entry.dport = ntohs(ireq->rmt_port);
 
-				if (!inet_diag_bc_run(RTA_DATA(bc),
-						    RTA_PAYLOAD(bc), &entry))
+				if (!inet_diag_bc_run(nla_data(bc),
+						      nla_len(bc), &entry))
 					continue;
 			}
 
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 6671485..e468bdd 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1035,6 +1035,7 @@ static int do_replace(struct net *net, void __user *user, unsigned int len)
 	/* overflow check */
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
+	tmp.name[sizeof(tmp.name)-1] = 0;
 
 	newinfo = xt_alloc_table_info(tmp.size);
 	if (!newinfo)
@@ -1455,6 +1456,7 @@ static int compat_do_replace(struct net *net, void __user *user,
 		return -ENOMEM;
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
+	tmp.name[sizeof(tmp.name)-1] = 0;
 
 	newinfo = xt_alloc_table_info(tmp.size);
 	if (!newinfo)
@@ -1710,6 +1712,7 @@ static int do_arpt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len
 			ret = -EFAULT;
 			break;
 		}
+		rev.name[sizeof(rev.name)-1] = 0;
 
 		try_then_request_module(xt_find_revision(NF_ARP, rev.name,
 							 rev.revision, 1, &ret),
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index b56a203..58a273d 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1276,6 +1276,7 @@ do_replace(struct net *net, void __user *user, unsigned int len)
 	/* overflow check */
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
+	tmp.name[sizeof(tmp.name)-1] = 0;
 
 	newinfo = xt_alloc_table_info(tmp.size);
 	if (!newinfo)
@@ -1808,6 +1809,7 @@ compat_do_replace(struct net *net, void __user *user, unsigned int len)
 		return -ENOMEM;
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
+	tmp.name[sizeof(tmp.name)-1] = 0;
 
 	newinfo = xt_alloc_table_info(tmp.size);
 	if (!newinfo)
@@ -2032,6 +2034,7 @@ do_ipt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 			ret = -EFAULT;
 			break;
 		}
+		rev.name[sizeof(rev.name)-1] = 0;
 
 		if (cmd == IPT_SO_GET_REVISION_TARGET)
 			target = 1;
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index fafe8eb..b41b9b1 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -672,8 +672,11 @@ static ssize_t clusterip_proc_write(struct file *file, const char __user *input,
 	struct clusterip_config *c = pde->data;
 	unsigned long nodenum;
 
-	if (copy_from_user(buffer, input, PROC_WRITELEN))
+	if (size > PROC_WRITELEN)
+		return -EIO;
+	if (copy_from_user(buffer, input, size))
 		return -EFAULT;
+	buffer[size] = 0;
 
 	if (*buffer == '+') {
 		nodenum = simple_strtoul(buffer+1, NULL, 10);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index dc2caaf..268426d 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1256,6 +1256,7 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 		sk_eat_skb(sk, skb, 0);
 		if (!desc->count)
 			break;
+		tp->copied_seq = seq;
 	}
 	tp->copied_seq = seq;
 
@@ -2033,7 +2034,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		/* Values greater than interface MTU won't take effect. However
 		 * at the point when this call is done we typically don't yet
 		 * know which interface is going to be used */
-		if (val < 8 || val > MAX_TCP_WINDOW) {
+		if (val < TCP_MIN_MSS || val > MAX_TCP_WINDOW) {
 			err = -EINVAL;
 			break;
 		}
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 81751c3..7eda3bf 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1303,6 +1303,7 @@ do_replace(struct net *net, void __user *user, unsigned int len)
 	/* overflow check */
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
+	tmp.name[sizeof(tmp.name)-1] = 0;
 
 	newinfo = xt_alloc_table_info(tmp.size);
 	if (!newinfo)
@@ -1835,6 +1836,7 @@ compat_do_replace(struct net *net, void __user *user, unsigned int len)
 		return -ENOMEM;
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
+	tmp.name[sizeof(tmp.name)-1] = 0;
 
 	newinfo = xt_alloc_table_info(tmp.size);
 	if (!newinfo)
@@ -2059,6 +2061,7 @@ do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 			ret = -EFAULT;
 			break;
 		}
+		rev.name[sizeof(rev.name)-1] = 0;
 
 		if (cmd == IP6T_SO_GET_REVISION_TARGET)
 			target = 1;
diff --git a/net/irda/af_irda.c b/net/irda/af_irda.c
index b28409c..e71364b 100644
--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -2165,6 +2165,14 @@ static int irda_getsockopt(struct socket *sock, int level, int optname,
 
 	switch (optname) {
 	case IRLMP_ENUMDEVICES:
+
+		/* Offset to first device entry */
+		offset = sizeof(struct irda_device_list) -
+			sizeof(struct irda_device_info);
+
+		if (len < offset)
+			return -EINVAL;
+
 		/* Ask lmp for the current discovery log */
 		discoveries = irlmp_get_discoveries(&list.len, self->mask.word,
 						    self->nslots);
@@ -2174,15 +2182,9 @@ static int irda_getsockopt(struct socket *sock, int level, int optname,
 		err = 0;
 
 		/* Write total list length back to client */
-		if (copy_to_user(optval, &list,
-				 sizeof(struct irda_device_list) -
-				 sizeof(struct irda_device_info)))
+		if (copy_to_user(optval, &list, offset))
 			err = -EFAULT;
 
-		/* Offset to first device entry */
-		offset = sizeof(struct irda_device_list) -
-			sizeof(struct irda_device_info);
-
 		/* Copy the list itself - watch for overflow */
 		if(list.len > 2048)
 		{
diff --git a/net/irda/iriap.c b/net/irda/iriap.c
index 1c33994..e6a5857 100644
--- a/net/irda/iriap.c
+++ b/net/irda/iriap.c
@@ -655,10 +655,16 @@ static void iriap_getvaluebyclass_indication(struct iriap_cb *self,
 	n = 1;
 
 	name_len = fp[n++];
+
+	IRDA_ASSERT(name_len < IAS_MAX_CLASSNAME + 1, return;);
+
 	memcpy(name, fp+n, name_len); n+=name_len;
 	name[name_len] = '\0';
 
 	attr_len = fp[n++];
+
+	IRDA_ASSERT(attr_len < IAS_MAX_ATTRIBNAME + 1, return;);
+
 	memcpy(attr, fp+n, attr_len); n+=attr_len;
 	attr[attr_len] = '\0';
 
diff --git a/net/irda/irnet/irnet_ppp.c b/net/irda/irnet/irnet_ppp.c
index 6d8ae03..8f5664f 100644
--- a/net/irda/irnet/irnet_ppp.c
+++ b/net/irda/irnet/irnet_ppp.c
@@ -104,6 +104,9 @@ irnet_ctrl_write(irnet_socket *	ap,
 	      while(isspace(start[length - 1]))
 		length--;
 
+	      DABORT(length < 5 || length > NICKNAME_MAX_LEN + 5,
+		     -EINVAL, CTRL_ERROR, "Invalid nickname.\n");
+
 	      /* Copy the name for later reuse */
 	      memcpy(ap->rname, start + 5, length - 5);
 	      ap->rname[length - 5] = '\0';
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f2ba653..104b48b 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -241,6 +241,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	memcpy(sta->addr, addr, ETH_ALEN);
 	sta->local = local;
 	sta->sdata = sdata;
+	sta->last_rx = jiffies;
 
 	sta->rate_ctrl = rate_control_get(local->rate_ctrl);
 	sta->rate_ctrl_priv = rate_control_alloc_sta(sta->rate_ctrl,
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index ade1ebd..45dfb94 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1208,7 +1208,7 @@ static int packet_getname_spkt(struct socket *sock, struct sockaddr *uaddr,
 	uaddr->sa_family = AF_PACKET;
 	dev = dev_get_by_index(sock_net(sk), pkt_sk(sk)->ifindex);
 	if (dev) {
-		strlcpy(uaddr->sa_data, dev->name, 15);
+		strncpy(uaddr->sa_data, dev->name, 14);
 		dev_put(dev);
 	} else
 		memset(uaddr->sa_data, 0, 14);
@@ -1231,6 +1231,7 @@ static int packet_getname(struct socket *sock, struct sockaddr *uaddr,
 	sll->sll_family = AF_PACKET;
 	sll->sll_ifindex = po->ifindex;
 	sll->sll_protocol = po->num;
+	sll->sll_pkttype = 0;
 	dev = dev_get_by_index(sock_net(sk), po->ifindex);
 	if (dev) {
 		sll->sll_hatype = dev->type;
diff --git a/net/rose/rose_subr.c b/net/rose/rose_subr.c
index b05108f..07bca7d 100644
--- a/net/rose/rose_subr.c
+++ b/net/rose/rose_subr.c
@@ -289,10 +289,15 @@ static int rose_parse_national(unsigned char *p, struct rose_facilities_struct *
 				facilities->source_ndigis = 0;
 				facilities->dest_ndigis   = 0;
 				for (pt = p + 2, lg = 0 ; lg < l ; pt += AX25_ADDR_LEN, lg += AX25_ADDR_LEN) {
-					if (pt[6] & AX25_HBIT)
+					if (pt[6] & AX25_HBIT) {
+						if (facilities->dest_ndigis >= ROSE_MAX_DIGIS)
+							return -1;
 						memcpy(&facilities->dest_digis[facilities->dest_ndigis++], pt, AX25_ADDR_LEN);
-					else
+					} else {
+						if (facilities->source_ndigis >= ROSE_MAX_DIGIS)
+							return -1;
 						memcpy(&facilities->source_digis[facilities->source_ndigis++], pt, AX25_ADDR_LEN);
+					}
 				}
 			}
 			p   += l + 2;
@@ -332,6 +337,11 @@ static int rose_parse_ccitt(unsigned char *p, struct rose_facilities_struct *fac
 
 		case 0xC0:
 			l = p[1];
+
+			/* Prevent overflows*/
+			if (l < 10 || l > 20)
+				return -1;
+
 			if (*p == FAC_CCITT_DEST_NSAP) {
 				memcpy(&facilities->source_addr, p + 7, ROSE_ADDR_LEN);
 				memcpy(callsign, p + 12,   l - 10);
@@ -372,12 +382,16 @@ int rose_parse_facilities(unsigned char *p,
 			switch (*p) {
 			case FAC_NATIONAL:		/* National */
 				len = rose_parse_national(p + 1, facilities, facilities_len - 1);
+				if (len < 0)
+					return 0;
 				facilities_len -= len + 1;
 				p += len + 1;
 				break;
 
 			case FAC_CCITT:		/* CCITT */
 				len = rose_parse_ccitt(p + 1, facilities, facilities_len - 1);
+				if (len < 0)
+					return 0;
 				facilities_len -= len + 1;
 				p += len + 1;
 				break;
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 52db5f6..1ca7e4d 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -542,16 +542,20 @@ struct sctp_hmac *sctp_auth_asoc_get_hmac(const struct sctp_association *asoc)
 		id = ntohs(hmacs->hmac_ids[i]);
 
 		/* Check the id is in the supported range */
-		if (id > SCTP_AUTH_HMAC_ID_MAX)
+		if (id > SCTP_AUTH_HMAC_ID_MAX) {
+			id = 0;
 			continue;
+		}
 
 		/* See is we support the id.  Supported IDs have name and
 		 * length fields set, so that we can allocated and use
 		 * them.  We can safely just check for name, for without the
 		 * name, we can't allocate the TFM.
 		 */
-		if (!sctp_hmac_list[id].hmac_name)
+		if (!sctp_hmac_list[id].hmac_name) {
+			id = 0;
 			continue;
+		}
 
 		break;
 	}
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index baf2fa4..ad54b46 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -230,7 +230,8 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 	sp = sctp_sk(asoc->base.sk);
 	num_types = sp->pf->supported_addrs(sp, types);
 
-	chunksize = sizeof(init) + addrs_len + SCTP_SAT_LEN(num_types);
+	chunksize = sizeof(init) + addrs_len;
+	chunksize += WORD_ROUND(SCTP_SAT_LEN(num_types));
 	chunksize += sizeof(ecap_param);
 
 	if (sctp_prsctp_enable)
@@ -258,14 +259,14 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 		/* Add HMACS parameter length if any were defined */
 		auth_hmacs = (sctp_paramhdr_t *)asoc->c.auth_hmacs;
 		if (auth_hmacs->length)
-			chunksize += ntohs(auth_hmacs->length);
+			chunksize += WORD_ROUND(ntohs(auth_hmacs->length));
 		else
 			auth_hmacs = NULL;
 
 		/* Add CHUNKS parameter length */
 		auth_chunks = (sctp_paramhdr_t *)asoc->c.auth_chunks;
 		if (auth_chunks->length)
-			chunksize += ntohs(auth_chunks->length);
+			chunksize += WORD_ROUND(ntohs(auth_chunks->length));
 		else
 			auth_chunks = NULL;
 
@@ -275,7 +276,8 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 
 	/* If we have any extensions to report, account for that */
 	if (num_ext)
-		chunksize += sizeof(sctp_supported_ext_param_t) + num_ext;
+		chunksize += WORD_ROUND(sizeof(sctp_supported_ext_param_t) +
+					num_ext);
 
 	/* RFC 2960 3.3.2 Initiation (INIT) (1)
 	 *
@@ -412,13 +414,13 @@ struct sctp_chunk *sctp_make_init_ack(const struct sctp_association *asoc,
 
 		auth_hmacs = (sctp_paramhdr_t *)asoc->c.auth_hmacs;
 		if (auth_hmacs->length)
-			chunksize += ntohs(auth_hmacs->length);
+			chunksize += WORD_ROUND(ntohs(auth_hmacs->length));
 		else
 			auth_hmacs = NULL;
 
 		auth_chunks = (sctp_paramhdr_t *)asoc->c.auth_chunks;
 		if (auth_chunks->length)
-			chunksize += ntohs(auth_chunks->length);
+			chunksize += WORD_ROUND(ntohs(auth_chunks->length));
 		else
 			auth_chunks = NULL;
 
@@ -427,7 +429,8 @@ struct sctp_chunk *sctp_make_init_ack(const struct sctp_association *asoc,
 	}
 
 	if (num_ext)
-		chunksize += sizeof(sctp_supported_ext_param_t) + num_ext;
+		chunksize += WORD_ROUND(sizeof(sctp_supported_ext_param_t) +
+					num_ext);
 
 	/* Now allocate and fill out the chunk.  */
 	retval = sctp_make_chunk(asoc, SCTP_CID_INIT_ACK, 0, chunksize);
@@ -3342,21 +3345,6 @@ int sctp_process_asconf_ack(struct sctp_association *asoc,
 	sctp_chunk_free(asconf);
 	asoc->addip_last_asconf = NULL;
 
-	/* Send the next asconf chunk from the addip chunk queue. */
-	if (!list_empty(&asoc->addip_chunk_list)) {
-		struct list_head *entry = asoc->addip_chunk_list.next;
-		asconf = list_entry(entry, struct sctp_chunk, list);
-
-		list_del_init(entry);
-
-		/* Hold the chunk until an ASCONF_ACK is received. */
-		sctp_chunk_hold(asconf);
-		if (sctp_primitive_ASCONF(asoc, asconf))
-			sctp_chunk_free(asconf);
-		else
-			asoc->addip_last_asconf = asconf;
-	}
-
 	return retval;
 }
 
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 06757c4..87d42b8 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -630,6 +630,29 @@ static void sctp_cmd_t3_rtx_timers_stop(sctp_cmd_seq_t *cmds,
 	}
 }
 
+/* Sent the next ASCONF packet currently stored in the association.
+ * This happens after the ASCONF_ACK was succeffully processed.
+ */
+static void sctp_cmd_send_asconf(struct sctp_association *asoc)
+{
+	/* Send the next asconf chunk from the addip chunk
+	 * queue.
+	 */
+	if (!list_empty(&asoc->addip_chunk_list)) {
+		struct list_head *entry = asoc->addip_chunk_list.next;
+		struct sctp_chunk *asconf = list_entry(entry,
+						struct sctp_chunk, list);
+		list_del_init(entry);
+
+		/* Hold the chunk until an ASCONF_ACK is received. */
+		sctp_chunk_hold(asconf);
+		if (sctp_primitive_ASCONF(asoc, asconf))
+			sctp_chunk_free(asconf);
+		else
+			asoc->addip_last_asconf = asconf;
+	}
+}
+
 
 /* Helper function to update the heartbeat timer. */
 static void sctp_cmd_hb_timer_update(sctp_cmd_seq_t *cmds,
@@ -845,6 +868,9 @@ static void sctp_cmd_process_operr(sctp_cmd_seq_t *cmds,
 			sctp_add_cmd_sf(cmds, SCTP_CMD_TIMER_STOP,
 					SCTP_TO(SCTP_EVENT_TIMEOUT_T4_RTO));
 			break;
+		case SCTP_CMD_SEND_NEXT_ASCONF:
+			sctp_cmd_send_asconf(asoc);
+			break;
 		default:
 			break;
 		}
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 649d174..75d33aa 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3587,8 +3587,14 @@ sctp_disposition_t sctp_sf_do_asconf_ack(const struct sctp_endpoint *ep,
 				SCTP_TO(SCTP_EVENT_TIMEOUT_T4_RTO));
 
 		if (!sctp_process_asconf_ack((struct sctp_association *)asoc,
-					     asconf_ack))
+					     asconf_ack)) {
+			/* Successfully processed ASCONF_ACK.  We can
+			 * release the next asconf if we have one.
+			 */
+			sctp_add_cmd_sf(commands, SCTP_CMD_SEND_NEXT_ASCONF,
+					SCTP_NULL());
 			return SCTP_DISPOSITION_CONSUME;
+		}
 
 		abort = sctp_make_abort(asoc, asconf_ack,
 					sizeof(sctp_errhdr_t));
diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index c996671..de1d0bf 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1252,8 +1252,10 @@ static int content_open(struct inode *inode, struct file *file)
 	struct cache_detail *cd = PDE(inode)->data;
 
 	han = __seq_open_private(file, &cache_content_op, sizeof(*han));
-	if (han == NULL)
+	if (han == NULL) {
+		module_put(cd->owner);
 		return -ENOMEM;
+	}
 
 	han->cd = cd;
 	return 0;
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 385f427..aad8362 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -629,14 +629,12 @@ static void __rpc_execute(struct rpc_task *task)
 			save_callback = task->tk_callback;
 			task->tk_callback = NULL;
 			save_callback(task);
-		}
-
-		/*
-		 * Perform the next FSM step.
-		 * tk_action may be NULL when the task has been killed
-		 * by someone else.
-		 */
-		if (!RPC_IS_QUEUED(task)) {
+		} else {
+			/*
+			 * Perform the next FSM step.
+			 * tk_action may be NULL when the task has been killed
+			 * by someone else.
+			 */
 			if (task->tk_action == NULL)
 				break;
 			task->tk_action(task);
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 1848693..71036fb 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -393,6 +393,7 @@ static int get_name(struct socket *sock, struct sockaddr *uaddr,
 	struct sockaddr_tipc *addr = (struct sockaddr_tipc *)uaddr;
 	struct tipc_sock *tsock = tipc_sk(sock->sk);
 
+	memset(addr, 0, sizeof(*addr));
 	if (peer) {
 		if ((sock->state != SS_CONNECTED) &&
 			((peer != 2) || (sock->state != SS_DISCONNECTING)))
diff --git a/net/x25/x25_link.c b/net/x25/x25_link.c
index e4e1b6e..3f1816a 100644
--- a/net/x25/x25_link.c
+++ b/net/x25/x25_link.c
@@ -391,8 +391,12 @@ void __exit x25_link_free(void)
 	write_lock_bh(&x25_neigh_list_lock);
 
 	list_for_each_safe(entry, tmp, &x25_neigh_list) {
+		struct net_device *dev;
+
 		nb = list_entry(entry, struct x25_neigh, node);
+		dev = nb->dev;
 		__x25_remove_neigh(nb);
+		dev_put(dev);
 	}
 	write_unlock_bh(&x25_neigh_list_lock);
 }
diff --git a/sound/oss/dev_table.h b/sound/oss/dev_table.h
index b7617be..0199a31 100644
--- a/sound/oss/dev_table.h
+++ b/sound/oss/dev_table.h
@@ -271,7 +271,7 @@ struct synth_operations
 	void (*reset) (int dev);
 	void (*hw_control) (int dev, unsigned char *event);
 	int (*load_patch) (int dev, int format, const char __user *addr,
-	     int offs, int count, int pmgr_flag);
+	     int count, int pmgr_flag);
 	void (*aftertouch) (int dev, int voice, int pressure);
 	void (*controller) (int dev, int voice, int ctrl_num, int value);
 	void (*panning) (int dev, int voice, int value);
diff --git a/sound/oss/midi_synth.c b/sound/oss/midi_synth.c
index 9e45098..978423e 100644
--- a/sound/oss/midi_synth.c
+++ b/sound/oss/midi_synth.c
@@ -476,7 +476,7 @@ EXPORT_SYMBOL(midi_synth_hw_control);
 
 int
 midi_synth_load_patch(int dev, int format, const char __user *addr,
-		      int offs, int count, int pmgr_flag)
+		      int count, int pmgr_flag)
 {
 	int             orig_dev = synth_devs[dev]->midi_dev;
 
@@ -491,39 +491,37 @@ midi_synth_load_patch(int dev, int format, const char __user *addr,
 	if (!prefix_cmd(orig_dev, 0xf0))
 		return 0;
 
+	/* Invalid patch format */
 	if (format != SYSEX_PATCH)
-	{
-/*		  printk("MIDI Error: Invalid patch format (key) 0x%x\n", format);*/
 		  return -EINVAL;
-	}
+
+	/* Patch header too short */
 	if (count < hdr_size)
-	{
-/*		printk("MIDI Error: Patch header too short\n");*/
 		return -EINVAL;
-	}
+
 	count -= hdr_size;
 
 	/*
-	 * Copy the header from user space but ignore the first bytes which have
-	 * been transferred already.
+	 * Copy the header from user space
 	 */
 
-	if(copy_from_user(&((char *) &sysex)[offs], &(addr)[offs], hdr_size - offs))
+	if (copy_from_user(&sysex, addr, hdr_size))
 		return -EFAULT;
- 
- 	if (count < sysex.len)
-	{
-/*		printk(KERN_WARNING "MIDI Warning: Sysex record too short (%d<%d)\n", count, (int) sysex.len);*/
+
+	/* Sysex record too short */
+	if ((unsigned)count < (unsigned)sysex.len)
 		sysex.len = count;
-	}
-  	left = sysex.len;
-  	src_offs = 0;
+
+	left = sysex.len;
+	src_offs = 0;
 
 	for (i = 0; i < left && !signal_pending(current); i++)
 	{
 		unsigned char   data;
 
-		get_user(*(unsigned char *) &data, (unsigned char __user *) &((addr)[hdr_size + i]));
+		if (get_user(data,
+		    (unsigned char __user *)(addr + hdr_size + i)))
+			return -EFAULT;
 
 		eox_seen = (i > 0 && data & 0x80);	/* End of sysex */
 
diff --git a/sound/oss/midi_synth.h b/sound/oss/midi_synth.h
index 6bc9d00..b64ddd6 100644
--- a/sound/oss/midi_synth.h
+++ b/sound/oss/midi_synth.h
@@ -8,7 +8,7 @@ int midi_synth_open (int dev, int mode);
 void midi_synth_close (int dev);
 void midi_synth_hw_control (int dev, unsigned char *event);
 int midi_synth_load_patch (int dev, int format, const char __user * addr,
-		 int offs, int count, int pmgr_flag);
+		 int count, int pmgr_flag);
 void midi_synth_panning (int dev, int channel, int pressure);
 void midi_synth_aftertouch (int dev, int channel, int pressure);
 void midi_synth_controller (int dev, int channel, int ctrl_num, int value);
diff --git a/sound/oss/opl3.c b/sound/oss/opl3.c
index 7781c13..4e912dd 100644
--- a/sound/oss/opl3.c
+++ b/sound/oss/opl3.c
@@ -819,7 +819,7 @@ static void opl3_hw_control(int dev, unsigned char *event)
 }
 
 static int opl3_load_patch(int dev, int format, const char __user *addr,
-		int offs, int count, int pmgr_flag)
+		int count, int pmgr_flag)
 {
 	struct sbi_instrument ins;
 
@@ -829,11 +829,7 @@ static int opl3_load_patch(int dev, int format, const char __user *addr,
 		return -EINVAL;
 	}
 
-	/*
-	 * What the fuck is going on here?  We leave junk in the beginning
-	 * of ins and then check the field pretty close to that beginning?
-	 */
-	if(copy_from_user(&((char *) &ins)[offs], addr + offs, sizeof(ins) - offs))
+	if (copy_from_user(&ins, addr, sizeof(ins)))
 		return -EFAULT;
 
 	if (ins.channel < 0 || ins.channel >= SBFM_MAXINSTR)
@@ -848,6 +844,10 @@ static int opl3_load_patch(int dev, int format, const char __user *addr,
 
 static void opl3_panning(int dev, int voice, int value)
 {
+
+	if (voice < 0 || voice >= devc->nr_voice)
+		return;
+
 	devc->voc[voice].panning = value;
 }
 
@@ -1065,8 +1065,15 @@ static int opl3_alloc_voice(int dev, int chn, int note, struct voice_alloc_info
 
 static void opl3_setup_voice(int dev, int voice, int chn)
 {
-	struct channel_info *info =
-	&synth_devs[dev]->chn_info[chn];
+	struct channel_info *info;
+
+	if (voice < 0 || voice >= devc->nr_voice)
+		return;
+
+	if (chn < 0 || chn > 15)
+		return;
+
+	info = &synth_devs[dev]->chn_info[chn];
 
 	opl3_set_instr(dev, voice, info->pgm_num);
 
diff --git a/sound/oss/sequencer.c b/sound/oss/sequencer.c
index 5c215f7..7027b8d 100644
--- a/sound/oss/sequencer.c
+++ b/sound/oss/sequencer.c
@@ -242,7 +242,7 @@ int sequencer_write(int dev, struct file *file, const char __user *buf, int coun
 				return -ENXIO;
 
 			fmt = (*(short *) &event_rec[0]) & 0xffff;
-			err = synth_devs[dev]->load_patch(dev, fmt, buf, p + 4, c, 0);
+			err = synth_devs[dev]->load_patch(dev, fmt, buf + p, c, 0);
 			if (err < 0)
 				return err;
 
diff --git a/sound/pci/au88x0/au88x0_pcm.c b/sound/pci/au88x0/au88x0_pcm.c
index f9a58b4..9f87141 100644
--- a/sound/pci/au88x0/au88x0_pcm.c
+++ b/sound/pci/au88x0/au88x0_pcm.c
@@ -42,11 +42,7 @@ static struct snd_pcm_hardware snd_vortex_playback_hw_adb = {
 	.rate_min = 5000,
 	.rate_max = 48000,
 	.channels_min = 1,
-#ifdef CHIP_AU8830
-	.channels_max = 4,
-#else
 	.channels_max = 2,
-#endif
 	.buffer_bytes_max = 0x10000,
 	.period_bytes_min = 0x1,
 	.period_bytes_max = 0x1000,
@@ -115,6 +111,17 @@ static struct snd_pcm_hardware snd_vortex_playback_hw_wt = {
 	.periods_max = 64,
 };
 #endif
+#ifdef CHIP_AU8830
+static unsigned int au8830_channels[3] = {
+	1, 2, 4,
+};
+
+static struct snd_pcm_hw_constraint_list hw_constraints_au8830_channels = {
+	.count = ARRAY_SIZE(au8830_channels),
+	.list = au8830_channels,
+	.mask = 0,
+};
+#endif
 /* open callback */
 static int snd_vortex_pcm_open(struct snd_pcm_substream *substream)
 {
@@ -156,6 +163,15 @@ static int snd_vortex_pcm_open(struct snd_pcm_substream *substream)
 		if (VORTEX_PCM_TYPE(substream->pcm) == VORTEX_PCM_ADB
 		    || VORTEX_PCM_TYPE(substream->pcm) == VORTEX_PCM_I2S)
 			runtime->hw = snd_vortex_playback_hw_adb;
+#ifdef CHIP_AU8830
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK &&
+			VORTEX_PCM_TYPE(substream->pcm) == VORTEX_PCM_ADB) {
+			runtime->hw.channels_max = 4;
+			snd_pcm_hw_constraint_list(runtime, 0,
+				SNDRV_PCM_HW_PARAM_CHANNELS,
+				&hw_constraints_au8830_channels);
+		}
+#endif
 		substream->runtime->private_data = NULL;
 	}
 #ifndef CHIP_AU8810
diff --git a/sound/pci/ens1370.c b/sound/pci/ens1370.c
index 9bf9536..1b50ed5 100644
--- a/sound/pci/ens1370.c
+++ b/sound/pci/ens1370.c
@@ -229,6 +229,7 @@ MODULE_PARM_DESC(lineio, "Line In to Rear Out (0 = auto, 1 = force).");
 #define ES_REG_1371_CODEC 0x14	/* W/R: Codec Read/Write register address */
 #define   ES_1371_CODEC_RDY	   (1<<31)	/* codec ready */
 #define   ES_1371_CODEC_WIP	   (1<<30)	/* codec register access in progress */
+#define   EV_1938_CODEC_MAGIC	   (1<<26)
 #define   ES_1371_CODEC_PIRD	   (1<<23)	/* codec read/write select register */
 #define   ES_1371_CODEC_WRITE(a,d) ((((a)&0x7f)<<16)|(((d)&0xffff)<<0))
 #define   ES_1371_CODEC_READS(a)   ((((a)&0x7f)<<16)|ES_1371_CODEC_PIRD)
@@ -602,12 +603,18 @@ static void snd_es1370_codec_write(struct snd_ak4531 *ak4531,
 
 #ifdef CHIP1371
 
+static inline bool is_ev1938(struct ensoniq *ensoniq)
+{
+	return ensoniq->pci->device == 0x8938;
+}
+
 static void snd_es1371_codec_write(struct snd_ac97 *ac97,
 				   unsigned short reg, unsigned short val)
 {
 	struct ensoniq *ensoniq = ac97->private_data;
-	unsigned int t, x;
+	unsigned int t, x, flag;
 
+	flag = is_ev1938(ensoniq) ? EV_1938_CODEC_MAGIC : 0;
 	mutex_lock(&ensoniq->src_mutex);
 	for (t = 0; t < POLL_COUNT; t++) {
 		if (!(inl(ES_REG(ensoniq, 1371_CODEC)) & ES_1371_CODEC_WIP)) {
@@ -629,7 +636,8 @@ static void snd_es1371_codec_write(struct snd_ac97 *ac97,
 				    0x00010000)
 					break;
 			}
-			outl(ES_1371_CODEC_WRITE(reg, val), ES_REG(ensoniq, 1371_CODEC));
+			outl(ES_1371_CODEC_WRITE(reg, val) | flag,
+			     ES_REG(ensoniq, 1371_CODEC));
 			/* restore SRC reg */
 			snd_es1371_wait_src_ready(ensoniq);
 			outl(x, ES_REG(ensoniq, 1371_SMPRATE));
@@ -646,8 +654,9 @@ static unsigned short snd_es1371_codec_read(struct snd_ac97 *ac97,
 					    unsigned short reg)
 {
 	struct ensoniq *ensoniq = ac97->private_data;
-	unsigned int t, x, fail = 0;
+	unsigned int t, x, flag, fail = 0;
 
+	flag = is_ev1938(ensoniq) ? EV_1938_CODEC_MAGIC : 0;
       __again:
 	mutex_lock(&ensoniq->src_mutex);
 	for (t = 0; t < POLL_COUNT; t++) {
@@ -670,7 +679,8 @@ static unsigned short snd_es1371_codec_read(struct snd_ac97 *ac97,
 				    0x00010000)
 					break;
 			}
-			outl(ES_1371_CODEC_READS(reg), ES_REG(ensoniq, 1371_CODEC));
+			outl(ES_1371_CODEC_READS(reg) | flag,
+			     ES_REG(ensoniq, 1371_CODEC));
 			/* restore SRC reg */
 			snd_es1371_wait_src_ready(ensoniq);
 			outl(x, ES_REG(ensoniq, 1371_SMPRATE));
@@ -682,6 +692,11 @@ static unsigned short snd_es1371_codec_read(struct snd_ac97 *ac97,
 			/* now wait for the stinkin' data (RDY) */
 			for (t = 0; t < POLL_COUNT; t++) {
 				if ((x = inl(ES_REG(ensoniq, 1371_CODEC))) & ES_1371_CODEC_RDY) {
+					if (is_ev1938(ensoniq)) {
+						for (t = 0; t < 100; t++)
+							inl(ES_REG(ensoniq, CONTROL));
+						x = inl(ES_REG(ensoniq, 1371_CODEC));
+					}
 					mutex_unlock(&ensoniq->src_mutex);
 					return ES_1371_CODEC_READ(x);
 				}

