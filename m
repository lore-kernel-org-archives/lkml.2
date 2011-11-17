Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab1KQWhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 17:37:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:12670 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab1KQWhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 17:37:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="77077685"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org, kbuild@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 8/8] x86: Generate system call tables and unistd_*.h from tables
Date: Thu, 17 Nov 2011 14:37:26 -0800
Message-Id: <1321569446-20433-9-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1321569446-20433-1-git-send-email-hpa@linux.intel.com>
References: <1321569446-20433-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Generate system call tables and unistd_*.h automatically from the
tables in arch/x86/syscalls.  All other information, like NR_syscalls,
is auto-generated, some of which is in asm-offsets_*.c.

This allows us to keep all the system call information in one place,
and allows for kernel space and user space to see different
information; this is currently used for the ia32 system call numbers
when building the 64-bit kernel, but will be used by the x32 ABI in
the near future.

This also removes some gratuitious differences between i386, x86-64
and ia32; in particular, now all system call tables are generated with
the same mechanism.

Cc: H. J. Lu <hjl.tools@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Makefile                  |    6 +
 arch/x86/ia32/Makefile             |    2 +-
 arch/x86/ia32/ia32entry.S          |  356 -----------------
 arch/x86/ia32/syscall_ia32.c       |   25 ++
 arch/x86/include/asm/Kbuild        |    5 +-
 arch/x86/include/asm/ia32_unistd.h |   13 +-
 arch/x86/include/asm/unistd.h      |   54 +++-
 arch/x86/include/asm/unistd_32.h   |  401 --------------------
 arch/x86/include/asm/unistd_64.h   |  732 ------------------------------------
 arch/x86/kernel/Makefile           |    3 +-
 arch/x86/kernel/asm-offsets_32.c   |    8 +
 arch/x86/kernel/asm-offsets_64.c   |   19 +-
 arch/x86/kernel/entry_32.S         |   37 +--
 arch/x86/kernel/syscall_32.c       |   25 ++
 arch/x86/kernel/syscall_64.c       |   14 +-
 arch/x86/kernel/syscall_table_32.S |  350 -----------------
 16 files changed, 154 insertions(+), 1896 deletions(-)
 create mode 100644 arch/x86/ia32/syscall_ia32.c
 delete mode 100644 arch/x86/include/asm/unistd_32.h
 delete mode 100644 arch/x86/include/asm/unistd_64.h
 create mode 100644 arch/x86/kernel/syscall_32.c
 delete mode 100644 arch/x86/kernel/syscall_table_32.S

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index b02e509..209ba12 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -118,6 +118,12 @@ KBUILD_CFLAGS += $(mflags-y)
 KBUILD_AFLAGS += $(mflags-y)
 
 ###
+# Syscall table generation
+
+archheaders:
+	$(Q)$(MAKE) $(build)=arch/x86/syscalls all
+
+###
 # Kernel objects
 
 head-y := arch/x86/kernel/head_$(BITS).o
diff --git a/arch/x86/ia32/Makefile b/arch/x86/ia32/Makefile
index eea9a1c..455646e 100644
--- a/arch/x86/ia32/Makefile
+++ b/arch/x86/ia32/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-$(CONFIG_IA32_EMULATION) := ia32entry.o sys_ia32.o ia32_signal.o
-obj-$(CONFIG_IA32_EMULATION) += nosyscall.o
+obj-$(CONFIG_IA32_EMULATION) += nosyscall.o syscall_ia32.o
 
 sysv-$(CONFIG_SYSVIPC) := ipc32.o
 obj-$(CONFIG_IA32_EMULATION) += $(sysv-y)
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 59538a7..72f853a 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -27,8 +27,6 @@
 
 	.section .entry.text, "ax"
 
-#define IA32_NR_syscalls ((ia32_syscall_end - ia32_sys_call_table)/8)
-
 	.macro IA32_ARG_FIXUP noebp=0
 	movl	%edi,%r8d
 	.if \noebp
@@ -496,357 +494,3 @@ ENTRY(ia32_ptregs_common)
 	jmp  ia32_sysret	/* misbalances the return cache */
 	CFI_ENDPROC
 END(ia32_ptregs_common)
