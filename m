Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab0E0R3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:29:31 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:47756 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932616Ab0E0R30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:29:26 -0400
Date: Thu, 27 May 2010 19:29:23 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-s390 <linux-s390@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.35
Message-ID: <20100527192923.625975e4@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
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

Heiko Carstens (8):
      [S390] cmm: fix crash on module unload
      [S390] atomic: implement atomic64_dec_if_positive
      [S390] spp: fix compilation for CONFIG_32BIT
      [S390] kprobes: forbid probing of stnsm/stosm/epsw
      [S390] spp: remove KVM_AWARE_CMF config option
      [S390] cmm: remove superfluous EXPORT_SYMBOLs plus cleanups
      [S390] cmm: get rid of CMM_PROC config option
      [S390] Add support for LZO-compressed kernels.

Jonathan Nieder (1):
      [S390] fill out file list in s390 MAINTAINERS entry

Michael Ernst (1):
      [S390] cio: unit check handling during internal I/O

Sebastian Ott (2):
      [S390] cio: remove stsch
      [S390] ccwgroup: add locking around drvdata access

Stefan Haberland (1):
      [S390] dasd: unit check handling during internal cio I/O

 MAINTAINERS                        |    3 +
 arch/s390/Kconfig                  |    8 +--
 arch/s390/boot/compressed/Makefile |    5 +-
 arch/s390/boot/compressed/misc.c   |    4 +
 arch/s390/include/asm/atomic.h     |   19 ++++++
 arch/s390/include/asm/ccwdev.h     |   10 +++
 arch/s390/kernel/asm-offsets.c     |    4 +-
 arch/s390/kernel/entry64.S         |    2 +-
 arch/s390/kernel/kprobes.c         |    3 +
 arch/s390/kernel/setup.c           |    2 +-
 arch/s390/kvm/Kconfig              |   11 ----
 arch/s390/kvm/sie64a.S             |    4 +-
 arch/s390/mm/cmm.c                 |  109 ++++++++++++-----------------------
 drivers/s390/block/dasd.c          |   23 ++++++++
 drivers/s390/block/dasd_eckd.c     |    1 +
 drivers/s390/block/dasd_int.h      |    1 +
 drivers/s390/cio/ccwgroup.c        |    7 ++
 drivers/s390/cio/ccwreq.c          |   15 +++++
 drivers/s390/cio/ioasm.h           |   15 -----
 19 files changed, 134 insertions(+), 112 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 18355cc..cf4db76 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4836,6 +4836,9 @@ W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
 F:	arch/s390/
 F:	drivers/s390/
+F:	fs/partitions/ibm.c
+F:	Documentation/s390/
+F:	Documentation/DocBook/s390*
 
 S390 NETWORK DRIVERS
 M:	Ursula Braun <ursula.braun@de.ibm.com>
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 79d0ca0..bee1c0f 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -102,6 +102,7 @@ config S390
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
+	select HAVE_KERNEL_LZO
 	select ARCH_INLINE_SPIN_TRYLOCK
 	select ARCH_INLINE_SPIN_TRYLOCK_BH
 	select ARCH_INLINE_SPIN_LOCK
@@ -479,13 +480,6 @@ config CMM
 	  Everybody who wants to run Linux under VM should select this
 	  option.
 
-config CMM_PROC
-	bool "/proc interface to cooperative memory management"
-	depends on CMM
-	help
-	  Select this option to enable the /proc interface to the
-	  cooperative memory management.
-
 config CMM_IUCV
 	bool "IUCV special message interface to cooperative memory management"
 	depends on CMM && (SMSGIUCV=y || CMM=SMSGIUCV)
diff --git a/arch/s390/boot/compressed/Makefile b/arch/s390/boot/compressed/Makefile
index 6e4a67a..1c999f7 100644
--- a/arch/s390/boot/compressed/Makefile
+++ b/arch/s390/boot/compressed/Makefile
@@ -7,7 +7,7 @@
 BITS := $(if $(CONFIG_64BIT),64,31)
 
 targets	:= vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 \
