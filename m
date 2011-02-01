Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754Ab1BAHMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 02:12:20 -0500
Received: from mail4.comsite.net ([205.238.176.238]:43649 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab1BAHMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 02:12:19 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
Subject: [PATCH 1/3 v2] call_function_many: fix list delete vs add race
From: Milton Miller <miltonm@bga.com>
To: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org
Cc: Anton Blanchard <anton@samba.org>, xiaoguangrong@cn.fujitsu.com,
        mingo@elte.hu, jaxboe@fusionio.com, npiggin@gmail.com,
        rusty@rustcorp.com.au, efault@gmx.de, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
References: <20110112150740.77dde58c@kryten>
	 <1295288253.30950.280.camel@laptop>
	 <smp-call-function-peter-reply@mdm.bga.com>
	 <smp-call-function-move-writes@mdm.bga.com>
	 <1296145360.15234.234.camel@laptop> 
	 <smp-call-function-list-race@mdm.bga.com>
	 <smp-call-function-list-race-fix@mdm.bga.com>
	 <ipi-list-reply@mdm.bga.com>
In-Reply-To: <ipi-list-reply@mdm.bga.com>
Message-ID: <smp-call-function-list-race-fix-v2@mdm.bga.com>
Date: Tue, 01 Feb 2011 01:12:18 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter pointed out there was nothing preventing the list_del_rcu in
smp_call_function_interrupt from running before the list_add_rcu in
smp_call_function_many.   Fix this by not setting refs until we
have gotten the lock for the list.  Take advantage of the wmb in
list_add_rcu to save an explicit additional one.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Milton Miller <miltonm@bga.com>
---
v2: rely on wmb in list_add_rcu not combined partial ordering of spin
lock and unlock, which may not provide the needed guarantees.

I tried to force this race with a udelay before the lock & list_add
and by mixing all 64 online cpus with just 3 random cpus in the mask,
but was unsuccessful.  Still, inspection shows a valid race, and the
fix is a extension of the existing protection window in the current code.

Index: linux-2.6/kernel/smp.c
===================================================================
--- linux-2.6.orig/kernel/smp.c	2011-01-31 17:44:47.182756513 -0600
+++ linux-2.6/kernel/smp.c	2011-01-31 18:25:47.266755387 -0600
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
