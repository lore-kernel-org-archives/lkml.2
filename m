Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab1A2AUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 19:20:17 -0500
Received: from mail4.comsite.net ([205.238.176.238]:20945 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab1A2AUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 19:20:16 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=65.70.204.62;
Subject: call_function_many: fix list delete vs add race
From: Milton Miller <miltonm@bga.com>
To: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org
Cc: Anton Blanchard <anton@samba.org>, xiaoguangrong@cn.fujitsu.com,
        mingo@elte.hu, jaxboe@fusionio.com, npiggin@gmail.com,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
References: <20110112150740.77dde58c@kryten>
	 <1295288253.30950.280.camel@laptop>
	 <smp-call-function-peter-reply@mdm.bga.com>
	 <smp-call-function-move-writes@mdm.bga.com>
	 <1296145360.15234.234.camel@laptop> 
	 <smp-call-function-list-race@mdm.bga.com>
In-Reply-To: <smp-call-function-list-race@mdm.bga.com>
Message-ID: <smp-call-function-list-race-fix@mdm.bga.com>
Date: Fri, 28 Jan 2011 18:20:14 -0600
X-Originating-IP: 65.70.204.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Peter pointed out there was nothing preventing the list_del_rcu in
smp_call_function_interrupt from running before the list_add_rcu in
smp_call_function_many.   Fix this by not setting refs until we have put
the entry on the list.  We can use the lock acquire and release instead
of a wmb.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Milton Miller <miltonm@bga.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
---

I tried to force this race with a udelay before the lock & list_add and
by mixing all 64 online cpus with just 3 random cpus in the mask, but
was unsuccessful.  Still, it seems to be a valid race, and the fix
is a simple change to the current code.

Index: common/kernel/smp.c
===================================================================
--- common.orig/kernel/smp.c	2011-01-28 16:23:15.000000000 -0600
+++ common/kernel/smp.c	2011-01-28 16:55:01.000000000 -0600
@@ -491,15 +491,17 @@ void smp_call_function_many(const struct
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
+	 * add the element to the queue.  We use the acquire and release
+	 * of the lock as a wmb() -- acquire prevents write moving up and
+	 * release requires old writes are visible.
 	 */
-	smp_wmb();
-
-	atomic_set(&data->refs, cpumask_weight(data->cpumask));
-
 	raw_spin_lock_irqsave(&call_function.lock, flags);
 	/*
 	 * Place entry at the _HEAD_ of the list, so that any cpu still
@@ -509,6 +511,8 @@ void smp_call_function_many(const struct
 	list_add_rcu(&data->csd.list, &call_function.queue);
 	raw_spin_unlock_irqrestore(&call_function.lock, flags);
 
+	atomic_set(&data->refs, cpumask_weight(data->cpumask));
+
 	/*
 	 * Make the list addition visible before sending the ipi.
 	 * (IPIs must obey or appear to obey normal Linux cache
