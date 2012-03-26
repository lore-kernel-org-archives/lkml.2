Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331Ab2CZSkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:40:01 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:52596 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933197Ab2CZSjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:39:35 -0400
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Cc: David Sharp <dhsharp@google.com>, Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Michael Davidson <md@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 2/6] trace: add support for 32 bit compat syscalls on x86_64
Date: Mon, 26 Mar 2012 11:39:24 -0700
Message-Id: <1332787168-20457-3-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>
References: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Davidson <md@google.com>

Add support for a set of events to trace 32 bit compat system calls
in addition to the native 64 bit system calls.

Events for compat system calls have event names of the form:
  syscalls:sys_enter_compat_<name>
  syscalls:sys_exit_compat_<name>

The ascii formatted version of trace events that can be read from
the tracing/trace file reports compat system calls as:
  compat_<name>(...)

- add CONFIG_FTRACE_COMPAT_SYSCALLS

- add a "compat" flag to the syscall_metadata struct so that we can
  distinguish between "native" and "compat" metadata at init time
  when building the system call # to metadata mapping tables

- add a COMPAT_SYSCALL_METADATAx() macro to define system call
  metadata for compat system calls

- define a set of COMPAT_SYSCALL_METADATA[0-6] macros

- modify syscall_nr_to_meta() to know about compat system calls
  and return a pointer to the correct metadata

- modify print_syscall_{enter|exit}() to find the system call metadata
  by looking in the containing ftrace_event_call struct

- add system call metadata definitions for the x86_64 32 bit compat
  system calls

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 arch/x86/ia32/Makefile                |    2 +
 arch/x86/ia32/ia32_syscall_metadata.c |  443 +++++++++++++++++++++++++++++++++
 fs/dcookies.c                         |    2 +-
 fs/open.c                             |    2 +-
 fs/read_write.c                       |    8 +-
 fs/sync.c                             |    8 +-
 include/linux/syscalls.h              |   24 ++-
 include/trace/syscall.h               |   18 ++-
 kernel/trace/Kconfig                  |    6 +
 kernel/trace/trace_syscalls.c         |   24 ++-
 mm/fadvise.c                          |    5 +-
 mm/filemap.c                          |    2 +-
 12 files changed, 521 insertions(+), 23 deletions(-)
 create mode 100644 arch/x86/ia32/ia32_syscall_metadata.c

diff --git a/arch/x86/ia32/Makefile b/arch/x86/ia32/Makefile
index 455646e..ba6d3c8 100644
--- a/arch/x86/ia32/Makefile
+++ b/arch/x86/ia32/Makefile
@@ -12,3 +12,5 @@ obj-$(CONFIG_IA32_AOUT) += ia32_aout.o
 
 audit-class-$(CONFIG_AUDIT) := audit.o
 obj-$(CONFIG_IA32_EMULATION) += $(audit-class-y)