-
-	.section .rodata,"a"
-	.align 8
-ia32_sys_call_table:
-	.quad sys_restart_syscall
-	.quad sys_exit
-	.quad stub32_fork
-	.quad sys_read
-	.quad sys_write
-	.quad compat_sys_open		/* 5 */
-	.quad sys_close
-	.quad sys32_waitpid
-	.quad sys_creat
-	.quad sys_link
-	.quad sys_unlink		/* 10 */
-	.quad stub32_execve
-	.quad sys_chdir
-	.quad compat_sys_time
-	.quad sys_mknod
-	.quad sys_chmod		/* 15 */
-	.quad sys_lchown16
-	.quad quiet_ni_syscall			/* old break syscall holder */
-	.quad sys_stat
-	.quad sys32_lseek
-	.quad sys_getpid		/* 20 */
-	.quad compat_sys_mount	/* mount  */
-	.quad sys_oldumount	/* old_umount  */
-	.quad sys_setuid16
-	.quad sys_getuid16
-	.quad compat_sys_stime	/* stime */		/* 25 */
-	.quad compat_sys_ptrace	/* ptrace */
-	.quad sys_alarm
-	.quad sys_fstat	/* (old)fstat */
-	.quad sys_pause
-	.quad compat_sys_utime	/* 30 */
-	.quad quiet_ni_syscall	/* old stty syscall holder */
-	.quad quiet_ni_syscall	/* old gtty syscall holder */
-	.quad sys_access
-	.quad sys_nice	
-	.quad quiet_ni_syscall	/* 35 */	/* old ftime syscall holder */
-	.quad sys_sync
-	.quad sys32_kill
-	.quad sys_rename
-	.quad sys_mkdir
-	.quad sys_rmdir		/* 40 */
-	.quad sys_dup
-	.quad sys_pipe
-	.quad compat_sys_times
-	.quad quiet_ni_syscall			/* old prof syscall holder */
-	.quad sys_brk		/* 45 */
-	.quad sys_setgid16
-	.quad sys_getgid16
-	.quad sys_signal
-	.quad sys_geteuid16
-	.quad sys_getegid16	/* 50 */
-	.quad sys_acct
-	.quad sys_umount			/* new_umount */
-	.quad quiet_ni_syscall			/* old lock syscall holder */
-	.quad compat_sys_ioctl
-	.quad compat_sys_fcntl64		/* 55 */
-	.quad quiet_ni_syscall			/* old mpx syscall holder */
-	.quad sys_setpgid
-	.quad quiet_ni_syscall			/* old ulimit syscall holder */
-	.quad sys_olduname
-	.quad sys_umask		/* 60 */
-	.quad sys_chroot
-	.quad compat_sys_ustat
-	.quad sys_dup2
-	.quad sys_getppid
-	.quad sys_getpgrp		/* 65 */
-	.quad sys_setsid
-	.quad sys32_sigaction
-	.quad sys_sgetmask
-	.quad sys_ssetmask
-	.quad sys_setreuid16	/* 70 */
-	.quad sys_setregid16
-	.quad sys32_sigsuspend
-	.quad compat_sys_sigpending
-	.quad sys_sethostname
-	.quad compat_sys_setrlimit	/* 75 */
-	.quad compat_sys_old_getrlimit	/* old_getrlimit */
-	.quad compat_sys_getrusage
-	.quad compat_sys_gettimeofday
-	.quad compat_sys_settimeofday
-	.quad sys_getgroups16	/* 80 */
-	.quad sys_setgroups16
-	.quad compat_sys_old_select
-	.quad sys_symlink
-	.quad sys_lstat
-	.quad sys_readlink		/* 85 */
-	.quad sys_uselib
-	.quad sys_swapon
-	.quad sys_reboot
-	.quad compat_sys_old_readdir
-	.quad sys32_mmap		/* 90 */
-	.quad sys_munmap
-	.quad sys_truncate
-	.quad sys_ftruncate
-	.quad sys_fchmod
-	.quad sys_fchown16		/* 95 */
-	.quad sys_getpriority
-	.quad sys_setpriority
-	.quad quiet_ni_syscall			/* old profil syscall holder */
-	.quad compat_sys_statfs
-	.quad compat_sys_fstatfs		/* 100 */
-	.quad sys_ioperm
-	.quad compat_sys_socketcall
-	.quad sys_syslog
-	.quad compat_sys_setitimer
-	.quad compat_sys_getitimer	/* 105 */
-	.quad compat_sys_newstat
-	.quad compat_sys_newlstat
-	.quad compat_sys_newfstat
-	.quad sys_uname
-	.quad stub32_iopl		/* 110 */
-	.quad sys_vhangup
-	.quad quiet_ni_syscall	/* old "idle" system call */
-	.quad sys32_vm86_warning	/* vm86old */ 
-	.quad compat_sys_wait4
-	.quad sys_swapoff		/* 115 */
-	.quad compat_sys_sysinfo
-	.quad sys32_ipc
-	.quad sys_fsync
-	.quad stub32_sigreturn
-	.quad stub32_clone		/* 120 */
-	.quad sys_setdomainname
-	.quad sys_newuname
-	.quad sys_modify_ldt
-	.quad compat_sys_adjtimex
-	.quad sys32_mprotect		/* 125 */
-	.quad compat_sys_sigprocmask
-	.quad quiet_ni_syscall		/* create_module */
-	.quad sys_init_module
-	.quad sys_delete_module
-	.quad quiet_ni_syscall		/* 130  get_kernel_syms */
-	.quad sys32_quotactl
-	.quad sys_getpgid
-	.quad sys_fchdir
-	.quad quiet_ni_syscall	/* bdflush */
-	.quad sys_sysfs		/* 135 */
-	.quad sys_personality
-	.quad quiet_ni_syscall	/* for afs_syscall */
-	.quad sys_setfsuid16
-	.quad sys_setfsgid16
-	.quad sys_llseek		/* 140 */
-	.quad compat_sys_getdents
-	.quad compat_sys_select
-	.quad sys_flock
-	.quad sys_msync
-	.quad compat_sys_readv		/* 145 */
-	.quad compat_sys_writev
-	.quad sys_getsid
-	.quad sys_fdatasync
-	.quad compat_sys_sysctl	/* sysctl */
-	.quad sys_mlock		/* 150 */
-	.quad sys_munlock
-	.quad sys_mlockall
-	.quad sys_munlockall
-	.quad sys_sched_setparam
-	.quad sys_sched_getparam   /* 155 */
-	.quad sys_sched_setscheduler
-	.quad sys_sched_getscheduler
-	.quad sys_sched_yield
-	.quad sys_sched_get_priority_max
-	.quad sys_sched_get_priority_min  /* 160 */
-	.quad sys32_sched_rr_get_interval
-	.quad compat_sys_nanosleep
-	.quad sys_mremap
-	.quad sys_setresuid16
-	.quad sys_getresuid16	/* 165 */
-	.quad sys32_vm86_warning	/* vm86 */ 
-	.quad quiet_ni_syscall	/* query_module */
-	.quad sys_poll
-	.quad quiet_ni_syscall /* old nfsservctl */
-	.quad sys_setresgid16	/* 170 */
-	.quad sys_getresgid16
-	.quad sys_prctl
-	.quad stub32_rt_sigreturn
-	.quad sys32_rt_sigaction
-	.quad sys32_rt_sigprocmask	/* 175 */
-	.quad sys32_rt_sigpending
-	.quad compat_sys_rt_sigtimedwait
-	.quad sys32_rt_sigqueueinfo
-	.quad sys_rt_sigsuspend
-	.quad sys32_pread		/* 180 */
-	.quad sys32_pwrite
-	.quad sys_chown16
-	.quad sys_getcwd
-	.quad sys_capget
-	.quad sys_capset
-	.quad stub32_sigaltstack
-	.quad sys32_sendfile
-	.quad quiet_ni_syscall		/* streams1 */
-	.quad quiet_ni_syscall		/* streams2 */
-	.quad stub32_vfork            /* 190 */
-	.quad compat_sys_getrlimit
-	.quad sys_mmap_pgoff
-	.quad sys32_truncate64
-	.quad sys32_ftruncate64
-	.quad sys32_stat64		/* 195 */
-	.quad sys32_lstat64
-	.quad sys32_fstat64
-	.quad sys_lchown
-	.quad sys_getuid
-	.quad sys_getgid		/* 200 */
-	.quad sys_geteuid
-	.quad sys_getegid
-	.quad sys_setreuid
-	.quad sys_setregid
-	.quad sys_getgroups	/* 205 */
-	.quad sys_setgroups
-	.quad sys_fchown
-	.quad sys_setresuid
-	.quad sys_getresuid
-	.quad sys_setresgid	/* 210 */
-	.quad sys_getresgid
-	.quad sys_chown
-	.quad sys_setuid
-	.quad sys_setgid
-	.quad sys_setfsuid		/* 215 */
-	.quad sys_setfsgid
-	.quad sys_pivot_root
-	.quad sys_mincore
-	.quad sys_madvise
-	.quad compat_sys_getdents64	/* 220 getdents64 */
-	.quad compat_sys_fcntl64	
-	.quad quiet_ni_syscall		/* tux */
-	.quad quiet_ni_syscall    	/* security */
-	.quad sys_gettid	
-	.quad sys32_readahead	/* 225 */
-	.quad sys_setxattr
-	.quad sys_lsetxattr
-	.quad sys_fsetxattr
-	.quad sys_getxattr
-	.quad sys_lgetxattr	/* 230 */
-	.quad sys_fgetxattr
-	.quad sys_listxattr
-	.quad sys_llistxattr
-	.quad sys_flistxattr
-	.quad sys_removexattr	/* 235 */
-	.quad sys_lremovexattr
-	.quad sys_fremovexattr
-	.quad sys_tkill
-	.quad sys_sendfile64 
-	.quad compat_sys_futex		/* 240 */
-	.quad compat_sys_sched_setaffinity
-	.quad compat_sys_sched_getaffinity
-	.quad sys_set_thread_area
-	.quad sys_get_thread_area
-	.quad compat_sys_io_setup	/* 245 */
-	.quad sys_io_destroy
-	.quad compat_sys_io_getevents
-	.quad compat_sys_io_submit
-	.quad sys_io_cancel
-	.quad sys32_fadvise64		/* 250 */
-	.quad quiet_ni_syscall 	/* free_huge_pages */
-	.quad sys_exit_group
-	.quad sys32_lookup_dcookie
-	.quad sys_epoll_create
-	.quad sys_epoll_ctl		/* 255 */
-	.quad sys_epoll_wait
-	.quad sys_remap_file_pages
-	.quad sys_set_tid_address
-	.quad compat_sys_timer_create
-	.quad compat_sys_timer_settime	/* 260 */
-	.quad compat_sys_timer_gettime
-	.quad sys_timer_getoverrun
-	.quad sys_timer_delete
-	.quad compat_sys_clock_settime
-	.quad compat_sys_clock_gettime	/* 265 */
-	.quad compat_sys_clock_getres
-	.quad compat_sys_clock_nanosleep
-	.quad compat_sys_statfs64
-	.quad compat_sys_fstatfs64
-	.quad sys_tgkill		/* 270 */
-	.quad compat_sys_utimes
-	.quad sys32_fadvise64_64
-	.quad quiet_ni_syscall	/* sys_vserver */
-	.quad sys_mbind
-	.quad compat_sys_get_mempolicy	/* 275 */
-	.quad sys_set_mempolicy
-	.quad compat_sys_mq_open
-	.quad sys_mq_unlink
-	.quad compat_sys_mq_timedsend
-	.quad compat_sys_mq_timedreceive	/* 280 */
-	.quad compat_sys_mq_notify
-	.quad compat_sys_mq_getsetattr
-	.quad compat_sys_kexec_load	/* reserved for kexec */
-	.quad compat_sys_waitid
-	.quad quiet_ni_syscall		/* 285: sys_altroot */
-	.quad sys_add_key
-	.quad sys_request_key
-	.quad sys_keyctl
-	.quad sys_ioprio_set
-	.quad sys_ioprio_get		/* 290 */
-	.quad sys_inotify_init
-	.quad sys_inotify_add_watch
-	.quad sys_inotify_rm_watch
-	.quad sys_migrate_pages
-	.quad compat_sys_openat		/* 295 */
-	.quad sys_mkdirat
-	.quad sys_mknodat
-	.quad sys_fchownat
-	.quad compat_sys_futimesat
-	.quad sys32_fstatat		/* 300 */
-	.quad sys_unlinkat
-	.quad sys_renameat
-	.quad sys_linkat
-	.quad sys_symlinkat
-	.quad sys_readlinkat		/* 305 */
-	.quad sys_fchmodat
-	.quad sys_faccessat
-	.quad compat_sys_pselect6
-	.quad compat_sys_ppoll
-	.quad sys_unshare		/* 310 */
-	.quad compat_sys_set_robust_list
-	.quad compat_sys_get_robust_list
-	.quad sys_splice
-	.quad sys32_sync_file_range
-	.quad sys_tee			/* 315 */
-	.quad compat_sys_vmsplice
-	.quad compat_sys_move_pages
-	.quad sys_getcpu
-	.quad sys_epoll_pwait
-	.quad compat_sys_utimensat	/* 320 */
-	.quad compat_sys_signalfd
-	.quad sys_timerfd_create
-	.quad sys_eventfd
-	.quad sys32_fallocate
-	.quad compat_sys_timerfd_settime	/* 325 */
-	.quad compat_sys_timerfd_gettime
-	.quad compat_sys_signalfd4
-	.quad sys_eventfd2
-	.quad sys_epoll_create1
-	.quad sys_dup3				/* 330 */
-	.quad sys_pipe2
-	.quad sys_inotify_init1
-	.quad compat_sys_preadv
-	.quad compat_sys_pwritev
-	.quad compat_sys_rt_tgsigqueueinfo	/* 335 */
-	.quad sys_perf_event_open
-	.quad compat_sys_recvmmsg
-	.quad sys_fanotify_init
-	.quad sys32_fanotify_mark
-	.quad sys_prlimit64		/* 340 */
-	.quad sys_name_to_handle_at
-	.quad compat_sys_open_by_handle_at
-	.quad compat_sys_clock_adjtime
-	.quad sys_syncfs
-	.quad compat_sys_sendmmsg	/* 345 */
-	.quad sys_setns
-	.quad compat_sys_process_vm_readv
-	.quad compat_sys_process_vm_writev
-ia32_syscall_end:
diff --git a/arch/x86/ia32/syscall_ia32.c b/arch/x86/ia32/syscall_ia32.c
new file mode 100644
index 0000000..d04d3db
--- /dev/null
+++ b/arch/x86/ia32/syscall_ia32.c
@@ -0,0 +1,25 @@
+/* System call table for ia32 emulation. */
+
+#include <linux/linkage.h>
+#include <linux/sys.h>
+#include <linux/cache.h>
+#include <asm/asm-offsets.h>
+
+#define __SYSCALL_I386(nr, sym, compat) extern asmlinkage void compat(void) ;
+#include <asm/syscalls_32.h>
+#undef __SYSCALL_I386
+
+#define __SYSCALL_I386(nr, sym, compat) [nr] = compat,
+
+typedef void (*sys_call_ptr_t)(void);
+
+extern void compat_ni_syscall(void);
+
+const sys_call_ptr_t ia32_sys_call_table[__NR_ia32_syscall_max+1] = {
+	/*
+	 * Smells like a like a compiler bug -- it doesn't work
+	 * when the & below is removed.
+	 */
+	[0 ... __NR_ia32_syscall_max] = &compat_ni_syscall,
+#include <asm/syscalls_32.h>
+};
diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 6fa90a8..b57e6a4 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -19,7 +19,8 @@ header-y += processor-flags.h
 header-y += ptrace-abi.h
 header-y += sigcontext32.h
 header-y += ucontext.h
-header-y += unistd_32.h
-header-y += unistd_64.h
 header-y += vm86.h
 header-y += vsyscall.h
+
+genhdr-y += unistd_32.h
+genhdr-y += unistd_64.h
diff --git a/arch/x86/include/asm/ia32_unistd.h b/arch/x86/include/asm/ia32_unistd.h
index 976f6ec..b0d5716 100644
--- a/arch/x86/include/asm/ia32_unistd.h
+++ b/arch/x86/include/asm/ia32_unistd.h
@@ -2,17 +2,10 @@
 #define _ASM_X86_IA32_UNISTD_H
 
 /*
- * This file contains the system call numbers of the ia32 port,
+ * This file contains the system call numbers of the ia32 compat ABI,
  * this is for the kernel only.
- * Only add syscalls here where some part of the kernel needs to know
- * the number. This should be otherwise in sync with asm-x86/unistd_32.h. -AK
  */
-
-#define __NR_ia32_restart_syscall 0
-#define __NR_ia32_exit		  1
-#define __NR_ia32_read		  3
-#define __NR_ia32_write		  4
-#define __NR_ia32_sigreturn	119
-#define __NR_ia32_rt_sigreturn	173
+#define __SYSCALL_ia32_NR(x) (x)
+#include <asm/unistd_32_ia32.h>
 
 #endif /* _ASM_X86_IA32_UNISTD_H */
diff --git a/arch/x86/include/asm/unistd.h b/arch/x86/include/asm/unistd.h
index 2a58ed3..b4a3db7 100644
--- a/arch/x86/include/asm/unistd.h
+++ b/arch/x86/include/asm/unistd.h
@@ -1,13 +1,59 @@
+#ifndef _ASM_X86_UNISTD_H
+#define _ASM_X86_UNISTD_H 1
+
 #ifdef __KERNEL__
 # ifdef CONFIG_X86_32
-#  include "unistd_32.h"
+
+#  include <asm/unistd_32.h>
+#  define __ARCH_WANT_IPC_PARSE_VERSION
+#  define __ARCH_WANT_STAT64
+#  define __ARCH_WANT_SYS_OLD_MMAP
+#  define __ARCH_WANT_SYS_OLD_SELECT
+
 # else
-#  include "unistd_64.h"
+
+#  include <asm/unistd_64.h>
+#  define __ARCH_WANT_COMPAT_SYS_TIME
+
 # endif
+
+# define __ARCH_WANT_OLD_READDIR
+# define __ARCH_WANT_OLD_STAT
+# define __ARCH_WANT_SYS_ALARM
+# define __ARCH_WANT_SYS_FADVISE64
+# define __ARCH_WANT_SYS_GETHOSTNAME
+# define __ARCH_WANT_SYS_GETPGRP
+# define __ARCH_WANT_SYS_LLSEEK
+# define __ARCH_WANT_SYS_NICE
+# define __ARCH_WANT_SYS_OLDUMOUNT
+# define __ARCH_WANT_SYS_OLD_GETRLIMIT
+# define __ARCH_WANT_SYS_OLD_UNAME
+# define __ARCH_WANT_SYS_PAUSE
+# define __ARCH_WANT_SYS_RT_SIGACTION
+# define __ARCH_WANT_SYS_RT_SIGSUSPEND
+# define __ARCH_WANT_SYS_SGETMASK
+# define __ARCH_WANT_SYS_SIGNAL
+# define __ARCH_WANT_SYS_SIGPENDING
+# define __ARCH_WANT_SYS_SIGPROCMASK
+# define __ARCH_WANT_SYS_SOCKETCALL
+# define __ARCH_WANT_SYS_TIME
+# define __ARCH_WANT_SYS_UTIME
+# define __ARCH_WANT_SYS_WAITPID
+
+/*
+ * "Conditional" syscalls
+ *
+ * What we want is __attribute__((weak,alias("sys_ni_syscall"))),
+ * but it doesn't work on all toolchains, so we just do it by hand
+ */
+# define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")
+
 #else
 # ifdef __i386__
-#  include "unistd_32.h"
+#  include <asm/unistd_32.h>
 # else