-	   vmlinux.bin.lzma misc.o piggy.o sizes.h head$(BITS).o
+	   vmlinux.bin.lzma vmlinux.bin.lzo misc.o piggy.o sizes.h head$(BITS).o
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += $(cflags-y)
@@ -47,6 +47,7 @@ vmlinux.bin.all-y := $(obj)/vmlinux.bin
 suffix-$(CONFIG_KERNEL_GZIP)  := gz
 suffix-$(CONFIG_KERNEL_BZIP2) := bz2
 suffix-$(CONFIG_KERNEL_LZMA)  := lzma
+suffix-$(CONFIG_KERNEL_LZO)  := lzo
 
 $(obj)/vmlinux.bin.gz: $(vmlinux.bin.all-y)
 	$(call if_changed,gzip)
@@ -54,6 +55,8 @@ $(obj)/vmlinux.bin.bz2: $(vmlinux.bin.all-y)
 	$(call if_changed,bzip2)
 $(obj)/vmlinux.bin.lzma: $(vmlinux.bin.all-y)
 	$(call if_changed,lzma)
+$(obj)/vmlinux.bin.lzo: $(vmlinux.bin.all-y)
+	$(call if_changed,lzo)
 
 LDFLAGS_piggy.o := -r --format binary --oformat $(LD_BFD) -T
 $(obj)/piggy.o: $(obj)/vmlinux.scr $(obj)/vmlinux.bin.$(suffix-y)
diff --git a/arch/s390/boot/compressed/misc.c b/arch/s390/boot/compressed/misc.c
index 14e0479..0851eb1 100644
--- a/arch/s390/boot/compressed/misc.c
+++ b/arch/s390/boot/compressed/misc.c
@@ -50,6 +50,10 @@ static unsigned long free_mem_end_ptr;
 #include "../../../../lib/decompress_unlzma.c"
 #endif
 
+#ifdef CONFIG_KERNEL_LZO
+#include "../../../../lib/decompress_unlzo.c"
+#endif
+
 extern _sclp_print_early(const char *);
 
 int puts(const char *s)
diff --git a/arch/s390/include/asm/atomic.h b/arch/s390/include/asm/atomic.h
index 451bfbb..76daea1 100644
--- a/arch/s390/include/asm/atomic.h
+++ b/arch/s390/include/asm/atomic.h
@@ -15,6 +15,7 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <asm/system.h>
 
 #define ATOMIC_INIT(i)  { (i) }
 
