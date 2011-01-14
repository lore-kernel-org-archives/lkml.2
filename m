Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab1ANJ7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:59:09 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:52995 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab1ANJ7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:59:02 -0500
Date: Fri, 14 Jan 2011 10:59:00 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.38 #2
Message-ID: <20110114105900.088f4ce1@mschwide.boeblingen.de.ibm.com>
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

Heiko Carstens (10):
      [S390] mmap: consider stack address randomization
      [S390] reduce miminum gap between stack and mmap_base
      [S390] vdso: dont map at mmap_base
      [S390] Enable flexible mmap layout for 64 bit processes
      [S390] Rearrange mmap.c
      [S390] Randomize mmap start address
      [S390] Randomize lower bits of stack address
      [S390] Add is_32bit_task() helper function
      [S390] Randomise the brk region
      [S390] Randomize PIEs

Holger Dengler (1):
      [S390] MAINTAINERS: Update zcrypt driver entry

Martin Schwidefsky (1):
      [S390] Update default configuration

Sebastian Ott (1):
      [S390] cio: path_event overindication after resume

 MAINTAINERS                         |    3 +-
 arch/s390/defconfig                 |   16 ++++++++++-
 arch/s390/include/asm/compat.h      |    2 +-
 arch/s390/include/asm/elf.h         |    9 +++++-
 arch/s390/include/asm/system.h      |    2 +-
 arch/s390/include/asm/thread_info.h |    6 ++++
 arch/s390/kernel/process.c          |   38 +++++++++++++++++++++++++++
 arch/s390/kernel/vdso.c             |    4 +--
 arch/s390/mm/mmap.c                 |   49 ++++++++++++++++++++++-------------
 drivers/s390/cio/device.c           |    1 +
 10 files changed, 103 insertions(+), 27 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 42f991e..6ce9191 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5243,8 +5243,7 @@ S:	Supported
 F:	drivers/s390/net/
 
 S390 ZCRYPT DRIVER
-M:	Felix Beck <felix.beck@de.ibm.com>
-M:	Ralph Wuerthner <ralph.wuerthner@de.ibm.com>
+M:	Holger Dengler <hd@linux.vnet.ibm.com>
 M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
diff --git a/arch/s390/defconfig b/arch/s390/defconfig
index d796971..29c82c6 100644
--- a/arch/s390/defconfig
+++ b/arch/s390/defconfig
@@ -5,10 +5,21 @@ CONFIG_AUDIT=y
 CONFIG_RCU_TRACE=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
+CONFIG_CGROUPS=y
+CONFIG_CPUSETS=y
+CONFIG_CGROUP_CPUACCT=y
+CONFIG_RESOURCE_COUNTERS=y
+CONFIG_CGROUP_MEM_RES_CTLR=y
+CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
+CONFIG_CGROUP_SCHED=y
+CONFIG_RT_GROUP_SCHED=y
+CONFIG_BLK_CGROUP=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_PERF_EVENTS=y
+# CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
+CONFIG_PROFILING=y
+CONFIG_OPROFILE=y
 CONFIG_KPROBES=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
@@ -19,7 +30,9 @@ CONFIG_HIGH_RES_TIMERS=y
 CONFIG_PREEMPT=y
 CONFIG_MEMORY_HOTPLUG=y
 CONFIG_MEMORY_HOTREMOVE=y
+CONFIG_KSM=y
 CONFIG_BINFMT_MISC=m
+CONFIG_CMM=m
 CONFIG_HZ_100=y
 CONFIG_KEXEC=y
 CONFIG_PM=y
@@ -105,6 +118,7 @@ CONFIG_DEBUG_LIST=y
 CONFIG_DEBUG_NOTIFIERS=y
 # CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_KPROBES_SANITY_TEST=y
+CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
 CONFIG_CPU_NOTIFIER_ERROR_INJECT=m
 CONFIG_LATENCYTOP=y
 CONFIG_SYSCTL_SYSCALL_CHECK=y
