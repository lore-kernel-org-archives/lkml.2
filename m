Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439Ab1D0Pcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:32:32 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:39021 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab1D0Pca convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Wed, 27 Apr 2011 11:32:30 -0400
Message-Id: <4DB85376020000780003E6C9@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 27 Apr 2011 16:33:42 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: re-use kernel/syscall_table_32.S in
	 ia32/ia32entry.S
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This requires a little bit of renaming, and a (much shorter than the
original full table) set of #define-s for those table entries where
native and compat mode entries differ.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/ia32/ia32entry.S |  499 ++++++++++++----------------------------------
 1 file changed, 135 insertions(+), 364 deletions(-)

--- 2.6.39-rc5/arch/x86/ia32/ia32entry.S
+++ 2.6.39-rc5-x86_64-ia32entry-syscall-table-32/arch/x86/ia32/ia32entry.S
@@ -452,30 +452,25 @@ ia32_badsys:
 	movq $0,ORIG_RAX-ARGOFFSET(%rsp)
 	movq $-ENOSYS,%rax
 	jmp ia32_sysret
-
-quiet_ni_syscall:
-	movq $-ENOSYS,%rax
-	ret
 	CFI_ENDPROC
 	
-	.macro PTREGSCALL label, func, arg
-	.globl \label
-\label:
-	leaq \func(%rip),%rax
-	leaq -ARGOFFSET+8(%rsp),\arg	/* 8 for return address */
+	.macro PTREGSCALL name, pfx, arg
+ptregs_\name:
+	leaq \pfx\name(%rip),%rax
+	leaq -ARGOFFSET+8(%rsp),%r\arg	/* 8 for return address */
 	jmp  ia32_ptregs_common	
 	.endm
 
 	CFI_STARTPROC32
 
-	PTREGSCALL stub32_rt_sigreturn, sys32_rt_sigreturn, %rdi
-	PTREGSCALL stub32_sigreturn, sys32_sigreturn, %rdi
-	PTREGSCALL stub32_sigaltstack, sys32_sigaltstack, %rdx
-	PTREGSCALL stub32_execve, sys32_execve, %rcx
-	PTREGSCALL stub32_fork, sys_fork, %rdi
-	PTREGSCALL stub32_clone, sys32_clone, %rdx
-	PTREGSCALL stub32_vfork, sys_vfork, %rdi
-	PTREGSCALL stub32_iopl, sys_iopl, %rsi
+	PTREGSCALL rt_sigreturn, sys32_, di
+	PTREGSCALL sigreturn, sys32_, di
+	PTREGSCALL sigaltstack, sys32_, dx
+	PTREGSCALL execve, sys32_, cx
+	PTREGSCALL fork, sys_, di
+	PTREGSCALL clone, sys32_, dx
+	PTREGSCALL vfork, sys_, di
+	PTREGSCALL iopl, sys_, si
 
 ENTRY(ia32_ptregs_common)
 	popq %r11
