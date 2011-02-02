Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1BBVzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:55:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:60983 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431Ab1BBVzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:55:12 -0500
Date: Wed, 2 Feb 2011 21:54:51 GMT
From: tip-bot for Richard Cochran <richard.cochran@omicron.at>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
In-Reply-To: <20110201134417.545698637@linutronix.de>
References: <20110201134417.545698637@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] time: Correct the *settime* parameters
Message-ID: <tip-1e6d767924c74929c0cfe839ae8f37bcee9e544e@git.kernel.org>
Git-Commit-ID: 1e6d767924c74929c0cfe839ae8f37bcee9e544e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 21:54:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e6d767924c74929c0cfe839ae8f37bcee9e544e
Gitweb:     http://git.kernel.org/tip/1e6d767924c74929c0cfe839ae8f37bcee9e544e
Author:     Richard Cochran <richard.cochran@omicron.at>
AuthorDate: Tue, 1 Feb 2011 13:50:58 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:11 +0100

time: Correct the *settime* parameters

Both settimeofday() and clock_settime() promise with a 'const'
attribute not to alter the arguments passed in. This patch adds the
missing 'const' attribute into the various kernel functions
implementing these calls.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
Acked-by: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <20110201134417.545698637@linutronix.de>
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

diff --git a/drivers/char/mmtimer.c b/drivers/char/mmtimer.c
index e6d7562..ecd0082 100644
--- a/drivers/char/mmtimer.c
+++ b/drivers/char/mmtimer.c
@@ -487,7 +487,7 @@ static int sgi_clock_get(clockid_t clockid, struct timespec *tp)
 	return 0;
 };
 
-static int sgi_clock_set(clockid_t clockid, struct timespec *tp)
+static int sgi_clock_set(const clockid_t clockid, const struct timespec *tp)
 {
 
 	u64 nsec;
diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 3e23844a..b2c14cb 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
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
@@ -89,7 +90,7 @@ void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock);
 /* error handlers for timer_create, nanosleep and settime */
 int do_posix_clock_nonanosleep(const clockid_t, int flags, struct timespec *,
 			       struct timespec __user *);
-int do_posix_clock_nosettime(const clockid_t, struct timespec *tp);
+int do_posix_clock_nosettime(const clockid_t, const struct timespec *tp);
 
 /* function to call to trigger timer event */
 int posix_timer_event(struct k_itimer *timr, int si_private);
diff --git a/include/linux/security.h b/include/linux/security.h
index c642bb8..c096aa6 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
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
@@ -1669,7 +1669,7 @@ int security_sysctl(struct ctl_table *table, int op);
 int security_quotactl(int cmds, int type, int id, struct super_block *sb);
 int security_quota_on(struct dentry *dentry);
 int security_syslog(int type);
-int security_settime(struct timespec *ts, struct timezone *tz);
+int security_settime(const struct timespec *ts, const struct timezone *tz);
 int security_vm_enough_memory(long pages);
 int security_vm_enough_memory_mm(struct mm_struct *mm, long pages);
 int security_vm_enough_memory_kern(long pages);
@@ -1904,7 +1904,8 @@ static inline int security_syslog(int type)
 	return 0;
 }
 
-static inline int security_settime(struct timespec *ts, struct timezone *tz)
+static inline int security_settime(const struct timespec *ts,
+				   const struct timezone *tz)
 {
 	return cap_settime(ts, tz);
 }
diff --git a/include/linux/time.h b/include/linux/time.h
index 38c5206..7c44e77 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -145,8 +145,9 @@ static inline u32 arch_gettimeoffset(void) { return 0; }
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
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 93bd2eb..21b7ca2 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -192,7 +192,7 @@ static int common_clock_get(clockid_t which_clock, struct timespec *tp)
 }
 
 static inline int common_clock_set(const clockid_t which_clock,
-				   struct timespec *tp)
+				   const struct timespec *tp)
 {
 	return do_sys_settimeofday(tp, NULL);
 }
@@ -928,7 +928,7 @@ void exit_itimers(struct signal_struct *sig)
 }
 
 /* Not available / possible... functions */
-int do_posix_clock_nosettime(const clockid_t clockid, struct timespec *tp)
+int do_posix_clock_nosettime(const clockid_t clockid, const struct timespec *tp)
 {
 	return -EINVAL;
 }
diff --git a/kernel/time.c b/kernel/time.c
index a31b512..5cb8053 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -150,7 +150,7 @@ static inline void warp_clock(void)
  * various programs will get confused when the clock gets warped.
  */
 
-int do_sys_settimeofday(struct timespec *tv, struct timezone *tz)
+int do_sys_settimeofday(const struct timespec *tv, const struct timezone *tz)
 {
 	static int firsttime = 1;
 	int error = 0;
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 02c13a3..4f9f65b 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -353,7 +353,7 @@ EXPORT_SYMBOL(do_gettimeofday);
  *
  * Sets the time of day to the new time and update NTP and notify hrtimers
  */
-int do_settimeofday(struct timespec *tv)
+int do_settimeofday(const struct timespec *tv)
 {
 	struct timespec ts_delta;
 	unsigned long flags;
diff --git a/security/commoncap.c b/security/commoncap.c
index 64c2ed9..dbfdaed 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -93,7 +93,7 @@ int cap_capable(struct task_struct *tsk, const struct cred *cred, int cap,
  * Determine whether the current process may set the system clock and timezone
  * information, returning 0 if permission granted, -ve if denied.
  */
-int cap_settime(struct timespec *ts, struct timezone *tz)
+int cap_settime(const struct timespec *ts, const struct timezone *tz)
 {
 	if (!capable(CAP_SYS_TIME))
 		return -EPERM;
diff --git a/security/security.c b/security/security.c
index 739e403..b995428 100644
--- a/security/security.c
+++ b/security/security.c
@@ -202,7 +202,7 @@ int security_syslog(int type)
 	return security_ops->syslog(type);
 }
 
-int security_settime(struct timespec *ts, struct timezone *tz)
+int security_settime(const struct timespec *ts, const struct timezone *tz)
 {
 	return security_ops->settime(ts, tz);
 }
