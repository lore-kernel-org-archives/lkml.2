Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817Ab1FWRih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:38:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:35521 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933792Ab1FWRia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:30 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Milton Miller <miltonm@bga.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 195/247] call_function_many: fix list delete vs add race
Date: Thu, 23 Jun 2011 13:34:23 -0400
Message-Id: <1308850515-15242-136-git-send-email-paul.gortmaker@windriver.com>
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

commit e6cd1e07a185d5f9b0aa75e020df02d3c1c44940 upstream.

Peter pointed out there was nothing preventing the list_del_rcu in
smp_call_function_interrupt from running before the list_add_rcu in
smp_call_function_many.

Fix this by not setting refs until we have gotten the lock for the list.
Take advantage of the wmb in list_add_rcu to save an explicit additional
one.

I tried to force this race with a udelay before the lock & list_add and
by mixing all 64 online cpus with just 3 random cpus in the mask, but
was unsuccessful.  Still, inspection shows a valid race, and the fix is
a extension of the existing protection window in the current code.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/smp.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 0a9e6bd..de11a66 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -470,14 +470,15 @@ void smp_call_function_many(const struct cpumask *mask,
 	cpumask_clear_cpu(this_cpu, data->cpumask);
 
 	/*
-	 * To ensure the interrupt handler gets an complete view
-	 * we order the cpumask and refs writes and order the read
-	 * of them in the interrupt handler.  In addition we may
-	 * only clear our own cpu bit from the mask.
+	 * We reuse the call function data without waiting for any grace
+	 * period after some other cpu removes it from the global queue.
+	 * This means a cpu might find our data block as it is writen.
+	 * The interrupt handler waits until it sees refs filled out
+	 * while its cpu mask bit is set; here we may only clear our
+	 * own cpu mask bit, and must wait to set refs until we are sure
+	 * previous writes are complete and we have obtained the lock to
+	 * add the element to the queue.
 	 */
-	smp_wmb();
-
-	atomic_set(&data->refs, cpumask_weight(data->cpumask));
 
 	raw_spin_lock_irqsave(&call_function.lock, flags);
 	/*
@@ -486,6 +487,11 @@ void smp_call_function_many(const struct cpumask *mask,
 	 * will not miss any other list entries:
 	 */
 	list_add_rcu(&data->csd.list, &call_function.queue);
+	/*
+	 * We rely on the wmb() in list_add_rcu to order the writes
+	 * to func, data, and cpumask before this write to refs.
+	 */
+	atomic_set(&data->refs, cpumask_weight(data->cpumask));
 	raw_spin_unlock_irqrestore(&call_function.lock, flags);
 
 	/*
-- 
1.7.4.4

