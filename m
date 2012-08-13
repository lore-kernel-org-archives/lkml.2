Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab2HMLUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 07:20:21 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:36397 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab2HMLUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 07:20:19 -0400
Date: Mon, 13 Aug 2012 13:20:13 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.6-rc1
Message-ID: <20120813132013.1fce081b@de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12081311-5024-0000-0000-0000037E383B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive some s390 patches on top of 3.6-rc1.
Included are bug fixes and a patch to enable system call filtering with BPF.

Heiko Carstens (4):
      s390/mm: remove MAX_PHYSADDR_BITS define
      s390/seccomp: add support for system call filtering using BPF
      s390/compat: fix compat wrappers for process_vm system calls
      s390/compat: fix mmap compat system calls

Jiri Kosina (1):
      s390: do not clobber personality flags in sys_32_personality()

Michael Holzheu (1):
      s390/sclp_sdias: Add missing break and "fall through"

 arch/s390/Kconfig                 |    1 +
 arch/s390/include/asm/sparsemem.h |    2 --
 arch/s390/include/asm/syscall.h   |   10 ++++++++++
 arch/s390/kernel/compat_linux.c   |    2 --
 arch/s390/kernel/compat_wrapper.S |    4 ++--
 arch/s390/kernel/ptrace.c         |    7 ++++++-
 arch/s390/kernel/sys_s390.c       |    9 +++++----
 drivers/s390/char/sclp_sdias.c    |    2 ++
 8 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 76de6b6..107610e 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -124,6 +124,7 @@ config S390
 	select GENERIC_TIME_VSYSCALL
 	select GENERIC_CLOCKEVENTS
 	select KTIME_SCALAR if 32BIT
+	select HAVE_ARCH_SECCOMP_FILTER
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
diff --git a/arch/s390/include/asm/sparsemem.h b/arch/s390/include/asm/sparsemem.h
index 0fb3402..a60d085 100644
--- a/arch/s390/include/asm/sparsemem.h
+++ b/arch/s390/include/asm/sparsemem.h
@@ -4,13 +4,11 @@
 #ifdef CONFIG_64BIT
 
 #define SECTION_SIZE_BITS	28
-#define MAX_PHYSADDR_BITS	46
 #define MAX_PHYSMEM_BITS	46
 
 #else
 
 #define SECTION_SIZE_BITS	25
-#define MAX_PHYSADDR_BITS	31
 #define MAX_PHYSMEM_BITS	31
 
 #endif /* CONFIG_64BIT */
diff --git a/arch/s390/include/asm/syscall.h b/arch/s390/include/asm/syscall.h
index fb214dd..fe7b997 100644
--- a/arch/s390/include/asm/syscall.h
+++ b/arch/s390/include/asm/syscall.h
@@ -12,6 +12,7 @@
 #ifndef _ASM_SYSCALL_H
 #define _ASM_SYSCALL_H	1
 
+#include <linux/audit.h>
 #include <linux/sched.h>
 #include <linux/err.h>
 #include <asm/ptrace.h>
@@ -87,4 +88,13 @@ static inline void syscall_set_arguments(struct task_struct *task,
 		regs->orig_gpr2 = args[0];
 }
 
+static inline int syscall_get_arch(struct task_struct *task,
+				   struct pt_regs *regs)
+{
+#ifdef CONFIG_COMPAT
+	if (test_tsk_thread_flag(task, TIF_31BIT))
+		return AUDIT_ARCH_S390;
+#endif
+	return sizeof(long) == 8 ? AUDIT_ARCH_S390X : AUDIT_ARCH_S390;
+}
 #endif	/* _ASM_SYSCALL_H */
diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index d122508..f606d93 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -620,7 +620,6 @@ asmlinkage unsigned long old32_mmap(struct mmap_arg_struct_emu31 __user *arg)
 		return -EFAULT;
 	if (a.offset & ~PAGE_MASK)
 		return -EINVAL;
