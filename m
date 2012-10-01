Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab2JANt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:49:26 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47597 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2JANtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:49:21 -0400
Date: Mon, 1 Oct 2012 15:49:16 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/debug changes for v3.7
Message-ID: <20121001134916.GA24077@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-debug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-debug-for-linus

   HEAD: 924e101a7ab6f884047f4344e5f1154a4bcd63a6 x86/debug: Dump family, model, stepping of the boot CPU

Various smaller enhancements.

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      x86/debug: Dump family, model, stepping of the boot CPU

Mathias Krause (7):
      x86: Fix __user annotations in asm/sys_ia32.h
      x86/vdso: Add __user annotation to VDSO32_SYMBOL
      x86/signals: ia32_signal.c: add __user casts to fix sparse warnings
      x86/pci/probe_roms: Add missing __iomem annotation to pci_map_biosrom()
      x86/fpu/xsave: Keep __user annotation in casts
      x86/iommu: Drop duplicate const in __IOMMU_INIT
      x86/iommu: Use NULL instead of plain 0 for __IOMMU_INIT


 arch/x86/ia32/ia32_signal.c        | 11 ++++++-----
 arch/x86/ia32/sys_ia32.c           |  2 +-
 arch/x86/include/asm/iommu_table.h |  6 +++---
 arch/x86/include/asm/sys_ia32.h    |  2 +-
 arch/x86/include/asm/vdso.h        |  3 ++-
 arch/x86/kernel/cpu/common.c       |  8 +++++---
 arch/x86/kernel/probe_roms.c       |  2 +-
 arch/x86/kernel/xsave.c            |  6 +++---
 8 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 673ac9b..452d4dd 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -162,7 +162,8 @@ asmlinkage long sys32_sigaltstack(const stack_ia32_t __user *uss_ptr,
 	}
 	seg = get_fs();
 	set_fs(KERNEL_DS);
-	ret = do_sigaltstack(uss_ptr ? &uss : NULL, &uoss, regs->sp);
+	ret = do_sigaltstack((stack_t __force __user *) (uss_ptr ? &uss : NULL),
+			     (stack_t __force __user *) &uoss, regs->sp);
 	set_fs(seg);
 	if (ret >= 0 && uoss_ptr)  {
 		if (!access_ok(VERIFY_WRITE, uoss_ptr, sizeof(stack_ia32_t)))
@@ -361,7 +362,7 @@ static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
  */
 static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 				 size_t frame_size,
-				 void **fpstate)
+				 void __user **fpstate)
 {
 	unsigned long sp;
 
@@ -382,7 +383,7 @@ static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 
 	if (used_math()) {
 		sp = sp - sig_xstate_ia32_size;
-		*fpstate = (struct _fpstate_ia32 *) sp;
+		*fpstate = (struct _fpstate_ia32 __user *) sp;
 		if (save_i387_xstate_ia32(*fpstate) < 0)
 			return (void __user *) -1L;
 	}
@@ -448,7 +449,7 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 		 * These are actually not used anymore, but left because some
 		 * gdb versions depend on them as a marker.
 		 */
-		put_user_ex(*((u64 *)&code), (u64 *)frame->retcode);
+		put_user_ex(*((u64 *)&code), (u64 __user *)frame->retcode);
 	} put_user_catch(err);
 
 	if (err)
@@ -529,7 +530,7 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		 * Not actually used anymore, but left because some gdb
 		 * versions need it.
 		 */
-		put_user_ex(*((u64 *)&code), (u64 *)frame->retcode);
+		put_user_ex(*((u64 *)&code), (u64 __user *)frame->retcode);
 	} put_user_catch(err);
 
 	if (err)
diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 4540bec..c5b938d 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -287,7 +287,7 @@ asmlinkage long sys32_sigaction(int sig, struct old_sigaction32 __user *act,
 	return ret;
 }
 
