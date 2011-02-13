Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab1BMUpW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 15:45:22 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56116 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab1BMUpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 15:45:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=UxaNDsSelBskjb/HhaGb0LM3f5DTzNoss22/+SS0S7cTDMFSc/quVgl1fFvRD1VH0G
         SvUWuF3gRGiSu1Edd3EmMVqP2WhFLLWzwNjLJpZ/nwdORNOm5j4XH1hJbBU8pUAzn0vX
         Pvm6noh/oJRrK67x+MH3g+rCgwIygMV1fRr7Q=
Date: Sun, 13 Feb 2011 21:43:24 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] hrtimer: constify read-only parameters
Message-ID: <20110213204324.GB5395@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/hrtimer.h |   12 +++++++-----
 kernel/hrtimer.c        |   18 +++++++++++-------
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index f376ddc..7beb09c 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -407,20 +407,22 @@ static inline u64 hrtimer_forward_now(struct hrtimer *timer,
 }
 
 /* Precise sleep: */
-extern long hrtimer_nanosleep(struct timespec *rqtp,
+extern long hrtimer_nanosleep(const struct timespec *rqtp,
 			      struct timespec __user *rmtp,
 			      const enum hrtimer_mode mode,
 			      const clockid_t clockid);
-extern long hrtimer_nanosleep_restart(struct restart_block *restart_block);
+extern long
+hrtimer_nanosleep_restart(const struct restart_block *restart_block);
 
 extern void hrtimer_init_sleeper(struct hrtimer_sleeper *sl,
 				 struct task_struct *tsk);
 
-extern int schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
+extern int schedule_hrtimeout_range(const ktime_t *expires, unsigned long delta,
 						const enum hrtimer_mode mode);
-extern int schedule_hrtimeout_range_clock(ktime_t *expires,
+extern int schedule_hrtimeout_range_clock(const ktime_t *expires,
 		unsigned long delta, const enum hrtimer_mode mode, int clock);
-extern int schedule_hrtimeout(ktime_t *expires, const enum hrtimer_mode mode);
+extern int schedule_hrtimeout(const ktime_t *expires,
+				const enum hrtimer_mode mode);
 
 /* Soft interrupt function to run the hrtimer queues: */
 extern void hrtimer_run_queues(void);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0c8d7c0..1de816f 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1491,7 +1491,8 @@ static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mod
 	return t->task == NULL;
 }
 
-static int update_rmtp(struct hrtimer *timer, struct timespec __user *rmtp)
+static int update_rmtp(const struct hrtimer *timer,
+			struct timespec __user *rmtp)
 {
 	struct timespec rmt;
 	ktime_t rem;
@@ -1507,7 +1508,7 @@ static int update_rmtp(struct hrtimer *timer, struct timespec __user *rmtp)
 	return 1;
 }
 
-long __sched hrtimer_nanosleep_restart(struct restart_block *restart)
+long __sched hrtimer_nanosleep_restart(const struct restart_block *restart)
 {
 	struct hrtimer_sleeper t;
 	struct timespec __user  *rmtp;
@@ -1534,8 +1535,10 @@ out:
 	return ret;
 }
 
-long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
-		       const enum hrtimer_mode mode, const clockid_t clockid)
+long hrtimer_nanosleep(const struct timespec *rqtp,
+		       struct timespec __user *rmtp,
+		       const enum hrtimer_mode mode,
+		       const clockid_t clockid)
 {
 	struct restart_block *restart;
 	struct hrtimer_sleeper t;
@@ -1730,7 +1733,7 @@ void __init hrtimers_init(void)
  * @clock:	timer clock, CLOCK_MONOTONIC or CLOCK_REALTIME
  */
 int __sched
-schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
+schedule_hrtimeout_range_clock(const ktime_t *expires, unsigned long delta,
 			       const enum hrtimer_mode mode, int clock)
 {
 	struct hrtimer_sleeper t;
@@ -1801,7 +1804,8 @@ schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
  *
  * Returns 0 when the timer has expired otherwise -EINTR
  */
-int __sched schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
+int __sched schedule_hrtimeout_range(const ktime_t *expires,
+				     unsigned long delta,
 				     const enum hrtimer_mode mode)
 {
 	return schedule_hrtimeout_range_clock(expires, delta, mode,
@@ -1831,7 +1835,7 @@ EXPORT_SYMBOL_GPL(schedule_hrtimeout_range);
  *
  * Returns 0 when the timer has expired otherwise -EINTR
  */
-int __sched schedule_hrtimeout(ktime_t *expires,
+int __sched schedule_hrtimeout(const ktime_t *expires,
 			       const enum hrtimer_mode mode)
 {
 	return schedule_hrtimeout_range(expires, 0, mode);
-- 
1.7.4.rc3