-#  include "unistd_64.h"
+#  include <asm/unistd_64.h>
 # endif
 #endif
+
+#endif /* _ASM_X86_UNISTD_H */
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
deleted file mode 100644
index 599c77d..0000000
--- a/arch/x86/include/asm/unistd_32.h
+++ /dev/null
@@ -1,401 +0,0 @@
-#ifndef _ASM_X86_UNISTD_32_H
-#define _ASM_X86_UNISTD_32_H
-
-/*
- * This file contains the system call numbers.
- */
-
-#define __NR_restart_syscall      0
-#define __NR_exit		  1
-#define __NR_fork		  2
-#define __NR_read		  3
-#define __NR_write		  4
-#define __NR_open		  5
-#define __NR_close		  6
-#define __NR_waitpid		  7
-#define __NR_creat		  8
-#define __NR_link		  9
-#define __NR_unlink		 10
-#define __NR_execve		 11
-#define __NR_chdir		 12
-#define __NR_time		 13
-#define __NR_mknod		 14
-#define __NR_chmod		 15
-#define __NR_lchown		 16
-#define __NR_break		 17
-#define __NR_oldstat		 18
-#define __NR_lseek		 19
-#define __NR_getpid		 20
-#define __NR_mount		 21
-#define __NR_umount		 22
-#define __NR_setuid		 23
-#define __NR_getuid		 24
-#define __NR_stime		 25
-#define __NR_ptrace		 26
-#define __NR_alarm		 27
-#define __NR_oldfstat		 28
-#define __NR_pause		 29
-#define __NR_utime		 30
-#define __NR_stty		 31
-#define __NR_gtty		 32
-#define __NR_access		 33
-#define __NR_nice		 34
-#define __NR_ftime		 35
-#define __NR_sync		 36
-#define __NR_kill		 37
-#define __NR_rename		 38
-#define __NR_mkdir		 39
-#define __NR_rmdir		 40
-#define __NR_dup		 41
-#define __NR_pipe		 42
-#define __NR_times		 43
-#define __NR_prof		 44
-#define __NR_brk		 45
-#define __NR_setgid		 46
-#define __NR_getgid		 47
-#define __NR_signal		 48
-#define __NR_geteuid		 49
-#define __NR_getegid		 50
-#define __NR_acct		 51
-#define __NR_umount2		 52
-#define __NR_lock		 53
-#define __NR_ioctl		 54
-#define __NR_fcntl		 55
-#define __NR_mpx		 56
-#define __NR_setpgid		 57
-#define __NR_ulimit		 58
-#define __NR_oldolduname	 59
-#define __NR_umask		 60
-#define __NR_chroot		 61
-#define __NR_ustat		 62
-#define __NR_dup2		 63
-#define __NR_getppid		 64
-#define __NR_getpgrp		 65
-#define __NR_setsid		 66
-#define __NR_sigaction		 67
-#define __NR_sgetmask		 68
-#define __NR_ssetmask		 69
-#define __NR_setreuid		 70
-#define __NR_setregid		 71
-#define __NR_sigsuspend		 72
-#define __NR_sigpending		 73
-#define __NR_sethostname	 74
-#define __NR_setrlimit		 75
-#define __NR_getrlimit		 76   /* Back compatible 2Gig limited rlimit */
-#define __NR_getrusage		 77
-#define __NR_gettimeofday	 78
-#define __NR_settimeofday	 79
-#define __NR_getgroups		 80
-#define __NR_setgroups		 81
-#define __NR_select		 82
-#define __NR_symlink		 83
-#define __NR_oldlstat		 84
-#define __NR_readlink		 85
-#define __NR_uselib		 86
-#define __NR_swapon		 87
-#define __NR_reboot		 88
-#define __NR_readdir		 89
-#define __NR_mmap		 90
-#define __NR_munmap		 91
-#define __NR_truncate		 92
-#define __NR_ftruncate		 93
-#define __NR_fchmod		 94
-#define __NR_fchown		 95
-#define __NR_getpriority	 96
-#define __NR_setpriority	 97
-#define __NR_profil		 98
-#define __NR_statfs		 99
-#define __NR_fstatfs		100
-#define __NR_ioperm		101
-#define __NR_socketcall		102
-#define __NR_syslog		103
-#define __NR_setitimer		104
-#define __NR_getitimer		105
-#define __NR_stat		106
-#define __NR_lstat		107
-#define __NR_fstat		108
-#define __NR_olduname		109
-#define __NR_iopl		110
-#define __NR_vhangup		111
-#define __NR_idle		112
-#define __NR_vm86old		113
-#define __NR_wait4		114
-#define __NR_swapoff		115
-#define __NR_sysinfo		116
-#define __NR_ipc		117
-#define __NR_fsync		118
-#define __NR_sigreturn		119
-#define __NR_clone		120
-#define __NR_setdomainname	121
-#define __NR_uname		122
-#define __NR_modify_ldt		123
-#define __NR_adjtimex		124
-#define __NR_mprotect		125
-#define __NR_sigprocmask	126
-#define __NR_create_module	127
-#define __NR_init_module	128
-#define __NR_delete_module	129
-#define __NR_get_kernel_syms	130
-#define __NR_quotactl		131
-#define __NR_getpgid		132
-#define __NR_fchdir		133
-#define __NR_bdflush		134
-#define __NR_sysfs		135
-#define __NR_personality	136
-#define __NR_afs_syscall	137 /* Syscall for Andrew File System */
-#define __NR_setfsuid		138
-#define __NR_setfsgid		139
-#define __NR__llseek		140
-#define __NR_getdents		141
-#define __NR__newselect		142
-#define __NR_flock		143
-#define __NR_msync		144
-#define __NR_readv		145
-#define __NR_writev		146
-#define __NR_getsid		147
-#define __NR_fdatasync		148
-#define __NR__sysctl		149
-#define __NR_mlock		150
-#define __NR_munlock		151
-#define __NR_mlockall		152
-#define __NR_munlockall		153
-#define __NR_sched_setparam		154
-#define __NR_sched_getparam		155
-#define __NR_sched_setscheduler		156
-#define __NR_sched_getscheduler		157
-#define __NR_sched_yield		158
-#define __NR_sched_get_priority_max	159
-#define __NR_sched_get_priority_min	160
-#define __NR_sched_rr_get_interval	161
-#define __NR_nanosleep		162
-#define __NR_mremap		163
-#define __NR_setresuid		164
-#define __NR_getresuid		165
-#define __NR_vm86		166
-#define __NR_query_module	167
-#define __NR_poll		168
-#define __NR_nfsservctl		169
-#define __NR_setresgid		170
-#define __NR_getresgid		171
-#define __NR_prctl              172
-#define __NR_rt_sigreturn	173
-#define __NR_rt_sigaction	174
-#define __NR_rt_sigprocmask	175
-#define __NR_rt_sigpending	176
-#define __NR_rt_sigtimedwait	177
-#define __NR_rt_sigqueueinfo	178
-#define __NR_rt_sigsuspend	179
-#define __NR_pread64		180
-#define __NR_pwrite64		181
-#define __NR_chown		182
-#define __NR_getcwd		183
-#define __NR_capget		184
-#define __NR_capset		185
-#define __NR_sigaltstack	186
-#define __NR_sendfile		187
-#define __NR_getpmsg		188	/* some people actually want streams */
-#define __NR_putpmsg		189	/* some people actually want streams */
-#define __NR_vfork		190
-#define __NR_ugetrlimit		191	/* SuS compliant getrlimit */
-#define __NR_mmap2		192
-#define __NR_truncate64		193
-#define __NR_ftruncate64	194
-#define __NR_stat64		195
-#define __NR_lstat64		196
-#define __NR_fstat64		197
-#define __NR_lchown32		198
-#define __NR_getuid32		199
-#define __NR_getgid32		200
-#define __NR_geteuid32		201
-#define __NR_getegid32		202
-#define __NR_setreuid32		203
-#define __NR_setregid32		204
-#define __NR_getgroups32	205
-#define __NR_setgroups32	206
-#define __NR_fchown32		207
-#define __NR_setresuid32	208
-#define __NR_getresuid32	209
-#define __NR_setresgid32	210
-#define __NR_getresgid32	211
-#define __NR_chown32		212
-#define __NR_setuid32		213
-#define __NR_setgid32		214
-#define __NR_setfsuid32		215
-#define __NR_setfsgid32		216
-#define __NR_pivot_root		217
-#define __NR_mincore		218
-#define __NR_madvise		219
-#define __NR_madvise1		219	/* delete when C lib stub is removed */
-#define __NR_getdents64		220
-#define __NR_fcntl64		221
-/* 223 is unused */
-#define __NR_gettid		224
-#define __NR_readahead		225
-#define __NR_setxattr		226
-#define __NR_lsetxattr		227
-#define __NR_fsetxattr		228
-#define __NR_getxattr		229
-#define __NR_lgetxattr		230
-#define __NR_fgetxattr		231
-#define __NR_listxattr		232
-#define __NR_llistxattr		233
-#define __NR_flistxattr		234
-#define __NR_removexattr	235
-#define __NR_lremovexattr	236
-#define __NR_fremovexattr	237
-#define __NR_tkill		238
-#define __NR_sendfile64		239
-#define __NR_futex		240
-#define __NR_sched_setaffinity	241
-#define __NR_sched_getaffinity	242
-#define __NR_set_thread_area	243
-#define __NR_get_thread_area	244
-#define __NR_io_setup		245
-#define __NR_io_destroy		246
-#define __NR_io_getevents	247
-#define __NR_io_submit		248
-#define __NR_io_cancel		249
-#define __NR_fadvise64		250
-/* 251 is available for reuse (was briefly sys_set_zone_reclaim) */
-#define __NR_exit_group		252
-#define __NR_lookup_dcookie	253
-#define __NR_epoll_create	254
-#define __NR_epoll_ctl		255
-#define __NR_epoll_wait		256
-#define __NR_remap_file_pages	257
-#define __NR_set_tid_address	258
-#define __NR_timer_create	259
-#define __NR_timer_settime	(__NR_timer_create+1)
-#define __NR_timer_gettime	(__NR_timer_create+2)
-#define __NR_timer_getoverrun	(__NR_timer_create+3)
-#define __NR_timer_delete	(__NR_timer_create+4)
-#define __NR_clock_settime	(__NR_timer_create+5)
-#define __NR_clock_gettime	(__NR_timer_create+6)
-#define __NR_clock_getres	(__NR_timer_create+7)
-#define __NR_clock_nanosleep	(__NR_timer_create+8)
-#define __NR_statfs64		268
-#define __NR_fstatfs64		269
-#define __NR_tgkill		270
-#define __NR_utimes		271
-#define __NR_fadvise64_64	272
-#define __NR_vserver		273
-#define __NR_mbind		274
-#define __NR_get_mempolicy	275
-#define __NR_set_mempolicy	276
-#define __NR_mq_open 		277
-#define __NR_mq_unlink		(__NR_mq_open+1)
-#define __NR_mq_timedsend	(__NR_mq_open+2)
-#define __NR_mq_timedreceive	(__NR_mq_open+3)
-#define __NR_mq_notify		(__NR_mq_open+4)
-#define __NR_mq_getsetattr	(__NR_mq_open+5)
-#define __NR_kexec_load		283
-#define __NR_waitid		284
-/* #define __NR_sys_setaltroot	285 */
-#define __NR_add_key		286
-#define __NR_request_key	287
-#define __NR_keyctl		288
-#define __NR_ioprio_set		289
-#define __NR_ioprio_get		290
-#define __NR_inotify_init	291
-#define __NR_inotify_add_watch	292
-#define __NR_inotify_rm_watch	293
-#define __NR_migrate_pages	294
-#define __NR_openat		295
-#define __NR_mkdirat		296
-#define __NR_mknodat		297
-#define __NR_fchownat		298
-#define __NR_futimesat		299
-#define __NR_fstatat64		300
-#define __NR_unlinkat		301
-#define __NR_renameat		302
-#define __NR_linkat		303
-#define __NR_symlinkat		304
-#define __NR_readlinkat		305
-#define __NR_fchmodat		306
-#define __NR_faccessat		307
-#define __NR_pselect6		308
-#define __NR_ppoll		309
-#define __NR_unshare		310
-#define __NR_set_robust_list	311
-#define __NR_get_robust_list	312
-#define __NR_splice		313
-#define __NR_sync_file_range	314
-#define __NR_tee		315
-#define __NR_vmsplice		316
-#define __NR_move_pages		317
-#define __NR_getcpu		318
-#define __NR_epoll_pwait	319
-#define __NR_utimensat		320
-#define __NR_signalfd		321
-#define __NR_timerfd_create	322
-#define __NR_eventfd		323
-#define __NR_fallocate		324
-#define __NR_timerfd_settime	325
-#define __NR_timerfd_gettime	326
-#define __NR_signalfd4		327
-#define __NR_eventfd2		328
-#define __NR_epoll_create1	329
-#define __NR_dup3		330
-#define __NR_pipe2		331
-#define __NR_inotify_init1	332
-#define __NR_preadv		333
-#define __NR_pwritev		334
-#define __NR_rt_tgsigqueueinfo	335
-#define __NR_perf_event_open	336
-#define __NR_recvmmsg		337
-#define __NR_fanotify_init	338
-#define __NR_fanotify_mark	339
-#define __NR_prlimit64		340
-#define __NR_name_to_handle_at	341
-#define __NR_open_by_handle_at  342
-#define __NR_clock_adjtime	343
-#define __NR_syncfs             344
-#define __NR_sendmmsg		345
-#define __NR_setns		346
-#define __NR_process_vm_readv	347
-#define __NR_process_vm_writev	348
-
-#ifdef __KERNEL__
-
-#define NR_syscalls 349
-
-#define __ARCH_WANT_IPC_PARSE_VERSION
-#define __ARCH_WANT_OLD_READDIR
-#define __ARCH_WANT_OLD_STAT
-#define __ARCH_WANT_STAT64
-#define __ARCH_WANT_SYS_ALARM
-#define __ARCH_WANT_SYS_GETHOSTNAME
-#define __ARCH_WANT_SYS_IPC
-#define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
-#define __ARCH_WANT_SYS_SIGNAL
-#define __ARCH_WANT_SYS_TIME
-#define __ARCH_WANT_SYS_UTIME
-#define __ARCH_WANT_SYS_WAITPID
-#define __ARCH_WANT_SYS_SOCKETCALL
-#define __ARCH_WANT_SYS_FADVISE64
-#define __ARCH_WANT_SYS_GETPGRP
-#define __ARCH_WANT_SYS_LLSEEK
-#define __ARCH_WANT_SYS_NICE
-#define __ARCH_WANT_SYS_OLD_GETRLIMIT
-#define __ARCH_WANT_SYS_OLD_UNAME
-#define __ARCH_WANT_SYS_OLD_MMAP
-#define __ARCH_WANT_SYS_OLD_SELECT
-#define __ARCH_WANT_SYS_OLDUMOUNT
-#define __ARCH_WANT_SYS_SIGPENDING
-#define __ARCH_WANT_SYS_SIGPROCMASK
-#define __ARCH_WANT_SYS_RT_SIGACTION
-#define __ARCH_WANT_SYS_RT_SIGSUSPEND
-
-/*
- * "Conditional" syscalls
- *
- * What we want is __attribute__((weak,alias("sys_ni_syscall"))),
- * but it doesn't work on all toolchains, so we just do it by hand
- */
-#ifndef cond_syscall
-#define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")
-#endif
-
-#endif /* __KERNEL__ */
-#endif /* _ASM_X86_UNISTD_32_H */
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
deleted file mode 100644
index 0431f19..0000000
--- a/arch/x86/include/asm/unistd_64.h
+++ /dev/null
@@ -1,732 +0,0 @@
-#ifndef _ASM_X86_UNISTD_64_H
-#define _ASM_X86_UNISTD_64_H
-
-#ifndef __SYSCALL
-#define __SYSCALL(a, b)
-#endif
-
-/*
- * This file contains the system call numbers.
- *
- * Note: holes are not allowed.
- */
-
-/* at least 8 syscall per cacheline */
-#define __NR_read				0
-__SYSCALL(__NR_read, sys_read)
-#define __NR_write				1
-__SYSCALL(__NR_write, sys_write)
-#define __NR_open				2
-__SYSCALL(__NR_open, sys_open)
-#define __NR_close				3
-__SYSCALL(__NR_close, sys_close)
-#define __NR_stat				4
-__SYSCALL(__NR_stat, sys_newstat)
-#define __NR_fstat				5
-__SYSCALL(__NR_fstat, sys_newfstat)
-#define __NR_lstat				6
-__SYSCALL(__NR_lstat, sys_newlstat)
-#define __NR_poll				7
-__SYSCALL(__NR_poll, sys_poll)
-
-#define __NR_lseek				8
-__SYSCALL(__NR_lseek, sys_lseek)
-#define __NR_mmap				9
-__SYSCALL(__NR_mmap, sys_mmap)
-#define __NR_mprotect				10
-__SYSCALL(__NR_mprotect, sys_mprotect)
-#define __NR_munmap				11
-__SYSCALL(__NR_munmap, sys_munmap)
-#define __NR_brk				12
-__SYSCALL(__NR_brk, sys_brk)
-#define __NR_rt_sigaction			13
-__SYSCALL(__NR_rt_sigaction, sys_rt_sigaction)
-#define __NR_rt_sigprocmask			14
-__SYSCALL(__NR_rt_sigprocmask, sys_rt_sigprocmask)
-#define __NR_rt_sigreturn			15
-__SYSCALL(__NR_rt_sigreturn, stub_rt_sigreturn)
-
-#define __NR_ioctl				16
-__SYSCALL(__NR_ioctl, sys_ioctl)
-#define __NR_pread64				17
-__SYSCALL(__NR_pread64, sys_pread64)
-#define __NR_pwrite64				18
-__SYSCALL(__NR_pwrite64, sys_pwrite64)
-#define __NR_readv				19
-__SYSCALL(__NR_readv, sys_readv)
-#define __NR_writev				20
-__SYSCALL(__NR_writev, sys_writev)
-#define __NR_access				21
-__SYSCALL(__NR_access, sys_access)
-#define __NR_pipe				22
-__SYSCALL(__NR_pipe, sys_pipe)
-#define __NR_select				23
-__SYSCALL(__NR_select, sys_select)
-
-#define __NR_sched_yield			24
-__SYSCALL(__NR_sched_yield, sys_sched_yield)
-#define __NR_mremap				25
-__SYSCALL(__NR_mremap, sys_mremap)
-#define __NR_msync				26
-__SYSCALL(__NR_msync, sys_msync)
-#define __NR_mincore				27
-__SYSCALL(__NR_mincore, sys_mincore)
-#define __NR_madvise				28
-__SYSCALL(__NR_madvise, sys_madvise)
-#define __NR_shmget				29
-__SYSCALL(__NR_shmget, sys_shmget)
-#define __NR_shmat				30
-__SYSCALL(__NR_shmat, sys_shmat)
-#define __NR_shmctl				31
-__SYSCALL(__NR_shmctl, sys_shmctl)
-
-#define __NR_dup				32
-__SYSCALL(__NR_dup, sys_dup)
-#define __NR_dup2				33
-__SYSCALL(__NR_dup2, sys_dup2)
-#define __NR_pause				34
-__SYSCALL(__NR_pause, sys_pause)
-#define __NR_nanosleep				35
-__SYSCALL(__NR_nanosleep, sys_nanosleep)
-#define __NR_getitimer				36
-__SYSCALL(__NR_getitimer, sys_getitimer)
-#define __NR_alarm				37
-__SYSCALL(__NR_alarm, sys_alarm)
-#define __NR_setitimer				38
-__SYSCALL(__NR_setitimer, sys_setitimer)
-#define __NR_getpid				39
-__SYSCALL(__NR_getpid, sys_getpid)
-
-#define __NR_sendfile				40
-__SYSCALL(__NR_sendfile, sys_sendfile64)
-#define __NR_socket				41
-__SYSCALL(__NR_socket, sys_socket)
-#define __NR_connect				42
-__SYSCALL(__NR_connect, sys_connect)
-#define __NR_accept				43
-__SYSCALL(__NR_accept, sys_accept)
-#define __NR_sendto				44
-__SYSCALL(__NR_sendto, sys_sendto)
-#define __NR_recvfrom				45
-__SYSCALL(__NR_recvfrom, sys_recvfrom)
-#define __NR_sendmsg				46
-__SYSCALL(__NR_sendmsg, sys_sendmsg)
-#define __NR_recvmsg				47
-__SYSCALL(__NR_recvmsg, sys_recvmsg)
-
-#define __NR_shutdown				48
-__SYSCALL(__NR_shutdown, sys_shutdown)
-#define __NR_bind				49
-__SYSCALL(__NR_bind, sys_bind)
-#define __NR_listen				50
-__SYSCALL(__NR_listen, sys_listen)
-#define __NR_getsockname			51
-__SYSCALL(__NR_getsockname, sys_getsockname)
-#define __NR_getpeername			52
-__SYSCALL(__NR_getpeername, sys_getpeername)
-#define __NR_socketpair				53
-__SYSCALL(__NR_socketpair, sys_socketpair)
-#define __NR_setsockopt				54
-__SYSCALL(__NR_setsockopt, sys_setsockopt)
-#define __NR_getsockopt				55
-__SYSCALL(__NR_getsockopt, sys_getsockopt)
-
-#define __NR_clone				56
-__SYSCALL(__NR_clone, stub_clone)
-#define __NR_fork				57
-__SYSCALL(__NR_fork, stub_fork)
-#define __NR_vfork				58
-__SYSCALL(__NR_vfork, stub_vfork)
-#define __NR_execve				59
-__SYSCALL(__NR_execve, stub_execve)
-#define __NR_exit				60
-__SYSCALL(__NR_exit, sys_exit)
-#define __NR_wait4				61
-__SYSCALL(__NR_wait4, sys_wait4)
-#define __NR_kill				62
-__SYSCALL(__NR_kill, sys_kill)
-#define __NR_uname				63
-__SYSCALL(__NR_uname, sys_newuname)
-
-#define __NR_semget				64
-__SYSCALL(__NR_semget, sys_semget)
-#define __NR_semop				65
-__SYSCALL(__NR_semop, sys_semop)
-#define __NR_semctl				66
-__SYSCALL(__NR_semctl, sys_semctl)
-#define __NR_shmdt				67
-__SYSCALL(__NR_shmdt, sys_shmdt)
-#define __NR_msgget				68
-__SYSCALL(__NR_msgget, sys_msgget)
-#define __NR_msgsnd				69
-__SYSCALL(__NR_msgsnd, sys_msgsnd)
-#define __NR_msgrcv				70
-__SYSCALL(__NR_msgrcv, sys_msgrcv)
-#define __NR_msgctl				71
-__SYSCALL(__NR_msgctl, sys_msgctl)
-
-#define __NR_fcntl				72
-__SYSCALL(__NR_fcntl, sys_fcntl)
-#define __NR_flock				73
-__SYSCALL(__NR_flock, sys_flock)
-#define __NR_fsync				74
-__SYSCALL(__NR_fsync, sys_fsync)
-#define __NR_fdatasync				75
-__SYSCALL(__NR_fdatasync, sys_fdatasync)
-#define __NR_truncate				76
-__SYSCALL(__NR_truncate, sys_truncate)
-#define __NR_ftruncate				77
-__SYSCALL(__NR_ftruncate, sys_ftruncate)
-#define __NR_getdents				78
-__SYSCALL(__NR_getdents, sys_getdents)
-#define __NR_getcwd				79
-__SYSCALL(__NR_getcwd, sys_getcwd)
-
-#define __NR_chdir				80
-__SYSCALL(__NR_chdir, sys_chdir)
-#define __NR_fchdir				81
-__SYSCALL(__NR_fchdir, sys_fchdir)
-#define __NR_rename				82
-__SYSCALL(__NR_rename, sys_rename)
-#define __NR_mkdir				83
-__SYSCALL(__NR_mkdir, sys_mkdir)
-#define __NR_rmdir				84
-__SYSCALL(__NR_rmdir, sys_rmdir)
-#define __NR_creat				85
-__SYSCALL(__NR_creat, sys_creat)
-#define __NR_link				86
-__SYSCALL(__NR_link, sys_link)
-#define __NR_unlink				87
-__SYSCALL(__NR_unlink, sys_unlink)
-
-#define __NR_symlink				88
-__SYSCALL(__NR_symlink, sys_symlink)
-#define __NR_readlink				89
-__SYSCALL(__NR_readlink, sys_readlink)
-#define __NR_chmod				90
-__SYSCALL(__NR_chmod, sys_chmod)
-#define __NR_fchmod				91
-__SYSCALL(__NR_fchmod, sys_fchmod)
-#define __NR_chown				92
-__SYSCALL(__NR_chown, sys_chown)
-#define __NR_fchown				93
-__SYSCALL(__NR_fchown, sys_fchown)
-#define __NR_lchown				94
-__SYSCALL(__NR_lchown, sys_lchown)
-#define __NR_umask				95
-__SYSCALL(__NR_umask, sys_umask)
-
-#define __NR_gettimeofday			96
-__SYSCALL(__NR_gettimeofday, sys_gettimeofday)
-#define __NR_getrlimit				97
-__SYSCALL(__NR_getrlimit, sys_getrlimit)
-#define __NR_getrusage				98
-__SYSCALL(__NR_getrusage, sys_getrusage)
-#define __NR_sysinfo				99
-__SYSCALL(__NR_sysinfo, sys_sysinfo)
-#define __NR_times				100
-__SYSCALL(__NR_times, sys_times)
-#define __NR_ptrace				101
-__SYSCALL(__NR_ptrace, sys_ptrace)
-#define __NR_getuid				102
-__SYSCALL(__NR_getuid, sys_getuid)
-#define __NR_syslog				103
-__SYSCALL(__NR_syslog, sys_syslog)
-
-/* at the very end the stuff that never runs during the benchmarks */
-#define __NR_getgid				104
-__SYSCALL(__NR_getgid, sys_getgid)
-#define __NR_setuid				105
-__SYSCALL(__NR_setuid, sys_setuid)
-#define __NR_setgid				106
-__SYSCALL(__NR_setgid, sys_setgid)
-#define __NR_geteuid				107
-__SYSCALL(__NR_geteuid, sys_geteuid)
-#define __NR_getegid				108
-__SYSCALL(__NR_getegid, sys_getegid)
-#define __NR_setpgid				109
-__SYSCALL(__NR_setpgid, sys_setpgid)
-#define __NR_getppid				110
-__SYSCALL(__NR_getppid, sys_getppid)
-#define __NR_getpgrp				111
-__SYSCALL(__NR_getpgrp, sys_getpgrp)
-
-#define __NR_setsid				112
-__SYSCALL(__NR_setsid, sys_setsid)
-#define __NR_setreuid				113
-__SYSCALL(__NR_setreuid, sys_setreuid)
-#define __NR_setregid				114
-__SYSCALL(__NR_setregid, sys_setregid)
-#define __NR_getgroups				115
-__SYSCALL(__NR_getgroups, sys_getgroups)
-#define __NR_setgroups				116
-__SYSCALL(__NR_setgroups, sys_setgroups)
-#define __NR_setresuid				117
-__SYSCALL(__NR_setresuid, sys_setresuid)
-#define __NR_getresuid				118
-__SYSCALL(__NR_getresuid, sys_getresuid)
-#define __NR_setresgid				119
-__SYSCALL(__NR_setresgid, sys_setresgid)
-
-#define __NR_getresgid				120
-__SYSCALL(__NR_getresgid, sys_getresgid)
-#define __NR_getpgid				121
-__SYSCALL(__NR_getpgid, sys_getpgid)
-#define __NR_setfsuid				122
-__SYSCALL(__NR_setfsuid, sys_setfsuid)
-#define __NR_setfsgid				123
-__SYSCALL(__NR_setfsgid, sys_setfsgid)
-#define __NR_getsid				124
-__SYSCALL(__NR_getsid, sys_getsid)
-#define __NR_capget				125
-__SYSCALL(__NR_capget, sys_capget)
-#define __NR_capset				126
-__SYSCALL(__NR_capset, sys_capset)
-
-#define __NR_rt_sigpending			127
-__SYSCALL(__NR_rt_sigpending, sys_rt_sigpending)
-#define __NR_rt_sigtimedwait			128
-__SYSCALL(__NR_rt_sigtimedwait, sys_rt_sigtimedwait)
-#define __NR_rt_sigqueueinfo			129
-__SYSCALL(__NR_rt_sigqueueinfo, sys_rt_sigqueueinfo)
-#define __NR_rt_sigsuspend			130
-__SYSCALL(__NR_rt_sigsuspend, sys_rt_sigsuspend)
-#define __NR_sigaltstack			131
-__SYSCALL(__NR_sigaltstack, stub_sigaltstack)
-#define __NR_utime				132
-__SYSCALL(__NR_utime, sys_utime)
-#define __NR_mknod				133
-__SYSCALL(__NR_mknod, sys_mknod)
-
-/* Only needed for a.out */
-#define __NR_uselib				134
-__SYSCALL(__NR_uselib, sys_ni_syscall)
-#define __NR_personality			135
-__SYSCALL(__NR_personality, sys_personality)
-
-#define __NR_ustat				136
-__SYSCALL(__NR_ustat, sys_ustat)
-#define __NR_statfs				137
-__SYSCALL(__NR_statfs, sys_statfs)
-#define __NR_fstatfs				138
-__SYSCALL(__NR_fstatfs, sys_fstatfs)
-#define __NR_sysfs				139
-__SYSCALL(__NR_sysfs, sys_sysfs)
-
-#define __NR_getpriority			140
-__SYSCALL(__NR_getpriority, sys_getpriority)
-#define __NR_setpriority			141
-__SYSCALL(__NR_setpriority, sys_setpriority)
-#define __NR_sched_setparam			142
-__SYSCALL(__NR_sched_setparam, sys_sched_setparam)
-#define __NR_sched_getparam			143
-__SYSCALL(__NR_sched_getparam, sys_sched_getparam)
-#define __NR_sched_setscheduler			144
-__SYSCALL(__NR_sched_setscheduler, sys_sched_setscheduler)
-#define __NR_sched_getscheduler			145
-__SYSCALL(__NR_sched_getscheduler, sys_sched_getscheduler)
-#define __NR_sched_get_priority_max		146
-__SYSCALL(__NR_sched_get_priority_max, sys_sched_get_priority_max)
-#define __NR_sched_get_priority_min		147
-__SYSCALL(__NR_sched_get_priority_min, sys_sched_get_priority_min)
-#define __NR_sched_rr_get_interval		148
-__SYSCALL(__NR_sched_rr_get_interval, sys_sched_rr_get_interval)
-
-#define __NR_mlock				149
-__SYSCALL(__NR_mlock, sys_mlock)
-#define __NR_munlock				150
-__SYSCALL(__NR_munlock, sys_munlock)
-#define __NR_mlockall				151
-__SYSCALL(__NR_mlockall, sys_mlockall)
-#define __NR_munlockall				152
-__SYSCALL(__NR_munlockall, sys_munlockall)
-
-#define __NR_vhangup				153
-__SYSCALL(__NR_vhangup, sys_vhangup)
-
-#define __NR_modify_ldt				154
-__SYSCALL(__NR_modify_ldt, sys_modify_ldt)
-
-#define __NR_pivot_root				155
-__SYSCALL(__NR_pivot_root, sys_pivot_root)
-
-#define __NR__sysctl				156
-__SYSCALL(__NR__sysctl, sys_sysctl)
-
-#define __NR_prctl				157
-__SYSCALL(__NR_prctl, sys_prctl)
-#define __NR_arch_prctl				158
-__SYSCALL(__NR_arch_prctl, sys_arch_prctl)
-
-#define __NR_adjtimex				159
-__SYSCALL(__NR_adjtimex, sys_adjtimex)
-
-#define __NR_setrlimit				160
-__SYSCALL(__NR_setrlimit, sys_setrlimit)
-
-#define __NR_chroot				161
-__SYSCALL(__NR_chroot, sys_chroot)
-
-#define __NR_sync				162
-__SYSCALL(__NR_sync, sys_sync)
-
-#define __NR_acct				163
-__SYSCALL(__NR_acct, sys_acct)
-
-#define __NR_settimeofday			164
-__SYSCALL(__NR_settimeofday, sys_settimeofday)
-
-#define __NR_mount				165
-__SYSCALL(__NR_mount, sys_mount)
-#define __NR_umount2				166
-__SYSCALL(__NR_umount2, sys_umount)
-
-#define __NR_swapon				167
-__SYSCALL(__NR_swapon, sys_swapon)
-#define __NR_swapoff				168
-__SYSCALL(__NR_swapoff, sys_swapoff)
-
-#define __NR_reboot				169
-__SYSCALL(__NR_reboot, sys_reboot)
-
-#define __NR_sethostname			170
-__SYSCALL(__NR_sethostname, sys_sethostname)
-#define __NR_setdomainname			171
-__SYSCALL(__NR_setdomainname, sys_setdomainname)
-
-#define __NR_iopl				172
-__SYSCALL(__NR_iopl, stub_iopl)
-#define __NR_ioperm				173
-__SYSCALL(__NR_ioperm, sys_ioperm)
-
-#define __NR_create_module			174
-__SYSCALL(__NR_create_module, sys_ni_syscall)
-#define __NR_init_module			175
-__SYSCALL(__NR_init_module, sys_init_module)
-#define __NR_delete_module			176
-__SYSCALL(__NR_delete_module, sys_delete_module)
-#define __NR_get_kernel_syms			177
-__SYSCALL(__NR_get_kernel_syms, sys_ni_syscall)
-#define __NR_query_module			178
-__SYSCALL(__NR_query_module, sys_ni_syscall)
-
-#define __NR_quotactl				179
-__SYSCALL(__NR_quotactl, sys_quotactl)
-
-#define __NR_nfsservctl				180
-__SYSCALL(__NR_nfsservctl, sys_ni_syscall)
-
-/* reserved for LiS/STREAMS */
-#define __NR_getpmsg				181
-__SYSCALL(__NR_getpmsg, sys_ni_syscall)
-#define __NR_putpmsg				182
-__SYSCALL(__NR_putpmsg, sys_ni_syscall)
-
-/* reserved for AFS */
-#define __NR_afs_syscall			183
-__SYSCALL(__NR_afs_syscall, sys_ni_syscall)
-
-/* reserved for tux */
-#define __NR_tuxcall				184
-__SYSCALL(__NR_tuxcall, sys_ni_syscall)
-
-#define __NR_security				185
-__SYSCALL(__NR_security, sys_ni_syscall)
-
-#define __NR_gettid				186
-__SYSCALL(__NR_gettid, sys_gettid)
-
-#define __NR_readahead				187
-__SYSCALL(__NR_readahead, sys_readahead)
-#define __NR_setxattr				188
-__SYSCALL(__NR_setxattr, sys_setxattr)
-#define __NR_lsetxattr				189
-__SYSCALL(__NR_lsetxattr, sys_lsetxattr)
-#define __NR_fsetxattr				190
-__SYSCALL(__NR_fsetxattr, sys_fsetxattr)
-#define __NR_getxattr				191
-__SYSCALL(__NR_getxattr, sys_getxattr)
-#define __NR_lgetxattr				192
-__SYSCALL(__NR_lgetxattr, sys_lgetxattr)
-#define __NR_fgetxattr				193
-__SYSCALL(__NR_fgetxattr, sys_fgetxattr)
-#define __NR_listxattr				194
-__SYSCALL(__NR_listxattr, sys_listxattr)
-#define __NR_llistxattr				195
-__SYSCALL(__NR_llistxattr, sys_llistxattr)
-#define __NR_flistxattr				196
-__SYSCALL(__NR_flistxattr, sys_flistxattr)
-#define __NR_removexattr			197
-__SYSCALL(__NR_removexattr, sys_removexattr)
-#define __NR_lremovexattr			198
-__SYSCALL(__NR_lremovexattr, sys_lremovexattr)
-#define __NR_fremovexattr			199
-__SYSCALL(__NR_fremovexattr, sys_fremovexattr)
-#define __NR_tkill				200
-__SYSCALL(__NR_tkill, sys_tkill)
-#define __NR_time				201
-__SYSCALL(__NR_time, sys_time)
-#define __NR_futex				202
-__SYSCALL(__NR_futex, sys_futex)
-#define __NR_sched_setaffinity			203
-__SYSCALL(__NR_sched_setaffinity, sys_sched_setaffinity)
-#define __NR_sched_getaffinity			204
-__SYSCALL(__NR_sched_getaffinity, sys_sched_getaffinity)
-#define __NR_set_thread_area			205
-__SYSCALL(__NR_set_thread_area, sys_ni_syscall)	/* use arch_prctl */
-#define __NR_io_setup				206
-__SYSCALL(__NR_io_setup, sys_io_setup)
-#define __NR_io_destroy				207
-__SYSCALL(__NR_io_destroy, sys_io_destroy)
-#define __NR_io_getevents			208
-__SYSCALL(__NR_io_getevents, sys_io_getevents)
-#define __NR_io_submit				209
-__SYSCALL(__NR_io_submit, sys_io_submit)
-#define __NR_io_cancel				210
-__SYSCALL(__NR_io_cancel, sys_io_cancel)
-#define __NR_get_thread_area			211
-__SYSCALL(__NR_get_thread_area, sys_ni_syscall)	/* use arch_prctl */
-#define __NR_lookup_dcookie			212
-__SYSCALL(__NR_lookup_dcookie, sys_lookup_dcookie)
-#define __NR_epoll_create			213
-__SYSCALL(__NR_epoll_create, sys_epoll_create)
-#define __NR_epoll_ctl_old			214
-__SYSCALL(__NR_epoll_ctl_old, sys_ni_syscall)
-#define __NR_epoll_wait_old			215
-__SYSCALL(__NR_epoll_wait_old, sys_ni_syscall)
-#define __NR_remap_file_pages			216
-__SYSCALL(__NR_remap_file_pages, sys_remap_file_pages)
-#define __NR_getdents64				217
-__SYSCALL(__NR_getdents64, sys_getdents64)
-#define __NR_set_tid_address			218
-__SYSCALL(__NR_set_tid_address, sys_set_tid_address)
-#define __NR_restart_syscall			219
-__SYSCALL(__NR_restart_syscall, sys_restart_syscall)
-#define __NR_semtimedop				220
-__SYSCALL(__NR_semtimedop, sys_semtimedop)
-#define __NR_fadvise64				221
-__SYSCALL(__NR_fadvise64, sys_fadvise64)
-#define __NR_timer_create			222
-__SYSCALL(__NR_timer_create, sys_timer_create)
-#define __NR_timer_settime			223
-__SYSCALL(__NR_timer_settime, sys_timer_settime)
-#define __NR_timer_gettime			224
-__SYSCALL(__NR_timer_gettime, sys_timer_gettime)
-#define __NR_timer_getoverrun			225
-__SYSCALL(__NR_timer_getoverrun, sys_timer_getoverrun)
-#define __NR_timer_delete			226
-__SYSCALL(__NR_timer_delete, sys_timer_delete)
-#define __NR_clock_settime			227
-__SYSCALL(__NR_clock_settime, sys_clock_settime)
-#define __NR_clock_gettime			228
-__SYSCALL(__NR_clock_gettime, sys_clock_gettime)
-#define __NR_clock_getres			229
-__SYSCALL(__NR_clock_getres, sys_clock_getres)
-#define __NR_clock_nanosleep			230
-__SYSCALL(__NR_clock_nanosleep, sys_clock_nanosleep)
-#define __NR_exit_group				231
-__SYSCALL(__NR_exit_group, sys_exit_group)
-#define __NR_epoll_wait				232
-__SYSCALL(__NR_epoll_wait, sys_epoll_wait)
-#define __NR_epoll_ctl				233
-__SYSCALL(__NR_epoll_ctl, sys_epoll_ctl)
-#define __NR_tgkill				234
-__SYSCALL(__NR_tgkill, sys_tgkill)
-#define __NR_utimes				235
-__SYSCALL(__NR_utimes, sys_utimes)
-#define __NR_vserver				236
-__SYSCALL(__NR_vserver, sys_ni_syscall)
-#define __NR_mbind				237
-__SYSCALL(__NR_mbind, sys_mbind)
-#define __NR_set_mempolicy			238
-__SYSCALL(__NR_set_mempolicy, sys_set_mempolicy)
-#define __NR_get_mempolicy			239
-__SYSCALL(__NR_get_mempolicy, sys_get_mempolicy)
-#define __NR_mq_open				240
-__SYSCALL(__NR_mq_open, sys_mq_open)
-#define __NR_mq_unlink				241
-__SYSCALL(__NR_mq_unlink, sys_mq_unlink)
-#define __NR_mq_timedsend			242
-__SYSCALL(__NR_mq_timedsend, sys_mq_timedsend)
-#define __NR_mq_timedreceive			243
-__SYSCALL(__NR_mq_timedreceive, sys_mq_timedreceive)
-#define __NR_mq_notify				244
-__SYSCALL(__NR_mq_notify, sys_mq_notify)
-#define __NR_mq_getsetattr			245
-__SYSCALL(__NR_mq_getsetattr, sys_mq_getsetattr)
-#define __NR_kexec_load				246
-__SYSCALL(__NR_kexec_load, sys_kexec_load)
-#define __NR_waitid				247
-__SYSCALL(__NR_waitid, sys_waitid)
-#define __NR_add_key				248
-__SYSCALL(__NR_add_key, sys_add_key)
-#define __NR_request_key			249
-__SYSCALL(__NR_request_key, sys_request_key)
-#define __NR_keyctl				250
-__SYSCALL(__NR_keyctl, sys_keyctl)
-#define __NR_ioprio_set				251
-__SYSCALL(__NR_ioprio_set, sys_ioprio_set)
-#define __NR_ioprio_get				252
-__SYSCALL(__NR_ioprio_get, sys_ioprio_get)
-#define __NR_inotify_init			253
-__SYSCALL(__NR_inotify_init, sys_inotify_init)
-#define __NR_inotify_add_watch			254
-__SYSCALL(__NR_inotify_add_watch, sys_inotify_add_watch)
-#define __NR_inotify_rm_watch			255
-__SYSCALL(__NR_inotify_rm_watch, sys_inotify_rm_watch)
-#define __NR_migrate_pages			256
-__SYSCALL(__NR_migrate_pages, sys_migrate_pages)
-#define __NR_openat				257
-__SYSCALL(__NR_openat, sys_openat)
-#define __NR_mkdirat				258
-__SYSCALL(__NR_mkdirat, sys_mkdirat)
-#define __NR_mknodat				259
-__SYSCALL(__NR_mknodat, sys_mknodat)
-#define __NR_fchownat				260
-__SYSCALL(__NR_fchownat, sys_fchownat)
-#define __NR_futimesat				261
-__SYSCALL(__NR_futimesat, sys_futimesat)
-#define __NR_newfstatat				262
-__SYSCALL(__NR_newfstatat, sys_newfstatat)
-#define __NR_unlinkat				263
-__SYSCALL(__NR_unlinkat, sys_unlinkat)
-#define __NR_renameat				264
-__SYSCALL(__NR_renameat, sys_renameat)
-#define __NR_linkat				265
-__SYSCALL(__NR_linkat, sys_linkat)
-#define __NR_symlinkat				266
-__SYSCALL(__NR_symlinkat, sys_symlinkat)
-#define __NR_readlinkat				267
-__SYSCALL(__NR_readlinkat, sys_readlinkat)
-#define __NR_fchmodat				268
-__SYSCALL(__NR_fchmodat, sys_fchmodat)
-#define __NR_faccessat				269
-__SYSCALL(__NR_faccessat, sys_faccessat)
-#define __NR_pselect6				270
-__SYSCALL(__NR_pselect6, sys_pselect6)
-#define __NR_ppoll				271
-__SYSCALL(__NR_ppoll,	sys_ppoll)
-#define __NR_unshare				272
-__SYSCALL(__NR_unshare,	sys_unshare)
-#define __NR_set_robust_list			273
-__SYSCALL(__NR_set_robust_list, sys_set_robust_list)
-#define __NR_get_robust_list			274
-__SYSCALL(__NR_get_robust_list, sys_get_robust_list)
-#define __NR_splice				275
-__SYSCALL(__NR_splice, sys_splice)
-#define __NR_tee				276
-__SYSCALL(__NR_tee, sys_tee)
-#define __NR_sync_file_range			277
-__SYSCALL(__NR_sync_file_range, sys_sync_file_range)
-#define __NR_vmsplice				278
-__SYSCALL(__NR_vmsplice, sys_vmsplice)
-#define __NR_move_pages				279
-__SYSCALL(__NR_move_pages, sys_move_pages)
-#define __NR_utimensat				280
-__SYSCALL(__NR_utimensat, sys_utimensat)
-#define __NR_epoll_pwait			281
-__SYSCALL(__NR_epoll_pwait, sys_epoll_pwait)
-#define __NR_signalfd				282
-__SYSCALL(__NR_signalfd, sys_signalfd)
-#define __NR_timerfd_create			283
-__SYSCALL(__NR_timerfd_create, sys_timerfd_create)
-#define __NR_eventfd				284
-__SYSCALL(__NR_eventfd, sys_eventfd)
-#define __NR_fallocate				285
-__SYSCALL(__NR_fallocate, sys_fallocate)
-#define __NR_timerfd_settime			286
-__SYSCALL(__NR_timerfd_settime, sys_timerfd_settime)
-#define __NR_timerfd_gettime			287
-__SYSCALL(__NR_timerfd_gettime, sys_timerfd_gettime)
-#define __NR_accept4				288
-__SYSCALL(__NR_accept4, sys_accept4)
-#define __NR_signalfd4				289
-__SYSCALL(__NR_signalfd4, sys_signalfd4)
-#define __NR_eventfd2				290
-__SYSCALL(__NR_eventfd2, sys_eventfd2)
-#define __NR_epoll_create1			291
-__SYSCALL(__NR_epoll_create1, sys_epoll_create1)
-#define __NR_dup3				292
-__SYSCALL(__NR_dup3, sys_dup3)
-#define __NR_pipe2				293
-__SYSCALL(__NR_pipe2, sys_pipe2)
-#define __NR_inotify_init1			294
-__SYSCALL(__NR_inotify_init1, sys_inotify_init1)
-#define __NR_preadv				295
-__SYSCALL(__NR_preadv, sys_preadv)
-#define __NR_pwritev				296
-__SYSCALL(__NR_pwritev, sys_pwritev)
-#define __NR_rt_tgsigqueueinfo			297
-__SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
-#define __NR_perf_event_open			298
-__SYSCALL(__NR_perf_event_open, sys_perf_event_open)
-#define __NR_recvmmsg				299
-__SYSCALL(__NR_recvmmsg, sys_recvmmsg)
-#define __NR_fanotify_init			300
-__SYSCALL(__NR_fanotify_init, sys_fanotify_init)
-#define __NR_fanotify_mark			301
-__SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
-#define __NR_prlimit64				302
-__SYSCALL(__NR_prlimit64, sys_prlimit64)
-#define __NR_name_to_handle_at			303
-__SYSCALL(__NR_name_to_handle_at, sys_name_to_handle_at)
-#define __NR_open_by_handle_at			304
-__SYSCALL(__NR_open_by_handle_at, sys_open_by_handle_at)
-#define __NR_clock_adjtime			305
-__SYSCALL(__NR_clock_adjtime, sys_clock_adjtime)
-#define __NR_syncfs                             306
-__SYSCALL(__NR_syncfs, sys_syncfs)
-#define __NR_sendmmsg				307
-__SYSCALL(__NR_sendmmsg, sys_sendmmsg)
-#define __NR_setns				308
-__SYSCALL(__NR_setns, sys_setns)
-#define __NR_getcpu				309
-__SYSCALL(__NR_getcpu, sys_getcpu)
-#define __NR_process_vm_readv			310
-__SYSCALL(__NR_process_vm_readv, sys_process_vm_readv)
-#define __NR_process_vm_writev			311
-__SYSCALL(__NR_process_vm_writev, sys_process_vm_writev)
-
-#ifndef __NO_STUBS
-#define __ARCH_WANT_OLD_READDIR
-#define __ARCH_WANT_OLD_STAT
-#define __ARCH_WANT_SYS_ALARM
-#define __ARCH_WANT_SYS_GETHOSTNAME
-#define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
-#define __ARCH_WANT_SYS_SIGNAL
-#define __ARCH_WANT_SYS_UTIME
-#define __ARCH_WANT_SYS_WAITPID
-#define __ARCH_WANT_SYS_SOCKETCALL
-#define __ARCH_WANT_SYS_FADVISE64
-#define __ARCH_WANT_SYS_GETPGRP
-#define __ARCH_WANT_SYS_LLSEEK
-#define __ARCH_WANT_SYS_NICE
-#define __ARCH_WANT_SYS_OLD_GETRLIMIT
-#define __ARCH_WANT_SYS_OLD_UNAME
-#define __ARCH_WANT_SYS_OLDUMOUNT
-#define __ARCH_WANT_SYS_SIGPENDING
-#define __ARCH_WANT_SYS_SIGPROCMASK
-#define __ARCH_WANT_SYS_RT_SIGACTION
-#define __ARCH_WANT_SYS_RT_SIGSUSPEND
-#define __ARCH_WANT_SYS_TIME
-#define __ARCH_WANT_COMPAT_SYS_TIME
-#endif	/* __NO_STUBS */
-
-#ifdef __KERNEL__
-
-#ifndef COMPILE_OFFSETS
-#include <asm/asm-offsets.h>
-#define NR_syscalls (__NR_syscall_max + 1)
-#endif
-
-/*
- * "Conditional" syscalls
- *
- * What we want is __attribute__((weak,alias("sys_ni_syscall"))),
- * but it doesn't work on all toolchains, so we just do it by hand
- */
-#define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")
-#endif	/* __KERNEL__ */
-
-#endif /* _ASM_X86_UNISTD_64_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 8baca3c..8c473d9 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -25,7 +25,8 @@ obj-$(CONFIG_IRQ_WORK)  += irq_work.o
 obj-y			+= probe_roms.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
-obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
+obj-y			+= syscall_$(BITS).o
+obj-$(CONFIG_X86_64)	+= vsyscall_64.o
 obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index 395a10e..85d98ab 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -3,6 +3,11 @@
 #include <linux/lguest.h>
 #include "../../../drivers/lguest/lg.h"
 
+#define __SYSCALL_I386(nr, sym, compat) [nr] = 1,
+static char syscalls[] = {
+#include <asm/syscalls_32.h>
+};
+
 /* workaround for a warning with -Wmissing-prototypes */
 void foo(void);
 
@@ -76,4 +81,7 @@ void foo(void)
 	OFFSET(LGUEST_PAGES_regs_errcode, lguest_pages, regs.errcode);
 	OFFSET(LGUEST_PAGES_regs, lguest_pages, regs);
 #endif
+	BLANK();
+	DEFINE(__NR_syscall_max, sizeof(syscalls) - 1);
+	DEFINE(NR_syscalls, sizeof(syscalls));
 }
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index e72a119..834e897 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -1,11 +1,12 @@
 #include <asm/ia32.h>
 
-#define __NO_STUBS 1
-#undef __SYSCALL
-#undef _ASM_X86_UNISTD_64_H
-#define __SYSCALL(nr, sym) [nr] = 1,
-static char syscalls[] = {
-#include <asm/unistd.h>
+#define __SYSCALL_64(nr, sym, compat) [nr] = 1,
+static char syscalls_64[] = {
+#include <asm/syscalls_64.h>
+};
+#define __SYSCALL_I386(nr, sym, compat) [nr] = 1,
+static char syscalls_ia32[] = {
+#include <asm/syscalls_32.h>
 };
 
 int main(void)
@@ -72,7 +73,11 @@ int main(void)
 	OFFSET(TSS_ist, tss_struct, x86_tss.ist);
 	BLANK();
 
-	DEFINE(__NR_syscall_max, sizeof(syscalls) - 1);
+	DEFINE(__NR_syscall_max, sizeof(syscalls_64) - 1);
+	DEFINE(NR_syscalls, sizeof(syscalls_64));
+
+	DEFINE(__NR_ia32_syscall_max, sizeof(syscalls_ia32) - 1);
+	DEFINE(IA32_NR_syscalls, sizeof(syscalls_ia32));
 
 	return 0;
 }
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index f3f6f53..1ffcda2 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -81,8 +81,6 @@
  * enough to patch inline, increasing performance.
  */
 
