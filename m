Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab2FRHOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 03:14:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59135 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab2FRHNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 03:13:46 -0400
From: Charles Wang <muming.wq@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Charles Wang <muming.wq@taobao.com>, Peter Zijlstra <peterz@infradead.org>,
        Doug Smythies <dsmythies@telus.net>, Ingo Molnar <mingo@redhat.com>,
        Tao Ma <tm@tao.ma>, Sha Zhengju <handai.szj@gmail.com>
Subject: [PATCH 2/2] sched: Try fix sampling time line for idle
Date: Mon, 18 Jun 2012 15:12:50 +0800
Message-Id: <1340003570-7193-2-git-send-email-muming.wq@taobao.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340003570-7193-1-git-send-email-muming.wq@taobao.com>
References: <1340003570-7193-1-git-send-email-muming.wq@taobao.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In our mind per-cpu sampling for cpu idle and non-idle is equal. But
actually may not. For non-idle cpu sampling, it's right the load when
sampling. But for idle, cause of nohz, the sampling will be delayed to
nohz exit(less than 1 tick after nohz exit). Nohz exit is always caused
by processes woken up--non-idle model. It's not fair here. Idle
sampling will be turned to non-idle sampling. And cause loadavg being
higher than normal.

     time-expected-sampling
                   |    time-do-sampling
                   |         |
                   V         V
-|-------------------------|--
start_nohz              stop_nohz

CC: Peter Zijlstra <peterz@infradead.org>
CC: Doug Smythies <dsmythies@telus.net>
CC: Ingo Molnar <mingo@redhat.com>
CC: Tao Ma <tm@tao.ma>
CC: Sha Zhengju <handai.szj@gmail.com>
Reported-by: Sha Zhengju <handai.szj@gmail.com>
Signed-off-by: Charles Wang <muming.wq@taobao.com>

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 691e7ec..2983838 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2166,6 +2166,7 @@ unsigned long this_cpu_load(void)
 static atomic_long_t calc_load_tasks;
 static unsigned long calc_load_update;
 static unsigned long calc_mask_update;
+static unsigned long calc_load_time_start = LOAD_FREQ;
 unsigned long avenrun[3];
 EXPORT_SYMBOL(avenrun);
 
@@ -2260,6 +2261,7 @@ void calc_load_account_idle(struct rq *this_rq)
 	long delta;
 
 	delta = calc_load_fold_active(this_rq);
+	this_rq->last_idle_enter = jiffies;
 	if (delta) {
 		atomic_long_add(delta, &calc_load_tasks_idle);
 		/*
@@ -2499,6 +2501,8 @@ void prepare_calc_load(void)
 static void calc_load_account_active(struct rq *this_rq)
 {
 	long delta;
+	unsigned long delta_time;
+	long last_idle_time_elapse;
 
 	if (time_before(jiffies, this_rq->calc_load_update))
 		return;
@@ -2508,15 +2512,24 @@ static void calc_load_account_active(struct rq *this_rq)
 		atomic_long_xchg(&calc_unmask_cpu_load_idle, 0);
 		delta = atomic_long_xchg(&calc_load_tasks_idle, 0);
 		atomic_long_add(delta, &calc_load_tasks);
+		calc_load_time_start = jiffies;
 	}
 	/* mark this cpu as load calculated */
 	set_cpu_load_update_mask();
 
+	last_idle_time_elapse = this_rq->last_idle_enter - calc_load_time_start;
+	delta_time = jiffies - this_rq->calc_load_update;
+	if (last_idle_time_elapse > 0)
+		goto out;
+	if ((last_idle_time_elapse > -1) && (delta_time >= 1))
+		goto out;
+
 	delta  = calc_load_fold_active(this_rq);
 	delta += calc_load_fold_unmask_idle();
 	if (delta)
 		atomic_long_add(delta, &calc_load_tasks);
 
+out:
 	this_rq->calc_load_update += LOAD_FREQ;
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 4134d37..a356588 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -438,6 +438,7 @@ struct rq {
 
 	/* calc_load related fields */
 	unsigned long calc_load_update;
+	unsigned long last_idle_enter;
 	long calc_load_active;
 
 #ifdef CONFIG_SCHED_HRTICK
-- 
1.7.9.5