@@ -274,6 +275,7 @@ static inline void atomic64_clear_mask(unsigned long long mask, atomic64_t *v)
 static inline int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 {
 	long long c, old;
+
 	c = atomic64_read(v);
 	for (;;) {
 		if (unlikely(c == u))
@@ -286,6 +288,23 @@ static inline int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 	return c != u;
 }
 
+static inline long long atomic64_dec_if_positive(atomic64_t *v)
+{
+	long long c, old, dec;
+
+	c = atomic64_read(v);
+	for (;;) {
+		dec = c - 1;
+		if (unlikely(dec < 0))
+			break;
+		old = atomic64_cmpxchg((v), c, dec);
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return dec;
+}
+
 #define atomic64_add(_i, _v)		atomic64_add_return(_i, _v)
 #define atomic64_add_negative(_i, _v)	(atomic64_add_return(_i, _v) < 0)
 #define atomic64_inc(_v)		atomic64_add_return(1, _v)
diff --git a/arch/s390/include/asm/ccwdev.h b/arch/s390/include/asm/ccwdev.h
index f4bd346..1c0030f 100644
--- a/arch/s390/include/asm/ccwdev.h
+++ b/arch/s390/include/asm/ccwdev.h
@@ -91,6 +91,14 @@ struct ccw_device {
 	void (*handler) (struct ccw_device *, unsigned long, struct irb *);
 };
 
+/*
+ * Possible CIO actions triggered by the unit check handler.
+ */
+enum uc_todo {
+	UC_TODO_RETRY,
+	UC_TODO_RETRY_ON_NEW_PATH,
+	UC_TODO_STOP
+};
 
 /**
  * struct ccw driver - device driver for channel attached devices
@@ -107,6 +115,7 @@ struct ccw_device {
  * @freeze: callback for freezing during hibernation snapshotting
  * @thaw: undo work done in @freeze
  * @restore: callback for restoring after hibernation
+ * @uc_handler: callback for unit check handler
  * @driver: embedded device driver structure
  * @name: device driver name
  */
@@ -124,6 +133,7 @@ struct ccw_driver {
 	int (*freeze)(struct ccw_device *);
 	int (*thaw) (struct ccw_device *);
 	int (*restore)(struct ccw_device *);
+	enum uc_todo (*uc_handler) (struct ccw_device *, struct irb *);
 	struct device_driver driver;
 	char *name;
 };
diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index d9b490a..5232278 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -132,8 +132,6 @@ int main(void)
 	DEFINE(__LC_MCCK_CLOCK, offsetof(struct _lowcore, mcck_clock));
 	DEFINE(__LC_MACHINE_FLAGS, offsetof(struct _lowcore, machine_flags));
 	DEFINE(__LC_FTRACE_FUNC, offsetof(struct _lowcore, ftrace_func));
-	DEFINE(__LC_SIE_HOOK, offsetof(struct _lowcore, sie_hook));
-	DEFINE(__LC_CMF_HPP, offsetof(struct _lowcore, cmf_hpp));
 	DEFINE(__LC_IRB, offsetof(struct _lowcore, irb));
 	DEFINE(__LC_CPU_TIMER_SAVE_AREA, offsetof(struct _lowcore, cpu_timer_save_area));
 	DEFINE(__LC_CLOCK_COMP_SAVE_AREA, offsetof(struct _lowcore, clock_comp_save_area));
@@ -154,6 +152,8 @@ int main(void)
 	DEFINE(__LC_FP_CREG_SAVE_AREA, offsetof(struct _lowcore, fpt_creg_save_area));
 	DEFINE(__LC_LAST_BREAK, offsetof(struct _lowcore, breaking_event_addr));
 	DEFINE(__LC_VDSO_PER_CPU, offsetof(struct _lowcore, vdso_per_cpu_data));
+	DEFINE(__LC_SIE_HOOK, offsetof(struct _lowcore, sie_hook));
+	DEFINE(__LC_CMF_HPP, offsetof(struct _lowcore, cmf_hpp));
 #endif /* CONFIG_32BIT */
 	return 0;
 }
diff --git a/arch/s390/kernel/entry64.S b/arch/s390/kernel/entry64.S
index 178d925..e7192e1 100644
--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -65,7 +65,7 @@ _TIF_SYSCALL = (_TIF_SYSCALL_TRACE>>8 | _TIF_SYSCALL_AUDIT>>8 | \
 	ltgr	%r3,%r3
 	jz	0f
 	basr	%r14,%r3
-	0:
+0:
 #endif
 	.endm
 
diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index 3d34eef..2a3d2bf 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -63,6 +63,8 @@ int __kprobes is_prohibited_opcode(kprobe_opcode_t *instruction)
 	case 0x0b:	/* bsm	 */
 	case 0x83:	/* diag  */
 	case 0x44:	/* ex	 */
+	case 0xac:	/* stnsm */
+	case 0xad:	/* stosm */
 		return -EINVAL;
 	}
 	switch (*(__u16 *) instruction) {
@@ -72,6 +74,7 @@ int __kprobes is_prohibited_opcode(kprobe_opcode_t *instruction)
 	case 0xb258:	/* bsg	 */
 	case 0xb218:	/* pc	 */
 	case 0xb228:	/* pt	 */
+	case 0xb98d:	/* epsw	 */
 		return -EINVAL;
 	}
 	return 0;
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 7d89324..c8e8e13 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -401,7 +401,6 @@ setup_lowcore(void)
 	lc->io_new_psw.mask = psw_kernel_bits;
 	lc->io_new_psw.addr = PSW_ADDR_AMODE | (unsigned long) io_int_handler;
 	lc->clock_comparator = -1ULL;
-	lc->cmf_hpp = -1ULL;
 	lc->kernel_stack = ((unsigned long) &init_thread_union) + THREAD_SIZE;
 	lc->async_stack = (unsigned long)
 		__alloc_bootmem(ASYNC_SIZE, ASYNC_SIZE, 0) + ASYNC_SIZE;
@@ -418,6 +417,7 @@ setup_lowcore(void)
 		__ctl_set_bit(14, 29);
 	}
 #else