-#define nr_syscalls ((syscall_table_size)/4)
-
 #ifdef CONFIG_PREEMPT
 #define preempt_stop(clobbers)	DISABLE_INTERRUPTS(clobbers); TRACE_IRQS_OFF
 #else
@@ -423,7 +421,7 @@ sysenter_past_esp:
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%ebp)
 	jnz sysenter_audit
 sysenter_do_call:
-	cmpl $(nr_syscalls), %eax
+	cmpl $(NR_syscalls), %eax
 	jae syscall_badsys
 	call *sys_call_table(,%eax,4)
 	movl %eax,PT_EAX(%esp)
@@ -504,7 +502,7 @@ ENTRY(system_call)
 					# system call tracing in operation / emulation
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%ebp)
 	jnz syscall_trace_entry
-	cmpl $(nr_syscalls), %eax
+	cmpl $(NR_syscalls), %eax
 	jae syscall_badsys
 syscall_call:
 	call *sys_call_table(,%eax,4)
@@ -650,7 +648,7 @@ syscall_trace_entry:
 	movl %esp, %eax
 	call syscall_trace_enter
 	/* What it returned is what we'll actually use.  */
-	cmpl $(nr_syscalls), %eax
+	cmpl $(NR_syscalls), %eax
 	jnae syscall_call
 	jmp syscall_exit
 END(syscall_trace_entry)
@@ -690,29 +688,28 @@ END(syscall_badsys)
  * System calls that need a pt_regs pointer.
  */
 #define PTREGSCALL0(name) \
-	ALIGN; \
-ptregs_##name: \
+ENTRY(ptregs_##name) ;  \
 	leal 4(%esp),%eax; \
-	jmp sys_##name;
+	jmp sys_##name; \
+ENDPROC(ptregs_##name)
 
 #define PTREGSCALL1(name) \
-	ALIGN; \
-ptregs_##name: \
+ENTRY(ptregs_##name) ; \
 	leal 4(%esp),%edx; \
 	movl (PT_EBX+4)(%esp),%eax; \
-	jmp sys_##name;
+	jmp sys_##name; \
+ENDPROC(ptregs_##name)
 
 #define PTREGSCALL2(name) \
-	ALIGN; \
-ptregs_##name: \
+ENTRY(ptregs_##name) ; \
 	leal 4(%esp),%ecx; \
 	movl (PT_ECX+4)(%esp),%edx; \
 	movl (PT_EBX+4)(%esp),%eax; \
-	jmp sys_##name;
+	jmp sys_##name; \
+ENDPROC(ptregs_##name)
 
 #define PTREGSCALL3(name) \
-	ALIGN; \
-ptregs_##name: \
+ENTRY(ptregs_##name) ; \
 	CFI_STARTPROC; \
 	leal 4(%esp),%eax; \
 	pushl_cfi %eax; \
@@ -737,8 +734,7 @@ PTREGSCALL2(vm86)
 PTREGSCALL1(vm86old)
 
 /* Clone is an oddball.  The 4th arg is in %edi */
-	ALIGN;
-ptregs_clone:
+ENTRY(ptregs_clone)
 	CFI_STARTPROC
 	leal 4(%esp),%eax
 	pushl_cfi %eax
@@ -1209,11 +1205,6 @@ return_to_handler:
 	jmp *%ecx
 #endif
 
-.section .rodata,"a"
-#include "syscall_table_32.S"
-
-syscall_table_size=(.-sys_call_table)
-
 /*
  * Some functions should be protected against kprobes
  */
diff --git a/arch/x86/kernel/syscall_32.c b/arch/x86/kernel/syscall_32.c
new file mode 100644
index 0000000..b37a573
--- /dev/null
+++ b/arch/x86/kernel/syscall_32.c
@@ -0,0 +1,25 @@
+/* System call table for i386. */
+
+#include <linux/linkage.h>
+#include <linux/sys.h>
+#include <linux/cache.h>
+#include <asm/asm-offsets.h>
+
+#define __SYSCALL_I386(nr, sym, compat) extern asmlinkage void sym(void) ;
+#include <asm/syscalls_32.h>
+#undef __SYSCALL_I386
+
+#define __SYSCALL_I386(nr, sym, compat) [nr] = sym,
+
+typedef asmlinkage void (*sys_call_ptr_t)(void);
+
+extern asmlinkage void sys_ni_syscall(void);
+
+const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
+	/*
+	 * Smells like a like a compiler bug -- it doesn't work
+	 * when the & below is removed.
+	 */
+	[0 ... __NR_syscall_max] = &sys_ni_syscall,
+#include <asm/syscalls_32.h>
+};
diff --git a/arch/x86/kernel/syscall_64.c b/arch/x86/kernel/syscall_64.c
index 0edfafa..7ac7943 100644
--- a/arch/x86/kernel/syscall_64.c
+++ b/arch/x86/kernel/syscall_64.c
@@ -5,15 +5,11 @@
 #include <linux/cache.h>
 #include <asm/asm-offsets.h>
 
-#define __NO_STUBS
+#define __SYSCALL_64(nr, sym, compat) extern asmlinkage void sym(void) ;
+#include <asm/syscalls_64.h>
+#undef __SYSCALL_64
 
-#define __SYSCALL(nr, sym) extern asmlinkage void sym(void) ;
-#undef _ASM_X86_UNISTD_64_H
-#include <asm/unistd_64.h>
-
-#undef __SYSCALL
-#define __SYSCALL(nr, sym) [nr] = sym,
-#undef _ASM_X86_UNISTD_64_H
+#define __SYSCALL_64(nr, sym, compat) [nr] = sym,
 
 typedef void (*sys_call_ptr_t)(void);
 
@@ -25,5 +21,5 @@ const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
 	 * when the & below is removed.
 	 */
 	[0 ... __NR_syscall_max] = &sys_ni_syscall,
-#include <asm/unistd_64.h>
+#include <asm/syscalls_64.h>
 };
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
deleted file mode 100644
index 9a0e312..0000000
--- a/arch/x86/kernel/syscall_table_32.S
+++ /dev/null
@@ -1,350 +0,0 @@
-ENTRY(sys_call_table)
-	.long sys_restart_syscall	/* 0 - old "setup()" system call, used for restarting */
-	.long sys_exit
-	.long ptregs_fork
-	.long sys_read
-	.long sys_write
-	.long sys_open		/* 5 */
-	.long sys_close
-	.long sys_waitpid
-	.long sys_creat
-	.long sys_link
-	.long sys_unlink	/* 10 */
-	.long ptregs_execve
-	.long sys_chdir
-	.long sys_time
-	.long sys_mknod
-	.long sys_chmod		/* 15 */
-	.long sys_lchown16
-	.long sys_ni_syscall	/* old break syscall holder */
-	.long sys_stat
-	.long sys_lseek
-	.long sys_getpid	/* 20 */
-	.long sys_mount
-	.long sys_oldumount
-	.long sys_setuid16
-	.long sys_getuid16
-	.long sys_stime		/* 25 */
-	.long sys_ptrace
-	.long sys_alarm
-	.long sys_fstat
-	.long sys_pause
-	.long sys_utime		/* 30 */
-	.long sys_ni_syscall	/* old stty syscall holder */
-	.long sys_ni_syscall	/* old gtty syscall holder */
-	.long sys_access
-	.long sys_nice
-	.long sys_ni_syscall	/* 35 - old ftime syscall holder */
-	.long sys_sync
-	.long sys_kill
-	.long sys_rename
-	.long sys_mkdir
-	.long sys_rmdir		/* 40 */
-	.long sys_dup
-	.long sys_pipe
-	.long sys_times
-	.long sys_ni_syscall	/* old prof syscall holder */
-	.long sys_brk		/* 45 */
-	.long sys_setgid16
-	.long sys_getgid16
-	.long sys_signal
-	.long sys_geteuid16
-	.long sys_getegid16	/* 50 */
-	.long sys_acct
-	.long sys_umount	/* recycled never used phys() */
-	.long sys_ni_syscall	/* old lock syscall holder */
-	.long sys_ioctl
-	.long sys_fcntl		/* 55 */
-	.long sys_ni_syscall	/* old mpx syscall holder */
-	.long sys_setpgid
-	.long sys_ni_syscall	/* old ulimit syscall holder */
-	.long sys_olduname
-	.long sys_umask		/* 60 */
-	.long sys_chroot
-	.long sys_ustat
-	.long sys_dup2
-	.long sys_getppid
-	.long sys_getpgrp	/* 65 */
-	.long sys_setsid
-	.long sys_sigaction
-	.long sys_sgetmask
-	.long sys_ssetmask
-	.long sys_setreuid16	/* 70 */
-	.long sys_setregid16
-	.long sys_sigsuspend
-	.long sys_sigpending
-	.long sys_sethostname
-	.long sys_setrlimit	/* 75 */
-	.long sys_old_getrlimit
-	.long sys_getrusage
-	.long sys_gettimeofday
-	.long sys_settimeofday
-	.long sys_getgroups16	/* 80 */
-	.long sys_setgroups16
-	.long sys_old_select
-	.long sys_symlink
-	.long sys_lstat
-	.long sys_readlink	/* 85 */
-	.long sys_uselib
-	.long sys_swapon
-	.long sys_reboot
-	.long sys_old_readdir
-	.long sys_old_mmap	/* 90 */
-	.long sys_munmap
-	.long sys_truncate
-	.long sys_ftruncate
-	.long sys_fchmod
-	.long sys_fchown16	/* 95 */
-	.long sys_getpriority
-	.long sys_setpriority
-	.long sys_ni_syscall	/* old profil syscall holder */
-	.long sys_statfs
-	.long sys_fstatfs	/* 100 */
-	.long sys_ioperm
-	.long sys_socketcall
-	.long sys_syslog
-	.long sys_setitimer
-	.long sys_getitimer	/* 105 */
-	.long sys_newstat
-	.long sys_newlstat
-	.long sys_newfstat
-	.long sys_uname
-	.long ptregs_iopl	/* 110 */
-	.long sys_vhangup
-	.long sys_ni_syscall	/* old "idle" system call */
-	.long ptregs_vm86old
-	.long sys_wait4
-	.long sys_swapoff	/* 115 */
-	.long sys_sysinfo
-	.long sys_ipc
-	.long sys_fsync
-	.long ptregs_sigreturn
-	.long ptregs_clone	/* 120 */
-	.long sys_setdomainname
-	.long sys_newuname
-	.long sys_modify_ldt
-	.long sys_adjtimex
-	.long sys_mprotect	/* 125 */
-	.long sys_sigprocmask
-	.long sys_ni_syscall	/* old "create_module" */
-	.long sys_init_module
-	.long sys_delete_module
-	.long sys_ni_syscall	/* 130:	old "get_kernel_syms" */
-	.long sys_quotactl
-	.long sys_getpgid
-	.long sys_fchdir
-	.long sys_bdflush
-	.long sys_sysfs		/* 135 */
-	.long sys_personality
-	.long sys_ni_syscall	/* reserved for afs_syscall */
-	.long sys_setfsuid16
-	.long sys_setfsgid16
-	.long sys_llseek	/* 140 */
-	.long sys_getdents
-	.long sys_select
-	.long sys_flock
-	.long sys_msync
-	.long sys_readv		/* 145 */
-	.long sys_writev
-	.long sys_getsid
-	.long sys_fdatasync
-	.long sys_sysctl
-	.long sys_mlock		/* 150 */
-	.long sys_munlock
-	.long sys_mlockall
-	.long sys_munlockall
-	.long sys_sched_setparam
-	.long sys_sched_getparam   /* 155 */
-	.long sys_sched_setscheduler
-	.long sys_sched_getscheduler
-	.long sys_sched_yield
-	.long sys_sched_get_priority_max
-	.long sys_sched_get_priority_min  /* 160 */
-	.long sys_sched_rr_get_interval
-	.long sys_nanosleep
-	.long sys_mremap
-	.long sys_setresuid16
-	.long sys_getresuid16	/* 165 */
-	.long ptregs_vm86
-	.long sys_ni_syscall	/* Old sys_query_module */
-	.long sys_poll
-	.long sys_ni_syscall	/* Old nfsservctl */
-	.long sys_setresgid16	/* 170 */
-	.long sys_getresgid16
-	.long sys_prctl
-	.long ptregs_rt_sigreturn
-	.long sys_rt_sigaction
-	.long sys_rt_sigprocmask	/* 175 */
-	.long sys_rt_sigpending
-	.long sys_rt_sigtimedwait
-	.long sys_rt_sigqueueinfo
-	.long sys_rt_sigsuspend
-	.long sys_pread64	/* 180 */
-	.long sys_pwrite64
-	.long sys_chown16
-	.long sys_getcwd
-	.long sys_capget
-	.long sys_capset	/* 185 */
-	.long ptregs_sigaltstack
-	.long sys_sendfile
-	.long sys_ni_syscall	/* reserved for streams1 */
-	.long sys_ni_syscall	/* reserved for streams2 */
-	.long ptregs_vfork	/* 190 */
-	.long sys_getrlimit
-	.long sys_mmap_pgoff
-	.long sys_truncate64
-	.long sys_ftruncate64
-	.long sys_stat64	/* 195 */
-	.long sys_lstat64
-	.long sys_fstat64
-	.long sys_lchown
-	.long sys_getuid
-	.long sys_getgid	/* 200 */
-	.long sys_geteuid
-	.long sys_getegid
-	.long sys_setreuid
-	.long sys_setregid
-	.long sys_getgroups	/* 205 */
-	.long sys_setgroups
-	.long sys_fchown
-	.long sys_setresuid
-	.long sys_getresuid
-	.long sys_setresgid	/* 210 */
-	.long sys_getresgid
-	.long sys_chown
-	.long sys_setuid
-	.long sys_setgid
-	.long sys_setfsuid	/* 215 */
-	.long sys_setfsgid
-	.long sys_pivot_root
-	.long sys_mincore
-	.long sys_madvise
-	.long sys_getdents64	/* 220 */
-	.long sys_fcntl64
-	.long sys_ni_syscall	/* reserved for TUX */
-	.long sys_ni_syscall
-	.long sys_gettid
-	.long sys_readahead	/* 225 */
-	.long sys_setxattr
-	.long sys_lsetxattr
-	.long sys_fsetxattr
-	.long sys_getxattr
-	.long sys_lgetxattr	/* 230 */
-	.long sys_fgetxattr
-	.long sys_listxattr
-	.long sys_llistxattr
-	.long sys_flistxattr
-	.long sys_removexattr	/* 235 */
-	.long sys_lremovexattr
-	.long sys_fremovexattr
-	.long sys_tkill
-	.long sys_sendfile64
-	.long sys_futex		/* 240 */
-	.long sys_sched_setaffinity
-	.long sys_sched_getaffinity
-	.long sys_set_thread_area
-	.long sys_get_thread_area
-	.long sys_io_setup	/* 245 */
-	.long sys_io_destroy
-	.long sys_io_getevents
-	.long sys_io_submit
-	.long sys_io_cancel
-	.long sys_fadvise64	/* 250 */
-	.long sys_ni_syscall
-	.long sys_exit_group
-	.long sys_lookup_dcookie
-	.long sys_epoll_create
-	.long sys_epoll_ctl	/* 255 */
-	.long sys_epoll_wait
- 	.long sys_remap_file_pages
- 	.long sys_set_tid_address
- 	.long sys_timer_create
- 	.long sys_timer_settime		/* 260 */
- 	.long sys_timer_gettime
- 	.long sys_timer_getoverrun
- 	.long sys_timer_delete
- 	.long sys_clock_settime
- 	.long sys_clock_gettime		/* 265 */
- 	.long sys_clock_getres
- 	.long sys_clock_nanosleep
-	.long sys_statfs64
-	.long sys_fstatfs64
-	.long sys_tgkill	/* 270 */
-	.long sys_utimes
- 	.long sys_fadvise64_64
-	.long sys_ni_syscall	/* sys_vserver */
-	.long sys_mbind
-	.long sys_get_mempolicy
-	.long sys_set_mempolicy
-	.long sys_mq_open
-	.long sys_mq_unlink
-	.long sys_mq_timedsend
-	.long sys_mq_timedreceive	/* 280 */
-	.long sys_mq_notify
-	.long sys_mq_getsetattr
-	.long sys_kexec_load
-	.long sys_waitid
-	.long sys_ni_syscall		/* 285 */ /* available */
-	.long sys_add_key
-	.long sys_request_key
-	.long sys_keyctl
-	.long sys_ioprio_set
-	.long sys_ioprio_get		/* 290 */
-	.long sys_inotify_init
-	.long sys_inotify_add_watch
-	.long sys_inotify_rm_watch
-	.long sys_migrate_pages
-	.long sys_openat		/* 295 */
-	.long sys_mkdirat
-	.long sys_mknodat
-	.long sys_fchownat
-	.long sys_futimesat
-	.long sys_fstatat64		/* 300 */
-	.long sys_unlinkat
-	.long sys_renameat
-	.long sys_linkat
-	.long sys_symlinkat
-	.long sys_readlinkat		/* 305 */
-	.long sys_fchmodat
-	.long sys_faccessat
-	.long sys_pselect6
-	.long sys_ppoll
-	.long sys_unshare		/* 310 */
-	.long sys_set_robust_list
-	.long sys_get_robust_list
-	.long sys_splice
-	.long sys_sync_file_range
-	.long sys_tee			/* 315 */
-	.long sys_vmsplice
-	.long sys_move_pages
-	.long sys_getcpu
-	.long sys_epoll_pwait
-	.long sys_utimensat		/* 320 */
-	.long sys_signalfd
-	.long sys_timerfd_create
-	.long sys_eventfd
-	.long sys_fallocate
-	.long sys_timerfd_settime	/* 325 */
-	.long sys_timerfd_gettime
-	.long sys_signalfd4
-	.long sys_eventfd2
-	.long sys_epoll_create1
-	.long sys_dup3			/* 330 */
-	.long sys_pipe2
-	.long sys_inotify_init1
-	.long sys_preadv
-	.long sys_pwritev
-	.long sys_rt_tgsigqueueinfo	/* 335 */
-	.long sys_perf_event_open
-	.long sys_recvmmsg
-	.long sys_fanotify_init
-	.long sys_fanotify_mark
-	.long sys_prlimit64		/* 340 */
-	.long sys_name_to_handle_at
-	.long sys_open_by_handle_at
-	.long sys_clock_adjtime
-	.long sys_syncfs
-	.long sys_sendmmsg		/* 345 */
-	.long sys_setns
-	.long sys_process_vm_readv
-	.long sys_process_vm_writev
-- 
1.7.6.4

