Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab1CQJ6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 05:58:52 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:36911 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab1CQJ6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 05:58:48 -0400
Date: Thu, 17 Mar 2011 10:58:41 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.39
Message-ID: <20110317105841.17dc5d5c@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

Heiko Carstens (3):
      [S390] dasd: get rid of compile warning
      [S390] support XZ compressed kernel
      [S390] kexec: Disable ftrace during kexec

Jan Glauber (2):
      [S390] remove redundant stack check option
      [S390] Write protect module text and RO data

Sebastian Ott (10):
      [S390] remove superfluous check from do_IRQ
      [S390] cio: move orb definitions to separate header
      [S390] cio: move asms to generic header
      [S390] cio: move options to io_sch_private
      [S390] cio: move cdev pointer to io_subchannel_private
      [S390] css: move io_private to drv_data
      [S390] css: move chsc_private to drv_data
      [S390] css: remove subchannel private
      [S390] css_driver: remove duplicate members
      [S390] css_bus_type: make it static

 arch/s390/Kconfig                  |   21 ++-----
 arch/s390/Kconfig.debug            |    3 +
 arch/s390/Makefile                 |    3 +-
 arch/s390/boot/compressed/Makefile |    6 ++-
 arch/s390/boot/compressed/misc.c   |    5 ++
 arch/s390/include/asm/cacheflush.h |    4 +
 arch/s390/kernel/machine_kexec.c   |    2 +
 arch/s390/mm/Makefile              |    1 +
 arch/s390/mm/pageattr.c            |   55 +++++++++++++++++
 drivers/s390/block/dasd_eckd.c     |    1 +
 drivers/s390/cio/chsc_sch.c        |   17 +++--
 drivers/s390/cio/cio.c             |   43 ++++----------
 drivers/s390/cio/cio.h             |   11 ----
 drivers/s390/cio/css.c             |    6 +-
 drivers/s390/cio/css.h             |   10 ---
 drivers/s390/cio/device.c          |   23 +++++---
 drivers/s390/cio/io_sch.h          |  114 ++++++++----------------------------
 drivers/s390/cio/ioasm.h           |   34 +++++++++++
 drivers/s390/cio/orb.h             |   67 +++++++++++++++++++++
 19 files changed, 248 insertions(+), 178 deletions(-)
 create mode 100644 arch/s390/mm/pageattr.c
 create mode 100644 drivers/s390/cio/orb.h

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 636bcb8..2508a6f 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -85,6 +85,7 @@ config S390
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
 	select HAVE_KERNEL_LZO
+	select HAVE_KERNEL_XZ
 	select HAVE_GET_USER_PAGES_FAST
 	select HAVE_ARCH_MUTEX_CPU_RELAX
 	select ARCH_INLINE_SPIN_TRYLOCK
@@ -341,26 +342,16 @@ config STACK_GUARD
 	  The minimum size for the stack guard should be 256 for 31 bit and
 	  512 for 64 bit.
 
-config WARN_STACK
+config WARN_DYNAMIC_STACK
 	def_bool n
-	prompt "Emit compiler warnings for function with broken stack usage"
+	prompt "Emit compiler warnings for function with dynamic stack usage"
 	help
-	  This option enables the compiler options -mwarn-framesize and
-	  -mwarn-dynamicstack. If the compiler supports these options it
-	  will generate warnings for function which either use alloca or
-	  create a stack frame bigger than CONFIG_WARN_STACK_SIZE.
+	  This option enables the compiler option -mwarn-dynamicstack. If the
+	  compiler supports this options generates warnings for functions
+	  that dynamically allocate stack space using alloca.
 
 	  Say N if you are unsure.
 
-config WARN_STACK_SIZE
-	int "Maximum frame size considered safe (128-2048)"
-	range 128 2048
-	depends on WARN_STACK
-	default "2048"
-	help
-	  This allows you to specify the maximum frame size a function may
-	  have without the compiler complaining about it.
-
 config ARCH_POPULATES_NODE_MAP
 	def_bool y
 
diff --git a/arch/s390/Kconfig.debug b/arch/s390/Kconfig.debug
index 2b380df..d76cef3 100644
--- a/arch/s390/Kconfig.debug
+++ b/arch/s390/Kconfig.debug
@@ -31,4 +31,7 @@ config DEBUG_STRICT_USER_COPY_CHECKS
 
 	  If unsure, or if you run an older (pre 4.4) gcc, say N.
 
+config DEBUG_SET_MODULE_RONX
+	def_bool y
+	depends on MODULES
 endmenu
diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index d5b8a6a..27a0b5d 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -80,8 +80,7 @@ endif
 endif
 
 ifeq ($(call cc-option-yn,-mwarn-dynamicstack),y)
-cflags-$(CONFIG_WARN_STACK) += -mwarn-dynamicstack
-cflags-$(CONFIG_WARN_STACK) += -mwarn-framesize=$(CONFIG_WARN_STACK_SIZE)
+cflags-$(CONFIG_WARN_DYNAMIC_STACK) += -mwarn-dynamicstack
 endif
 
 KBUILD_CFLAGS	+= -mbackchain -msoft-float $(cflags-y)
diff --git a/arch/s390/boot/compressed/Makefile b/arch/s390/boot/compressed/Makefile
index 1c999f7..10e22c4 100644
--- a/arch/s390/boot/compressed/Makefile
+++ b/arch/s390/boot/compressed/Makefile
@@ -7,7 +7,8 @@
 BITS := $(if $(CONFIG_64BIT),64,31)
 
 targets	:= vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 \
-	   vmlinux.bin.lzma vmlinux.bin.lzo misc.o piggy.o sizes.h head$(BITS).o
+	   vmlinux.bin.xz vmlinux.bin.lzma vmlinux.bin.lzo misc.o piggy.o \
+	   sizes.h head$(BITS).o
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += $(cflags-y)
@@ -48,6 +49,7 @@ suffix-$(CONFIG_KERNEL_GZIP)  := gz
 suffix-$(CONFIG_KERNEL_BZIP2) := bz2
 suffix-$(CONFIG_KERNEL_LZMA)  := lzma
 suffix-$(CONFIG_KERNEL_LZO)  := lzo
+suffix-$(CONFIG_KERNEL_XZ)  := xz
 
 $(obj)/vmlinux.bin.gz: $(vmlinux.bin.all-y)
 	$(call if_changed,gzip)
@@ -57,6 +59,8 @@ $(obj)/vmlinux.bin.lzma: $(vmlinux.bin.all-y)
 	$(call if_changed,lzma)
 $(obj)/vmlinux.bin.lzo: $(vmlinux.bin.all-y)
 	$(call if_changed,lzo)
+$(obj)/vmlinux.bin.xz: $(vmlinux.bin.all-y)
+	$(call if_changed,xzkern)
 
 LDFLAGS_piggy.o := -r --format binary --oformat $(LD_BFD) -T
 $(obj)/piggy.o: $(obj)/vmlinux.scr $(obj)/vmlinux.bin.$(suffix-y)
diff --git a/arch/s390/boot/compressed/misc.c b/arch/s390/boot/compressed/misc.c
index 2751b3a..028f23e 100644
--- a/arch/s390/boot/compressed/misc.c
+++ b/arch/s390/boot/compressed/misc.c
@@ -19,6 +19,7 @@
 #undef memset
 #undef memcpy
 #undef memmove
+#define memmove memmove
 #define memzero(s, n) memset((s), 0, (n))
 
 /* Symbols defined by linker scripts */
@@ -54,6 +55,10 @@ static unsigned long free_mem_end_ptr;
 #include "../../../../lib/decompress_unlzo.c"
 #endif
 
+#ifdef CONFIG_KERNEL_XZ
+#include "../../../../lib/decompress_unxz.c"
+#endif
+
 extern _sclp_print_early(const char *);
 
 int puts(const char *s)
diff --git a/arch/s390/include/asm/cacheflush.h b/arch/s390/include/asm/cacheflush.h
index 7e1f776..43a5c78 100644
--- a/arch/s390/include/asm/cacheflush.h
+++ b/arch/s390/include/asm/cacheflush.h
@@ -8,4 +8,8 @@
 void kernel_map_pages(struct page *page, int numpages, int enable);
 #endif
 
+int set_memory_ro(unsigned long addr, int numpages);
+int set_memory_rw(unsigned long addr, int numpages);
+int set_memory_nx(unsigned long addr, int numpages);
+
 #endif /* _S390_CACHEFLUSH_H */
diff --git a/arch/s390/kernel/machine_kexec.c b/arch/s390/kernel/machine_kexec.c
index a922d51..b09b9c6 100644
--- a/arch/s390/kernel/machine_kexec.c
+++ b/arch/s390/kernel/machine_kexec.c
@@ -12,6 +12,7 @@
 #include <linux/kexec.h>
 #include <linux/delay.h>
 #include <linux/reboot.h>
+#include <linux/ftrace.h>
 #include <asm/cio.h>
 #include <asm/setup.h>
 #include <asm/pgtable.h>
