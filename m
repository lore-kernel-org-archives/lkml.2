Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab0KBXHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 19:07:01 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:45339 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab0KBXG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 19:06:56 -0400
X-Greylist: delayed 1777 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Nov 2010 19:06:55 EDT
Message-ID: <4CD09235.9010107@cs.columbia.edu>
Date: Tue, 02 Nov 2010 18:35:33 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Lightning/1.0b1 Thunderbird/3.0.8
MIME-Version: 1.0
To: ksummit-2010-discuss@lists.linux-foundation.org
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: checkpoint-restart: naked patch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resending with the missing CC's]

Hi,

Following the discussion yesterday, here is a linux-cr diff that
that is limited to changes to existing code.

The diff doesn't include the eclone() patches. I also tried to strip
off the new c/r code (either code in new files, or new code within
#ifdef CONFIG_CHECKPOINT in existing files).

I left a few such snippets in, e.g. c/r syscalls templates and declaration of
c/r specific methods in, e.g. file_operations.

The remaining changes in this patch include new freezer state
("CHECKPOINTING"), mostly refactoring of exsiting code, and a bit
of new helpers.

Disclaimer: don't try to compile (or apply) - this is *only* intended
to give a ballpark of how the c/r patches change existing code.

Thanks,

Oren.


 Documentation/cgroups/freezer-subsystem.txt |   10 ++
 Documentation/credentials.txt               |   14 ++
 MAINTAINERS                                 |   12 ++
 Makefile                                    |    2 +-
 arch/arm/Kconfig                            |    4 +
 arch/arm/include/asm/ptrace.h               |    1 +
 arch/arm/include/asm/syscall.h              |   32 ++++
 arch/arm/include/asm/unistd.h               |    3 +
 arch/arm/kernel/Makefile                    |    1 +
 arch/arm/kernel/calls.S                     |    3 +
 arch/arm/kernel/entry-common.S              |    6 +
 arch/arm/kernel/ptrace.c                    |   69 +++++++++
 arch/arm/kernel/signal.c                    |    5 +
 arch/arm/kernel/sys_arm.c                   |   13 ++
 arch/powerpc/Kconfig                        |    3 +
 arch/powerpc/include/asm/Kbuild             |    1 +
 arch/powerpc/include/asm/elf.h              |    1 +
 arch/powerpc/include/asm/ptrace.h           |    7 +
 arch/powerpc/include/asm/systbl.h           |    2 +
 arch/powerpc/include/asm/unistd.h           |    4 +-
 arch/powerpc/kernel/Makefile                |    1 +
 arch/powerpc/kernel/entry_32.S              |   23 +++
 arch/powerpc/kernel/entry_64.S              |   16 ++
 arch/powerpc/kernel/process.c               |    1 +
 arch/powerpc/kernel/ptrace.c                |   83 ++++++++---
 arch/powerpc/kernel/signal.c                |    6 +
 arch/powerpc/kernel/vdso.c                  |   13 ++-
 arch/s390/Kconfig                           |    4 +
 arch/s390/include/asm/Kbuild                |    1 +
 arch/s390/include/asm/elf.h                 |    2 +-
 arch/s390/include/asm/thread_info.h         |    2 +
 arch/s390/include/asm/unistd.h              |    4 +-
 arch/s390/kernel/Makefile                   |    1 +
 arch/s390/kernel/compat_wrapper.S           |   16 ++
 arch/s390/kernel/process.c                  |   27 ++++
 arch/s390/kernel/signal.c                   |   21 +++
 arch/s390/kernel/syscalls.S                 |    2 +
 arch/s390/kernel/vdso.c                     |   13 ++-
 arch/s390/mm/Makefile                       |    1 +
 arch/sh/include/asm/elf.h                   |    1 +
 arch/sh/kernel/vsyscall/vsyscall.c          |    2 +-
 arch/x86/Kconfig                            |    4 +
 arch/x86/ia32/ia32entry.S                   |    9 +
 arch/x86/include/asm/Kbuild                 |    1 +
 arch/x86/include/asm/elf.h                  |    3 +-
 arch/x86/include/asm/ldt.h                  |    7 +
 arch/x86/include/asm/syscalls.h             |    6 +
 arch/x86/include/asm/unistd_32.h            |    4 +-
 arch/x86/include/asm/unistd_64.h            |    4 +
 arch/x86/kernel/Makefile                    |   10 ++
 arch/x86/kernel/entry_32.S                  |    8 +
 arch/x86/kernel/entry_64.S                  |    7 +
 arch/x86/kernel/signal.c                    |    5 +
 arch/x86/kernel/syscall_table_32.S          |    2 +
 arch/x86/vdso/vdso32-setup.c                |    9 +-
 arch/x86/vdso/vma.c                         |   11 +-
 drivers/char/pty.c                          |   42 +++++-
 drivers/char/tty_io.c                       |   35 ++++-
 drivers/net/loopback.c                      |    9 +-
 drivers/net/macvlan.c                       |    3 +
 drivers/net/veth.c                          |    3 +
 fs/Makefile                                 |    1 +
 fs/binfmt_elf.c                             |    2 +-
 fs/devpts/inode.c                           |   13 ++-
 fs/eventfd.c                                |    1 +
 fs/eventpoll.c                              |   70 ++++++----
 fs/exec.c                                   |   71 ++++++++-
 fs/fcntl.c                                  |   21 ++-
 fs/fs_struct.c                              |   21 +++
 fs/namespace.c                              |   36 +++--
 fs/nilfs2/dir.c                             |    1 -
 fs/notify/dnotify/dnotify.c                 |   18 +++
 fs/open.c                                   |   58 +++++---
 fs/pipe.c                                   |    1 +
 fs/read_write.c                             |   10 --
 fs/select.c                                 |    2 +-
 fs/splice.c                                 |   78 ++++++-----
 fs/squashfs/dir.c                           |    2 +-
 include/linux/Kbuild                        |    3 +
 include/linux/aio.h                         |    2 +
 include/linux/compat.h                      |    3 +-
 include/linux/cred.h                        |    8 +
 include/linux/devpts_fs.h                   |    6 +-
 include/linux/dnotify.h                     |    6 +
 include/linux/eventpoll.h                   |    6 +-
 include/linux/freezer.h                     |    9 +
 include/linux/fs.h                          |   35 +++++-
 include/linux/fs_struct.h                   |    2 +
 include/linux/futex.h                       |   12 ++
 include/linux/hrtimer.h                     |    8 +-
 include/linux/magic.h                       |    3 +
 include/linux/mm.h                          |   38 +++++
 include/linux/net.h                         |   11 ++
 include/linux/netdevice.h                   |    6 +
 include/linux/poll.h                        |    3 +
 include/linux/posix-timers.h                |   15 ++
 include/linux/resource.h                    |    1 +
 include/linux/sched.h                       |   10 +-
 include/linux/security.h                    |   11 ++
 include/linux/sem.h                         |    2 +
 include/linux/shm.h                         |    7 +
 include/linux/signal.h                      |    3 +
 include/linux/splice.h                      |    9 +
 include/linux/tty.h                         |    4 +
 include/linux/user.h                        |    9 +
 include/linux/user_namespace.h              |    8 +
 include/linux/utsname.h                     |    1 +
 include/net/af_unix.h                       |    1 +
 include/net/sock.h                          |   48 ++++++
 init/Kconfig                                |   10 +-
 ipc/Makefile                                |    3 +-
 ipc/msg.c                                   |   23 ++--
 ipc/msgutil.c                               |    8 -
 ipc/namespace.c                             |    2 +-
 ipc/sem.c                                   |  113 ++++++++++-----
 ipc/shm.c                                   |   55 ++++++--
 ipc/util.c                                  |   42 ++++--
 ipc/util.h                                  |   32 ++++-
 kernel/Makefile                             |    2 +
 kernel/capability.c                         |   96 +++++++++++--
 kernel/cgroup_freezer.c                     |  214 ++++++++++++++++++++------
 kernel/compat.c                             |    4 +-
 kernel/cred.c                               |  116 +++++++++++++++
 kernel/exit.c                               |   11 ++-
 kernel/fork.c                               |   10 ++
 kernel/futex.c                              |   31 ++---
 kernel/futex_compat.c                       |   13 ++-
 kernel/groups.c                             |    1 +
 kernel/nsproxy.c                            |    5 +
 kernel/posix-cpu-timers.c                   |    9 -
 kernel/posix-timers.c                       |    2 +-
 kernel/signal.c                             |   13 ++
 kernel/sys.c                                |  170 ++++++----------------
 kernel/sys_ni.c                             |    4 +
 kernel/sysctl.c                             |    1 +
 kernel/user.c                               |    5 +
 kernel/user_namespace.c                     |   54 +++++--
 kernel/utsname.c                            |    3 +-
 kernel/utsname_sysctl.c                     |    7 +
 lib/Kconfig.debug                           |   13 ++
 mm/Makefile                                 |    1 +
 mm/filemap.c                                |    1 +
 mm/memory.c                                 |   95 ++++++++++++-
 mm/mmap.c                                   |   39 +++++-
 mm/shmem.c                                  |   16 +--
 net/Kconfig                                 |    4 +
 net/Makefile                                |    3 +
 net/ipv4/Makefile                           |    1 +
 net/ipv4/af_inet.c                          |    6 +
 net/ipv6/sit.c                              |    3 +
 net/socket.c                                |   31 +---
 net/unix/Makefile                           |    1 +
 security/capability.c                       |    1 +
 security/commoncap.c                        |   19 +--
 security/selinux/include/classmap.h         |    9 +-
 security/smack/smack.h                      |    1 +
 security/smack/smack_lsm.c                  |    1 +
 security/smack/smackfs.c                    |    1 +
 159 files changed, 2031 insertions(+), 587 deletions(-)

diff --git a/Documentation/cgroups/freezer-subsystem.txt
b/Documentation/cgroups/freezer-subsystem.txt
index 41f37fe..92b68e6 100644
--- a/Documentation/cgroups/freezer-subsystem.txt
+++ b/Documentation/cgroups/freezer-subsystem.txt
@@ -100,3 +100,13 @@ things happens:
 		and returns EINVAL)
 	3) The tasks that blocked the cgroup from entering the "FROZEN"
 		state disappear from the cgroup's set of tasks.
+
+When the cgroup freezer is used to guard container checkpoint operations the
+freezer.state may be "CHECKPOINTING". "CHECKPOINTING" can only be set on a
+"FROZEN" cgroup using the checkpoint system call. Once in the "CHECKPOINTING"
+state, the cgroup may not leave until the checkpoint system call returns the
+freezer state to "FROZEN". Writing any new state to freezer.state while
+checkpointing will return EBUSY. These semantics ensure that userspace cannot
+unfreeze the cgroup midway through the checkpoint system call. Note that,
+unlike "FROZEN" and "FREEZING", there is no corresponding "CHECKPOINTED"
+state.
diff --git a/Documentation/credentials.txt b/Documentation/credentials.txt
index df03169..55dd589 100644
--- a/Documentation/credentials.txt
+++ b/Documentation/credentials.txt
@@ -530,6 +530,20 @@ A typical credentials alteration function would look
something like this:
 	}
  +SETUID/SETGID HELPERS
+---------------------
+
+Helpers exist to perform the core of uid and gid alterations:
+
+cred_setresuid(struct cred *new, uid_t ruid, uid_t euid, uid_t suid);
+cred_setresgid(struct cred *new, gid_t rgid, gid_t egid, gid_t sgid);
+cred_setfsuid(struct cred *new, uid_t uid, uid_t *old_fsuid);
+cred_setfsgid(struct cred *new, gid_t gid, gid_t *old_fsgid);
+
+These helpers are used in kernel/sys.c for the analogous syscalls.
+As can be seen in those examples, these helpers are to be wrapped
+between calls to prepare_creds() and commit_creds() or abort_creds().
+
 MANAGING CREDENTIALS
 --------------------
 diff --git a/MAINTAINERS b/MAINTAINERS
index a0e3c3a..e4494d2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1501,6 +1501,18 @@ M:	Andy Whitcroft <apw@canonical.com>
 S:	Supported
 F:	scripts/checkpatch.pl
 +CHECKPOINT-RESTART
+M:	Oren Laadan <orenl@cs.columbia.edu>
+M:	Serge E. Hallyn <serue@us.ibm.com>
+L:	containers@lists.linux-foundation.org
+W:	http://ckpt.wiki.kernel.org/index.php/Main_Page
+S:	Maintained
+F:	*checkpoint*
+K:	checkpoint
+K:	restore
+K:	ckpt
+K:	c/r
+
 CISCO 10G ETHERNET DRIVER
 M:	Scott Feldman <scofeldm@cisco.com>
 M:	Joe Eykholt <jeykholt@cisco.com>
diff --git a/Makefile b/Makefile
index fa1db90..93be4e1 100644
--- a/Makefile
+++ b/Makefile
@@ -409,7 +409,7 @@ endif
 # of make so .config is not included in this case either (for *config).
  no-dot-config-targets := clean mrproper distclean \
-			 cscope TAGS tags help %docs check% \
+			 cscope TAGS tags help %docs checkstack \
 			 include/linux/version.h headers_% \
 			 kernelrelease kernelversion
 diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c5408bf..14c7c84 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -100,6 +100,10 @@ config HAVE_LATENCYTOP_SUPPORT
 	depends on !SMP
 	default y
 +config CHECKPOINT_SUPPORT
+	bool
+	default y
+
 config LOCKDEP_SUPPORT
 	bool
 	default y
diff --git a/arch/arm/include/asm/ptrace.h b/arch/arm/include/asm/ptrace.h
index 9dcb11e..9999568 100644
--- a/arch/arm/include/asm/ptrace.h
+++ b/arch/arm/include/asm/ptrace.h
@@ -57,6 +57,7 @@
 #define PSR_C_BIT	0x20000000
 #define PSR_Z_BIT	0x40000000
 #define PSR_N_BIT	0x80000000
+#define PSR_GE_BITS	0x000f0000
  /*
  * Groups of PSR bits
diff --git a/arch/arm/include/asm/syscall.h b/arch/arm/include/asm/syscall.h
new file mode 100644
index 0000000..1a6ca68
--- /dev/null
+++ b/arch/arm/include/asm/syscall.h
@@ -0,0 +1,32 @@
+/*
+ * syscall.h - Linux syscall interfaces for ARM
+ *
+ * Copyright (c) 2010 Christoffer Dall
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#ifndef _ASM_ARM_SYSCALLS_H
+#define _ASM_ARM_SYSCALLS_H
+
+#include <linux/highmem.h>
+#include <linux/pagemap.h>
+#include <linux/memory.h>
+#include <asm/unistd.h>
+
+int syscall_get_nr(struct task_struct *task, struct pt_regs *regs);
+
+static inline long syscall_get_return_value(struct task_struct *task,
+					    struct pt_regs *regs)
+{
+	return regs->ARM_r0;
+}
+
+static inline long syscall_get_error(struct task_struct *task,
+				     struct pt_regs *regs)
+{
+	return regs->ARM_r0;
+}
+
+#endif /* _ASM_ARM_SYSCALLS_H */
diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index dd2bf53..89484b4 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -392,6 +392,9 @@
 #define __NR_rt_tgsigqueueinfo		(__NR_SYSCALL_BASE+363)
 #define __NR_perf_event_open		(__NR_SYSCALL_BASE+364)
 #define __NR_recvmmsg			(__NR_SYSCALL_BASE+365)
+#define __NR_eclone			(__NR_SYSCALL_BASE+366)
+#define __NR_checkpoint			(__NR_SYSCALL_BASE+367)
+#define __NR_restart			(__NR_SYSCALL_BASE+368)
  /*
  * The following SWIs are ARM private.
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 26d302c..bfe39d8 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_ARM_THUMBEE)	+= thumbee.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_ARM_UNWIND)	+= unwind.o
 obj-$(CONFIG_HAVE_TCM)		+= tcm.o
+obj-$(CONFIG_CHECKPOINT)	+= checkpoint.o
  obj-$(CONFIG_CRUNCH)		+= crunch.o crunch-bits.o
 AFLAGS_crunch-bits.o		:= -Wa,-mcpu=ep9312
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index 37ae301..aa38a4e 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -375,6 +375,9 @@
 		CALL(sys_rt_tgsigqueueinfo)
 		CALL(sys_perf_event_open)
 /* 365 */	CALL(sys_recvmmsg)
+		CALL(sys_eclone_wrapper)
+		CALL(sys_checkpoint)
+		CALL(sys_restart)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 2c1db77..ba365dc 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -380,6 +380,12 @@ sys_clone_wrapper:
 		b	sys_clone
 ENDPROC(sys_clone_wrapper)
 +sys_eclone_wrapper:
+		add	ip, sp, #S_OFF
+		str	ip, [sp, #0]
+		b	sys_eclone
+ENDPROC(sys_eclone_wrapper)
+
 sys_sigreturn_wrapper:
 		add	r0, sp, #S_OFF
 		b	sys_sigreturn
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 3f562a7..26ac9ef 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -23,6 +23,7 @@
 #include <asm/pgtable.h>
 #include <asm/system.h>
 #include <asm/traps.h>
+#include <asm/syscall.h>
  #include "ptrace.h"
 @@ -863,3 +864,71 @@ asmlinkage int syscall_trace(int why, struct pt_regs
*regs, int scno)
  	return current_thread_info()->syscall;
 }
+
+/*
+ * This function essentially duplicates the logic from vector_swi in
+ * arch/arm/kernel/entry-common.S. However, that code is in the
+ * critical path for system calls and is hard to factor out without
+ * compromising performance.
+ */
+int syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
+{
+	int ret;
+	int scno;
+	unsigned long instr;
+	bool config_oabi = false;
+	bool config_aeabi = false;
+	bool config_arm_thumb = false;
+	bool config_cpu_endian_be8 = false;
+
+#ifdef CONFIG_OABI_COMPAT
+	config_oabi = true;
+#endif
+#ifdef CONFIG_AEABI
+	config_aeabi = true;
+#endif
+#ifdef CONFIG_ARM_THUMB
+	config_arm_thumb = true;
+#endif
+#ifdef CONFIG_CPU_ENDIAN_BE8
+	config_cpu_endian_be8 = true;
+#endif
+#ifdef CONFIG_CPU_ARM710
+	return -1;
+#endif
+
+	if (config_aeabi && !config_oabi) {
+		/* Pure EABI */
+		return regs->ARM_r7;
+	} else if (config_oabi) {
+		if (config_arm_thumb && (regs->ARM_cpsr & PSR_T_BIT))
+			return -1;
+
+		ret = access_process_vm(task, regs->ARM_pc - 4, &instr,
+					sizeof(unsigned long), 0);
+		if (ret != sizeof(unsigned long))
+			return -1;
+
+		if (config_cpu_endian_be8)
+			asm ("rev %[out], %[in]": [out] "=r" (instr):
+						  [in] "r" (instr));
+
+		if ((instr & 0x00ffffff) == 0)
+			return regs->ARM_r7; /* EABI call */
+		else
+			return (instr & 0x00ffffff) | __NR_OABI_SYSCALL_BASE;
+	} else {
+		 /* Legacy ABI only */
+		if (config_arm_thumb && (regs->ARM_cpsr & PSR_T_BIT)) {
+			/* Thumb mode ABI */
+			scno = regs->ARM_r7 + __NR_SYSCALL_BASE;
+		} else {
+			ret = access_process_vm(task, regs->ARM_pc - 4, &instr,
+						sizeof(unsigned long), 0);
+			if (ret != sizeof(unsigned long))
+				return -1;
+			scno = instr;
+		}
+		return scno & 0x00ffffff;
+	}
+}
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 907d5a6..d37ef41 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -773,6 +773,11 @@ static void do_signal(struct pt_regs *regs, int syscall)
 	single_step_set(current);
 }
 +int task_has_saved_sigmask(struct task_struct *task)
+{
+	return !!(task_thread_info(task)->flags & _TIF_RESTORE_SIGMASK);
+}
+
 asmlinkage void
 do_notify_resume(struct pt_regs *regs, unsigned int thread_flags, int syscall)
 {
diff --git a/arch/arm/kernel/sys_arm.c b/arch/arm/kernel/sys_arm.c
index c235018..5473ebd 100644
--- a/arch/arm/kernel/sys_arm.c
+++ b/arch/arm/kernel/sys_arm.c
@@ -27,6 +27,7 @@
 #include <linux/ipc.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
+#include <linux/checkpoint.h>
  /* Fork a new task - this creates a new program thread.
  * This is called indirectly via a small wrapper
@@ -127,3 +128,15 @@ asmlinkage long sys_arm_fadvise64_64(int fd, int advice,
 {
 	return sys_fadvise64_64(fd, offset, len, advice);
 }
+
+asmlinkage long sys_checkpoint(unsigned long pid, unsigned long fd,
+			       unsigned long flags, unsigned long logfd)
+{
+	return do_sys_checkpoint(pid, fd, flags, logfd);
+}
+
+asmlinkage long sys_restart(unsigned long pid, unsigned long fd,
+			    unsigned long flags, unsigned long logfd)
+{
+	return do_sys_restart(pid, fd, flags, logfd);
+}
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 2e19500..16416b0 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -26,6 +26,9 @@ config MMU
 	bool
 	default y
 +config CHECKPOINT_SUPPORT
+	def_bool y
+
 config GENERIC_CMOS_UPDATE
 	def_bool y
 diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
index 5ab7d7f..20379f1 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -12,6 +12,7 @@ header-y += shmbuf.h
 header-y += socket.h
 header-y += termbits.h
 header-y += fcntl.h
+header-y += checkpoint_hdr.h
 header-y += poll.h
 header-y += sockios.h
 header-y += ucontext.h
diff --git a/arch/powerpc/include/asm/elf.h b/arch/powerpc/include/asm/elf.h
index c376eda..0b06255 100644
--- a/arch/powerpc/include/asm/elf.h
+++ b/arch/powerpc/include/asm/elf.h
@@ -266,6 +266,7 @@ extern int ucache_bsize;
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES
 struct linux_binprm;
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
+				       unsigned long start,
 				       int uses_interp);
 #define VDSO_AUX_ENT(a,b) NEW_AUX_ENT(a,b);
 diff --git a/arch/powerpc/include/asm/ptrace.h b/arch/powerpc/include/asm/ptrace.h
index 9e2d84c..a88d711 100644
--- a/arch/powerpc/include/asm/ptrace.h
+++ b/arch/powerpc/include/asm/ptrace.h
@@ -87,6 +87,8 @@ struct pt_regs {
  #ifndef __ASSEMBLY__
 +#include <linux/types.h>
+
 #define instruction_pointer(regs) ((regs)->nip)
 #define user_stack_pointer(regs) ((regs)->gpr[1])
 #define regs_return_value(regs) ((regs)->gpr[3])
@@ -141,6 +143,11 @@ do {									      \
 #define arch_has_block_step()	(!cpu_has_feature(CPU_FTR_601))
 #define ARCH_HAS_USER_SINGLE_STEP_INFO
 +/* for reprogramming DABR/DAC during restart of a checkpointed task */
+extern bool debugreg_valid(unsigned long val, unsigned int index);
+extern void debugreg_update(struct task_struct *task, unsigned long val,
+			    unsigned int index);
+
 #endif /* __ASSEMBLY__ */
  #endif /* __KERNEL__ */
diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index f94fc43..b5afba3 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -327,3 +327,5 @@ COMPAT_SYS_SPU(preadv)
 COMPAT_SYS_SPU(pwritev)
 COMPAT_SYS(rt_tgsigqueueinfo)
 PPC_SYS(eclone)
+PPC_SYS(checkpoint)
+PPC_SYS(restart)
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index 4cdbd5c..54f6ecb 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -346,10 +346,12 @@
 #define __NR_pwritev		321
 #define __NR_rt_tgsigqueueinfo	322
 #define __NR_eclone		323
+#define __NR_checkpoint		324
+#define __NR_restart		325
  #ifdef __KERNEL__
 -#define __NR_syscalls		324
+#define __NR_syscalls		326
  #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 8773263..6d294a4 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -63,6 +63,7 @@ obj64-$(CONFIG_HIBERNATION)	+= swsusp_asm64.o
 obj-$(CONFIG_MODULES)		+= module.o module_$(CONFIG_WORD_SIZE).o
 obj-$(CONFIG_44x)		+= cpu_setup_44x.o
 obj-$(CONFIG_FSL_BOOKE)		+= cpu_setup_fsl_booke.o dbell.o
+obj-$(CONFIG_CHECKPOINT)	+= checkpoint.o
  extra-y				:= head_$(CONFIG_WORD_SIZE).o
 extra-$(CONFIG_PPC_BOOK3E_32)	:= head_new_booke.o
diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 579f1da..853814b 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -594,6 +594,29 @@ ppc_eclone:
 	stw	r0,_TRAP(r1)		/* register set saved */
 	b	sys_eclone
 +/* To handle self-checkpoint we must save nvpgprs */
+	.globl	ppc_checkpoint
+ppc_checkpoint:
+	SAVE_NVGPRS(r1)
+	lwz	r0,_TRAP(r1)
+	rlwinm	r0,r0,0,0,30		/* clear LSB to indicate full */
+	stw	r0,_TRAP(r1)		/* register set saved */
+	b	sys_checkpoint
+
+/* The full register set must be restored upon return from restart.
+ * Save nvgprs unconditionally so the caller's state is
+ * restored correctly in case of error.
+ */
+	.globl	ppc_restart
+ppc_restart:
+	SAVE_NVGPRS(r1)
+	lwz	r0,_TRAP(r1)
+	rlwinm	r0,r0,0,0,30		/* clear LSB to indicate full */
+	stw	r0,_TRAP(r1)		/* register set saved */
+	bl	sys_restart
+	REST_NVGPRS(r1)
+	b ret_from_syscall
+
 	.globl	ppc_swapcontext
 ppc_swapcontext:
 	SAVE_NVGPRS(r1)
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index b763340..228f592 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -349,6 +349,22 @@ _GLOBAL(ppc_eclone)
 	bl	.sys_eclone
 	b	syscall_exit
 +/* To handle self-checkpoint we must save nvpgprs */
+_GLOBAL(ppc_checkpoint)
+	bl	.save_nvgprs
+	bl	.sys_checkpoint
+	b	syscall_exit
+
+/* The full register set must be restored upon return from restart.
+ * Save nvgprs unconditionally so the caller's state is
+ * restored correctly in case of error.
+ */
+_GLOBAL(ppc_restart)
+	bl	.save_nvgprs
+	bl	.sys_restart
+	REST_NVGPRS(r1)
+	b	syscall_exit
+
 _GLOBAL(ppc32_swapcontext)
 	bl	.save_nvgprs
 	bl	.compat_sys_swapcontext
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index b183287..1664586 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -30,6 +30,7 @@
 #include <linux/init_task.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
+#include <linux/checkpoint.h>
 #include <linux/mqueue.h>
 #include <linux/hardirq.h>
 #include <linux/utsname.h>
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index ed2cfe1..972e6a1 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -763,19 +763,23 @@ void user_disable_single_step(struct task_struct *task)
 	clear_tsk_thread_flag(task, TIF_SINGLESTEP);
 }
 -int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
