Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab2IGQbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:31:55 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34576 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab2IGQ16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:27:58 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 21/31] arm64: 32-bit (compat) applications support
Date: Fri,  7 Sep 2012 17:26:56 +0100
Message-Id: <1347035226-18649-22-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Sep 2012 16:27:55.0519 (UTC) FILETIME=[BC3768F0:01CD8D15]
X-MC-Unique: 112090717275600201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q87GWJk4008407

From: Will Deacon <will.deacon@arm.com>

This patch adds support for 32-bit applications. The vectors page is a
binary blob mapped into the application user space at 0xffff0000 (the
AArch64 toolchain does not support compilation of AArch32 code). Full
compatibility with ARMv7 user space is supported. The use of deprecated
ARMv7 functionality (SWP, CP15 barriers) has been disabled by default on
AArch64 kernels and unaligned LDM/STM is not supported.

Please note that only the ARM 32-bit EABI is supported, so no OABI
compatibility.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm64/include/asm/compat.h   |  242 ++++++++++
 arch/arm64/include/asm/signal32.h |   53 +++
 arch/arm64/include/asm/unistd32.h |  758 ++++++++++++++++++++++++++++++++
 arch/arm64/kernel/kuser32.S       |   77 ++++
 arch/arm64/kernel/signal32.c      |  876 +++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/sys32.S         |  282 ++++++++++++
 arch/arm64/kernel/sys_compat.c    |  164 +++++++
 7 files changed, 2452 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/include/asm/compat.h
 create mode 100644 arch/arm64/include/asm/signal32.h
 create mode 100644 arch/arm64/include/asm/unistd32.h
 create mode 100644 arch/arm64/kernel/kuser32.S
 create mode 100644 arch/arm64/kernel/signal32.c
 create mode 100644 arch/arm64/kernel/sys32.S
 create mode 100644 arch/arm64/kernel/sys_compat.c

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
new file mode 100644
index 0000000..a670a33
--- /dev/null
+++ b/arch/arm64/include/asm/compat.h
@@ -0,0 +1,242 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_COMPAT_H
+#define __ASM_COMPAT_H
+#ifdef __KERNEL__
+#ifdef CONFIG_COMPAT
+
+/*
+ * Architecture specific compatibility types
+ */
+#include <linux/types.h>
+#include <linux/sched.h>
+
+#define COMPAT_USER_HZ		100
+#define COMPAT_UTS_MACHINE	"armv8l\0\0"
+
+typedef u32		compat_size_t;
+typedef s32		compat_ssize_t;
+typedef s32		compat_time_t;
+typedef s32		compat_clock_t;
+typedef s32		compat_pid_t;
+typedef u32		__compat_uid_t;
+typedef u32		__compat_gid_t;
+typedef u32		__compat_uid32_t;
+typedef u32		__compat_gid32_t;
+typedef u32		compat_mode_t;
+typedef u32		compat_ino_t;
+typedef u32		compat_dev_t;
+typedef s32		compat_off_t;
+typedef s64		compat_loff_t;
+typedef s16		compat_nlink_t;
+typedef u16		compat_ipc_pid_t;
+typedef s32		compat_daddr_t;
+typedef u32		compat_caddr_t;
+typedef __kernel_fsid_t	compat_fsid_t;
+typedef s32		compat_key_t;
+typedef s32		compat_timer_t;
+
+typedef s32		compat_int_t;
+typedef s32		compat_long_t;
+typedef s64		compat_s64;
+typedef u32		compat_uint_t;
+typedef u32		compat_ulong_t;
+typedef u64		compat_u64;
+
+struct compat_timespec {
+	compat_time_t	tv_sec;
+	s32		tv_nsec;
+};
+
+struct compat_timeval {
+	compat_time_t	tv_sec;
+	s32		tv_usec;
+};
+
+struct compat_stat {
+	compat_dev_t	st_dev;
+	compat_ino_t	st_ino;
+	compat_mode_t	st_mode;
+	compat_nlink_t	st_nlink;
+	__compat_uid32_t	st_uid;
+	__compat_gid32_t	st_gid;
+	compat_dev_t	st_rdev;
+	compat_off_t	st_size;
+	compat_off_t	st_blksize;
+	compat_off_t	st_blocks;
+	compat_time_t	st_atime;
+	u32		st_atime_nsec;
+	compat_time_t	st_mtime;
+	u32		st_mtime_nsec;
+	compat_time_t	st_ctime;
+	u32		st_ctime_nsec;
+	u32		__unused4[2];
+};
+
+struct compat_flock {
+	short		l_type;
+	short		l_whence;
+	compat_off_t	l_start;
+	compat_off_t	l_len;
+	compat_pid_t	l_pid;
+};
+
+#define F_GETLK64	12	/*  using 'struct flock64' */
+#define F_SETLK64	13
+#define F_SETLKW64	14
+
+struct compat_flock64 {
+	short		l_type;
+	short		l_whence;
+	compat_loff_t	l_start;
+	compat_loff_t	l_len;
+	compat_pid_t	l_pid;
+};
+
+struct compat_statfs {
+	int		f_type;
+	int		f_bsize;
+	int		f_blocks;
+	int		f_bfree;
+	int		f_bavail;
+	int		f_files;
+	int		f_ffree;
+	compat_fsid_t	f_fsid;
+	int		f_namelen;	/* SunOS ignores this field. */
+	int		f_frsize;
+	int		f_flags;
+	int		f_spare[4];
+};
+
+#define COMPAT_RLIM_INFINITY		0xffffffff
+
+typedef u32		compat_old_sigset_t;
+
+#define _COMPAT_NSIG		64
+#define _COMPAT_NSIG_BPW	32
+
+typedef u32		compat_sigset_word;
+
+#define COMPAT_OFF_T_MAX	0x7fffffff
+#define COMPAT_LOFF_T_MAX	0x7fffffffffffffffL
+
+/*
+ * A pointer passed in from user mode. This should not
+ * be used for syscall parameters, just declare them
+ * as pointers because the syscall entry code will have
+ * appropriately converted them already.
+ */
+typedef	u32		compat_uptr_t;
+
+static inline void __user *compat_ptr(compat_uptr_t uptr)
+{
+	return (void __user *)(unsigned long)uptr;
+}
+
+static inline compat_uptr_t ptr_to_compat(void __user *uptr)
+{
+	return (u32)(unsigned long)uptr;
+}
+
+static inline void __user *arch_compat_alloc_user_space(long len)
+{
+	struct pt_regs *regs = task_pt_regs(current);
+	return (void __user *)regs->compat_sp - len;
+}
+
+struct compat_ipc64_perm {
+	compat_key_t key;
+	__compat_uid32_t uid;
+	__compat_gid32_t gid;
+	__compat_uid32_t cuid;
+	__compat_gid32_t cgid;
+	unsigned short mode;
+	unsigned short __pad1;
+	unsigned short seq;
+	unsigned short __pad2;
+	compat_ulong_t unused1;
+	compat_ulong_t unused2;
+};
+
+struct compat_semid64_ds {
+	struct compat_ipc64_perm sem_perm;
+	compat_time_t  sem_otime;
+	compat_ulong_t __unused1;
+	compat_time_t  sem_ctime;
+	compat_ulong_t __unused2;
+	compat_ulong_t sem_nsems;
+	compat_ulong_t __unused3;
+	compat_ulong_t __unused4;
+};
+
+struct compat_msqid64_ds {
+	struct compat_ipc64_perm msg_perm;
+	compat_time_t  msg_stime;
+	compat_ulong_t __unused1;
+	compat_time_t  msg_rtime;
+	compat_ulong_t __unused2;
+	compat_time_t  msg_ctime;
+	compat_ulong_t __unused3;
+	compat_ulong_t msg_cbytes;
+	compat_ulong_t msg_qnum;
+	compat_ulong_t msg_qbytes;
+	compat_pid_t   msg_lspid;
+	compat_pid_t   msg_lrpid;
+	compat_ulong_t __unused4;
+	compat_ulong_t __unused5;
+};
+
+struct compat_shmid64_ds {
+	struct compat_ipc64_perm shm_perm;
+	compat_size_t  shm_segsz;
+	compat_time_t  shm_atime;
+	compat_ulong_t __unused1;
+	compat_time_t  shm_dtime;
+	compat_ulong_t __unused2;
+	compat_time_t  shm_ctime;
+	compat_ulong_t __unused3;
+	compat_pid_t   shm_cpid;
+	compat_pid_t   shm_lpid;
+	compat_ulong_t shm_nattch;
+	compat_ulong_t __unused4;
+	compat_ulong_t __unused5;
+};
+
+static inline int is_compat_task(void)
+{
+	return test_thread_flag(TIF_32BIT);
+}
+
+static inline int is_compat_thread(struct thread_info *thread)
+{
+	return test_ti_thread_flag(thread, TIF_32BIT);
+}
+
+#else /* !CONFIG_COMPAT */
+
+static inline int is_compat_task(void)
+{
+	return 0;
+}
+
+static inline int is_compat_thread(struct thread_info *thread)
+{
+	return 0;
+}
+
+#endif /* CONFIG_COMPAT */
+#endif /* __KERNEL__ */
+#endif /* __ASM_COMPAT_H */
diff --git a/arch/arm64/include/asm/signal32.h b/arch/arm64/include/asm/signal32.h
new file mode 100644
index 0000000..7c275e3
--- /dev/null
+++ b/arch/arm64/include/asm/signal32.h
@@ -0,0 +1,53 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_SIGNAL32_H
+#define __ASM_SIGNAL32_H
+
+#ifdef __KERNEL__
+#ifdef CONFIG_COMPAT
+#include <linux/compat.h>
+
+#define AARCH32_KERN_SIGRET_CODE_OFFSET	0x500
+
+extern const compat_ulong_t aarch32_sigret_code[6];
+
+int compat_setup_frame(int usig, struct k_sigaction *ka, sigset_t *set,
+		       struct pt_regs *regs);
+int compat_setup_rt_frame(int usig, struct k_sigaction *ka, siginfo_t *info,
+			  sigset_t *set, struct pt_regs *regs);
+
+void compat_setup_restart_syscall(struct pt_regs *regs);
+#else
+
+static inline int compat_setup_frame(int usid, struct k_sigaction *ka,
+				     sigset_t *set, struct pt_regs *regs)
+{
+	return -ENOSYS;
+}
+
+static inline int compat_setup_rt_frame(int usig, struct k_sigaction *ka,
+					siginfo_t *info, sigset_t *set,
+					struct pt_regs *regs)
+{
+	return -ENOSYS;
+}
+
+static inline void compat_setup_restart_syscall(struct pt_regs *regs)
+{
+}
+#endif /* CONFIG_COMPAT */
+#endif /* __KERNEL__ */
+#endif /* __ASM_SIGNAL32_H */
diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
new file mode 100644
index 0000000..a50405f
--- /dev/null
+++ b/arch/arm64/include/asm/unistd32.h
@@ -0,0 +1,758 @@
+/*
+ * Based on arch/arm/include/asm/unistd.h
+ *
+ * Copyright (C) 2001-2005 Russell King
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#if !defined(__ASM_UNISTD32_H) || defined(__SYSCALL)
+#define __ASM_UNISTD32_H
+
+#ifndef __SYSCALL
+#define __SYSCALL(x, y)
+#endif
+
+/*
+ * This file contains the system call numbers.
+ */
+
+#ifdef __SYSCALL_COMPAT
+
+#define __NR_restart_syscall		0
+__SYSCALL(__NR_restart_syscall, sys_restart_syscall)
+#define __NR_exit			1
+__SYSCALL(__NR_exit, sys_exit)
+#define __NR_fork			2
+__SYSCALL(__NR_fork, sys_fork)
+#define __NR_read			3
+__SYSCALL(__NR_read, sys_read)
+#define __NR_write			4
+__SYSCALL(__NR_write, sys_write)
+#define __NR_open			5
+__SYSCALL(__NR_open, sys_open)
+#define __NR_close			6
+__SYSCALL(__NR_close, sys_close)
+__SYSCALL(7, sys_ni_syscall)		/* 7 was sys_waitpid */
+#define __NR_creat			8
+__SYSCALL(__NR_creat, sys_creat)
+#define __NR_link			9
+__SYSCALL(__NR_link, sys_link)
+#define __NR_unlink			10
+__SYSCALL(__NR_unlink, sys_unlink)
+#define __NR_execve			11
+__SYSCALL(__NR_execve, sys_execve)
+#define __NR_chdir			12
+__SYSCALL(__NR_chdir, sys_chdir)
+__SYSCALL(13, sys_ni_syscall)		/* 13 was sys_time */
+#define __NR_mknod			14
+__SYSCALL(__NR_mknod, sys_mknod)
+#define __NR_chmod			15
+__SYSCALL(__NR_chmod, sys_chmod)
+#define __NR_lchown			16
+__SYSCALL(__NR_lchown, sys_lchown16)
+__SYSCALL(17, sys_ni_syscall)		/* 17 was sys_break */
+__SYSCALL(18, sys_ni_syscall)		/* 18 was sys_stat */
+#define __NR_lseek			19
+__SYSCALL(__NR_lseek, sys_lseek)
+#define __NR_getpid			20
+__SYSCALL(__NR_getpid, sys_getpid)
+#define __NR_mount			21
+__SYSCALL(__NR_mount, sys_mount)
+__SYSCALL(22, sys_ni_syscall)		/* 22 was sys_umount */
+#define __NR_setuid			23
+__SYSCALL(__NR_setuid, sys_setuid16)
+#define __NR_getuid			24
+__SYSCALL(__NR_getuid, sys_getuid16)
+__SYSCALL(25, sys_ni_syscall)		/* 25 was sys_stime */
+#define __NR_ptrace			26
+__SYSCALL(__NR_ptrace, sys_ptrace)
+__SYSCALL(27, sys_ni_syscall)		/* 27 was sys_alarm */
+__SYSCALL(28, sys_ni_syscall)		/* 28 was sys_fstat */
+#define __NR_pause			29
+__SYSCALL(__NR_pause, sys_pause)
+__SYSCALL(30, sys_ni_syscall)		/* 30 was sys_utime */
+__SYSCALL(31, sys_ni_syscall)		/* 31 was sys_stty */
+__SYSCALL(32, sys_ni_syscall)		/* 32 was sys_gtty */
+#define __NR_access			33
+__SYSCALL(__NR_access, sys_access)
+#define __NR_nice			34
+__SYSCALL(__NR_nice, sys_nice)
+__SYSCALL(35, sys_ni_syscall)		/* 35 was sys_ftime */
+#define __NR_sync			36
+__SYSCALL(__NR_sync, sys_sync)
+#define __NR_kill			37
+__SYSCALL(__NR_kill, sys_kill)
+#define __NR_rename			38
+__SYSCALL(__NR_rename, sys_rename)
+#define __NR_mkdir			39
+__SYSCALL(__NR_mkdir, sys_mkdir)
+#define __NR_rmdir			40
+__SYSCALL(__NR_rmdir, sys_rmdir)
+#define __NR_dup			41
+__SYSCALL(__NR_dup, sys_dup)
+#define __NR_pipe			42
+__SYSCALL(__NR_pipe, sys_pipe)
+#define __NR_times			43
+__SYSCALL(__NR_times, sys_times)
+__SYSCALL(44, sys_ni_syscall)		/* 44 was sys_prof */
+#define __NR_brk			45
+__SYSCALL(__NR_brk, sys_brk)
+#define __NR_setgid			46
+__SYSCALL(__NR_setgid, sys_setgid16)
+#define __NR_getgid			47
+__SYSCALL(__NR_getgid, sys_getgid16)
+__SYSCALL(48, sys_ni_syscall)		/* 48 was sys_signal */
+#define __NR_geteuid			49
+__SYSCALL(__NR_geteuid, sys_geteuid16)
+#define __NR_getegid			50
+__SYSCALL(__NR_getegid, sys_getegid16)
+#define __NR_acct			51
+__SYSCALL(__NR_acct, sys_acct)
+#define __NR_umount2			52
+__SYSCALL(__NR_umount2, sys_umount)
+__SYSCALL(53, sys_ni_syscall)		/* 53 was sys_lock */
+#define __NR_ioctl			54
+__SYSCALL(__NR_ioctl, sys_ioctl)
+#define __NR_fcntl			55
+__SYSCALL(__NR_fcntl, sys_fcntl)
+__SYSCALL(56, sys_ni_syscall)		/* 56 was sys_mpx */
+#define __NR_setpgid			57
+__SYSCALL(__NR_setpgid, sys_setpgid)
+__SYSCALL(58, sys_ni_syscall)		/* 58 was sys_ulimit */
+__SYSCALL(59, sys_ni_syscall)		/* 59 was sys_olduname */
+#define __NR_umask			60
+__SYSCALL(__NR_umask, sys_umask)
+#define __NR_chroot			61
+__SYSCALL(__NR_chroot, sys_chroot)
+#define __NR_ustat			62
+__SYSCALL(__NR_ustat, sys_ustat)
+#define __NR_dup2			63
+__SYSCALL(__NR_dup2, sys_dup2)
+#define __NR_getppid			64
+__SYSCALL(__NR_getppid, sys_getppid)
+#define __NR_getpgrp			65
+__SYSCALL(__NR_getpgrp, sys_getpgrp)
+#define __NR_setsid			66
+__SYSCALL(__NR_setsid, sys_setsid)
+#define __NR_sigaction			67
+__SYSCALL(__NR_sigaction, sys_sigaction)
+__SYSCALL(68, sys_ni_syscall)		/* 68 was sys_sgetmask */
+__SYSCALL(69, sys_ni_syscall)		/* 69 was sys_ssetmask */
+#define __NR_setreuid			70
+__SYSCALL(__NR_setreuid, sys_setreuid16)
+#define __NR_setregid			71
+__SYSCALL(__NR_setregid, sys_setregid16)
+#define __NR_sigsuspend			72
+__SYSCALL(__NR_sigsuspend, sys_sigsuspend)
+#define __NR_sigpending			73
+__SYSCALL(__NR_sigpending, sys_sigpending)
+#define __NR_sethostname		74
+__SYSCALL(__NR_sethostname, sys_sethostname)
+#define __NR_setrlimit			75
+__SYSCALL(__NR_setrlimit, sys_setrlimit)
+__SYSCALL(76, sys_ni_syscall)		/* 76 was sys_getrlimit */
+#define __NR_getrusage			77
+__SYSCALL(__NR_getrusage, sys_getrusage)
+#define __NR_gettimeofday		78
+__SYSCALL(__NR_gettimeofday, sys_gettimeofday)
+#define __NR_settimeofday		79
+__SYSCALL(__NR_settimeofday, sys_settimeofday)
+#define __NR_getgroups			80
+__SYSCALL(__NR_getgroups, sys_getgroups16)
+#define __NR_setgroups			81
+__SYSCALL(__NR_setgroups, sys_setgroups16)
+__SYSCALL(82, sys_ni_syscall)		/* 82 was sys_select */
+#define __NR_symlink			83
+__SYSCALL(__NR_symlink, sys_symlink)
+__SYSCALL(84, sys_ni_syscall)		/* 84 was sys_lstat */
+#define __NR_readlink			85
+__SYSCALL(__NR_readlink, sys_readlink)
+#define __NR_uselib			86
+__SYSCALL(__NR_uselib, sys_uselib)
+#define __NR_swapon			87
+__SYSCALL(__NR_swapon, sys_swapon)
+#define __NR_reboot			88
+__SYSCALL(__NR_reboot, sys_reboot)
+__SYSCALL(89, sys_ni_syscall)		/* 89 was sys_readdir */
+__SYSCALL(90, sys_ni_syscall)		/* 90 was sys_mmap */
+#define __NR_munmap			91
+__SYSCALL(__NR_munmap, sys_munmap)
+#define __NR_truncate			92
+__SYSCALL(__NR_truncate, sys_truncate)
+#define __NR_ftruncate			93
+__SYSCALL(__NR_ftruncate, sys_ftruncate)
+#define __NR_fchmod			94
+__SYSCALL(__NR_fchmod, sys_fchmod)
+#define __NR_fchown			95
+__SYSCALL(__NR_fchown, sys_fchown16)
+#define __NR_getpriority		96
+__SYSCALL(__NR_getpriority, sys_getpriority)
+#define __NR_setpriority		97
+__SYSCALL(__NR_setpriority, sys_setpriority)
+__SYSCALL(98, sys_ni_syscall)		/* 98 was sys_profil */
+#define __NR_statfs			99
+__SYSCALL(__NR_statfs, sys_statfs)
+#define __NR_fstatfs			100
+__SYSCALL(__NR_fstatfs, sys_fstatfs)
+__SYSCALL(101, sys_ni_syscall)		/* 101 was sys_ioperm */
+__SYSCALL(102, sys_ni_syscall)		/* 102 was sys_socketcall */
+#define __NR_syslog			103
+__SYSCALL(__NR_syslog, sys_syslog)
+#define __NR_setitimer			104
+__SYSCALL(__NR_setitimer, sys_setitimer)
+#define __NR_getitimer			105
+__SYSCALL(__NR_getitimer, sys_getitimer)
+#define __NR_stat			106
+__SYSCALL(__NR_stat, sys_newstat)
+#define __NR_lstat			107
+__SYSCALL(__NR_lstat, sys_newlstat)
+#define __NR_fstat			108
+__SYSCALL(__NR_fstat, sys_newfstat)
+__SYSCALL(109, sys_ni_syscall)		/* 109 was sys_uname */
+__SYSCALL(110, sys_ni_syscall)		/* 110 was sys_iopl */
+#define __NR_vhangup			111
+__SYSCALL(__NR_vhangup, sys_vhangup)
+__SYSCALL(112, sys_ni_syscall)		/* 112 was sys_idle */
+__SYSCALL(113, sys_ni_syscall)		/* 113 was sys_syscall */
+#define __NR_wait4			114
+__SYSCALL(__NR_wait4, sys_wait4)
+#define __NR_swapoff			115
+__SYSCALL(__NR_swapoff, sys_swapoff)
+#define __NR_sysinfo			116
+__SYSCALL(__NR_sysinfo, sys_sysinfo)
+__SYSCALL(117, sys_ni_syscall)		/* 117 was sys_ipc */
+#define __NR_fsync			118
+__SYSCALL(__NR_fsync, sys_fsync)
+#define __NR_sigreturn			119
+__SYSCALL(__NR_sigreturn, sys_sigreturn)
+#define __NR_clone			120
+__SYSCALL(__NR_clone, sys_clone)
+#define __NR_setdomainname		121
+__SYSCALL(__NR_setdomainname, sys_setdomainname)
+#define __NR_uname			122
+__SYSCALL(__NR_uname, sys_newuname)
+__SYSCALL(123, sys_ni_syscall)		/* 123 was sys_modify_ldt */
+#define __NR_adjtimex			124
+__SYSCALL(__NR_adjtimex, sys_adjtimex)
+#define __NR_mprotect			125
+__SYSCALL(__NR_mprotect, sys_mprotect)
+#define __NR_sigprocmask		126
+__SYSCALL(__NR_sigprocmask, sys_sigprocmask)
+__SYSCALL(127, sys_ni_syscall)		/* 127 was sys_create_module */
+#define __NR_init_module		128
+__SYSCALL(__NR_init_module, sys_init_module)
+#define __NR_delete_module		129
+__SYSCALL(__NR_delete_module, sys_delete_module)
+__SYSCALL(130, sys_ni_syscall)		/* 130 was sys_get_kernel_syms */
+#define __NR_quotactl			131
+__SYSCALL(__NR_quotactl, sys_quotactl)
+#define __NR_getpgid			132
+__SYSCALL(__NR_getpgid, sys_getpgid)
+#define __NR_fchdir			133
+__SYSCALL(__NR_fchdir, sys_fchdir)
+#define __NR_bdflush			134
+__SYSCALL(__NR_bdflush, sys_bdflush)
+#define __NR_sysfs			135
+__SYSCALL(__NR_sysfs, sys_sysfs)
+#define __NR_personality		136
+__SYSCALL(__NR_personality, sys_personality)
+__SYSCALL(137, sys_ni_syscall)		/* 137 was sys_afs_syscall */
+#define __NR_setfsuid			138
+__SYSCALL(__NR_setfsuid, sys_setfsuid16)
+#define __NR_setfsgid			139
+__SYSCALL(__NR_setfsgid, sys_setfsgid16)
+#define __NR__llseek			140
+__SYSCALL(__NR__llseek, sys_llseek)
+#define __NR_getdents			141
+__SYSCALL(__NR_getdents, sys_getdents)
+#define __NR__newselect			142
+__SYSCALL(__NR__newselect, sys_select)
+#define __NR_flock			143
+__SYSCALL(__NR_flock, sys_flock)
+#define __NR_msync			144
+__SYSCALL(__NR_msync, sys_msync)
+#define __NR_readv			145
+__SYSCALL(__NR_readv, sys_readv)
+#define __NR_writev			146
+__SYSCALL(__NR_writev, sys_writev)
+#define __NR_getsid			147
+__SYSCALL(__NR_getsid, sys_getsid)
+#define __NR_fdatasync			148
+__SYSCALL(__NR_fdatasync, sys_fdatasync)
+#define __NR__sysctl			149
+__SYSCALL(__NR__sysctl, sys_sysctl)
+#define __NR_mlock			150
+__SYSCALL(__NR_mlock, sys_mlock)
+#define __NR_munlock			151
+__SYSCALL(__NR_munlock, sys_munlock)
+#define __NR_mlockall			152
+__SYSCALL(__NR_mlockall, sys_mlockall)
+#define __NR_munlockall			153
+__SYSCALL(__NR_munlockall, sys_munlockall)
+#define __NR_sched_setparam		154
+__SYSCALL(__NR_sched_setparam, sys_sched_setparam)
+#define __NR_sched_getparam		155
+__SYSCALL(__NR_sched_getparam, sys_sched_getparam)
+#define __NR_sched_setscheduler		156
+__SYSCALL(__NR_sched_setscheduler, sys_sched_setscheduler)
+#define __NR_sched_getscheduler		157
+__SYSCALL(__NR_sched_getscheduler, sys_sched_getscheduler)
+#define __NR_sched_yield		158
+__SYSCALL(__NR_sched_yield, sys_sched_yield)
+#define __NR_sched_get_priority_max	159
+__SYSCALL(__NR_sched_get_priority_max, sys_sched_get_priority_max)
+#define __NR_sched_get_priority_min	160
+__SYSCALL(__NR_sched_get_priority_min, sys_sched_get_priority_min)
+#define __NR_sched_rr_get_interval	161
+__SYSCALL(__NR_sched_rr_get_interval, sys_sched_rr_get_interval)
+#define __NR_nanosleep			162
+__SYSCALL(__NR_nanosleep, sys_nanosleep)
+#define __NR_mremap			163
+__SYSCALL(__NR_mremap, sys_mremap)
+#define __NR_setresuid			164
+__SYSCALL(__NR_setresuid, sys_setresuid16)
+#define __NR_getresuid			165
+__SYSCALL(__NR_getresuid, sys_getresuid16)
+__SYSCALL(166, sys_ni_syscall)		/* 166 was sys_vm86 */
+__SYSCALL(167, sys_ni_syscall)		/* 167 was sys_query_module */
+#define __NR_poll			168
+__SYSCALL(__NR_poll, sys_poll)
+#define __NR_nfsservctl			169
+__SYSCALL(__NR_nfsservctl, sys_ni_syscall)
+#define __NR_setresgid			170
+__SYSCALL(__NR_setresgid, sys_setresgid16)
+#define __NR_getresgid			171
+__SYSCALL(__NR_getresgid, sys_getresgid16)
+#define __NR_prctl			172
+__SYSCALL(__NR_prctl, sys_prctl)
+#define __NR_rt_sigreturn		173
+__SYSCALL(__NR_rt_sigreturn, sys_rt_sigreturn)
+#define __NR_rt_sigaction		174
+__SYSCALL(__NR_rt_sigaction, sys_rt_sigaction)
+#define __NR_rt_sigprocmask		175
+__SYSCALL(__NR_rt_sigprocmask, sys_rt_sigprocmask)
+#define __NR_rt_sigpending		176
+__SYSCALL(__NR_rt_sigpending, sys_rt_sigpending)
+#define __NR_rt_sigtimedwait		177
+__SYSCALL(__NR_rt_sigtimedwait, sys_rt_sigtimedwait)
+#define __NR_rt_sigqueueinfo		178
+__SYSCALL(__NR_rt_sigqueueinfo, sys_rt_sigqueueinfo)
+#define __NR_rt_sigsuspend		179
+__SYSCALL(__NR_rt_sigsuspend, sys_rt_sigsuspend)
+#define __NR_pread64			180
+__SYSCALL(__NR_pread64, sys_pread64)
+#define __NR_pwrite64			181
+__SYSCALL(__NR_pwrite64, sys_pwrite64)
+#define __NR_chown			182
+__SYSCALL(__NR_chown, sys_chown16)
+#define __NR_getcwd			183
+__SYSCALL(__NR_getcwd, sys_getcwd)
+#define __NR_capget			184
+__SYSCALL(__NR_capget, sys_capget)
+#define __NR_capset			185
+__SYSCALL(__NR_capset, sys_capset)
+#define __NR_sigaltstack		186
+__SYSCALL(__NR_sigaltstack, sys_sigaltstack)
+#define __NR_sendfile			187
+__SYSCALL(__NR_sendfile, sys_sendfile)
+__SYSCALL(188, sys_ni_syscall)		/* 188 reserved */
+__SYSCALL(189, sys_ni_syscall)		/* 189 reserved */
+#define __NR_vfork			190
+__SYSCALL(__NR_vfork, sys_vfork)
+#define __NR_ugetrlimit			191	/* SuS compliant getrlimit */
+__SYSCALL(__NR_ugetrlimit, sys_getrlimit)
+#define __NR_mmap2			192
+__SYSCALL(__NR_mmap2, sys_mmap2)
+#define __NR_truncate64			193
+__SYSCALL(__NR_truncate64, sys_truncate64)
+#define __NR_ftruncate64		194
+__SYSCALL(__NR_ftruncate64, sys_ftruncate64)
+#define __NR_stat64			195
+__SYSCALL(__NR_stat64, sys_stat64)
+#define __NR_lstat64			196
+__SYSCALL(__NR_lstat64, sys_lstat64)
+#define __NR_fstat64			197
+__SYSCALL(__NR_fstat64, sys_fstat64)
+#define __NR_lchown32			198
+__SYSCALL(__NR_lchown32, sys_lchown)
+#define __NR_getuid32			199
+__SYSCALL(__NR_getuid32, sys_getuid)
+#define __NR_getgid32			200
+__SYSCALL(__NR_getgid32, sys_getgid)
+#define __NR_geteuid32			201
+__SYSCALL(__NR_geteuid32, sys_geteuid)
+#define __NR_getegid32			202
+__SYSCALL(__NR_getegid32, sys_getegid)
+#define __NR_setreuid32			203
+__SYSCALL(__NR_setreuid32, sys_setreuid)
+#define __NR_setregid32			204
+__SYSCALL(__NR_setregid32, sys_setregid)
+#define __NR_getgroups32		205
+__SYSCALL(__NR_getgroups32, sys_getgroups)
+#define __NR_setgroups32		206
+__SYSCALL(__NR_setgroups32, sys_setgroups)
+#define __NR_fchown32			207
+__SYSCALL(__NR_fchown32, sys_fchown)
+#define __NR_setresuid32		208
+__SYSCALL(__NR_setresuid32, sys_setresuid)
+#define __NR_getresuid32		209
+__SYSCALL(__NR_getresuid32, sys_getresuid)
+#define __NR_setresgid32		210
+__SYSCALL(__NR_setresgid32, sys_setresgid)
+#define __NR_getresgid32		211
+__SYSCALL(__NR_getresgid32, sys_getresgid)
+#define __NR_chown32			212
+__SYSCALL(__NR_chown32, sys_chown)
+#define __NR_setuid32			213
+__SYSCALL(__NR_setuid32, sys_setuid)
+#define __NR_setgid32			214
+__SYSCALL(__NR_setgid32, sys_setgid)
+#define __NR_setfsuid32			215
+__SYSCALL(__NR_setfsuid32, sys_setfsuid)
+#define __NR_setfsgid32			216
+__SYSCALL(__NR_setfsgid32, sys_setfsgid)
+#define __NR_getdents64			217
+__SYSCALL(__NR_getdents64, sys_getdents64)
+#define __NR_pivot_root			218
+__SYSCALL(__NR_pivot_root, sys_pivot_root)
+#define __NR_mincore			219
+__SYSCALL(__NR_mincore, sys_mincore)
+#define __NR_madvise			220
+__SYSCALL(__NR_madvise, sys_madvise)
+#define __NR_fcntl64			221
+__SYSCALL(__NR_fcntl64, sys_fcntl64)
+__SYSCALL(222, sys_ni_syscall)		/* 222 for tux */
+__SYSCALL(223, sys_ni_syscall)		/* 223 is unused */
+#define __NR_gettid			224
+__SYSCALL(__NR_gettid, sys_gettid)
+#define __NR_readahead			225
+__SYSCALL(__NR_readahead, sys_readahead)
+#define __NR_setxattr			226
+__SYSCALL(__NR_setxattr, sys_setxattr)
+#define __NR_lsetxattr			227
+__SYSCALL(__NR_lsetxattr, sys_lsetxattr)
+#define __NR_fsetxattr			228
+__SYSCALL(__NR_fsetxattr, sys_fsetxattr)
+#define __NR_getxattr			229
+__SYSCALL(__NR_getxattr, sys_getxattr)
+#define __NR_lgetxattr			230
+__SYSCALL(__NR_lgetxattr, sys_lgetxattr)
+#define __NR_fgetxattr			231
+__SYSCALL(__NR_fgetxattr, sys_fgetxattr)
+#define __NR_listxattr			232
+__SYSCALL(__NR_listxattr, sys_listxattr)
+#define __NR_llistxattr			233
+__SYSCALL(__NR_llistxattr, sys_llistxattr)
+#define __NR_flistxattr			234
+__SYSCALL(__NR_flistxattr, sys_flistxattr)
+#define __NR_removexattr		235
+__SYSCALL(__NR_removexattr, sys_removexattr)
+#define __NR_lremovexattr		236
+__SYSCALL(__NR_lremovexattr, sys_lremovexattr)
+#define __NR_fremovexattr		237
+__SYSCALL(__NR_fremovexattr, sys_fremovexattr)
+#define __NR_tkill			238
+__SYSCALL(__NR_tkill, sys_tkill)
+#define __NR_sendfile64			239
+__SYSCALL(__NR_sendfile64, sys_sendfile64)
+#define __NR_futex			240
+__SYSCALL(__NR_futex, sys_futex)
+#define __NR_sched_setaffinity		241
+__SYSCALL(__NR_sched_setaffinity, sys_sched_setaffinity)
+#define __NR_sched_getaffinity		242
+__SYSCALL(__NR_sched_getaffinity, sys_sched_getaffinity)
+#define __NR_io_setup			243
+__SYSCALL(__NR_io_setup, sys_io_setup)
+#define __NR_io_destroy			244
+__SYSCALL(__NR_io_destroy, sys_io_destroy)
+#define __NR_io_getevents		245
+__SYSCALL(__NR_io_getevents, sys_io_getevents)
+#define __NR_io_submit			246
+__SYSCALL(__NR_io_submit, sys_io_submit)
+#define __NR_io_cancel			247
+__SYSCALL(__NR_io_cancel, sys_io_cancel)
+#define __NR_exit_group			248
+__SYSCALL(__NR_exit_group, sys_exit_group)
+#define __NR_lookup_dcookie		249
+__SYSCALL(__NR_lookup_dcookie, sys_lookup_dcookie)
+#define __NR_epoll_create		250
+__SYSCALL(__NR_epoll_create, sys_epoll_create)
+#define __NR_epoll_ctl			251
+__SYSCALL(__NR_epoll_ctl, sys_epoll_ctl)
+#define __NR_epoll_wait			252
+__SYSCALL(__NR_epoll_wait, sys_epoll_wait)
+#define __NR_remap_file_pages		253
+__SYSCALL(__NR_remap_file_pages, sys_remap_file_pages)
+__SYSCALL(254, sys_ni_syscall)		/* 254 for set_thread_area */
+__SYSCALL(255, sys_ni_syscall)		/* 255 for get_thread_area */
+#define __NR_set_tid_address		256
+__SYSCALL(__NR_set_tid_address, sys_set_tid_address)
+#define __NR_timer_create		257
+__SYSCALL(__NR_timer_create, sys_timer_create)
+#define __NR_timer_settime		258
+__SYSCALL(__NR_timer_settime, sys_timer_settime)
+#define __NR_timer_gettime		259
+__SYSCALL(__NR_timer_gettime, sys_timer_gettime)
+#define __NR_timer_getoverrun		260
+__SYSCALL(__NR_timer_getoverrun, sys_timer_getoverrun)
+#define __NR_timer_delete		261
+__SYSCALL(__NR_timer_delete, sys_timer_delete)
+#define __NR_clock_settime		262
+__SYSCALL(__NR_clock_settime, sys_clock_settime)
+#define __NR_clock_gettime		263
+__SYSCALL(__NR_clock_gettime, sys_clock_gettime)
+#define __NR_clock_getres		264
+__SYSCALL(__NR_clock_getres, sys_clock_getres)
+#define __NR_clock_nanosleep		265
+__SYSCALL(__NR_clock_nanosleep, sys_clock_nanosleep)
+#define __NR_statfs64			266
+__SYSCALL(__NR_statfs64, sys_statfs64)
+#define __NR_fstatfs64			267
+__SYSCALL(__NR_fstatfs64, sys_fstatfs64)
+#define __NR_tgkill			268
+__SYSCALL(__NR_tgkill, sys_tgkill)
+#define __NR_utimes			269
+__SYSCALL(__NR_utimes, sys_utimes)
+#define __NR_fadvise64			270
+__SYSCALL(__NR_fadvise64, sys_fadvise64_64)
+#define __NR_pciconfig_iobase		271
+__SYSCALL(__NR_pciconfig_iobase, sys_pciconfig_iobase)
+#define __NR_pciconfig_read		272
+__SYSCALL(__NR_pciconfig_read, sys_pciconfig_read)
+#define __NR_pciconfig_write		273
+__SYSCALL(__NR_pciconfig_write, sys_pciconfig_write)
+#define __NR_mq_open			274
+__SYSCALL(__NR_mq_open, sys_mq_open)
+#define __NR_mq_unlink			275
+__SYSCALL(__NR_mq_unlink, sys_mq_unlink)
+#define __NR_mq_timedsend		276
+__SYSCALL(__NR_mq_timedsend, sys_mq_timedsend)
+#define __NR_mq_timedreceive		277
+__SYSCALL(__NR_mq_timedreceive, sys_mq_timedreceive)
+#define __NR_mq_notify			278
+__SYSCALL(__NR_mq_notify, sys_mq_notify)
+#define __NR_mq_getsetattr		279
+__SYSCALL(__NR_mq_getsetattr, sys_mq_getsetattr)
+#define __NR_waitid			280
+__SYSCALL(__NR_waitid, sys_waitid)
+#define __NR_socket			281
+__SYSCALL(__NR_socket, sys_socket)
+#define __NR_bind			282
+__SYSCALL(__NR_bind, sys_bind)
+#define __NR_connect			283
+__SYSCALL(__NR_connect, sys_connect)
+#define __NR_listen			284
+__SYSCALL(__NR_listen, sys_listen)
+#define __NR_accept			285
+__SYSCALL(__NR_accept, sys_accept)
+#define __NR_getsockname		286
+__SYSCALL(__NR_getsockname, sys_getsockname)
+#define __NR_getpeername		287
+__SYSCALL(__NR_getpeername, sys_getpeername)
+#define __NR_socketpair			288
+__SYSCALL(__NR_socketpair, sys_socketpair)
+#define __NR_send			289
+__SYSCALL(__NR_send, sys_send)
+#define __NR_sendto			290
+__SYSCALL(__NR_sendto, sys_sendto)
+#define __NR_recv			291
+__SYSCALL(__NR_recv, sys_recv)
+#define __NR_recvfrom			292
+__SYSCALL(__NR_recvfrom, sys_recvfrom)
+#define __NR_shutdown			293
+__SYSCALL(__NR_shutdown, sys_shutdown)
+#define __NR_setsockopt			294
+__SYSCALL(__NR_setsockopt, sys_setsockopt)
+#define __NR_getsockopt			295
+__SYSCALL(__NR_getsockopt, sys_getsockopt)
+#define __NR_sendmsg			296
+__SYSCALL(__NR_sendmsg, sys_sendmsg)
+#define __NR_recvmsg			297
+__SYSCALL(__NR_recvmsg, sys_recvmsg)
+#define __NR_semop			298
+__SYSCALL(__NR_semop, sys_semop)
+#define __NR_semget			299
+__SYSCALL(__NR_semget, sys_semget)
+#define __NR_semctl			300
+__SYSCALL(__NR_semctl, sys_semctl)
+#define __NR_msgsnd			301
+__SYSCALL(__NR_msgsnd, sys_msgsnd)
+#define __NR_msgrcv			302
+__SYSCALL(__NR_msgrcv, sys_msgrcv)
+#define __NR_msgget			303
+__SYSCALL(__NR_msgget, sys_msgget)
+#define __NR_msgctl			304
+__SYSCALL(__NR_msgctl, sys_msgctl)
+#define __NR_shmat			305
+__SYSCALL(__NR_shmat, sys_shmat)
+#define __NR_shmdt			306
+__SYSCALL(__NR_shmdt, sys_shmdt)
+#define __NR_shmget			307
+__SYSCALL(__NR_shmget, sys_shmget)
+#define __NR_shmctl			308
+__SYSCALL(__NR_shmctl, sys_shmctl)
+#define __NR_add_key			309
+__SYSCALL(__NR_add_key, sys_add_key)
+#define __NR_request_key		310
+__SYSCALL(__NR_request_key, sys_request_key)
+#define __NR_keyctl			311
+__SYSCALL(__NR_keyctl, sys_keyctl)
+#define __NR_semtimedop			312
+__SYSCALL(__NR_semtimedop, sys_semtimedop)
+#define __NR_vserver			313
+__SYSCALL(__NR_vserver, sys_ni_syscall)
+#define __NR_ioprio_set			314
+__SYSCALL(__NR_ioprio_set, sys_ioprio_set)
+#define __NR_ioprio_get			315
+__SYSCALL(__NR_ioprio_get, sys_ioprio_get)
+#define __NR_inotify_init		316
+__SYSCALL(__NR_inotify_init, sys_inotify_init)
+#define __NR_inotify_add_watch		317
+__SYSCALL(__NR_inotify_add_watch, sys_inotify_add_watch)
+#define __NR_inotify_rm_watch		318
+__SYSCALL(__NR_inotify_rm_watch, sys_inotify_rm_watch)
+#define __NR_mbind			319
+__SYSCALL(__NR_mbind, sys_mbind)
+#define __NR_get_mempolicy		320
+__SYSCALL(__NR_get_mempolicy, sys_get_mempolicy)
+#define __NR_set_mempolicy		321
+__SYSCALL(__NR_set_mempolicy, sys_set_mempolicy)
+#define __NR_openat			322
+__SYSCALL(__NR_openat, sys_openat)
+#define __NR_mkdirat			323
+__SYSCALL(__NR_mkdirat, sys_mkdirat)
+#define __NR_mknodat			324
+__SYSCALL(__NR_mknodat, sys_mknodat)
+#define __NR_fchownat			325
+__SYSCALL(__NR_fchownat, sys_fchownat)
+#define __NR_futimesat			326
+__SYSCALL(__NR_futimesat, sys_futimesat)
+#define __NR_fstatat64			327
+__SYSCALL(__NR_fstatat64, sys_fstatat64)
+#define __NR_unlinkat			328
+__SYSCALL(__NR_unlinkat, sys_unlinkat)
+#define __NR_renameat			329
+__SYSCALL(__NR_renameat, sys_renameat)
+#define __NR_linkat			330
+__SYSCALL(__NR_linkat, sys_linkat)
+#define __NR_symlinkat			331
+__SYSCALL(__NR_symlinkat, sys_symlinkat)
+#define __NR_readlinkat			332
+__SYSCALL(__NR_readlinkat, sys_readlinkat)
+#define __NR_fchmodat			333
+__SYSCALL(__NR_fchmodat, sys_fchmodat)
+#define __NR_faccessat			334
+__SYSCALL(__NR_faccessat, sys_faccessat)
+#define __NR_pselect6			335
+__SYSCALL(__NR_pselect6, sys_pselect6)
+#define __NR_ppoll			336
+__SYSCALL(__NR_ppoll, sys_ppoll)
+#define __NR_unshare			337
+__SYSCALL(__NR_unshare, sys_unshare)
+#define __NR_set_robust_list		338
+__SYSCALL(__NR_set_robust_list, sys_set_robust_list)
+#define __NR_get_robust_list		339
+__SYSCALL(__NR_get_robust_list, sys_get_robust_list)
+#define __NR_splice			340
+__SYSCALL(__NR_splice, sys_splice)
+#define __NR_sync_file_range2		341
+__SYSCALL(__NR_sync_file_range2, sys_sync_file_range2)
+#define __NR_tee			342
+__SYSCALL(__NR_tee, sys_tee)
+#define __NR_vmsplice			343
+__SYSCALL(__NR_vmsplice, sys_vmsplice)
+#define __NR_move_pages			344
+__SYSCALL(__NR_move_pages, sys_move_pages)
+#define __NR_getcpu			345
+__SYSCALL(__NR_getcpu, sys_getcpu)
+#define __NR_epoll_pwait		346
+__SYSCALL(__NR_epoll_pwait, sys_epoll_pwait)
+#define __NR_kexec_load			347
+__SYSCALL(__NR_kexec_load, sys_kexec_load)
+#define __NR_utimensat			348
+__SYSCALL(__NR_utimensat, sys_utimensat)
+#define __NR_signalfd			349
+__SYSCALL(__NR_signalfd, sys_signalfd)
+#define __NR_timerfd_create		350
+__SYSCALL(__NR_timerfd_create, sys_timerfd_create)
+#define __NR_eventfd			351
+__SYSCALL(__NR_eventfd, sys_eventfd)
+#define __NR_fallocate			352
+__SYSCALL(__NR_fallocate, sys_fallocate)
+#define __NR_timerfd_settime		353
+__SYSCALL(__NR_timerfd_settime, sys_timerfd_settime)
+#define __NR_timerfd_gettime		354
+__SYSCALL(__NR_timerfd_gettime, sys_timerfd_gettime)
+#define __NR_signalfd4			355
+__SYSCALL(__NR_signalfd4, sys_signalfd4)
+#define __NR_eventfd2			356
+__SYSCALL(__NR_eventfd2, sys_eventfd2)
+#define __NR_epoll_create1		357
+__SYSCALL(__NR_epoll_create1, sys_epoll_create1)
+#define __NR_dup3			358
+__SYSCALL(__NR_dup3, sys_dup3)
+#define __NR_pipe2			359
+__SYSCALL(__NR_pipe2, sys_pipe2)
+#define __NR_inotify_init1		360
+__SYSCALL(__NR_inotify_init1, sys_inotify_init1)
+#define __NR_preadv			361
+__SYSCALL(__NR_preadv, sys_preadv)
+#define __NR_pwritev			362
+__SYSCALL(__NR_pwritev, sys_pwritev)
+#define __NR_rt_tgsigqueueinfo		363
+__SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
+#define __NR_perf_event_open		364
+__SYSCALL(__NR_perf_event_open, sys_perf_event_open)
+#define __NR_recvmmsg			365
+__SYSCALL(__NR_recvmmsg, sys_recvmmsg)
+#define __NR_accept4			366
+__SYSCALL(__NR_accept4, sys_accept4)
+#define __NR_fanotify_init		367
+__SYSCALL(__NR_fanotify_init, sys_fanotify_init)
+#define __NR_fanotify_mark		368
+__SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
+#define __NR_prlimit64			369
+__SYSCALL(__NR_prlimit64, sys_prlimit64)
+#define __NR_name_to_handle_at		370
+__SYSCALL(__NR_name_to_handle_at, sys_name_to_handle_at)
+#define __NR_open_by_handle_at		371
+__SYSCALL(__NR_open_by_handle_at, sys_open_by_handle_at)
+#define __NR_clock_adjtime		372
+__SYSCALL(__NR_clock_adjtime, sys_clock_adjtime)
+#define __NR_syncfs			373
+__SYSCALL(__NR_syncfs, sys_syncfs)
+
+/*
+ * The following SVCs are ARM private.
+ */
+#define __ARM_NR_COMPAT_BASE		0x0f0000
+#define __ARM_NR_compat_cacheflush	(__ARM_NR_COMPAT_BASE+2)
+#define __ARM_NR_compat_set_tls		(__ARM_NR_COMPAT_BASE+5)
+
+#endif	/* __SYSCALL_COMPAT */
+
+#define __NR_compat_syscalls		374
+
+#define __ARCH_WANT_COMPAT_IPC_PARSE_VERSION
+#define __ARCH_WANT_COMPAT_STAT64
+#define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_PAUSE
+#define __ARCH_WANT_SYS_GETPGRP
+#define __ARCH_WANT_SYS_LLSEEK
+#define __ARCH_WANT_SYS_NICE
+#define __ARCH_WANT_SYS_SIGPENDING
+#define __ARCH_WANT_SYS_SIGPROCMASK
+#define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
+
+#endif /* __ASM_UNISTD32_H */
diff --git a/arch/arm64/kernel/kuser32.S b/arch/arm64/kernel/kuser32.S
new file mode 100644
index 0000000..7557737
--- /dev/null
+++ b/arch/arm64/kernel/kuser32.S
@@ -0,0 +1,77 @@
+/*
+ * Low-level user helpers placed in the vectors page for AArch32.
+ * Based on the kuser helpers in arch/arm/kernel/entry-armv.S.
+ *
+ * Copyright (C) 2005-2011 Nicolas Pitre <nico@cam.org>
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ *
+ * AArch32 user helpers.
+ *
+ * Each segment is 32-byte aligned and will be moved to the top of the high
+ * vector page.  New segments (if ever needed) must be added in front of
+ * existing ones.  This mechanism should be used only for things that are
+ * really small and justified, and not be abused freely.
+ *
+ * See Documentation/arm/kernel_user_helpers.txt for formal definitions.
+ */
+	.align	5
+	.globl	__kuser_helper_start
+__kuser_helper_start:
+
+__kuser_cmpxchg64:			// 0xffff0f60
+	.inst	0xe92d00f0		//	push		{r4, r5, r6, r7}
+	.inst	0xe1c040d0		//	ldrd		r4, r5, [r0]
+	.inst	0xe1c160d0		//	ldrd		r6, r7, [r1]
+	.inst	0xf57ff05f		//	dmb		sy
+	.inst	0xe1b20f9f		// 1:	ldrexd		r0, r1, [r2]
+	.inst	0xe0303004		//	eors		r3, r0, r4
+	.inst	0x00313005		//	eoreqs		r3, r1, r5
+	.inst	0x01a23f96		//	strexdeq	r3, r6, [r2]
+	.inst	0x03330001		//	teqeq		r3, #1
+	.inst	0x0afffff9		//	beq		1b
+	.inst	0xf57ff05f		//	dmb		sy
+	.inst	0xe2730000		//	rsbs		r0, r3, #0
+	.inst	0xe8bd00f0		//	pop		{r4, r5, r6, r7}
+	.inst	0xe12fff1e		//	bx		lr
+
+	.align	5
+__kuser_memory_barrier:			// 0xffff0fa0
+	.inst	0xf57ff05f		//	dmb		sy
+	.inst	0xe12fff1e		//	bx		lr
+
+	.align	5
+__kuser_cmpxchg:			// 0xffff0fc0
+	.inst	0xf57ff05f		//	dmb		sy
+	.inst	0xe1923f9f		// 1:	ldrex		r3, [r2]
+	.inst	0xe0533000		//	subs		r3, r3, r0
+	.inst	0x01823f91		//	strexeq	r3, r1, [r2]
+	.inst	0x03330001		//	teqeq		r3, #1
+	.inst	0x0afffffa		//	beq		1b
+	.inst	0xe2730000		//	rsbs		r0, r3, #0
+	.inst	0xeaffffef		//	b		<__kuser_memory_barrier>
+
+	.align	5
+__kuser_get_tls:			// 0xffff0fe0
+	.inst	0xee1d0f70		//	mrc		p15, 0, r0, c13, c0, 3
+	.inst	0xe12fff1e		//	bx		lr
+	.rep	5
+	.word	0
+	.endr
+
+__kuser_helper_version:			// 0xffff0ffc
+	.word	((__kuser_helper_end - __kuser_helper_start) >> 5)
+	.globl	__kuser_helper_end
+__kuser_helper_end:
diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
new file mode 100644
index 0000000..ac74c2f
--- /dev/null
+++ b/arch/arm64/kernel/signal32.c
@@ -0,0 +1,876 @@
+/*
+ * Based on arch/arm/kernel/signal.c
+ *
+ * Copyright (C) 1995-2009 Russell King
+ * Copyright (C) 2012 ARM Ltd.
+ * Modified by Will Deacon <will.deacon@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#define __SYSCALL_COMPAT
+
+#include <linux/compat.h>
+#include <linux/signal.h>
+#include <linux/syscalls.h>
+#include <linux/ratelimit.h>
+
+#include <asm/fpsimd.h>
+#include <asm/signal32.h>
+#include <asm/uaccess.h>
+#include <asm/unistd.h>
+
+typedef struct compat_siginfo {
+	int si_signo;
+	int si_errno;
+	int si_code;
+
+	union {
+		/* The padding is the same size as AArch64. */
+		int _pad[SI_PAD_SIZE];
+
+		/* kill() */
+		struct {
+			compat_pid_t _pid;	/* sender's pid */
+			__compat_uid32_t _uid;	/* sender's uid */
+		} _kill;
+
+		/* POSIX.1b timers */
+		struct {
+			compat_timer_t _tid;	/* timer id */
+			int _overrun;		/* overrun count */
+			compat_sigval_t _sigval;	/* same as below */
+			int _sys_private;       /* not to be passed to user */
+		} _timer;
+
+		/* POSIX.1b signals */
+		struct {
+			compat_pid_t _pid;	/* sender's pid */
+			__compat_uid32_t _uid;	/* sender's uid */
+			compat_sigval_t _sigval;
+		} _rt;
+
+		/* SIGCHLD */
+		struct {
+			compat_pid_t _pid;	/* which child */
+			__compat_uid32_t _uid;	/* sender's uid */
+			int _status;		/* exit code */
+			compat_clock_t _utime;
+			compat_clock_t _stime;
+		} _sigchld;
+
+		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
+		struct {
+			compat_uptr_t _addr; /* faulting insn/memory ref. */
+			short _addr_lsb; /* LSB of the reported address */
+		} _sigfault;
+
+		/* SIGPOLL */
+		struct {
+			compat_long_t _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
+			int _fd;
+		} _sigpoll;
+	} _sifields;
+} compat_siginfo_t;
+
+struct compat_sigaction {
+	compat_uptr_t			sa_handler;
+	compat_ulong_t			sa_flags;
+	compat_uptr_t			sa_restorer;
+	compat_sigset_t			sa_mask;
+};
+
+struct compat_old_sigaction {
+	compat_uptr_t			sa_handler;
+	compat_old_sigset_t		sa_mask;
+	compat_ulong_t			sa_flags;
+	compat_uptr_t			sa_restorer;
+};
+
+typedef struct compat_sigaltstack {
+	compat_uptr_t			ss_sp;
+	int				ss_flags;
+	compat_size_t			ss_size;
+} compat_stack_t;
+
+struct compat_sigcontext {
+	/* We always set these two fields to 0 */
+	compat_ulong_t			trap_no;
+	compat_ulong_t			error_code;
+
+	compat_ulong_t			oldmask;
+	compat_ulong_t			arm_r0;
+	compat_ulong_t			arm_r1;
+	compat_ulong_t			arm_r2;
+	compat_ulong_t			arm_r3;
+	compat_ulong_t			arm_r4;
+	compat_ulong_t			arm_r5;
+	compat_ulong_t			arm_r6;
+	compat_ulong_t			arm_r7;
+	compat_ulong_t			arm_r8;
+	compat_ulong_t			arm_r9;
+	compat_ulong_t			arm_r10;
+	compat_ulong_t			arm_fp;
+	compat_ulong_t			arm_ip;
+	compat_ulong_t			arm_sp;
+	compat_ulong_t			arm_lr;
+	compat_ulong_t			arm_pc;
+	compat_ulong_t			arm_cpsr;
+	compat_ulong_t			fault_address;
+};
+
+struct compat_ucontext {
+	compat_ulong_t			uc_flags;
+	struct compat_ucontext		*uc_link;
+	compat_stack_t			uc_stack;
+	struct compat_sigcontext	uc_mcontext;
+	compat_sigset_t			uc_sigmask;
+	int		__unused[32 - (sizeof (compat_sigset_t) / sizeof (int))];
+	compat_ulong_t	uc_regspace[128] __attribute__((__aligned__(8)));
+};
+
+struct compat_vfp_sigframe {
+	compat_ulong_t	magic;
+	compat_ulong_t	size;
+	struct compat_user_vfp {
+		compat_u64	fpregs[32];
+		compat_ulong_t	fpscr;
+	} ufp;
+	struct compat_user_vfp_exc {
+		compat_ulong_t	fpexc;
+		compat_ulong_t	fpinst;
+		compat_ulong_t	fpinst2;
+	} ufp_exc;
+} __attribute__((__aligned__(8)));
+
+#define VFP_MAGIC		0x56465001
+#define VFP_STORAGE_SIZE	sizeof(struct compat_vfp_sigframe)
+
+struct compat_aux_sigframe {
+	struct compat_vfp_sigframe	vfp;
+
+	/* Something that isn't a valid magic number for any coprocessor.  */
+	unsigned long			end_magic;
+} __attribute__((__aligned__(8)));
+
+struct compat_sigframe {
+	struct compat_ucontext	uc;
+	compat_ulong_t		retcode[2];
+};
+
+struct compat_rt_sigframe {
+	struct compat_siginfo info;
+	struct compat_sigframe sig;
+};
+
+#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
+
+/*
+ * For ARM syscalls, the syscall number has to be loaded into r7.
+ * We do not support an OABI userspace.
+ */
+#define MOV_R7_NR_SIGRETURN	(0xe3a07000 | __NR_sigreturn)
+#define SVC_SYS_SIGRETURN	(0xef000000 | __NR_sigreturn)
+#define MOV_R7_NR_RT_SIGRETURN	(0xe3a07000 | __NR_rt_sigreturn)
+#define SVC_SYS_RT_SIGRETURN	(0xef000000 | __NR_rt_sigreturn)
+
+/*
+ * For Thumb syscalls, we also pass the syscall number via r7. We therefore
+ * need two 16-bit instructions.
+ */
+#define SVC_THUMB_SIGRETURN	(((0xdf00 | __NR_sigreturn) << 16) | \
+				   0x2700 | __NR_sigreturn)
+#define SVC_THUMB_RT_SIGRETURN	(((0xdf00 | __NR_rt_sigreturn) << 16) | \
+				   0x2700 | __NR_rt_sigreturn)
+
+const compat_ulong_t aarch32_sigret_code[6] = {
+	/*
+	 * AArch32 sigreturn code.
+	 * We don't construct an OABI SWI - instead we just set the imm24 field
+	 * to the EABI syscall number so that we create a sane disassembly.
+	 */
+	MOV_R7_NR_SIGRETURN,    SVC_SYS_SIGRETURN,    SVC_THUMB_SIGRETURN,
+	MOV_R7_NR_RT_SIGRETURN, SVC_SYS_RT_SIGRETURN, SVC_THUMB_RT_SIGRETURN,
+};
+
+static inline int put_sigset_t(compat_sigset_t __user *uset, sigset_t *set)
+{
+	compat_sigset_t	cset;
+
+	cset.sig[0] = set->sig[0] & 0xffffffffull;
+	cset.sig[1] = set->sig[0] >> 32;
+
+	return copy_to_user(uset, &cset, sizeof(*uset));
+}
+
+static inline int get_sigset_t(sigset_t *set,
+			       const compat_sigset_t __user *uset)
+{
+	compat_sigset_t s32;
+
+	if (copy_from_user(&s32, uset, sizeof(*uset)))
+		return -EFAULT;
+
+	set->sig[0] = s32.sig[0] | (((long)s32.sig[1]) << 32);
+	return 0;
+}
+
+int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
+{
+	int err;
+
+	if (!access_ok(VERIFY_WRITE, to, sizeof(*to)))
+		return -EFAULT;
+
+	/* If you change siginfo_t structure, please be sure
+	 * this code is fixed accordingly.
+	 * It should never copy any pad contained in the structure
+	 * to avoid security leaks, but must copy the generic
+	 * 3 ints plus the relevant union member.
+	 * This routine must convert siginfo from 64bit to 32bit as well
+	 * at the same time.
+	 */
+	err = __put_user(from->si_signo, &to->si_signo);
+	err |= __put_user(from->si_errno, &to->si_errno);
+	err |= __put_user((short)from->si_code, &to->si_code);
+	if (from->si_code < 0)
+		err |= __copy_to_user(&to->_sifields._pad, &from->_sifields._pad,
+				      SI_PAD_SIZE);
+	else switch (from->si_code & __SI_MASK) {
+	case __SI_KILL:
+		err |= __put_user(from->si_pid, &to->si_pid);
+		err |= __put_user(from->si_uid, &to->si_uid);
+		break;
+	case __SI_TIMER:
+		 err |= __put_user(from->si_tid, &to->si_tid);
+		 err |= __put_user(from->si_overrun, &to->si_overrun);
+		 err |= __put_user((compat_uptr_t)(unsigned long)from->si_ptr,
+				   &to->si_ptr);
+		break;
+	case __SI_POLL:
+		err |= __put_user(from->si_band, &to->si_band);
+		err |= __put_user(from->si_fd, &to->si_fd);
+		break;
+	case __SI_FAULT:
+		err |= __put_user((compat_uptr_t)(unsigned long)from->si_addr,
+				  &to->si_addr);
+#ifdef BUS_MCEERR_AO
+		/*
+		 * Other callers might not initialize the si_lsb field,
+		 * so check explicitely for the right codes here.
+		 */
+		if (from->si_code == BUS_MCEERR_AR || from->si_code == BUS_MCEERR_AO)
+			err |= __put_user(from->si_addr_lsb, &to->si_addr_lsb);
+#endif
+		break;
+	case __SI_CHLD:
+		err |= __put_user(from->si_pid, &to->si_pid);
+		err |= __put_user(from->si_uid, &to->si_uid);
+		err |= __put_user(from->si_status, &to->si_status);
+		err |= __put_user(from->si_utime, &to->si_utime);
+		err |= __put_user(from->si_stime, &to->si_stime);
+		break;
+	case __SI_RT: /* This is not generated by the kernel as of now. */
+	case __SI_MESGQ: /* But this is */
+		err |= __put_user(from->si_pid, &to->si_pid);
+		err |= __put_user(from->si_uid, &to->si_uid);
+		err |= __put_user((compat_uptr_t)(unsigned long)from->si_ptr, &to->si_ptr);
+		break;
+	default: /* this is just in case for now ... */
+		err |= __put_user(from->si_pid, &to->si_pid);
+		err |= __put_user(from->si_uid, &to->si_uid);
+		break;
+	}
+	return err;
+}
+
+int copy_siginfo_from_user32(siginfo_t *to, compat_siginfo_t __user *from)
+{
+	memset(to, 0, sizeof *to);
+
+	if (copy_from_user(to, from, __ARCH_SI_PREAMBLE_SIZE) ||
+	    copy_from_user(to->_sifields._pad,
+			   from->_sifields._pad, SI_PAD_SIZE))
+		return -EFAULT;
+
+	return 0;
+}
+
+/*
+ * VFP save/restore code.
+ */
+static int compat_preserve_vfp_context(struct compat_vfp_sigframe __user *frame)
+{
+	struct fpsimd_state *fpsimd = &current->thread.fpsimd_state;
+	compat_ulong_t magic = VFP_MAGIC;
+	compat_ulong_t size = VFP_STORAGE_SIZE;
+	compat_ulong_t fpscr, fpexc;
+	int err = 0;
+
+	/*
+	 * Save the hardware registers to the fpsimd_state structure.
+	 * Note that this also saves V16-31, which aren't visible
+	 * in AArch32.
+	 */
+	fpsimd_save_state(fpsimd);
+
+	/* Place structure header on the stack */
+	__put_user_error(magic, &frame->magic, err);
+	__put_user_error(size, &frame->size, err);
+
+	/*
+	 * Now copy the FP registers. Since the registers are packed,
+	 * we can copy the prefix we want (V0-V15) as it is.
+	 * FIXME: Won't work if big endian.
+	 */
+	err |= __copy_to_user(&frame->ufp.fpregs, fpsimd->vregs,
+			      sizeof(frame->ufp.fpregs));
+
+	/* Create an AArch32 fpscr from the fpsr and the fpcr. */
+	fpscr = (fpsimd->fpsr & VFP_FPSCR_STAT_MASK) |
+		(fpsimd->fpcr & VFP_FPSCR_CTRL_MASK);
+	__put_user_error(fpscr, &frame->ufp.fpscr, err);
+
+	/*
+	 * The exception register aren't available so we fake up a
+	 * basic FPEXC and zero everything else.
+	 */
+	fpexc = (1 << 30);
+	__put_user_error(fpexc, &frame->ufp_exc.fpexc, err);
+	__put_user_error(0, &frame->ufp_exc.fpinst, err);
+	__put_user_error(0, &frame->ufp_exc.fpinst2, err);
+
+	return err ? -EFAULT : 0;
+}
+
+static int compat_restore_vfp_context(struct compat_vfp_sigframe __user *frame)
+{
+	struct fpsimd_state fpsimd;
+	compat_ulong_t magic = VFP_MAGIC;
+	compat_ulong_t size = VFP_STORAGE_SIZE;
+	compat_ulong_t fpscr;
+	int err = 0;
+
+	__get_user_error(magic, &frame->magic, err);
+	__get_user_error(size, &frame->size, err);
+
+	if (err)
+		return -EFAULT;
+	if (magic != VFP_MAGIC || size != VFP_STORAGE_SIZE)
+		return -EINVAL;
+
+	/*
+	 * Copy the FP registers into the start of the fpsimd_state.
+	 * FIXME: Won't work if big endian.
+	 */
+	err |= __copy_from_user(fpsimd.vregs, frame->ufp.fpregs,
+				sizeof(frame->ufp.fpregs));
+
+	/* Extract the fpsr and the fpcr from the fpscr */
+	__get_user_error(fpscr, &frame->ufp.fpscr, err);
+	fpsimd.fpsr = fpscr & VFP_FPSCR_STAT_MASK;
+	fpsimd.fpcr = fpscr & VFP_FPSCR_CTRL_MASK;
+
+	/*
+	 * We don't need to touch the exception register, so
+	 * reload the hardware state.
+	 */
+	if (!err) {
+		preempt_disable();
+		fpsimd_load_state(&fpsimd);
+		preempt_enable();
+	}
+
+	return err ? -EFAULT : 0;
+}
+
+/*
+ * atomically swap in the new signal mask, and wait for a signal.
+ */
+asmlinkage int compat_sys_sigsuspend(int restart, compat_ulong_t oldmask,
+				     compat_old_sigset_t mask)
+{
+	sigset_t blocked;
+
+	siginitset(&current->blocked, mask);
+	return sigsuspend(&blocked);
+}
+
+asmlinkage int compat_sys_sigaction(int sig,
+				    const struct compat_old_sigaction __user *act,
+				    struct compat_old_sigaction __user *oact)
+{
+	struct k_sigaction new_ka, old_ka;
+	int ret;
+	compat_old_sigset_t mask;
+	compat_uptr_t handler, restorer;
+
+	if (act) {
+		if (!access_ok(VERIFY_READ, act, sizeof(*act)) ||
+		    __get_user(handler, &act->sa_handler) ||
+		    __get_user(restorer, &act->sa_restorer) ||
+		    __get_user(new_ka.sa.sa_flags, &act->sa_flags) ||
+		    __get_user(mask, &act->sa_mask))
+			return -EFAULT;
+
+		new_ka.sa.sa_handler = compat_ptr(handler);
+		new_ka.sa.sa_restorer = compat_ptr(restorer);
+		siginitset(&new_ka.sa.sa_mask, mask);
+	}
+
+	ret = do_sigaction(sig, act ? &new_ka : NULL, oact ? &old_ka : NULL);
+
+	if (!ret && oact) {
+		if (!access_ok(VERIFY_WRITE, oact, sizeof(*oact)) ||
+		    __put_user(ptr_to_compat(old_ka.sa.sa_handler),
+			       &oact->sa_handler) ||
+		    __put_user(ptr_to_compat(old_ka.sa.sa_restorer),
+			       &oact->sa_restorer) ||
+		    __put_user(old_ka.sa.sa_flags, &oact->sa_flags) ||
+		    __put_user(old_ka.sa.sa_mask.sig[0], &oact->sa_mask))
+			return -EFAULT;
+	}
+
+	return ret;
+}
+
+asmlinkage int compat_sys_rt_sigaction(int sig,
+				       const struct compat_sigaction __user *act,
+				       struct compat_sigaction __user *oact,
+				       compat_size_t sigsetsize)
+{
+	struct k_sigaction new_ka, old_ka;
+	int ret;
+
+	/* XXX: Don't preclude handling different sized sigset_t's.  */
+	if (sigsetsize != sizeof(compat_sigset_t))
+		return -EINVAL;
+
+	if (act) {
+		compat_uptr_t handler, restorer;
+
+		ret = get_user(handler, &act->sa_handler);
+		new_ka.sa.sa_handler = compat_ptr(handler);
+		ret |= get_user(restorer, &act->sa_restorer);
+		new_ka.sa.sa_restorer = compat_ptr(restorer);
+		ret |= get_sigset_t(&new_ka.sa.sa_mask, &act->sa_mask);
+		ret |= __get_user(new_ka.sa.sa_flags, &act->sa_flags);
+		if (ret)
+			return -EFAULT;
+	}
+
+	ret = do_sigaction(sig, act ? &new_ka : NULL, oact ? &old_ka : NULL);
+	if (!ret && oact) {
+		ret = put_user(ptr_to_compat(old_ka.sa.sa_handler), &oact->sa_handler);
+		ret |= put_sigset_t(&oact->sa_mask, &old_ka.sa.sa_mask);
+		ret |= __put_user(old_ka.sa.sa_flags, &oact->sa_flags);
+	}
+	return ret;
+}
+
+int compat_do_sigaltstack(compat_uptr_t compat_uss, compat_uptr_t compat_uoss,
+			  compat_ulong_t sp)
+{
+	compat_stack_t __user *newstack = compat_ptr(compat_uss);
+	compat_stack_t __user *oldstack = compat_ptr(compat_uoss);
+	compat_uptr_t ss_sp;
+	int ret;
+	mm_segment_t old_fs;
+	stack_t uss, uoss;
+
+	/* Marshall the compat new stack into a stack_t */
+	if (newstack) {
+		if (get_user(ss_sp, &newstack->ss_sp) ||
+		    __get_user(uss.ss_flags, &newstack->ss_flags) ||
+		    __get_user(uss.ss_size, &newstack->ss_size))
+			return -EFAULT;
+		uss.ss_sp = compat_ptr(ss_sp);
+	}
+
+	old_fs = get_fs();
+	set_fs(KERNEL_DS);
+	/* The __user pointer casts are valid because of the set_fs() */
+	ret = do_sigaltstack(
+		newstack ? (stack_t __user *) &uss : NULL,
+		oldstack ? (stack_t __user *) &uoss : NULL,
+		(unsigned long)sp);
+	set_fs(old_fs);
+
+	/* Convert the old stack_t into a compat stack. */
+	if (!ret && oldstack &&
+		(put_user(ptr_to_compat(uoss.ss_sp), &oldstack->ss_sp) ||
+		 __put_user(uoss.ss_flags, &oldstack->ss_flags) ||
+		 __put_user(uoss.ss_size, &oldstack->ss_size)))
+		return -EFAULT;
+	return ret;
+}
+
+static int compat_restore_sigframe(struct pt_regs *regs,
+				   struct compat_sigframe __user *sf)
+{
+	int err;
+	sigset_t set;
+	struct compat_aux_sigframe __user *aux;
+
+	err = get_sigset_t(&set, &sf->uc.uc_sigmask);
+	if (err == 0) {
+		sigdelsetmask(&set, ~_BLOCKABLE);
+		set_current_blocked(&set);
+	}
+
+	__get_user_error(regs->regs[0], &sf->uc.uc_mcontext.arm_r0, err);
+	__get_user_error(regs->regs[1], &sf->uc.uc_mcontext.arm_r1, err);
+	__get_user_error(regs->regs[2], &sf->uc.uc_mcontext.arm_r2, err);
+	__get_user_error(regs->regs[3], &sf->uc.uc_mcontext.arm_r3, err);
+	__get_user_error(regs->regs[4], &sf->uc.uc_mcontext.arm_r4, err);
+	__get_user_error(regs->regs[5], &sf->uc.uc_mcontext.arm_r5, err);
+	__get_user_error(regs->regs[6], &sf->uc.uc_mcontext.arm_r6, err);
+	__get_user_error(regs->regs[7], &sf->uc.uc_mcontext.arm_r7, err);
+	__get_user_error(regs->regs[8], &sf->uc.uc_mcontext.arm_r8, err);
+	__get_user_error(regs->regs[9], &sf->uc.uc_mcontext.arm_r9, err);
+	__get_user_error(regs->regs[10], &sf->uc.uc_mcontext.arm_r10, err);
+	__get_user_error(regs->regs[11], &sf->uc.uc_mcontext.arm_fp, err);
+	__get_user_error(regs->regs[12], &sf->uc.uc_mcontext.arm_ip, err);
+	__get_user_error(regs->compat_sp, &sf->uc.uc_mcontext.arm_sp, err);
+	__get_user_error(regs->compat_lr, &sf->uc.uc_mcontext.arm_lr, err);
+	__get_user_error(regs->pc, &sf->uc.uc_mcontext.arm_pc, err);
+	__get_user_error(regs->pstate, &sf->uc.uc_mcontext.arm_cpsr, err);
+
+	/*
+	 * Avoid compat_sys_sigreturn() restarting.
+	 */
+	regs->syscallno = ~0UL;
+
+	err |= !valid_user_regs(&regs->user_regs);
+
+	aux = (struct compat_aux_sigframe __user *) sf->uc.uc_regspace;
+	if (err == 0)
+		err |= compat_restore_vfp_context(&aux->vfp);
+
+	return err;
+}
+
+asmlinkage int compat_sys_sigreturn(struct pt_regs *regs)
+{
+	struct compat_sigframe __user *frame;
+
+	/* Always make any pending restarted system calls return -EINTR */
+	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+
+	/*
+	 * Since we stacked the signal on a 64-bit boundary,
+	 * then 'sp' should be word aligned here.  If it's
+	 * not, then the user is trying to mess with us.
+	 */
+	if (regs->compat_sp & 7)
+		goto badframe;
+
+	frame = (struct compat_sigframe __user *)regs->compat_sp;
+
+	if (!access_ok(VERIFY_READ, frame, sizeof (*frame)))
+		goto badframe;
+
+	if (compat_restore_sigframe(regs, frame))
+		goto badframe;
+
+	return regs->regs[0];
+
+badframe:
+	if (show_unhandled_signals)
+		pr_info_ratelimited("%s[%d]: bad frame in %s: pc=%08llx sp=%08llx\n",
+				    current->comm, task_pid_nr(current), __func__,
+				    regs->pc, regs->sp);
+	force_sig(SIGSEGV, current);
+	return 0;
+}
+
+asmlinkage int compat_sys_rt_sigreturn(struct pt_regs *regs)
+{
+	struct compat_rt_sigframe __user *frame;
+
+	/* Always make any pending restarted system calls return -EINTR */
+	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+
+	/*
+	 * Since we stacked the signal on a 64-bit boundary,
+	 * then 'sp' should be word aligned here.  If it's
+	 * not, then the user is trying to mess with us.
+	 */
+	if (regs->compat_sp & 7)
+		goto badframe;
+
+	frame = (struct compat_rt_sigframe __user *)regs->compat_sp;
+
+	if (!access_ok(VERIFY_READ, frame, sizeof (*frame)))
+		goto badframe;
+
+	if (compat_restore_sigframe(regs, &frame->sig))
+		goto badframe;
+
+	if (compat_do_sigaltstack(ptr_to_compat(&frame->sig.uc.uc_stack),
+				 ptr_to_compat((void __user *)NULL),
+				 regs->compat_sp) == -EFAULT)
+		goto badframe;
+
+	return regs->regs[0];
+
+badframe:
+	if (show_unhandled_signals)
+		pr_info_ratelimited("%s[%d]: bad frame in %s: pc=%08llx sp=%08llx\n",
+				    current->comm, task_pid_nr(current), __func__,
+				    regs->pc, regs->sp);
+	force_sig(SIGSEGV, current);
+	return 0;
+}
+
+static inline void __user *compat_get_sigframe(struct k_sigaction *ka,
+					       struct pt_regs *regs,
+					       int framesize)
+{
+	compat_ulong_t sp = regs->compat_sp;
+	void __user *frame;
+
+	/*
+	 * This is the X/Open sanctioned signal stack switching.
+	 */
+	if ((ka->sa.sa_flags & SA_ONSTACK) && !sas_ss_flags(sp))
+		sp = current->sas_ss_sp + current->sas_ss_size;
+
+	/*
+	 * ATPCS B01 mandates 8-byte alignment
+	 */
+	frame = compat_ptr((compat_uptr_t)((sp - framesize) & ~7));
+
+	/*
+	 * Check that we can actually write to the signal frame.
+	 */
+	if (!access_ok(VERIFY_WRITE, frame, framesize))
+		frame = NULL;
+
+	return frame;
+}
+
+static int compat_setup_return(struct pt_regs *regs, struct k_sigaction *ka,
+			       compat_ulong_t __user *rc, void __user *frame,
+			       int usig)
+{
+	compat_ulong_t handler = ptr_to_compat(ka->sa.sa_handler);
+	compat_ulong_t retcode;
+	compat_ulong_t spsr = regs->pstate & ~PSR_f;
+	int thumb;
+
+	/* Check if the handler is written for ARM or Thumb */
+	thumb = handler & 1;
+
+	if (thumb) {
+		spsr |= COMPAT_PSR_T_BIT;
+		spsr &= ~COMPAT_PSR_IT_MASK;
+	} else {
+		spsr &= ~COMPAT_PSR_T_BIT;
+	}
+
+	if (ka->sa.sa_flags & SA_RESTORER) {
+		retcode = ptr_to_compat(ka->sa.sa_restorer);
+	} else {
+		/* Set up sigreturn pointer */
+		unsigned int idx = thumb << 1;
+
+		if (ka->sa.sa_flags & SA_SIGINFO)
+			idx += 3;
+
+		retcode = AARCH32_VECTORS_BASE +
+			  AARCH32_KERN_SIGRET_CODE_OFFSET +
+			  (idx << 2) + thumb;
+	}
+
+	regs->regs[0]	= usig;
+	regs->compat_sp	= ptr_to_compat(frame);
+	regs->compat_lr	= retcode;
+	regs->pc	= handler;
+	regs->pstate	= spsr;
+
+	return 0;
+}
+
+static int compat_setup_sigframe(struct compat_sigframe __user *sf,
+				 struct pt_regs *regs, sigset_t *set)
+{
+	struct compat_aux_sigframe __user *aux;
+	int err = 0;
+
+	__put_user_error(regs->regs[0], &sf->uc.uc_mcontext.arm_r0, err);
+	__put_user_error(regs->regs[1], &sf->uc.uc_mcontext.arm_r1, err);
+	__put_user_error(regs->regs[2], &sf->uc.uc_mcontext.arm_r2, err);
+	__put_user_error(regs->regs[3], &sf->uc.uc_mcontext.arm_r3, err);
+	__put_user_error(regs->regs[4], &sf->uc.uc_mcontext.arm_r4, err);
+	__put_user_error(regs->regs[5], &sf->uc.uc_mcontext.arm_r5, err);
+	__put_user_error(regs->regs[6], &sf->uc.uc_mcontext.arm_r6, err);
+	__put_user_error(regs->regs[7], &sf->uc.uc_mcontext.arm_r7, err);
+	__put_user_error(regs->regs[8], &sf->uc.uc_mcontext.arm_r8, err);
+	__put_user_error(regs->regs[9], &sf->uc.uc_mcontext.arm_r9, err);
+	__put_user_error(regs->regs[10], &sf->uc.uc_mcontext.arm_r10, err);
+	__put_user_error(regs->regs[11], &sf->uc.uc_mcontext.arm_fp, err);
+	__put_user_error(regs->regs[12], &sf->uc.uc_mcontext.arm_ip, err);
+	__put_user_error(regs->compat_sp, &sf->uc.uc_mcontext.arm_sp, err);
+	__put_user_error(regs->compat_lr, &sf->uc.uc_mcontext.arm_lr, err);
+	__put_user_error(regs->pc, &sf->uc.uc_mcontext.arm_pc, err);
+	__put_user_error(regs->pstate, &sf->uc.uc_mcontext.arm_cpsr, err);
+
+	__put_user_error((compat_ulong_t)0, &sf->uc.uc_mcontext.trap_no, err);
+	__put_user_error((compat_ulong_t)0, &sf->uc.uc_mcontext.error_code, err);
+	__put_user_error(current->thread.fault_address, &sf->uc.uc_mcontext.fault_address, err);
+	__put_user_error(set->sig[0], &sf->uc.uc_mcontext.oldmask, err);
+
+	err |= put_sigset_t(&sf->uc.uc_sigmask, set);
+
+	aux = (struct compat_aux_sigframe __user *) sf->uc.uc_regspace;
+
+	if (err == 0)
+		err |= compat_preserve_vfp_context(&aux->vfp);
+	__put_user_error(0, &aux->end_magic, err);
+
+	return err;
+}
+
+/*
+ * 32-bit signal handling routines called from signal.c
+ */
+int compat_setup_rt_frame(int usig, struct k_sigaction *ka, siginfo_t *info,
+			  sigset_t *set, struct pt_regs *regs)
+{
+	struct compat_rt_sigframe __user *frame;
+	compat_stack_t stack;
+	int err = 0;
+
+	frame = compat_get_sigframe(ka, regs, sizeof(*frame));
+
+	if (!frame)
+		return 1;
+
+	err |= copy_siginfo_to_user32(&frame->info, info);
+
+	__put_user_error(0, &frame->sig.uc.uc_flags, err);
+	__put_user_error(NULL, &frame->sig.uc.uc_link, err);
+
+	memset(&stack, 0, sizeof(stack));
+	stack.ss_sp = (compat_uptr_t)current->sas_ss_sp;
+	stack.ss_flags = sas_ss_flags(regs->compat_sp);
+	stack.ss_size = current->sas_ss_size;
+	err |= __copy_to_user(&frame->sig.uc.uc_stack, &stack, sizeof(stack));
+
+	err |= compat_setup_sigframe(&frame->sig, regs, set);
+	if (err == 0)
+		err = compat_setup_return(regs, ka, frame->sig.retcode, frame,
+					  usig);
+
+	if (err == 0) {
+		regs->regs[1] = (compat_ulong_t)(unsigned long)&frame->info;
+		regs->regs[2] = (compat_ulong_t)(unsigned long)&frame->sig.uc;
+	}
+
+	return err;
+}
+
+int compat_setup_frame(int usig, struct k_sigaction *ka, sigset_t *set,
+		       struct pt_regs *regs)
+{
+	struct compat_sigframe __user *frame;
+	int err = 0;
+
+	frame = compat_get_sigframe(ka, regs, sizeof(*frame));
+
+	if (!frame)
+		return 1;
+
+	__put_user_error(0x5ac3c35a, &frame->uc.uc_flags, err);
+
+	err |= compat_setup_sigframe(frame, regs, set);
+	if (err == 0)
+		err = compat_setup_return(regs, ka, frame->retcode, frame, usig);
+
+	return err;
+}
+
+/*
+ * RT signals don't have generic compat wrappers.
+ * See arch/powerpc/kernel/signal_32.c
+ */
+asmlinkage int compat_sys_rt_sigprocmask(int how, compat_sigset_t __user *set,
+					 compat_sigset_t __user *oset,
+					 compat_size_t sigsetsize)
+{
+	sigset_t s;
+	sigset_t __user *up;
+	int ret;
+	mm_segment_t old_fs = get_fs();
+
+	if (set) {
+		if (get_sigset_t(&s, set))
+			return -EFAULT;
+	}
+
+	set_fs(KERNEL_DS);
+	/* This is valid because of the set_fs() */
+	up = (sigset_t __user *) &s;
+	ret = sys_rt_sigprocmask(how, set ? up : NULL, oset ? up : NULL,
+				 sigsetsize);
+	set_fs(old_fs);
+	if (ret)
+		return ret;
+	if (oset) {
+		if (put_sigset_t(oset, &s))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+asmlinkage int compat_sys_rt_sigpending(compat_sigset_t __user *set,
+					compat_size_t sigsetsize)
+{
+	sigset_t s;
+	int ret;
+	mm_segment_t old_fs = get_fs();
+
+	set_fs(KERNEL_DS);
+	/* The __user pointer cast is valid because of the set_fs() */
+	ret = sys_rt_sigpending((sigset_t __user *) &s, sigsetsize);
+	set_fs(old_fs);
+	if (!ret) {
+		if (put_sigset_t(set, &s))
+			return -EFAULT;
+	}
+	return ret;
+}
+
+asmlinkage int compat_sys_rt_sigqueueinfo(int pid, int sig,
+					  compat_siginfo_t __user *uinfo)
+{
+	siginfo_t info;
+	int ret;
+	mm_segment_t old_fs = get_fs();
+
+	ret = copy_siginfo_from_user32(&info, uinfo);
+	if (unlikely(ret))
+		return ret;
+
+	set_fs (KERNEL_DS);
+	/* The __user pointer cast is valid because of the set_fs() */
+	ret = sys_rt_sigqueueinfo(pid, sig, (siginfo_t __user *) &info);
+	set_fs (old_fs);
+	return ret;
+}
+
+void compat_setup_restart_syscall(struct pt_regs *regs)
+{
+       regs->regs[7] = __NR_restart_syscall;
+}
diff --git a/arch/arm64/kernel/sys32.S b/arch/arm64/kernel/sys32.S
new file mode 100644
index 0000000..5e4dc93
--- /dev/null
+++ b/arch/arm64/kernel/sys32.S
@@ -0,0 +1,282 @@
+/*
+ * Compat system call wrappers
+ *
+ * Copyright (C) 2012 ARM Ltd.
+ * Authors: Will Deacon <will.deacon@arm.com>
+ *	    Catalin Marinas <catalin.marinas@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/linkage.h>
+
+#include <asm/assembler.h>
+#include <asm/asm-offsets.h>
+
+/*
+ * System call wrappers for the AArch32 compatibility layer.
+ */
+compat_sys_fork_wrapper:
+	mov	x0, sp
+	b	compat_sys_fork
+ENDPROC(compat_sys_fork_wrapper)
+
+compat_sys_vfork_wrapper:
+	mov	x0, sp
+	b	compat_sys_vfork
+ENDPROC(compat_sys_vfork_wrapper)
+
+compat_sys_execve_wrapper:
+	mov	x3, sp
+	b	compat_sys_execve
+ENDPROC(compat_sys_execve_wrapper)
+
+compat_sys_clone_wrapper:
+	mov	x5, sp
+	b	compat_sys_clone
+ENDPROC(compat_sys_clone_wrapper)
+
+compat_sys_sigreturn_wrapper:
+	mov	x0, sp
+	mov	x27, #0		// prevent syscall restart handling (why)
+	b	compat_sys_sigreturn
+ENDPROC(compat_sys_sigreturn_wrapper)
+
+compat_sys_rt_sigreturn_wrapper:
+	mov	x0, sp
+	mov	x27, #0		// prevent syscall restart handling (why)
+	b	compat_sys_rt_sigreturn
+ENDPROC(compat_sys_rt_sigreturn_wrapper)
+
+compat_sys_sigaltstack_wrapper:
+	ldr	x2, [sp, #S_COMPAT_SP]
+	b	compat_do_sigaltstack
+ENDPROC(compat_sys_sigaltstack_wrapper)
+
+compat_sys_statfs64_wrapper:
+	mov	w3, #84
+	cmp	w1, #88
+	csel	w1, w3, w1, eq
+	b	compat_sys_statfs64
+ENDPROC(compat_sys_statfs64_wrapper)
+
+compat_sys_fstatfs64_wrapper:
+	mov	w3, #84
+	cmp	w1, #88
+	csel	w1, w3, w1, eq
+	b	compat_sys_fstatfs64
+ENDPROC(compat_sys_fstatfs64_wrapper)
+
+/*
+ * Wrappers for AArch32 syscalls that either take 64-bit parameters
+ * in registers or that take 32-bit parameters which require sign
+ * extension.
+ */
+compat_sys_lseek_wrapper:
+	sxtw	x1, w1
+	b	sys_lseek
+ENDPROC(compat_sys_lseek_wrapper)
+
+compat_sys_pread64_wrapper:
+	orr	x3, x4, x5, lsl #32
+	b	sys_pread64
+ENDPROC(compat_sys_pread64_wrapper)
+
+compat_sys_pwrite64_wrapper:
+	orr	x3, x4, x5, lsl #32
+	b	sys_pwrite64
+ENDPROC(compat_sys_pwrite64_wrapper)
+
+compat_sys_truncate64_wrapper:
+	orr	x1, x2, x3, lsl #32
+	b	sys_truncate
+ENDPROC(compat_sys_truncate64_wrapper)
+
+compat_sys_ftruncate64_wrapper:
+	orr	x1, x2, x3, lsl #32
+	b	sys_ftruncate
+ENDPROC(compat_sys_ftruncate64_wrapper)
+
+compat_sys_readahead_wrapper:
+	orr	x1, x2, x3, lsl #32
+	mov	w2, w4
+	b	sys_readahead
+ENDPROC(compat_sys_readahead_wrapper)
+
+compat_sys_lookup_dcookie:
+	orr	x0, x0, x1, lsl #32
+	mov	w1, w2
+	mov	w2, w3
+	b	sys_lookup_dcookie
+ENDPROC(compat_sys_lookup_dcookie)
+
+compat_sys_fadvise64_64_wrapper:
+	mov	w6, w1
+	orr	x1, x2, x3, lsl #32
+	orr	x2, x4, x5, lsl #32
+	mov	w3, w6
+	b	sys_fadvise64_64
+ENDPROC(compat_sys_fadvise64_64_wrapper)
+
+compat_sys_sync_file_range2_wrapper:
+	orr	x2, x2, x3, lsl #32
+	orr	x3, x4, x5, lsl #32
+	b	sys_sync_file_range2
+ENDPROC(compat_sys_sync_file_range2_wrapper)
+
+compat_sys_fallocate_wrapper:
+	orr	x2, x2, x3, lsl #32
+	orr	x3, x4, x5, lsl #32
+	b	sys_fallocate
+ENDPROC(compat_sys_fallocate_wrapper)
+
+compat_sys_fanotify_mark_wrapper:
+	orr	x2, x2, x3, lsl #32
+	mov	w3, w4
+	mov	w4, w5
+	b	sys_fanotify_mark
+ENDPROC(compat_sys_fanotify_mark_wrapper)
+
+/*
+ * Use the compat system call wrappers.
+ */
+#define sys_fork		compat_sys_fork_wrapper
+#define sys_open		compat_sys_open
+#define sys_execve		compat_sys_execve_wrapper
+#define sys_lseek		compat_sys_lseek_wrapper
+#define sys_mount		compat_sys_mount
+#define sys_ptrace		compat_sys_ptrace
+#define sys_times		compat_sys_times
+#define sys_ioctl		compat_sys_ioctl
+#define sys_fcntl		compat_sys_fcntl
+#define sys_ustat		compat_sys_ustat
+#define sys_sigaction		compat_sys_sigaction
+#define sys_sigsuspend		compat_sys_sigsuspend
+#define sys_sigpending		compat_sys_sigpending
+#define sys_setrlimit		compat_sys_setrlimit
+#define sys_getrusage		compat_sys_getrusage
+#define sys_gettimeofday	compat_sys_gettimeofday
+#define sys_settimeofday	compat_sys_settimeofday
+#define sys_statfs		compat_sys_statfs
+#define sys_fstatfs		compat_sys_fstatfs
+#define sys_setitimer		compat_sys_setitimer
+#define sys_getitimer		compat_sys_getitimer
+#define sys_newstat		compat_sys_newstat
+#define sys_newlstat		compat_sys_newlstat
+#define sys_newfstat		compat_sys_newfstat
+#define sys_wait4		compat_sys_wait4
+#define sys_sysinfo		compat_sys_sysinfo
+#define sys_sigreturn		compat_sys_sigreturn_wrapper
+#define sys_clone		compat_sys_clone_wrapper
+#define sys_adjtimex		compat_sys_adjtimex
+#define sys_sigprocmask		compat_sys_sigprocmask
+#define sys_getdents		compat_sys_getdents
+#define sys_select		compat_sys_select
+#define sys_readv		compat_sys_readv
+#define sys_writev		compat_sys_writev
+#define sys_sysctl		compat_sys_sysctl
+#define sys_sched_rr_get_interval compat_sys_sched_rr_get_interval
+#define sys_nanosleep		compat_sys_nanosleep
+#define sys_rt_sigreturn	compat_sys_rt_sigreturn_wrapper
+#define sys_rt_sigaction	compat_sys_rt_sigaction
+#define sys_rt_sigprocmask	compat_sys_rt_sigprocmask
+#define sys_rt_sigpending	compat_sys_rt_sigpending
+#define sys_rt_sigtimedwait	compat_sys_rt_sigtimedwait
+#define sys_rt_sigqueueinfo	compat_sys_rt_sigqueueinfo
+#define sys_rt_sigsuspend	compat_sys_rt_sigsuspend
+#define sys_pread64		compat_sys_pread64_wrapper
+#define sys_pwrite64		compat_sys_pwrite64_wrapper
+#define sys_sigaltstack		compat_sys_sigaltstack_wrapper
+#define sys_sendfile		compat_sys_sendfile
+#define sys_vfork		compat_sys_vfork_wrapper
+#define sys_getrlimit		compat_sys_getrlimit
+#define sys_mmap2		sys_mmap_pgoff
+#define sys_truncate64		compat_sys_truncate64_wrapper
+#define sys_ftruncate64		compat_sys_ftruncate64_wrapper
+#define sys_getdents64		compat_sys_getdents64
+#define sys_fcntl64		compat_sys_fcntl64
+#define sys_readahead		compat_sys_readahead_wrapper
+#define sys_futex		compat_sys_futex
+#define sys_sched_setaffinity	compat_sys_sched_setaffinity
+#define sys_sched_getaffinity	compat_sys_sched_getaffinity
+#define sys_io_setup		compat_sys_io_setup
+#define sys_io_getevents	compat_sys_io_getevents
+#define sys_io_submit		compat_sys_io_submit
+#define sys_lookup_dcookie	compat_sys_lookup_dcookie
+#define sys_timer_create	compat_sys_timer_create
+#define sys_timer_settime	compat_sys_timer_settime
+#define sys_timer_gettime	compat_sys_timer_gettime
+#define sys_clock_settime	compat_sys_clock_settime
+#define sys_clock_gettime	compat_sys_clock_gettime
+#define sys_clock_getres	compat_sys_clock_getres
+#define sys_clock_nanosleep	compat_sys_clock_nanosleep
+#define sys_statfs64		compat_sys_statfs64_wrapper
+#define sys_fstatfs64		compat_sys_fstatfs64_wrapper
+#define sys_utimes		compat_sys_utimes
+#define sys_fadvise64_64	compat_sys_fadvise64_64_wrapper
+#define sys_mq_open		compat_sys_mq_open
+#define sys_mq_timedsend	compat_sys_mq_timedsend
+#define sys_mq_timedreceive	compat_sys_mq_timedreceive
+#define sys_mq_notify		compat_sys_mq_notify
+#define sys_mq_getsetattr	compat_sys_mq_getsetattr
+#define sys_waitid		compat_sys_waitid
+#define sys_recv		compat_sys_recv
+#define sys_recvfrom		compat_sys_recvfrom
+#define sys_setsockopt		compat_sys_setsockopt
+#define sys_getsockopt		compat_sys_getsockopt
+#define sys_sendmsg		compat_sys_sendmsg
+#define sys_recvmsg		compat_sys_recvmsg
+#define sys_semctl		compat_sys_semctl
+#define sys_msgsnd		compat_sys_msgsnd
+#define sys_msgrcv		compat_sys_msgrcv
+#define sys_msgctl		compat_sys_msgctl
+#define sys_shmat		compat_sys_shmat
+#define sys_shmctl		compat_sys_shmctl
+#define sys_keyctl		compat_sys_keyctl
+#define sys_semtimedop		compat_sys_semtimedop
+#define sys_mbind		compat_sys_mbind
+#define sys_get_mempolicy	compat_sys_get_mempolicy
+#define sys_set_mempolicy	compat_sys_set_mempolicy
+#define sys_openat		compat_sys_openat
+#define sys_futimesat		compat_sys_futimesat
+#define sys_pselect6		compat_sys_pselect6
+#define sys_ppoll		compat_sys_ppoll
+#define sys_set_robust_list	compat_sys_set_robust_list
+#define sys_get_robust_list	compat_sys_get_robust_list
+#define sys_sync_file_range2	compat_sys_sync_file_range2_wrapper
+#define sys_vmsplice		compat_sys_vmsplice
+#define sys_move_pages		compat_sys_move_pages
+#define sys_epoll_pwait		compat_sys_epoll_pwait
+#define sys_kexec_load		compat_sys_kexec_load
+#define sys_utimensat		compat_sys_utimensat
+#define sys_signalfd		compat_sys_signalfd
+#define sys_fallocate		compat_sys_fallocate_wrapper
+#define sys_timerfd_settime	compat_sys_timerfd_settime
+#define sys_timerfd_gettime	compat_sys_timerfd_gettime
+#define sys_signalfd4		compat_sys_signalfd4
+#define sys_preadv		compat_sys_preadv
+#define sys_pwritev		compat_sys_pwritev
+#define sys_rt_tgsigqueueinfo	compat_sys_rt_tgsigqueueinfo
+#define sys_recvmmsg		compat_sys_recvmmsg
+#define sys_fanotify_mark	compat_sys_fanotify_mark_wrapper
+
+#undef __SYSCALL
+#define __SYSCALL(x, y)		.quad	y	// x
+#define __SYSCALL_COMPAT
+
+/*
+ * The system calls table must be 4KB aligned.
+ */
+	.align	12
+ENTRY(compat_sys_call_table)
+#include <asm/unistd.h>
diff --git a/arch/arm64/kernel/sys_compat.c b/arch/arm64/kernel/sys_compat.c
new file mode 100644
index 0000000..967e92f
--- /dev/null
+++ b/arch/arm64/kernel/sys_compat.c
@@ -0,0 +1,164 @@
+/*
+ * Based on arch/arm/kernel/sys_arm.c
+ *
+ * Copyright (C) People who wrote linux/arch/i386/kernel/sys_i386.c
+ * Copyright (C) 1995, 1996 Russell King.
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#define __SYSCALL_COMPAT
+
+#include <linux/compat.h>
+#include <linux/personality.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+
+#include <asm/cacheflush.h>
+#include <asm/unistd.h>
+
+asmlinkage int compat_sys_fork(struct pt_regs *regs)
+{
+	return do_fork(SIGCHLD, regs->compat_sp, regs, 0, NULL, NULL);
+}
+
+asmlinkage int compat_sys_clone(unsigned long clone_flags, unsigned long newsp,
+			  int __user *parent_tidptr, int tls_val,
+			  int __user *child_tidptr, struct pt_regs *regs)
+{
+	if (!newsp)
+		newsp = regs->compat_sp;
+
+	return do_fork(clone_flags, newsp, regs, 0, parent_tidptr, child_tidptr);
+}
+
+asmlinkage int compat_sys_vfork(struct pt_regs *regs)
+{
+	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->compat_sp,
+		       regs, 0, NULL, NULL);
+}
+
+asmlinkage int compat_sys_execve(const char __user *filenamei,
+				 compat_uptr_t argv, compat_uptr_t envp,
+				 struct pt_regs *regs)
+{
+	int error;
+	char * filename;
+
+	filename = getname(filenamei);
+	error = PTR_ERR(filename);
+	if (IS_ERR(filename))
+		goto out;
+	error = compat_do_execve(filename, compat_ptr(argv), compat_ptr(envp),
+				 regs);
+	putname(filename);
+out:
+	return error;
+}
+
+asmlinkage int compat_sys_sched_rr_get_interval(compat_pid_t pid,
+						struct compat_timespec __user *interval)
+{
+	struct timespec t;
+	int ret;
+	mm_segment_t old_fs = get_fs();
+
+	set_fs(KERNEL_DS);
+	ret = sys_sched_rr_get_interval(pid, (struct timespec __user *)&t);
+	set_fs(old_fs);
+	if (put_compat_timespec(&t, interval))
+		return -EFAULT;
+	return ret;
+}
+
+asmlinkage int compat_sys_sendfile(int out_fd, int in_fd,
+				   compat_off_t __user *offset, s32 count)
+{
+	mm_segment_t old_fs = get_fs();
+	int ret;
+	off_t of;
+
+	if (offset && get_user(of, offset))
+		return -EFAULT;
+
+	set_fs(KERNEL_DS);
+	ret = sys_sendfile(out_fd, in_fd, offset ? (off_t __user *)&of : NULL,
+			   count);
+	set_fs(old_fs);
+
+	if (offset && put_user(of, offset))
+		return -EFAULT;
+	return ret;
+}
+
+static inline void
+do_compat_cache_op(unsigned long start, unsigned long end, int flags)
+{
+	struct mm_struct *mm = current->active_mm;
+	struct vm_area_struct *vma;
+
+	if (end < start || flags)
+		return;
+
+	down_read(&mm->mmap_sem);
+	vma = find_vma(mm, start);
+	if (vma && vma->vm_start < end) {
+		if (start < vma->vm_start)
+			start = vma->vm_start;
+		if (end > vma->vm_end)
+			end = vma->vm_end;
+		up_read(&mm->mmap_sem);
+		__flush_cache_user_range(start & PAGE_MASK, PAGE_ALIGN(end));
+		return;
+	}
+	up_read(&mm->mmap_sem);
+}
+
+/*
+ * Handle all unrecognised system calls.
+ */
+long compat_arm_syscall(struct pt_regs *regs)
+{
+	unsigned int no = regs->regs[7];
+
+	switch (no) {
+	/*
+	 * Flush a region from virtual address 'r0' to virtual address 'r1'
+	 * _exclusive_.  There is no alignment requirement on either address;
+	 * user space does not need to know the hardware cache layout.
+	 *
+	 * r2 contains flags.  It should ALWAYS be passed as ZERO until it
+	 * is defined to be something else.  For now we ignore it, but may
+	 * the fires of hell burn in your belly if you break this rule. ;)
+	 *
+	 * (at a later date, we may want to allow this call to not flush
+	 * various aspects of the cache.  Passing '0' will guarantee that
+	 * everything necessary gets flushed to maintain consistency in
+	 * the specified region).
+	 */
+	case __ARM_NR_compat_cacheflush:
+		do_compat_cache_op(regs->regs[0], regs->regs[1], regs->regs[2]);
+		return 0;
+
+	case __ARM_NR_compat_set_tls:
+		current->thread.tp_value = regs->regs[0];
+		asm ("msr tpidrro_el0, %0" : : "r" (regs->regs[0]));
+		return 0;
+
+	default:
+		return -ENOSYS;
+	}
+}