-	a.addr = (unsigned long) compat_ptr(a.addr);
 	return sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd,
 			      a.offset >> PAGE_SHIFT);
 }
@@ -631,7 +630,6 @@ asmlinkage long sys32_mmap2(struct mmap_arg_struct_emu31 __user *arg)
 
 	if (copy_from_user(&a, arg, sizeof(a)))
 		return -EFAULT;
-	a.addr = (unsigned long) compat_ptr(a.addr);
 	return sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd, a.offset);
 }
 
diff --git a/arch/s390/kernel/compat_wrapper.S b/arch/s390/kernel/compat_wrapper.S
index e835d6d..2d82cfc 100644
--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -1635,7 +1635,7 @@ ENTRY(compat_sys_process_vm_readv_wrapper)
 	llgfr	%r6,%r6			# unsigned long
 	llgf	%r0,164(%r15)		# unsigned long
 	stg	%r0,160(%r15)
-	jg	sys_process_vm_readv
+	jg	compat_sys_process_vm_readv
 
 ENTRY(compat_sys_process_vm_writev_wrapper)
 	lgfr	%r2,%r2			# compat_pid_t
@@ -1645,4 +1645,4 @@ ENTRY(compat_sys_process_vm_writev_wrapper)
 	llgfr	%r6,%r6			# unsigned long
 	llgf	%r0,164(%r15)		# unsigned long
 	stg	%r0,160(%r15)
-	jg	sys_process_vm_writev
+	jg	compat_sys_process_vm_writev
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index f4eb376..e4be113 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -719,7 +719,11 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 	long ret = 0;
 
 	/* Do the secure computing check first. */
-	secure_computing_strict(regs->gprs[2]);
+	if (secure_computing(regs->gprs[2])) {
+		/* seccomp failures shouldn't expose any additional code. */
+		ret = -1;
+		goto out;
+	}
 
 	/*
 	 * The sysc_tracesys code in entry.S stored the system
@@ -745,6 +749,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 			    regs->gprs[2], regs->orig_gpr2,
 			    regs->gprs[3], regs->gprs[4],
 			    regs->gprs[5]);
+out:
 	return ret ?: regs->gprs[2];
 }
 
diff --git a/arch/s390/kernel/sys_s390.c b/arch/s390/kernel/sys_s390.c
index b4a29ee..d0964d2 100644
--- a/arch/s390/kernel/sys_s390.c
+++ b/arch/s390/kernel/sys_s390.c
@@ -81,11 +81,12 @@ SYSCALL_DEFINE1(s390_personality, unsigned int, personality)
 {
 	unsigned int ret;
 
-	if (current->personality == PER_LINUX32 && personality == PER_LINUX)
-		personality = PER_LINUX32;
+	if (personality(current->personality) == PER_LINUX32 &&
+	    personality(personality) == PER_LINUX)
+		personality |= PER_LINUX32;
 	ret = sys_personality(personality);
-	if (ret == PER_LINUX32)
-		ret = PER_LINUX;
+	if (personality(ret) == PER_LINUX32)
+		ret &= ~PER_LINUX32;
 
 	return ret;
 }
diff --git a/drivers/s390/char/sclp_sdias.c b/drivers/s390/char/sclp_sdias.c
index 6a6f76b..b103293 100644
--- a/drivers/s390/char/sclp_sdias.c
+++ b/drivers/s390/char/sclp_sdias.c
@@ -242,11 +242,13 @@ int sclp_sdias_copy(void *dest, int start_blk, int nr_blks)
 	switch (sdias_evbuf.event_status) {
 		case EVSTATE_ALL_STORED:
 			TRACE("all stored\n");
+			break;
 		case EVSTATE_PART_STORED:
 			TRACE("part stored: %i\n", sdias_evbuf.blk_cnt);
 			break;
 		case EVSTATE_NO_DATA:
 			TRACE("no data\n");
+			/* fall through */
 		default:
 			pr_err("Error from SCLP while copying hsa. "
 			       "Event status = %x\n",