+	lc->cmf_hpp = -1ULL;
 	lc->vdso_per_cpu_data = (unsigned long) &lc->paste[0];
 #endif
 	lc->sync_enter_timer = S390_lowcore.sync_enter_timer;
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index 2f4b687..a725158 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -33,17 +33,6 @@ config KVM
 
 	  If unsure, say N.
 
-config KVM_AWARE_CMF
-	depends on KVM
-	bool "KVM aware sampling"
-	---help---
-	  This option enhances the sampling data from the CPU Measurement
-	  Facility with additional information, that allows to distinguish
-	  guest(s) and host when using the kernel based virtual machine
-	  functionality.
-
-	  If unsure, say N.
-
 # OK, it's a little counter-intuitive to do this, but it puts it neatly under
 # the virtualization menu.
 source drivers/vhost/Kconfig
diff --git a/arch/s390/kvm/sie64a.S b/arch/s390/kvm/sie64a.S
index 31646bd..7e9d30d 100644
--- a/arch/s390/kvm/sie64a.S
+++ b/arch/s390/kvm/sie64a.S
@@ -32,12 +32,10 @@ SPI_PSW  = STACK_FRAME_OVERHEAD + __PT_PSW
 
 
 	.macro SPP newpp
-#ifdef CONFIG_KVM_AWARE_CMF
 	tm	__LC_MACHINE_FLAGS+6,0x20	# MACHINE_FLAG_SPP
 	jz	0f
 	.insn	s,0xb2800000,\newpp
-	0:
-#endif
+0:
 	.endm
 
 sie_irq_handler:
diff --git a/arch/s390/mm/cmm.c b/arch/s390/mm/cmm.c
index f87b347..eb6a2ef 100644
--- a/arch/s390/mm/cmm.c
+++ b/arch/s390/mm/cmm.c
@@ -1,11 +1,9 @@
 /*
- *  arch/s390/mm/cmm.c
+ *  Collaborative memory management interface.
  *
- *  S390 version
- *    Copyright (C) 2003 IBM Deutschland Entwicklung GmbH, IBM Corporation
- *    Author(s): Martin Schwidefsky (schwidefsky@de.ibm.com)
+ *    Copyright IBM Corp 2003,2010
+ *    Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>,
  *
- *  Collaborative memory management interface.
  */
 
 #include <linux/errno.h>
@@ -20,9 +18,9 @@
 #include <linux/kthread.h>
 #include <linux/oom.h>
 #include <linux/suspend.h>
+#include <linux/uaccess.h>
 
 #include <asm/pgalloc.h>
-#include <asm/uaccess.h>
 #include <asm/diag.h>
 
 static char *sender = "VMRMSVM";
@@ -53,14 +51,14 @@ static struct cmm_page_array *cmm_timed_page_list;
 static DEFINE_SPINLOCK(cmm_lock);
 
 static struct task_struct *cmm_thread_ptr;
-static wait_queue_head_t cmm_thread_wait;
-static struct timer_list cmm_timer;
+static DECLARE_WAIT_QUEUE_HEAD(cmm_thread_wait);
+static DEFINE_TIMER(cmm_timer, NULL, 0, 0);
 
 static void cmm_timer_fn(unsigned long);
 static void cmm_set_timer(void);
 
-static long
-cmm_alloc_pages(long nr, long *counter, struct cmm_page_array **list)
+static long cmm_alloc_pages(long nr, long *counter,
+			    struct cmm_page_array **list)
 {
 	struct cmm_page_array *pa, *npa;
 	unsigned long addr;
@@ -99,8 +97,7 @@ cmm_alloc_pages(long nr, long *counter, struct cmm_page_array **list)
 	return nr;
 }
 
-static long
-cmm_free_pages(long nr, long *counter, struct cmm_page_array **list)
+static long cmm_free_pages(long nr, long *counter, struct cmm_page_array **list)
 {
 	struct cmm_page_array *pa;
 	unsigned long addr;
@@ -140,11 +137,10 @@ static int cmm_oom_notify(struct notifier_block *self,
 }
 
 static struct notifier_block cmm_oom_nb = {
-	.notifier_call = cmm_oom_notify
+	.notifier_call = cmm_oom_notify,
 };
 
-static int
-cmm_thread(void *dummy)
+static int cmm_thread(void *dummy)
 {
 	int rc;
 
@@ -170,7 +166,7 @@ cmm_thread(void *dummy)
 				cmm_timed_pages_target = cmm_timed_pages;
 		} else if (cmm_timed_pages_target < cmm_timed_pages) {
 			cmm_free_pages(1, &cmm_timed_pages,
-			       	       &cmm_timed_page_list);
+				       &cmm_timed_page_list);
 		}
 		if (cmm_timed_pages > 0 && !timer_pending(&cmm_timer))
 			cmm_set_timer();
@@ -178,14 +174,12 @@ cmm_thread(void *dummy)
 	return 0;
 }
 
-static void
-cmm_kick_thread(void)
+static void cmm_kick_thread(void)
 {
 	wake_up(&cmm_thread_wait);
 }
 