-			       unsigned long data)
+/**
+ * debugreg_valid() - validate the value to be written to a debug register
+ * @val:	The prospective contents of the register.
+ * @index:	Must be zero.
+ *
+ * Returns true if @val is an acceptable value for the register indicated by
+ * @index, false otherwise.
+ */
+bool debugreg_valid(unsigned long val, unsigned int index)
 {
-	/* For ppc64 we support one DABR and no IABR's at the moment (ppc64).
-	 *  For embedded processors we support one DAC and no IAC's at the
-	 *  moment.
-	 */
-	if (addr > 0)
-		return -EINVAL;
+	/* We support only one debug register for now */
+	if (index != 0)
+		return false;
  	/* The bottom 3 bits in dabr are flags */
-	if ((data & ~0x7UL) >= TASK_SIZE)
-		return -EIO;
+	if ((val & ~0x7UL) >= TASK_SIZE)
+		return false;
  #ifndef CONFIG_PPC_ADV_DEBUG_REGS
 	/* For processors using DABR (i.e. 970), the bottom 3 bits are flags.
@@ -791,19 +795,38 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned
long addr,
 	 */
  	/* Ensure breakpoint translation bit is set */
-	if (data && !(data & DABR_TRANSLATION))
-		return -EIO;
-
-	/* Move contents to the DABR register */
-	task->thread.dabr = data;
-#else /* CONFIG_PPC_ADV_DEBUG_REGS */
+	if (val && !(val & DABR_TRANSLATION))
+		return false;
+#else
 	/* As described above, it was assumed 3 bits were passed with the data
 	 *  address, but we will assume only the mode bits will be passed
 	 *  as to not cause alignment restrictions for DAC-based processors.
 	 */
 +	/* Read or Write bits must be set */
+	if (!(val & 0x3UL))
+		return -EINVAL;
+#endif
+	return true;
+}
+
+/**
+ * debugreg_update() - update a debug register associated with a task
+ * @task:	The task whose register state is to be modified.
+ * @val:	The value to be written to the debug register.
+ * @index:	Specifies the debug register.  Currently unused.
+ *
+ * Set a task's DABR/DAC to @val, which should be validated with
+ * debugreg_valid() beforehand.
+ */
+void debugreg_update(struct task_struct *task, unsigned long val,
+		     unsigned int index)
+{
+#ifndef CONFIG_PPC_ADV_DEBUG_REGS
+	task->thread.dabr = val;
+#else
 	/* DAC's hold the whole address without any mode flags */
-	task->thread.dac1 = data & ~0x3UL;
+	task->thread.dabr = val & ~0x3UL;
  	if (task->thread.dac1 == 0) {
 		dbcr_dac(task) &= ~(DBCR_DAC1R | DBCR_DAC1W);
@@ -812,13 +835,8 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned
long addr,
 			task->thread.regs->msr &= ~MSR_DE;
 			task->thread.dbcr0 &= ~DBCR0_IDM;
 		}
-		return 0;
 	}
 -	/* Read or Write bits must be set */
-
-	if (!(data & 0x3UL))
-		return -EINVAL;
  	/* Set the Internal Debugging flag (IDM bit 1) for the DBCR0
 	   register */
@@ -827,12 +845,29 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned
long addr,
 	/* Check for write and read flags and set DBCR0
 	   accordingly */
 	dbcr_dac(task) &= ~(DBCR_DAC1R|DBCR_DAC1W);
-	if (data & 0x1UL)
+	if (val & 0x1UL)
 		dbcr_dac(task) |= DBCR_DAC1R;
-	if (data & 0x2UL)
+	if (val & 0x2UL)
 		dbcr_dac(task) |= DBCR_DAC1W;
 	task->thread.regs->msr |= MSR_DE;
 #endif /* CONFIG_PPC_ADV_DEBUG_REGS */
+}
+
+static int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
+			       unsigned long data)
+{
+	/* For ppc64 we support one DABR and no IABR's at the moment (ppc64).
+	 * For embedded processors we support one DAC and no IAC's at the
+	 * moment.
+	 */
+	if (addr > 0)
+		return -EINVAL;
+
+	if (!debugreg_valid(data, 0))
+		return -EIO;
+
+	debugreg_update(task, data, 0);
+
 	return 0;
 }
 diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
index a0afb55..b3337ad 100644
--- a/arch/powerpc/kernel/signal.c
+++ b/arch/powerpc/kernel/signal.c
@@ -186,6 +186,12 @@ static int do_signal_pending(sigset_t *oldset, struct
pt_regs *regs)
 	return ret;
 }
 +int task_has_saved_sigmask(struct task_struct *task)
+{
+	struct thread_info *ti = task_thread_info(task);
+	return !!(ti->local_flags & _TLF_RESTORE_SIGMASK);
+}
+
 void do_signal(struct pt_regs *regs, unsigned long thread_info_flags)
 {
 	if (thread_info_flags & _TIF_SIGPENDING)
diff --git a/arch/powerpc/kernel/vdso.c b/arch/powerpc/kernel/vdso.c
index d84d192..74210ab 100644
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -188,7 +188,8 @@ static void dump_vdso_pages(struct vm_area_struct * vma)
  * This is called from binfmt_elf, we create the special vma for the
  * vDSO and insert it into the mm struct tree
  */
-int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+int arch_setup_additional_pages(struct linux_binprm *bprm,
+				unsigned long start, int uses_interp)
 {
 	struct mm_struct *mm = current->mm;
 	struct page **vdso_pagelist;
@@ -220,6 +221,10 @@ int arch_setup_additional_pages(struct linux_binprm *bprm,
int uses_interp)
 	vdso_base = VDSO32_MBASE;
 #endif
 +	/* in case restart(2) mandates a specific location */
+	if (start)
+		vdso_base = start;
+
 	current->mm->context.vdso_base = 0;
  	/* vDSO has a problem and was disabled, just don't "enable" it for the
@@ -249,6 +254,12 @@ int arch_setup_additional_pages(struct linux_binprm *bprm,
int uses_interp)
 	/* Add required alignment. */
 	vdso_base = ALIGN(vdso_base, VDSO_ALIGNMENT);
 +	/* for restart(2), double check that we got we asked for */
+	if (start && vdso_base != start) {
+		rc = -EBUSY;
+		goto fail_mmapsem;
+	}
+
 	/*
 	 * Put vDSO base into mm struct. We need to do this before calling
 	 * install_special_mapping or the perf counter mmap tracking code
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 0d8cd9b..b358e63 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -49,6 +49,10 @@ config GENERIC_TIME_VSYSCALL
 config GENERIC_CLOCKEVENTS
 	def_bool y
 +config CHECKPOINT_SUPPORT
+	bool
+	default y if 64BIT
+
 config GENERIC_BUG
 	bool
 	depends on BUG
diff --git a/arch/s390/include/asm/Kbuild b/arch/s390/include/asm/Kbuild
index 63a2341..3282a6e 100644
--- a/arch/s390/include/asm/Kbuild
+++ b/arch/s390/include/asm/Kbuild
@@ -8,6 +8,7 @@ header-y += ucontext.h
 header-y += vtoc.h
 header-y += zcrypt.h
 header-y += chsc.h
+header-y += checkpoint_hdr.h
  unifdef-y += cmb.h
 unifdef-y += debug.h
diff --git a/arch/s390/include/asm/elf.h b/arch/s390/include/asm/elf.h
index 354d426..5081938 100644
--- a/arch/s390/include/asm/elf.h
+++ b/arch/s390/include/asm/elf.h
@@ -216,6 +216,6 @@ do {									    \
 struct linux_binprm;
  #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
-int arch_setup_additional_pages(struct linux_binprm *, int);
+int arch_setup_additional_pages(struct linux_binprm *, unsigned long, int);
  #endif
diff --git a/arch/s390/include/asm/thread_info.h
b/arch/s390/include/asm/thread_info.h
index 34f0873..60f932e 100644
--- a/arch/s390/include/asm/thread_info.h
+++ b/arch/s390/include/asm/thread_info.h
@@ -99,6 +99,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_MEMDIE		18
 #define TIF_RESTORE_SIGMASK	19	/* restore signal mask in do_signal() */
 #define TIF_FREEZE		20	/* thread is freezing for suspend */
+#define TIF_SIG_RESTARTBLOCK	23	/* restart must set TIF_RESTART_SVC */
  #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
@@ -114,6 +115,7 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_31BIT		(1<<TIF_31BIT)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
+#define _TIF_SIG_RESTARTBLOCK	(1<<TIF_SIG_RESTARTBLOCK)
  #endif /* __KERNEL__ */
 diff --git a/arch/s390/include/asm/unistd.h b/arch/s390/include/asm/unistd.h
index ff13be1..79a4178 100644
--- a/arch/s390/include/asm/unistd.h
+++ b/arch/s390/include/asm/unistd.h
@@ -270,7 +270,9 @@
 #define __NR_rt_tgsigqueueinfo	330
 #define __NR_perf_event_open	331
 #define __NR_eclone		332
-#define NR_syscalls 333
+#define __NR_checkpoint		333
+#define __NR_restart		334
+#define NR_syscalls 335
  /*   * There are some system calls that are not present on 64 bit, some
diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index 64230bc..b472855 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_SMP)		+= smp.o topology.o
 obj-$(CONFIG_SMP)		+= $(if $(CONFIG_64BIT),switch_cpu64.o, \
 							switch_cpu.o)
 obj-$(CONFIG_HIBERNATION)	+= suspend.o swsusp_asm64.o
+obj-$(CONFIG_CHECKPOINT)	+= checkpoint.o
 obj-$(CONFIG_AUDIT)		+= audit.o
 compat-obj-$(CONFIG_AUDIT)	+= compat_audit.o
 obj-$(CONFIG_COMPAT)		+= compat_linux.o compat_signal.o \
diff --git a/arch/s390/kernel/compat_wrapper.S b/arch/s390/kernel/compat_wrapper.S
index b7bedfa..d57e5e0 100644
--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -1861,3 +1861,19 @@ sys32_execve_wrapper:
 	llgtr	%r3,%r3			# compat_uptr_t *
 	llgtr	%r4,%r4			# compat_uptr_t *
 	jg	sys32_execve		# branch to system call
+
+	.globl sys_checkpoint_wrapper
+sys_checkpoint_wrapper:
+	lgfr	%r2,%r2			# pid_t
+	lgfr	%r3,%r3			# int
+	llgfr	%r4,%r4			# unsigned long
+	lgfr	%r5,%r5			# int
+	jg	sys_checkpoint
+
+	.globl sys_restart_wrapper
+sys_restart_wrapper:
+	lgfr	%r2,%r2			# pid_t
+	lgfr	%r3,%r3			# int
+	llgfr	%r4,%r4			# unsigned long
+	lgfr	%r5,%r5			# int
+	jg	sys_restart
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 799cbb0..efc7e8a 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -32,6 +32,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/syscalls.h>
 #include <linux/compat.h>
+#include <linux/checkpoint.h>
 #include <asm/compat.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -240,6 +241,32 @@ SYSCALL_DEFINE4(clone, unsigned long, newsp, unsigned long,
clone_flags,
 		       parent_tidptr, child_tidptr);
 }
 +#ifdef CONFIG_CHECKPOINT
+SYSCALL_DEFINE4(checkpoint, pid_t, pid, int, fd, unsigned long, flags,
+		int, logfd)
+{
+	return do_sys_checkpoint(pid, fd, flags, logfd);
+}
+
+SYSCALL_DEFINE4(restart, pid_t, pid, int, fd, unsigned long, flags,
+		int, logfd)
+{
+	return do_sys_restart(pid, fd, flags, logfd);
+}
+#else
+SYSCALL_DEFINE4(checkpoint, pid_t, pid, int, fd, unsigned long, flags,
+		int, logfd)
+{
+	return -ENOSYS;
+}
+
+SYSCALL_DEFINE4(restart, pid_t, pid, int, fd, unsigned long, flags,
+		int, logfd)
+{
+	return -ENOSYS;
+}
+#endif
+
 SYSCALL_DEFINE4(eclone, unsigned int, flags_low, struct clone_args __user *,
 		uca, int, args_size, pid_t __user *, pids)
 {
diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index 6289945..41e03d3 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -459,6 +459,16 @@ void do_signal(struct pt_regs *regs)
 			break;
 		case -ERESTART_RESTARTBLOCK:
 			regs->gprs[2] = -EINTR;
+			/*
+			 * This condition is the only one which requires
+			 * special care after handling a signr==0.  So if
+			 * we get frozen and checkpointed at the
+			 * get_signal_to_deliver() below, then we need
+			 * to convey this condition to sys_restart() so it
+			 * can set the restored thread up to run the restart
+			 * block.
+			 */
+			set_thread_flag(TIF_SIG_RESTARTBLOCK);
 		}
 		regs->svcnr = 0;	/* Don't deal with this again. */
 	}
@@ -467,6 +477,12 @@ void do_signal(struct pt_regs *regs)
 	   the debugger may change all our registers ... */
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 +	/*
+	 * we won't get frozen past this so clear the thread flag hinting
+	 * to sys_restart that TIF_RESTART_SVC must be set.
+	 */
+	clear_thread_flag(TIF_SIG_RESTARTBLOCK);
+
 	/* Depending on the signal settings we may need to revert the
 	   decision to restart the system call. */
 	if (signr > 0 && regs->psw.addr == restart_addr) {
@@ -524,6 +540,11 @@ void do_signal(struct pt_regs *regs)
 	}
 }
 +int task_has_saved_sigmask(struct task_struct *task)
+{
+	return !!(test_tsk_thread_flag(task, TIF_RESTORE_SIGMASK));
+}
+
 void do_notify_resume(struct pt_regs *regs)
 {
 	clear_thread_flag(TIF_NOTIFY_RESUME);
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index 08eab1d..9f1f28e 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -341,3 +341,5 @@ SYSCALL(sys_pwritev,sys_pwritev,compat_sys_pwritev_wrapper)
 SYSCALL(sys_rt_tgsigqueueinfo,sys_rt_tgsigqueueinfo,compat_sys_rt_tgsigqueueinfo_wrapper) /* 330 */
 SYSCALL(sys_perf_event_open,sys_perf_event_open,sys_perf_event_open_wrapper)
 SYSCALL(sys_eclone,sys_eclone,sys_eclone_wrapper)
+SYSCALL(sys_checkpoint,sys_checkpoint,sys_checkpoint_wrapper)
+SYSCALL(sys_restart,sys_restart,sys_restart_wrapper)
diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
index 6bc9c19..54dad2f 100644
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -195,7 +195,8 @@ static void vdso_init_cr5(void)
  * This is called from binfmt_elf, we create the special vma for the
  * vDSO and insert it into the mm struct tree
  */
-int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+int arch_setup_additional_pages(struct linux_binprm *bprm,
+				unsigned long start, int uses_interp)
 {
 	struct mm_struct *mm = current->mm;
 	struct page **vdso_pagelist;
@@ -226,6 +227,10 @@ int arch_setup_additional_pages(struct linux_binprm *bprm,
int uses_interp)
 	vdso_pages = vdso32_pages;
 #endif
 +	/* in case restart(2) mandates a specific location */
+	if (start)
+		vdso_base = start;
+
 	/*
 	 * vDSO has a problem and was disabled, just don't "enable" it for
 	 * the process
@@ -248,6 +253,12 @@ int arch_setup_additional_pages(struct linux_binprm *bprm,
int uses_interp)
 		goto out_up;
 	}
 +	/* for restart(2), double check that we got we asked for */
+	if (start && vdso_base != start) {
+		rc = -EINVAL;
+		goto out_up;
+	}
+
 	/*
 	 * Put vDSO base into mm struct. We need to do this before calling
 	 * install_special_mapping or the perf counter mmap tracking code
diff --git a/arch/s390/mm/Makefile b/arch/s390/mm/Makefile
index eec0544..359a3bc 100644
--- a/arch/s390/mm/Makefile
+++ b/arch/s390/mm/Makefile
@@ -6,3 +6,4 @@ obj-y	 := init.o fault.o extmem.o mmap.o vmem.o pgtable.o
maccess.o \
 	    page-states.o
 obj-$(CONFIG_CMM) += cmm.o
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
+obj-$(CONFIG_PAGE_STATES) += page-states.o
diff --git a/arch/sh/include/asm/elf.h b/arch/sh/include/asm/elf.h
index ce830fa..4128c30 100644
--- a/arch/sh/include/asm/elf.h
+++ b/arch/sh/include/asm/elf.h
@@ -201,6 +201,7 @@ do {									\
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES
 struct linux_binprm;
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
+				       unsigned long start,
 				       int uses_interp);
  extern unsigned int vdso_enabled;
diff --git a/arch/sh/kernel/vsyscall/vsyscall.c b/arch/sh/kernel/vsyscall/vsyscall.c
index 242117c..6dbdfe1 100644
--- a/arch/sh/kernel/vsyscall/vsyscall.c
+++ b/arch/sh/kernel/vsyscall/vsyscall.c
@@ -58,7 +58,7 @@ int __init vsyscall_init(void)
 }
  /* Setup a VMA at program startup for the vsyscall page */
-int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+int arch_setup_additional_pages(struct linux_binprm *bprm, unsigned long start,
int uses_interp)
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9458685..335a4b3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -93,6 +93,10 @@ config STACKTRACE_SUPPORT
 config HAVE_LATENCYTOP_SUPPORT
 	def_bool y
 +config CHECKPOINT_SUPPORT
+	bool
+	default y
+
 config MMU
 	def_bool y
 diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index b7f3f34..2efc4db 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -478,6 +478,13 @@ quiet_ni_syscall:
 	PTREGSCALL stub32_vfork, sys_vfork, %rdi
 	PTREGSCALL stub32_iopl, sys_iopl, %rsi
 	PTREGSCALL stub32_eclone, sys_eclone, %r8
+#ifdef CONFIG_CHECKPOINT
+	PTREGSCALL stub32_checkpoint, sys_checkpoint, %r8
+	PTREGSCALL stub32_restart, sys_restart, %r8
+#else
+	PTREGSCALL stub32_checkpoint, sys_ni_syscall, %r8
+	PTREGSCALL stub32_restart, sys_ni_syscall, %r8
+#endif
  ENTRY(ia32_ptregs_common)
 	popq %r11
@@ -844,4 +851,6 @@ ia32_sys_call_table:
 	.quad sys_perf_event_open
 	.quad compat_sys_recvmmsg
 	.quad stub32_eclone
+	.quad stub32_checkpoint
+	.quad stub32_restart			/* 340 */
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 493092e..0893cfa 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -2,6 +2,7 @@ include include/asm-generic/Kbuild.asm
  header-y += boot.h
 header-y += bootparam.h
+header-y += checkpoint_hdr.h
 header-y += debugreg.h
 header-y += ldt.h
 header-y += msr-index.h
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index f2ad216..3761be8 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -312,9 +312,10 @@ struct linux_binprm;
  #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
+				       unsigned long start,
 				       int uses_interp);
 -extern int syscall32_setup_pages(struct linux_binprm *, int exstack);
+extern int syscall32_setup_pages(struct linux_binprm *, unsigned long start,
int exstack);
 #define compat_arch_setup_additional_pages	syscall32_setup_pages
  extern unsigned long arch_randomize_brk(struct mm_struct *mm);
diff --git a/arch/x86/include/asm/ldt.h b/arch/x86/include/asm/ldt.h
index 46727eb..f2845f9 100644
--- a/arch/x86/include/asm/ldt.h
+++ b/arch/x86/include/asm/ldt.h
@@ -37,4 +37,11 @@ struct user_desc {
 #define MODIFY_LDT_CONTENTS_CODE	2
  #endif /* !__ASSEMBLY__ */
+
+#ifdef __KERNEL__
+#include <linux/linkage.h>
+asmlinkage int sys_modify_ldt(int func, void __user *ptr,
+			      unsigned long bytecount);
+#endif
+
 #endif /* _ASM_X86_LDT_H */
diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index d525677..538a1ef 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -29,6 +29,12 @@ long sys_clone(unsigned long, unsigned long, void __user *,
 	       void __user *, struct pt_regs *);
 long sys_eclone(unsigned flags_low, struct clone_args __user *uca,
 		int args_size, pid_t __user *pids, struct pt_regs *regs);
+#ifdef CONFIG_CHECKPOINT
+long sys_checkpoint(pid_t pid, int fd, unsigned long flags,
+		    int logfd, struct pt_regs *regs);
+long sys_restart(pid_t pid, int fd, unsigned long flags,
+		 int logfd, struct pt_regs *regs);
+#endif
  /* kernel/ldt.c */
 asmlinkage int sys_modify_ldt(int, void __user *, unsigned long);
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index e543b0e..007d7cd 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -344,10 +344,12 @@
 #define __NR_perf_event_open	336
 #define __NR_recvmmsg		337
 #define __NR_eclone		338
+#define __NR_checkpoint		339
+#define __NR_restart		340
  #ifdef __KERNEL__
 -#define NR_syscalls 339
+#define NR_syscalls 341
  #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 1cd16af..2b162e1 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -665,6 +665,10 @@ __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
 __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
 #define __NR_eclone				300
 __SYSCALL(__NR_eclone, stub_eclone)
+#define __NR_checkpoint				301
+__SYSCALL(__NR_checkpoint, stub_checkpoint)
+#define __NR_restart				302
+__SYSCALL(__NR_restart, stub_restart)
  #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 4c58352..916a7e1 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -117,6 +117,14 @@ obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
  obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
 +obj-$(CONFIG_CHECKPOINT)	+= checkpoint.o
+
+###
+# 32 bit specific files
+ifeq ($(CONFIG_X86_32),y)
+	obj-$(CONFIG_CHECKPOINT)	+= checkpoint_32.o
+endif
+
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
@@ -130,4 +138,6 @@ ifeq ($(CONFIG_X86_64),y)
  	obj-$(CONFIG_PCI_MMCONFIG)	+= mmconf-fam10h_64.o
 	obj-y				+= vsmp_64.o
+
+	obj-$(CONFIG_CHECKPOINT)	+= checkpoint_64.o
 endif
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 65e1735..49d6628 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -781,6 +781,14 @@ PTREGSCALL0(rt_sigreturn)
 PTREGSCALL2(vm86)
 PTREGSCALL1(vm86old)
 PTREGSCALL4(eclone)
+#ifdef CONFIG_CHECKPOINT
+PTREGSCALL4(checkpoint)
+PTREGSCALL4(restart)
+#else
+/* Use the weak defs in kernel/sys_ni.c */
+#define ptregs_checkpoint  sys_checkpoint
+#define ptregs_restart  sys_restart
+#endif
  /* Clone is an oddball.  The 4th arg is in %edi */
 	ALIGN;
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 216681e..c2ece28 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -699,6 +699,13 @@ END(\label)
 	PTREGSCALL stub_sigaltstack, sys_sigaltstack, %rdx
 	PTREGSCALL stub_iopl, sys_iopl, %rsi
 	PTREGSCALL stub_eclone, sys_eclone, %r8
+#ifdef CONFIG_CHECKPOINT
+	PTREGSCALL stub_checkpoint, sys_checkpoint, %r8
+	PTREGSCALL stub_restart, sys_restart, %r8
+#else
+	PTREGSCALL stub_checkpoint, sys_ni_syscall, %r8
+	PTREGSCALL stub_restart, sys_ni_syscall, %r8
+#endif
  ENTRY(ptregscall_common)
 	DEFAULT_FRAME 1 8	/* offset 8: return address */
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 4fd173c..eb63d59 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -831,6 +831,11 @@ static void do_signal(struct pt_regs *regs)
 	}
 }
 +int task_has_saved_sigmask(struct task_struct *task)
+{
+	return !!(task_thread_info(task)->status & TS_RESTORE_SIGMASK);
+}
+
 /*
  * notification of userspace execution resumption
  * - triggered by the TIF_WORK_MASK flags
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index 0c92570..2485482 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -338,3 +338,5 @@ ENTRY(sys_call_table)
 	.long sys_perf_event_open
 	.long sys_recvmmsg
 	.long ptregs_eclone
+	.long ptregs_checkpoint
+	.long ptregs_restart		/* 340 */
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 02b442e..62043c1 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -310,7 +310,8 @@ int __init sysenter_setup(void)
 }
  /* Setup a VMA at program startup for the vsyscall page */
-int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+int arch_setup_additional_pages(struct linux_binprm *bprm,
+				unsigned long start, int uses_interp)
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
@@ -331,13 +332,17 @@ int arch_setup_additional_pages(struct linux_binprm *bprm,
int uses_interp)
 	if (compat)
 		addr = VDSO_HIGH_BASE;
 	else {
-		addr = get_unmapped_area(NULL, 0, PAGE_SIZE, 0, 0);
+		addr = get_unmapped_area(NULL, start, PAGE_SIZE, 0, 0);
 		if (IS_ERR_VALUE(addr)) {
 			ret = addr;
 			goto up_fail;
 		}
 	}
 +	/* for restart(2), double check that we got we asked for */
