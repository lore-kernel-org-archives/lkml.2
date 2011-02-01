Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab1BANvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:51:17 -0500
Received: from www.tglx.de ([62.245.132.106]:47086 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab1BANvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:51:14 -0500
Message-Id: <20110201134417.545698637@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:50:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 01/28] time: Correct the *settime* parameters
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline; filename=time-correct-the-settime-parameters.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both settimeofday() and clock_settime() promise with a 'const'
attribute not to alter the arguments passed in. This patch adds the
missing 'const' attribute into the various kernel functions
implementing these calls.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
Cc: John Stultz <john.stultz@linaro.org>
LKML-Reference: <681d9f8ba43fea01bae9f6a17a4674194a90353b.1296124770.git.richard.cochran@omicron.at>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/char/mmtimer.c       |    2 +-
 include/linux/posix-timers.h |    5 +++--
 include/linux/security.h     |    9 +++++----
 include/linux/time.h         |    5 +++--
 kernel/posix-timers.c        |    4 ++--
 kernel/time.c                |    2 +-
 kernel/time/timekeeping.c    |    2 +-
 security/commoncap.c         |    2 +-
 security/security.c          |    2 +-
 9 files changed, 18 insertions(+), 15 deletions(-)

Index: linux-2.6-tip/drivers/char/mmtimer.c
===================================================================
--- linux-2.6-tip.orig/drivers/char/mmtimer.c
+++ linux-2.6-tip/drivers/char/mmtimer.c
@@ -487,7 +487,7 @@ static int sgi_clock_get(clockid_t clock
 	return 0;
 };
 