diff --git a/arch/s390/include/asm/compat.h b/arch/s390/include/asm/compat.h
index a875c2f..da359ca 100644
--- a/arch/s390/include/asm/compat.h
+++ b/arch/s390/include/asm/compat.h
@@ -169,7 +169,7 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
 
 static inline int is_compat_task(void)
 {
-	return test_thread_flag(TIF_31BIT);
+	return is_32bit_task();
 }
 
 #else
diff --git a/arch/s390/include/asm/elf.h b/arch/s390/include/asm/elf.h
index 354d426..10c029c 100644
--- a/arch/s390/include/asm/elf.h
+++ b/arch/s390/include/asm/elf.h
@@ -161,7 +161,9 @@ extern unsigned int vdso_enabled;
    use of this is to invoke "./ld.so someprog" to test out a new version of
    the loader.  We need to make sure that it is out of the way of the program
    that it will "exec", and that there is sufficient room for the brk.  */
-#define ELF_ET_DYN_BASE		(STACK_TOP / 3 * 2)
+
+extern unsigned long randomize_et_dyn(unsigned long base);
+#define ELF_ET_DYN_BASE		(randomize_et_dyn(STACK_TOP / 3 * 2))
 
 /* This yields a mask that user programs can use to figure out what
    instruction set this CPU supports. */
@@ -206,6 +208,8 @@ do {								\
 	current->mm->context.noexec == 0;		\
 })
 
+#define STACK_RND_MASK	0x7ffUL
+
 #define ARCH_DLINFO							    \
 do {									    \
 	if (vdso_enabled)						    \
@@ -218,4 +222,7 @@ struct linux_binprm;
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
 int arch_setup_additional_pages(struct linux_binprm *, int);
 
+extern unsigned long arch_randomize_brk(struct mm_struct *mm);
+#define arch_randomize_brk arch_randomize_brk
+
 #endif
diff --git a/arch/s390/include/asm/system.h b/arch/s390/include/asm/system.h
index 6710b0e..8f8d759 100644
--- a/arch/s390/include/asm/system.h
+++ b/arch/s390/include/asm/system.h
@@ -449,7 +449,7 @@ extern void (*_machine_restart)(char *command);
 extern void (*_machine_halt)(void);
 extern void (*_machine_power_off)(void);
 
-#define arch_align_stack(x) (x)
+extern unsigned long arch_align_stack(unsigned long sp);
 
 static inline int tprot(unsigned long addr)
 {
diff --git a/arch/s390/include/asm/thread_info.h b/arch/s390/include/asm/thread_info.h
index ebc7709..ad1382f 100644
--- a/arch/s390/include/asm/thread_info.h
+++ b/arch/s390/include/asm/thread_info.h
@@ -118,6 +118,12 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_SINGLE_STEP	(1<<TIF_FREEZE)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
 
+#ifdef CONFIG_64BIT
+#define is_32bit_task()		(test_thread_flag(TIF_31BIT))
+#else
+#define is_32bit_task()		(1)
+#endif
+
 #endif /* __KERNEL__ */
 
 #define PREEMPT_ACTIVE		0x4000000
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 6ba4222..a895e69 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -30,9 +30,11 @@
 #include <linux/tick.h>
 #include <linux/elfcore.h>
 #include <linux/kernel_stat.h>
+#include <linux/personality.h>
 #include <linux/syscalls.h>
 #include <linux/compat.h>
 #include <linux/kprobes.h>
+#include <linux/random.h>
 #include <asm/compat.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -332,3 +334,39 @@ unsigned long get_wchan(struct task_struct *p)
 	}
 	return 0;
 }
+
+unsigned long arch_align_stack(unsigned long sp)
+{
+	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
+		sp -= get_random_int() & ~PAGE_MASK;
+	return sp & ~0xf;
+}
+
+static inline unsigned long brk_rnd(void)
+{
+	/* 8MB for 32bit, 1GB for 64bit */
+	if (is_32bit_task())
+		return (get_random_int() & 0x7ffUL) << PAGE_SHIFT;
+	else
+		return (get_random_int() & 0x3ffffUL) << PAGE_SHIFT;
+}
+
+unsigned long arch_randomize_brk(struct mm_struct *mm)
+{
+	unsigned long ret = PAGE_ALIGN(mm->brk + brk_rnd());
+
+	if (ret < mm->brk)
+		return mm->brk;
+	return ret;
+}
+
+unsigned long randomize_et_dyn(unsigned long base)
+{
+	unsigned long ret = PAGE_ALIGN(base + brk_rnd());
+
+	if (!(current->flags & PF_RANDOMIZE))
+		return base;
+	if (ret < base)
+		return base;
+	return ret;
+}
diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
index e3150dd..f438d74 100644
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -203,7 +203,6 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	if (!uses_interp)
 		return 0;
 
