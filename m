Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938057Ab0CPRtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:49:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938205Ab0CPRtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:49:15 -0400
Date: Tue, 16 Mar 2010 13:46:56 -0400
From: Jason Baron <jbaron@redhat.com>
To: fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       hpa@zytor.com, tglx@linutronix.de, mhiramat@redhat.com,
       heiko.carstens@de.ibm.com, benh@kernel.crashing.org,
       davem@davemloft.net, lethal@linux-sh.org, schwidefsky@de.ibm.com,
       brueckner@linux.vnet.ibm.com, tony.luck@intel.com
Message-Id: <f3a7b190b9804b9042acc824fa14838b8da86394.1268749695.git.jbaron@redhat.com>
In-Reply-To: <cover.1268749695.git.jbaron@redhat.com>
References: <cover.1268749695.git.jbaron@redhat.com>
Subject: [PATCH 10/14] compat: convert to use COMPAT_SYSCALL_DEFINE#N()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

convert kernel/compat.c to use the new COMPAT_SYSCALL_DEFINE#N macro. Thus,
tying these syscalls into the syscall event layer.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 kernel/compat.c |  106 ++++++++++++++++++++++++++----------------------------
 1 files changed, 51 insertions(+), 55 deletions(-)

diff --git a/kernel/compat.c b/kernel/compat.c
index f6c204f..46dd9c7 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -51,8 +51,8 @@ static int compat_put_timeval(struct compat_timeval __user *o,
 		put_user(i->tv_usec, &o->tv_usec)) ? -EFAULT : 0;
 }
 