-asmlinkage long sys32_waitpid(compat_pid_t pid, unsigned int *stat_addr,
+asmlinkage long sys32_waitpid(compat_pid_t pid, unsigned int __user *stat_addr,
 			      int options)
 {
 	return compat_sys_wait4(pid, stat_addr, options, NULL);
diff --git a/arch/x86/include/asm/iommu_table.h b/arch/x86/include/asm/iommu_table.h
index f229b13..f42a047 100644
--- a/arch/x86/include/asm/iommu_table.h
+++ b/arch/x86/include/asm/iommu_table.h
@@ -48,7 +48,7 @@ struct iommu_table_entry {
 
 
 #define __IOMMU_INIT(_detect, _depend, _early_init, _late_init, _finish)\
-	static const struct iommu_table_entry const			\
+	static const struct iommu_table_entry				\
 		__iommu_entry_##_detect __used				\
 	__attribute__ ((unused, __section__(".iommu_table"),		\
 			aligned((sizeof(void *)))))	\
@@ -63,10 +63,10 @@ struct iommu_table_entry {
  * to stop detecting the other IOMMUs after yours has been detected.
  */
 #define IOMMU_INIT_POST(_detect)					\
-	__IOMMU_INIT(_detect, pci_swiotlb_detect_4gb,  0, 0, 0)
+	__IOMMU_INIT(_detect, pci_swiotlb_detect_4gb,  NULL, NULL, 0)
 
 #define IOMMU_INIT_POST_FINISH(detect)					\
-	__IOMMU_INIT(_detect, pci_swiotlb_detect_4gb,  0, 0, 1)
+	__IOMMU_INIT(_detect, pci_swiotlb_detect_4gb,  NULL, NULL, 1)
 
 /*
  * A more sophisticated version of IOMMU_INIT. This variant requires:
diff --git a/arch/x86/include/asm/sys_ia32.h b/arch/x86/include/asm/sys_ia32.h
index 3fda9db4..4ca1c61 100644
--- a/arch/x86/include/asm/sys_ia32.h
+++ b/arch/x86/include/asm/sys_ia32.h
@@ -40,7 +40,7 @@ asmlinkage long sys32_sigaction(int, struct old_sigaction32 __user *,
 				struct old_sigaction32 __user *);
 asmlinkage long sys32_alarm(unsigned int);
 
-asmlinkage long sys32_waitpid(compat_pid_t, unsigned int *, int);
+asmlinkage long sys32_waitpid(compat_pid_t, unsigned int __user *, int);
 asmlinkage long sys32_sysfs(int, u32, u32);
 
 asmlinkage long sys32_sched_rr_get_interval(compat_pid_t,
diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index bb05228..fddb53d 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -11,7 +11,8 @@ extern const char VDSO32_PRELINK[];
 #define VDSO32_SYMBOL(base, name)					\
 ({									\
 	extern const char VDSO32_##name[];				\
-	(void *)(VDSO32_##name - VDSO32_PRELINK + (unsigned long)(base)); \
+	(void __user *)(VDSO32_##name - VDSO32_PRELINK +		\
+			(unsigned long)(base));				\
 })
 #endif
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a5fbc3c..1cc48ff 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1023,14 +1023,16 @@ void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 		printk(KERN_CONT "%s ", vendor);
 
 	if (c->x86_model_id[0])
-		printk(KERN_CONT "%s", c->x86_model_id);
+		printk(KERN_CONT "%s", strim(c->x86_model_id));
 	else
 		printk(KERN_CONT "%d86", c->x86);
 
+	printk(KERN_CONT " (fam: %02x, model: %02x", c->x86, c->x86_model);
+
 	if (c->x86_mask || c->cpuid_level >= 0)
-		printk(KERN_CONT " stepping %02x\n", c->x86_mask);
+		printk(KERN_CONT ", stepping: %02x)\n", c->x86_mask);
 	else
-		printk(KERN_CONT "\n");
+		printk(KERN_CONT ")\n");
 
 	print_cpu_msr(c);
 }
diff --git a/arch/x86/kernel/probe_roms.c b/arch/x86/kernel/probe_roms.c
index 0bc72e2..d5f15c3 100644
--- a/arch/x86/kernel/probe_roms.c
+++ b/arch/x86/kernel/probe_roms.c
@@ -150,7 +150,7 @@ static struct resource *find_oprom(struct pci_dev *pdev)
 	return oprom;
 }
 
-void *pci_map_biosrom(struct pci_dev *pdev)
+void __iomem *pci_map_biosrom(struct pci_dev *pdev)
 {
 	struct resource *oprom = find_oprom(pdev);
 
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 3d3e207..9e1a8a7 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -132,9 +132,9 @@ int check_for_xstate(struct i387_fxsave_struct __user *buf,
 	    fx_sw_user->xstate_size > fx_sw_user->extended_size)
 		return -EINVAL;
 
-	err = __get_user(magic2, (__u32 *) (((void *)fpstate) +
-					    fx_sw_user->extended_size -
-					    FP_XSTATE_MAGIC2_SIZE));
+	err = __get_user(magic2, (__u32 __user *) (fpstate +
+						   fx_sw_user->extended_size -
+						   FP_XSTATE_MAGIC2_SIZE));
 	if (err)
 		return err;
 	/*
