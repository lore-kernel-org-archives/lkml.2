Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417Ab1COT1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 15:27:25 -0400
Received: from mail4.comsite.net ([205.238.176.238]:28374 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758170Ab1COT1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 15:27:18 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
Subject: [PATCH 4/4 v3] smp_call_function_interrupt: use typedef and %pf
To: akpm@linux-foundation.org
From: Milton Miller <miltonm@bga.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Anton Blanchard <anton@samba.org>,
        xiaoguangrong@cn.fujitsu.com, mingo@elte.hu,
        Jan Beulich <JBeulich@novell.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Tony Luck <tony.luck@intel.com>, jaxboe@fusionio.com,
        npiggin@gmail.com, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        efault@gmx.de, benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Message-ID: <smp-ipi-interrupt-cleanup-v3@mdm.bga.com>
In-Reply-To: <ipi-list-reply@mdm.bga.com>
References: <20110112150740.77dde58c@kryten>
	 <1295288253.30950.280.camel@laptop>
	 <smp-call-function-peter-reply@mdm.bga.com>
	 <smp-call-function-move-writes@mdm.bga.com>
	 <1296145360.15234.234.camel@laptop>
	 <smp-call-function-list-race@mdm.bga.com>
	 <smp-call-function-list-race-fix@mdm.bga.com>
	 <1296458482.7889.175.camel@marge.simson.net>
	 <ipi-list-reply@mdm.bga.com>
Date: Tue, 15 Mar 2011 13:27:17 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly added smp_call_func_t in smp_call_function_interrupt
for the func variable, and make the comment above the WARN more assertive
and explicit.  Also, func is a function pointer and does not need an
offset, so use %pf not %pS.

Signed-off-by: Milton Miller <miltonm@bga.com>
---
v3 use func to call the function too, as suggested, instead of making
compiler notice the repeated access.

Index: common/kernel/smp.c
===================================================================
--- common.orig/kernel/smp.c	2011-03-15 06:22:26.000000000 -0500
+++ common/kernel/smp.c	2011-03-15 06:55:07.000000000 -0500
@@ -194,7 +194,7 @@ void generic_smp_call_function_interrupt
 	 */
 	list_for_each_entry_rcu(data, &call_function.queue, csd.list) {
 		int refs;
-		void (*func) (void *info);
+		smp_call_func_t func;
 
 		/*
 		 * Since we walk the list without any locks, we might
@@ -214,16 +214,17 @@ void generic_smp_call_function_interrupt
 		if (atomic_read(&data->refs) == 0)
 			continue;
 
-		func = data->csd.func;			/* for later warn */
-		data->csd.func(data->csd.info);
+		func = data->csd.func;		/* save for later warn */
+		func(data->csd.info);
 
 		/*
-		 * If the cpu mask is not still set then it enabled interrupts,
-		 * we took another smp interrupt, and executed the function
-		 * twice on this cpu.  In theory that copy decremented refs.
+		 * If the cpu mask is not still set then func enabled
+		 * interrupts (BUG), and this cpu took another smp call
+		 * function interrupt and executed func(info) twice
+		 * on this cpu.  That nested execution decremented refs.
 		 */
 		if (!cpumask_test_and_clear_cpu(cpu, data->cpumask)) {
-			WARN(1, "%pS enabled interrupts and double executed\n",
+			WARN(1, "%pf enabled interrupts and double executed\n",
 			     func);
 			continue;
 		}
