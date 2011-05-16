Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1EPKhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 06:37:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:50352 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382Ab1EPKhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 06:37:51 -0400
Date: Mon, 16 May 2011 10:37:26 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Message-ID: <tip-61eadef6a9bde9ea62fda724a9cb501ce9bc925a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, skoe@directbox.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, skoe@directbox.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1304059010.7472.1.camel@marge.simson.net>
References: <1304059010.7472.1.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, rt: Update rq clock when unthrottling of an otherwise idle CPU
Git-Commit-ID: 61eadef6a9bde9ea62fda724a9cb501ce9bc925a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 16 May 2011 10:37:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61eadef6a9bde9ea62fda724a9cb501ce9bc925a
Gitweb:     http://git.kernel.org/tip/61eadef6a9bde9ea62fda724a9cb501ce9bc925a
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Fri, 29 Apr 2011 08:36:50 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 May 2011 11:01:17 +0200

sched, rt: Update rq clock when unthrottling of an otherwise idle CPU

If an RT task is awakened while it's rt_rq is throttled, the time between
wakeup/enqueue and unthrottle/selection may be accounted as rt_time
if the CPU is idle.  Set rq->skip_clock_update negative upon throttle
release to tell put_prev_task() that we need a clock update.

Reported-by: Thomas Giesel <skoe@directbox.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1304059010.7472.1.camel@marge.simson.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c    |    6 +++---
 kernel/sched_rt.c |    7 +++++++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f9778c0..b8b9a7d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -466,7 +466,7 @@ struct rq {
 	u64 nohz_stamp;
 	unsigned char nohz_balance_kick;
 #endif
-	unsigned int skip_clock_update;
+	int skip_clock_update;
 
 	/* capture load from *all* tasks on this cpu: */
 	struct load_weight load;
@@ -652,7 +652,7 @@ static void update_rq_clock(struct rq *rq)
 {
 	s64 delta;
 
-	if (rq->skip_clock_update)
+	if (rq->skip_clock_update > 0)
 		return;
 
 	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
@@ -4127,7 +4127,7 @@ static inline void schedule_debug(struct task_struct *prev)
 
 static void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
-	if (prev->on_rq)
+	if (prev->on_rq || rq->skip_clock_update < 0)
 		update_rq_clock(rq);
 	prev->sched_class->put_prev_task(rq, prev);
 }
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 19ecb31..0943ed7 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -562,6 +562,13 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 			if (rt_rq->rt_throttled && rt_rq->rt_time < runtime) {
 				rt_rq->rt_throttled = 0;
 				enqueue = 1;
+
+				/*
+				 * Force a clock update if the CPU was idle,
+				 * lest wakeup -> unthrottle time accumulate.
+				 */
+				if (rt_rq->rt_nr_running && rq->curr == rq->idle)
+					rq->skip_clock_update = -1;
 			}
 			if (rt_rq->rt_time || rt_rq->rt_nr_running)
 				idle = 0;
