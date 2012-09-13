Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750858Ab2IMELj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 00:11:39 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65333 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2IMELh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 00:11:37 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Cc: peterz@infradead.org, mingo@redhat.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC] sched: nohz_idle_balance
Date: Thu, 13 Sep 2012 06:11:26 +0200
Message-Id: <1347509486-8688-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On tickless system, one CPU runs load balance for all idle CPUs.
The cpu_load of this CPU is updated before starting the load balance
of each other idle CPUs. We should instead update the cpu_load of the balance_cpu.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1ca4fe4..9ae3a5b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4794,14 +4794,15 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 		if (need_resched())
 			break;
 
-		raw_spin_lock_irq(&this_rq->lock);
-		update_rq_clock(this_rq);
-		update_idle_cpu_load(this_rq);
-		raw_spin_unlock_irq(&this_rq->lock);
+		rq = cpu_rq(balance_cpu);
+
+		raw_spin_lock_irq(&rq->lock);
+		update_rq_clock(rq);
+		update_idle_cpu_load(rq);
+		raw_spin_unlock_irq(&rq->lock);
 
 		rebalance_domains(balance_cpu, CPU_IDLE);
 
-		rq = cpu_rq(balance_cpu);
 		if (time_after(this_rq->next_balance, rq->next_balance))
 			this_rq->next_balance = rq->next_balance;
 	}
-- 
1.7.9.5