@@ -501,351 +496,127 @@ ENTRY(ia32_ptregs_common)
 END(ia32_ptregs_common)
 
 	.section .rodata,"a"
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
-	.quad compat_sys_nfsservctl
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
+#define sys_call_table		ia32_sys_call_table
+#define long			quad
+
+#define ptregs_vm86		sys32_vm86_warning
+#define ptregs_vm86old		sys32_vm86_warning
+#define sys_adjtimex		compat_sys_adjtimex
+#define sys_bdflush		sys_ni_syscall
+#define sys_call_table		ia32_sys_call_table
+#define sys_clock_adjtime	compat_sys_clock_adjtime
+#define sys_clock_getres	compat_sys_clock_getres
+#define sys_clock_gettime	compat_sys_clock_gettime
+#define sys_clock_nanosleep	compat_sys_clock_nanosleep
+#define sys_clock_settime	compat_sys_clock_settime
+#define sys_fadvise64		sys32_fadvise64
+#define sys_fadvise64_64	sys32_fadvise64_64
+#define sys_fallocate		sys32_fallocate
+#define sys_fanotify_mark	sys32_fanotify_mark
+#define sys_fcntl		compat_sys_fcntl64
+#define sys_fcntl64		compat_sys_fcntl64
+#define sys_fstat64		sys32_fstat64
+#define sys_fstatat64		sys32_fstatat
+#define sys_fstatfs		compat_sys_fstatfs
+#define sys_fstatfs64		compat_sys_fstatfs64
+#define sys_ftruncate64		sys32_ftruncate64
+#define sys_futex		compat_sys_futex
+#define sys_futimesat		compat_sys_futimesat
+#define sys_getdents64		compat_sys_getdents64
+#define sys_getdents		compat_sys_getdents
+#define sys_getitimer		compat_sys_getitimer
+#define sys_get_mempolicy	compat_sys_get_mempolicy
+#define sys_getrlimit		compat_sys_getrlimit
+#define sys_get_robust_list	compat_sys_get_robust_list
+#define sys_getrusage		compat_sys_getrusage
+#define sys_gettimeofday	compat_sys_gettimeofday
+#define sys_ioctl		compat_sys_ioctl
+#define sys_io_getevents	compat_sys_io_getevents
+#define sys_io_setup		compat_sys_io_setup
+#define sys_io_submit		compat_sys_io_submit
+#define sys_ipc			sys32_ipc
+#define sys_kexec_load		compat_sys_kexec_load
+#define sys_kill		sys32_kill
+#define sys_lookup_dcookie	sys32_lookup_dcookie
+#define sys_lseek		sys32_lseek
+#define sys_lstat64		sys32_lstat64
+#define sys_mount		compat_sys_mount
+#define sys_move_pages		compat_sys_move_pages
+#define sys_mprotect		sys32_mprotect
+#define sys_mq_getsetattr	compat_sys_mq_getsetattr
+#define sys_mq_notify		compat_sys_mq_notify
+#define sys_mq_open		compat_sys_mq_open
+#define sys_mq_timedreceive	compat_sys_mq_timedreceive
+#define sys_mq_timedsend	compat_sys_mq_timedsend
+#define sys_nanosleep		compat_sys_nanosleep
+#define sys_newfstat		compat_sys_newfstat
+#define sys_newlstat		compat_sys_newlstat
+#define sys_newstat		compat_sys_newstat
+#define sys_nfsservctl		compat_sys_nfsservctl
+#define sys_old_mmap		sys32_mmap
+#define sys_old_getrlimit	compat_sys_old_getrlimit
+#define sys_old_readdir		compat_sys_old_readdir
+#define sys_old_select		compat_sys_old_select
+#define sys_open		compat_sys_open
+#define sys_openat		compat_sys_openat
+#define sys_open_by_handle_at	compat_sys_open_by_handle_at
+#define sys_ppoll		compat_sys_ppoll
+#define sys_pread64		sys32_pread
+#define sys_preadv		compat_sys_preadv
+#define sys_pselect6		compat_sys_pselect6
+#define sys_ptrace		compat_sys_ptrace
+#define sys_pwrite64		sys32_pwrite
+#define sys_pwritev		compat_sys_pwritev
+#define sys_quotactl		sys32_quotactl
+#define sys_readahead		sys32_readahead
+#define sys_readv		compat_sys_readv
+#define sys_recvmmsg		compat_sys_recvmmsg
+#define sys_rt_sigaction	sys32_rt_sigaction
+#define sys_rt_sigpending	sys32_rt_sigpending
+#define sys_rt_sigprocmask	sys32_rt_sigprocmask
+#define sys_rt_sigqueueinfo	sys32_rt_sigqueueinfo
+#define sys_rt_sigtimedwait	compat_sys_rt_sigtimedwait
+#define sys_rt_tgsigqueueinfo	compat_sys_rt_tgsigqueueinfo
+#define sys_sched_getaffinity	compat_sys_sched_getaffinity
+#define sys_sched_rr_get_interval sys32_sched_rr_get_interval
+#define sys_sched_setaffinity	compat_sys_sched_setaffinity
+#define sys_select		compat_sys_select
+#define sys_sendfile		sys32_sendfile
+#define sys_setitimer		compat_sys_setitimer
+#define sys_setrlimit		compat_sys_setrlimit
+#define sys_set_robust_list	compat_sys_set_robust_list
+#define sys_settimeofday	compat_sys_settimeofday
+#define sys_sigaction		sys32_sigaction
+#define sys_signalfd4		compat_sys_signalfd4
+#define sys_signalfd		compat_sys_signalfd
+#define sys_sigpending		compat_sys_sigpending
+#define sys_sigprocmask		compat_sys_sigprocmask
+#define sys_sigsuspend		sys32_sigsuspend
+#define sys_socketcall		compat_sys_socketcall
+#define sys_stat64		sys32_stat64
+#define sys_statfs		compat_sys_statfs
+#define sys_statfs64		compat_sys_statfs64
+#define sys_stime		compat_sys_stime
+#define sys_sync_file_range	sys32_sync_file_range
+#define sys_sysctl		compat_sys_sysctl
+#define sys_sysinfo		compat_sys_sysinfo
+#define sys_time		compat_sys_time
+#define sys_timer_create	compat_sys_timer_create
+#define sys_timerfd_gettime	compat_sys_timerfd_gettime
+#define sys_timerfd_settime	compat_sys_timerfd_settime
+#define sys_timer_gettime	compat_sys_timer_gettime
+#define sys_timer_settime	compat_sys_timer_settime
+#define sys_times		compat_sys_times
+#define sys_truncate64		sys32_truncate64
+#define sys_ustat		compat_sys_ustat
+#define sys_utime		compat_sys_utime
+#define sys_utimensat		compat_sys_utimensat
+#define sys_utimes		compat_sys_utimes
+#define sys_vmsplice		compat_sys_vmsplice
+#define sys_wait4		compat_sys_wait4
+#define sys_waitid		compat_sys_waitid
+#define sys_waitpid		sys32_waitpid
+#define sys_writev		compat_sys_writev
+
+#include "../kernel/syscall_table_32.S"
 ia32_syscall_end:


