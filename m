Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab2FROl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 10:41:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50063 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab2FROl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 10:41:58 -0400
Message-ID: <4FDF3E30.2090307@gmail.com>
Date: Mon, 18 Jun 2012 22:41:52 +0800
From: Charles Wang <muming.wq@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Doug Smythies <dsmythies@telus.net>
CC: "'Peter Zijlstra'" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        "'Ingo Molnar'" <mingo@redhat.com>, "'Tao Ma'" <tm@tao.ma>,
        =?ISO-2022-JP?B?JxskQjReQmMbKEIn?= <handai.szj@taobao.com>
Subject: Re: [PATCH] sched: Folding nohz load accounting more accurate
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>	  <1339429374.30462.54.camel@twins> <4FD70D12.5030404@gmail.com>	 <1339494970.31548.66.camel@twins> <4FDB4642.5070509@gmail.com> <1339781988.15222.6.camel@twins> <000801cd4bcf$d6018630$82049290$@net> <001401cd4d1d$79f370c0$6dda5240$@net>
In-Reply-To: <001401cd4d1d$79f370c0$6dda5240$@net>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter's patch works the well.  Now I ported the second patch
to fix high load problem based on Peter's. It works fine on my testing
environment.  Doug, please try this. Thanks.


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

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4101a0e..180e612 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2228,6 +2228,7 @@ void calc_load_account_idle(struct rq *this_rq)
        int idx;

        delta = calc_load_fold_active(this_rq);
+       this_rq->last_idle_enter = jiffies;

        if (delta) {
                idx = calc_load_write_idx();
                atomic_long_add(delta, &calc_load_idle[idx]);
@@ -2431,15 +2432,27 @@ void calc_global_load(void)
 static void calc_load_account_active(struct rq *this_rq)
 {
        long delta;
+       unsigned long delta_time;
+       long last_idle_time_elapse;

        if (time_before(jiffies, this_rq->calc_load_update))
                return;

+       last_idle_time_elapse = this_rq->last_idle_enter - calc_load_update;
+       delta_time = jiffies - this_rq->calc_load_update;
+
+       if (last_idle_time_elapse > 0)
+               goto out;
+
+       if ((last_idle_time_elapse > -1) && (delta_time >= 1))
+               goto out;
+
        delta  = calc_load_fold_active(this_rq);
        delta += calc_load_fold_idle();
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
+       unsigned long last_idle_enter;
        long calc_load_active;

 #ifdef CONFIG_SCHED_HRTICK
-- 
1.7.9.5