+	if (start && addr != start)
+		goto up_fail;
+
 	current->mm->context.vdso = (void *)addr;
  	if (compat_uses_vma || !compat) {
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index ac74869..b813286 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -100,23 +100,28 @@ static unsigned long vdso_addr(unsigned long start,
unsigned len)
  /* Setup a VMA at program startup for the vsyscall page.
    Not called for compat tasks */
-int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+int arch_setup_additional_pages(struct linux_binprm *bprm,
+				unsigned long start, int uses_interp)
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
-	int ret;
+	int ret = -EINVAL;
  	if (!vdso_enabled)
 		return 0;
  	down_write(&mm->mmap_sem);
-	addr = vdso_addr(mm->start_stack, vdso_size);
+	addr = start ? : vdso_addr(mm->start_stack, vdso_size);
 	addr = get_unmapped_area(NULL, addr, vdso_size, 0, 0);
 	if (IS_ERR_VALUE(addr)) {
 		ret = addr;
 		goto up_fail;
 	}
 +	/* for restart(2), double check that we got we asked for */
+	if (start && addr != start)
+		goto up_fail;
+
 	current->mm->context.vdso = (void *)addr;
  	ret = install_special_mapping(mm, addr, vdso_size,
diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index d83a431..77c2d70 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -15,6 +15,7 @@
  #include <linux/errno.h>
 #include <linux/interrupt.h>
+#include <linux/file.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/fcntl.h>
@@ -28,6 +29,7 @@
 #include <linux/device.h>
 #include <linux/uaccess.h>
 #include <linux/bitops.h>
+#include <linux/file.h>
 #include <linux/devpts_fs.h>
 #include <linux/slab.h>
 @@ -615,9 +617,10 @@ static const struct tty_operations pty_unix98_ops = {
 };
  /**
- *	ptmx_open		-	open a unix 98 pty master
+ *	__ptmx_open		-	open a unix 98 pty master
  *	@inode: inode of device file
  *	@filp: file pointer to tty
+ *	@index: desired slave index
  *
  *	Allocate a unix98 pty master device from the ptmx driver.
  *
@@ -626,16 +629,15 @@ static const struct tty_operations pty_unix98_ops = {
  *		allocated_ptys_lock handles the list of free pty numbers
  */
 -static int __ptmx_open(struct inode *inode, struct file *filp)
+static int __ptmx_open(struct inode *inode, struct file *filp, int index)
 {
 	struct tty_struct *tty;
 	int retval;
-	int index;
  	nonseekable_open(inode, filp);
  	/* find a device that is not in use. */
-	index = devpts_new_index(inode);
+	index = devpts_new_index(inode, index);
 	if (index < 0)
 		return index;
 @@ -672,11 +674,40 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 	int ret;
  	lock_kernel();
-	ret = __ptmx_open(inode, filp);
+	ret = __ptmx_open(inode, filp, UNSPECIFIED_PTY_INDEX);
 	unlock_kernel();
 	return ret;
 }
 +static int ptmx_release(struct inode *inode, struct file *filp)
+{
+	return tty_release(inode, filp);
+}
+
+struct file *pty_open_by_index(char *ptmxpath, int index)
+{
+	struct file *ptmxfile;
+	int ret;
+
+	/*
+	 * We need to pick a way to specify which devpts mountpoint to
+	 * use. For now, we'll just use whatever /dev/ptmx points to.
+	 */
+	ptmxfile = filp_open(ptmxpath, O_RDWR|O_NOCTTY, 0);
+	if (IS_ERR(ptmxfile))
+		return ptmxfile;
+
+	lock_kernel();
+	ret = __ptmx_open(ptmxfile->f_dentry->d_inode, ptmxfile, index);
+	unlock_kernel();
+	if (ret) {
+		fput(ptmxfile);
+		return ERR_PTR(ret);
+	}
+
+	return ptmxfile;
+}
+
 static struct file_operations ptmx_fops;
  static void __init unix98_pty_init(void)
@@ -733,6 +764,7 @@ static void __init unix98_pty_init(void)
 	/* Now create the /dev/ptmx special device */
 	tty_default_fops(&ptmx_fops);
 	ptmx_fops.open = ptmx_open;
+	ptmx_fops.release = ptmx_release;
  	cdev_init(&ptmx_cdev, &ptmx_fops);
 	if (cdev_add(&ptmx_cdev, MKDEV(TTYAUX_MAJOR, 2), 1) ||
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 6da962c..3977322 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -96,6 +96,7 @@
 #include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/seq_file.h>
+#include <linux/mount.h>
  #include <linux/uaccess.h>
 #include <asm/system.h>
@@ -106,6 +107,7 @@
  #include <linux/kmod.h>
 #include <linux/nsproxy.h>
+#include <linux/checkpoint.h>
  #undef TTY_DEBUG_HANGUP
 @@ -2162,7 +2164,7 @@ static int fionbio(struct file *file, int __user *p)
  *		Takes ->siglock() when updating signal->tty
  */
 -static int tiocsctty(struct tty_struct *tty, int arg)
+int tiocsctty(struct tty_struct *tty, int arg)
 {
 	int ret = 0;
 	if (current->signal->leader && (task_session(current) == tty->session))
@@ -2251,10 +2253,10 @@ static int tiocgpgrp(struct tty_struct *tty, struct
tty_struct *real_tty, pid_t
 }
  /**
- *	tiocspgrp		-	attempt to set process group
+ *	do_tiocspgrp		-	attempt to set process group
  *	@tty: tty passed by user
  *	@real_tty: tty side device matching tty passed by user
- *	@p: pid pointer
+ *	@pid: pgrp_nr
  *
  *	Set the process group of the tty to the session passed. Only
  *	permitted where the tty session is our session.
@@ -2262,10 +2264,10 @@ static int tiocgpgrp(struct tty_struct *tty, struct
tty_struct *real_tty, pid_t
  *	Locking: RCU, ctrl lock
  */
 -static int tiocspgrp(struct tty_struct *tty, struct tty_struct *real_tty,
pid_t __user *p)
+int do_tiocspgrp(struct tty_struct *tty,
+		 struct tty_struct *real_tty, pid_t pgrp_nr)
 {
 	struct pid *pgrp;
-	pid_t pgrp_nr;
 	int retval = tty_check_change(real_tty);
 	unsigned long flags;
 @@ -2277,8 +2279,6 @@ static int tiocspgrp(struct tty_struct *tty, struct
tty_struct *real_tty, pid_t
 	    (current->signal->tty != real_tty) ||
 	    (real_tty->session != task_session(current)))
 		return -ENOTTY;
-	if (get_user(pgrp_nr, p))
-		return -EFAULT;
 	if (pgrp_nr < 0)
 		return -EINVAL;
 	rcu_read_lock();
@@ -2300,6 +2300,27 @@ out_unlock:
 }
  /**
+ *	tiocspgrp		-	attempt to set process group
+ *	@tty: tty passed by user
+ *	@real_tty: tty side device matching tty passed by user
+ *	@p: pid pointer
+ *
+ *	Set the process group of the tty to the session passed. Only
+ *	permitted where the tty session is our session.
+ *
+ *	Locking: RCU, ctrl lock
+ */
+
+static int tiocspgrp(struct tty_struct *tty, struct tty_struct *real_tty, pid_t
__user *p)
+{
+	pid_t pgrp_nr;
+
+	if (get_user(pgrp_nr, p))
+		return -EFAULT;
+	return do_tiocspgrp(tty, real_tty, pgrp_nr);
+}
+
+/**
  *	tiocgsid		-	get session id
  *	@tty: tty passed by user
  *	@real_tty: tty side of the tty pased by the user if a pty else the tty
diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 72b7949..83c9bf7 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -156,9 +156,12 @@ static void loopback_dev_free(struct net_device *dev)
 }
  static const struct net_device_ops loopback_ops = {
-	.ndo_init      = loopback_dev_init,
-	.ndo_start_xmit= loopback_xmit,
-	.ndo_get_stats = loopback_get_stats,
+	.ndo_init       = loopback_dev_init,
+	.ndo_start_xmit = loopback_xmit,
+	.ndo_get_stats  = loopback_get_stats,
+#ifdef CONFIG_NETNS_CHECKPOINT
+	.ndo_checkpoint = loopback_checkpoint,
+#endif
 };
  /*
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 40faa36..8bd6be9 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -501,6 +501,9 @@ static const struct net_device_ops macvlan_netdev_ops = {
 	.ndo_set_multicast_list	= macvlan_set_multicast_list,
 	.ndo_get_stats		= macvlan_dev_get_stats,
 	.ndo_validate_addr	= eth_validate_addr,
+#ifdef CONFIG_NETNS_CHECKPOINT
+	.ndo_checkpoint		= macvlan_checkpoint,
+#endif
 };
  static void macvlan_setup(struct net_device *dev)
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index f9f0730..9d776c9 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -293,6 +293,9 @@ static const struct net_device_ops veth_netdev_ops = {
 	.ndo_change_mtu      = veth_change_mtu,
 	.ndo_get_stats       = veth_get_stats,
 	.ndo_set_mac_address = eth_mac_addr,
+#ifdef CONFIG_NETNS_CHECKPOINT
+	.ndo_checkpoint      = veth_checkpoint,
+#endif
 };
  static void veth_setup(struct net_device *dev)
diff --git a/fs/Makefile b/fs/Makefile
index 97f340f..aa25755 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_EVENTFD)		+= eventfd.o
 obj-$(CONFIG_AIO)               += aio.o
 obj-$(CONFIG_FILE_LOCKING)      += locks.o
 obj-$(CONFIG_COMPAT)		+= compat.o compat_ioctl.o
+obj-$(CONFIG_CHECKPOINT)        += checkpoint.o
  nfsd-$(CONFIG_NFSD)		:= nfsctl.o
 obj-y				+= $(nfsd-y) $(nfsd-m)
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 535e763..6434003 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -923,7 +923,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct
pt_regs *regs)
 	set_binfmt(&elf_format);
  #ifdef ARCH_HAS_SETUP_ADDITIONAL_PAGES
-	retval = arch_setup_additional_pages(bprm, !!elf_interpreter);
+	retval = arch_setup_additional_pages(bprm, 0, !!elf_interpreter);
 	if (retval < 0) {
 		send_sig(SIGKILL, current, 0);
 		goto out;
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 0120247..75fb8c5 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -433,11 +433,11 @@ static struct file_system_type devpts_fs_type = {
  * to the System V naming convention
  */
 -int devpts_new_index(struct inode *ptmx_inode)
+int devpts_new_index(struct inode *ptmx_inode, int req_idx)
 {
 	struct super_block *sb = pts_sb_from_inode(ptmx_inode);
 	struct pts_fs_info *fsi = DEVPTS_SB(sb);
-	int index;
+	int index = req_idx;
 	int ida_ret;
  retry:
@@ -445,7 +445,9 @@ retry:
 		return -ENOMEM;
  	mutex_lock(&allocated_ptys_lock);
-	ida_ret = ida_get_new(&fsi->allocated_ptys, &index);
+	if (index == UNSPECIFIED_PTY_INDEX)
+		index = 0;
+	ida_ret = ida_get_new_above(&fsi->allocated_ptys, index, &index);
 	if (ida_ret < 0) {
 		mutex_unlock(&allocated_ptys_lock);
 		if (ida_ret == -EAGAIN)
@@ -453,6 +455,11 @@ retry:
 		return -EIO;
 	}
 +	if (req_idx != UNSPECIFIED_PTY_INDEX && index != req_idx) {
+		ida_remove(&fsi->allocated_ptys, index);
+		mutex_unlock(&allocated_ptys_lock);
+		return -EBUSY;
+	}
 	if (index >= pty_limit) {
 		ida_remove(&fsi->allocated_ptys, index);
 		mutex_unlock(&allocated_ptys_lock);
diff --git a/fs/eventfd.c b/fs/eventfd.c
index 6bd3f76..92fdbfa 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/kref.h>
 #include <linux/eventfd.h>
+#include <linux/checkpoint.h>
  struct eventfd_ctx {
 	struct kref kref;
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index bd056a5..95da38a 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -674,7 +674,7 @@ static unsigned int ep_eventpoll_poll(struct file *file,
poll_table *wait)
 /* File callbacks that implement the eventpoll file behaviour */
 static const struct file_operations eventpoll_fops = {
 	.release	= ep_eventpoll_release,
-	.poll		= ep_eventpoll_poll
+	.poll		= ep_eventpoll_poll,
 };
  /* Fast test to see if the file is an evenpoll file */
@@ -1226,35 +1226,18 @@ SYSCALL_DEFINE1(epoll_create, int, size)
  * the eventpoll file that enables the insertion/removal/change of
  * file descriptors inside the interest set.
  */
-SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
-		struct epoll_event __user *, event)
+int do_epoll_ctl(int op, int fd,
+		 struct file *file, struct file *tfile,
+		 struct epoll_event *epds)
 {
 	int error;
-	struct file *file, *tfile;
 	struct eventpoll *ep;
 	struct epitem *epi;
-	struct epoll_event epds;
-
-	error = -EFAULT;
-	if (ep_op_has_event(op) &&
-	    copy_from_user(&epds, event, sizeof(struct epoll_event)))
-		goto error_return;
-
-	/* Get the "struct file *" for the eventpoll file */
-	error = -EBADF;
-	file = fget(epfd);
-	if (!file)
-		goto error_return;
-
-	/* Get the "struct file *" for the target file */
-	tfile = fget(fd);
-	if (!tfile)
-		goto error_fput;
  	/* The target file descriptor must support poll */
 	error = -EPERM;
 	if (!tfile->f_op || !tfile->f_op->poll)
-		goto error_tgt_fput;
+		return error;
  	/*
 	 * We have to check that the file structure underneath the file descriptor
@@ -1263,7 +1246,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	 */
 	error = -EINVAL;
 	if (file == tfile || !is_file_epoll(file))
-		goto error_tgt_fput;
+		return error;
  	/*
 	 * At this point it is safe to assume that the "private_data" contains
@@ -1284,8 +1267,8 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	switch (op) {
 	case EPOLL_CTL_ADD:
 		if (!epi) {
-			epds.events |= POLLERR | POLLHUP;
-			error = ep_insert(ep, &epds, tfile, fd);
+			epds->events |= POLLERR | POLLHUP;
+			error = ep_insert(ep, epds, tfile, fd);
 		} else
 			error = -EEXIST;
 		break;
@@ -1297,15 +1280,46 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 		break;
 	case EPOLL_CTL_MOD:
 		if (epi) {
-			epds.events |= POLLERR | POLLHUP;
-			error = ep_modify(ep, epi, &epds);
+			epds->events |= POLLERR | POLLHUP;
+			error = ep_modify(ep, epi, epds);
 		} else
 			error = -ENOENT;
 		break;
 	}
 	mutex_unlock(&ep->mtx);
 -error_tgt_fput:
+	return error;
+}
+
+/*
+ * The following function implements the controller interface for
+ * the eventpoll file that enables the insertion/removal/change of
+ * file descriptors inside the interest set.
+ */
+SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
+		struct epoll_event __user *, event)
+{
+	int error;
+	struct file *file, *tfile;
+	struct epoll_event epds;
+
+	error = -EFAULT;
+	if (ep_op_has_event(op) &&
+	    copy_from_user(&epds, event, sizeof(struct epoll_event)))
+		goto error_return;
+
+	/* Get the "struct file *" for the eventpoll file */
+	error = -EBADF;
+	file = fget(epfd);
+	if (!file)
+		goto error_return;
+
+	/* Get the "struct file *" for the target file */
+	tfile = fget(fd);
+	if (!tfile)
+		goto error_fput;
+
+	error = do_epoll_ctl(op, fd, file, tfile, &epds);
 	fput(tfile);
 error_fput:
 	fput(file);
diff --git a/fs/exec.c b/fs/exec.c
index 49cdaa1..06f93d8 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -693,24 +693,83 @@ exit:
 }
 EXPORT_SYMBOL(open_exec);
 -int kernel_read(struct file *file, loff_t offset,
-		char *addr, unsigned long count)
+static ssize_t _kernel_read(struct file *file, loff_t offset,
+			    char __user *ubuf, size_t count)
 {
-	mm_segment_t old_fs;
+	ssize_t nread;
+	size_t nleft;
 	loff_t pos = offset;
-	int result;
+
+	for (nleft = count; nleft; nleft -= nread) {
+		nread = vfs_read(file, ubuf, nleft, &pos);
+		if (nread <= 0) {
+			if (nread == -EAGAIN) {
+				nread = 0;
+				continue;
+			} else if (nread == 0)
+				break;
+			else
+				return nread;
+		}
+		ubuf += nread;
+	}
+	return count - nleft;
+}
+
+ssize_t kernel_read(struct file *file, loff_t offset,
+		    char *addr, size_t count)
+{
+	mm_segment_t old_fs;
+	ssize_t result;
  	old_fs = get_fs();
 	set_fs(get_ds());
 	/* The cast to a user pointer is valid due to the set_fs() */
-	result = vfs_read(file, (void __user *)addr, count, &pos);
+	result = _kernel_read(file, offset, (void __user *)addr, count);
 	set_fs(old_fs);
 	return result;
 }
  EXPORT_SYMBOL(kernel_read);
 -static int exec_mmap(struct mm_struct *mm)
+static ssize_t _kernel_write(struct file *file, loff_t offset,
+			     const char __user *ubuf, size_t count)
+{
+	ssize_t nwrite;
+	size_t nleft;
+	loff_t pos = offset;
+
+	for (nleft = count; nleft; nleft -= nwrite) {
+		nwrite = vfs_write(file, ubuf, nleft, &pos);
+		if (nwrite < 0) {
+			if (nwrite == -EAGAIN) {
+				nwrite = 0;
+				continue;
+			} else
+				return nwrite;
+		}
+		ubuf += nwrite;
+	}
+	return count - nleft;
+}
+
+ssize_t kernel_write(struct file *file, loff_t offset,
+		     const char *addr, size_t count)
+{
+	mm_segment_t old_fs;
+	ssize_t result;
+
+	old_fs = get_fs();
+	set_fs(get_ds());
+	/* The cast to a user pointer is valid due to the set_fs() */
+	result = _kernel_write(file, offset, (void __user *)addr, count);
+	set_fs(old_fs);
+	return result;
+}
+
+EXPORT_SYMBOL(kernel_write);
+
+int exec_mmap(struct mm_struct *mm)
 {
 	struct task_struct *tsk;
 	struct mm_struct * old_mm, *active_mm;
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 452d02f..2079af0 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -418,6 +418,18 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned
long arg,
 	return err;
 }
 +int vfs_fcntl(int fd, unsigned int cmd, unsigned long arg, struct file *filp)
+{
+	int err;
+
+	err = security_file_fcntl(filp, cmd, arg);
+	if (err)
+		goto out;
+	err = do_fcntl(fd, cmd, arg, filp);
+ out:
+	return err;
+}
+
 SYSCALL_DEFINE3(fcntl, unsigned int, fd, unsigned int, cmd, unsigned long, arg)
 {	
 	struct file *filp;
@@ -427,14 +439,7 @@ SYSCALL_DEFINE3(fcntl, unsigned int, fd, unsigned int, cmd,
unsigned long, arg)
 	if (!filp)
 		goto out;
 -	err = security_file_fcntl(filp, cmd, arg);
-	if (err) {
-		fput(filp);
-		return err;
-	}
-
-	err = do_fcntl(fd, cmd, arg, filp);
-
+	err = vfs_fcntl(fd, cmd, arg, filp);
  	fput(filp);
 out:
 	return err;
diff --git a/fs/fs_struct.c b/fs/fs_struct.c
index eee0590..2a4c6f5 100644
--- a/fs/fs_struct.c
+++ b/fs/fs_struct.c
@@ -6,6 +6,27 @@
 #include <linux/fs_struct.h>
  /*
+ * call with owning task locked
+ */
+void get_fs_struct(struct fs_struct *fs)
+{
+	write_lock(&fs->lock);
+	fs->users++;
+	write_unlock(&fs->lock);
+}
+
+void put_fs_struct(struct fs_struct *fs)
+{
+	int kill;
+
+	write_lock(&fs->lock);
+	kill = !--fs->users;
+	write_unlock(&fs->lock);
+	if (kill)
+		free_fs_struct(fs);
+}
+
+/*
  * Replace the fs->{rootmnt,root} with {mnt,dentry}. Put the old values.
  * It can block.
  */
diff --git a/fs/namespace.c b/fs/namespace.c
index 8174c8a..da36155 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -29,6 +29,7 @@
 #include <linux/log2.h>
 #include <linux/idr.h>
 #include <linux/fs_struct.h>
+#include <linux/checkpoint.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
@@ -2318,6 +2319,22 @@ static void __init init_mount_tree(void)
 	set_fs_root(current->fs, &root);
 }
 +void put_mnt_ns(struct mnt_namespace *ns)
+{
+	LIST_HEAD(umount_list);
+
+	if (!atomic_dec_and_test(&ns->count))
+		return;
+	down_write(&namespace_sem);
+	spin_lock(&vfsmount_lock);
+	umount_tree(ns->root, 0, &umount_list);
+	spin_unlock(&vfsmount_lock);
+	up_write(&namespace_sem);
+	release_mounts(&umount_list);
+	kfree(ns);
+}
+EXPORT_SYMBOL(put_mnt_ns);
+
 void __init mnt_init(void)
 {
 	unsigned u;
@@ -2347,20 +2364,7 @@ void __init mnt_init(void)
 		printk(KERN_WARNING "%s: kobj create error\n", __func__);
 	init_rootfs();
 	init_mount_tree();
+#ifdef CONFIG_CHECKPOINT
+	register_checkpoint_obj(&ckpt_obj_mntns_ops);
+#endif
 }
-
-void put_mnt_ns(struct mnt_namespace *ns)
-{
-	LIST_HEAD(umount_list);
-
-	if (!atomic_dec_and_test(&ns->count))
-		return;
-	down_write(&namespace_sem);
-	spin_lock(&vfsmount_lock);
-	umount_tree(ns->root, 0, &umount_list);
-	spin_unlock(&vfsmount_lock);
-	up_write(&namespace_sem);
-	release_mounts(&umount_list);
-	kfree(ns);
-}
-EXPORT_SYMBOL(put_mnt_ns);
diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 85c89df..e251cab 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -702,5 +702,4 @@ const struct file_operations nilfs_dir_operations = {
 	.compat_ioctl	= nilfs_ioctl,
 #endif	/* CONFIG_COMPAT */
 	.fsync		= nilfs_sync_file,
-
 };
diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index 7e54e52..0a63bf6 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -289,6 +289,24 @@ static int attach_dn(struct dnotify_struct *dn, struct
dnotify_mark_entry *dnent
 	return 0;
 }
 +int is_dnotify_attached(struct file *filp)
+{
+	struct fsnotify_mark_entry *entry;
+	struct inode *inode;
+
+	inode = filp->f_path.dentry->d_inode;
+	if (!S_ISDIR(inode->i_mode))
+		return 0;
+
+	spin_lock(&inode->i_lock);
+	entry = fsnotify_find_mark_entry(dnotify_group, inode);
+	spin_unlock(&inode->i_lock);
+	if (!entry)
+		return 0;
+	fsnotify_put_mark(entry);
+	return 1;
+}
+
 /*
  * When a process calls fcntl to attach a dnotify watch to a directory it ends
  * up here.  Allocate both a mark for fsnotify to add and a dnotify_struct to be
diff --git a/fs/open.c b/fs/open.c
index 74e5cd9..e9d5626 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -524,6 +524,18 @@ SYSCALL_DEFINE2(access, const char __user *, filename, int,
mode)
 	return sys_faccessat(AT_FDCWD, filename, mode);
 }
 +int do_chdir(struct fs_struct *fs, struct path *path)
+{
+	int error;
+
+	error = inode_permission(path->dentry->d_inode, MAY_EXEC | MAY_ACCESS);
+	if (error)
+		return error;
+
+	set_fs_pwd(fs, path);
+	return 0;
+}
+
 SYSCALL_DEFINE1(chdir, const char __user *, filename)
 {
 	struct path path;
@@ -531,17 +543,10 @@ SYSCALL_DEFINE1(chdir, const char __user *, filename)
  	error = user_path_dir(filename, &path);
 	if (error)
-		goto out;
-
-	error = inode_permission(path.dentry->d_inode, MAY_EXEC | MAY_ACCESS);
-	if (error)
-		goto dput_and_out;
-
-	set_fs_pwd(current->fs, &path);
+		return error;
 -dput_and_out:
+	error = do_chdir(current->fs, &path);
 	path_put(&path);
-out:
 	return error;
 }
 @@ -571,31 +576,36 @@ out:
 	return error;
 }
 -SYSCALL_DEFINE1(chroot, const char __user *, filename)
+int do_chroot(struct fs_struct *fs, struct path *path)
 {
-	struct path path;
 	int error;
 -	error = user_path_dir(filename, &path);
+	error = inode_permission(path->dentry->d_inode, MAY_EXEC | MAY_ACCESS);
 	if (error)
-		goto out;
+		return error;
+
+	if (!capable(CAP_SYS_CHROOT))
+		return -EPERM;
 -	error = inode_permission(path.dentry->d_inode, MAY_EXEC | MAY_ACCESS);
+	error = security_path_chroot(path);
 	if (error)
-		goto dput_and_out;
+		return error;
 -	error = -EPERM;
-	if (!capable(CAP_SYS_CHROOT))
-		goto dput_and_out;
-	error = security_path_chroot(&path);
+	set_fs_root(fs, path);
+	return 0;
+}
+
+SYSCALL_DEFINE1(chroot, const char __user *, filename)
+{
+	struct path path;
+	int error;
+
+	error = user_path_dir(filename, &path);
 	if (error)
-		goto dput_and_out;
+		return error;
 -	set_fs_root(current->fs, &path);
-	error = 0;
-dput_and_out:
+	error = do_chroot(current->fs, &path);
 	path_put(&path);
-out:
 	return error;
 }
 diff --git a/fs/pipe.c b/fs/pipe.c
index 37ba29f..d1cb313 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -13,6 +13,7 @@
 #include <linux/fs.h>
 #include <linux/mount.h>
 #include <linux/pipe_fs_i.h>
+#include <linux/splice.h>
 #include <linux/uio.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
diff --git a/fs/read_write.c b/fs/read_write.c
index 113386d..67b7d83 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -361,16 +361,6 @@ ssize_t vfs_write(struct file *file, const char __user
*buf, size_t count, loff_
  EXPORT_SYMBOL(vfs_write);
 -static inline loff_t file_pos_read(struct file *file)
-{
-	return file->f_pos;
-}
-
-static inline void file_pos_write(struct file *file, loff_t pos)
-{
-	file->f_pos = pos;
-}
-
 SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)
 {
 	struct file *file;
diff --git a/fs/select.c b/fs/select.c
index 500a669..194c6d6 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -890,7 +890,7 @@ out_fds:
 	return err;
 }
 -static long do_restart_poll(struct restart_block *restart_block)
+long do_restart_poll(struct restart_block *restart_block)
 {
 	struct pollfd __user *ufds = restart_block->poll.ufds;
 	int nfds = restart_block->poll.nfds;
diff --git a/fs/splice.c b/fs/splice.c
index 9313b61..ed91d7a 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -538,21 +538,6 @@ static ssize_t kernel_readv(struct file *file, const struct
iovec *vec,
 	return res;
 }
 -static ssize_t kernel_write(struct file *file, const char *buf, size_t count,
-			    loff_t pos)
-{
-	mm_segment_t old_fs;
-	ssize_t res;
-
-	old_fs = get_fs();
-	set_fs(get_ds());
-	/* The cast to a user pointer is valid due to the set_fs() */
-	res = vfs_write(file, (const char __user *)buf, count, &pos);
-	set_fs(old_fs);
-
-	return res;
-}
-
 ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
 				 struct pipe_inode_info *pipe, size_t len,
 				 unsigned int flags)
@@ -1011,7 +996,7 @@ static int write_pipe_buf(struct pipe_inode_info *pipe,
struct pipe_buffer *buf,
 		return ret;
  	data = buf->ops->map(pipe, buf, 0);
-	ret = kernel_write(sd->u.file, data + buf->offset, sd->len, sd->pos);
+	ret = kernel_write(sd->u.file, sd->pos, data + buf->offset, sd->len);
 	buf->ops->unmap(pipe, buf, data);
  	return ret;
@@ -1052,18 +1037,43 @@ ssize_t generic_splice_sendpage(struct pipe_inode_info
*pipe, struct file *out,
 EXPORT_SYMBOL(generic_splice_sendpage);
  /*
+ * After the inode slimming patch, i_pipe/i_bdev/i_cdev share the same
+ * location, so checking ->i_pipe is not enough to verify that this is a
+ * pipe.
+ */
+static inline struct pipe_inode_info *pipe_info(struct inode *inode)
+{
+	if (S_ISFIFO(inode->i_mode))
+		return inode->i_pipe;
+
+	return NULL;
+}
+
+static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
+			       struct pipe_inode_info *opipe,
+			       size_t len, unsigned int flags);
+
+/*
  * Attempt to initiate a splice from pipe to file.
  */
-static long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
-			   loff_t *ppos, size_t len, unsigned int flags)
+long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
+		    loff_t *ppos, size_t len, unsigned int flags)
 {
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *,
 				loff_t *, size_t, unsigned int);
+	struct pipe_inode_info *opipe;
 	int ret;
  	if (unlikely(!(out->f_mode & FMODE_WRITE)))
 		return -EBADF;
 +	/* When called directly (e.g. from c/r) output may be a pipe */
+	opipe = pipe_info(out->f_path.dentry->d_inode);
+	if (opipe) {
+		BUG_ON(opipe == pipe);
+		return splice_pipe_to_pipe(pipe, opipe, len, flags);
+	}
+
 	if (unlikely(out->f_flags & O_APPEND))
 		return -EINVAL;
 @@ -1082,17 +1092,25 @@ static long do_splice_from(struct pipe_inode_info
*pipe, struct file *out,
 /*
  * Attempt to initiate a splice from a file to a pipe.
  */
-static long do_splice_to(struct file *in, loff_t *ppos,
-			 struct pipe_inode_info *pipe, size_t len,
-			 unsigned int flags)
+long do_splice_to(struct file *in, loff_t *ppos,
+		  struct pipe_inode_info *pipe, size_t len,
+		  unsigned int flags)
 {
 	ssize_t (*splice_read)(struct file *, loff_t *,
 			       struct pipe_inode_info *, size_t, unsigned int);
+	struct pipe_inode_info *ipipe;
 	int ret;
  	if (unlikely(!(in->f_mode & FMODE_READ)))
 		return -EBADF;
 +	/* When called firectly (e.g. from c/r) input may be a pipe */
+	ipipe = pipe_info(in->f_path.dentry->d_inode);
+	if (ipipe) {
+		BUG_ON(ipipe == pipe);
+		return splice_pipe_to_pipe(ipipe, pipe, len, flags);
+	}
+
 	ret = rw_verify_area(READ, in, ppos, len);
 	if (unlikely(ret < 0))
 		return ret;
@@ -1272,18 +1290,6 @@ long do_splice_direct(struct file *in, loff_t *ppos,
struct file *out,
 static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 			       struct pipe_inode_info *opipe,
 			       size_t len, unsigned int flags);
-/*
- * After the inode slimming patch, i_pipe/i_bdev/i_cdev share the same
- * location, so checking ->i_pipe is not enough to verify that this is a
- * pipe.
- */
-static inline struct pipe_inode_info *pipe_info(struct inode *inode)
-{
-	if (S_ISFIFO(inode->i_mode))
-		return inode->i_pipe;
-
-	return NULL;
-}
  /*
  * Determine where to splice to/from.
@@ -1888,9 +1894,9 @@ retry:
 /*
  * Link contents of ipipe to opipe.
  */
-static int link_pipe(struct pipe_inode_info *ipipe,
-		     struct pipe_inode_info *opipe,
-		     size_t len, unsigned int flags)
+int link_pipe(struct pipe_inode_info *ipipe,
+	      struct pipe_inode_info *opipe,
+	      size_t len, unsigned int flags)
 {
 	struct pipe_buffer *ibuf, *obuf;
 	int ret = 0, i = 0, nbuf;
diff --git a/fs/squashfs/dir.c b/fs/squashfs/dir.c
index 12b933a..198865b 100644
--- a/fs/squashfs/dir.c
+++ b/fs/squashfs/dir.c
@@ -230,5 +230,5 @@ failed_read:
  const struct file_operations squashfs_dir_ops = {
 	.read = generic_read_dir,
-	.readdir = squashfs_readdir
+	.readdir = squashfs_readdir,
 };
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index e2ea0b2..71bb8d1 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -45,6 +45,9 @@ header-y += bsg.h
 header-y += can.h
 header-y += cciss_defs.h
 header-y += cdk.h
+header-y += checkpoint.h
+header-y += checkpoint_hdr.h
+header-y += checkpoint_types.h
 header-y += chio.h
 header-y += coda_psdev.h
 header-y += coff.h
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 811dbb3..e0b1808 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -212,6 +212,7 @@ extern void kick_iocb(struct kiocb *iocb);
 extern int aio_complete(struct kiocb *iocb, long res, long res2);
 struct mm_struct;
 extern void exit_aio(struct mm_struct *mm);
+extern int check_for_outstanding_aio(struct mm_struct *mm);
 #else
 static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
 static inline int aio_put_req(struct kiocb *iocb) { return 0; }
@@ -219,6 +220,7 @@ static inline void kick_iocb(struct kiocb *iocb) { }
 static inline int aio_complete(struct kiocb *iocb, long res, long res2) {
return 0; }
 struct mm_struct;
 static inline void exit_aio(struct mm_struct *mm) { }
+static inline int check_for_outstanding_aio(struct mm_struct *mm) { return 0; }
 #endif /* CONFIG_AIO */
  static inline struct kiocb *list_kiocb(struct list_head *h)
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 717c691..89125dd 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -210,7 +210,8 @@ struct compat_robust_list_head {
 };
  extern void compat_exit_robust_list(struct task_struct *curr);
-
+extern long do_compat_set_robust_list(struct compat_robust_list_head __user *head,
+				      compat_size_t len);
 asmlinkage long
 compat_sys_set_robust_list(struct compat_robust_list_head __user *head,
 			   compat_size_t len);
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 52507c3..8558bec 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -22,6 +22,9 @@ struct user_struct;
 struct cred;
 struct inode;
 +/* defined in sys.c, used in cred_setresuid */
+extern int set_user(struct cred *new);
+
 /*
  * COW Supplementary groups list
  */
@@ -396,4 +399,9 @@ do {						\
 	*(_fsgid) = __cred->fsgid;		\
 } while(0)
 +extern int cred_setresuid(struct cred *new, uid_t ruid, uid_t euid, uid_t suid);
+extern int cred_setresgid(struct cred *new, gid_t rgid, gid_t egid, gid_t sgid);
+extern int cred_setfsuid(struct cred *new, uid_t uid, uid_t *old_fsuid);
+extern int cred_setfsgid(struct cred *new, gid_t gid, gid_t *old_fsgid);
+
 #endif /* _LINUX_CRED_H */
diff --git a/include/linux/devpts_fs.h b/include/linux/devpts_fs.h
index 5ce0e5f..163a70e 100644
--- a/include/linux/devpts_fs.h
+++ b/include/linux/devpts_fs.h
@@ -15,9 +15,13 @@
  #include <linux/errno.h>
 +#define UNSPECIFIED_PTY_INDEX -1
+
 #ifdef CONFIG_UNIX98_PTYS
 -int devpts_new_index(struct inode *ptmx_inode);
+struct file *pty_open_by_index(char *ptmxpath, int index);
+
+int devpts_new_index(struct inode *ptmx_inode, int req_idx);
 void devpts_kill_index(struct inode *ptmx_inode, int idx);
 /* mknod in devpts */
 int devpts_pty_new(struct inode *ptmx_inode, struct tty_struct *tty);
diff --git a/include/linux/dnotify.h b/include/linux/dnotify.h
index ecc0628..7093052 100644
--- a/include/linux/dnotify.h
+++ b/include/linux/dnotify.h
@@ -29,6 +29,7 @@ struct dnotify_struct {
 			    FS_MOVED_FROM | FS_MOVED_TO)
  extern void dnotify_flush(struct file *, fl_owner_t);
+extern int is_dnotify_attached(struct file *);
 extern int fcntl_dirnotify(int, struct file *, unsigned long);
  #else
@@ -37,6 +38,11 @@ static inline void dnotify_flush(struct file *filp,
fl_owner_t id)
 {
 }
 +static inline int is_dnotify_attached(struct file *filp)
+{
+	return 0;
+}
+
 static inline int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 {
 	return -EINVAL;
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index f6856a5..0f7339d 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -56,6 +56,9 @@ struct file;
   #ifdef CONFIG_EPOLL
+struct ckpt_ctx;
+struct ckpt_hdr_file;
+
  /* Used to initialize the epoll bits inside the "struct file" */
 static inline void eventpoll_init_file(struct file *file)
@@ -95,8 +98,9 @@ static inline void eventpoll_release(struct file *file)
 	eventpoll_release_file(file);
 }
 -#else
 +#else
+/* !defined(CONFIG_EPOLL) */
 static inline void eventpoll_init_file(struct file *file) {}
 static inline void eventpoll_release(struct file *file) {}
 diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index da7e52b..0cb22cb 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -65,11 +65,20 @@ extern void cancel_freezing(struct task_struct *p);
  #ifdef CONFIG_CGROUP_FREEZER
 extern int cgroup_freezing_or_frozen(struct task_struct *task);
+extern int in_same_cgroup_freezer(struct task_struct *p, struct task_struct *q);
+extern int cgroup_freezer_begin_checkpoint(struct task_struct *task);
+extern void cgroup_freezer_end_checkpoint(struct task_struct *task);
+extern int cgroup_freezer_make_frozen(struct task_struct *task);
 #else /* !CONFIG_CGROUP_FREEZER */
 static inline int cgroup_freezing_or_frozen(struct task_struct *task)
 {
 	return 0;
 }
+static inline int in_same_cgroup_freezer(struct task_struct *p,
+					 struct task_struct *q)
+{
+	return 0;
+}
 #endif /* !CONFIG_CGROUP_FREEZER */
  /*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 39d57bc..ee725ff 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -397,6 +397,7 @@ struct kstatfs;
 struct vm_area_struct;
 struct vfsmount;
 struct cred;
+struct ckpt_ctx;
  extern void __init inode_init(void);
 extern void __init inode_init_early(void);
@@ -1096,6 +1097,8 @@ struct file_lock {
  #include <linux/fcntl.h>
 +extern int vfs_fcntl(int fd, unsigned cmd, unsigned long arg, struct file *fp);
+
 extern void send_sigio(struct fown_struct *fown, int fd, int band);
  #ifdef CONFIG_FILE_LOCKING
@@ -1120,6 +1123,7 @@ extern void locks_remove_posix(struct file *, fl_owner_t);
 extern void locks_remove_flock(struct file *);
 extern void locks_release_private(struct file_lock *);
 extern void posix_test_lock(struct file *, struct file_lock *);
+extern int find_locks_with_owner(struct file *filp, fl_owner_t owner);
 extern int posix_lock_file(struct file *, struct file_lock *, struct file_lock *);
 extern int posix_lock_file_wait(struct file *, struct file_lock *);
 extern int posix_unblock_lock(struct file *, struct file_lock *);
@@ -1188,6 +1192,11 @@ static inline void locks_remove_posix(struct file *filp,
fl_owner_t owner)
 	return;
 }
 +static inline int find_locks_with_owner(struct file *filp, fl_owner_t owner)
+{
+	return -ENOENT;
+}
+
 static inline void locks_remove_flock(struct file *filp)
 {
 	return;
@@ -1509,6 +1518,10 @@ struct file_operations {
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *,
size_t, unsigned int);
 	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *,
size_t, unsigned int);
 	int (*setlease)(struct file *, long, struct file_lock **);
+#ifdef CONFIG_CHECKPOINT
+	int (*checkpoint)(struct ckpt_ctx *, struct file *);
+	int (*collect)(struct ckpt_ctx *, struct file *);
+#endif
 };
  struct inode_operations {
@@ -1548,6 +1561,16 @@ ssize_t rw_copy_check_uvector(int type, const struct
iovec __user * uvector,
 				struct iovec *fast_pointer,
 				struct iovec **ret_pointer);
 +static inline loff_t file_pos_read(struct file *file)
+{
+	return file->f_pos;
+}
+
+static inline void file_pos_write(struct file *file, loff_t pos)
+{
+	file->f_pos = pos;
+}
+
 extern ssize_t vfs_read(struct file *, char __user *, size_t, loff_t *);
 extern ssize_t vfs_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
@@ -1803,6 +1826,11 @@ extern int iterate_mounts(int (*)(struct vfsmount *, void
*), void *,
 			  struct vfsmount *);
 extern int vfs_statfs(struct dentry *, struct kstatfs *);
 +struct fs_struct;
+extern int do_chdir(struct fs_struct *fs, struct path *path);
+extern int do_chroot(struct fs_struct *fs, struct path *path);
+
+
 extern int current_umask(void);
  /* /sys/fs */
@@ -2127,7 +2155,8 @@ extern struct file *do_filp_open(int dfd, const char
*pathname,
 		int open_flag, int mode, int acc_mode);
 extern int may_open(struct path *, int, int);
 -extern int kernel_read(struct file *, loff_t, char *, unsigned long);
+extern ssize_t kernel_read(struct file *, loff_t, char *, size_t);
+extern ssize_t kernel_write(struct file *, loff_t, const char *, size_t);
 extern struct file * open_exec(const char *);
   /* fs/dcache.c -- generic fs support functions */
@@ -2305,6 +2334,10 @@ void inode_sub_bytes(struct inode *inode, loff_t bytes);
 loff_t inode_get_bytes(struct inode *inode);
 void inode_set_bytes(struct inode *inode, loff_t bytes);
 +#ifdef CONFIG_CHECKPOINT
+extern int generic_file_checkpoint(struct ckpt_ctx *ctx, struct file *file);
+#endif
+
 extern int vfs_readdir(struct file *, filldir_t, void *);
  extern int vfs_stat(char __user *, struct kstat *);
diff --git a/include/linux/fs_struct.h b/include/linux/fs_struct.h
index 78a05bf..a73cbcb 100644
--- a/include/linux/fs_struct.h
+++ b/include/linux/fs_struct.h
@@ -20,5 +20,7 @@ extern struct fs_struct *copy_fs_struct(struct fs_struct *);
 extern void free_fs_struct(struct fs_struct *);
 extern void daemonize_fs_struct(void);
 extern int unshare_fs_struct(void);
+extern void get_fs_struct(struct fs_struct *);
+extern void put_fs_struct(struct fs_struct *);
  #endif /* _LINUX_FS_STRUCT_H */
diff --git a/include/linux/futex.h b/include/linux/futex.h
index 1e5a26d..c825790 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -136,6 +136,17 @@ extern int
 handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi);
  /*
+ * In case we must use restart_block to restart a futex_wait,
+ * we encode in the 'flags' shared capability
+ */
+#define FLAGS_SHARED		0x01
+#define FLAGS_CLOCKRT		0x02
+#define FLAGS_HAS_TIMEOUT	0x04
+
+/* for c/r */
+extern long futex_wait_restart(struct restart_block *restart);
+
+/*
  * Futexes are matched on equal values of this key.
  * The key type depends on whether it's a shared or private mapping.
  * Don't rearrange members without looking at hash_futex().
@@ -174,6 +185,7 @@ union futex_key {
 #define FUTEX_KEY_INIT (union futex_key) { .both = { .ptr = NULL } }
  #ifdef CONFIG_FUTEX
+extern long do_set_robust_list(struct robust_list_head __user *head, size_t len);
 extern void exit_robust_list(struct task_struct *curr);
 extern void exit_pi_state_list(struct task_struct *curr);
 extern int futex_cmpxchg_enabled;
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 5d86fb2..97751ad 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -244,7 +244,13 @@ static inline s64 hrtimer_get_expires_ns(const struct
hrtimer *timer)
  static inline ktime_t hrtimer_expires_remaining(const struct hrtimer *timer)
 {
-    return ktime_sub(timer->_expires, timer->base->get_time());
+	return ktime_sub(timer->_expires, timer->base->get_time());
+}
+
+/* @after will usually be <= now */
+static inline ktime_t hrtimer_expires_remaining_after(const struct hrtimer
*timer, ktime_t after)
+{
+	return ktime_sub(timer->_expires, after);
 }
  #ifdef CONFIG_HIGH_RES_TIMERS
diff --git a/include/linux/magic.h b/include/linux/magic.h
index eb9800f..e04117a 100644
--- a/include/linux/magic.h
+++ b/include/linux/magic.h
@@ -58,4 +58,7 @@
 #define DEVPTS_SUPER_MAGIC	0x1cd1
 #define SOCKFS_MAGIC		0x534F434B
 +#define CHECKPOINT_MAGIC_HEAD  0x00feed0cc0a2d200LL
+#define CHECKPOINT_MAGIC_TAIL  0x002d2a0cc0deef00LL
+
 #endif /* __LINUX_MAGIC_H__ */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 462acaf..31520e5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -20,6 +20,7 @@ struct file_ra_state;
 struct user_struct;
 struct writeback_control;
 struct rlimit;
+struct ckpt_ctx;
  #ifndef CONFIG_DISCONTIGMEM          /* Don't use mapnrs, do it properly */
 extern unsigned long max_mapnr;
@@ -221,6 +222,9 @@ struct vm_operations_struct {
 	int (*migrate)(struct vm_area_struct *vma, const nodemask_t *from,
 		const nodemask_t *to, unsigned long flags);
 #endif
+#ifdef CONFIG_CHECKPOINT
+	int (*checkpoint)(struct ckpt_ctx *ctx, struct vm_area_struct *vma);
+#endif
 };
  struct mmu_gather;
@@ -336,6 +340,17 @@ void put_pages_list(struct list_head *pages);
  void split_page(struct page *page, unsigned int order);
 +/* Flag allocation requirements to shmem_getpage and shmem_swp_alloc */
+enum sgp_type {
+	SGP_READ,	/* don't exceed i_size, don't allocate page */
+	SGP_CACHE,	/* don't exceed i_size, may allocate page */
+	SGP_DIRTY,	/* like SGP_CACHE, but set new page dirty */
+	SGP_WRITE,	/* may exceed i_size, may allocate page */
+};
+
+extern int shmem_getpage(struct inode *inode, unsigned long idx,
+			 struct page **pagep, enum sgp_type sgp, int *type);
+
 /*
  * Compound pages have a destructor function.  Provide a
  * prototype for that function and accessor functions.
@@ -842,6 +857,7 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct
*mm,
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
 struct page *get_dump_page(unsigned long addr);
+struct page *__get_dirty_page(struct vm_area_struct *vma, unsigned long addr);
  extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
 extern void do_invalidatepage(struct page *page, unsigned long offset);
@@ -1282,9 +1298,13 @@ out:
 }
  extern int do_munmap(struct mm_struct *, unsigned long, size_t);
+extern int destroy_mm(struct mm_struct *);
  extern unsigned long do_brk(unsigned long, unsigned long);
 +/* fs/exec.c */
+extern int exec_mmap(struct mm_struct *mm);
+
 /* filemap.c */
 extern unsigned long page_unuse(struct page *);
 extern void truncate_inode_pages(struct address_space *, loff_t);
@@ -1294,10 +1314,27 @@ extern void truncate_inode_pages_range(struct
address_space *,
 /* generic vm_area_ops exported for stackable file systems */
 extern int filemap_fault(struct vm_area_struct *, struct vm_fault *);
 +#ifdef CONFIG_CHECKPOINT
+/* generic vm_area_ops exported for mapped files checkpoint */
+extern int filemap_checkpoint(struct ckpt_ctx *, struct vm_area_struct *);
+#endif
+
 /* mm/page-writeback.c */
 int write_one_page(struct page *page, int wait);
 void task_dirty_inc(struct task_struct *tsk);
 +
+/* checkpoint/restart */
+#ifdef CONFIG_CHECKPOINT
+struct ckpt_hdr_vma;
+extern int filemap_restore(struct ckpt_ctx *ctx, struct mm_struct *mm,
+			   struct ckpt_hdr_vma *hh);
+extern int special_mapping_restore(struct ckpt_ctx *ctx, struct mm_struct *mm,
+				   struct ckpt_hdr_vma *hh);
+extern int shmem_restore(struct ckpt_ctx *ctx, struct mm_struct *mm,
+			 struct ckpt_hdr_vma *hh);
+#endif
+
 /* readahead.c */
 #define VM_MAX_READAHEAD	128	/* kbytes */
 #define VM_MIN_READAHEAD	16	/* kbytes (includes current page) */
@@ -1369,6 +1406,7 @@ struct page *follow_page(struct vm_area_struct *, unsigned
long address,
 #define FOLL_GET	0x04	/* do get_page on page */
 #define FOLL_DUMP	0x08	/* give error on hole if it would be zero */
 #define FOLL_FORCE	0x10	/* get_user_pages read/write w/o permission */
+#define FOLL_DIRTY	0x20	/* give error on non-present file mapped */
  typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
diff --git a/include/linux/net.h b/include/linux/net.h
index 4157b5d..6ffe827 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -153,6 +153,9 @@ struct sockaddr;
 struct msghdr;
 struct module;
 +struct ckpt_ctx;
+struct ckpt_hdr_socket;
+
 struct proto_ops {
 	int		family;
 	struct module	*owner;
@@ -201,6 +204,12 @@ struct proto_ops {
 				      int offset, size_t size, int flags);
 	ssize_t 	(*splice_read)(struct socket *sock,  loff_t *ppos,
 				       struct pipe_inode_info *pipe, size_t len, unsigned int flags);
+	int		(*checkpoint)(struct ckpt_ctx *ctx,
+				      struct socket *sock);
+	int		(*collect)(struct ckpt_ctx *ctx,
+				   struct socket *sock);
+	int		(*restore)(struct ckpt_ctx *ctx, struct socket *sock,
+				   struct ckpt_hdr_socket *h);
 };
  #define DECLARE_SOCKADDR(type, dst, src)	\
@@ -237,6 +246,8 @@ extern int   	     sock_sendmsg(struct socket *sock, struct
msghdr *msg,
 				  size_t len);
 extern int	     sock_recvmsg(struct socket *sock, struct msghdr *msg,
 				  size_t size, int flags);
+extern int	     sock_alloc_file(struct socket *sock, struct file **f,
+				     int flags);
 extern int 	     sock_map_fd(struct socket *sock, int flags);
 extern struct socket *sockfd_lookup(int fd, int *err);
 #define		     sockfd_put(sock) fput(sock->file)
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index fa8b476..9f6de34 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -691,6 +691,12 @@ struct net_device_ops {
 	int			(*ndo_fcoe_get_wwn)(struct net_device *dev,
 						    u64 *wwn, int type);
 #endif
+#ifdef CONFIG_CHECKPOINT
+	int			(*ndo_collect)(struct ckpt_ctx *ctx,
+					       struct net_device *dev);
+	int			(*ndo_checkpoint)(struct ckpt_ctx *ctx,
+						  struct net_device *dev);
+#endif
 };
  /*
diff --git a/include/linux/poll.h b/include/linux/poll.h
index 600cc1f..03357b8 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -136,6 +136,9 @@ extern int core_sys_select(int n, fd_set __user *inp, fd_set
__user *outp,
  extern int poll_select_set_timeout(struct timespec *to, long sec, long nsec);
 +/* used by checkpoint/restart */
+extern long do_restart_poll(struct restart_block *restart_block);
+
 #endif /* KERNEL */
  #endif /* _LINUX_POLL_H */
diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 4f71bf4..7dd69c3 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -101,6 +101,10 @@ int posix_cpu_timer_create(struct k_itimer *timer);
 int posix_cpu_nsleep(const clockid_t which_clock, int flags,
 		     struct timespec *rqtp, struct timespec __user *rmtp);
 long posix_cpu_nsleep_restart(struct restart_block *restart_block);
+#ifdef CONFIG_COMPAT
+long compat_nanosleep_restart(struct restart_block *restart);
+long compat_clock_nanosleep_restart(struct restart_block *restart);
+#endif
 int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 			struct itimerspec *new, struct itimerspec *old);
 int posix_cpu_timer_del(struct k_itimer *timer);
@@ -119,4 +123,15 @@ long clock_nanosleep_restart(struct restart_block
*restart_block);
  void update_rlimit_cpu(unsigned long rlim_new);
 +int invalid_clockid(const clockid_t which_clock);
+
+static inline cputime_t prof_ticks(struct task_struct *p)
+{
+	return cputime_add(p->utime, p->stime);
+}
+static inline cputime_t virt_ticks(struct task_struct *p)
+{
+	return p->utime;
+}
+
 #endif
diff --git a/include/linux/resource.h b/include/linux/resource.h
index f1e914e..35f6163 100644
--- a/include/linux/resource.h
+++ b/include/linux/resource.h
@@ -73,6 +73,7 @@ struct rlimit {
 struct task_struct;
  int getrusage(struct task_struct *p, int who, struct rusage __user *ru);
+int do_setrlimit(unsigned int resource, struct rlimit *rlim);
  #endif /* __KERNEL__ */
 diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8593051..3ff96d6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -641,6 +641,10 @@ struct signal_struct {
 #endif
  	int oom_adj;	/* OOM kill score adjustment (bit shift) */
+
+#ifdef CONFIG_CHECKPOINT
+	atomic_t restart_count;		/* threads group restart sync */
+#endif
 };
  /* Context switch must be unlocked if interrupts are to be enabled */
@@ -1518,6 +1522,9 @@ struct task_struct {
 		unsigned long memsw_bytes; /* uncharged mem+swap usage */
 	} memcg_batch;
 #endif
+#ifdef CONFIG_CHECKPOINT
+	struct ckpt_ctx *checkpoint_ctx;
+#endif
 };
  /* Future-safe accessor for struct task_struct's cpus_allowed. */
@@ -1711,6 +1718,7 @@ extern void thread_group_times(struct task_struct *p,
cputime_t *ut, cputime_t *
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
 #define PF_VCPU		0x00000010	/* I'm a virtual CPU */
+#define PF_RESTARTING	0x00000020	/* Process is restarting (c/r) */
 #define PF_FORKNOEXEC	0x00000040	/* forked but didn't exec */
 #define PF_MCE_PROCESS  0x00000080      /* process policy on mce errors */
 #define PF_SUPERPRIV	0x00000100	/* used super-user privileges */
@@ -2212,7 +2220,7 @@ static inline int task_detached(struct task_struct *p)
  * Protects ->fs, ->files, ->mm, ->group_info, ->comm, keyring
  * subscriptions and synchronises with wait4().  Also used in procfs.  Also
  * pins the final release of task.io_context.  Also protects ->cpuset and
- * ->cgroup.subsys[].
+ * ->cgroup.subsys[]. Also protects ->checkpoint_ctx in checkpoint/restart.
  *
  * Nests both inside and outside of read_lock(&tasklist_lock).
  * It must not be nested with write_lock_irq(&tasklist_lock),
diff --git a/include/linux/security.h b/include/linux/security.h
index 3158dd9..7541237 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1582,6 +1582,7 @@ struct security_operations {
  	int (*task_create) (unsigned long clone_flags);
 	int (*cred_alloc_blank) (struct cred *cred, gfp_t gfp);
+
 	void (*cred_free) (struct cred *cred);
 	int (*cred_prepare)(struct cred *new, const struct cred *old,
 			    gfp_t gfp);
@@ -1913,6 +1914,9 @@ void security_release_secctx(char *secdata, u32 seclen);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
 int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
 int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen);
+
+char *security_get_lsm_name(void);
+
 #else /* CONFIG_SECURITY */
 struct security_mnt_opts {
 };
@@ -1935,6 +1939,12 @@ static inline int security_init(void)
 	return 0;
 }
 +#define DEFAULT_LSM_NAME "lsm_none"
+static inline char *security_get_lsm_name(void)
+{
+	return DEFAULT_LSM_NAME;
+}
+
 static inline int security_ptrace_access_check(struct task_struct *child,
 					     unsigned int mode)
 {
@@ -2682,6 +2692,7 @@ static inline int security_inode_getsecctx(struct inode
*inode, void **ctx, u32
 {
 	return -EOPNOTSUPP;
 }
+
 #endif	/* CONFIG_SECURITY */
  #ifdef CONFIG_SECURITY_NETWORK
diff --git a/include/linux/sem.h b/include/linux/sem.h
index 8a4adbe..8cf9636 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -127,12 +127,14 @@ struct sem_undo {
 	short *			semadj;		/* array of adjustments, one per semaphore */
 };
 +struct ipc_namespace;
 /* sem_undo_list controls shared access to the list of sem_undo structures
  * that may be shared among all a CLONE_SYSVSEM task group.
  */  struct sem_undo_list {
 	atomic_t		refcnt;
 	spinlock_t		lock;
+	struct ipc_namespace	*ipc_ns;
 	struct list_head	list_proc;
 };
 diff --git a/include/linux/shm.h b/include/linux/shm.h
index eca6235..67fe5e2 100644
--- a/include/linux/shm.h
+++ b/include/linux/shm.h
@@ -105,6 +105,9 @@ struct shmid_kernel /* private to the kernel */
  #ifdef CONFIG_SYSVIPC
 long do_shmat(int shmid, char __user *shmaddr, int shmflg, unsigned long *addr);
+long do_shmat_pgoff(int shmid, char __user *shmaddr,
+		    int shmflg, unsigned long *addr,
+		    unsigned long shmsize, unsigned long shmpgoff);
 extern int is_file_shm_hugepages(struct file *file);
 #else
 static inline long do_shmat(int shmid, char __user *shmaddr,
@@ -118,6 +121,10 @@ static inline int is_file_shm_hugepages(struct file *file)
 }
 #endif
 +struct ipc_namespace;
+extern int shmctl_down(struct ipc_namespace *ns, int shmid, int cmd,
+		       struct shmid_ds __user *buf, int version);
+
 #endif /* __KERNEL__ */
  #endif /* _LINUX_SHM_H_ */
diff --git a/include/linux/signal.h b/include/linux/signal.h
index fcd2b14..031784c 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -378,6 +378,9 @@ int unhandled_signal(struct task_struct *tsk, int sig);
  void signals_init(void);
 +/* [arch] checkpoint: should saved_sigmask be used in place of blocked */
+int task_has_saved_sigmask(struct task_struct *task);
+
 #endif /* __KERNEL__ */
  #endif /* _LINUX_SIGNAL_H */
diff --git a/include/linux/splice.h b/include/linux/splice.h
index 18e7c7c..431662c 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -82,4 +82,13 @@ extern ssize_t splice_to_pipe(struct pipe_inode_info *,
 extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,
 				      splice_direct_actor *);
 +extern int link_pipe(struct pipe_inode_info *ipipe,
+		     struct pipe_inode_info *opipe,
+		     size_t len, unsigned int flags);
+extern long do_splice_to(struct file *in, loff_t *ppos,
+			 struct pipe_inode_info *pipe, size_t len,
+			 unsigned int flags);
+extern long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
+			   loff_t *ppos, size_t len, unsigned int flags);
+
 #endif
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 4409967..b76140e 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -513,6 +513,10 @@ extern void tty_ldisc_begin(void);
 /* This last one is just for the tty layer internals and shouldn't be used
elsewhere */
 extern void tty_ldisc_enable(struct tty_struct *tty);
 +/* These are for checkpoint/restart */
+extern int tiocsctty(struct tty_struct *tty, int arg);
+extern int do_tiocspgrp(struct tty_struct *tty,
+			struct tty_struct *real_tty, pid_t pgrp_nr);
  /* n_tty.c */
 extern struct tty_ldisc_ops tty_ldisc_N_TTY;
diff --git a/include/linux/user.h b/include/linux/user.h
index 68daf84..c231e9c 100644
--- a/include/linux/user.h
+++ b/include/linux/user.h
@@ -1 +1,10 @@
+#ifndef _LINUX_USER_H
+#define _LINUX_USER_H
+
 #include <asm/user.h>
+#include <linux/sched.h>
+
+extern int may_setuid(struct user_namespace *ns, uid_t uid);
+extern int may_setgid(gid_t gid);
+
+#endif
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index cc4f453..f6ea75d 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -20,6 +20,8 @@ extern struct user_namespace init_user_ns;
  #ifdef CONFIG_USER_NS
 +struct user_namespace *new_user_ns(struct user_struct *creator,
+				   struct user_struct **newroot);
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
 {
 	if (ns)
@@ -38,6 +40,12 @@ static inline void put_user_ns(struct user_namespace *ns)
  #else
 +static inline struct user_namespace *new_user_ns(struct user_struct *creator,
+				   struct user_struct **newroot)
+{
+	return ERR_PTR(-EINVAL);
+}
+
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
 {
 	return &init_user_ns;
diff --git a/include/linux/utsname.h b/include/linux/utsname.h
index 69f3997..774001d 100644
--- a/include/linux/utsname.h
+++ b/include/linux/utsname.h
@@ -49,6 +49,7 @@ static inline void get_uts_ns(struct uts_namespace *ns)
 	kref_get(&ns->kref);
 }
 +extern struct uts_namespace *create_uts_ns(void);
 extern struct uts_namespace *copy_utsname(unsigned long flags,
 					struct uts_namespace *ns);
 extern void free_uts_ns(struct kref *kref);
diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index 1614d78..f79e72b 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -68,4 +68,5 @@ static inline int unix_sysctl_register(struct net *net) {
return 0; }
 static inline void unix_sysctl_unregister(struct net *net) {}
 #endif
 #endif
+
 #endif
diff --git a/include/net/sock.h b/include/net/sock.h
index b4603cd..3cf7de4 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1645,6 +1645,54 @@ extern void sock_enable_timestamp(struct sock *sk, int flag);
 extern int sock_get_timestamp(struct sock *, struct timeval __user *);
 extern int sock_get_timestampns(struct sock *, struct timespec __user *);
 +/* bind() helper shared between any callers needing to perform a bind on
+ * behalf of userspace (syscall and restart) with the security hooks.
+ */
+static inline int sock_bind(struct socket *sock,
+			    struct sockaddr *addr,
+			    int addr_len)
+{
+	int err;
+
+	err = security_socket_bind(sock, addr, addr_len);
+	if (err)
+		return err;
+	else
+		return sock->ops->bind(sock, addr, addr_len);
+}
+
+/* getname() helper shared between any callers needing to perform a getname on
+ * behalf of userspace (syscall and restart) with the security hooks.
+ */
+static inline int sock_getname(struct socket *sock,
+			       struct sockaddr *addr,
+			       int *addr_len)
+{
+	int err;
+
+	err = security_socket_getsockname(sock);
+	if (err)
+		return err;
+	else
+		return sock->ops->getname(sock, addr, addr_len, 0);
+}
+
+/* getpeer() helper shared between any callers needing to perform a getpeer on
+ * behalf of userspace (syscall and restart) with the security hooks.
+ */
+static inline int sock_getpeer(struct socket *sock,
+			       struct sockaddr *addr,
+			       int *addr_len)
+{
+	int err;
+
+	err = security_socket_getpeername(sock);
+	if (err)
+		return err;
+	else
+		return sock->ops->getname(sock, addr, addr_len, 1);
+}
+
 /*   *	Enable debug/info messages   */
diff --git a/init/Kconfig b/init/Kconfig
index eb77e8c..424d5b6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -201,6 +201,12 @@ config SYSVIPC
 	  section 6.4 of the Linux Programmer's Guide, available from
 	  <http://www.tldp.org/guides.html>.
 +config SYSVIPC_CHECKPOINT
+	bool
+	depends on SYSVIPC
+	depends on CHECKPOINT
+	default y
+
 config SYSVIPC_SYSCTL
 	bool
 	depends on SYSVIPC
@@ -664,7 +670,7 @@ config RELAY
  	  If unsure, say N.
 -config NAMESPACES
+menuconfig NAMESPACES
 	bool "Namespaces support" if EMBEDDED
 	default !EMBEDDED
 	help
@@ -715,6 +721,8 @@ config NET_NS
 	  Allow user space to create what appear to be multiple instances
 	  of the network stack.
 +source "kernel/checkpoint/Kconfig"
+
 config BLK_DEV_INITRD
 	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
 	depends on BROKEN || !FRV
diff --git a/ipc/Makefile b/ipc/Makefile
index 9075e17..55e38d4 100644
--- a/ipc/Makefile
+++ b/ipc/Makefile
@@ -9,4 +9,5 @@ obj_mq-$(CONFIG_COMPAT) += compat_mq.o
 obj-$(CONFIG_POSIX_MQUEUE) += mqueue.o msgutil.o $(obj_mq-y)
 obj-$(CONFIG_IPC_NS) += namespace.o
 obj-$(CONFIG_POSIX_MQUEUE_SYSCTL) += mq_sysctl.o
-
+obj-$(CONFIG_SYSVIPC_CHECKPOINT) += checkpoint.o \
+		checkpoint_shm.o checkpoint_msg.o checkpoint_sem.o
diff --git a/ipc/msg.c b/ipc/msg.c
index 9547cb7..9ef6a5e 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -71,8 +71,7 @@ struct msg_sender {
  #define msg_unlock(msq)		ipc_unlock(&(msq)->q_perm)
 -static void freeque(struct ipc_namespace *, struct kern_ipc_perm *);
-static int newque(struct ipc_namespace *, struct ipc_params *);
+static int newque(struct ipc_namespace *, struct ipc_params *, int);
 #ifdef CONFIG_PROC_FS
 static int sysvipc_msg_proc_show(struct seq_file *s, void *it);
 #endif
@@ -174,10 +173,12 @@ static inline void msg_rmid(struct ipc_namespace *ns,
struct msg_queue *s)
  * newque - Create a new msg queue
  * @ns: namespace
  * @params: ptr to the structure that contains the key and msgflg
+ * @req_id: request desired id if available (-1 if don't care)
  *
  * Called with msg_ids.rw_mutex held (writer)
  */
-static int newque(struct ipc_namespace *ns, struct ipc_params *params)
+static int
+newque(struct ipc_namespace *ns, struct ipc_params *params, int req_id)
 {
 	struct msg_queue *msq;
 	int id, retval;
@@ -201,7 +202,7 @@ static int newque(struct ipc_namespace *ns, struct
ipc_params *params)
 	/*
 	 * ipc_addid() locks msq
 	 */
-	id = ipc_addid(&msg_ids(ns), &msq->q_perm, ns->msg_ctlmni);
+	id = ipc_addid(&msg_ids(ns), &msq->q_perm, ns->msg_ctlmni, req_id);
 	if (id < 0) {
 		security_msg_queue_free(msq);
 		ipc_rcu_putref(msq);
@@ -276,7 +277,7 @@ static void expunge_all(struct msg_queue *msq, int res)
  * msg_ids.rw_mutex (writer) and the spinlock for this message queue are held
  * before freeque() is called. msg_ids.rw_mutex remains locked on exit.
  */
-static void freeque(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
+void freeque(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 {
 	struct list_head *tmp;
 	struct msg_queue *msq = container_of(ipcp, struct msg_queue, q_perm);
@@ -309,14 +310,11 @@ static inline int msg_security(struct kern_ipc_perm *ipcp,
int msgflg)
 	return security_msg_queue_associate(msq, msgflg);
 }
 -SYSCALL_DEFINE2(msgget, key_t, key, int, msgflg)
+int do_msgget(struct ipc_namespace *ns, key_t key, int msgflg, int req_id)
 {
-	struct ipc_namespace *ns;
 	struct ipc_ops msg_ops;
 	struct ipc_params msg_params;
 -	ns = current->nsproxy->ipc_ns;
-
 	msg_ops.getnew = newque;
 	msg_ops.associate = msg_security;
 	msg_ops.more_checks = NULL;
@@ -324,7 +322,12 @@ SYSCALL_DEFINE2(msgget, key_t, key, int, msgflg)
 	msg_params.key = key;
 	msg_params.flg = msgflg;
 -	return ipcget(ns, &msg_ids(ns), &msg_ops, &msg_params);
+	return ipcget(ns, &msg_ids(ns), &msg_ops, &msg_params, req_id);
+}
+
+SYSCALL_DEFINE2(msgget, key_t, key, int, msgflg)
+{
+	return do_msgget(current->nsproxy->ipc_ns, key, msgflg, -1);
 }
  static inline unsigned long
diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index f095ee2..e119243 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -36,14 +36,6 @@ struct ipc_namespace init_ipc_ns = {
  atomic_t nr_ipc_ns = ATOMIC_INIT(1);
 -struct msg_msgseg {
-	struct msg_msgseg* next;
-	/* the next part of the message follows immediately */
-};
-
-#define DATALEN_MSG	(PAGE_SIZE-sizeof(struct msg_msg))
-#define DATALEN_SEG	(PAGE_SIZE-sizeof(struct msg_msgseg))
-
 struct msg_msg *load_msg(const void __user *src, int len)
 {
 	struct msg_msg *msg;
diff --git a/ipc/namespace.c b/ipc/namespace.c
index a1094ff..8e5ea32 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -14,7 +14,7 @@
  #include "util.h"
 -static struct ipc_namespace *create_ipc_ns(void)
+struct ipc_namespace *create_ipc_ns(void)
 {
 	struct ipc_namespace *ns;
 	int err;
diff --git a/ipc/sem.c b/ipc/sem.c
index dbef95b..4fca49a 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -92,8 +92,7 @@
 #define sem_unlock(sma)		ipc_unlock(&(sma)->sem_perm)
 #define sem_checkid(sma, semid)	ipc_checkid(&sma->sem_perm, semid)
 -static int newary(struct ipc_namespace *, struct ipc_params *);
-static void freeary(struct ipc_namespace *, struct kern_ipc_perm *);
+static int newary(struct ipc_namespace *, struct ipc_params *, int);
 #ifdef CONFIG_PROC_FS
 static int sysvipc_sem_proc_show(struct seq_file *s, void *it);
 #endif
@@ -133,14 +132,6 @@ void sem_exit_ns(struct ipc_namespace *ns)
 }
 #endif
 -void __init sem_init (void)
-{
-	sem_init_ns(&init_ipc_ns);
-	ipc_init_proc_interface("sysvipc/sem",
-				"       key      semid perms      nsems   uid   gid  cuid  cgid      otime
     ctime\n",
-				IPC_SEM_IDS, sysvipc_sem_proc_show);
-}
-
 /*
  * sem_lock_(check_) routines are called in the paths where the rw_mutex
  * is not held.
@@ -228,11 +219,13 @@ static inline void sem_rmid(struct ipc_namespace *ns,
struct sem_array *s)
  * newary - Create a new semaphore set
  * @ns: namespace
  * @params: ptr to the structure that contains key, semflg and nsems
+ * @req_id: request desired id if available (-1 if don't care)
  *
  * Called with sem_ids.rw_mutex held (as a writer)
  */
 -static int newary(struct ipc_namespace *ns, struct ipc_params *params)
+static int
+newary(struct ipc_namespace *ns, struct ipc_params *params, int req_id)
 {
 	int id;
 	int retval;
@@ -265,7 +258,7 @@ static int newary(struct ipc_namespace *ns, struct
ipc_params *params)
 		return retval;
 	}
 -	id = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);
+	id = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni, req_id);
 	if (id < 0) {
 		security_sem_free(sma);
 		ipc_rcu_putref(sma);
@@ -315,14 +308,12 @@ static inline int sem_more_checks(struct kern_ipc_perm *ipcp,
 	return 0;
 }
 -SYSCALL_DEFINE3(semget, key_t, key, int, nsems, int, semflg)
+int do_semget(struct ipc_namespace *ns, key_t key, int nsems,
+	      int semflg, int req_id)
 {
-	struct ipc_namespace *ns;
 	struct ipc_ops sem_ops;
 	struct ipc_params sem_params;
 -	ns = current->nsproxy->ipc_ns;
-
 	if (nsems < 0 || nsems > ns->sc_semmsl)
 		return -EINVAL;
 @@ -334,7 +325,12 @@ SYSCALL_DEFINE3(semget, key_t, key, int, nsems, int, semflg)
 	sem_params.flg = semflg;
 	sem_params.u.nsems = nsems;
 -	return ipcget(ns, &sem_ids(ns), &sem_ops, &sem_params);
+	return ipcget(ns, &sem_ids(ns), &sem_ops, &sem_params, req_id);
+}
+
+SYSCALL_DEFINE3(semget, key_t, key, int, nsems, int, semflg)
+{
+	return do_semget(current->nsproxy->ipc_ns, key, nsems, semflg, -1);
 }
  /*
@@ -567,7 +563,7 @@ static void free_un(struct rcu_head *head)
  * as a writer and the spinlock for this semaphore set hold. sem_ids.rw_mutex
  * remains locked on exit.
  */
-static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
+void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 {
 	struct sem_undo *un, *tu;
 	struct sem_queue *q, *tq;
@@ -979,6 +975,21 @@ asmlinkage long SyS_semctl(int semid, int semnum, int cmd,
union semun arg)
 SYSCALL_ALIAS(sys_semctl, SyS_semctl);
 #endif
 +static struct sem_undo_list *alloc_undo_list(struct ipc_namespace *ipc_ns)
+{
+	struct sem_undo_list *undo_list;
+
+	undo_list = kzalloc(sizeof(*undo_list), GFP_KERNEL);
+	if (undo_list == NULL)
+		return NULL;
+	spin_lock_init(&undo_list->lock);
+	atomic_set(&undo_list->refcnt, 1);
+	INIT_LIST_HEAD(&undo_list->list_proc);
+	undo_list->ipc_ns = ipc_ns;
+
+	return undo_list;
+}
+
 /* If the task doesn't already have a undo_list, then allocate one
  * here.  We guarantee there is only one thread using this undo list,
  * and current is THE ONE
@@ -990,19 +1001,16 @@ SYSCALL_ALIAS(sys_semctl, SyS_semctl);
  *
  * This can block, so callers must hold no locks.
  */
-static inline int get_undo_list(struct sem_undo_list **undo_listp)
+static inline int get_undo_list(struct sem_undo_list **undo_listp,
+				struct ipc_namespace *ipc_ns)
 {
 	struct sem_undo_list *undo_list;
  	undo_list = current->sysvsem.undo_list;
 	if (!undo_list) {
-		undo_list = kzalloc(sizeof(*undo_list), GFP_KERNEL);
-		if (undo_list == NULL)
+		undo_list = alloc_undo_list(ipc_ns);
+		if (!undo_list)
 			return -ENOMEM;
-		spin_lock_init(&undo_list->lock);
-		atomic_set(&undo_list->refcnt, 1);
-		INIT_LIST_HEAD(&undo_list->list_proc);
-
 		current->sysvsem.undo_list = undo_list;
 	}
 	*undo_listp = undo_list;
@@ -1035,7 +1043,7 @@ static struct sem_undo *lookup_undo(struct sem_undo_list
*ulp, int semid)
 }
  /**
- * find_alloc_undo - Lookup (and if not present create) undo array
+ * __find_alloc_undo - Lookup (and if not present create) undo array
  * @ns: namespace
  * @semid: semaphore array id
  *
@@ -1045,7 +1053,8 @@ static struct sem_undo *lookup_undo(struct sem_undo_list
*ulp, int semid)
  * Lifetime-rules: sem_undo is rcu-protected, on success, the function
  * performs a rcu_read_lock().
  */
-static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
+static struct sem_undo *__find_alloc_undo(struct ipc_namespace *ns, int semid,
+					  short checkperms)
 {
 	struct sem_array *sma;
 	struct sem_undo_list *ulp;
@@ -1053,7 +1062,7 @@ static struct sem_undo *find_alloc_undo(struct
ipc_namespace *ns, int semid)
 	int nsems;
 	int error;
 -	error = get_undo_list(&ulp);
+	error = get_undo_list(&ulp, ns);
 	if (error)
 		return ERR_PTR(error);
 @@ -1071,6 +1080,11 @@ static struct sem_undo *find_alloc_undo(struct
ipc_namespace *ns, int semid)
 	if (IS_ERR(sma))
 		return ERR_PTR(PTR_ERR(sma));
 +	if (checkperms && ipcperms(&sma->sem_perm, checkperms)) {
+		sem_unlock(sma);
+		return ERR_PTR(-EPERM);
+	}
+
 	nsems = sma->sem_nsems;
 	sem_getref_and_unlock(sma);
 @@ -1117,6 +1131,11 @@ out:
 	return un;
 }
 +static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
+{
+	return __find_alloc_undo(ns, semid, 0);
+}
+
 SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 		unsigned, nsops, const struct timespec __user *, timeout)
 {
@@ -1324,7 +1343,7 @@ int copy_semundo(unsigned long clone_flags, struct
task_struct *tsk)
 	int error;
  	if (clone_flags & CLONE_SYSVSEM) {
-		error = get_undo_list(&undo_list);
+		error = get_undo_list(&undo_list, tsk->nsproxy->ipc_ns);
 		if (error)
 			return error;
 		atomic_inc(&undo_list->refcnt);
@@ -1347,14 +1366,8 @@ int copy_semundo(unsigned long clone_flags, struct
task_struct *tsk)
  * The current implementation does not do so. The POSIX standard
  * and SVID should be consulted to determine what behavior is mandated.
  */
-void exit_sem(struct task_struct *tsk)
+static void put_undo_list(struct sem_undo_list *ulp)
 {
-	struct sem_undo_list *ulp;
-
-	ulp = tsk->sysvsem.undo_list;
-	if (!ulp)
-		return;
-	tsk->sysvsem.undo_list = NULL;
  	if (!atomic_dec_and_test(&ulp->refcnt))
 		return;
@@ -1377,7 +1390,7 @@ void exit_sem(struct task_struct *tsk)
 		if (semid == -1)
 			break;
 -		sma = sem_lock_check(tsk->nsproxy->ipc_ns, un->semid);
+		sma = sem_lock_check(ulp->ipc_ns, un->semid);
  		/* exit_sem raced with IPC_RMID, nothing to do */
 		if (IS_ERR(sma))
@@ -1435,6 +1448,16 @@ void exit_sem(struct task_struct *tsk)
 	kfree(ulp);
 }
 +void exit_sem(struct task_struct *tsk)
+{
+	struct sem_undo_list *ulp = tsk->sysvsem.undo_list;
+
+	if (ulp) {
+		put_undo_list(ulp);
+		tsk->sysvsem.undo_list = NULL;
+	}
+}
+
 #ifdef CONFIG_PROC_FS
 static int sysvipc_sem_proc_show(struct seq_file *s, void *it)
 {
@@ -1454,3 +1477,19 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void
*it)
 			  sma->sem_ctime);
 }
 #endif
+
+void __init sem_init (void)
+{
+	sem_init_ns(&init_ipc_ns);
+	ipc_init_proc_interface("sysvipc/sem",
+				"       key      semid perms      nsems   uid   gid  cuid  cgid      otime
     ctime\n",
+				IPC_SEM_IDS, sysvipc_sem_proc_show);
+
+#ifdef CONFIG_CHECKPOINT
+	/* sem_undo_list uses a short but we write a __s16 */
+	CKPT_BUILD_BUG_ON_MISMATCH(*CKPT_STRUCT_MEMBER(sem_undo, semadj),
+				   __s16);
+
+	register_checkpoint_obj(&ckpt_obj_sem_undo_ops);
+#endif
+}
diff --git a/ipc/shm.c b/ipc/shm.c
index 1a314c8..ce41555 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -39,6 +39,7 @@
 #include <linux/nsproxy.h>
 #include <linux/mount.h>
 #include <linux/ipc_namespace.h>
+#include <linux/checkpoint.h>
  #include <asm/uaccess.h>
 @@ -61,7 +62,7 @@ static const struct vm_operations_struct shm_vm_ops;
 #define shm_unlock(shp)			\
 	ipc_unlock(&(shp)->shm_perm)
 -static int newseg(struct ipc_namespace *, struct ipc_params *);
+static int newseg(struct ipc_namespace *, struct ipc_params *, int);
 static void shm_open(struct vm_area_struct *vma);
 static void shm_close(struct vm_area_struct *vma);
 static void shm_destroy (struct ipc_namespace *ns, struct shmid_kernel *shp);
@@ -82,7 +83,7 @@ void shm_init_ns(struct ipc_namespace *ns)
  * Called with shm_ids.rw_mutex (writer) and the shp structure locked.
  * Only shm_ids.rw_mutex remains locked on exit.
  */
-static void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
+void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 {
 	struct shmid_kernel *shp;
 	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
@@ -329,11 +330,13 @@ static const struct vm_operations_struct shm_vm_ops = {
  * newseg - Create a new shared memory segment
  * @ns: namespace
  * @params: ptr to the structure that contains key, size and shmflg
+ * @req_id: request desired id if available (-1 if don't care)
  *
  * Called with shm_ids.rw_mutex held as a writer.
  */
 -static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
+static int
+newseg(struct ipc_namespace *ns, struct ipc_params *params, int req_id)
 {
 	key_t key = params->key;
 	int shmflg = params->flg;
@@ -388,7 +391,7 @@ static int newseg(struct ipc_namespace *ns, struct
ipc_params *params)
 	if (IS_ERR(file))
 		goto no_file;
 -	id = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
+	id = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni, req_id);
 	if (id < 0) {
 		error = id;
 		goto no_id;
@@ -448,14 +451,12 @@ static inline int shm_more_checks(struct kern_ipc_perm *ipcp,
 	return 0;
 }
 -SYSCALL_DEFINE3(shmget, key_t, key, size_t, size, int, shmflg)
+int do_shmget(struct ipc_namespace *ns, key_t key, size_t size,
+	      int shmflg, int req_id)
 {
-	struct ipc_namespace *ns;
 	struct ipc_ops shm_ops;
 	struct ipc_params shm_params;
 -	ns = current->nsproxy->ipc_ns;
-
 	shm_ops.getnew = newseg;
 	shm_ops.associate = shm_security;
 	shm_ops.more_checks = shm_more_checks;
@@ -464,7 +465,12 @@ SYSCALL_DEFINE3(shmget, key_t, key, size_t, size, int, shmflg)
 	shm_params.flg = shmflg;
 	shm_params.u.size = size;
 -	return ipcget(ns, &shm_ids(ns), &shm_ops, &shm_params);
+	return ipcget(ns, &shm_ids(ns), &shm_ops, &shm_params, req_id);
+}
+
+SYSCALL_DEFINE3(shmget, key_t, key, size_t, size, int, shmflg)
+{
+	return do_shmget(current->nsproxy->ipc_ns, key, size, shmflg, -1);
 }
  static inline unsigned long copy_shmid_to_user(void __user *buf, struct
shmid64_ds *in, int version)
@@ -595,8 +601,8 @@ static void shm_get_stat(struct ipc_namespace *ns, unsigned
long *rss,
  * to be held in write mode.
  * NOTE: no locks must be held, the rw_mutex is taken inside this function.
  */
-static int shmctl_down(struct ipc_namespace *ns, int shmid, int cmd,
-		       struct shmid_ds __user *buf, int version)
+int shmctl_down(struct ipc_namespace *ns, int shmid, int cmd,
+		struct shmid_ds __user *buf, int version)
 {
 	struct kern_ipc_perm *ipcp;
 	struct shmid64_ds shmid64;
@@ -810,11 +816,13 @@ out:
  * "raddr" thing points to kernel space, and there has to be a wrapper around
  * this.
  */
-long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
+long do_shmat_pgoff(int shmid, char __user *shmaddr, int shmflg,
+		    ulong *raddr, ulong shmsize, ulong shmpgoff)
 {
 	struct shmid_kernel *shp;
 	unsigned long addr;
 	unsigned long size;
+	unsigned long pgoff;
 	struct file * file;
 	int    err;
 	unsigned long flags;
@@ -886,6 +894,17 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg,
ulong *raddr)
 	size = i_size_read(path.dentry->d_inode);
 	shm_unlock(shp);
 +	pgoff = 0;
+
+	err = -EINVAL;
+	if (shmsize) {
+		if (shmpgoff + shmsize > size ||
+		    shmpgoff + shmsize < shmpgoff)
+			goto out_put_dentry;
+		size = shmsize;
+		pgoff = shmpgoff;
+	}
+
 	err = -ENOMEM;
 	sfd = kzalloc(sizeof(*sfd), GFP_KERNEL);
 	if (!sfd)
@@ -919,7 +938,7 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg,
ulong *raddr)
 			goto invalid;
 	}
 		
-	user_addr = do_mmap (file, addr, size, prot, flags, 0);
+	user_addr = do_mmap (file, addr, size, prot, flags, pgoff);
 	*raddr = user_addr;
 	err = 0;
 	if (IS_ERR_VALUE(user_addr))
@@ -955,6 +974,16 @@ out_put_dentry:
 	goto out_nattch;
 }
 +/*
+ * NOTE! Despite the name, this is NOT a direct system call entrypoint. The
+ * "raddr" thing points to kernel space, and there has to be a wrapper around
+ * this.
+ */
+long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
+{
+	return do_shmat_pgoff(shmid, shmaddr, shmflg, raddr, 0, 0);
+}
+
 SYSCALL_DEFINE3(shmat, int, shmid, char __user *, shmaddr, int, shmflg)
 {
 	unsigned long ret;
diff --git a/ipc/util.c b/ipc/util.c
index 79ce84e..c4ce60d 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -247,10 +247,12 @@ int ipc_get_maxid(struct ipc_ids *ids)
  *	Called with ipc_ids.rw_mutex held as a writer.
  */
  -int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
+int
+ipc_addid(struct ipc_ids *ids, struct kern_ipc_perm *new, int size, int req_id)
 {
 	uid_t euid;
 	gid_t egid;
+	int lid = 0;
 	int id, err;
  	if (size > IPCMNI)
@@ -259,28 +261,41 @@ int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm*
new, int size)
 	if (ids->in_use >= size)
 		return -ENOSPC;
 +	if (req_id >= 0)
+		lid = ipcid_to_idx(req_id);
+
 	spin_lock_init(&new->lock);
 	new->deleted = 0;
 	rcu_read_lock();
 	spin_lock(&new->lock);
 -	err = idr_get_new(&ids->ipcs_idr, new, &id);
+	err = idr_get_new_above(&ids->ipcs_idr, new, lid, &id);
 	if (err) {
 		spin_unlock(&new->lock);
 		rcu_read_unlock();
 		return err;
 	}
 +	if (req_id >= 0) {
+		if (id != lid) {
+			idr_remove(&ids->ipcs_idr, id);
+			spin_unlock(&new->lock);
+			rcu_read_unlock();
+			return -EBUSY;
+		}
+		new->seq = req_id / SEQ_MULTIPLIER;
+	} else {
+		new->seq = ids->seq++;
+		if (ids->seq > ids->seq_max)
+			ids->seq = 0;
+	}
+
 	ids->in_use++;
  	current_euid_egid(&euid, &egid);
 	new->cuid = new->uid = euid;
 	new->gid = new->cgid = egid;
 -	new->seq = ids->seq++;
-	if(ids->seq > ids->seq_max)
-		ids->seq = 0;
-
 	new->id = ipc_buildid(id, new->seq);
 	return id;
 }
@@ -296,7 +311,7 @@ int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm*
new, int size)
  *	when the key is IPC_PRIVATE.
  */
 static int ipcget_new(struct ipc_namespace *ns, struct ipc_ids *ids,
-		struct ipc_ops *ops, struct ipc_params *params)
+		struct ipc_ops *ops, struct ipc_params *params, int req_id)
 {
 	int err;
 retry:
@@ -306,7 +321,7 @@ retry:
 		return -ENOMEM;
  	down_write(&ids->rw_mutex);
-	err = ops->getnew(ns, params);
+	err = ops->getnew(ns, params, req_id);
 	up_write(&ids->rw_mutex);
  	if (err == -EAGAIN)
@@ -351,6 +366,7 @@ static int ipc_check_perms(struct kern_ipc_perm *ipcp,
struct ipc_ops *ops,
  *	@ids: IPC identifer set
  *	@ops: the actual creation routine to call
  *	@params: its parameters
+ *	@req_id: request desired id if available (-1 if don't care)
  *
  *	This routine is called by sys_msgget, sys_semget() and sys_shmget()
  *	when the key is not IPC_PRIVATE.
@@ -360,7 +376,7 @@ static int ipc_check_perms(struct kern_ipc_perm *ipcp,
struct ipc_ops *ops,
  *	On success, the ipc id is returned.
  */
 static int ipcget_public(struct ipc_namespace *ns, struct ipc_ids *ids,
-		struct ipc_ops *ops, struct ipc_params *params)
+		struct ipc_ops *ops, struct ipc_params *params, int req_id)
 {
 	struct kern_ipc_perm *ipcp;
 	int flg = params->flg;
@@ -381,7 +397,7 @@ retry:
 		else if (!err)
 			err = -ENOMEM;
 		else
-			err = ops->getnew(ns, params);
+			err = ops->getnew(ns, params, req_id);
 	} else {
 		/* ipc object has been locked by ipc_findkey() */
 @@ -742,12 +758,12 @@ struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids,
int id)
  * Common routine called by sys_msgget(), sys_semget() and sys_shmget().
  */
 int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
-			struct ipc_ops *ops, struct ipc_params *params)
+		struct ipc_ops *ops, struct ipc_params *params, int req_id)
 {
 	if (params->key == IPC_PRIVATE)
-		return ipcget_new(ns, ids, ops, params);
+		return ipcget_new(ns, ids, ops, params, req_id);
 	else
-		return ipcget_public(ns, ids, ops, params);
+		return ipcget_public(ns, ids, ops, params, req_id);
 }
  /**
diff --git a/ipc/util.h b/ipc/util.h
index 764b51a..62ea760 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -12,6 +12,7 @@
  #include <linux/unistd.h>
 #include <linux/err.h>
+#include <linux/checkpoint.h>
  #define SEQ_MULTIPLIER	(IPCMNI)
 @@ -71,7 +72,7 @@ struct ipc_params {
  *      . routine to call for an extra check if needed
  */
 struct ipc_ops {
-	int (*getnew) (struct ipc_namespace *, struct ipc_params *);
+	int (*getnew) (struct ipc_namespace *, struct ipc_params *, int);
 	int (*associate) (struct kern_ipc_perm *, int);
 	int (*more_checks) (struct kern_ipc_perm *, struct ipc_params *);
 };
@@ -94,7 +95,7 @@ void __init ipc_init_proc_interface(const char *path, const
char *header,
 #define ipcid_to_idx(id) ((id) % SEQ_MULTIPLIER)
  /* must be called with ids->rw_mutex acquired for writing */
-int ipc_addid(struct ipc_ids *, struct kern_ipc_perm *, int);
+int ipc_addid(struct ipc_ids *, struct kern_ipc_perm *, int, int);
  /* must be called with ids->rw_mutex acquired for reading */
 int ipc_get_maxid(struct ipc_ids *);
@@ -140,6 +141,14 @@ extern void free_msg(struct msg_msg *msg);
 extern struct msg_msg *load_msg(const void __user *src, int len);
 extern int store_msg(void __user *dest, struct msg_msg *msg, int len);
 +struct msg_msgseg {
+	struct msg_msgseg *next;
+	/* the next part of the message follows immediately */
+};
+
+#define DATALEN_MSG	(PAGE_SIZE-sizeof(struct msg_msg))
+#define DATALEN_SEG	(PAGE_SIZE-sizeof(struct msg_msgseg))
+
 extern void recompute_msgmni(struct ipc_namespace *);
  static inline int ipc_buildid(int id, int seq)
@@ -171,7 +180,22 @@ static inline void ipc_unlock(struct kern_ipc_perm *perm)
  struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id);
 int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
-			struct ipc_ops *ops, struct ipc_params *params);
+	   struct ipc_ops *ops, struct ipc_params *params, int req_id);
 void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
-		void (*free)(struct ipc_namespace *, struct kern_ipc_perm *));
+	       void (*free)(struct ipc_namespace *, struct kern_ipc_perm *));
+
+struct ipc_namespace *create_ipc_ns(void);
+
+int do_shmget(struct ipc_namespace *ns, key_t key, size_t size, int shmflg,
+	      int req_id);
+void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp);
+
+int do_msgget(struct ipc_namespace *ns, key_t key, int msgflg, int req_id);
+void freeque(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp);
+
+int do_semget(struct ipc_namespace *ns, key_t key, int nsems, int semflg,
+	      int req_id);
+void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp);
+
+
 #endif
diff --git a/kernel/Makefile b/kernel/Makefile
index a987aa1..67159cd 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -25,6 +25,7 @@ CFLAGS_REMOVE_sched_clock.o = -pg
 CFLAGS_REMOVE_perf_event.o = -pg
 endif
 +obj-$(CONFIG_DEFERQUEUE) += deferqueue.o
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_SYSCTL_SYSCALL_CHECK) += sysctl_check.o
@@ -105,6 +106,7 @@ obj-$(CONFIG_PERF_EVENTS) += perf_event.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
+obj-$(CONFIG_CHECKPOINT) += checkpoint/
  ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/capability.c b/kernel/capability.c
index 9e4697e..4f868b3 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -14,6 +14,8 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/pid_namespace.h>
+#include <linux/securebits.h>
+#include <linux/checkpoint.h>
 #include <asm/uaccess.h>
 #include "cred-internals.h"
 @@ -215,6 +217,45 @@ SYSCALL_DEFINE2(capget, cap_user_header_t, header,
cap_user_data_t, dataptr)
 	return ret;
 }
 +static int do_capset_tocred(kernel_cap_t *effective, kernel_cap_t *inheritable,
+			kernel_cap_t *permitted, struct cred *new)
+{
+	int ret;
+
+	ret = security_capset(new, current_cred(),
+			      effective, inheritable, permitted);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * for checkpoint-restart, do we want to wait until end of restart?
+	 * not sure we care */
+	audit_log_capset(current->pid, new, current_cred());
+
+	return 0;
+}
+
+static int do_capset(kernel_cap_t *effective, kernel_cap_t *inheritable,
+			kernel_cap_t *permitted)
+{
+	struct cred *new;
+	int ret;
+
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
+	ret = do_capset_tocred(effective, inheritable, permitted, new);
+	if (ret < 0)
+		goto error;
+
+	return commit_creds(new);
+
+error:
+	abort_creds(new);
+	return ret;
+}
+
 /**
  * sys_capset - set capabilities for a process or (*) a group of processes
  * @header: pointer to struct that contains capability version and
@@ -238,7 +279,6 @@ SYSCALL_DEFINE2(capset, cap_user_header_t, header, const
cap_user_data_t, data)
 	struct __user_cap_data_struct kdata[_KERNEL_CAPABILITY_U32S];
 	unsigned i, tocopy, copybytes;
 	kernel_cap_t inheritable, permitted, effective;
-	struct cred *new;
 	int ret;
 	pid_t pid;
 @@ -272,22 +312,52 @@ SYSCALL_DEFINE2(capset, cap_user_header_t, header, const
cap_user_data_t, data)
 		i++;
 	}
 -	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	return do_capset(&effective, &inheritable, &permitted);
 -	ret = security_capset(new, current_cred(),
-			      &effective, &inheritable, &permitted);
-	if (ret < 0)
-		goto error;
+}
+
+int apply_securebits(unsigned securebits, struct cred *new)
+{
+	if ((((new->securebits & SECURE_ALL_LOCKS) >> 1)
+	     & (new->securebits ^ securebits))				/*[1]*/
+	    || ((new->securebits & SECURE_ALL_LOCKS & ~securebits))	/*[2]*/
+	    || (securebits & ~(SECURE_ALL_LOCKS | SECURE_ALL_BITS))	/*[3]*/
+	    || (cap_capable(current, current_cred(), CAP_SETPCAP,
+			    SECURITY_CAP_AUDIT) != 0)			/*[4]*/
+		/*
+		 * [1] no changing of bits that are locked
+		 * [2] no unlocking of locks
+		 * [3] no setting of unsupported bits
+		 * [4] doing anything requires privilege (go read about
+		 *     the "sendmail capabilities bug")
+		 */
+	    )
+		/* cannot change a locked bit */
+		return -EPERM;
+	new->securebits = securebits;
+	return 0;
+}
 -	audit_log_capset(pid, new, current_cred());
+static void do_capbset_drop(struct cred *cred, int cap)
+{
+	cap_lower(cred->cap_bset, cap);
+}
 -	return commit_creds(new);
+static inline int restore_cap_bset(kernel_cap_t bset, struct cred *cred)
+{
+	int i, may_dropbcap = capable(CAP_SETPCAP);
+
+	for (i = 0; i < CAP_LAST_CAP; i++) {
+		if (cap_raised(bset, i))
+			continue;
+		if (!cap_raised(current_cred()->cap_bset, i))
+			continue;
+		if (!may_dropbcap)
+			return -EPERM;
+		do_capbset_drop(cred, i);
+	}
 -error:
-	abort_creds(new);
-	return ret;
+	return 0;
 }
  /**
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index da5e139..8f923d8 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -26,6 +26,7 @@ enum freezer_state {
 	CGROUP_THAWED = 0,
 	CGROUP_FREEZING,
 	CGROUP_FROZEN,
+	CGROUP_CHECKPOINTING,
 };
  struct freezer {
@@ -64,6 +65,44 @@ int cgroup_freezing_or_frozen(struct task_struct *task)
 	return (state == CGROUP_FREEZING) || (state == CGROUP_FROZEN);
 }
 +/* Task is frozen or will freeze immediately when next it gets woken */
+static bool is_task_frozen_enough(struct task_struct *task)
+{
+	return frozen(task) ||
+		(task_is_stopped_or_traced(task) && freezing(task));
+}
+
+/*
+ * caller must hold freezer->lock
+ */
+static void update_freezer_state(struct cgroup *cgroup,
+				 struct freezer *freezer)
+{
+	struct cgroup_iter it;
+	struct task_struct *task;
+	unsigned int nfrozen = 0, ntotal = 0;
+
+	cgroup_iter_start(cgroup, &it);
+	while ((task = cgroup_iter_next(cgroup, &it))) {
+		ntotal++;
+		if (is_task_frozen_enough(task))
+			nfrozen++;
+	}
+
+	/*
+	 * Transition to FROZEN when no new tasks can be added ensures
+	 * that we never exist in the FROZEN state while there are unfrozen
+	 * tasks.
+	 */
+	if (nfrozen == ntotal)
+		freezer->state = CGROUP_FROZEN;
+	else if (nfrozen > 0)
+		freezer->state = CGROUP_FREEZING;
+	else
+		freezer->state = CGROUP_THAWED;
+	cgroup_iter_end(cgroup, &it);
+}
+
 /*
  * cgroups_write_string() limits the size of freezer state strings to
  * CGROUP_LOCAL_BUFFER_SIZE
@@ -72,6 +111,7 @@ static const char *freezer_state_strs[] = {
 	"THAWED",
 	"FREEZING",
 	"FROZEN",
+	"CHECKPOINTING",
 };
  /*
@@ -79,9 +119,9 @@ static const char *freezer_state_strs[] = {
  * Transitions are caused by userspace writes to the freezer.state file.
  * The values in parenthesis are state labels. The rest are edge labels.
  *
- * (THAWED) --FROZEN--> (FREEZING) --FROZEN--> (FROZEN)
- *    ^ ^                    |                     |
- *    | \_______THAWED_______/                     |
+ * (THAWED) --FROZEN--> (FREEZING) --FROZEN--> (FROZEN) --> (CHECKPOINTING)
+ *    ^ ^                    |                     | ^             |
+ *    | \_______THAWED_______/                     | \_____________/
  *    \__________________________THAWED____________/
  */
 @@ -89,10 +129,10 @@ struct cgroup_subsys freezer_subsys;
  /* Locks taken and their ordering
  * ------------------------------
- * css_set_lock
  * cgroup_mutex (AKA cgroup_lock)
- * task->alloc_lock (AKA task_lock)
  * freezer->lock
+ * css_set_lock
+ * task->alloc_lock (AKA task_lock)
  * task->sighand->siglock
  *
  * cgroup code forces css_set_lock to be taken before task->alloc_lock
@@ -100,33 +140,38 @@ struct cgroup_subsys freezer_subsys;
  * freezer_create(), freezer_destroy():
  * cgroup_mutex [ by cgroup core ]
  *
- * can_attach():
- * cgroup_mutex
+ * freezer_can_attach():
+ * cgroup_mutex (held by caller of can_attach)
  *
- * cgroup_frozen():
+ * cgroup_freezing_or_frozen():
  * task->alloc_lock (to get task's cgroup)
  *
  * freezer_fork() (preserving fork() performance means can't take cgroup_mutex):
- * task->alloc_lock (to get task's cgroup)
  * freezer->lock
  *  sighand->siglock (if the cgroup is freezing)
  *
  * freezer_read():
  * cgroup_mutex
  *  freezer->lock
+ *   write_lock css_set_lock (cgroup iterator start)
+ *    task->alloc_lock
  *   read_lock css_set_lock (cgroup iterator start)
  *
  * freezer_write() (freeze):
  * cgroup_mutex
  *  freezer->lock
+ *   write_lock css_set_lock (cgroup iterator start)
+ *    task->alloc_lock
  *   read_lock css_set_lock (cgroup iterator start)
- *    sighand->siglock
+ *    sighand->siglock (fake signal delivery inside freeze_task())
  *
  * freezer_write() (unfreeze):
  * cgroup_mutex
  *  freezer->lock
+ *   write_lock css_set_lock (cgroup iterator start)
+ *    task->alloc_lock
  *   read_lock css_set_lock (cgroup iterator start)
- *    task->alloc_lock (to prevent races with freeze_task())
+ *    task->alloc_lock (inside thaw_process(), prevents race with refrigerator())
  *     sighand->siglock
  */
 static struct cgroup_subsys_state *freezer_create(struct cgroup_subsys *ss,
@@ -149,13 +194,6 @@ static void freezer_destroy(struct cgroup_subsys *ss,
 	kfree(cgroup_freezer(cgroup));
 }
 -/* Task is frozen or will freeze immediately when next it gets woken */
-static bool is_task_frozen_enough(struct task_struct *task)
-{
-	return frozen(task) ||
-		(task_is_stopped_or_traced(task) && freezing(task));
-}
-
 /*
  * The call to cgroup_lock() in the freezer.state write method prevents
  * a write to that file racing against an attach, and hence the
@@ -225,37 +263,6 @@ static void freezer_fork(struct cgroup_subsys *ss, struct
task_struct *task)
 	spin_unlock_irq(&freezer->lock);
 }
 -/*
- * caller must hold freezer->lock
- */
-static void update_freezer_state(struct cgroup *cgroup,
-				 struct freezer *freezer)
-{
-	struct cgroup_iter it;
-	struct task_struct *task;
-	unsigned int nfrozen = 0, ntotal = 0;
-
-	cgroup_iter_start(cgroup, &it);
-	while ((task = cgroup_iter_next(cgroup, &it))) {
-		ntotal++;
-		if (is_task_frozen_enough(task))
-			nfrozen++;
-	}
-
-	/*
-	 * Transition to FROZEN when no new tasks can be added ensures
-	 * that we never exist in the FROZEN state while there are unfrozen
-	 * tasks.
-	 */
-	if (nfrozen == ntotal)
-		freezer->state = CGROUP_FROZEN;
-	else if (nfrozen > 0)
-		freezer->state = CGROUP_FREEZING;
-	else
-		freezer->state = CGROUP_THAWED;
-	cgroup_iter_end(cgroup, &it);
-}
-
 static int freezer_read(struct cgroup *cgroup, struct cftype *cft,
 			struct seq_file *m)
 {
@@ -326,7 +333,10 @@ static int freezer_change_state(struct cgroup *cgroup,
 	freezer = cgroup_freezer(cgroup);
  	spin_lock_irq(&freezer->lock);
-
+	if (freezer->state == CGROUP_CHECKPOINTING) {
+		retval = -EBUSY;
+		goto out;
+	}
 	update_freezer_state(cgroup, freezer);
 	if (goal_state == freezer->state)
 		goto out;
@@ -394,3 +404,107 @@ struct cgroup_subsys freezer_subsys = {
 	.fork		= freezer_fork,
 	.exit		= NULL,
 };
+
+#ifdef CONFIG_CHECKPOINT
+/*
+ * Caller is expected to ensure that neither @p nor @q may change its
+ * freezer cgroup during this test in a way that may affect the result.
+ * E.g., when called form c/r, @p must be in CHECKPOINTING cgroup, so
+ * may not change cgroup, and either @q is also there, or is not there
+ * and may not join.
+ */
+int in_same_cgroup_freezer(struct task_struct *p, struct task_struct *q)
+{
+	struct cgroup_subsys_state *p_css, *q_css;
+
+	task_lock(p);
+	p_css = task_subsys_state(p, freezer_subsys_id);
+	task_unlock(p);
+
+	task_lock(q);
+	q_css = task_subsys_state(q, freezer_subsys_id);
+	task_unlock(q);
+
+	return (p_css == q_css);
+}
+
+/*
+ * cgroup freezer state changes made without the aid of the cgroup filesystem
+ * must go through this function to ensure proper locking is observed.
+ */
+static int freezer_checkpointing(struct task_struct *task,
+				 enum freezer_state next_state)
+{
+	struct freezer *freezer;
+	struct cgroup_subsys_state *css;
+	enum freezer_state state;
+
+	task_lock(task);
+	css = task_subsys_state(task, freezer_subsys_id);
+	css_get(css); /* make sure freezer doesn't go away */
+	freezer = container_of(css, struct freezer, css);
+	task_unlock(task);
+
+	if (freezer->state == CGROUP_FREEZING) {
+		/* May be in middle of a lazy FREEZING -> FROZEN transition */
+		if (cgroup_lock_live_group(css->cgroup)) {
+			spin_lock_irq(&freezer->lock);
+			update_freezer_state(css->cgroup, freezer);
+			spin_unlock_irq(&freezer->lock);
+			cgroup_unlock();
+		}
+	}
+
+	spin_lock_irq(&freezer->lock);
+	state = freezer->state;
+	if ((state == CGROUP_FROZEN && next_state == CGROUP_CHECKPOINTING) ||
+	    (state == CGROUP_CHECKPOINTING && next_state == CGROUP_FROZEN))
+		freezer->state = next_state;
+	spin_unlock_irq(&freezer->lock);
+	css_put(css);
+	return state;
+}
+
+int cgroup_freezer_begin_checkpoint(struct task_struct *task)
+{
+	if (freezer_checkpointing(task, CGROUP_CHECKPOINTING) != CGROUP_FROZEN)
+		return -EBUSY;
+	return 0;
+}
+
+void cgroup_freezer_end_checkpoint(struct task_struct *task)
+{
+	/*
+	 * If we weren't in CHECKPOINTING state then userspace could have
+	 * unfrozen a task and given us an inconsistent checkpoint image
+	 */
+	WARN_ON(freezer_checkpointing(task, CGROUP_FROZEN) != CGROUP_CHECKPOINTING);
+}
+
+int cgroup_freezer_make_frozen(struct task_struct *task)
+{
+	struct freezer *freezer;
+	struct cgroup_subsys_state *css;
+	int ret = -ENODEV;
+
+	task_lock(task);
+	css = task_subsys_state(task, freezer_subsys_id);
+	css_get(css); /* make sure freezer doesn't go away */
+	freezer = container_of(css, struct freezer, css);
+	task_unlock(task);
+
+	/* Never freeze the root cgroup */
+	if (!test_bit(CSS_ROOT, &css->flags) &&
+	    cgroup_lock_live_group(css->cgroup)) {
+		/* do not freeze outselves, ei ?! */
+		if (css != task_subsys_state(current, freezer_subsys_id))
+			ret = freezer_change_state(css->cgroup, CGROUP_FROZEN);
+		else
+			ret = -EPERM;
+		cgroup_unlock();
+	}
+
+	css_put(css);
+	return ret;
+}
+#endif /* CONFIG_CHECKPOINT */
diff --git a/kernel/compat.c b/kernel/compat.c
index 7f40e92..8b18f5d 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -101,7 +101,7 @@ int put_compat_timespec(const struct timespec *ts, struct
compat_timespec __user
 			__put_user(ts->tv_nsec, &cts->tv_nsec)) ? -EFAULT : 0;
 }
 -static long compat_nanosleep_restart(struct restart_block *restart)
+long compat_nanosleep_restart(struct restart_block *restart)
 {
 	struct compat_timespec __user *rmtp;
 	struct timespec rmt;
@@ -648,7 +648,7 @@ long compat_sys_clock_getres(clockid_t which_clock,
 	return err;
 }
 -static long compat_clock_nanosleep_restart(struct restart_block *restart)
+long compat_clock_nanosleep_restart(struct restart_block *restart)
 {
 	long err;
 	mm_segment_t oldfs;
diff --git a/kernel/cred.c b/kernel/cred.c
index e1dbe9e..9abe8fa 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -17,6 +17,7 @@
 #include <linux/init_task.h>
 #include <linux/security.h>
 #include <linux/cn_proc.h>
+#include <linux/checkpoint.h>
 #include "cred-internals.h"
  #if 0
@@ -895,3 +896,118 @@ void validate_creds_for_do_exit(struct task_struct *tsk)
 }
  #endif /* CONFIG_DEBUG_CREDENTIALS */
+
+int cred_setresuid(struct cred *new, uid_t ruid, uid_t euid, uid_t suid)
+{
+	int retval;
+	const struct cred *old;
+
+	retval = security_task_setuid(ruid, euid, suid, LSM_SETID_RES);
+	if (retval)
+		return retval;
+	old = current_cred();
+
+	if (!capable(CAP_SETUID)) {
+		if (ruid != (uid_t) -1 && ruid != old->uid &&
+		    ruid != old->euid  && ruid != old->suid)
+			return -EPERM;
+		if (euid != (uid_t) -1 && euid != old->uid &&
+		    euid != old->euid  && euid != old->suid)
+			return -EPERM;
+		if (suid != (uid_t) -1 && suid != old->uid &&
+		    suid != old->euid  && suid != old->suid)
+			return -EPERM;
+	}
+
+	if (ruid != (uid_t) -1) {
+		new->uid = ruid;
+		if (ruid != old->uid) {
+			retval = set_user(new);
+			if (retval < 0)
+				return retval;
+		}
+	}
+	if (euid != (uid_t) -1)
+		new->euid = euid;
+	if (suid != (uid_t) -1)
+		new->suid = suid;
+	new->fsuid = new->euid;
+
+	return security_task_fix_setuid(new, old, LSM_SETID_RES);
+}
+
+int cred_setresgid(struct cred *new, gid_t rgid, gid_t egid,
+			gid_t sgid)
+{
+	const struct cred *old = current_cred();
+	int retval;
+
+	retval = security_task_setgid(rgid, egid, sgid, LSM_SETID_RES);
+	if (retval)
+		return retval;
+
+	if (!capable(CAP_SETGID)) {
+		if (rgid != (gid_t) -1 && rgid != old->gid &&
+		    rgid != old->egid  && rgid != old->sgid)
+			return -EPERM;
+		if (egid != (gid_t) -1 && egid != old->gid &&
+		    egid != old->egid  && egid != old->sgid)
+			return -EPERM;
+		if (sgid != (gid_t) -1 && sgid != old->gid &&
+		    sgid != old->egid  && sgid != old->sgid)
+			return -EPERM;
+	}
+
+	if (rgid != (gid_t) -1)
+		new->gid = rgid;
+	if (egid != (gid_t) -1)
+		new->egid = egid;
+	if (sgid != (gid_t) -1)
+		new->sgid = sgid;
+	new->fsgid = new->egid;
+	return 0;
+}
+
+int cred_setfsuid(struct cred *new, uid_t uid, uid_t *old_fsuid)
+{
+	const struct cred *old;
+
+	old = current_cred();
+	*old_fsuid = old->fsuid;
+
+	if (security_task_setuid(uid, (uid_t)-1, (uid_t)-1, LSM_SETID_FS) < 0)
+		return -EPERM;
+
+	if (uid == old->uid  || uid == old->euid  ||
+	    uid == old->suid || uid == old->fsuid ||
+	    capable(CAP_SETUID)) {
+		if (uid != *old_fsuid) {
+			new->fsuid = uid;
+			if (security_task_fix_setuid(new, old, LSM_SETID_FS) == 0)
+				return 0;
+		}
+	}
+	return -EPERM;
+}
+
+int cred_setfsgid(struct cred *new, gid_t gid, gid_t *old_fsgid)
+{
+	const struct cred *old;
+
+	old = current_cred();
+	*old_fsgid = old->fsgid;
+
+	if (security_task_setgid(gid, (gid_t)-1, (gid_t)-1, LSM_SETID_FS))
+		return -EPERM;
+
+	if (gid == old->gid  || gid == old->egid  ||
+	    gid == old->sgid || gid == old->fsgid ||
+	    capable(CAP_SETGID)) {
+		if (gid != *old_fsgid) {
+			new->fsgid = gid;
+			return 0;
+		}
+	}
+	return -EPERM;
+}
+
diff --git a/kernel/exit.c b/kernel/exit.c
index 7f2683a..0ef6685 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -50,6 +50,7 @@
 #include <linux/perf_event.h>
 #include <trace/events/sched.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/checkpoint.h>
  #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -303,6 +304,10 @@ kill_orphaned_pgrp(struct task_struct *tsk, struct
task_struct *parent)
 	struct pid *pgrp = task_pgrp(tsk);
 	struct task_struct *ignored_task = tsk;
 +	/* restarting zombie doesn't trigger signals */
+	if (tsk->flags & PF_RESTARTING)
+		return;
+
 	if (!parent)
 		 /* exit: our father is in a different pgrp than
 		  * we are and we were the only connection outside.
@@ -792,7 +797,7 @@ static void forget_original_parent(struct task_struct *father)
 				BUG_ON(task_ptrace(t));
 				t->parent = t->real_parent;
 			}
-			if (t->pdeath_signal)
+			if (t->pdeath_signal && !(t->flags & PF_RESTARTING))
 				group_send_sig_info(t->pdeath_signal,
 						    SEND_SIG_NOINFO, t);
 		} while_each_thread(p, t);
@@ -1010,6 +1015,10 @@ NORET_TYPE void do_exit(long code)
 	if (unlikely(current->pi_state_cache))
 		kfree(current->pi_state_cache);
 #endif
+#ifdef CONFIG_CHECKPOINT
+	if (unlikely(tsk->checkpoint_ctx))
+		exit_checkpoint(tsk);
+#endif
 	/*
 	 * Make sure we are holding no locks:
 	 */
diff --git a/kernel/fork.c b/kernel/fork.c
index 9d5be5c..86ced8c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -65,6 +65,7 @@
 #include <linux/perf_event.h>
 #include <linux/posix-timers.h>
 #include <linux/user-return-notifier.h>
+#include <linux/checkpoint.h>
  #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -886,6 +887,9 @@ static int copy_signal(unsigned long clone_flags, struct
task_struct *tsk)
  	sig->oom_adj = current->signal->oom_adj;
 +#ifdef CONFIG_CHECKPOINT
+	atomic_set(&sig->restart_count, 0);
+#endif
 	return 0;
 }
 @@ -1226,6 +1230,12 @@ static struct task_struct *copy_process(unsigned long
clone_flags,
 	/* Need tasklist lock for parent etc handling! */
 	write_lock_irq(&tasklist_lock);
 +#ifdef CONFIG_CHECKPOINT
+	/* If parent is restarting, child should be too */
+	if (unlikely(current->checkpoint_ctx))
+		p->checkpoint_ctx = ckpt_ctx_get(current->checkpoint_ctx);
+#endif
+
 	/* CLONE_PARENT re-uses the old parent */
 	if (clone_flags & (CLONE_PARENT|CLONE_THREAD)) {
 		p->real_parent = current->real_parent;
diff --git a/kernel/futex.c b/kernel/futex.c
index e7a35f1..baaecb4 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1593,16 +1593,6 @@ handle_fault:
 	goto retry;
 }
 -/*
- * In case we must use restart_block to restart a futex_wait,
- * we encode in the 'flags' shared capability
- */
-#define FLAGS_SHARED		0x01
-#define FLAGS_CLOCKRT		0x02
-#define FLAGS_HAS_TIMEOUT	0x04
-
-static long futex_wait_restart(struct restart_block *restart);
-
 /**
  * fixup_owner() - Post lock pi_state and corner case management
  * @uaddr:	user address of the futex
@@ -1876,7 +1866,7 @@ out:
 }
  -static long futex_wait_restart(struct restart_block *restart)
+long futex_wait_restart(struct restart_block *restart)
 {
 	u32 __user *uaddr = (u32 __user *)restart->futex.uaddr;
 	int fshared = 0;
@@ -2352,13 +2342,7 @@ out:
  * the list. There can only be one such pending lock.
  */
 -/**
- * sys_set_robust_list() - Set the robust-futex list head of a task
- * @head:	pointer to the list-head
- * @len:	length of the list-head, as userspace expects
- */
-SYSCALL_DEFINE2(set_robust_list, struct robust_list_head __user *, head,
-		size_t, len)
+long do_set_robust_list(struct robust_list_head __user *head, size_t len)
 {
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
@@ -2374,6 +2358,17 @@ SYSCALL_DEFINE2(set_robust_list, struct robust_list_head
__user *, head,
 }
  /**
+ * sys_set_robust_list() - Set the robust-futex list head of a task
+ * @head:	pointer to the list-head
+ * @len:	length of the list-head, as userspace expects
+ */
+SYSCALL_DEFINE2(set_robust_list, struct robust_list_head __user *, head,
+		size_t, len)
+{
+	return do_set_robust_list(head, len);
+}
+
+/**
  * sys_get_robust_list() - Get the robust-futex list head of a task
  * @pid:	pid of the process [zero for current task]
  * @head_ptr:	pointer to a list-head pointer, the kernel fills it in
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index d49afb2..900bb2b 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -114,9 +114,9 @@ void compat_exit_robust_list(struct task_struct *curr)
 	}
 }
 -asmlinkage long
-compat_sys_set_robust_list(struct compat_robust_list_head __user *head,
-			   compat_size_t len)
+long
+do_compat_set_robust_list(struct compat_robust_list_head __user *head,
+			  compat_size_t len)
 {
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
@@ -130,6 +130,13 @@ compat_sys_set_robust_list(struct compat_robust_list_head
__user *head,
 }
  asmlinkage long
+compat_sys_set_robust_list(struct compat_robust_list_head __user *head,
+			   compat_size_t len)
+{
+	return do_compat_set_robust_list(head, len);
+}
+
+asmlinkage long
 compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 			   compat_size_t __user *len_ptr)
 {
diff --git a/kernel/groups.c b/kernel/groups.c
index 2b45b2e..9b0a176 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -6,6 +6,7 @@
 #include <linux/slab.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
+#include <linux/checkpoint.h>
 #include <asm/uaccess.h>
  /* init to 2 - one for init_task, one to ensure it is never freed */
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index f74e6c0..5f96b1c 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -22,6 +22,7 @@
 #include <linux/pid_namespace.h>
 #include <net/net_namespace.h>
 #include <linux/ipc_namespace.h>
+#include <linux/checkpoint.h>
  static struct kmem_cache *nsproxy_cachep;
 @@ -236,7 +237,11 @@ void exit_task_namespaces(struct task_struct *p)
 static int __init nsproxy_cache_init(void)
 {
 	nsproxy_cachep = KMEM_CACHE(nsproxy, SLAB_PANIC);
+#ifdef CONFIG_CHECKPOINT
+	return checkpoint_register_nsproxy();
+#else
 	return 0;
+#endif
 }
  module_init(nsproxy_cache_init);
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index bc7704b..fd35ef1 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -168,15 +168,6 @@ static void bump_cpu_timer(struct k_itimer *timer,
 	}
 }
 -static inline cputime_t prof_ticks(struct task_struct *p)
-{
-	return cputime_add(p->utime, p->stime);
-}
-static inline cputime_t virt_ticks(struct task_struct *p)
-{
-	return p->utime;
-}
-
 int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *tp)
 {
 	int error = check_clock(which_clock);
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 00d1fda..ec2e802 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -211,7 +211,7 @@ static int no_nsleep(const clockid_t which_clock, int flags,
 /*
  * Return nonzero if we know a priori this clockid_t value is bogus.
  */
-static inline int invalid_clockid(const clockid_t which_clock)
+int invalid_clockid(const clockid_t which_clock)
 {
 	if (which_clock < 0)	/* CPU clock, posix_cpu_* will check it */
 		return 0;
diff --git a/kernel/signal.c b/kernel/signal.c
index dbd7fe0..32dc1cd 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -30,6 +30,12 @@
 #include <linux/nsproxy.h>
 #define CREATE_TRACE_POINTS
 #include <trace/events/signal.h>
+#define CKPT_DFLAG  CKPT_DSYS
+#include <linux/errno.h>
+#include <linux/resource.h>
+#include <linux/timer.h>
+#include <linux/posix-timers.h>
+#include <linux/checkpoint.h>
  #include <asm/param.h>
 #include <asm/uaccess.h>
@@ -1449,6 +1455,10 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 	BUG_ON(!task_ptrace(tsk) &&
 	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
 +	/* restarting zombie doesn't notify parent */
+	if (tsk->flags & PF_RESTARTING)
+		return ret;
+
 	info.si_signo = sig;
 	info.si_errno = 0;
 	/*
@@ -2734,4 +2744,7 @@ __attribute__((weak)) const char *arch_vma_name(struct
vm_area_struct *vma)
 void __init signals_init(void)
 {
 	sigqueue_cachep = KMEM_CACHE(sigqueue, SLAB_PANIC);
+#ifdef CONFIG_CHECKPOINT
+	checkpoint_register_signal();
+#endif
 }
diff --git a/kernel/sys.c b/kernel/sys.c
index 6d1a7e0..9a98d05 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -565,11 +565,12 @@ error:
 /*
  * change the user struct in a credentials set to match the new UID
  */
-static int set_user(struct cred *new)
+int set_user(struct cred *new)
 {
 	struct user_struct *new_user;
 -	new_user = alloc_uid(current_user_ns(), new->uid);
+	/* is this ok? */
+	new_user = alloc_uid(new->user->user_ns, new->uid);
 	if (!new_user)
 		return -EAGAIN;
 @@ -704,14 +705,12 @@ error:
 	return retval;
 }
 -
 /*
  * This function implements a generic ability to update ruid, euid,
  * and suid.  This allows you to implement the 4.4 compatible seteuid().
  */
 SYSCALL_DEFINE3(setresuid, uid_t, ruid, uid_t, euid, uid_t, suid)
 {
-	const struct cred *old;
 	struct cred *new;
 	int retval;
 @@ -719,45 +718,10 @@ SYSCALL_DEFINE3(setresuid, uid_t, ruid, uid_t, euid,
uid_t, suid)
 	if (!new)
 		return -ENOMEM;
 -	retval = security_task_setuid(ruid, euid, suid, LSM_SETID_RES);
-	if (retval)
-		goto error;
-	old = current_cred();
-
-	retval = -EPERM;
-	if (!capable(CAP_SETUID)) {
-		if (ruid != (uid_t) -1 && ruid != old->uid &&
-		    ruid != old->euid  && ruid != old->suid)
-			goto error;
-		if (euid != (uid_t) -1 && euid != old->uid &&
-		    euid != old->euid  && euid != old->suid)
-			goto error;
-		if (suid != (uid_t) -1 && suid != old->uid &&
-		    suid != old->euid  && suid != old->suid)
-			goto error;
-	}
-
-	if (ruid != (uid_t) -1) {
-		new->uid = ruid;
-		if (ruid != old->uid) {
-			retval = set_user(new);
-			if (retval < 0)
-				goto error;
-		}
-	}
-	if (euid != (uid_t) -1)
-		new->euid = euid;
-	if (suid != (uid_t) -1)
-		new->suid = suid;
-	new->fsuid = new->euid;
-
-	retval = security_task_fix_setuid(new, old, LSM_SETID_RES);
-	if (retval < 0)
-		goto error;
-
-	return commit_creds(new);
+	retval = cred_setresuid(new, ruid, euid, suid);
+	if (retval == 0)
+		return commit_creds(new);
 -error:
 	abort_creds(new);
 	return retval;
 }
@@ -779,43 +743,17 @@ SYSCALL_DEFINE3(getresuid, uid_t __user *, ruid, uid_t
__user *, euid, uid_t __u
  */
 SYSCALL_DEFINE3(setresgid, gid_t, rgid, gid_t, egid, gid_t, sgid)
 {
-	const struct cred *old;
 	struct cred *new;
 	int retval;
  	new = prepare_creds();
 	if (!new)
 		return -ENOMEM;
-	old = current_cred();
-
-	retval = security_task_setgid(rgid, egid, sgid, LSM_SETID_RES);
-	if (retval)
-		goto error;
-
-	retval = -EPERM;
-	if (!capable(CAP_SETGID)) {
-		if (rgid != (gid_t) -1 && rgid != old->gid &&
-		    rgid != old->egid  && rgid != old->sgid)
-			goto error;
-		if (egid != (gid_t) -1 && egid != old->gid &&
-		    egid != old->egid  && egid != old->sgid)
-			goto error;
-		if (sgid != (gid_t) -1 && sgid != old->gid &&
-		    sgid != old->egid  && sgid != old->sgid)
-			goto error;
-	}
-
-	if (rgid != (gid_t) -1)
-		new->gid = rgid;
-	if (egid != (gid_t) -1)
-		new->egid = egid;
-	if (sgid != (gid_t) -1)
-		new->sgid = sgid;
-	new->fsgid = new->egid;
 -	return commit_creds(new);
+	retval = cred_setresgid(new, rgid, egid, sgid);
+	if (retval == 0)
+		return commit_creds(new);
 -error:
 	abort_creds(new);
 	return retval;
 }
@@ -832,7 +770,6 @@ SYSCALL_DEFINE3(getresgid, gid_t __user *, rgid, gid_t
__user *, egid, gid_t __u
 	return retval;
 }
 -
 /*
  * "setfsuid()" sets the fsuid - the uid used for filesystem checks. This
  * is used for "access()" and for the NFS daemon (letting nfsd stay at
@@ -841,35 +778,20 @@ SYSCALL_DEFINE3(getresgid, gid_t __user *, rgid, gid_t
__user *, egid, gid_t __u
  */
 SYSCALL_DEFINE1(setfsuid, uid_t, uid)
 {
-	const struct cred *old;
 	struct cred *new;
 	uid_t old_fsuid;
+	int retval;
  	new = prepare_creds();
 	if (!new)
 		return current_fsuid();
-	old = current_cred();
-	old_fsuid = old->fsuid;
-
-	if (security_task_setuid(uid, (uid_t)-1, (uid_t)-1, LSM_SETID_FS) < 0)
-		goto error;
-
-	if (uid == old->uid  || uid == old->euid  ||
-	    uid == old->suid || uid == old->fsuid ||
-	    capable(CAP_SETUID)) {
-		if (uid != old_fsuid) {
-			new->fsuid = uid;
-			if (security_task_fix_setuid(new, old, LSM_SETID_FS) == 0)
-				goto change_okay;
-		}
-	}
 -error:
-	abort_creds(new);
-	return old_fsuid;
+	retval = cred_setfsuid(new, uid, &old_fsuid);
+	if (retval == 0)
+		commit_creds(new);
+	else
+		abort_creds(new);
 -change_okay:
-	commit_creds(new);
 	return old_fsuid;
 }
 @@ -878,34 +800,20 @@ change_okay:
  */
 SYSCALL_DEFINE1(setfsgid, gid_t, gid)
 {
-	const struct cred *old;
 	struct cred *new;
 	gid_t old_fsgid;
+	int retval;
  	new = prepare_creds();
 	if (!new)
 		return current_fsgid();
-	old = current_cred();
-	old_fsgid = old->fsgid;
-
-	if (security_task_setgid(gid, (gid_t)-1, (gid_t)-1, LSM_SETID_FS))
-		goto error;
 -	if (gid == old->gid  || gid == old->egid  ||
-	    gid == old->sgid || gid == old->fsgid ||
-	    capable(CAP_SETGID)) {
-		if (gid != old_fsgid) {
-			new->fsgid = gid;
-			goto change_okay;
-		}
-	}
-
-error:
-	abort_creds(new);
-	return old_fsgid;
+	retval = cred_setfsgid(new, gid, &old_fsgid);
+	if (retval == 0)
+		commit_creds(new);
+	else
+		abort_creds(new);
 -change_okay:
-	commit_creds(new);
 	return old_fsgid;
 }
 @@ -1303,40 +1211,39 @@ SYSCALL_DEFINE2(old_getrlimit, unsigned int, resource,
  #endif
 -SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
+int do_setrlimit(unsigned int resource, struct rlimit *new_rlim)
 {
-	struct rlimit new_rlim, *old_rlim;
+	struct rlimit *old_rlim;
 	int retval;
  	if (resource >= RLIM_NLIMITS)
 		return -EINVAL;
-	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
-		return -EFAULT;
-	if (new_rlim.rlim_cur > new_rlim.rlim_max)
+	if (new_rlim->rlim_cur > new_rlim->rlim_max)
 		return -EINVAL;
+
 	old_rlim = current->signal->rlim + resource;
-	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
+	if ((new_rlim->rlim_max > old_rlim->rlim_max) &&
 	    !capable(CAP_SYS_RESOURCE))
 		return -EPERM;
-	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
+	if (resource == RLIMIT_NOFILE && new_rlim->rlim_max > sysctl_nr_open)
 		return -EPERM;
 -	retval = security_task_setrlimit(resource, &new_rlim);
+	retval = security_task_setrlimit(resource, new_rlim);
 	if (retval)
 		return retval;
 -	if (resource == RLIMIT_CPU && new_rlim.rlim_cur == 0) {
+	if (resource == RLIMIT_CPU && new_rlim->rlim_cur == 0) {
 		/*
 		 * The caller is asking for an immediate RLIMIT_CPU
 		 * expiry.  But we use the zero value to mean "it was
 		 * never set".  So let's cheat and make it one second
 		 * instead
 		 */
-		new_rlim.rlim_cur = 1;
+		new_rlim->rlim_cur = 1;
 	}
  	task_lock(current->group_leader);
-	*old_rlim = new_rlim;
+	*old_rlim = *new_rlim;
 	task_unlock(current->group_leader);
  	if (resource != RLIMIT_CPU)
@@ -1348,14 +1255,25 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource,
struct rlimit __user *, rlim)
 	 * very long-standing error, and fixing it now risks breakage of
 	 * applications, so we live with it
 	 */
-	if (new_rlim.rlim_cur == RLIM_INFINITY)
+	if (new_rlim->rlim_cur == RLIM_INFINITY)
 		goto out;
 -	update_rlimit_cpu(new_rlim.rlim_cur);
+	update_rlimit_cpu(new_rlim->rlim_cur);
 out:
 	return 0;
 }
 +SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
+{
+	struct rlimit new_rlim;
+
+	if (resource >= RLIM_NLIMITS)
+		return -EINVAL;
+	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
+		return -EFAULT;
+	return do_setrlimit(resource, &new_rlim);
+}
+
 /*
  * It would make sense to put struct rusage in the task_struct,
  * except that would make the task_struct be *really big*.  After
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 70f2ea7..0206aca 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -181,3 +181,7 @@ cond_syscall(sys_eventfd2);
  /* performance counters: */
 cond_syscall(sys_perf_event_open);
+
+/* checkpoint/restart */
+cond_syscall(sys_checkpoint);
+cond_syscall(sys_restart);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8686b0f..967fa2a 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -926,6 +926,7 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
diff --git a/kernel/user.c b/kernel/user.c
index 766467b..3c78366 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -16,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/user_namespace.h>
+#include <linux/checkpoint.h>
 #include "cred-internals.h"
  struct user_namespace init_user_ns = {
@@ -199,7 +200,11 @@ static int __init uid_cache_init(void)
 	uid_hash_insert(&root_user, uidhashentry(&init_user_ns, 0));
 	spin_unlock_irq(&uidhash_lock);
 +#ifdef CONFIG_CHECKPOINT
+	return checkpoint_register_userns();
+#else
 	return 0;
+#endif
 }
  module_init(uid_cache_init);
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 076c7c8..ca4790f 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -9,17 +9,11 @@
 #include <linux/nsproxy.h>
 #include <linux/slab.h>
 #include <linux/user_namespace.h>
+#include <linux/checkpoint.h>
 #include <linux/cred.h>
 -/*
- * Create a new user namespace, deriving the creator from the user in the
- * passed credentials, and replacing that user with the new root user for the
- * new namespace.
- *
- * This is called by copy_creds(), which will finish setting the target task's
- * credentials.
- */
-int create_user_ns(struct cred *new)
+static struct user_namespace *_new_user_ns(struct user_struct *creator,
+				   struct user_struct **newroot)
 {
 	struct user_namespace *ns;
 	struct user_struct *root_user;
@@ -27,7 +21,7 @@ int create_user_ns(struct cred *new)
  	ns = kmalloc(sizeof(struct user_namespace), GFP_KERNEL);
 	if (!ns)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
  	kref_init(&ns->kref);
 @@ -38,12 +32,43 @@ int create_user_ns(struct cred *new)
 	root_user = alloc_uid(ns, 0);
 	if (!root_user) {
 		kfree(ns);
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 	}
  	/* set the new root user in the credentials under preparation */
-	ns->creator = new->user;
-	new->user = root_user;
+	ns->creator = creator;
+
+	/* alloc_uid() incremented the userns refcount.  Just set it to 1 */
+	kref_set(&ns->kref, 1);
+
+	*newroot = root_user;
+	return ns;
+}
+
+struct user_namespace *new_user_ns(struct user_struct *creator,
+				   struct user_struct **newroot)
+{
+	if (!capable(CAP_SYS_ADMIN))
+		return ERR_PTR(-EPERM);
+	return _new_user_ns(creator, newroot);
+}
+
+/*
+ * Create a new user namespace, deriving the creator from the user in the
+ * passed credentials, and replacing that user with the new root user for the
+ * new namespace.
+ *
+ * This is called by copy_creds(), which will finish setting the target task's
+ * credentials.
+ */
+int create_user_ns(struct cred *new)
+{
+	struct user_namespace *ns;
+
+	ns = new_user_ns(new->user, &new->user);
+	if (IS_ERR(ns))
+		return PTR_ERR(ns);
+
 	new->uid = new->euid = new->suid = new->fsuid = 0;
 	new->gid = new->egid = new->sgid = new->fsgid = 0;
 	put_group_info(new->group_info);
@@ -54,9 +79,6 @@ int create_user_ns(struct cred *new)
 #endif
 	/* tgcred will be cleared in our caller bc CLONE_THREAD won't be set */
 -	/* alloc_uid() incremented the userns refcount.  Just set it to 1 */
-	kref_set(&ns->kref, 1);
-
 	return 0;
 }
 diff --git a/kernel/utsname.c b/kernel/utsname.c
index 8a82b4b..c82ed83 100644
--- a/kernel/utsname.c
+++ b/kernel/utsname.c
@@ -14,8 +14,9 @@
 #include <linux/utsname.h>
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <linux/checkpoint.h>
 -static struct uts_namespace *create_uts_ns(void)
+struct uts_namespace *create_uts_ns(void)
 {
 	struct uts_namespace *uts_ns;
 diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
index a2cd77e..41c837d 100644
--- a/kernel/utsname_sysctl.c
+++ b/kernel/utsname_sysctl.c
@@ -14,6 +14,10 @@
 #include <linux/utsname.h>
 #include <linux/sysctl.h>
 +#define CKPT_DFLAG  CKPT_DSYS
+#include <linux/nsproxy.h>
+#include <linux/checkpoint.h>
+
 static void *get_uts(ctl_table *table, int write)
 {
 	char *which = table->data;
@@ -108,6 +112,9 @@ static struct ctl_table uts_root_table[] = {
 static int __init utsname_sysctl_init(void)
 {
 	register_sysctl_table(uts_root_table);
+#ifdef CONFIG_CHECKPOINT
+	checkpoint_register_utsname();
+#endif
 	return 0;
 }
 diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 935248b..75d413e 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1086,6 +1086,19 @@ config DMA_API_DEBUG
 	  This option causes a performance degredation.  Use only if you want
 	  to debug device drivers. If unsure, say N.
 +config CHECKPOINT_DEBUG
+	bool "Checkpoint/restart debugging (EXPERIMENTAL)"
+	depends on CHECKPOINT
+	default y
+	help
+	  This options turns on the debugging output of checkpoint/restart.
+	  The level of verbosity is controlled by 'ckpt_debug_level' and can
+	  be set at boot time with "ckpt_debug=" option.
+
+	  Turning this option off will reduce the size of the c/r code. If
+	  turned on, it is unlikely to incur visible overhead if the debug
+	  level is set to zero.
+
 source "samples/Kconfig"
  source "lib/Kconfig.kgdb"
diff --git a/mm/Makefile b/mm/Makefile
index 6c2a73a..e779b69 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -38,6 +38,7 @@ obj-y += percpu.o
 else
 obj-y += percpu_up.o
 endif
+obj-$(CONFIG_CHECKPOINT) += checkpoint.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
 obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
diff --git a/mm/filemap.c b/mm/filemap.c
index 140ebda..d59417a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -34,6 +34,7 @@
 #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
 #include <linux/memcontrol.h>
 #include <linux/mm_inline.h> /* for page_is_file_cache() */
+#include <linux/checkpoint.h>
 #include "internal.h"
  /*
diff --git a/mm/memory.c b/mm/memory.c
index 833952d..21de72d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1314,8 +1314,17 @@ bad_page:
  no_page:
 	pte_unmap_unlock(ptep, ptl);
-	if (!pte_none(pte))
+	if (!pte_none(pte)) {
+		/*
+		 * When checkpointing we only care about dirty pages.
+		 * If a file-backed page is missing, then return an
+		 * error to tell __get_dirty_page() that it's clean,
+		 * so it won't try to demand page it into memory.
+		 */
+		if ((flags & FOLL_DIRTY) && pte_file(pte))
+			page = ERR_PTR(-EFAULT);
 		return page;
+	}
  no_page_table:
 	/*
@@ -1329,6 +1338,16 @@ no_page_table:
 	if ((flags & FOLL_DUMP) &&
 	    (!vma->vm_ops || !vma->vm_ops->fault))
 		return ERR_PTR(-EFAULT);
+
+	/*
+	 * When checkpointing we only care about dirty pages. If there
+	 * is no page table for a non-anonymous page, we return an
+	 * error to tell __get_dirty_page() that the page is clean, so
+	 * it won't allocate page tables and the page unnecessarily.
+	 */
+	if ((flags & FOLL_DIRTY) && vma->vm_ops)
+		return ERR_PTR(-EFAULT);
+
 	return page;
 }
 @@ -1586,6 +1605,80 @@ pte_t *get_locked_pte(struct mm_struct *mm, unsigned
long addr,
 	return NULL;
 }
 +/**
+ * __get_dirty_page - return page pointer for dirty user page
+ * @vma - target vma
+ * @addr - page address
+ *
+ * Looks up the page that correspond to the address in the vma, and
+ * return the page if it was modified (and grabs a reference to it),
+ * or otherwise returns NULL or error.
+ *
+ * Should only be called for private vma.
+ * Must be called with mmap_sem held for read or write.
+ */
+struct page *__get_dirty_page(struct vm_area_struct *vma, unsigned long addr)
+{
+	struct page *page;
+
+	BUG_ON(vma->vm_flags & (VM_SHARED | VM_MAYSHARE));
+
+	/*
+	 * FOLL_DUMP tells follow_page() to return -EFAULT for either
+	 * non-present anonymous pages, or memory "holes".
+	 * FOLL_DIRTY tells follow_page() to return -EFAULT also for
+	 * non-present file-mapped pages.
+	 * Otherwise, follow_page() returns the page, or NULL if the
+	 * page is swapped out.
+	 */
+
+	cond_resched();
+	while (!(page = follow_page(vma, addr,
+				    FOLL_GET | FOLL_DUMP | FOLL_DIRTY))) {
+		int ret;
+
+		/* the page is swapped out - bring it in (optimize ?) */
+		ret = handle_mm_fault(vma->vm_mm, vma, addr, 0);
+		if (ret & VM_FAULT_ERROR) {
+			if (ret & VM_FAULT_OOM)
+				return ERR_PTR(-ENOMEM);
+			else if (ret & VM_FAULT_SIGBUS)
+				return ERR_PTR(-EFAULT);
+			else
+				BUG();
+			break;
+		}
+		cond_resched();
+	}
+
+	/* -EFAULT means that the page is clean (see above) */
+	if (PTR_ERR(page) == -EFAULT)
+		return NULL;
+	else if (IS_ERR(page))
+		return page;
+
+	/*
+	 * Only care about dirty pages: either anonymous non-zero pages,
+	 * or file-backed COW (copy-on-write) pages that were modified.
+	 * A clean COW page is not interesting because its contents are
+	 * identical to the backing file; ignore such pages.
+	 * A file-backed broken COW is identified by its page_mapping()
+	 * being unset (NULL) because the page will no longer be mapped
+	 * to the original file after having been modified.
+	 */
+	if (is_zero_pfn(page_to_pfn(page))) {
+		/* this is the zero page: ignore */
+		page_cache_release(page);
+		page = NULL;
+	} else if (vma->vm_file && (page_mapping(page) != NULL)) {
+		/* file backed clean cow: ignore */
+		page_cache_release(page);
+		page = NULL;
+	}
+
+	return page;
+}
+
 /*
  * This is the old fallback for page remapping.
  *
diff --git a/mm/mmap.c b/mm/mmap.c
index f90ea92..a13d645 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -28,6 +28,7 @@
 #include <linux/rmap.h>
 #include <linux/mmu_notifier.h>
 #include <linux/perf_event.h>
+#include <linux/checkpoint.h>
  #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -2009,14 +2010,11 @@ int split_vma(struct mm_struct *mm, struct
vm_area_struct *vma,
  * work.  This now handles partial unmappings.
  * Jeremy Fitzhardinge <jeremy@goop.org>
  */
-int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
+int do_munmap_nocheck(struct mm_struct *mm, unsigned long start, size_t len)
 {
 	unsigned long end;
 	struct vm_area_struct *vma, *prev, *last;
 -	if ((start & ~PAGE_MASK) || start > TASK_SIZE || len > TASK_SIZE-start)
-		return -EINVAL;
-
 	if ((len = PAGE_ALIGN(len)) == 0)
 		return -EINVAL;
 @@ -2090,8 +2088,39 @@ int do_munmap(struct mm_struct *mm, unsigned long start,
size_t len)
 	return 0;
 }
 +int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
+{
+	if ((start & ~PAGE_MASK) || start > TASK_SIZE || len > TASK_SIZE-start)
+		return -EINVAL;
+
+	return do_munmap_nocheck(mm, start, len);
+}
+
 EXPORT_SYMBOL(do_munmap);
 +/*
+ * called with mm->mmap-sem held
+ * only called from checkpoint/memory.c:restore_mm()
+ */
+int destroy_mm(struct mm_struct *mm)
+{
+	struct vm_area_struct *vmnext = mm->mmap;
+	struct vm_area_struct *vma;
+	int ret;
+
+	while (vmnext) {
+		vma = vmnext;
+		vmnext = vmnext->vm_next;
+		ret = do_munmap_nocheck(mm, vma->vm_start,
+					vma->vm_end-vma->vm_start);
+		if (ret < 0) {
+			pr_warning("%s: failed munmap (%d)\n", __func__, ret);
+			return ret;
+		}
+	}
+	return 0;
+}
+
 SYSCALL_DEFINE2(munmap, unsigned long, addr, size_t, len)
 {
 	int ret;
@@ -2248,7 +2277,7 @@ void exit_mmap(struct mm_struct *mm)
 	tlb = tlb_gather_mmu(mm, 1);
 	/* update_hiwater_rss(mm) here? but nobody should be looking */
 	/* Use -1 here to ensure all VMAs in the mm are unmapped */
-	end = unmap_vmas(&tlb, vma, 0, -1, &nr_accounted, NULL);
+	end = vma ? unmap_vmas(&tlb, vma, 0, -1, &nr_accounted, NULL) : 0;
 	vm_unacct_memory(nr_accounted);
  	free_pgtables(tlb, vma, FIRST_USER_ADDRESS, 0);
diff --git a/mm/shmem.c b/mm/shmem.c
index eef4ebe..df30acc 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -29,6 +29,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/swap.h>
+#include <linux/checkpoint.h>
  static struct vfsmount *shm_mnt;
 @@ -98,14 +99,6 @@ static struct vfsmount *shm_mnt;
 /* Pretend that each entry is of this size in directory's i_size */
 #define BOGO_DIRENT_SIZE 20
 -/* Flag allocation requirements to shmem_getpage and shmem_swp_alloc */
-enum sgp_type {
-	SGP_READ,	/* don't exceed i_size, don't allocate page */
-	SGP_CACHE,	/* don't exceed i_size, may allocate page */
-	SGP_DIRTY,	/* like SGP_CACHE, but set new page dirty */
-	SGP_WRITE,	/* may exceed i_size, may allocate page */
-};
-
 #ifdef CONFIG_TMPFS
 static unsigned long shmem_default_max_blocks(void)
 {
@@ -118,9 +111,6 @@ static unsigned long shmem_default_max_inodes(void)
 }
 #endif
 -static int shmem_getpage(struct inode *inode, unsigned long idx,
-			 struct page **pagep, enum sgp_type sgp, int *type);
-
 static inline struct page *shmem_dir_alloc(gfp_t gfp_mask)
 {
 	/*
@@ -1213,8 +1203,8 @@ static inline struct mempolicy *shmem_get_sbmpol(struct
shmem_sb_info *sbinfo)
  * vm. If we swap it in we mark it dirty since we also free the swap
  * entry since a page cannot live in both the swap and page cache
  */
-static int shmem_getpage(struct inode *inode, unsigned long idx,
-			struct page **pagep, enum sgp_type sgp, int *type)
+int shmem_getpage(struct inode *inode, unsigned long idx,
+		  struct page **pagep, enum sgp_type sgp, int *type)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
diff --git a/net/Kconfig b/net/Kconfig
index 041c35e..c1cb774 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -276,4 +276,8 @@ source "net/wimax/Kconfig"
 source "net/rfkill/Kconfig"
 source "net/9p/Kconfig"
 +config NETNS_CHECKPOINT
+       bool
+       default y if NET && NET_NS && CHECKPOINT
+
 endif   # if NET
diff --git a/net/Makefile b/net/Makefile
index 1542e72..b7d78f4 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -65,3 +65,6 @@ ifeq ($(CONFIG_NET),y)
 obj-$(CONFIG_SYSCTL)		+= sysctl_net.o
 endif
 obj-$(CONFIG_WIMAX)		+= wimax/
+
+obj-$(CONFIG_CHECKPOINT)	+= checkpoint.o
+obj-$(CONFIG_NETNS_CHECKPOINT)	+= checkpoint_dev.o
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index 80ff87c..c00d8ce 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_TCP_CONG_LP) += tcp_lp.o
 obj-$(CONFIG_TCP_CONG_YEAH) += tcp_yeah.o
 obj-$(CONFIG_TCP_CONG_ILLINOIS) += tcp_illinois.o
 obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
+obj-$(CONFIG_CHECKPOINT) += checkpoint.o
  obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
 		      xfrm4_output.o
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index f713574..8b7d3dd 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -876,6 +876,9 @@ const struct proto_ops inet_stream_ops = {
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = tcp_sendpage,
 	.splice_read	   = tcp_splice_read,
+	.checkpoint        = inet_checkpoint,
+	.restore           = inet_restore,
+	.collect           = inet_collect,
 #ifdef CONFIG_COMPAT
 	.compat_setsockopt = compat_sock_common_setsockopt,
 	.compat_getsockopt = compat_sock_common_getsockopt,
@@ -902,6 +905,9 @@ const struct proto_ops inet_dgram_ops = {
 	.recvmsg	   = sock_common_recvmsg,
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = inet_sendpage,
+	.checkpoint        = inet_checkpoint,
+	.restore           = inet_restore,
+	.collect           = inet_collect,
 #ifdef CONFIG_COMPAT
 	.compat_setsockopt = compat_sock_common_setsockopt,
 	.compat_getsockopt = compat_sock_common_getsockopt,
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 5abae10..4105bfe 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1089,6 +1089,9 @@ static const struct net_device_ops ipip6_netdev_ops = {
 	.ndo_start_xmit	= ipip6_tunnel_xmit,
 	.ndo_do_ioctl	= ipip6_tunnel_ioctl,
 	.ndo_change_mtu	= ipip6_tunnel_change_mtu,
+#ifdef CONFIG_NETNS_CHECKPOINT
+	.ndo_checkpoint	= ipip6_checkpoint,
+#endif
 };
  static void ipip6_tunnel_setup(struct net_device *dev)
diff --git a/net/socket.c b/net/socket.c
index 5e8d0af..c5be3a4 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -343,7 +343,7 @@ static const struct dentry_operations
sockfs_dentry_operations = {
  *	but we take care of internal coherence yet.
  */
 -static int sock_alloc_file(struct socket *sock, struct file **f, int flags)
+int sock_alloc_file(struct socket *sock, struct file **f, int flags)
 {
 	struct qstr name = { .name = "" };
 	struct path path;
@@ -1422,15 +1422,10 @@ SYSCALL_DEFINE3(bind, int, fd, struct sockaddr __user *,
umyaddr, int, addrlen)
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (sock) {
 		err = move_addr_to_kernel(umyaddr, addrlen, (struct sockaddr *)&address);
-		if (err >= 0) {
-			err = security_socket_bind(sock,
-						   (struct sockaddr *)&address,
-						   addrlen);
-			if (!err)
-				err = sock->ops->bind(sock,
-						      (struct sockaddr *)
-						      &address, addrlen);
-		}
+		if (err >= 0)
+			err = sock_bind(sock,
+					(struct sockaddr *)&address,
+					addrlen);
 		fput_light(sock->file, fput_needed);
 	}
 	return err;
@@ -1609,11 +1604,7 @@ SYSCALL_DEFINE3(getsockname, int, fd, struct sockaddr
__user *, usockaddr,
 	if (!sock)
 		goto out;
 -	err = security_socket_getsockname(sock);
-	if (err)
-		goto out_put;
-
-	err = sock->ops->getname(sock, (struct sockaddr *)&address, &len, 0);
+	err = sock_getname(sock, (struct sockaddr *)&address, &len);
 	if (err)
 		goto out_put;
 	err = move_addr_to_user((struct sockaddr *)&address, len, usockaddr,
usockaddr_len);
@@ -1638,15 +1629,7 @@ SYSCALL_DEFINE3(getpeername, int, fd, struct sockaddr
__user *, usockaddr,
  	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (sock != NULL) {
-		err = security_socket_getpeername(sock);
-		if (err) {
-			fput_light(sock->file, fput_needed);
-			return err;
-		}
-
-		err =
-		    sock->ops->getname(sock, (struct sockaddr *)&address, &len,
-				       1);
+		err = sock_getpeer(sock, (struct sockaddr *)&address, &len);
 		if (!err)
 			err = move_addr_to_user((struct sockaddr *)&address, len, usockaddr,
 						usockaddr_len);
diff --git a/net/unix/Makefile b/net/unix/Makefile
index b852a2b..fbff1e6 100644
--- a/net/unix/Makefile
+++ b/net/unix/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_UNIX)	+= unix.o
  unix-y			:= af_unix.o garbage.o
 unix-$(CONFIG_SYSCTL)	+= sysctl_net_unix.o
+unix-$(CONFIG_CHECKPOINT) += checkpoint.o
diff --git a/security/capability.c b/security/capability.c
index 4875142..0876984 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -852,6 +852,7 @@ static int cap_inode_getsecctx(struct inode *inode, void
**ctx, u32 *ctxlen)
 {
 	return 0;
 }
+
 #ifdef CONFIG_KEYS
 static int cap_key_alloc(struct key *key, const struct cred *cred,
 			 unsigned long flags)
diff --git a/security/commoncap.c b/security/commoncap.c
index 6166973..532b971 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -828,24 +828,9 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned
long arg3,
 	 * capability-based-privilege environment.
 	 */
 	case PR_SET_SECUREBITS:
-		error = -EPERM;
-		if ((((new->securebits & SECURE_ALL_LOCKS) >> 1)
-		     & (new->securebits ^ arg2))			/*[1]*/
-		    || ((new->securebits & SECURE_ALL_LOCKS & ~arg2))	/*[2]*/
-		    || (arg2 & ~(SECURE_ALL_LOCKS | SECURE_ALL_BITS))	/*[3]*/
-		    || (cap_capable(current, current_cred(), CAP_SETPCAP,
-				    SECURITY_CAP_AUDIT) != 0)		/*[4]*/
-			/*
-			 * [1] no changing of bits that are locked
-			 * [2] no unlocking of locks
-			 * [3] no setting of unsupported bits
-			 * [4] doing anything requires privilege (go read about
-			 *     the "sendmail capabilities bug")
-			 */
-		    )
-			/* cannot change a locked bit */
+		error = apply_securebits(arg2, new);
+		if (error)
 			goto error;
-		new->securebits = arg2;
 		goto changed;
  	case PR_GET_SECUREBITS:
diff --git a/security/selinux/include/classmap.h
b/security/selinux/include/classmap.h
index 8b32e95..b1cde03 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -24,7 +24,7 @@ struct security_class_mapping secclass_map[] = {
 	    "getattr", "setexec", "setfscreate", "noatsecure", "siginh",
 	    "setrlimit", "rlimitinh", "dyntransition", "setcurrent",
 	    "execmem", "execstack", "execheap", "setkeycreate",
-	    "setsockcreate", NULL } },
+	    "setsockcreate", "restore", NULL } },
 	{ "system",
 	  { "ipc_info", "syslog_read", "syslog_mod",
 	    "syslog_console", "module_request", NULL } },
@@ -43,7 +43,8 @@ struct security_class_mapping secclass_map[] = {
 	    "quotaget", NULL } },
 	{ "file",
 	  { COMMON_FILE_PERMS,
-	    "execute_no_trans", "entrypoint", "execmod", "open", NULL } },
+	    "execute_no_trans", "entrypoint", "execmod", "open",
+	    "restore", "fown_restore", NULL } },
 	{ "dir",
 	  { COMMON_FILE_PERMS, "add_name", "remove_name",
 	    "reparent", "search", "rmdir", "open", NULL } },
@@ -93,13 +94,13 @@ struct security_class_mapping secclass_map[] = {
 	  } },
 	{ "sem",
 	  { COMMON_IPC_PERMS, NULL } },
-	{ "msg", { "send", "receive", NULL } },
+	{ "msg", { "send", "receive", "restore", NULL } },
 	{ "msgq",
 	  { COMMON_IPC_PERMS, "enqueue", NULL } },
 	{ "shm",
 	  { COMMON_IPC_PERMS, "lock", NULL } },
 	{ "ipc",
-	  { COMMON_IPC_PERMS, NULL } },
+	  { COMMON_IPC_PERMS, "restore", NULL } },
 	{ "netlink_route_socket",
 	  { COMMON_SOCK_PERMS,
 	    "nlmsg_read", "nlmsg_write", NULL } },
diff --git a/security/smack/smack.h b/security/smack/smack.h
index c6e9aca..a8917b0 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -216,6 +216,7 @@ u32 smack_to_secid(const char *);
 extern int smack_cipso_direct;
 extern char *smack_net_ambient;
 extern char *smack_onlycap;
+extern char *smack_version;
 extern const char *smack_cipso_option;
  extern struct smack_known smack_known_floor;
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index fdfeaa2..501e66a 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3119,6 +3119,7 @@ struct security_operations smack_ops = {
 	.file_receive = 		smack_file_receive,
  	.cred_alloc_blank =		smack_cred_alloc_blank,
+
 	.cred_free =			smack_cred_free,
 	.cred_prepare =			smack_cred_prepare,
 	.cred_commit =			smack_cred_commit,
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index a2b72d7..cc3046b 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -1256,6 +1256,7 @@ static const struct file_operations smk_logging_ops = {
 	.read		= smk_read_logging,
 	.write		= smk_write_logging,
 };
+
 /**
  * smk_fill_super - fill the /smackfs superblock
  * @sb: the empty superblock

