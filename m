Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab1EDSiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:38:00 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:36415 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab1EDSh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:37:56 -0400
Date: Wed, 4 May 2011 20:37:54 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux/m68k <linux-m68k@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>
cc: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        uClinux list <uclinux-dev@uclinux.org>
Subject: [PATCH] m68k: Merge mmu and non-mmu versions of sys_call_table
Message-ID: <alpine.DEB.2.00.1105042033190.9040@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact for nommu:
  - Store table in .rodata instead of .text,
  - Let kernel/sys_ni.c handle the stubbing of MMU-only syscalls,
  - Implement sys_mremap and sys_nfsservct,
  - Remove unused padding at the end of the table.

Impact for mmu:
  - Store table in .rodata instead of .data.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v2: Store table in .rodata instead of .data.
v3: Let kernel/sys_ni.c handle the stubbing of MMU-only syscalls,
    Implement sys_mremap and sys_nfsservct.

Greg, if it's OK for you, I'll add this to my for-2.6.40 branch.

 arch/m68k/kernel/Makefile_mm    |    2 +-
 arch/m68k/kernel/entry_mm.S     |  348 ---------------------------------------
 arch/m68k/kernel/syscalltable.S |  191 +++++++++++-----------
 3 files changed, 96 insertions(+), 445 deletions(-)

diff --git a/arch/m68k/kernel/Makefile_mm b/arch/m68k/kernel/Makefile_mm
index 55d5d6b..aced678 100644
--- a/arch/m68k/kernel/Makefile_mm
+++ b/arch/m68k/kernel/Makefile_mm
@@ -10,7 +10,7 @@ endif
 extra-y	+= vmlinux.lds
 
 obj-y	:= entry.o process.o traps.o ints.o signal.o ptrace.o module.o \
-	   sys_m68k.o time.o setup.o m68k_ksyms.o devres.o
+	   sys_m68k.o time.o setup.o m68k_ksyms.o devres.o syscalltable.o
 
 devres-y = ../../../kernel/irq/devres.o
 
diff --git a/arch/m68k/kernel/entry_mm.S b/arch/m68k/kernel/entry_mm.S
index 1359ee6..bd0ec05 100644
--- a/arch/m68k/kernel/entry_mm.S
+++ b/arch/m68k/kernel/entry_mm.S
@@ -407,351 +407,3 @@ resume:
 
 	rts
 