+
+obj-$(CONFIG_FTRACE_COMPAT_SYSCALLS) += ia32_syscall_metadata.o
diff --git a/arch/x86/ia32/ia32_syscall_metadata.c b/arch/x86/ia32/ia32_syscall_metadata.c
new file mode 100644
index 0000000..8001794
--- /dev/null
+++ b/arch/x86/ia32/ia32_syscall_metadata.c
@@ -0,0 +1,443 @@
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/module.h>
+#include <asm/asm-offsets.h>
+
+/*
+ * syscall metadata for 32 bit compatible system calls
+ *
+ * The metadata entries are in the same order as the system call table
+ * but this is just to make it easier to check them for completeness
+ * and correctness.
+ */
+
+COMPAT_SYSCALL_METADATA0(restart_syscall)
+COMPAT_SYSCALL_METADATA1(exit, int, error_code)
+/* fork */
+COMPAT_SYSCALL_METADATA3(read, unsigned int, fd, char __user *, buf, size_t, count)
+COMPAT_SYSCALL_METADATA3(write, unsigned int, fd, const char __user *, buf, size_t, count)
+COMPAT_SYSCALL_METADATA3(open, const char __user *, filename, int, flags, int, mode)
+COMPAT_SYSCALL_METADATA1(close, unsigned int, fd)
+COMPAT_SYSCALL_METADATA3(waitpid, compat_pid_t, pid, int __user *, stat_addr, int, options)
+COMPAT_SYSCALL_METADATA2(creat, const char __user *, pathname, int, mode)
+COMPAT_SYSCALL_METADATA2(link, const char __user *, oldname, const char __user *, newname)
+COMPAT_SYSCALL_METADATA1(unlink, const char __user *, pathname)
+/* execve */
+COMPAT_SYSCALL_METADATA1(chdir, const char __user *, filename)
+COMPAT_SYSCALL_METADATA1(time, compat_time_t __user *, tloc)
+COMPAT_SYSCALL_METADATA3(mknod, const char __user *, filename, int, mode, unsigned, dev)
+COMPAT_SYSCALL_METADATA2(chmod, const char __user *, filename, mode_t, mode)
+COMPAT_SYSCALL_METADATA3(lchown16, const char __user *, filename, old_uid_t, user, old_gid_t, group)
+/* ni */
+COMPAT_SYSCALL_METADATA2(stat, char __user *, filename, struct __old_kernel_stat __user *, statbuf)
+COMPAT_SYSCALL_METADATA3(lseek, unsigned int, fd, int, offset, unsigned int, whence)
+COMPAT_SYSCALL_METADATA0(getpid)
+COMPAT_SYSCALL_METADATA5(mount, char __user *, dev_name, char __user *, dir_name, char __user *, type, unsigned long, flags, void __user *, data)
+COMPAT_SYSCALL_METADATA1(oldumount, char __user *, name)
+COMPAT_SYSCALL_METADATA1(setuid16, old_uid_t, uid)
+COMPAT_SYSCALL_METADATA0(getuid16)
+COMPAT_SYSCALL_METADATA1(stime, compat_time_t __user *, tptr)
+COMPAT_SYSCALL_METADATA4(ptrace, compat_long_t, request, compat_long_t, pid, compat_long_t, addr, compat_long_t, data)
+COMPAT_SYSCALL_METADATA1(alarm, unsigned int, seconds)
+COMPAT_SYSCALL_METADATA2(fstat, unsigned int, fd, struct __old_kernel_stat __user *, statbuf)
+COMPAT_SYSCALL_METADATA0(pause)
+COMPAT_SYSCALL_METADATA2(utime, char __user *, filename, struct compat_utimbuf __user *, times)
+/* ni */
+/* ni */
+COMPAT_SYSCALL_METADATA2(access, const char __user *, filename, int, mode)
+COMPAT_SYSCALL_METADATA1(nice, int, increment)
+/* ni */
+COMPAT_SYSCALL_METADATA0(sync)
+COMPAT_SYSCALL_METADATA2(kill, int, pid, int, sig)
+COMPAT_SYSCALL_METADATA2(rename, const char __user *, oldname, const char __user *, newname)
+COMPAT_SYSCALL_METADATA2(mkdir, const char __user *, pathname, int, mode)
+COMPAT_SYSCALL_METADATA1(rmdir, const char __user *, pathname)
+COMPAT_SYSCALL_METADATA1(dup, unsigned int, fildes)
+COMPAT_SYSCALL_METADATA1(pipe, int __user *, fildes)
+COMPAT_SYSCALL_METADATA1(times, struct compat_tms __user *, tbuf)
+/* ni */
+COMPAT_SYSCALL_METADATA1(brk, unsigned long, brk)
+COMPAT_SYSCALL_METADATA1(setgid16, old_gid_t, gid)
+COMPAT_SYSCALL_METADATA0(getgid16)
+COMPAT_SYSCALL_METADATA2(signal, int, sig, __sighandler_t, handler)
+COMPAT_SYSCALL_METADATA0(geteuid16)
+COMPAT_SYSCALL_METADATA0(getegid16)
+COMPAT_SYSCALL_METADATA1(acct, const char __user *, name)
+COMPAT_SYSCALL_METADATA2(umount, char __user *, name, int, flags)
+/* ni */
+COMPAT_SYSCALL_METADATA3(ioctl, unsigned int, fd, unsigned int, cmd, unsigned long, arg)
+/* ni */
+COMPAT_SYSCALL_METADATA2(setpgid, pid_t, pid, pid_t, pgid)
+/* ni */
+COMPAT_SYSCALL_METADATA1(olduname, struct oldold_utsname __user *, name)
+COMPAT_SYSCALL_METADATA1(umask, int, mask)
+COMPAT_SYSCALL_METADATA1(chroot, const char __user *, filename)
+COMPAT_SYSCALL_METADATA2(ustat, unsigned, dev, struct compat_ustat __user *, ubuf)
+COMPAT_SYSCALL_METADATA2(dup2, unsigned int, oldfd, unsigned int, newfd)
+COMPAT_SYSCALL_METADATA0(getppid)
+COMPAT_SYSCALL_METADATA0(getpgrp)
+COMPAT_SYSCALL_METADATA0(setsid)
+COMPAT_SYSCALL_METADATA3(sigaction, int, sig, struct old_sigaction32 __user *, act, struct old_sigaction32 __user *, oact)
+COMPAT_SYSCALL_METADATA0(sgetmask)
+COMPAT_SYSCALL_METADATA1(ssetmask, int, newmask)
+COMPAT_SYSCALL_METADATA2(setreuid16, old_uid_t, ruid, old_uid_t, euid)
+COMPAT_SYSCALL_METADATA2(setregid16, old_gid_t, rgid, old_gid_t, egid)
+COMPAT_SYSCALL_METADATA3(sigsuspend, int, history0, int, history1, old_sigset_t, mask)
+COMPAT_SYSCALL_METADATA1(sigpending, compat_old_sigset_t __user *, set)
+COMPAT_SYSCALL_METADATA2(sethostname, char __user *, name, int, len)
+COMPAT_SYSCALL_METADATA2(setrlimit, unsigned int, resource, struct compat_rlimit __user *, rlim)
+COMPAT_SYSCALL_METADATA2(old_getrlimit, unsigned int, resource, struct compat_rlimit __user *, rlim)
+COMPAT_SYSCALL_METADATA2(getrusage, int, who, struct compat_rusage __user *, ru)
+COMPAT_SYSCALL_METADATA2(gettimeofday, struct compat_timeval __user *, tv, struct timezone __user *, tz)
+COMPAT_SYSCALL_METADATA2(settimeofday, struct compat_timeval __user *, tv, struct timezone __user *, tz)
+COMPAT_SYSCALL_METADATA2(getgroups16, int, gidsetsize, old_gid_t __user *, grouplist)
+COMPAT_SYSCALL_METADATA2(setgroups16, int, gidsetsize, old_gid_t __user *, grouplist)
+COMPAT_SYSCALL_METADATA1(old_select, struct compat_sel_arg_struct __user *, arg)
+COMPAT_SYSCALL_METADATA2(symlink, const char __user *, oldname, const char __user *, newname)
+COMPAT_SYSCALL_METADATA2(lstat, char __user *, filename, struct __old_kernel_stat __user *, statbuf)
+COMPAT_SYSCALL_METADATA3(readlink, const char __user *, path, char __user *, buf, int, bufsiz)
+COMPAT_SYSCALL_METADATA1(uselib, const char __user *, library)
+COMPAT_SYSCALL_METADATA2(swapon, const char __user *, specialfile, int, swap_flags)
+COMPAT_SYSCALL_METADATA4(reboot, int, magic1, int, magic2, unsigned int, cmd, void __user *, arg)
+COMPAT_SYSCALL_METADATA3(old_readdir, unsigned int, fd, struct compat_old_linux_dirent __user *, dirent, unsigned int, count)
+COMPAT_SYSCALL_METADATA1(mmap, struct mmap_arg_struct32 __user *, arg)
+COMPAT_SYSCALL_METADATA2(munmap, unsigned long, addr, size_t, len)
+COMPAT_SYSCALL_METADATA2(truncate, const char __user *, path, long, length)
+COMPAT_SYSCALL_METADATA2(ftruncate, unsigned int, fd, unsigned long, length)
+COMPAT_SYSCALL_METADATA2(fchmod, unsigned int, fd, mode_t, mode)
+COMPAT_SYSCALL_METADATA3(fchown16, unsigned int, fd, old_uid_t, user, old_gid_t, group)
+COMPAT_SYSCALL_METADATA2(getpriority, int, which, int, who)
+COMPAT_SYSCALL_METADATA3(setpriority, int, which, int, who, int, niceval)
+/* ni */
+COMPAT_SYSCALL_METADATA2(statfs, const char __user *, pathname, struct compat_statfs __user *, buf)
+COMPAT_SYSCALL_METADATA2(fstatfs, unsigned int, fd, struct compat_statfs __user *, buf)
+COMPAT_SYSCALL_METADATA3(ioperm, unsigned long, from, unsigned long, num, int, turn_on)
+COMPAT_SYSCALL_METADATA2(socketcall, int, call, u32 __user *, args)
+COMPAT_SYSCALL_METADATA3(syslog, int, type, char __user *, buf, int, len)
+COMPAT_SYSCALL_METADATA3(setitimer, int, which, struct compat_itimerval __user *, in, struct compat_itimerval __user *, out)
+COMPAT_SYSCALL_METADATA2(getitimer, int, which, struct compat_itimerval __user *, it)
+COMPAT_SYSCALL_METADATA2(newstat, char __user *, filename, struct compat_stat __user *, statbuf)
+COMPAT_SYSCALL_METADATA2(newlstat, char __user *, filename, struct compat_stat __user *, statbuf)
+COMPAT_SYSCALL_METADATA2(newfstat, unsigned int, fd, struct compat_stat __user *, statbuf)
+COMPAT_SYSCALL_METADATA1(uname, struct old_utsname __user *, name)
+COMPAT_SYSCALL_METADATA1(iopl, unsigned int, level)
+COMPAT_SYSCALL_METADATA0(vhangup)
+/* ni */
+/* sys32_vm86_warning */
+COMPAT_SYSCALL_METADATA4(wait4, compat_pid_t, pid, compat_uint_t __user *, stat_addr, int, options, struct compat_rusage __user *, ru)
+COMPAT_SYSCALL_METADATA1(swapoff, const char __user *, specialfile)
+COMPAT_SYSCALL_METADATA1(sysinfo, struct compat_sysinfo __user *, info)
+COMPAT_SYSCALL_METADATA6(ipc, u32, call, int, first, int, second, int, third, compat_uptr_t, ptr, u32, fifth)
+COMPAT_SYSCALL_METADATA1(fsync, unsigned int, fd)
+/* stub32_sigreturn */
+/* stub32_clone */
+COMPAT_SYSCALL_METADATA2(setdomainname, char __user *, name, int, len)
+COMPAT_SYSCALL_METADATA1(newuname, struct new_utsname __user *, name)
+/* sys_modify_ldt */
+COMPAT_SYSCALL_METADATA1(adjtimex, struct compat_timex __user *, utp)
+COMPAT_SYSCALL_METADATA3(mprotect, unsigned long, start, size_t, len, unsigned long, prot)
+COMPAT_SYSCALL_METADATA3(sigprocmask, int, how, compat_old_sigset_t __user *, set, compat_old_sigset_t __user *, oset)
+/* ni */
+COMPAT_SYSCALL_METADATA3(init_module, void __user *, umod, unsigned long, len, const char __user *, uargs)
+COMPAT_SYSCALL_METADATA2(delete_module, const char __user *, name_user, unsigned int, flags)
+/* ni */
+COMPAT_SYSCALL_METADATA4(quotactl, unsigned int, cmd, const char __user *, special, qid_t, id, void __user *, addr)
+COMPAT_SYSCALL_METADATA1(getpgid, pid_t, pid)
+COMPAT_SYSCALL_METADATA1(fchdir, unsigned int, fd)
+/* ni */
+COMPAT_SYSCALL_METADATA3(sysfs, int, option, unsigned long, arg1, unsigned long, arg2)
+COMPAT_SYSCALL_METADATA1(personality, u_long, personality)
+/* ni */
+COMPAT_SYSCALL_METADATA1(setfsuid16, old_uid_t, uid)
+COMPAT_SYSCALL_METADATA1(setfsgid16, old_gid_t, gid)
+COMPAT_SYSCALL_METADATA5(llseek, unsigned int, fd, unsigned long, offset_high, unsigned long, offset_low, loff_t __user *, result, unsigned int, origin)
+COMPAT_SYSCALL_METADATA3(getdents, unsigned int, fd, struct compat_linux_dirent __user *, dirent, unsigned int, count)
+COMPAT_SYSCALL_METADATA5(select, int, n, compat_ulong_t __user *, inp, compat_ulong_t __user *, outp, compat_ulong_tt __user *, exp, struct compat_timeval __user *, tvp)
+COMPAT_SYSCALL_METADATA2(flock, unsigned int, fd, unsigned int, cmd)
+COMPAT_SYSCALL_METADATA3(msync, unsigned long, start, size_t, len, int, flags)
+COMPAT_SYSCALL_METADATA3(readv, unsigned long, fd, const struct compat_iovec __user *, vec, unsigned long, vlen)
+COMPAT_SYSCALL_METADATA3(writev, unsigned long, fd, const struct compat_iovec __user *, vec, unsigned long, vlen)
+COMPAT_SYSCALL_METADATA1(getsid, pid_t, pid)
+COMPAT_SYSCALL_METADATA1(fdatasync, unsigned int, fd)
+COMPAT_SYSCALL_METADATA1(sysctl, struct compat_sysctl_args __user *, args)
+COMPAT_SYSCALL_METADATA2(mlock, unsigned long, start, size_t, len)
+COMPAT_SYSCALL_METADATA1(mlockall, int, flags)
+COMPAT_SYSCALL_METADATA2(munlock, unsigned long, start, size_t, len)
+COMPAT_SYSCALL_METADATA0(munlockall)
+COMPAT_SYSCALL_METADATA2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
+COMPAT_SYSCALL_METADATA2(sched_getparam, pid_t, pid, struct sched_param __user *, param)
+COMPAT_SYSCALL_METADATA3(sched_setscheduler, pid_t, pid, int, policy, struct sched_param __user *, param)
+COMPAT_SYSCALL_METADATA1(sched_getscheduler, pid_t, pid)
+COMPAT_SYSCALL_METADATA0(sched_yield)
+COMPAT_SYSCALL_METADATA1(sched_get_priority_max, int, policy)
+COMPAT_SYSCALL_METADATA1(sched_get_priority_min, int, policy)
+COMPAT_SYSCALL_METADATA2(sched_rr_get_interval, compat_pid_t, pid, struct compat_timespec __user *, interval)
+COMPAT_SYSCALL_METADATA2(nanosleep, struct compat_timespec __user *, rqtp, struct compat_timespec __user *, rmtp)
+COMPAT_SYSCALL_METADATA5(mremap, unsigned long, addr, unsigned long, old_len, unsigned long, new_len, unsigned long, flags, unsigned long, new_addr)
+COMPAT_SYSCALL_METADATA3(setresuid16, old_uid_t, ruid, old_uid_t, euid, old_uid_t, suid)
+COMPAT_SYSCALL_METADATA3(getresuid16, old_uid_t __user *, ruid, old_uid_t __user *, euid, old_uid_t __user *, suid)
+/* sys32_vm86_warning */
+/* ni */
+COMPAT_SYSCALL_METADATA3(poll, struct pollfd __user *, ufds, unsigned int, nfds, long, timeout_msecs)
+COMPAT_SYSCALL_METADATA3(nfsservctl, int, cmd, struct compat_nfsctl_arg __user *, arg, struct compat_nfsctl_res  __user *, res)
+COMPAT_SYSCALL_METADATA3(setresgid16, old_gid_t, rgid, old_gid_t, egid, old_gid_t, sgid)
+COMPAT_SYSCALL_METADATA3(getresgid16, old_gid_t __user *, rgid, old_gid_t __user *, egid, old_gid_t __user *, sgid)
+COMPAT_SYSCALL_METADATA5(prctl, int, option, unsigned long, arg2, unsigned long, arg3, unsigned long, arg4, unsigned long, arg5)
+/* stub32_rt_sigreturn */
+COMPAT_SYSCALL_METADATA4(rt_sigaction, int, sig, const struct sigaction32 __user *, act, struct sigaction32 __user *, oact, unsigned int , sigsetsize)
+COMPAT_SYSCALL_METADATA4(rt_sigprocmask, int, how, compat_sigset_t __user *, set, compat_sigset_t __user *, oset, unsigned int, sigsetsize)
+COMPAT_SYSCALL_METADATA2(rt_sigpending, compat_sigset_t __user *, set, unsigned int, sigsetsize)
+COMPAT_SYSCALL_METADATA4(rt_sigtimedwait, const compat_sigset_t __user *, uthese, compat_siginfo_t __user *, uinfo, const struct compat_timespec __user *, uts, compat_size_t, sigsetsize)
+COMPAT_SYSCALL_METADATA3(rt_sigqueueinfo, int, pid, int, sig, compat_siginfo_t __user *, uinfo)
+COMPAT_SYSCALL_METADATA2(rt_sigsuspend, sigset_t __user *, unewset, size_t, sigsetsize)
+COMPAT_SYSCALL_METADATA5(pread, unsigned int,  fd, char __user *, ubuf, u32, count, u32,  poslo, u32,  poshi)
+COMPAT_SYSCALL_METADATA5(pwrite, unsigned int,  fd, char __user *, ubuf, u32, count, u32,  poslo, u32,  poshi)
+COMPAT_SYSCALL_METADATA3(chown16, const char __user *, filename, old_uid_t, user, old_gid_t, group)
+COMPAT_SYSCALL_METADATA2(getcwd, char __user *, buf, unsigned long, size)
+COMPAT_SYSCALL_METADATA2(capget, cap_user_header_t, header, cap_user_data_t, dataptr)
+COMPAT_SYSCALL_METADATA2(capset, cap_user_header_t, header, const cap_user_data_t, data)
+COMPAT_SYSCALL_METADATA2(sigaltstack, const stack_ia32_t __user *, uss_ptr, stack_ia32_t __user *, uoss_ptr)
+COMPAT_SYSCALL_METADATA4(sendfile, int, out_fd, int, in_fd, compat_off_t __user *, offset, s32, count)
+/* ni */
+/* ni */
+/* stub32_vfork */
+COMPAT_SYSCALL_METADATA2(getrlimit, unsigned int, resource, struct rlimit __user *, rlim)
+COMPAT_SYSCALL_METADATA6(mmap_pgoff, unsigned long, addr, unsigned long, len, unsigned long, prot, unsigned long, flags, unsigned long, fd, unsigned long, pgoff)
+COMPAT_SYSCALL_METADATA3(truncate64, const char __user *,  path, unsigned long, offset_lo, unsigned long, offset_high)
+COMPAT_SYSCALL_METADATA3(ftruncate64, unsigned  int, fd, unsigned long, offset_lo, unsigned long, offset_high)
+COMPAT_SYSCALL_METADATA2(stat64, char __user *, filename, struct stat64 __user *, statbuf)
+COMPAT_SYSCALL_METADATA2(lstat64, char __user *, filename, struct stat64 __user *, statbuf)
+COMPAT_SYSCALL_METADATA2(fstat64, unsigned long, fd, struct stat64 __user *, statbuf)
+COMPAT_SYSCALL_METADATA3(lchown, const char __user *, filename, uid_t, user, gid_t, group)
+COMPAT_SYSCALL_METADATA0(getuid)
+COMPAT_SYSCALL_METADATA0(getgid)
+COMPAT_SYSCALL_METADATA0(geteuid)
+COMPAT_SYSCALL_METADATA0(getegid)
+COMPAT_SYSCALL_METADATA2(setreuid, uid_t, ruid, uid_t, euid)
+COMPAT_SYSCALL_METADATA2(setregid, gid_t, rgid, gid_t, egid)
+COMPAT_SYSCALL_METADATA2(getgroups, int, gidsetsize, gid_t __user *, grouplist)
+COMPAT_SYSCALL_METADATA2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
+COMPAT_SYSCALL_METADATA3(fchown, unsigned int, fd, uid_t, user, gid_t, group)
+COMPAT_SYSCALL_METADATA3(setresuid, uid_t, ruid, uid_t, euid, uid_t, suid)
+COMPAT_SYSCALL_METADATA3(getresuid, uid_t __user *, ruid, uid_t __user *, euid, uid_t __user *, suid)
+COMPAT_SYSCALL_METADATA3(setresgid, gid_t, rgid, gid_t, egid, gid_t, sgid)
+COMPAT_SYSCALL_METADATA3(getresgid, gid_t __user *, rgid, gid_t __user *, egid, gid_t __user *, sgid)
+COMPAT_SYSCALL_METADATA3(chown, const char __user *, filename, uid_t, user, gid_t, group)
+COMPAT_SYSCALL_METADATA1(setuid, uid_t, uid)
+COMPAT_SYSCALL_METADATA1(setgid, gid_t, gid)
+COMPAT_SYSCALL_METADATA1(setfsuid, uid_t, uid)
+COMPAT_SYSCALL_METADATA1(setfsgid, gid_t, gid)
+COMPAT_SYSCALL_METADATA2(pivot_root, const char __user *, new_root, const char __user *, put_old)
+COMPAT_SYSCALL_METADATA3(mincore, unsigned long, start, size_t, len, unsigned char __user *, vec)
+COMPAT_SYSCALL_METADATA3(madvise, unsigned long, start, size_t, len_in, int, behavior)
+COMPAT_SYSCALL_METADATA3(getdents64, unsigned int, fd, struct linux_dirent64 __user *, dirent, unsigned int, count)
+COMPAT_SYSCALL_METADATA3(fcntl64, unsigned int, fd, unsigned int, cmd, unsigned long, arg)
+/* ni */
+/* ni */
+COMPAT_SYSCALL_METADATA0(gettid)
+COMPAT_SYSCALL_METADATA4(readahead, int, fd, unsigned, off_lo, unsigned, off_hi, size_t, count)
+COMPAT_SYSCALL_METADATA5(setxattr, const char __user *, pathname, const char __user *, name, const void __user *, value, size_t, size, int, flags)
+COMPAT_SYSCALL_METADATA5(lsetxattr, const char __user *, pathname, const char __user *, name, const void __user *, value, size_t, size, int, flags)
+COMPAT_SYSCALL_METADATA5(fsetxattr, int, fd, const char __user *, name, const void __user *,value, size_t, size, int, flags)
+COMPAT_SYSCALL_METADATA4(getxattr, const char __user *, pathname, const char __user *, name, void __user *, value, size_t, size)
+COMPAT_SYSCALL_METADATA4(fgetxattr, int, fd, const char __user *, name, void __user *, value, size_t, size)
+COMPAT_SYSCALL_METADATA4(lgetxattr, const char __user *, pathname, const char __user *, name, void __user *, value, size_t, size)
+COMPAT_SYSCALL_METADATA3(listxattr, const char __user *, pathname, char __user *, list, size_t, size)
+COMPAT_SYSCALL_METADATA3(llistxattr, const char __user *, pathname, char __user *, list, size_t, size)
+COMPAT_SYSCALL_METADATA3(flistxattr, int, fd, char __user *, list, size_t, size)
+COMPAT_SYSCALL_METADATA2(removexattr, const char __user *, pathname, const char __user *, name)
+COMPAT_SYSCALL_METADATA2(lremovexattr, const char __user *, pathname, const char __user *, name)
+COMPAT_SYSCALL_METADATA2(fremovexattr, int, fd, const char __user *, name)
+COMPAT_SYSCALL_METADATA2(tkill, pid_t, pid, int, sig)
+COMPAT_SYSCALL_METADATA4(sendfile64, int, out_fd, int, in_fd, loff_t __user *, offset, size_t, count)
+COMPAT_SYSCALL_METADATA6(futex, u32 __user *, uaddr, int, op, u32, val, struct compat_timespec __user *, utime, u32 __user *, uaddr2, u32, val3)
+COMPAT_SYSCALL_METADATA3(sched_setaffinity, compat_pid_t, pid, unsigned int, len, compat_ulong_t __user *, user_mask_ptr)
+COMPAT_SYSCALL_METADATA3(sched_getaffinity, compat_pid_t, pid, unsigned int, len, compat_ulong_t __user *, user_mask_ptr)
+COMPAT_SYSCALL_METADATA1(set_thread_area, struct user_desc __user *, u_info)
+COMPAT_SYSCALL_METADATA1(get_thread_area, struct user_desc __user *, u_info)
+COMPAT_SYSCALL_METADATA2(io_setup, unsigned, nr_reqs, u32 __user *, ctxp)
+COMPAT_SYSCALL_METADATA1(io_destroy, aio_context_t, ctx)
+COMPAT_SYSCALL_METADATA5(io_getevents, aio_context_t, ctx_id, long, min_nr, long, nr, struct io_event __user *, events, struct timespec __user *, timeout)
+COMPAT_SYSCALL_METADATA3(io_submit, aio_context_t, ctx_id, long, nr, struct iocb __user * __user *, iocbpp)
+COMPAT_SYSCALL_METADATA3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb, struct io_event __user *, result)
+COMPAT_SYSCALL_METADATA6(fadvise64, int, fd, __u32, offset_low, __u32, offset_high, __u32, len_low, __u32, len_high, int, advice)
+/* ni */
+COMPAT_SYSCALL_METADATA1(exit_group, int, error_code)
+COMPAT_SYSCALL_METADATA3(lookup_dcookie, u64,  cookie64, char __user *,  buf, size_t, len)
+COMPAT_SYSCALL_METADATA1(epoll_create, int, size)
+COMPAT_SYSCALL_METADATA4(epoll_ctl, int, epfd, int, op, int, fd, struct epoll_event __user *, event)
+COMPAT_SYSCALL_METADATA4(epoll_wait, int, epfd, struct epoll_event __user *, events, int, maxevents, int, timeout)
+COMPAT_SYSCALL_METADATA5(remap_file_pages, unsigned long, start, unsigned long, size, unsigned long, prot, unsigned long, pgoff, unsigned long, flags)
+COMPAT_SYSCALL_METADATA1(set_tid_address, int __user *, tidptr)
+COMPAT_SYSCALL_METADATA3(timer_create, const clockid_t, which_clock, struct sigevent __user *, timer_event_spec, timer_t __user *, created_timer_id)
+COMPAT_SYSCALL_METADATA4(timer_settime, timer_t, timer_id, int, flags, const struct itimerspec __user *, new_setting, struct itimerspec __user *, old_setting)
+COMPAT_SYSCALL_METADATA2(timer_gettime, timer_t, timer_id, struct itimerspec __user *, setting)
+COMPAT_SYSCALL_METADATA1(timer_getoverrun, timer_t, timer_id)
+COMPAT_SYSCALL_METADATA1(timer_delete, timer_t, timer_id)
+COMPAT_SYSCALL_METADATA2(clock_settime, const clockid_t, which_clock, const struct timespec __user *, tp)
+COMPAT_SYSCALL_METADATA2(clock_gettime, const clockid_t, which_clock, struct timespec __user *,tp)
+COMPAT_SYSCALL_METADATA2(clock_getres, const clockid_t, which_clock, struct timespec __user *, tp)
+COMPAT_SYSCALL_METADATA4(clock_nanosleep, const clockid_t, which_clock, int, flags, const struct timespec __user *, rqtp, struct timespec __user *, rmtp)
+COMPAT_SYSCALL_METADATA3(statfs64, const char __user *, pathname, size_t, sz, struct statfs64 __user *, buf)
+COMPAT_SYSCALL_METADATA3(fstatfs64, unsigned int, fd, size_t, sz, struct statfs64 __user *, buf)
+COMPAT_SYSCALL_METADATA3(tgkill, pid_t, tgid, pid_t, pid, int, sig)
+COMPAT_SYSCALL_METADATA2(utimes, char __user *, filename, struct timeval __user *, utimes)
+COMPAT_SYSCALL_METADATA4(fadvise64_64, int, fd, loff_t, offset, loff_t, len, int, advice)
+/* ni */
+COMPAT_SYSCALL_METADATA6(mbind, unsigned long, start, unsigned long, len, unsigned long, mode, unsigned long __user *, nmask, unsigned long, maxnode, unsigned, flags)
+COMPAT_SYSCALL_METADATA5(get_mempolicy, int __user *, policy, unsigned long __user *, nmask, unsigned long, maxnode, unsigned long, addr, unsigned long, flags)
+COMPAT_SYSCALL_METADATA3(set_mempolicy, int, mode, unsigned long __user *, nmask, unsigned long, maxnode)
+COMPAT_SYSCALL_METADATA4(mq_open, const char __user *, u_name, int, oflag, mode_t, mode, struct mq_attr __user *, u_attr)
+COMPAT_SYSCALL_METADATA1(mq_unlink, const char __user *, u_name)
+COMPAT_SYSCALL_METADATA5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr, size_t, msg_len, unsigned int, msg_prio, const struct timespec __user *, u_abs_timeout)
+COMPAT_SYSCALL_METADATA5(mq_timedreceive, mqd_t, mqdes, char __user *, u_msg_ptr, size_t, msg_len, unsigned int __user *, u_msg_prio, const struct timespec __user *, u_abs_timeout)
+COMPAT_SYSCALL_METADATA2(mq_notify, mqd_t, mqdes, const struct sigevent __user *, u_notification)
+COMPAT_SYSCALL_METADATA3(mq_getsetattr, mqd_t, mqdes, const struct mq_attr __user *, u_mqstat, struct mq_attr __user *, u_omqstat)
+COMPAT_SYSCALL_METADATA4(kexec_load, unsigned long, entry, unsigned long, nr_segments, struct kexec_segment __user *, segments, unsigned long, flags)
+COMPAT_SYSCALL_METADATA5(waitid, int, which, pid_t, upid, struct siginfo __user *, infop, int, options, struct rusage __user *, ru)
+/* ni */
+COMPAT_SYSCALL_METADATA5(add_key, const char __user *, _type, const char __user *, _description, const void __user *, _payload, size_t, plen, key_serial_t, ringid)
+COMPAT_SYSCALL_METADATA4(request_key, const char __user *, _type, const char __user *, _description, const char __user *, _callout_info,  key_serial_t, destringid)
+COMPAT_SYSCALL_METADATA5(keyctl, int, option, unsigned long, arg2, unsigned long, arg3, unsigned long, arg4, unsigned long, arg5)
+COMPAT_SYSCALL_METADATA3(ioprio_set, int, which, int, who, int, ioprio)
+COMPAT_SYSCALL_METADATA2(ioprio_get, int, which, int, who)
+COMPAT_SYSCALL_METADATA0(inotify_init)
+COMPAT_SYSCALL_METADATA3(inotify_add_watch, int, fd, const char __user *, pathname, u32, mask)
+COMPAT_SYSCALL_METADATA2(inotify_rm_watch, int, fd, __s32, wd)
+COMPAT_SYSCALL_METADATA4(migrate_pages, pid_t, pid, unsigned long, maxnode, const unsigned long __user *, old_nodes, const unsigned long __user *, new_nodes)
+COMPAT_SYSCALL_METADATA4(openat, int, dfd, const char __user *, filename, int, flags, int, mode)
+COMPAT_SYSCALL_METADATA3(mkdirat, int, dfd, const char __user *, pathname, int, mode)
+COMPAT_SYSCALL_METADATA4(mknodat, int, dfd, const char __user *, filename, int, mode, unsigned, dev)
+COMPAT_SYSCALL_METADATA5(fchownat, int, dfd, const char __user *, filename, uid_t, user, gid_t, group, int, flag)
+COMPAT_SYSCALL_METADATA3(futimesat, int, dfd, char __user *, filename, struct timeval __user *, utimes)
+COMPAT_SYSCALL_METADATA4(fstatat, int, dfd, char __user *, filename, struct stat64 __user *, statbuf, int, flag)
+COMPAT_SYSCALL_METADATA3(unlinkat, int, dfd, const char __user *, pathname, int, flag)
+COMPAT_SYSCALL_METADATA4(renameat, int, olddfd, const char __user *, oldname, int, newdfd, const char __user *, newname)
+COMPAT_SYSCALL_METADATA5(linkat, int, olddfd, const char __user *, oldname, int, newdfd, const char __user *, newname, int, flags)
+COMPAT_SYSCALL_METADATA3(symlinkat, const char __user *, oldname, int, newdfd, const char __user *, newname)
+COMPAT_SYSCALL_METADATA4(readlinkat, int, dfd, const char __user *, pathname, char __user *, buf, int, bufsiz)
+COMPAT_SYSCALL_METADATA3(fchmodat, int, dfd, const char __user *, filename, mode_t, mode)
+COMPAT_SYSCALL_METADATA3(faccessat, int, dfd, const char __user *, filename, int, mode)
+COMPAT_SYSCALL_METADATA6(pselect6, int, n, fd_set __user *, inp, fd_set __user *, outp, fd_set __user *, exp, struct timespec __user *, tsp, void __user *, sig)
+COMPAT_SYSCALL_METADATA5(ppoll, struct pollfd __user *, ufds, unsigned int, nfds, struct timespec __user *, tsp, const sigset_t __user *, sigmask, size_t, sigsetsize)
+COMPAT_SYSCALL_METADATA1(unshare, unsigned long, unshare_flags)
+COMPAT_SYSCALL_METADATA2(set_robust_list, struct robust_list_head __user *, head, compat_size_t, len)
+COMPAT_SYSCALL_METADATA3(get_robust_list, int, pid, struct robust_list_head __user * __user *, head_ptr, compat_size_t __user *, len_ptr)
+COMPAT_SYSCALL_METADATA6(splice, int, fd_in, loff_t __user *, off_in, int, fd_out, loff_t __user *, off_out, size_t, len, unsigned int, flags)
+COMPAT_SYSCALL_METADATA4(sync_file_range, int, fd, loff_t, offset, loff_t, nbytes, unsigned int, flags)
+COMPAT_SYSCALL_METADATA4(tee, int, fdin, int, fdout, size_t, len, unsigned int, flags)
+COMPAT_SYSCALL_METADATA4(vmsplice, int, fd, const struct compat_iovec __user *, iov, unsigned long, nr_segs, unsigned int, flags)
+COMPAT_SYSCALL_METADATA6(move_pages, pid_t, pid, unsigned long, nr_pages, const void __user * __user *, pages, const int __user *, nodes, int __user *, status, int, flags)
+COMPAT_SYSCALL_METADATA3(getcpu, unsigned __user *, cpup, unsigned __user *, nodep, struct getcpu_cache __user *, unused)
+COMPAT_SYSCALL_METADATA6(epoll_pwait, int, epfd, struct epoll_event __user *, events, int, maxevents, int, timeout, const sigset_t __user *, sigmask, size_t, sigsetsize)
+COMPAT_SYSCALL_METADATA4(utimensat, int, dfd, char __user *, filename, struct timespec __user *, utimes, int, flags)
+COMPAT_SYSCALL_METADATA3(signalfd, int, ufd, sigset_t __user *, user_mask, size_t, sizemask)
+COMPAT_SYSCALL_METADATA2(timerfd_create, int, clockid, int, flags)
+COMPAT_SYSCALL_METADATA1(eventfd, unsigned int, count)
+COMPAT_SYSCALL_METADATA4(fallocate, int, fd, int, mode, loff_t, offset, loff_t, len)
+COMPAT_SYSCALL_METADATA4(timerfd_settime, int, ufd, int, flags, const struct itimerspec __user *, utmr, struct itimerspec __user *, otmr)
+COMPAT_SYSCALL_METADATA2(timerfd_gettime, int, ufd, struct itimerspec __user *, otmr)
+COMPAT_SYSCALL_METADATA4(signalfd4, int, ufd, sigset_t __user *, user_mask, size_t, sizemask, int, flags)
+COMPAT_SYSCALL_METADATA2(eventfd2, unsigned int, count, int, flags)
+COMPAT_SYSCALL_METADATA1(epoll_create1, int, flags)
+COMPAT_SYSCALL_METADATA3(dup3, unsigned int, oldfd, unsigned int, newfd, int, flags)
+COMPAT_SYSCALL_METADATA2(pipe2, int __user *, fildes, int, flags)
+COMPAT_SYSCALL_METADATA1(inotify_init1, int, flags)
+COMPAT_SYSCALL_METADATA5(preadv, unsigned long, fd, const struct compat_iovec __user *, vec, unsigned long, vlen, u32, pos_low, 32, pos_high)
+COMPAT_SYSCALL_METADATA5(pwritev, unsigned long, fd, const struct compat_iovec __user *, vec, unsigned long, vlen, u32, pos_low, u32, pos_high)
+COMPAT_SYSCALL_METADATA4(rt_tgsigqueueinfo, pid_t, tgid, pid_t, pid, int, sig, siginfo_t __user *, uinfo)
+COMPAT_SYSCALL_METADATA5(perf_event_open, struct perf_event_attr __user *, attr_uptr, pid_t, pid, int, cpu, int, group_fd, unsigned long, flags)
+COMPAT_SYSCALL_METADATA5(recvmmsg, int, fd, struct mmsghdr __user *, mmsg, unsigned int, vlen, unsigned int, flags, struct timespec __user *, timeout)
+
+
+extern long ia32_sys_call_table[];
+
+int nr_compat_syscalls;
+struct syscall_metadata **compat_syscalls_metadata;
+
+static const char *prefixes[] = { "sys32", "stub32", "compat_sys", "sys", NULL };
+
+/*
+ * This is truly horrible.
+ *
+ * There is no header file that defines a *complete* set of 32 bit system
+ * call numbers (unistd_32.h only defines ones that are currently exported
+ * to user space and omits lots of old system calls that are still implemented
+ * by the kernel.
+ *
+ * There is also no table that can be used to map a system call number into
+ * the canonical name of that system call.
+ *
+ * So we are forced to use an even more unpleasant version of the technique
+ * used by ftrace to handle the normal system call metadata ...
+ *
+ * For each entry in the 32 bit system call table:
+ *	Look up the address in the kernel symbol table
+ *	Strip off any "sys32|stub32|sys|compat" prefix
+ *	Search through all of the compat metadata entries for a matching name
+ *
+ */
+static struct syscall_metadata __init *find_compat_syscall_meta(unsigned long addr)
+{
+	struct syscall_metadata **start;
+	struct syscall_metadata **stop;
+	char str[KSYM_SYMBOL_LEN];
+	const char *name;
+	const char **p;
+	extern struct syscall_metadata *__start_syscalls_metadata[];
+	extern struct syscall_metadata *__stop_syscalls_metadata[];
+
+	start = __start_syscalls_metadata;
+	stop = __stop_syscalls_metadata;
+	kallsyms_lookup(addr, NULL, NULL, NULL, str);
+
+	/*
+	 * If there is a {sys|compat|sys32|stub32} prefix strip it off
+	 */
+	for (p = prefixes, name = str; *p; p++) {
+		int len = strlen(*p);
+		if (strncmp(name, *p, len) == 0) {
+			name += len;
+			break;
+		}
+	}
+
+	for ( ; start < stop; start++) {
+		if (!(*start)->compat)
+			continue;
+
+		/*
+		 * ignore the "compat_" prefix on the metadata name
+		 * when doing the comparison
+		 */
+		if ((*start)->name && !strcmp((*start)->name + 6, name))
+			return *start;
+	}
+	return NULL;
+}
+
+static int __init init_compat_syscall_metadata(void)
+{
+	struct syscall_metadata *meta;
+	int	i;
+
+	nr_compat_syscalls = __NR_ia32_syscall_max;
+	compat_syscalls_metadata = kzalloc(sizeof(*compat_syscalls_metadata) *
+					nr_compat_syscalls, GFP_KERNEL);
+	if (!compat_syscalls_metadata) {
+		nr_compat_syscalls = -1;
+		WARN_ON(1);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < nr_compat_syscalls; i++) {
+		if ((meta = find_compat_syscall_meta(ia32_sys_call_table[i]))) {
+			meta->syscall_nr = i;
+			compat_syscalls_metadata[i] = meta;
+		}
+	}
+
+	return 0;
+}
+
+core_initcall(init_compat_syscall_metadata);
diff --git a/fs/dcookies.c b/fs/dcookies.c
index dda0dc7..9a448c8 100644
--- a/fs/dcookies.c
+++ b/fs/dcookies.c
@@ -145,7 +145,7 @@ out:
 /* And here is where the userspace process can look up the cookie value
  * to retrieve the path.
  */