-static int sgi_clock_set(clockid_t clockid, struct timespec *tp)
+static int sgi_clock_set(const clockid_t clockid, const struct timespec *tp)
 {
 
 	u64 nsec;
Index: linux-2.6-tip/include/linux/posix-timers.h
===================================================================
--- linux-2.6-tip.orig/include/linux/posix-timers.h
+++ linux-2.6-tip/include/linux/posix-timers.h
@@ -69,7 +69,8 @@ struct k_itimer {
 struct k_clock {
 	int res;		/* in nanoseconds */
 	int (*clock_getres) (const clockid_t which_clock, struct timespec *tp);
-	int (*clock_set) (const clockid_t which_clock, struct timespec * tp);
+	int (*clock_set) (const clockid_t which_clock,
+			  const struct timespec *tp);
 	int (*clock_get) (const clockid_t which_clock, struct timespec * tp);
 	int (*timer_create) (struct k_itimer *timer);
 	int (*nsleep) (const clockid_t which_clock, int flags,
@@ -89,7 +90,7 @@ void register_posix_clock(const clockid_
 /* error handlers for timer_create, nanosleep and settime */
 int do_posix_clock_nonanosleep(const clockid_t, int flags, struct timespec *,
 			       struct timespec __user *);
-int do_posix_clock_nosettime(const clockid_t, struct timespec *tp);
+int do_posix_clock_nosettime(const clockid_t, const struct timespec *tp);
 
 /* function to call to trigger timer event */
 int posix_timer_event(struct k_itimer *timr, int si_private);
Index: linux-2.6-tip/include/linux/security.h
===================================================================
--- linux-2.6-tip.orig/include/linux/security.h
+++ linux-2.6-tip/include/linux/security.h
@@ -53,7 +53,7 @@ struct audit_krule;
  */
 extern int cap_capable(struct task_struct *tsk, const struct cred *cred,
 		       int cap, int audit);
-extern int cap_settime(struct timespec *ts, struct timezone *tz);
+extern int cap_settime(const struct timespec *ts, const struct timezone *tz);
 extern int cap_ptrace_access_check(struct task_struct *child, unsigned int mode);
 extern int cap_ptrace_traceme(struct task_struct *parent);
 extern int cap_capget(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
@@ -1387,7 +1387,7 @@ struct security_operations {
 	int (*quotactl) (int cmds, int type, int id, struct super_block *sb);
 	int (*quota_on) (struct dentry *dentry);
 	int (*syslog) (int type);
-	int (*settime) (struct timespec *ts, struct timezone *tz);
+	int (*settime) (const struct timespec *ts, const struct timezone *tz);
 	int (*vm_enough_memory) (struct mm_struct *mm, long pages);
 
 	int (*bprm_set_creds) (struct linux_binprm *bprm);
@@ -1669,7 +1669,7 @@ int security_sysctl(struct ctl_table *ta
 int security_quotactl(int cmds, int type, int id, struct super_block *sb);
 int security_quota_on(struct dentry *dentry);
 int security_syslog(int type);
-int security_settime(struct timespec *ts, struct timezone *tz);
+int security_settime(const struct timespec *ts, const struct timezone *tz);
 int security_vm_enough_memory(long pages);
 int security_vm_enough_memory_mm(struct mm_struct *mm, long pages);
 int security_vm_enough_memory_kern(long pages);
@@ -1904,7 +1904,8 @@ static inline int security_syslog(int ty
 	return 0;
 }
 
-static inline int security_settime(struct timespec *ts, struct timezone *tz)
+static inline int security_settime(const struct timespec *ts,
+				   const struct timezone *tz)
 {
 	return cap_settime(ts, tz);
 }
Index: linux-2.6-tip/include/linux/time.h
===================================================================
--- linux-2.6-tip.orig/include/linux/time.h
+++ linux-2.6-tip/include/linux/time.h
@@ -145,8 +145,9 @@ static inline u32 arch_gettimeoffset(voi
 #endif
 
 extern void do_gettimeofday(struct timeval *tv);
-extern int do_settimeofday(struct timespec *tv);
-extern int do_sys_settimeofday(struct timespec *tv, struct timezone *tz);
+extern int do_settimeofday(const struct timespec *tv);
+extern int do_sys_settimeofday(const struct timespec *tv,
+			       const struct timezone *tz);
 #define do_posix_clock_monotonic_gettime(ts) ktime_get_ts(ts)
 extern long do_utimes(int dfd, const char __user *filename, struct timespec *times, int flags);
 struct itimerval;
Index: linux-2.6-tip/kernel/posix-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-timers.c
+++ linux-2.6-tip/kernel/posix-timers.c
@@ -192,7 +192,7 @@ static int common_clock_get(clockid_t wh
 }
 
 static inline int common_clock_set(const clockid_t which_clock,
-				   struct timespec *tp)
+				   const struct timespec *tp)
 {
 	return do_sys_settimeofday(tp, NULL);
 }
@@ -928,7 +928,7 @@ void exit_itimers(struct signal_struct *
 }
 
 /* Not available / possible... functions */
-int do_posix_clock_nosettime(const clockid_t clockid, struct timespec *tp)
+int do_posix_clock_nosettime(const clockid_t clockid, const struct timespec *tp)
 {
 	return -EINVAL;
 }
Index: linux-2.6-tip/kernel/time.c
===================================================================
--- linux-2.6-tip.orig/kernel/time.c
+++ linux-2.6-tip/kernel/time.c
@@ -150,7 +150,7 @@ static inline void warp_clock(void)
  * various programs will get confused when the clock gets warped.
  */
 
-int do_sys_settimeofday(struct timespec *tv, struct timezone *tz)
+int do_sys_settimeofday(const struct timespec *tv, const struct timezone *tz)
 {
 	static int firsttime = 1;
 	int error = 0;
Index: linux-2.6-tip/kernel/time/timekeeping.c
===================================================================
--- linux-2.6-tip.orig/kernel/time/timekeeping.c
+++ linux-2.6-tip/kernel/time/timekeeping.c
@@ -353,7 +353,7 @@ EXPORT_SYMBOL(do_gettimeofday);
  *
  * Sets the time of day to the new time and update NTP and notify hrtimers
  */
-int do_settimeofday(struct timespec *tv)
+int do_settimeofday(const struct timespec *tv)
 {
 	struct timespec ts_delta;
 	unsigned long flags;
Index: linux-2.6-tip/security/commoncap.c
===================================================================
--- linux-2.6-tip.orig/security/commoncap.c
+++ linux-2.6-tip/security/commoncap.c
@@ -93,7 +93,7 @@ int cap_capable(struct task_struct *tsk,
  * Determine whether the current process may set the system clock and timezone
  * information, returning 0 if permission granted, -ve if denied.
  */
-int cap_settime(struct timespec *ts, struct timezone *tz)
+int cap_settime(const struct timespec *ts, const struct timezone *tz)
 {
 	if (!capable(CAP_SYS_TIME))
 		return -EPERM;
Index: linux-2.6-tip/security/security.c
===================================================================
--- linux-2.6-tip.orig/security/security.c
+++ linux-2.6-tip/security/security.c
@@ -202,7 +202,7 @@ int security_syslog(int type)
 	return security_ops->syslog(type);
 }
 
-int security_settime(struct timespec *ts, struct timezone *tz)
+int security_settime(const struct timespec *ts, const struct timezone *tz)
 {
 	return security_ops->settime(ts, tz);
 }