-.data
-ALIGN
-sys_call_table:
-	.long sys_restart_syscall	/* 0 - old "setup()" system call, used for restarting */
-	.long sys_exit
-	.long sys_fork
-	.long sys_read
-	.long sys_write
-	.long sys_open		/* 5 */
-	.long sys_close
-	.long sys_waitpid
-	.long sys_creat
-	.long sys_link
-	.long sys_unlink	/* 10 */
-	.long sys_execve
-	.long sys_chdir
-	.long sys_time
-	.long sys_mknod
-	.long sys_chmod		/* 15 */
-	.long sys_chown16
-	.long sys_ni_syscall				/* old break syscall holder */
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
-	.long sys_ni_syscall				/* old stty syscall holder */
-	.long sys_ni_syscall				/* old gtty syscall holder */
-	.long sys_access
-	.long sys_nice
-	.long sys_ni_syscall	/* 35 */	/* old ftime syscall holder */
-	.long sys_sync
-	.long sys_kill
-	.long sys_rename
-	.long sys_mkdir
-	.long sys_rmdir		/* 40 */
-	.long sys_dup
-	.long sys_pipe
-	.long sys_times
-	.long sys_ni_syscall				/* old prof syscall holder */
-	.long sys_brk		/* 45 */
-	.long sys_setgid16
-	.long sys_getgid16
-	.long sys_signal
-	.long sys_geteuid16
-	.long sys_getegid16	/* 50 */
-	.long sys_acct
-	.long sys_umount				/* recycled never used phys() */
-	.long sys_ni_syscall				/* old lock syscall holder */
-	.long sys_ioctl
-	.long sys_fcntl		/* 55 */
-	.long sys_ni_syscall				/* old mpx syscall holder */
-	.long sys_setpgid
-	.long sys_ni_syscall				/* old ulimit syscall holder */
-	.long sys_ni_syscall
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
-	.long sys_ni_syscall				/* old profil syscall holder */
-	.long sys_statfs
-	.long sys_fstatfs	/* 100 */
-	.long sys_ni_syscall				/* ioperm for i386 */
-	.long sys_socketcall
-	.long sys_syslog
-	.long sys_setitimer
-	.long sys_getitimer	/* 105 */
-	.long sys_newstat
-	.long sys_newlstat
-	.long sys_newfstat
-	.long sys_ni_syscall
-	.long sys_ni_syscall	/* 110 */	/* iopl for i386 */
-	.long sys_vhangup
-	.long sys_ni_syscall				/* obsolete idle() syscall */
-	.long sys_ni_syscall				/* vm86old for i386 */
-	.long sys_wait4
-	.long sys_swapoff	/* 115 */
-	.long sys_sysinfo
-	.long sys_ipc
-	.long sys_fsync
-	.long sys_sigreturn
-	.long sys_clone		/* 120 */
-	.long sys_setdomainname
-	.long sys_newuname
-	.long sys_cacheflush				/* modify_ldt for i386 */
-	.long sys_adjtimex
-	.long sys_mprotect	/* 125 */
-	.long sys_sigprocmask
-	.long sys_ni_syscall		/* old "create_module" */
-	.long sys_init_module
-	.long sys_delete_module
-	.long sys_ni_syscall	/* 130 - old "get_kernel_syms" */
-	.long sys_quotactl
-	.long sys_getpgid
-	.long sys_fchdir
-	.long sys_bdflush
-	.long sys_sysfs		/* 135 */
-	.long sys_personality
-	.long sys_ni_syscall				/* for afs_syscall */
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
-	.long sys_sched_getparam	/* 155 */
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
-	.long sys_getpagesize
-	.long sys_ni_syscall		/* old sys_query_module */
-	.long sys_poll
-	.long sys_nfsservctl
-	.long sys_setresgid16	/* 170 */
-	.long sys_getresgid16
-	.long sys_prctl
-	.long sys_rt_sigreturn
-	.long sys_rt_sigaction
-	.long sys_rt_sigprocmask	/* 175 */
-	.long sys_rt_sigpending
-	.long sys_rt_sigtimedwait
-	.long sys_rt_sigqueueinfo
-	.long sys_rt_sigsuspend
-	.long sys_pread64	/* 180 */
-	.long sys_pwrite64
-	.long sys_lchown16;
-	.long sys_getcwd
-	.long sys_capget
-	.long sys_capset	/* 185 */
-	.long sys_sigaltstack
-	.long sys_sendfile
-	.long sys_ni_syscall				/* streams1 */
-	.long sys_ni_syscall				/* streams2 */
-	.long sys_vfork		/* 190 */
-	.long sys_getrlimit
-	.long sys_mmap2
-	.long sys_truncate64
-	.long sys_ftruncate64
-	.long sys_stat64	/* 195 */
-	.long sys_lstat64
-	.long sys_fstat64
-	.long sys_chown
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
-	.long sys_lchown
-	.long sys_setuid
-	.long sys_setgid
-	.long sys_setfsuid	/* 215 */
-	.long sys_setfsgid
-	.long sys_pivot_root
-	.long sys_ni_syscall
-	.long sys_ni_syscall
-	.long sys_getdents64	/* 220 */
-	.long sys_gettid
-	.long sys_tkill
-	.long sys_setxattr
-	.long sys_lsetxattr
-	.long sys_fsetxattr	/* 225 */
-	.long sys_getxattr
-	.long sys_lgetxattr
-	.long sys_fgetxattr
-	.long sys_listxattr
-	.long sys_llistxattr	/* 230 */
-	.long sys_flistxattr
-	.long sys_removexattr
-	.long sys_lremovexattr
-	.long sys_fremovexattr
-	.long sys_futex		/* 235 */
-	.long sys_sendfile64
-	.long sys_mincore
-	.long sys_madvise
-	.long sys_fcntl64
-	.long sys_readahead	/* 240 */
-	.long sys_io_setup
-	.long sys_io_destroy
-	.long sys_io_getevents
-	.long sys_io_submit
-	.long sys_io_cancel	/* 245 */
-	.long sys_fadvise64
-	.long sys_exit_group
-	.long sys_lookup_dcookie
-	.long sys_epoll_create
-	.long sys_epoll_ctl	/* 250 */
-	.long sys_epoll_wait
-	.long sys_remap_file_pages
-	.long sys_set_tid_address
-	.long sys_timer_create
-	.long sys_timer_settime	/* 255 */
-	.long sys_timer_gettime
-	.long sys_timer_getoverrun
-	.long sys_timer_delete
-	.long sys_clock_settime
-	.long sys_clock_gettime	/* 260 */
-	.long sys_clock_getres
-	.long sys_clock_nanosleep
-	.long sys_statfs64
-	.long sys_fstatfs64
-	.long sys_tgkill	/* 265 */
-	.long sys_utimes
-	.long sys_fadvise64_64
-	.long sys_mbind
-	.long sys_get_mempolicy
-	.long sys_set_mempolicy	/* 270 */
-	.long sys_mq_open
-	.long sys_mq_unlink
-	.long sys_mq_timedsend
-	.long sys_mq_timedreceive
-	.long sys_mq_notify	/* 275 */
-	.long sys_mq_getsetattr
-	.long sys_waitid
-	.long sys_ni_syscall	/* for sys_vserver */
-	.long sys_add_key
-	.long sys_request_key	/* 280 */
-	.long sys_keyctl
-	.long sys_ioprio_set
-	.long sys_ioprio_get
-	.long sys_inotify_init
-	.long sys_inotify_add_watch	/* 285 */
-	.long sys_inotify_rm_watch
-	.long sys_migrate_pages
-	.long sys_openat
-	.long sys_mkdirat
-	.long sys_mknodat		/* 290 */
-	.long sys_fchownat
-	.long sys_futimesat
-	.long sys_fstatat64
-	.long sys_unlinkat
-	.long sys_renameat		/* 295 */
-	.long sys_linkat
-	.long sys_symlinkat
-	.long sys_readlinkat
-	.long sys_fchmodat
-	.long sys_faccessat		/* 300 */
-	.long sys_ni_syscall		/* Reserved for pselect6 */
-	.long sys_ni_syscall		/* Reserved for ppoll */
-	.long sys_unshare
-	.long sys_set_robust_list
-	.long sys_get_robust_list	/* 305 */
-	.long sys_splice
-	.long sys_sync_file_range
-	.long sys_tee
-	.long sys_vmsplice
-	.long sys_move_pages		/* 310 */
-	.long sys_sched_setaffinity
-	.long sys_sched_getaffinity
-	.long sys_kexec_load
-	.long sys_getcpu
-	.long sys_epoll_pwait		/* 315 */
-	.long sys_utimensat
-	.long sys_signalfd
-	.long sys_timerfd_create
-	.long sys_eventfd
-	.long sys_fallocate		/* 320 */
-	.long sys_timerfd_settime
-	.long sys_timerfd_gettime
-	.long sys_signalfd4
-	.long sys_eventfd2
-	.long sys_epoll_create1		/* 325 */
-	.long sys_dup3
-	.long sys_pipe2
-	.long sys_inotify_init1
-	.long sys_preadv
-	.long sys_pwritev		/* 330 */
-	.long sys_rt_tgsigqueueinfo
-	.long sys_perf_event_open
-	.long sys_get_thread_area
-	.long sys_set_thread_area
-	.long sys_atomic_cmpxchg_32	/* 335 */
-	.long sys_atomic_barrier
-	.long sys_fanotify_init
-	.long sys_fanotify_mark
-	.long sys_prlimit64
-	.long sys_name_to_handle_at	/* 340 */
-	.long sys_open_by_handle_at
-	.long sys_clock_adjtime
-	.long sys_syncfs
-
diff --git a/arch/m68k/kernel/syscalltable.S b/arch/m68k/kernel/syscalltable.S
index 9b8393d..0284192 100644
--- a/arch/m68k/kernel/syscalltable.S
+++ b/arch/m68k/kernel/syscalltable.S
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/m68knommu/kernel/syscalltable.S
- *
  *  Copyright (C) 2002, Greg Ungerer (gerg@snapgear.com)
  *
  *  Based on older entry.S files, the following copyrights apply:
@@ -9,171 +7,176 @@
  *                      Kenneth Albanowski <kjahds@kjahds.com>,
  *  Copyright (C) 2000  Lineo Inc. (www.lineo.com) 
  *  Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ *  Linux/m68k support by Hamish Macdonald
  */
 
 #include <linux/sys.h>
 #include <linux/linkage.h>
-#include <asm/unistd.h>
 
-.text
+#ifndef CONFIG_MMU
+#define sys_mmap2		sys_mmap_pgoff
+#endif
+
+.section .rodata
 ALIGN
 ENTRY(sys_call_table)
-	.long sys_restart_syscall	/* 0  -  old "setup()" system call */
+	.long sys_restart_syscall	/* 0 - old "setup()" system call, used for restarting */
 	.long sys_exit
 	.long sys_fork
 	.long sys_read
 	.long sys_write
-	.long sys_open		/* 5 */
+	.long sys_open			/* 5 */
 	.long sys_close
 	.long sys_waitpid
 	.long sys_creat
 	.long sys_link
-	.long sys_unlink	/* 10 */
+	.long sys_unlink		/* 10 */
 	.long sys_execve
 	.long sys_chdir
 	.long sys_time
 	.long sys_mknod
-	.long sys_chmod		/* 15 */
+	.long sys_chmod			/* 15 */
 	.long sys_chown16