-SYSCALL_DEFINE(lookup_dcookie)(u64 cookie64, char __user * buf, size_t len)
+SYSCALL_DEFINE3(lookup_dcookie, u64, cookie64, char __user *, buf, size_t, len)
 {
 	unsigned long cookie = (unsigned long)cookie64;
 	int err = -EINVAL;
diff --git a/fs/open.c b/fs/open.c
index 77becc0..cc5edeb 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -269,7 +269,7 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	return file->f_op->fallocate(file, mode, offset, len);
 }
 
-SYSCALL_DEFINE(fallocate)(int fd, int mode, loff_t offset, loff_t len)
+SYSCALL_DEFINE4(fallocate, int, fd, int, mode, loff_t, offset, loff_t, len)
 {
 	struct file *file;
 	int error = -EBADF;
diff --git a/fs/read_write.c b/fs/read_write.c
index 5ad4248..72b675b 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -492,8 +492,8 @@ SYSCALL_DEFINE3(write, unsigned int, fd, const char __user *, buf,
 	return ret;
 }
 
-SYSCALL_DEFINE(pread64)(unsigned int fd, char __user *buf,
-			size_t count, loff_t pos)
+SYSCALL_DEFINE4(pread64, unsigned int, fd, char __user *, buf,
+			size_t, count, loff_t, pos)
 {
 	struct file *file;
 	ssize_t ret = -EBADF;
@@ -521,8 +521,8 @@ asmlinkage long SyS_pread64(long fd, long buf, long count, loff_t pos)
 SYSCALL_ALIAS(sys_pread64, SyS_pread64);
 #endif
 
-SYSCALL_DEFINE(pwrite64)(unsigned int fd, const char __user *buf,
-			 size_t count, loff_t pos)
+SYSCALL_DEFINE4(pwrite64, unsigned int, fd, const char __user *, buf,
+			 size_t, count, loff_t, pos)
 {
 	struct file *file;
 	ssize_t ret = -EBADF;
diff --git a/fs/sync.c b/fs/sync.c
index f3501ef..584cbd0 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -271,8 +271,8 @@ EXPORT_SYMBOL(generic_write_sync);
  * already-instantiated disk blocks, there are no guarantees here that the data
  * will be available after a crash.
  */
-SYSCALL_DEFINE(sync_file_range)(int fd, loff_t offset, loff_t nbytes,
-				unsigned int flags)
+SYSCALL_DEFINE4(sync_file_range, int, fd, loff_t, offset, loff_t, nbytes,
+				unsigned int, flags)
 {
 	int ret;
 	struct file *file;
@@ -366,8 +366,8 @@ SYSCALL_ALIAS(sys_sync_file_range, SyS_sync_file_range);
 
 /* It would be nice if people remember that not all the world's an i386
    when they introduce new system calls */
-SYSCALL_DEFINE(sync_file_range2)(int fd, unsigned int flags,
-				 loff_t offset, loff_t nbytes)
+SYSCALL_DEFINE4(sync_file_range2, int, fd, unsigned int, flags,
+				 loff_t, offset, loff_t, nbytes)
 {
 	return sys_sync_file_range(fd, offset, nbytes, flags);
 }
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index ed0003c..a5b0cae 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -159,7 +159,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	  __attribute__((section("_ftrace_events")))			\
 	*__event_exit_##sname = &event_exit_##sname;
 
-#define SYSCALL_METADATAx(x, sname, ...)			\
+#define _SYSCALL_METADATAx(x, mname, sname, _compat, ...)	\
 	static const char *types_##sname[] = {			\
 		__SC_STR_TDECL##x(__VA_ARGS__)			\
 	};							\
@@ -170,11 +170,12 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	SYSCALL_TRACE_EXIT_EVENT(sname);			\
 	static struct syscall_metadata __used			\
 	  __syscall_meta_##sname = {				\
-		.name 		= "sys"#sname,			\
+		.name 		= mname,			\
 		.syscall_nr	= -1,	/* Filled in at boot */	\
 		.nb_args 	= x,				\
 		.types		= types_##sname,		\
 		.args		= args_##sname,			\
+		.compat		= _compat,			\
 		.enter_event	= &event_enter_##sname,		\
 		.exit_event	= &event_exit_##sname,		\
 		.enter_fields	= LIST_HEAD_INIT(__syscall_meta_##sname.enter_fields), \
@@ -182,6 +183,25 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	static struct syscall_metadata __used			\
 	  __attribute__((section("__syscalls_metadata")))	\
 	 *__p_syscall_meta_##sname = &__syscall_meta_##sname;
+
+#define SYSCALL_METADATAx(x, sname, ...)		\
+	_SYSCALL_METADATAx(x, "sys"#sname, sname, 0, __VA_ARGS__)
+
+#ifdef CONFIG_FTRACE_COMPAT_SYSCALLS
+
+#define COMPAT_SYSCALL_METADATAx(x, sname, ...)			\
+	_SYSCALL_METADATAx(x, "compat"#sname, _compat##sname, 1, __VA_ARGS__)
+
+#define COMPAT_SYSCALL_METADATA0(name, ...) COMPAT_SYSCALL_METADATAx(0, _##name, __VA_ARGS__)
+#define COMPAT_SYSCALL_METADATA1(name, ...) COMPAT_SYSCALL_METADATAx(1, _##name, __VA_ARGS__)
+#define COMPAT_SYSCALL_METADATA2(name, ...) COMPAT_SYSCALL_METADATAx(2, _##name, __VA_ARGS__)
+#define COMPAT_SYSCALL_METADATA3(name, ...) COMPAT_SYSCALL_METADATAx(3, _##name, __VA_ARGS__)
+#define COMPAT_SYSCALL_METADATA4(name, ...) COMPAT_SYSCALL_METADATAx(4, _##name, __VA_ARGS__)
+#define COMPAT_SYSCALL_METADATA5(name, ...) COMPAT_SYSCALL_METADATAx(5, _##name, __VA_ARGS__)
+#define COMPAT_SYSCALL_METADATA6(name, ...) COMPAT_SYSCALL_METADATAx(6, _##name, __VA_ARGS__)
+
+#endif /* CONFIG_FTRACE_COMPAT_SYSCALLS */
+
 #else
 #define SYSCALL_METADATAx(x, name, ...)
 #endif /* CONFIG_FTRACE_SYSCALLS */
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 31966a4..f495e55 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -21,8 +21,9 @@
  */
 struct syscall_metadata {
 	const char	*name;
-	int		syscall_nr;
-	int		nb_args;
+	u16		syscall_nr;
+	u8		nb_args;
+	u8		compat;
 	const char	**types;
 	const char	**args;
 	struct list_head enter_fields;
@@ -32,6 +33,19 @@ struct syscall_metadata {
 };
 
 #ifdef CONFIG_FTRACE_SYSCALLS
+
+#ifdef CONFIG_FTRACE_COMPAT_SYSCALLS
+
+extern int nr_compat_syscalls;
+extern struct syscall_metadata **compat_syscalls_metadata;
+
+static inline struct syscall_metadata *compat_syscall_nr_to_meta(int nr)
+{
+	return (nr < nr_compat_syscalls) ? compat_syscalls_metadata[nr]
+						  : NULL;
+}
+#endif /* CONFIG_FTRACE_COMPAT_SYSCALLS */
+
 extern unsigned long arch_syscall_addr(int nr);
 extern int init_syscall_trace(struct ftrace_event_call *call);
 
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index cd31345..cd0954b 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -240,6 +240,12 @@ config FTRACE_SYSCALLS
 	help
 	  Basic tracer to catch the syscall entry and exit events.
 
+config FTRACE_COMPAT_SYSCALLS
+	bool "Trace 32 bit compat syscalls"
+	depends on FTRACE_SYSCALLS
+	help
+	  Trace syscall entry and exit events for 32 bit compat syscalls.
+
 config TRACE_BRANCH_PROFILING
 	bool
 	select GENERIC_TRACER
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index cb65454..43a8685 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>	/* for MODULE_NAME_LEN via KSYM_SYMBOL_LEN */
 #include <linux/ftrace.h>
 #include <linux/perf_event.h>
+#include <linux/compat.h>
 #include <asm/syscall.h>
 
 #include "trace_output.h"
@@ -90,6 +91,10 @@ find_syscall_meta(unsigned long syscall)
 		return NULL;
 
 	for ( ; start < stop; start++) {
+#ifdef CONFIG_FTRACE_COMPAT_SYSCALLS
+		if ((*start)->compat)	/* skip compat syscalls */
+			continue;
+#endif
 		if ((*start)->name && arch_syscall_match_sym_name(str, (*start)->name))
 			return *start;
 	}
@@ -98,6 +103,10 @@ find_syscall_meta(unsigned long syscall)
 
 static struct syscall_metadata *syscall_nr_to_meta(int nr)
 {
+#ifdef CONFIG_FTRACE_COMPAT_SYSCALLS
+	if (is_compat_task())
+		return compat_syscall_nr_to_meta(nr);
+#endif
 	if (!syscalls_metadata || nr >= NR_syscalls || nr < 0)
 		return NULL;
 
@@ -112,11 +121,13 @@ print_syscall_enter(struct trace_iterator *iter, int flags,
 	struct trace_entry *ent = iter->ent;
 	struct syscall_trace_enter *trace;
 	struct syscall_metadata *entry;
-	int i, ret, syscall;
+	int i, ret;
+	struct ftrace_event_call *call;
 
 	trace = (typeof(trace))ent;
-	syscall = trace->nr;
-	entry = syscall_nr_to_meta(syscall);
+	event = ftrace_find_event(ent->type);
+	call = container_of(event, struct ftrace_event_call, event);
+	entry = call->data;
 
 	if (!entry)
 		goto end;
@@ -164,13 +175,14 @@ print_syscall_exit(struct trace_iterator *iter, int flags,
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *ent = iter->ent;
 	struct syscall_trace_exit *trace;
-	int syscall;
 	struct syscall_metadata *entry;
 	int ret;
+	struct ftrace_event_call *call;
 
 	trace = (typeof(trace))ent;
-	syscall = trace->nr;
-	entry = syscall_nr_to_meta(syscall);
+	event = ftrace_find_event(ent->type);
+	call = container_of(event, struct ftrace_event_call, event);
+	entry = call->data;
 
 	if (!entry) {
 		trace_seq_printf(s, "\n");
diff --git a/mm/fadvise.c b/mm/fadvise.c
index 469491e..60d83eb 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -24,7 +24,8 @@
  * POSIX_FADV_WILLNEED could set PG_Referenced, and POSIX_FADV_NOREUSE could
  * deactivate the pages and clear PG_Referenced.
  */
-SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
+SYSCALL_DEFINE4(fadvise64_64, int, fd, loff_t, offset,
+			loff_t, len, int, advice)
 {
 	struct file *file = fget(fd);
 	struct address_space *mapping;
@@ -145,7 +146,7 @@ SYSCALL_ALIAS(sys_fadvise64_64, SyS_fadvise64_64);
 
 #ifdef __ARCH_WANT_SYS_FADVISE64
 
-SYSCALL_DEFINE(fadvise64)(int fd, loff_t offset, size_t len, int advice)
+SYSCALL_DEFINE4(fadvise64, int, fd, loff_t, offset, size_t, len, int, advice)
 {
 	return sys_fadvise64_64(fd, offset, len, advice);
 }
diff --git a/mm/filemap.c b/mm/filemap.c
index cb8ee3e..6e06d27 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1499,7 +1499,7 @@ do_readahead(struct address_space *mapping, struct file *filp,
 	return 0;
 }
 
-SYSCALL_DEFINE(readahead)(int fd, loff_t offset, size_t count)
+SYSCALL_DEFINE3(readahead, int, fd, loff_t, offset, size_t, count)
 {
 	ssize_t ret;
 	struct file *file;
-- 
1.7.7.3