-	vdso_base = mm->mmap_base;
 #ifdef CONFIG_64BIT
 	vdso_pagelist = vdso64_pagelist;
 	vdso_pages = vdso64_pages;
@@ -233,8 +232,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	 * fail and end up putting it elsewhere.
 	 */
 	down_write(&mm->mmap_sem);
-	vdso_base = get_unmapped_area(NULL, vdso_base,
-				      vdso_pages << PAGE_SHIFT, 0, 0);
+	vdso_base = get_unmapped_area(NULL, 0, vdso_pages << PAGE_SHIFT, 0, 0);
 	if (IS_ERR_VALUE(vdso_base)) {
 		rc = vdso_base;
 		goto out_up;
diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
index 869efba..c9a9f7f 100644
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -27,17 +27,44 @@
 #include <linux/personality.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/random.h>
 #include <asm/pgalloc.h>
 #include <asm/compat.h>
 
+static unsigned long stack_maxrandom_size(void)
+{
+	if (!(current->flags & PF_RANDOMIZE))
+		return 0;
+	if (current->personality & ADDR_NO_RANDOMIZE)
+		return 0;
+	return STACK_RND_MASK << PAGE_SHIFT;
+}
+
 /*
  * Top of mmap area (just below the process stack).
  *
- * Leave an at least ~128 MB hole.
+ * Leave at least a ~32 MB hole.
  */
-#define MIN_GAP (128*1024*1024)
+#define MIN_GAP (32*1024*1024)
 #define MAX_GAP (STACK_TOP/6*5)
 
+static inline int mmap_is_legacy(void)
+{
+	if (current->personality & ADDR_COMPAT_LAYOUT)
+		return 1;
+	if (rlimit(RLIMIT_STACK) == RLIM_INFINITY)
+		return 1;
+	return sysctl_legacy_va_layout;
+}
+
+static unsigned long mmap_rnd(void)
+{
+	if (!(current->flags & PF_RANDOMIZE))
+		return 0;
+	/* 8MB randomization for mmap_base */
+	return (get_random_int() & 0x7ffUL) << PAGE_SHIFT;
+}
+
 static inline unsigned long mmap_base(void)
 {
 	unsigned long gap = rlimit(RLIMIT_STACK);
@@ -46,22 +73,8 @@ static inline unsigned long mmap_base(void)
 		gap = MIN_GAP;
 	else if (gap > MAX_GAP)
 		gap = MAX_GAP;
-
-	return STACK_TOP - (gap & PAGE_MASK);
-}
-
-static inline int mmap_is_legacy(void)
-{
-#ifdef CONFIG_64BIT
-	/*
-	 * Force standard allocation for 64 bit programs.
-	 */
-	if (!is_compat_task())
-		return 1;
-#endif
-	return sysctl_legacy_va_layout ||
-	    (current->personality & ADDR_COMPAT_LAYOUT) ||
-	    rlimit(RLIMIT_STACK) == RLIM_INFINITY;
+	gap &= PAGE_MASK;
+	return STACK_TOP - stack_maxrandom_size() - mmap_rnd() - gap;
 }
 
 #ifndef CONFIG_64BIT
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index e8391b8..b7eaff9 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1835,6 +1835,7 @@ static void __ccw_device_pm_restore(struct ccw_device *cdev)
 	 * available again. Kick re-detection.
 	 */
 	cdev->private->flags.resuming = 1;
+	cdev->private->path_new_mask = LPM_ANYPATH;
 	css_schedule_eval(sch->schid);
 	spin_unlock_irq(sch->lock);
 	css_complete_work();
