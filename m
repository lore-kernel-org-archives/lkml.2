Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab2HMRGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:06:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33712 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab2HMRGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:06:39 -0400
Date: Mon, 13 Aug 2012 10:06:22 -0700
From: tip-bot for Michael Wang <wangyun@linux.vnet.ibm.com>
Message-ID: <tip-78feefc512a09165627dd534111f651b6c8e605f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, wangyun@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, wangyun@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <501F8357.3070102@linux.vnet.ibm.com>
References: <501F8357.3070102@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  using dst_rq instead of this_rq during load balance
Git-Commit-ID: 78feefc512a09165627dd534111f651b6c8e605f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 13 Aug 2012 10:06:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  78feefc512a09165627dd534111f651b6c8e605f
Gitweb:     http://git.kernel.org/tip/78feefc512a09165627dd534111f651b6c8e605f
Author:     Michael Wang <wangyun@linux.vnet.ibm.com>
AuthorDate: Mon, 6 Aug 2012 16:41:59 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 13 Aug 2012 18:58:15 +0200

sched: using dst_rq instead of this_rq during load balance

As we already have dst_rq in lb_env, using or changing "this_rq" do not
make sense.

This patch will replace "this_rq" with dst_rq in load_balance, and we
don't need to change "this_rq" while process LBF_SOME_PINNED any more.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/501F8357.3070102@linux.vnet.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/fair.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 99285a8..287bfac 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4283,7 +4283,7 @@ redo:
 		goto out_balanced;
 	}
 
-	BUG_ON(busiest == this_rq);
+	BUG_ON(busiest == env.dst_rq);
 
 	schedstat_add(sd, lb_imbalance[idle], env.imbalance);
 
@@ -4304,7 +4304,7 @@ redo:
 		update_h_load(env.src_cpu);
 more_balance:
 		local_irq_save(flags);
-		double_rq_lock(this_rq, busiest);
+		double_rq_lock(env.dst_rq, busiest);
 
 		/*
 		 * cur_ld_moved - load moved in current iteration
@@ -4312,7 +4312,7 @@ more_balance:
 		 */
 		cur_ld_moved = move_tasks(&env);
 		ld_moved += cur_ld_moved;
-		double_rq_unlock(this_rq, busiest);
+		double_rq_unlock(env.dst_rq, busiest);
 		local_irq_restore(flags);
 
 		if (env.flags & LBF_NEED_BREAK) {
@@ -4348,8 +4348,7 @@ more_balance:
 		if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0 &&
 				lb_iterations++ < max_lb_iterations) {
 
-			this_rq		 = cpu_rq(env.new_dst_cpu);
-			env.dst_rq	 = this_rq;
+			env.dst_rq	 = cpu_rq(env.new_dst_cpu);
 			env.dst_cpu	 = env.new_dst_cpu;
 			env.flags	&= ~LBF_SOME_PINNED;
 			env.loop	 = 0;
