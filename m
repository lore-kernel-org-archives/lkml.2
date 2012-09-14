Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab2INGMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:12:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48927 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922Ab2INGMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:12:33 -0400
Date: Thu, 13 Sep 2012 23:12:17 -0700
From: tip-bot for Vincent Guittot <vincent.guittot@linaro.org>
Message-ID: <tip-5ed4f1d96deee82ee92cd1ac1e0108c27e80e9b0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, vincent.guittot@linaro.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, venki@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com,
        vincent.guittot@linaro.org, tglx@linutronix.de, venki@google.com
In-Reply-To: <1347509486-8688-1-git-send-email-vincent.guittot@linaro.org>
References: <1347509486-8688-1-git-send-email-vincent.guittot@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix nohz_idle_balance()
Git-Commit-ID: 5ed4f1d96deee82ee92cd1ac1e0108c27e80e9b0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:12:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ed4f1d96deee82ee92cd1ac1e0108c27e80e9b0
Gitweb:     http://git.kernel.org/tip/5ed4f1d96deee82ee92cd1ac1e0108c27e80e9b0
Author:     Vincent Guittot <vincent.guittot@linaro.org>
AuthorDate: Thu, 13 Sep 2012 06:11:26 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 13 Sep 2012 16:52:03 +0200

sched: Fix nohz_idle_balance()

On tickless systems, one CPU runs load balance for all idle CPUs.

The cpu_load of this CPU is updated before starting the load balance
of each other idle CPUs. We should instead update the cpu_load of
the balance_cpu.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1347509486-8688-1-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

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
