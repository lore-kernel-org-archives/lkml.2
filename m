Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab1CUXXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:23:12 -0400
Received: from kroah.org ([198.145.64.141]:52789 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932416Ab1CUXS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:18:29 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:28 2011
Message-Id: <20110321230328.403103871@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:02:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Milton Miller <miltonm@bga.com>
Subject: [65/78] call_function_many: fix list delete vs add race
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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

---
 kernel/smp.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -491,14 +491,15 @@ void smp_call_function_many(const struct
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
@@ -507,6 +508,11 @@ void smp_call_function_many(const struct
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


