Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab2HFImM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 04:42:12 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:60336 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab2HFImL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 04:42:11 -0400
Message-ID: <501F8357.3070102@linux.vnet.ibm.com>
Date: Mon, 06 Aug 2012 16:41:59 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] sched: using dst_rq instead of this_rq during load balance
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12080608-8256-0000-0000-000003991E4C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

As we already have dst_rq in lb_env, using or changing "this_rq" do not
make sense.

This patch will replace "this_rq" with dst_rq in load_balance, and we
don't need to change "this_rq" while process LBF_SOME_PINNED any more.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d0cc03b..f03b99c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4275,7 +4275,7 @@ redo:
 		goto out_balanced;
 	}
 
-	BUG_ON(busiest == this_rq);
+	BUG_ON(busiest == env.dst_rq);
 
 	schedstat_add(sd, lb_imbalance[idle], env.imbalance);
 
@@ -4295,7 +4295,7 @@ redo:
 
 more_balance:
 		local_irq_save(flags);
-		double_rq_lock(this_rq, busiest);
+		double_rq_lock(env.dst_rq, busiest);
 		if (!env.loop)
 			update_h_load(env.src_cpu);
 
@@ -4305,7 +4305,7 @@ more_balance:
 		 */
 		cur_ld_moved = move_tasks(&env);
 		ld_moved += cur_ld_moved;
-		double_rq_unlock(this_rq, busiest);
+		double_rq_unlock(env.dst_rq, busiest);
 		local_irq_restore(flags);
 
 		if (env.flags & LBF_NEED_BREAK) {
@@ -4341,8 +4341,7 @@ more_balance:
 		if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0 &&
 				lb_iterations++ < max_lb_iterations) {
 
-			this_rq		 = cpu_rq(env.new_dst_cpu);
-			env.dst_rq	 = this_rq;
+			env.dst_rq	 = cpu_rq(env.new_dst_cpu);
 			env.dst_cpu	 = env.new_dst_cpu;
 			env.flags	&= ~LBF_SOME_PINNED;
 			env.loop	 = 0;
-- 
1.7.4.1

