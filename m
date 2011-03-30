Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933747Ab1C3VZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:25:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:22688 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965096Ab1C3VJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903736316"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: miltonm@bga.com, torvalds@linux-foundation.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [212/275] call_function_many: fix list delete vs add race
Message-Id: <20110330210736.E2D323E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Milton Miller <miltonm@bga.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/smp.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

Index: linux-2.6.35.y/kernel/smp.c
===================================================================
--- linux-2.6.35.y.orig/kernel/smp.c	2011-03-29 23:02:59.591310628 -0700
+++ linux-2.6.35.y/kernel/smp.c	2011-03-29 23:54:07.475811139 -0700
@@ -468,14 +468,15 @@
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
@@ -484,6 +485,11 @@
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
