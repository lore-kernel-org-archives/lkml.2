Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934051Ab1FWRrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:47:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:35497 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933775Ab1FWRi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:26 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Milton Miller <miltonm@bga.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 196/247] call_function_many: add missing ordering
Date: Thu, 23 Jun 2011 13:34:24 -0400
Message-Id: <1308850515-15242-137-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milton Miller <miltonm@bga.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 45a5791920ae643eafc02e2eedef1a58e341b736 upstream.

Paul McKenney's review pointed out two problems with the barriers in the
2.6.38 update to the smp call function many code.

First, a barrier that would force the func and info members of data to
be visible before their consumption in the interrupt handler was
missing.  This can be solved by adding a smp_wmb between setting the
func and info members and setting setting the cpumask; this will pair
with the existing and required smp_rmb ordering the cpumask read before
the read of refs.  This placement avoids the need a second smp_rmb in
the interrupt handler which would be executed on each of the N cpus
executing the call request.  (I was thinking this barrier was present
but was not).

Second, the previous write to refs (establishing the zero that we the
interrupt handler was testing from all cpus) was performed by a third
party cpu.  This would invoke transitivity which, as a recient or
concurrent addition to memory-barriers.txt now explicitly states, would
require a full smp_mb().

However, we know the cpumask will only be set by one cpu (the data
owner) and any preivous iteration of the mask would have cleared by the
reading cpu.  By redundantly writing refs to 0 on the owning cpu before
the smp_wmb, the write to refs will follow the same path as the writes
that set the cpumask, which in turn allows us to keep the barrier in the
interrupt handler a smp_rmb instead of promoting it to a smp_mb (which
will be be executed by N cpus for each of the possible M elements on the
list).

I moved and expanded the comment about our (ab)use of the rcu list
primitives for the concurrent walk earlier into this function.  I
considered moving the first two paragraphs to the queue list head and
lock, but felt it would have been too disconected from the code.

Cc: Paul McKinney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/smp.c |   46 +++++++++++++++++++++++++++++++++-------------
 1 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index de11a66..9686dbf 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -462,23 +462,42 @@ void smp_call_function_many(const struct cpumask *mask,
 
 	data = &__get_cpu_var(cfd_data);
 	csd_lock(&data->csd);
-	BUG_ON(atomic_read(&data->refs) || !cpumask_empty(data->cpumask));
 
-	data->csd.func = func;
-	data->csd.info = info;
-	cpumask_and(data->cpumask, mask, cpu_online_mask);
-	cpumask_clear_cpu(this_cpu, data->cpumask);
+	/* This BUG_ON verifies our reuse assertions and can be removed */
+	BUG_ON(atomic_read(&data->refs) || !cpumask_empty(data->cpumask));
 
 	/*
+	 * The global call function queue list add and delete are protected
+	 * by a lock, but the list is traversed without any lock, relying
+	 * on the rcu list add and delete to allow safe concurrent traversal.
 	 * We reuse the call function data without waiting for any grace
 	 * period after some other cpu removes it from the global queue.
-	 * This means a cpu might find our data block as it is writen.
-	 * The interrupt handler waits until it sees refs filled out
-	 * while its cpu mask bit is set; here we may only clear our
-	 * own cpu mask bit, and must wait to set refs until we are sure
-	 * previous writes are complete and we have obtained the lock to
-	 * add the element to the queue.
+	 * This means a cpu might find our data block as it is being
+	 * filled out.
+	 *
+	 * We hold off the interrupt handler on the other cpu by
+	 * ordering our writes to the cpu mask vs our setting of the
+	 * refs counter.  We assert only the cpu owning the data block
+	 * will set a bit in cpumask, and each bit will only be cleared
+	 * by the subject cpu.  Each cpu must first find its bit is
+	 * set and then check that refs is set indicating the element is
+	 * ready to be processed, otherwise it must skip the entry.
+	 *
+	 * On the previous iteration refs was set to 0 by another cpu.
+	 * To avoid the use of transitivity, set the counter to 0 here
+	 * so the wmb will pair with the rmb in the interrupt handler.
 	 */
+	atomic_set(&data->refs, 0);	/* convert 3rd to 1st party write */
+
+	data->csd.func = func;
+	data->csd.info = info;
+
+	/* Ensure 0 refs is visible before mask.  Also orders func and info */
+	smp_wmb();
+
+	/* We rely on the "and" being processed before the store */
+	cpumask_and(data->cpumask, mask, cpu_online_mask);
+	cpumask_clear_cpu(this_cpu, data->cpumask);
 
 	raw_spin_lock_irqsave(&call_function.lock, flags);
 	/*
@@ -488,8 +507,9 @@ void smp_call_function_many(const struct cpumask *mask,
 	 */
 	list_add_rcu(&data->csd.list, &call_function.queue);
 	/*
-	 * We rely on the wmb() in list_add_rcu to order the writes
-	 * to func, data, and cpumask before this write to refs.
+	 * We rely on the wmb() in list_add_rcu to complete our writes
+	 * to the cpumask before this write to refs, which indicates
+	 * data is on the list and is ready to be processed.
 	 */
 	atomic_set(&data->refs, cpumask_weight(data->cpumask));
 	raw_spin_unlock_irqrestore(&call_function.lock, flags);
-- 
1.7.4.4