-	.long sys_ni_syscall	/* old break syscall holder */
+	.long sys_ni_syscall		/* old break syscall holder */
 	.long sys_stat
 	.long sys_lseek
-	.long sys_getpid	/* 20 */
+	.long sys_getpid		/* 20 */
 	.long sys_mount
 	.long sys_oldumount
 	.long sys_setuid16
 	.long sys_getuid16
-	.long sys_stime		/* 25 */
+	.long sys_stime			/* 25 */
 	.long sys_ptrace
 	.long sys_alarm
 	.long sys_fstat
 	.long sys_pause
-	.long sys_utime		/* 30 */
-	.long sys_ni_syscall	/* old stty syscall holder */
-	.long sys_ni_syscall	/* old gtty syscall holder */
+	.long sys_utime			/* 30 */
+	.long sys_ni_syscall		/* old stty syscall holder */
+	.long sys_ni_syscall		/* old gtty syscall holder */
 	.long sys_access
 	.long sys_nice
-	.long sys_ni_syscall	/* 35 */ /* old ftime syscall holder */
+	.long sys_ni_syscall		/* 35 - old ftime syscall holder */
 	.long sys_sync
 	.long sys_kill
 	.long sys_rename
 	.long sys_mkdir
-	.long sys_rmdir		/* 40 */
+	.long sys_rmdir			/* 40 */
 	.long sys_dup
 	.long sys_pipe
 	.long sys_times
-	.long sys_ni_syscall	/* old prof syscall holder */
-	.long sys_brk		/* 45 */
+	.long sys_ni_syscall		/* old prof syscall holder */
+	.long sys_brk			/* 45 */
 	.long sys_setgid16
 	.long sys_getgid16
 	.long sys_signal
 	.long sys_geteuid16
-	.long sys_getegid16	/* 50 */
+	.long sys_getegid16		/* 50 */
 	.long sys_acct
-	.long sys_umount	/* recycled never used phys() */
-	.long sys_ni_syscall	/* old lock syscall holder */
+	.long sys_umount		/* recycled never used phys() */
+	.long sys_ni_syscall		/* old lock syscall holder */
 	.long sys_ioctl
-	.long sys_fcntl		/* 55 */
-	.long sys_ni_syscall	/* old mpx syscall holder */
+	.long sys_fcntl			/* 55 */
+	.long sys_ni_syscall		/* old mpx syscall holder */
 	.long sys_setpgid
-	.long sys_ni_syscall	/* old ulimit syscall holder */
+	.long sys_ni_syscall		/* old ulimit syscall holder */
 	.long sys_ni_syscall
