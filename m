Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab1BBAnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:43:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:32493 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab1BBAnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028229"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: heiko.carstens@de.ibm.com, a.p.zijlstra@chello.nl, ak@linux.intel.com,
        mingo@elte.hu, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [10/139] nohz: Fix printk_needs_cpu() return value on offline cpus
Message-Id: <20110202004324.310443E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 61ab25447ad6334a74e32f60efb135a3467223f8 upstream.

This patch fixes a hang observed with 2.6.32 kernels where timers got enqueued
on offline cpus.

printk_needs_cpu() may return 1 if called on offline cpus. When a cpu gets
offlined it schedules the idle process which, before killing its own cpu, will
call tick_nohz_stop_sched_tick(). That function in turn will call
printk_needs_cpu() in order to check if the local tick can be disabled. On
offline cpus this function should naturally return 0 since regardless if the
tick gets disabled or not the cpu will be dead short after. That is besides the
fact that __cpu_disable() should already have made sure that no interrupts on
the offlined cpu will be delivered anyway.

In this case it prevents tick_nohz_stop_sched_tick() to call
select_nohz_load_balancer(). No idea if that really is a problem. However what
made me debug this is that on 2.6.32 the function get_nohz_load_balancer() is
used within __mod_timer() to select a cpu on which a timer gets enqueued. If
printk_needs_cpu() returns 1 then the nohz_load_balancer cpu doesn't get
updated when a cpu gets offlined. It may contain the cpu number of an offline
cpu. In turn timers get enqueued on an offline cpu and not very surprisingly
they never expire and cause system hangs.

This has been observed 2.6.32 kernels. On current kernels __mod_timer() uses
get_nohz_timer_target() which doesn't have that problem. However there might be
other problems because of the too early exit tick_nohz_stop_sched_tick() in
case a cpu goes offline.

Easiest way to fix this is just to test if the current cpu is offline and call
printk_tick() directly which clears the condition.

Alternatively I tried a cpu hotplug notifier which would clear the condition,
however between calling the notifier function and printk_needs_cpu() something
could have called printk() again and the problem is back again. This seems to
be the safest fix.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <20101126120235.406766476@de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/printk.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.35.y/kernel/printk.c
===================================================================
--- linux-2.6.35.y.orig/kernel/printk.c
+++ linux-2.6.35.y/kernel/printk.c
@@ -1034,6 +1034,8 @@ void printk_tick(void)
 
 int printk_needs_cpu(int cpu)
 {
+	if (unlikely(cpu_is_offline(cpu)))
+		printk_tick();
 	return per_cpu(printk_pending, cpu);
 }
 