-asmlinkage long compat_sys_gettimeofday(struct compat_timeval __user *tv,
-		struct timezone __user *tz)
+COMPAT_SYSCALL_DEFINE2(gettimeofday, struct compat_timeval __user *, tv,
+		struct timezone __user *, tz)
 {
 	if (tv) {
 		struct timeval ktv;
@@ -68,8 +68,8 @@ asmlinkage long compat_sys_gettimeofday(struct compat_timeval __user *tv,
 	return 0;
 }
 
-asmlinkage long compat_sys_settimeofday(struct compat_timeval __user *tv,
-		struct timezone __user *tz)
+COMPAT_SYSCALL_DEFINE2(settimeofday, struct compat_timeval __user *, tv,
+		struct timezone __user *, tz)
 {
 	struct timespec kts;
 	struct timezone ktz;
@@ -123,8 +123,8 @@ static long compat_nanosleep_restart(struct restart_block *restart)
 	return ret;
 }
 
-asmlinkage long compat_sys_nanosleep(struct compat_timespec __user *rqtp,
-				     struct compat_timespec __user *rmtp)
+COMPAT_SYSCALL_DEFINE2(nanosleep, struct compat_timespec __user *, rqtp,
+				     struct compat_timespec __user *, rmtp)
 {
 	struct timespec tu, rmt;
 	mm_segment_t oldfs;
@@ -177,8 +177,8 @@ static inline long put_compat_itimerval(struct compat_itimerval __user *o,
 		 __put_user(i->it_value.tv_usec, &o->it_value.tv_usec)));
 }
 
-asmlinkage long compat_sys_getitimer(int which,
-		struct compat_itimerval __user *it)
+COMPAT_SYSCALL_DEFINE2(getitimer, int, which,
+		struct compat_itimerval __user *, it)
 {
 	struct itimerval kit;
 	int error;
@@ -189,9 +189,9 @@ asmlinkage long compat_sys_getitimer(int which,
 	return error;
 }
 
-asmlinkage long compat_sys_setitimer(int which,
-		struct compat_itimerval __user *in,
-		struct compat_itimerval __user *out)
+COMPAT_SYSCALL_DEFINE3(setitimer, int, which,
+		struct compat_itimerval __user *, in,
+		struct compat_itimerval __user *, out)
 {
 	struct itimerval kin, kout;
 	int error;
@@ -215,7 +215,7 @@ static compat_clock_t clock_t_to_compat_clock_t(clock_t x)
 	return compat_jiffies_to_clock_t(clock_t_to_jiffies(x));
 }
 
-asmlinkage long compat_sys_times(struct compat_tms __user *tbuf)
+COMPAT_SYSCALL_DEFINE1(times, struct compat_tms __user *, tbuf)
 {
 	if (tbuf) {
 		struct tms tms;
@@ -239,7 +239,7 @@ asmlinkage long compat_sys_times(struct compat_tms __user *tbuf)
  * types that can be passed to put_user()/get_user().
  */
 
-asmlinkage long compat_sys_sigpending(compat_old_sigset_t __user *set)
+COMPAT_SYSCALL_DEFINE1(sigpending, compat_old_sigset_t __user *, set)
 {
 	old_sigset_t s;
 	long ret;
@@ -253,8 +253,8 @@ asmlinkage long compat_sys_sigpending(compat_old_sigset_t __user *set)
 	return ret;
 }
 
-asmlinkage long compat_sys_sigprocmask(int how, compat_old_sigset_t __user *set,
-		compat_old_sigset_t __user *oset)
+COMPAT_SYSCALL_DEFINE3(sigprocmask, int, how, compat_old_sigset_t __user *, set,
+		compat_old_sigset_t __user *, oset)
 {
 	old_sigset_t s;
 	long ret;
@@ -274,8 +274,8 @@ asmlinkage long compat_sys_sigprocmask(int how, compat_old_sigset_t __user *set,
 	return ret;
 }
 
-asmlinkage long compat_sys_setrlimit(unsigned int resource,
-		struct compat_rlimit __user *rlim)
+COMPAT_SYSCALL_DEFINE2(setrlimit, unsigned int, resource,
+		struct compat_rlimit __user *, rlim)
 {
 	struct rlimit r;
 	int ret;
@@ -301,8 +301,8 @@ asmlinkage long compat_sys_setrlimit(unsigned int resource,
 
 #ifdef COMPAT_RLIM_OLD_INFINITY
 
-asmlinkage long compat_sys_old_getrlimit(unsigned int resource,
-		struct compat_rlimit __user *rlim)
+COMPAT_SYSCALL_DEFINE2(old_getrlimit, unsigned int, resource,
+		struct compat_rlimit __user *, rlim)
 {
 	struct rlimit r;
 	int ret;
@@ -328,8 +328,8 @@ asmlinkage long compat_sys_old_getrlimit(unsigned int resource,
 
 #endif
 
-asmlinkage long compat_sys_getrlimit (unsigned int resource,
-		struct compat_rlimit __user *rlim)
+COMPAT_SYSCALL_DEFINE2(getrlimit, unsigned int, resource,
+		struct compat_rlimit __user *, rlim)
 {
 	struct rlimit r;
 	int ret;
@@ -377,7 +377,7 @@ int put_compat_rusage(const struct rusage *r, struct compat_rusage __user *ru)
 	return 0;
 }
 
-asmlinkage long compat_sys_getrusage(int who, struct compat_rusage __user *ru)
+COMPAT_SYSCALL_DEFINE2(getrusage, int, who, struct compat_rusage __user *, ru)
 {
 	struct rusage r;
 	int ret;
@@ -396,9 +396,8 @@ asmlinkage long compat_sys_getrusage(int who, struct compat_rusage __user *ru)
 	return 0;
 }
 
-asmlinkage long
-compat_sys_wait4(compat_pid_t pid, compat_uint_t __user *stat_addr, int options,
-	struct compat_rusage __user *ru)
+COMPAT_SYSCALL_DEFINE4(wait4, compat_pid_t, pid, compat_uint_t __user *, stat_addr, int, options,
+	struct compat_rusage __user *, ru)
 {
 	if (!ru) {
 		return sys_wait4(pid, stat_addr, options, NULL);
@@ -425,9 +424,9 @@ compat_sys_wait4(compat_pid_t pid, compat_uint_t __user *stat_addr, int options,
 	}
 }
 
-asmlinkage long compat_sys_waitid(int which, compat_pid_t pid,
-		struct compat_siginfo __user *uinfo, int options,
-		struct compat_rusage __user *uru)
+COMPAT_SYSCALL_DEFINE5(waitid, int, which, compat_pid_t, pid,
+		struct compat_siginfo __user *, uinfo, int, options,
+		struct compat_rusage __user *, uru)
 {
 	siginfo_t info;
 	struct rusage ru;
@@ -469,9 +468,9 @@ static int compat_get_user_cpu_mask(compat_ulong_t __user *user_mask_ptr,
 	return compat_get_bitmap(k, user_mask_ptr, len * 8);
 }
 
-asmlinkage long compat_sys_sched_setaffinity(compat_pid_t pid,
-					     unsigned int len,
-					     compat_ulong_t __user *user_mask_ptr)
+COMPAT_SYSCALL_DEFINE3(sched_setaffinity, compat_pid_t, pid,
+					     unsigned int, len,
+					     compat_ulong_t __user *, user_mask_ptr)
 {
 	cpumask_var_t new_mask;
 	int retval;
@@ -489,8 +488,8 @@ out:
 	return retval;
 }
 
-asmlinkage long compat_sys_sched_getaffinity(compat_pid_t pid, unsigned int len,
-					     compat_ulong_t __user *user_mask_ptr)
+COMPAT_SYSCALL_DEFINE3(sched_getaffinity, compat_pid_t, pid, unsigned int, len,
+					     compat_ulong_t __user *, user_mask_ptr)
 {
 	int ret;
 	cpumask_var_t mask;
@@ -815,10 +814,9 @@ sigset_from_compat (sigset_t *set, compat_sigset_t *compat)
 	}
 }
 
-asmlinkage long
-compat_sys_rt_sigtimedwait (compat_sigset_t __user *uthese,
-		struct compat_siginfo __user *uinfo,
-		struct compat_timespec __user *uts, compat_size_t sigsetsize)
+COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
+		struct compat_siginfo __user *, uinfo,
+		struct compat_timespec __user *, uts, compat_size_t, sigsetsize)
 {
 	compat_sigset_t s32;
 	sigset_t s;
@@ -882,9 +880,8 @@ compat_sys_rt_sigtimedwait (compat_sigset_t __user *uthese,
 
 }
 
-asmlinkage long
-compat_sys_rt_tgsigqueueinfo(compat_pid_t tgid, compat_pid_t pid, int sig,
-			     struct compat_siginfo __user *uinfo)
+COMPAT_SYSCALL_DEFINE4(rt_tgsigqueueinfo, compat_pid_t, tgid, compat_pid_t, pid, int, sig,
+			     struct compat_siginfo __user *, uinfo)
 {
 	siginfo_t info;
 
@@ -897,7 +894,7 @@ compat_sys_rt_tgsigqueueinfo(compat_pid_t tgid, compat_pid_t pid, int sig,
 
 /* compat_time_t is a 32 bit "long" and needs to get converted. */
 
-asmlinkage long compat_sys_time(compat_time_t __user * tloc)
+COMPAT_SYSCALL_DEFINE1(time, compat_time_t __user *, tloc)
 {
 	compat_time_t i;
 	struct timeval tv;
@@ -913,7 +910,7 @@ asmlinkage long compat_sys_time(compat_time_t __user * tloc)
 	return i;
 }
 
-asmlinkage long compat_sys_stime(compat_time_t __user *tptr)
+COMPAT_SYSCALL_DEFINE1(stime, compat_time_t __user *, tptr)
 {
 	struct timespec tv;
 	int err;
@@ -934,7 +931,7 @@ asmlinkage long compat_sys_stime(compat_time_t __user *tptr)
 #endif /* __ARCH_WANT_COMPAT_SYS_TIME */
 
 #ifdef __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
-asmlinkage long compat_sys_rt_sigsuspend(compat_sigset_t __user *unewset, compat_size_t sigsetsize)
+COMPAT_SYSCALL_DEFINE2(rt_sigsuspend, compat_sigset_t __user *, unewset, compat_size_t, sigsetsize)
 {
 	sigset_t newset;
 	compat_sigset_t newset32;
@@ -961,7 +958,7 @@ asmlinkage long compat_sys_rt_sigsuspend(compat_sigset_t __user *unewset, compat
 }
 #endif /* __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND */
 
-asmlinkage long compat_sys_adjtimex(struct compat_timex __user *utp)
+COMPAT_SYSCALL_DEFINE1(adjtimex, struct compat_timex __user *, utp)
 {
 	struct timex txc;
 	int ret;
@@ -1021,11 +1018,11 @@ asmlinkage long compat_sys_adjtimex(struct compat_timex __user *utp)
 }
 
 #ifdef CONFIG_NUMA
-asmlinkage long compat_sys_move_pages(pid_t pid, unsigned long nr_pages,
-		compat_uptr_t __user *pages32,
-		const int __user *nodes,
-		int __user *status,
-		int flags)
+COMPAT_SYSCALL_DEFINE6(move_pages, pid_t, pid, unsigned long, nr_pages,
+		compat_uptr_t __user *, pages32,
+		const int __user *, nodes,
+		int __user *, status,
+		int, flags)
 {
 	const void __user * __user *pages;
 	int i;
@@ -1041,10 +1038,10 @@ asmlinkage long compat_sys_move_pages(pid_t pid, unsigned long nr_pages,
 	return sys_move_pages(pid, nr_pages, pages, nodes, status, flags);
 }
 
-asmlinkage long compat_sys_migrate_pages(compat_pid_t pid,
-			compat_ulong_t maxnode,
-			const compat_ulong_t __user *old_nodes,
-			const compat_ulong_t __user *new_nodes)
+COMPAT_SYSCALL_DEFINE4(migrate_pages, compat_pid_t, pid,
+			compat_ulong_t, maxnode,
+			const compat_ulong_t __user *, old_nodes,
+			const compat_ulong_t __user *, new_nodes)
 {
 	unsigned long __user *old = NULL;
 	unsigned long __user *new = NULL;
@@ -1092,8 +1089,7 @@ struct compat_sysinfo {
 	char _f[20-2*sizeof(u32)-sizeof(int)];
 };
 
-asmlinkage long
-compat_sys_sysinfo(struct compat_sysinfo __user *info)
+COMPAT_SYSCALL_DEFINE1(sysinfo, struct compat_sysinfo __user *, info)
 {
 	struct sysinfo s;
 
-- 
1.6.5.1