-static void
-cmm_set_timer(void)
+static void cmm_set_timer(void)
 {
 	if (cmm_timed_pages_target <= 0 || cmm_timeout_seconds <= 0) {
 		if (timer_pending(&cmm_timer))
@@ -202,8 +196,7 @@ cmm_set_timer(void)
 	add_timer(&cmm_timer);
 }
 
-static void
-cmm_timer_fn(unsigned long ignored)
+static void cmm_timer_fn(unsigned long ignored)
 {
 	long nr;
 
@@ -216,57 +209,49 @@ cmm_timer_fn(unsigned long ignored)
 	cmm_set_timer();
 }
 
-void
-cmm_set_pages(long nr)
+static void cmm_set_pages(long nr)
 {
 	cmm_pages_target = nr;
 	cmm_kick_thread();
 }
 
-long
-cmm_get_pages(void)
+static long cmm_get_pages(void)
 {
 	return cmm_pages;
 }
 
-void
-cmm_add_timed_pages(long nr)
+static void cmm_add_timed_pages(long nr)
 {
 	cmm_timed_pages_target += nr;
 	cmm_kick_thread();
 }
 
-long
-cmm_get_timed_pages(void)
+static long cmm_get_timed_pages(void)
 {
 	return cmm_timed_pages;
 }
 
-void
-cmm_set_timeout(long nr, long seconds)
+static void cmm_set_timeout(long nr, long seconds)
 {
 	cmm_timeout_pages = nr;
 	cmm_timeout_seconds = seconds;
 	cmm_set_timer();
 }
 
-static int
-cmm_skip_blanks(char *cp, char **endp)
+static int cmm_skip_blanks(char *cp, char **endp)
 {
 	char *str;
 
-	for (str = cp; *str == ' ' || *str == '\t'; str++);
+	for (str = cp; *str == ' ' || *str == '\t'; str++)
+		;
 	*endp = str;
 	return str != cp;
 }
 
-#ifdef CONFIG_CMM_PROC
-
 static struct ctl_table cmm_table[];
 
-static int
-cmm_pages_handler(ctl_table *ctl, int write,
-		  void __user *buffer, size_t *lenp, loff_t *ppos)
+static int cmm_pages_handler(ctl_table *ctl, int write, void __user *buffer,
+			     size_t *lenp, loff_t *ppos)
 {
 	char buf[16], *p;
 	long nr;
@@ -305,9 +290,8 @@ cmm_pages_handler(ctl_table *ctl, int write,
 	return 0;
 }
 
-static int
-cmm_timeout_handler(ctl_table *ctl, int write,
-		    void __user *buffer, size_t *lenp, loff_t *ppos)
+static int cmm_timeout_handler(ctl_table *ctl, int write,  void __user *buffer,
+			       size_t *lenp, loff_t *ppos)
 {
 	char buf[64], *p;
 	long nr, seconds;
@@ -370,12 +354,10 @@ static struct ctl_table cmm_dir_table[] = {
 	},
 	{ }
 };
-#endif
 
 #ifdef CONFIG_CMM_IUCV
 #define SMSG_PREFIX "CMM"
-static void
-cmm_smsg_target(const char *from, char *msg)
+static void cmm_smsg_target(const char *from, char *msg)
 {
 	long nr, seconds;
 
@@ -445,16 +427,13 @@ static struct notifier_block cmm_power_notifier = {
 	.notifier_call = cmm_power_event,
 };
 
-static int
-cmm_init (void)
+static int cmm_init(void)
 {
 	int rc = -ENOMEM;
 
-#ifdef CONFIG_CMM_PROC
 	cmm_sysctl_header = register_sysctl_table(cmm_dir_table);
 	if (!cmm_sysctl_header)
 		goto out_sysctl;
-#endif
 #ifdef CONFIG_CMM_IUCV
 	rc = smsg_register_callback(SMSG_PREFIX, cmm_smsg_target);
 	if (rc < 0)
@@ -466,8 +445,6 @@ cmm_init (void)
 	rc = register_pm_notifier(&cmm_power_notifier);
 	if (rc)
 		goto out_pm;
-	init_waitqueue_head(&cmm_thread_wait);
-	init_timer(&cmm_timer);
 	cmm_thread_ptr = kthread_run(cmm_thread, NULL, "cmmthread");
 	rc = IS_ERR(cmm_thread_ptr) ? PTR_ERR(cmm_thread_ptr) : 0;
 	if (rc)
@@ -483,36 +460,26 @@ out_oom_notify:
 	smsg_unregister_callback(SMSG_PREFIX, cmm_smsg_target);
 out_smsg:
 #endif
-#ifdef CONFIG_CMM_PROC
 	unregister_sysctl_table(cmm_sysctl_header);
 out_sysctl:
-#endif
+	del_timer_sync(&cmm_timer);
 	return rc;
 }
+module_init(cmm_init);
 
-static void
-cmm_exit(void)
+static void cmm_exit(void)
 {
-	kthread_stop(cmm_thread_ptr);
-	unregister_pm_notifier(&cmm_power_notifier);
-	unregister_oom_notifier(&cmm_oom_nb);
-	cmm_free_pages(cmm_pages, &cmm_pages, &cmm_page_list);
-	cmm_free_pages(cmm_timed_pages, &cmm_timed_pages, &cmm_timed_page_list);
-#ifdef CONFIG_CMM_PROC
 	unregister_sysctl_table(cmm_sysctl_header);
-#endif
 #ifdef CONFIG_CMM_IUCV
 	smsg_unregister_callback(SMSG_PREFIX, cmm_smsg_target);
 #endif
+	unregister_pm_notifier(&cmm_power_notifier);
+	unregister_oom_notifier(&cmm_oom_nb);
+	kthread_stop(cmm_thread_ptr);
+	del_timer_sync(&cmm_timer);
+	cmm_free_pages(cmm_pages, &cmm_pages, &cmm_page_list);
+	cmm_free_pages(cmm_timed_pages, &cmm_timed_pages, &cmm_timed_page_list);
 }
-
-module_init(cmm_init);
 module_exit(cmm_exit);
 
-EXPORT_SYMBOL(cmm_set_pages);
-EXPORT_SYMBOL(cmm_get_pages);
-EXPORT_SYMBOL(cmm_add_timed_pages);
-EXPORT_SYMBOL(cmm_get_timed_pages);
-EXPORT_SYMBOL(cmm_set_timeout);
-
 MODULE_LICENSE("GPL");
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 0e86247..33975e9 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -1186,6 +1186,29 @@ void dasd_int_handler(struct ccw_device *cdev, unsigned long intparm,
 	dasd_schedule_device_bh(device);
 }
 
+enum uc_todo dasd_generic_uc_handler(struct ccw_device *cdev, struct irb *irb)
+{
+	struct dasd_device *device;
+
+	device = dasd_device_from_cdev_locked(cdev);
+
+	if (IS_ERR(device))
+		goto out;
+	if (test_bit(DASD_FLAG_OFFLINE, &device->flags) ||
+	   device->state != device->target ||
+	   !device->discipline->handle_unsolicited_interrupt){
+		dasd_put_device(device);
+		goto out;
+	}
+
+	dasd_device_clear_timer(device);
+	device->discipline->handle_unsolicited_interrupt(device, irb);
+	dasd_put_device(device);
+out:
+	return UC_TODO_RETRY;
+}
+EXPORT_SYMBOL_GPL(dasd_generic_uc_handler);
+
 /*
  * If we have an error on a dasd_block layer request then we cancel
  * and return all further requests from the same dasd_block as well.
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 5b1cd8d..ab84da5 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -3436,6 +3436,7 @@ static struct ccw_driver dasd_eckd_driver = {
 	.freeze      = dasd_generic_pm_freeze,
 	.thaw	     = dasd_generic_restore_device,
 	.restore     = dasd_generic_restore_device,
+	.uc_handler  = dasd_generic_uc_handler,
 };
 
 /*
diff --git a/drivers/s390/block/dasd_int.h b/drivers/s390/block/dasd_int.h
index 32fac18..49b431d 100644
--- a/drivers/s390/block/dasd_int.h
+++ b/drivers/s390/block/dasd_int.h
@@ -617,6 +617,7 @@ int dasd_generic_notify(struct ccw_device *, int);
 void dasd_generic_handle_state_change(struct dasd_device *);
 int dasd_generic_pm_freeze(struct ccw_device *);
 int dasd_generic_restore_device(struct ccw_device *);
+enum uc_todo dasd_generic_uc_handler(struct ccw_device *, struct irb *);
 
 int dasd_generic_read_dev_chars(struct dasd_device *, int, void *, int);
 char *dasd_get_sense(struct irb *);
diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index 5f97ea2..97b25d6 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -123,8 +123,10 @@ ccwgroup_release (struct device *dev)
 
 	for (i = 0; i < gdev->count; i++) {
 		if (gdev->cdev[i]) {
+			spin_lock_irq(gdev->cdev[i]->ccwlock);
 			if (dev_get_drvdata(&gdev->cdev[i]->dev) == gdev)
 				dev_set_drvdata(&gdev->cdev[i]->dev, NULL);
+			spin_unlock_irq(gdev->cdev[i]->ccwlock);
 			put_device(&gdev->cdev[i]->dev);
 		}
 	}
@@ -262,11 +264,14 @@ int ccwgroup_create_from_string(struct device *root, unsigned int creator_id,
 			goto error;
 		}
 		/* Don't allow a device to belong to more than one group. */
+		spin_lock_irq(gdev->cdev[i]->ccwlock);
 		if (dev_get_drvdata(&gdev->cdev[i]->dev)) {
+			spin_unlock_irq(gdev->cdev[i]->ccwlock);
 			rc = -EINVAL;
 			goto error;
 		}
 		dev_set_drvdata(&gdev->cdev[i]->dev, gdev);
+		spin_unlock_irq(gdev->cdev[i]->ccwlock);
 	}
 	/* Check for sufficient number of bus ids. */
 	if (i < num_devices && !curr_buf) {
@@ -303,8 +308,10 @@ int ccwgroup_create_from_string(struct device *root, unsigned int creator_id,
 error:
 	for (i = 0; i < num_devices; i++)
 		if (gdev->cdev[i]) {
+			spin_lock_irq(gdev->cdev[i]->ccwlock);
 			if (dev_get_drvdata(&gdev->cdev[i]->dev) == gdev)
 				dev_set_drvdata(&gdev->cdev[i]->dev, NULL);
+			spin_unlock_irq(gdev->cdev[i]->ccwlock);
 			put_device(&gdev->cdev[i]->dev);
 			gdev->cdev[i] = NULL;
 		}
diff --git a/drivers/s390/cio/ccwreq.c b/drivers/s390/cio/ccwreq.c
index 37df42a..7f206ed 100644
--- a/drivers/s390/cio/ccwreq.c
+++ b/drivers/s390/cio/ccwreq.c
@@ -159,6 +159,7 @@ static enum io_status ccwreq_status(struct ccw_device *cdev, struct irb *lcirb)
 {
 	struct irb *irb = &cdev->private->irb;
 	struct cmd_scsw *scsw = &irb->scsw.cmd;
+	enum uc_todo todo;
 
 	/* Perform BASIC SENSE if needed. */
 	if (ccw_device_accumulate_and_sense(cdev, lcirb))
@@ -178,6 +179,20 @@ static enum io_status ccwreq_status(struct ccw_device *cdev, struct irb *lcirb)
 		/* Check for command reject. */
 		if (irb->ecw[0] & SNS0_CMD_REJECT)
 			return IO_REJECTED;
+		/* Ask the driver what to do */
+		if (cdev->drv && cdev->drv->uc_handler) {
+			todo = cdev->drv->uc_handler(cdev, lcirb);
+			switch (todo) {
+			case UC_TODO_RETRY:
+				return IO_STATUS_ERROR;
+			case UC_TODO_RETRY_ON_NEW_PATH:
+				return IO_PATH_ERROR;
+			case UC_TODO_STOP:
+				return IO_REJECTED;
+			default:
+				return IO_STATUS_ERROR;
+			}
+		}
 		/* Assume that unexpected SENSE data implies an error. */
 		return IO_STATUS_ERROR;
 	}
diff --git a/drivers/s390/cio/ioasm.h b/drivers/s390/cio/ioasm.h
index 7592627..fac0615 100644
--- a/drivers/s390/cio/ioasm.h
+++ b/drivers/s390/cio/ioasm.h
@@ -23,21 +23,6 @@ struct tpi_info {
  * Some S390 specific IO instructions as inline
  */
 
-static inline int stsch(struct subchannel_id schid, struct schib *addr)
-{
-	register struct subchannel_id reg1 asm ("1") = schid;
-	int ccode;
-
-	asm volatile(
-		"	stsch	0(%3)\n"
-		"	ipm	%0\n"
-		"	srl	%0,28"
-		: "=d" (ccode), "=m" (*addr)
-		: "d" (reg1), "a" (addr)
-		: "cc");
-	return ccode;
-}
-
 static inline int stsch_err(struct subchannel_id schid, struct schib *addr)
 {
 	register struct subchannel_id reg1 asm ("1") = schid;
