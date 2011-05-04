Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab1EDUE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:04:56 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:14691 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab1EDUEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:04:52 -0400
Message-Id: <201105042004.p44K4nRJ011722@farm-0032.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 4 May 2011 11:16:37 -0400
Subject: [PATCH] compat: fixes to allow working with tile arch
To: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Moyer <jmoyer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>
X-OriginalArrivalTime: 04 May 2011 20:04:52.0011 (UTC) FILETIME=[876977B0:01CC0A96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<linux/compat.h> doesn't currently provide enough to allow the new
<asm-generic/unistd.h> approach to work for the compat syscall vector.
In principle you should be able to "#define __SYSCALL(nr, call)
[nr] = (compat_##call)," and then #include <asm/unistd.h>.  This change
adds all the remaining compat_sys_xxx() prototypes, and also adds
appropriate #defines for compat syscalls that can use the non-compat
implementation.  See arch/tile/kernel/compat.c for an example.

compat.c defines compat_sys_sigpending() and compat_sys_sigprocmask()
even if the underlying architecture doesn't request it, which tries to
pull in undefined compat_old_sigset_t defines.  We need to guard those
compat syscall definitions with appropriate __ARCH_WANT_SYS_xxx ifdefs.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 include/linux/compat.h |  375 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/compat.c        |    8 +
 2 files changed, 383 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 5778b55..51ac93b 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -209,6 +209,18 @@ struct compat_robust_list_head {
 	compat_uptr_t			list_op_pending;
 };
 
+struct compat_statfs;
+struct compat_statfs64;
+struct compat_old_linux_dirent;
+struct compat_linux_dirent;
+struct linux_dirent64;
+struct compat_msghdr;
+struct compat_mmsghdr;
+struct compat_sysinfo;
+struct compat_sysctl_args;
+struct compat_kexec_segment;
+struct compat_mq_attr;
+
 extern void compat_exit_robust_list(struct task_struct *curr);
 
 asmlinkage long
@@ -331,9 +343,13 @@ asmlinkage long compat_sys_epoll_pwait(int epfd,
 			const compat_sigset_t __user *sigmask,
 			compat_size_t sigsetsize);
 
+asmlinkage long compat_sys_utime(const char __user *filename,
+				 struct compat_utimbuf __user *t);
 asmlinkage long compat_sys_utimensat(unsigned int dfd, const char __user *filename,
 				struct compat_timespec __user *t, int flags);
 
+asmlinkage long compat_sys_time(compat_time_t __user *tloc);
+asmlinkage long compat_sys_stime(compat_time_t __user *tptr);
 asmlinkage long compat_sys_signalfd(int ufd,
 				const compat_sigset_t __user *sigmask,
                                 compat_size_t sigsetsize);
@@ -350,11 +366,178 @@ asmlinkage long compat_sys_move_pages(pid_t pid, unsigned long nr_page,
 				      int flags);
 asmlinkage long compat_sys_futimesat(unsigned int dfd, const char __user *filename,
 				     struct compat_timeval __user *t);
+asmlinkage long compat_sys_utimes(const char __user *filename,
+				  struct compat_timeval __user *t);
+asmlinkage long compat_sys_newstat(const char __user * filename,
+				   struct compat_stat __user *statbuf);
+asmlinkage long compat_sys_newlstat(const char __user * filename,
+				    struct compat_stat __user *statbuf);
 asmlinkage long compat_sys_newfstatat(unsigned int dfd, const char __user * filename,
 				      struct compat_stat __user *statbuf,
 				      int flag);
+asmlinkage long compat_sys_newfstat(unsigned int fd,
+				    struct compat_stat __user * statbuf);
+asmlinkage long compat_sys_statfs(const char __user *pathname,
+				  struct compat_statfs __user *buf);
+asmlinkage long compat_sys_fstatfs(unsigned int fd,
+				   struct compat_statfs __user *buf);
+asmlinkage long compat_sys_statfs64(const char __user *pathname,
+				    compat_size_t sz,
+				    struct compat_statfs64 __user *buf);
+asmlinkage long compat_sys_fstatfs64(unsigned int fd, compat_size_t sz,
+				     struct compat_statfs64 __user *buf);
+asmlinkage long compat_sys_fcntl64(unsigned int fd, unsigned int cmd,
+				   unsigned long arg);
+asmlinkage long compat_sys_fcntl(unsigned int fd, unsigned int cmd,
+				 unsigned long arg);
+asmlinkage long compat_sys_io_setup(unsigned nr_reqs, u32 __user *ctx32p);
+asmlinkage long compat_sys_io_getevents(aio_context_t ctx_id,
+					unsigned long min_nr,
+					unsigned long nr,
+					struct io_event __user *events,
+					struct compat_timespec __user *timeout);
+asmlinkage long compat_sys_io_submit(aio_context_t ctx_id, int nr,
+				     u32 __user *iocb);
+asmlinkage long compat_sys_mount(const char __user * dev_name,
+				 const char __user * dir_name,
+				 const char __user * type, unsigned long flags,
+				 const void __user * data);
+asmlinkage long compat_sys_old_readdir(unsigned int fd,
+				       struct compat_old_linux_dirent __user *,
+				       unsigned int count);
+asmlinkage long compat_sys_getdents(unsigned int fd,
+				    struct compat_linux_dirent __user *dirent,
+				    unsigned int count);
+asmlinkage long compat_sys_getdents64(unsigned int fd,
+				      struct linux_dirent64 __user * dirent,
+				      unsigned int count);
+asmlinkage long compat_sys_vmsplice(int fd, const struct compat_iovec __user *,
+				    unsigned int nr_segs, unsigned int flags);
+asmlinkage long compat_sys_open(const char __user *filename, int flags,
+				int mode);
 asmlinkage long compat_sys_openat(unsigned int dfd, const char __user *filename,
 				  int flags, int mode);
+asmlinkage long compat_sys_pselect6(int n, compat_ulong_t __user *inp,
+				    compat_ulong_t __user *outp,
+				    compat_ulong_t __user *exp,
+				    struct compat_timespec __user *tsp,
+				    void __user *sig);
+asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
+				 unsigned int nfds,
+				 struct compat_timespec __user *tsp,
+				 const compat_sigset_t __user *sigmask,
+				 compat_size_t sigsetsize);
+#if (defined(CONFIG_NFSD) || defined(CONFIG_NFSD_MODULE)) && !defined(CONFIG_NFSD_DEPRECATED)
+union compat_nfsctl_res;
+struct compat_nfsctl_arg;
+asmlinkage long compat_sys_nfsservctl(int cmd,
+				      struct compat_nfsctl_arg __user *arg,
+				      union compat_nfsctl_res __user *res);
+#else
+long asmlinkage compat_sys_nfsservctl(int cmd, void *notused, void *notused2);
+#endif
+asmlinkage long compat_sys_signalfd4(int ufd,
+				     const compat_sigset_t __user *sigmask,
+				     compat_size_t sigsetsize, int flags);
+asmlinkage long compat_sys_get_mempolicy(int __user *policy,
+					 compat_ulong_t __user *nmask,
+					 compat_ulong_t maxnode,
+					 compat_ulong_t addr,
+					 compat_ulong_t flags);
+asmlinkage long compat_sys_set_mempolicy(int mode, compat_ulong_t __user *nmask,
+					 compat_ulong_t maxnode);
+asmlinkage long compat_sys_mbind(compat_ulong_t start, compat_ulong_t len,
+				 compat_ulong_t mode,
+				 compat_ulong_t __user *nmask,
+				 compat_ulong_t maxnode, compat_ulong_t flags);
+
+asmlinkage long compat_sys_setsockopt(int fd, int level, int optname,
+				      char __user *optval, unsigned int optlen);
+asmlinkage long compat_sys_sendmsg(int fd, struct compat_msghdr __user *msg,
+				   unsigned flags);
+asmlinkage long compat_sys_recvmsg(int fd, struct compat_msghdr __user *msg,
+				   unsigned int flags);
+asmlinkage long compat_sys_recv(int fd, void __user *buf, size_t len,
+				unsigned flags);
+asmlinkage long compat_sys_recvfrom(int fd, void __user *buf, size_t len,
+			    unsigned flags, struct sockaddr __user *addr,
+			    int __user *addrlen);
+asmlinkage long compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
+				    unsigned vlen, unsigned int flags,
+				    struct compat_timespec __user *timeout);
+asmlinkage long compat_sys_nanosleep(struct compat_timespec __user *rqtp,
+				     struct compat_timespec __user *rmtp);
+asmlinkage long compat_sys_getitimer(int which,
+				     struct compat_itimerval __user *it);
+asmlinkage long compat_sys_setitimer(int which,
+				     struct compat_itimerval __user *in,
+				     struct compat_itimerval __user *out);
+asmlinkage long compat_sys_times(struct compat_tms __user *tbuf);
+asmlinkage long compat_sys_setrlimit(unsigned int resource,
+				     struct compat_rlimit __user *rlim);
+asmlinkage long compat_sys_getrlimit (unsigned int resource,
+				      struct compat_rlimit __user *rlim);
+asmlinkage long compat_sys_getrusage(int who, struct compat_rusage __user *ru);
+asmlinkage long compat_sys_sched_setaffinity(compat_pid_t pid,
+				     unsigned int len,
+				     compat_ulong_t __user *user_mask_ptr);
+asmlinkage long compat_sys_sched_getaffinity(compat_pid_t pid,
+				     unsigned int len,
+				     compat_ulong_t __user *user_mask_ptr);
+asmlinkage long compat_sys_timer_create(clockid_t which_clock,
+			struct compat_sigevent __user *timer_event_spec,
+			timer_t __user *created_timer_id);
+asmlinkage long compat_sys_timer_settime(timer_t timer_id, int flags,
+					 struct compat_itimerspec __user *new,
+					 struct compat_itimerspec __user *old);
+asmlinkage long compat_sys_timer_gettime(timer_t timer_id,
+				 struct compat_itimerspec __user *setting);
+asmlinkage long compat_sys_clock_settime(clockid_t which_clock,
+					 struct compat_timespec __user *tp);
+asmlinkage long compat_sys_clock_gettime(clockid_t which_clock,
+					 struct compat_timespec __user *tp);
+asmlinkage long compat_sys_clock_adjtime(clockid_t which_clock,
+					 struct compat_timex __user *tp);
+asmlinkage long compat_sys_clock_getres(clockid_t which_clock,
+					struct compat_timespec __user *tp);
+asmlinkage long compat_sys_clock_nanosleep(clockid_t which_clock, int flags,
+					   struct compat_timespec __user *rqtp,
+					   struct compat_timespec __user *rmtp);
+asmlinkage long compat_sys_rt_sigtimedwait (compat_sigset_t __user *uthese,
+		struct compat_siginfo __user *uinfo,
+		struct compat_timespec __user *uts, compat_size_t sigsetsize);
+asmlinkage long compat_sys_rt_sigsuspend(compat_sigset_t __user *unewset,
+					 compat_size_t sigsetsize);
+asmlinkage long compat_sys_sysinfo(struct compat_sysinfo __user *info);
+asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
+				 unsigned long arg);
+asmlinkage long compat_sys_futex(u32 __user *uaddr, int op, u32 val,
+		struct compat_timespec __user *utime, u32 __user *uaddr2,
+		u32 val3);
+asmlinkage long compat_sys_getsockopt(int fd, int level, int optname,
+				      char __user *optval, int __user *optlen);
+asmlinkage long compat_sys_kexec_load(unsigned long entry,
+				      unsigned long nr_segments,
+				      struct compat_kexec_segment __user *,
+				      unsigned long flags);
+asmlinkage long compat_sys_mq_getsetattr(mqd_t mqdes,
+			const struct compat_mq_attr __user *u_mqstat,
+			struct compat_mq_attr __user *u_omqstat);
+asmlinkage long compat_sys_mq_notify(mqd_t mqdes,
+			const struct compat_sigevent __user *u_notification);
+asmlinkage long compat_sys_mq_open(const char __user *u_name,
+			int oflag, compat_mode_t mode,
+			struct compat_mq_attr __user *u_attr);
+asmlinkage long compat_sys_mq_timedsend(mqd_t mqdes,
+			const char __user *u_msg_ptr,
+			size_t msg_len, unsigned int msg_prio,
+			const struct compat_timespec __user *u_abs_timeout);
+asmlinkage ssize_t compat_sys_mq_timedreceive(mqd_t mqdes,
+			char __user *u_msg_ptr,
+			size_t msg_len, unsigned int __user *u_msg_prio,
+			const struct compat_timespec __user *u_abs_timeout);
+asmlinkage long compat_sys_socketcall(int call, u32 __user *args);
+asmlinkage long compat_sys_sysctl(struct compat_sysctl_args __user *args);
 
 extern ssize_t compat_rw_copy_check_uvector(int type,
 		const struct compat_iovec __user *uvector, unsigned long nr_segs,
@@ -363,5 +546,197 @@ extern ssize_t compat_rw_copy_check_uvector(int type,
 
 extern void __user *compat_alloc_user_space(unsigned long len);
 
+/* Standard Linux functions that don't have "compat" versions. */
+#define compat_sys_accept sys_accept
+#define compat_sys_accept4 sys_accept4
+#define compat_sys_access sys_access
+#define compat_sys_acct sys_acct
+#define compat_sys_add_key sys_add_key
+#define compat_sys_alarm sys_alarm
+#define compat_sys_bdflush sys_bdflush
+#define compat_sys_bind sys_bind
+#define compat_sys_brk sys_brk
+#define compat_sys_capget sys_capget
+#define compat_sys_capset sys_capset
+#define compat_sys_chdir sys_chdir
+#define compat_sys_chmod sys_chmod
+#define compat_sys_chown sys_chown
+#define compat_sys_chroot sys_chroot
+#define compat_sys_clone sys_clone
+#define compat_sys_close sys_close
+#define compat_sys_connect sys_connect
+#define compat_sys_creat sys_creat
+#define compat_sys_delete_module sys_delete_module
+#define compat_sys_dup sys_dup
+#define compat_sys_dup2 sys_dup2
+#define compat_sys_dup3 sys_dup3
+#define compat_sys_epoll_create sys_epoll_create
+#define compat_sys_epoll_create1 sys_epoll_create1
+#define compat_sys_epoll_ctl sys_epoll_ctl
+#define compat_sys_epoll_wait sys_epoll_wait
+#define compat_sys_eventfd sys_eventfd
+#define compat_sys_eventfd2 sys_eventfd2
+#define compat_sys_exit sys_exit
+#define compat_sys_exit_group sys_exit_group
+#define compat_sys_faccessat sys_faccessat
+#define compat_sys_fanotify_init sys_fanotify_init
+#define compat_sys_fanotify_mark sys_fanotify_mark
+#define compat_sys_fchdir sys_fchdir
+#define compat_sys_fchmod sys_fchmod
+#define compat_sys_fchmodat sys_fchmodat
+#define compat_sys_fchown sys_fchown
+#define compat_sys_fchownat sys_fchownat
+#define compat_sys_fdatasync sys_fdatasync
+#define compat_sys_fgetxattr sys_fgetxattr
+#define compat_sys_flistxattr sys_flistxattr
+#define compat_sys_flock sys_flock
+#define compat_sys_fork sys_fork
+#define compat_sys_fremovexattr sys_fremovexattr
+#define compat_sys_fsetxattr sys_fsetxattr
+#define compat_sys_fsync sys_fsync
+#define compat_sys_ftruncate sys_ftruncate
+#define compat_sys_getcpu sys_getcpu
+#define compat_sys_getcwd sys_getcwd
+#define compat_sys_getegid sys_getegid
+#define compat_sys_geteuid sys_geteuid
+#define compat_sys_getgid sys_getgid
+#define compat_sys_getgroups sys_getgroups
+#define compat_sys_getpeername sys_getpeername
+#define compat_sys_getpgid sys_getpgid
+#define compat_sys_getpgrp sys_getpgrp
+#define compat_sys_getpid sys_getpid
+#define compat_sys_getppid sys_getppid
+#define compat_sys_getpriority sys_getpriority
+#define compat_sys_getresgid sys_getresgid
+#define compat_sys_getresuid sys_getresuid
+#define compat_sys_getsid sys_getsid
+#define compat_sys_getsockname sys_getsockname
+#define compat_sys_gettid sys_gettid
+#define compat_sys_getuid sys_getuid
+#define compat_sys_getxattr sys_getxattr
+#define compat_sys_init_module sys_init_module
+#define compat_sys_inotify_add_watch sys_inotify_add_watch
+#define compat_sys_inotify_init sys_inotify_init
+#define compat_sys_inotify_init1 sys_inotify_init1
+#define compat_sys_inotify_rm_watch sys_inotify_rm_watch
+#define compat_sys_io_cancel sys_io_cancel
+#define compat_sys_io_destroy sys_io_destroy
+#define compat_sys_ioprio_get sys_ioprio_get
+#define compat_sys_ioprio_set sys_ioprio_set
+#define compat_sys_kill sys_kill
+#define compat_sys_lchown sys_lchown
+#define compat_sys_lgetxattr sys_lgetxattr
+#define compat_sys_link sys_link
+#define compat_sys_linkat sys_linkat
+#define compat_sys_listen sys_listen
+#define compat_sys_listxattr sys_listxattr
+#define compat_sys_llistxattr sys_llistxattr
+#define compat_sys_llseek sys_llseek
+#define compat_sys_lremovexattr sys_lremovexattr
+#define compat_sys_lseek sys_lseek
+#define compat_sys_lsetxattr sys_lsetxattr
+#define compat_sys_madvise sys_madvise
+#define compat_sys_mincore sys_mincore
+#define compat_sys_mkdir sys_mkdir
+#define compat_sys_mkdirat sys_mkdirat
+#define compat_sys_mknod sys_mknod
+#define compat_sys_mknodat sys_mknodat
+#define compat_sys_mlock sys_mlock
+#define compat_sys_mlockall sys_mlockall
+#define compat_sys_mmap sys_mmap
+#define compat_sys_mmap2 sys_mmap2
+#define compat_sys_mprotect sys_mprotect
+#define compat_sys_mq_unlink sys_mq_unlink
+#define compat_sys_mremap sys_mremap
+#define compat_sys_msgget sys_msgget
+#define compat_sys_msync sys_msync
+#define compat_sys_munlock sys_munlock
+#define compat_sys_munlockall sys_munlockall
+#define compat_sys_munmap sys_munmap
+#define compat_sys_name_to_handle_at sys_name_to_handle_at
+#define compat_sys_newuname sys_newuname
+#define compat_sys_oldumount sys_oldumount
+#define compat_sys_open_by_handle_at sys_open_by_handle_at
+#define compat_sys_pause sys_pause
+#define compat_sys_perf_event_open sys_perf_event_open
+#define compat_sys_personality sys_personality
+#define compat_sys_pipe sys_pipe
+#define compat_sys_pipe2 sys_pipe2
+#define compat_sys_pivot_root sys_pivot_root
+#define compat_sys_poll sys_poll
+#define compat_sys_prctl sys_prctl
+#define compat_sys_prlimit64 sys_prlimit64
+#define compat_sys_quotactl sys_quotactl
+#define compat_sys_read sys_read
+#define compat_sys_readlink sys_readlink
+#define compat_sys_readlinkat sys_readlinkat
+#define compat_sys_reboot sys_reboot
+#define compat_sys_remap_file_pages sys_remap_file_pages
+#define compat_sys_removexattr sys_removexattr
+#define compat_sys_rename sys_rename
+#define compat_sys_renameat sys_renameat
+#define compat_sys_request_key sys_request_key
+#define compat_sys_restart_syscall sys_restart_syscall
+#define compat_sys_rmdir sys_rmdir
+#define compat_sys_rt_sigpending sys_rt_sigpending
+#define compat_sys_rt_sigprocmask sys_rt_sigprocmask
+#define compat_sys_sched_get_priority_max sys_sched_get_priority_max
+#define compat_sys_sched_get_priority_min sys_sched_get_priority_min
+#define compat_sys_sched_getparam sys_sched_getparam
+#define compat_sys_sched_getscheduler sys_sched_getscheduler
+#define compat_sys_sched_setparam sys_sched_setparam
+#define compat_sys_sched_setscheduler sys_sched_setscheduler
+#define compat_sys_sched_yield sys_sched_yield
+#define compat_sys_semget sys_semget
+#define compat_sys_semop sys_semop
+#define compat_sys_send sys_send
+#define compat_sys_sendfile64 sys_sendfile64
+#define compat_sys_sendto sys_sendto
+#define compat_sys_set_tid_address sys_set_tid_address
+#define compat_sys_setdomainname sys_setdomainname
+#define compat_sys_setfsgid sys_setfsgid
+#define compat_sys_setfsuid sys_setfsuid
+#define compat_sys_setgid sys_setgid
+#define compat_sys_setgroups sys_setgroups
+#define compat_sys_sethostname sys_sethostname
+#define compat_sys_setpgid sys_setpgid
+#define compat_sys_setpriority sys_setpriority
+#define compat_sys_setregid sys_setregid
+#define compat_sys_setresgid sys_setresgid
+#define compat_sys_setresuid sys_setresuid
+#define compat_sys_setreuid sys_setreuid
+#define compat_sys_setsid sys_setsid
+#define compat_sys_setuid sys_setuid
+#define compat_sys_setxattr sys_setxattr
+#define compat_sys_shmdt sys_shmdt
+#define compat_sys_shmget sys_shmget
+#define compat_sys_shutdown sys_shutdown
+#define compat_sys_socket sys_socket
+#define compat_sys_socketpair sys_socketpair
+#define compat_sys_splice sys_splice
+#define compat_sys_swapoff sys_swapoff
+#define compat_sys_swapon sys_swapon
+#define compat_sys_symlink sys_symlink
+#define compat_sys_symlinkat sys_symlinkat
+#define compat_sys_sync sys_sync
+#define compat_sys_syncfs sys_syncfs
+#define compat_sys_syslog sys_syslog
+#define compat_sys_tee sys_tee
+#define compat_sys_tgkill sys_tgkill
+#define compat_sys_timer_delete sys_timer_delete
+#define compat_sys_timer_getoverrun sys_timer_getoverrun
+#define compat_sys_timerfd_create sys_timerfd_create
+#define compat_sys_tkill sys_tkill
+#define compat_sys_truncate sys_truncate
+#define compat_sys_umask sys_umask
+#define compat_sys_umount sys_umount
+#define compat_sys_unlink sys_unlink
+#define compat_sys_unlinkat sys_unlinkat
+#define compat_sys_unshare sys_unshare
+#define compat_sys_uselib sys_uselib
+#define compat_sys_vfork sys_vfork
+#define compat_sys_vhangup sys_vhangup
+#define compat_sys_write sys_write
+
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
diff --git a/kernel/compat.c b/kernel/compat.c
index 38b1d2c..80c2856 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -293,6 +293,8 @@ asmlinkage long compat_sys_times(struct compat_tms __user *tbuf)
 	return compat_jiffies_to_clock_t(jiffies);
 }
 
+#ifdef __ARCH_WANT_SYS_SIGPENDING
+
 /*
  * Assumption: old_sigset_t and compat_old_sigset_t are both
  * types that can be passed to put_user()/get_user().
@@ -312,6 +314,10 @@ asmlinkage long compat_sys_sigpending(compat_old_sigset_t __user *set)
 	return ret;
 }
 
+#endif
+
+#ifdef __ARCH_WANT_SYS_SIGPROCMASK
+
 asmlinkage long compat_sys_sigprocmask(int how, compat_old_sigset_t __user *set,
 		compat_old_sigset_t __user *oset)
 {
@@ -333,6 +339,8 @@ asmlinkage long compat_sys_sigprocmask(int how, compat_old_sigset_t __user *set,
 	return ret;
 }
 
+#endif
+
 asmlinkage long compat_sys_setrlimit(unsigned int resource,
 		struct compat_rlimit __user *rlim)
 {
-- 
1.6.5.2