-	.long sys_umask		/* 60 */
+	.long sys_umask			/* 60 */
 	.long sys_chroot
 	.long sys_ustat
 	.long sys_dup2
 	.long sys_getppid
-	.long sys_getpgrp	/* 65 */
+	.long sys_getpgrp		/* 65 */
 	.long sys_setsid
 	.long sys_sigaction
 	.long sys_sgetmask
 	.long sys_ssetmask
-	.long sys_setreuid16	/* 70 */
+	.long sys_setreuid16		/* 70 */
 	.long sys_setregid16
 	.long sys_sigsuspend
 	.long sys_sigpending
 	.long sys_sethostname
-	.long sys_setrlimit	/* 75 */
+	.long sys_setrlimit		/* 75 */
 	.long sys_old_getrlimit
 	.long sys_getrusage
 	.long sys_gettimeofday
 	.long sys_settimeofday
-	.long sys_getgroups16	/* 80 */
+	.long sys_getgroups16		/* 80 */
 	.long sys_setgroups16
 	.long sys_old_select
 	.long sys_symlink
 	.long sys_lstat
-	.long sys_readlink	/* 85 */
+	.long sys_readlink		/* 85 */
 	.long sys_uselib
-	.long sys_ni_syscall	/* sys_swapon */
+	.long sys_swapon
 	.long sys_reboot
 	.long sys_old_readdir
-	.long sys_old_mmap	/* 90 */
+	.long sys_old_mmap		/* 90 */
 	.long sys_munmap
 	.long sys_truncate
 	.long sys_ftruncate
 	.long sys_fchmod
-	.long sys_fchown16	/* 95 */
+	.long sys_fchown16		/* 95 */
 	.long sys_getpriority
 	.long sys_setpriority
-	.long sys_ni_syscall	/* old profil syscall holder */
+	.long sys_ni_syscall		/* old profil syscall holder */
 	.long sys_statfs
-	.long sys_fstatfs	/* 100 */
-	.long sys_ni_syscall	/* ioperm for i386 */
+	.long sys_fstatfs		/* 100 */
+	.long sys_ni_syscall		/* ioperm for i386 */
 	.long sys_socketcall
 	.long sys_syslog
 	.long sys_setitimer
-	.long sys_getitimer	/* 105 */
+	.long sys_getitimer		/* 105 */
 	.long sys_newstat
 	.long sys_newlstat
 	.long sys_newfstat
 	.long sys_ni_syscall
-	.long sys_ni_syscall	/* iopl for i386 */ /* 110 */
+	.long sys_ni_syscall		/* 110 - iopl for i386 */
 	.long sys_vhangup
-	.long sys_ni_syscall	/* obsolete idle() syscall */
-	.long sys_ni_syscall	/* vm86old for i386 */
+	.long sys_ni_syscall		/* obsolete idle() syscall */
+	.long sys_ni_syscall		/* vm86old for i386 */
 	.long sys_wait4
-	.long sys_ni_syscall	/* 115 */ /* sys_swapoff */
+	.long sys_swapoff		/* 115 */
 	.long sys_sysinfo
 	.long sys_ipc
 	.long sys_fsync
 	.long sys_sigreturn
-	.long sys_clone		/* 120 */
+	.long sys_clone			/* 120 */
 	.long sys_setdomainname
 	.long sys_newuname
-	.long sys_cacheflush	/* modify_ldt for i386 */
+	.long sys_cacheflush		/* modify_ldt for i386 */
 	.long sys_adjtimex
-	.long sys_ni_syscall	/* 125 */ /* sys_mprotect */
+	.long sys_mprotect		/* 125 */
 	.long sys_sigprocmask
-	.long sys_ni_syscall	/* old "creat_module" */
+	.long sys_ni_syscall		/* old "create_module" */
 	.long sys_init_module
 	.long sys_delete_module
-	.long sys_ni_syscall	/* 130: old "get_kernel_syms" */
+	.long sys_ni_syscall		/* 130 - old "get_kernel_syms" */
 	.long sys_quotactl
 	.long sys_getpgid
 	.long sys_fchdir
 	.long sys_bdflush
-	.long sys_sysfs		/* 135 */
+	.long sys_sysfs			/* 135 */
 	.long sys_personality
-	.long sys_ni_syscall	/* for afs_syscall */
+	.long sys_ni_syscall		/* for afs_syscall */
 	.long sys_setfsuid16
 	.long sys_setfsgid16
-	.long sys_llseek	/* 140 */
+	.long sys_llseek		/* 140 */
 	.long sys_getdents
 	.long sys_select
 	.long sys_flock
-	.long sys_ni_syscall	/* sys_msync */
-	.long sys_readv		/* 145 */
+	.long sys_msync
+	.long sys_readv			/* 145 */
 	.long sys_writev
 	.long sys_getsid
 	.long sys_fdatasync
 	.long sys_sysctl
-	.long sys_ni_syscall	/* 150 */ /* sys_mlock */
-	.long sys_ni_syscall	/* sys_munlock */
-	.long sys_ni_syscall	/* sys_mlockall */
-	.long sys_ni_syscall	/* sys_munlockall */
+	.long sys_mlock			/* 150 */
+	.long sys_munlock
+	.long sys_mlockall
+	.long sys_munlockall
 	.long sys_sched_setparam
-	.long sys_sched_getparam /* 155 */
+	.long sys_sched_getparam	/* 155 */
 	.long sys_sched_setscheduler
 	.long sys_sched_getscheduler
 	.long sys_sched_yield
@@ -181,124 +184,124 @@ ENTRY(sys_call_table)
 	.long sys_sched_get_priority_min  /* 160 */
 	.long sys_sched_rr_get_interval
 	.long sys_nanosleep
-	.long sys_ni_syscall	/* sys_mremap */
+	.long sys_mremap
 	.long sys_setresuid16
-	.long sys_getresuid16	/* 165 */
-	.long sys_getpagesize	/* sys_getpagesize */
-	.long sys_ni_syscall	/* old "query_module" */
+	.long sys_getresuid16		/* 165 */
+	.long sys_getpagesize
+	.long sys_ni_syscall		/* old "query_module" */
 	.long sys_poll
-	.long sys_ni_syscall	/* sys_nfsservctl */
-	.long sys_setresgid16	/* 170 */
+	.long sys_nfsservctl
+	.long sys_setresgid16		/* 170 */
 	.long sys_getresgid16
 	.long sys_prctl
 	.long sys_rt_sigreturn
 	.long sys_rt_sigaction
-	.long sys_rt_sigprocmask /* 175 */
+	.long sys_rt_sigprocmask	/* 175 */
 	.long sys_rt_sigpending
 	.long sys_rt_sigtimedwait
 	.long sys_rt_sigqueueinfo
 	.long sys_rt_sigsuspend
-	.long sys_pread64	/* 180 */
+	.long sys_pread64		/* 180 */
 	.long sys_pwrite64
 	.long sys_lchown16
 	.long sys_getcwd
 	.long sys_capget
-	.long sys_capset	/* 185 */
+	.long sys_capset		/* 185 */
 	.long sys_sigaltstack
 	.long sys_sendfile
-	.long sys_ni_syscall	/* streams1 */
-	.long sys_ni_syscall	/* streams2 */
-	.long sys_vfork		/* 190 */
+	.long sys_ni_syscall		/* streams1 */
+	.long sys_ni_syscall		/* streams2 */
+	.long sys_vfork			/* 190 */
 	.long sys_getrlimit
-	.long sys_mmap_pgoff
+	.long sys_mmap2
 	.long sys_truncate64
 	.long sys_ftruncate64
-	.long sys_stat64	/* 195 */
+	.long sys_stat64		/* 195 */
 	.long sys_lstat64
 	.long sys_fstat64
 	.long sys_chown
 	.long sys_getuid
-	.long sys_getgid	/* 200 */
+	.long sys_getgid		/* 200 */
 	.long sys_geteuid
 	.long sys_getegid
 	.long sys_setreuid
 	.long sys_setregid
-	.long sys_getgroups	/* 205 */
+	.long sys_getgroups		/* 205 */
 	.long sys_setgroups
 	.long sys_fchown
 	.long sys_setresuid
 	.long sys_getresuid
-	.long sys_setresgid	/* 210 */
+	.long sys_setresgid		/* 210 */
 	.long sys_getresgid
 	.long sys_lchown
 	.long sys_setuid
 	.long sys_setgid
-	.long sys_setfsuid	/* 215 */
+	.long sys_setfsuid		/* 215 */
 	.long sys_setfsgid
 	.long sys_pivot_root
 	.long sys_ni_syscall
 	.long sys_ni_syscall
-	.long sys_getdents64	/* 220 */
+	.long sys_getdents64		/* 220 */
 	.long sys_gettid
 	.long sys_tkill
 	.long sys_setxattr
 	.long sys_lsetxattr
-	.long sys_fsetxattr	/* 225 */
+	.long sys_fsetxattr		/* 225 */
 	.long sys_getxattr
 	.long sys_lgetxattr
 	.long sys_fgetxattr
 	.long sys_listxattr
-	.long sys_llistxattr	/* 230 */
+	.long sys_llistxattr		/* 230 */
 	.long sys_flistxattr
 	.long sys_removexattr
 	.long sys_lremovexattr
 	.long sys_fremovexattr
-	.long sys_futex		/* 235 */
+	.long sys_futex			/* 235 */
 	.long sys_sendfile64
-	.long sys_ni_syscall	/* sys_mincore */
-	.long sys_ni_syscall	/* sys_madvise */
+	.long sys_mincore
+	.long sys_madvise
 	.long sys_fcntl64
-	.long sys_readahead	/* 240 */
+	.long sys_readahead		/* 240 */
 	.long sys_io_setup
 	.long sys_io_destroy
 	.long sys_io_getevents
 	.long sys_io_submit
-	.long sys_io_cancel	/* 245 */
+	.long sys_io_cancel		/* 245 */
 	.long sys_fadvise64
 	.long sys_exit_group
 	.long sys_lookup_dcookie
 	.long sys_epoll_create
-	.long sys_epoll_ctl	/* 250 */
+	.long sys_epoll_ctl		/* 250 */
 	.long sys_epoll_wait
-	.long sys_ni_syscall	/* sys_remap_file_pages */
+	.long sys_remap_file_pages
 	.long sys_set_tid_address
 	.long sys_timer_create
-	.long sys_timer_settime	/* 255 */
+	.long sys_timer_settime		/* 255 */
 	.long sys_timer_gettime
 	.long sys_timer_getoverrun
 	.long sys_timer_delete
 	.long sys_clock_settime
-	.long sys_clock_gettime	/* 260 */
+	.long sys_clock_gettime		/* 260 */
 	.long sys_clock_getres
 	.long sys_clock_nanosleep
 	.long sys_statfs64
 	.long sys_fstatfs64
-	.long sys_tgkill	/* 265 */
+	.long sys_tgkill		/* 265 */
 	.long sys_utimes
 	.long sys_fadvise64_64
-	.long sys_mbind	
+	.long sys_mbind
 	.long sys_get_mempolicy
-	.long sys_set_mempolicy	/* 270 */
+	.long sys_set_mempolicy		/* 270 */
 	.long sys_mq_open
 	.long sys_mq_unlink
 	.long sys_mq_timedsend
 	.long sys_mq_timedreceive
-	.long sys_mq_notify	/* 275 */
+	.long sys_mq_notify		/* 275 */
 	.long sys_mq_getsetattr
 	.long sys_waitid
-	.long sys_ni_syscall	/* for sys_vserver */
+	.long sys_ni_syscall		/* for sys_vserver */
 	.long sys_add_key
-	.long sys_request_key	/* 280 */
+	.long sys_request_key		/* 280 */
 	.long sys_keyctl
 	.long sys_ioprio_set
 	.long sys_ioprio_get
@@ -363,7 +366,3 @@ ENTRY(sys_call_table)
 	.long sys_clock_adjtime
 	.long sys_syncfs
 
-	.rept NR_syscalls-(.-sys_call_table)/4
-		.long sys_ni_syscall
-	.endr
-
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
