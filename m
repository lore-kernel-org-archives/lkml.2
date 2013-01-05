Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab3AEEea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 23:34:30 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:39150 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab3AEEe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 23:34:28 -0500
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Sat, 5 Jan 2013 12:26:42 +0800
Message-ID: <CANFwon03L14jDhLAE66F936WytwtN=+43QetETOG5ndUGptnow@mail.gmail.com>
Subject: [PATCH] Remove WARN_ON_ONCE in __smp_call_function_single and smp_call_function_single
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <mina86@mina86.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Cc: Zhu Yanhai <gaoyang.zyh@taobao.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comments of these WARN_ON_ONCE said "Can deadlock when called with
interrupts disabled".
But I didn't find anything that will block this function.

So I think maybe this WARN_ON_ONCE is not need now.  So I post a patch for that.

Signed-off-by: Hui Zhu <teawater@gmail.com>
Signed-off-by: Zhu Yanhai <gaoyang.zyh@taobao.com>

--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -303,25 +303,13 @@ int smp_call_function_single(int cpu, sm
 		.flags = 0,
 	};
 	unsigned long flags;
-	int this_cpu;
 	int err = 0;

 	/*
 	 * prevent preemption and reschedule on another processor,
 	 * as well as CPU removal
 	 */
-	this_cpu = get_cpu();
-
-	/*
-	 * Can deadlock when called with interrupts disabled.
-	 * We allow cpu's that are not yet online though, as no one else can
-	 * send smp call function interrupt to this cpu and as such deadlocks
-	 * can't happen.
-	 */
-	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
-		     && !oops_in_progress);
-
-	if (cpu == this_cpu) {
+	if (cpu == get_cpu()) {
 		local_irq_save(flags);
 		func(info);
 		local_irq_restore(flags);
@@ -409,17 +397,7 @@ void __smp_call_function_single(int cpu,
 	unsigned int this_cpu;
 	unsigned long flags;

-	this_cpu = get_cpu();
-	/*
-	 * Can deadlock when called with interrupts disabled.
-	 * We allow cpu's that are not yet online though, as no one else can
-	 * send smp call function interrupt to this cpu and as such deadlocks
-	 * can't happen.
-	 */
-	WARN_ON_ONCE(cpu_online(smp_processor_id()) && wait && irqs_disabled()
-		     && !oops_in_progress);
-
-	if (cpu == this_cpu) {
+	if (cpu == get_cpu()) {
 		local_irq_save(flags);
 		data->func(data->info);
 		local_irq_restore(flags);