@@ -71,6 +72,7 @@ static void __machine_kexec(void *data)
 
 void machine_kexec(struct kimage *image)
 {
+	tracer_disable();
 	smp_send_stop();
 	smp_switch_to_ipl_cpu(__machine_kexec, image);
 }
diff --git a/arch/s390/mm/Makefile b/arch/s390/mm/Makefile
index 6fbc6f3..d98fe90 100644
--- a/arch/s390/mm/Makefile
+++ b/arch/s390/mm/Makefile
@@ -6,3 +6,4 @@ obj-y	 := init.o fault.o extmem.o mmap.o vmem.o pgtable.o maccess.o \
 	    page-states.o gup.o
 obj-$(CONFIG_CMM) += cmm.o
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
+obj-$(CONFIG_DEBUG_SET_MODULE_RONX) += pageattr.o
diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c
new file mode 100644
index 0000000..122ffbd
--- /dev/null
+++ b/arch/s390/mm/pageattr.c
@@ -0,0 +1,55 @@
+/*
+ * Copyright IBM Corp. 2011
+ * Author(s): Jan Glauber <jang@linux.vnet.ibm.com>
+ */
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/hugetlb.h>
+#include <asm/pgtable.h>
+
+static void change_page_attr(unsigned long addr, int numpages,
+			     pte_t (*set) (pte_t))
+{
+	pte_t *ptep, pte;
+	pmd_t *pmdp;
+	pud_t *pudp;
+	pgd_t *pgdp;
+	int i;
+
+	for (i = 0; i < numpages; i++) {
+		pgdp = pgd_offset(&init_mm, addr);
+		pudp = pud_offset(pgdp, addr);
+		pmdp = pmd_offset(pudp, addr);
+		if (pmd_huge(*pmdp)) {
+			WARN_ON_ONCE(1);
+			continue;
+		}
+		ptep = pte_offset_kernel(pmdp, addr + i * PAGE_SIZE);
+
+		pte = *ptep;
+		pte = set(pte);
+		ptep_invalidate(&init_mm, addr + i * PAGE_SIZE, ptep);
+		*ptep = pte;
+	}
+}
+
+int set_memory_ro(unsigned long addr, int numpages)
+{
+	change_page_attr(addr, numpages, pte_wrprotect);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(set_memory_ro);
+
+int set_memory_rw(unsigned long addr, int numpages)
+{
+	change_page_attr(addr, numpages, pte_mkwrite);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(set_memory_rw);
+
+/* not possible */
+int set_memory_nx(unsigned long addr, int numpages)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(set_memory_nx);
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index a9fe23d..379d859 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -2648,6 +2648,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 		dasd_sfree_request(cqr, startdev);
 		return ERR_PTR(-EAGAIN);
 	}
+	len_to_track_end = 0;
 	/*
 	 * A tidaw can address 4k of memory, but must not cross page boundaries
 	 * We can let the block layer handle this by setting
diff --git a/drivers/s390/cio/chsc_sch.c b/drivers/s390/cio/chsc_sch.c
index 3c3f3ff..e950f1a 100644
--- a/drivers/s390/cio/chsc_sch.c
+++ b/drivers/s390/cio/chsc_sch.c
@@ -50,7 +50,7 @@ MODULE_LICENSE("GPL");
 
 static void chsc_subchannel_irq(struct subchannel *sch)
 {
-	struct chsc_private *private = sch->private;
+	struct chsc_private *private = dev_get_drvdata(&sch->dev);
 	struct chsc_request *request = private->request;
 	struct irb *irb = (struct irb *)&S390_lowcore.irb;
 
@@ -80,13 +80,14 @@ static int chsc_subchannel_probe(struct subchannel *sch)
 	private = kzalloc(sizeof(*private), GFP_KERNEL);
 	if (!private)
 		return -ENOMEM;
+	dev_set_drvdata(&sch->dev, private);
 	ret = cio_enable_subchannel(sch, (u32)(unsigned long)sch);
 	if (ret) {
 		CHSC_MSG(0, "Failed to enable 0.%x.%04x: %d\n",
 			 sch->schid.ssid, sch->schid.sch_no, ret);
+		dev_set_drvdata(&sch->dev, NULL);
 		kfree(private);
 	} else {
-		sch->private = private;
 		if (dev_get_uevent_suppress(&sch->dev)) {
 			dev_set_uevent_suppress(&sch->dev, 0);
 			kobject_uevent(&sch->dev.kobj, KOBJ_ADD);
@@ -100,8 +101,8 @@ static int chsc_subchannel_remove(struct subchannel *sch)
 	struct chsc_private *private;
 
 	cio_disable_subchannel(sch);
-	private = sch->private;
-	sch->private = NULL;
+	private = dev_get_drvdata(&sch->dev);
+	dev_set_drvdata(&sch->dev, NULL);
 	if (private->request) {
 		complete(&private->request->completion);
 		put_device(&sch->dev);
@@ -147,7 +148,10 @@ static struct css_device_id chsc_subchannel_ids[] = {
 MODULE_DEVICE_TABLE(css, chsc_subchannel_ids);
 
 static struct css_driver chsc_subchannel_driver = {
-	.owner = THIS_MODULE,
+	.drv = {
+		.owner = THIS_MODULE,
+		.name = "chsc_subchannel",
+	},
 	.subchannel_type = chsc_subchannel_ids,
 	.irq = chsc_subchannel_irq,
 	.probe = chsc_subchannel_probe,
@@ -157,7 +161,6 @@ static struct css_driver chsc_subchannel_driver = {
 	.freeze = chsc_subchannel_freeze,
 	.thaw = chsc_subchannel_restore,
 	.restore = chsc_subchannel_restore,
-	.name = "chsc_subchannel",
 };
 
 static int __init chsc_init_dbfs(void)
@@ -241,7 +244,7 @@ static int chsc_async(struct chsc_async_area *chsc_area,
 	chsc_area->header.key = PAGE_DEFAULT_KEY >> 4;
 	while ((sch = chsc_get_next_subchannel(sch))) {
 		spin_lock(sch->lock);
-		private = sch->private;
+		private = dev_get_drvdata(&sch->dev);
 		if (private->request) {
 			spin_unlock(sch->lock);
 			ret = -EBUSY;
diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index 430f875..cbde448 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -84,29 +84,14 @@ out_unregister:
 
 arch_initcall (cio_debug_init);
 
-int
-cio_set_options (struct subchannel *sch, int flags)
+int cio_set_options(struct subchannel *sch, int flags)
 {
-       sch->options.suspend = (flags & DOIO_ALLOW_SUSPEND) != 0;
-       sch->options.prefetch = (flags & DOIO_DENY_PREFETCH) != 0;
-       sch->options.inter = (flags & DOIO_SUPPRESS_INTER) != 0;
-       return 0;
-}
+	struct io_subchannel_private *priv = to_io_private(sch);
 
-/* FIXME: who wants to use this? */
-int
-cio_get_options (struct subchannel *sch)
-{
-       int flags;
-
-       flags = 0;
-       if (sch->options.suspend)
-		flags |= DOIO_ALLOW_SUSPEND;
-       if (sch->options.prefetch)
-		flags |= DOIO_DENY_PREFETCH;
-       if (sch->options.inter)
-		flags |= DOIO_SUPPRESS_INTER;
-       return flags;
+	priv->options.suspend = (flags & DOIO_ALLOW_SUSPEND) != 0;
+	priv->options.prefetch = (flags & DOIO_DENY_PREFETCH) != 0;
+	priv->options.inter = (flags & DOIO_SUPPRESS_INTER) != 0;
+	return 0;
 }
 
 static int
@@ -139,21 +124,21 @@ cio_start_key (struct subchannel *sch,	/* subchannel structure */
 	       __u8 lpm,		/* logical path mask */
 	       __u8 key)                /* storage key */
 {
+	struct io_subchannel_private *priv = to_io_private(sch);
+	union orb *orb = &priv->orb;
 	int ccode;
-	union orb *orb;
 
 	CIO_TRACE_EVENT(5, "stIO");
 	CIO_TRACE_EVENT(5, dev_name(&sch->dev));
 
-	orb = &to_io_private(sch)->orb;
 	memset(orb, 0, sizeof(union orb));
 	/* sch is always under 2G. */
 	orb->cmd.intparm = (u32)(addr_t)sch;
 	orb->cmd.fmt = 1;
 
-	orb->cmd.pfch = sch->options.prefetch == 0;
-	orb->cmd.spnd = sch->options.suspend;
-	orb->cmd.ssic = sch->options.suspend && sch->options.inter;
+	orb->cmd.pfch = priv->options.prefetch == 0;
+	orb->cmd.spnd = priv->options.suspend;
+	orb->cmd.ssic = priv->options.suspend && priv->options.inter;
 	orb->cmd.lpm = (lpm != 0) ? lpm : sch->lpm;
 #ifdef CONFIG_64BIT
 	/*
@@ -630,11 +615,7 @@ void __irq_entry do_IRQ(struct pt_regs *regs)
 	irb = (struct irb *)&S390_lowcore.irb;
 	do {
 		kstat_cpu(smp_processor_id()).irqs[IO_INTERRUPT]++;
-		/*
-		 * Non I/O-subchannel thin interrupts are processed differently
-		 */
-		if (tpi_info->adapter_IO == 1 &&
-		    tpi_info->int_type == IO_INTERRUPT_TYPE) {
+		if (tpi_info->adapter_IO) {
 			do_adapter_IO(tpi_info->isc);
 			continue;
 		}
diff --git a/drivers/s390/cio/cio.h b/drivers/s390/cio/cio.h
index bf7f80f..155a82b 100644
--- a/drivers/s390/cio/cio.h
+++ b/drivers/s390/cio/cio.h
@@ -84,13 +84,6 @@ struct subchannel {
 		SUBCHANNEL_TYPE_MSG = 2,
 		SUBCHANNEL_TYPE_ADM = 3,
 	} st;			/* subchannel type */
-
-	struct {
-		unsigned int suspend:1; /* allow suspend */
-		unsigned int prefetch:1;/* deny prefetch */
-		unsigned int inter:1;   /* suppress intermediate interrupts */
-	} __attribute__ ((packed)) options;
-
 	__u8 vpm;		/* verified path mask */
 	__u8 lpm;		/* logical path mask */
 	__u8 opm;               /* operational path mask */
@@ -99,14 +92,11 @@ struct subchannel {
 	struct chsc_ssd_info ssd_info;	/* subchannel description */
 	struct device dev;	/* entry in device tree */
 	struct css_driver *driver;
-	void *private; /* private per subchannel type data */
 	enum sch_todo todo;
 	struct work_struct todo_work;
 	struct schib_config config;
 } __attribute__ ((aligned(8)));
 
-#define IO_INTERRUPT_TYPE	   0 /* I/O interrupt type */
-
 #define to_subchannel(n) container_of(n, struct subchannel, dev)
 
 extern int cio_validate_subchannel (struct subchannel *, struct subchannel_id);
@@ -120,7 +110,6 @@ extern int cio_start (struct subchannel *, struct ccw1 *, __u8);
 extern int cio_start_key (struct subchannel *, struct ccw1 *, __u8, __u8);
 extern int cio_cancel (struct subchannel *);
 extern int cio_set_options (struct subchannel *, int);
-extern int cio_get_options (struct subchannel *);
 extern int cio_update_schib(struct subchannel *sch);
 extern int cio_commit_config(struct subchannel *sch);
 
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 24d8e97..c47b25f 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -35,6 +35,7 @@ int css_init_done = 0;
 int max_ssid;
 
 struct channel_subsystem *channel_subsystems[__MAX_CSSID + 1];
+static struct bus_type css_bus_type;
 
 int
 for_each_subchannel(int(*fn)(struct subchannel_id, void *), void *data)
@@ -1214,7 +1215,7 @@ static const struct dev_pm_ops css_pm_ops = {
 	.restore = css_pm_restore,
 };
 
-struct bus_type css_bus_type = {
+static struct bus_type css_bus_type = {
 	.name     = "css",
 	.match    = css_bus_match,
 	.probe    = css_probe,
@@ -1233,9 +1234,7 @@ struct bus_type css_bus_type = {
  */
 int css_driver_register(struct css_driver *cdrv)
 {
-	cdrv->drv.name = cdrv->name;
 	cdrv->drv.bus = &css_bus_type;
-	cdrv->drv.owner = cdrv->owner;
 	return driver_register(&cdrv->drv);
 }
 EXPORT_SYMBOL_GPL(css_driver_register);
@@ -1253,4 +1252,3 @@ void css_driver_unregister(struct css_driver *cdrv)
 EXPORT_SYMBOL_GPL(css_driver_unregister);
 
 MODULE_LICENSE("GPL");
-EXPORT_SYMBOL(css_bus_type);
diff --git a/drivers/s390/cio/css.h b/drivers/s390/cio/css.h
index 7e37886..80ebddd 100644
--- a/drivers/s390/cio/css.h
+++ b/drivers/s390/cio/css.h
@@ -63,7 +63,6 @@ struct subchannel;
 struct chp_link;
 /**
  * struct css_driver - device driver for subchannels
- * @owner: owning module
  * @subchannel_type: subchannel type supported by this driver
  * @drv: embedded device driver structure
  * @irq: called on interrupts
@@ -78,10 +77,8 @@ struct chp_link;
  * @thaw: undo work done in @freeze
  * @restore: callback for restoring after hibernation
  * @settle: wait for asynchronous work to finish
- * @name: name of the device driver
  */
 struct css_driver {
-	struct module *owner;
 	struct css_device_id *subchannel_type;
 	struct device_driver drv;
 	void (*irq)(struct subchannel *);
@@ -96,16 +93,10 @@ struct css_driver {
 	int (*thaw) (struct subchannel *);
 	int (*restore)(struct subchannel *);
 	int (*settle)(void);
-	const char *name;
 };
 
 #define to_cssdriver(n) container_of(n, struct css_driver, drv)
 
-/*
- * all css_drivers have the css_bus_type
- */
-extern struct bus_type css_bus_type;
-
 extern int css_driver_register(struct css_driver *);
 extern void css_driver_unregister(struct css_driver *);
 
@@ -140,7 +131,6 @@ struct channel_subsystem {
 };
 #define to_css(dev) container_of(dev, struct channel_subsystem, device)
 
-extern struct bus_type css_bus_type;
 extern struct channel_subsystem *channel_subsystems[];
 
 /* Helper functions to build lists for the slow path. */
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index b7eaff9..e50b121 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -172,9 +172,11 @@ static int io_subchannel_settle(void)
 }
 
 static struct css_driver io_subchannel_driver = {
-	.owner = THIS_MODULE,
+	.drv = {
+		.owner = THIS_MODULE,
+		.name = "io_subchannel",
+	},
 	.subchannel_type = io_subchannel_ids,
-	.name = "io_subchannel",
 	.irq = io_subchannel_irq,
 	.sch_event = io_subchannel_sch_event,
 	.chp_event = io_subchannel_chp_event,
@@ -1030,6 +1032,7 @@ static void io_subchannel_init_fields(struct subchannel *sch)
  */
 static int io_subchannel_probe(struct subchannel *sch)
 {
+	struct io_subchannel_private *io_priv;
 	struct ccw_device *cdev;
 	int rc;
 
@@ -1073,10 +1076,11 @@ static int io_subchannel_probe(struct subchannel *sch)
 	if (rc)
 		goto out_schedule;
 	/* Allocate I/O subchannel private data. */
-	sch->private = kzalloc(sizeof(struct io_subchannel_private),
-			       GFP_KERNEL | GFP_DMA);
-	if (!sch->private)
+	io_priv = kzalloc(sizeof(*io_priv), GFP_KERNEL | GFP_DMA);
+	if (!io_priv)
 		goto out_schedule;
+
+	set_io_private(sch, io_priv);
 	css_schedule_eval(sch->schid);
 	return 0;
 
@@ -1090,6 +1094,7 @@ out_schedule:
 static int
 io_subchannel_remove (struct subchannel *sch)
 {
+	struct io_subchannel_private *io_priv = to_io_private(sch);
 	struct ccw_device *cdev;
 
 	cdev = sch_get_cdev(sch);
@@ -1099,11 +1104,12 @@ io_subchannel_remove (struct subchannel *sch)
 	/* Set ccw device to not operational and drop reference. */
 	spin_lock_irq(cdev->ccwlock);
 	sch_set_cdev(sch, NULL);
+	set_io_private(sch, NULL);
 	cdev->private->state = DEV_STATE_NOT_OPER;
 	spin_unlock_irq(cdev->ccwlock);
 	ccw_device_unregister(cdev);
 out_free:
-	kfree(sch->private);
+	kfree(io_priv);
 	sysfs_remove_group(&sch->dev.kobj, &io_subchannel_attr_group);
 	return 0;
 }
@@ -1553,11 +1559,12 @@ spinlock_t * cio_get_console_lock(void)
 static int ccw_device_console_enable(struct ccw_device *cdev,
 				     struct subchannel *sch)
 {
+	struct io_subchannel_private *io_priv = cio_get_console_priv();
 	int rc;
 
 	/* Attach subchannel private data. */
-	sch->private = cio_get_console_priv();
-	memset(sch->private, 0, sizeof(struct io_subchannel_private));
+	memset(io_priv, 0, sizeof(*io_priv));
+	set_io_private(sch, io_priv);
 	io_subchannel_init_fields(sch);
 	rc = cio_commit_config(sch);
 	if (rc)
diff --git a/drivers/s390/cio/io_sch.h b/drivers/s390/cio/io_sch.h
index d024d2c..ba31ad8 100644
--- a/drivers/s390/cio/io_sch.h
+++ b/drivers/s390/cio/io_sch.h
@@ -5,68 +5,36 @@
 #include <asm/schid.h>
 #include <asm/ccwdev.h>
 #include "css.h"
-
-/*
- * command-mode operation request block
- */
-struct cmd_orb {
-	u32 intparm;	/* interruption parameter */
-	u32 key  : 4;	/* flags, like key, suspend control, etc. */
-	u32 spnd : 1;	/* suspend control */
-	u32 res1 : 1;	/* reserved */
-	u32 mod  : 1;	/* modification control */
-	u32 sync : 1;	/* synchronize control */
-	u32 fmt  : 1;	/* format control */
-	u32 pfch : 1;	/* prefetch control */
-	u32 isic : 1;	/* initial-status-interruption control */
-	u32 alcc : 1;	/* address-limit-checking control */
-	u32 ssic : 1;	/* suppress-suspended-interr. control */
-	u32 res2 : 1;	/* reserved */
-	u32 c64  : 1;	/* IDAW/QDIO 64 bit control  */
-	u32 i2k  : 1;	/* IDAW 2/4kB block size control */
-	u32 lpm  : 8;	/* logical path mask */
-	u32 ils  : 1;	/* incorrect length */
-	u32 zero : 6;	/* reserved zeros */
-	u32 orbx : 1;	/* ORB extension control */
-	u32 cpa;	/* channel program address */
-}  __attribute__ ((packed, aligned(4)));
-
-/*
- * transport-mode operation request block
- */
-struct tm_orb {
-	u32 intparm;
-	u32 key:4;
-	u32 :9;
-	u32 b:1;
-	u32 :2;
-	u32 lpm:8;
-	u32 :7;
-	u32 x:1;
-	u32 tcw;
-	u32 prio:8;
-	u32 :8;
-	u32 rsvpgm:8;
-	u32 :8;
-	u32 :32;
-	u32 :32;
-	u32 :32;
-	u32 :32;
-}  __attribute__ ((packed, aligned(4)));
-
-union orb {
-	struct cmd_orb cmd;
-	struct tm_orb tm;
-}  __attribute__ ((packed, aligned(4)));
+#include "orb.h"
 
 struct io_subchannel_private {
 	union orb orb;		/* operation request block */
 	struct ccw1 sense_ccw;	/* static ccw for sense command */
-} __attribute__ ((aligned(8)));
+	struct ccw_device *cdev;/* pointer to the child ccw device */
+	struct {
+		unsigned int suspend:1;	/* allow suspend */
+		unsigned int prefetch:1;/* deny prefetch */
+		unsigned int inter:1;	/* suppress intermediate interrupts */
+	} __packed options;
+} __aligned(8);
 
-#define to_io_private(n) ((struct io_subchannel_private *)n->private)
-#define sch_get_cdev(n) (dev_get_drvdata(&n->dev))
-#define sch_set_cdev(n, c) (dev_set_drvdata(&n->dev, c))
+#define to_io_private(n) ((struct io_subchannel_private *) \
+			  dev_get_drvdata(&(n)->dev))
+#define set_io_private(n, p) (dev_set_drvdata(&(n)->dev, p))
+
+static inline struct ccw_device *sch_get_cdev(struct subchannel *sch)
+{
+	struct io_subchannel_private *priv = to_io_private(sch);
+	return priv ? priv->cdev : NULL;
+}
+
+static inline void sch_set_cdev(struct subchannel *sch,
+				struct ccw_device *cdev)
+{
+	struct io_subchannel_private *priv = to_io_private(sch);
+	if (priv)
+		priv->cdev = cdev;
+}
 
 #define MAX_CIWS 8
 
@@ -191,23 +159,6 @@ struct ccw_device_private {
 	void *cmb_wait;			/* deferred cmb enable/disable */
 };
 
-static inline int ssch(struct subchannel_id schid, union orb *addr)
-{
-	register struct subchannel_id reg1 asm("1") = schid;
-	int ccode = -EIO;
-
-	asm volatile(
-		"	ssch	0(%2)\n"
-		"0:	ipm	%0\n"
-		"	srl	%0,28\n"
-		"1:\n"
-		EX_TABLE(0b, 1b)
-		: "+d" (ccode)
-		: "d" (reg1), "a" (addr), "m" (*addr)
-		: "cc", "memory");
-	return ccode;
-}
-
 static inline int rsch(struct subchannel_id schid)
 {
 	register struct subchannel_id reg1 asm("1") = schid;
@@ -223,21 +174,6 @@ static inline int rsch(struct subchannel_id schid)
 	return ccode;
 }
 
-static inline int csch(struct subchannel_id schid)
-{
-	register struct subchannel_id reg1 asm("1") = schid;
-	int ccode;
-
-	asm volatile(
-		"	csch\n"
-		"	ipm	%0\n"
-		"	srl	%0,28"
-		: "=d" (ccode)
-		: "d" (reg1)
-		: "cc");
-	return ccode;
-}
-
 static inline int hsch(struct subchannel_id schid)
 {
 	register struct subchannel_id reg1 asm("1") = schid;
diff --git a/drivers/s390/cio/ioasm.h b/drivers/s390/cio/ioasm.h
index fac0615..4d80fc6 100644
--- a/drivers/s390/cio/ioasm.h
+++ b/drivers/s390/cio/ioasm.h
@@ -3,6 +3,8 @@
 
 #include <asm/chpid.h>
 #include <asm/schid.h>
+#include "orb.h"
+#include "cio.h"
 
 /*
  * TPI info structure
@@ -87,6 +89,38 @@ static inline int tsch(struct subchannel_id schid, struct irb *addr)
 	return ccode;
 }
 
+static inline int ssch(struct subchannel_id schid, union orb *addr)
+{
+	register struct subchannel_id reg1 asm("1") = schid;
+	int ccode = -EIO;
+
+	asm volatile(
+		"	ssch	0(%2)\n"
+		"0:	ipm	%0\n"
+		"	srl	%0,28\n"
+		"1:\n"
+		EX_TABLE(0b, 1b)
+		: "+d" (ccode)
+		: "d" (reg1), "a" (addr), "m" (*addr)
+		: "cc", "memory");
+	return ccode;
+}
+
+static inline int csch(struct subchannel_id schid)
+{
+	register struct subchannel_id reg1 asm("1") = schid;
+	int ccode;
+
+	asm volatile(
+		"	csch\n"
+		"	ipm	%0\n"
+		"	srl	%0,28"
+		: "=d" (ccode)
+		: "d" (reg1)
+		: "cc");
+	return ccode;
+}
+
 static inline int tpi(struct tpi_info *addr)
 {
 	int ccode;
diff --git a/drivers/s390/cio/orb.h b/drivers/s390/cio/orb.h
new file mode 100644
index 0000000..45a9865
--- /dev/null
+++ b/drivers/s390/cio/orb.h
@@ -0,0 +1,67 @@
+/*
+ * Orb related data structures.
+ *
+ * Copyright IBM Corp. 2007, 2011
+ *
+ * Author(s): Cornelia Huck <cornelia.huck@de.ibm.com>
+ *	      Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
+ *	      Sebastian Ott <sebott@linux.vnet.ibm.com>
+ */
+
+#ifndef S390_ORB_H
+#define S390_ORB_H
+
+/*
+ * Command-mode operation request block
+ */
+struct cmd_orb {
+	u32 intparm;	/* interruption parameter */
+	u32 key:4;	/* flags, like key, suspend control, etc. */
+	u32 spnd:1;	/* suspend control */
+	u32 res1:1;	/* reserved */
+	u32 mod:1;	/* modification control */
+	u32 sync:1;	/* synchronize control */
+	u32 fmt:1;	/* format control */
+	u32 pfch:1;	/* prefetch control */
+	u32 isic:1;	/* initial-status-interruption control */
+	u32 alcc:1;	/* address-limit-checking control */
+	u32 ssic:1;	/* suppress-suspended-interr. control */
+	u32 res2:1;	/* reserved */
+	u32 c64:1;	/* IDAW/QDIO 64 bit control  */
+	u32 i2k:1;	/* IDAW 2/4kB block size control */
+	u32 lpm:8;	/* logical path mask */
+	u32 ils:1;	/* incorrect length */
+	u32 zero:6;	/* reserved zeros */
+	u32 orbx:1;	/* ORB extension control */
+	u32 cpa;	/* channel program address */
+}  __packed __aligned(4);
+
+/*
+ * Transport-mode operation request block
+ */
+struct tm_orb {
+	u32 intparm;
+	u32 key:4;
+	u32:9;
+	u32 b:1;
+	u32:2;
+	u32 lpm:8;
+	u32:7;
+	u32 x:1;
+	u32 tcw;
+	u32 prio:8;
+	u32:8;
+	u32 rsvpgm:8;
+	u32:8;
+	u32:32;
+	u32:32;
+	u32:32;
+	u32:32;
+}  __packed __aligned(4);
+
+union orb {
+	struct cmd_orb cmd;
+	struct tm_orb tm;
+}  __packed __aligned(4);
+
+#endif /* S390_ORB_H */
