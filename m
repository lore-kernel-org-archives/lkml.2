Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab2IQIyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:54:24 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39417 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab2IQIyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:54:21 -0400
MIME-Version: 1.0
Date: Mon, 17 Sep 2012 16:54:19 +0800
Message-ID: <CAH83jXTx7OEYCFJx-hKA6P1v90MYNmNaE2N4m92RZgCc8Agh_g@mail.gmail.com>
Subject: Side effects of disabling SCHED_SOFTIRQ to trigger run_rebalance_domains
From: Xiong Wu <xiong.wu1981@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Since observed dead lock problem in sched run_rebalance_domains of
kernel 2.6.21.7, we just disabling SCHED_SOFTIRQ to trigger
run_rebalance_domains as one work around. The patch is as below:

--- kernel/sched.c      2012-06-29 23:17:34.000000000 +0800
+++ kernel-new/sched.c  2012-09-12 17:27:28.000000000 +0800
@@ -2940,7 +2940,7 @@ static void update_load(struct rq *this_
  * Balancing parameters are set up in arch_init_sched_domains.
  */
 static DEFINE_SPINLOCK(balancing);
-
+#if 0
 static void run_rebalance_domains(struct softirq_action *h)
 {
        int this_cpu = smp_processor_id(), balance = 1;
@@ -3001,6 +3001,7 @@ out:
        }
        this_rq->next_balance = next_balance;
 }
+#endif
 #else
 /*
  * on UP we do not need to balance between CPUs:
@@ -3230,9 +3231,11 @@ void scheduler_tick(void)
                task_running_tick(rq, p);
 #ifdef CONFIG_SMP
        update_load(rq);
+#if 0
        if (time_after_eq(jiffies, rq->next_balance))
                raise_softirq(SCHED_SOFTIRQ);
 #endif
+#endif
 }

 #if defined(CONFIG_PREEMPT) && defined(CONFIG_DEBUG_PREEMPT)
@@ -6766,9 +6769,11 @@ void __init sched_init(void)

        set_load_weight(&init_task);

+#if 0
 #ifdef CONFIG_SMP
        open_softirq(SCHED_SOFTIRQ, run_rebalance_domains, NULL);
 #endif
+#endif

 #ifdef CONFIG_RT_MUTEXES
        plist_head_init(&init_task.pi_waiters, &init_task.pi_lock);


Our experimentations and simulations that we have conducted so far did
not indicated any performance decrease due to disable re-balancing.
Since our system isn't always busy, the idle_balance can work well for
processes load balance instead of run_rebalance_domains.  However my
concern is if there is any side effects which I didn't consider.



Thanks,
Xiong
