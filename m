Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab0KZMCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 07:02:42 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:59861 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab0KZMCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 07:02:40 -0500
Message-Id: <20101126120235.406766476@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 26 Nov 2010 13:00:59 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Christof Schmitt <christof.schmitt@de.ibm.com>,
        Frank Blaschka <frank.blaschka@de.ibm.com>,
        Horst Hartmann <horsth@linux.vnet.ibm.com>, stable@kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 2/3] nohz: fix printk_needs_cpu() return value on offline cpus
References: <20101126120057.879397696@de.ibm.com>
Content-Disposition: inline; filename=002_printk_needs_cpu.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

This patch fixes a hang observed with 2.6.32 kernels where timers got
enqueued on offline cpus.

printk_needs_cpu() may return 1 if called on offline cpus. When a cpu gets
offlined it schedules the idle process which, before killing its own cpu,
will call tick_nohz_stop_sched_tick().
That function in turn will call printk_needs_cpu() in order to check if the
local tick can be disabled. On offline cpus this function should naturally
return 0 since regardless if the tick gets disabled or not the cpu will be
dead short after. That is besides the fact that __cpu_disable() should already
have made sure that no interrupts on the offlined cpu will be delivered anyway.

In this case it prevents tick_nohz_stop_sched_tick() to call
select_nohz_load_balancer(). No idea if that really is a problem. However what
made me debug this is that on 2.6.32 the function get_nohz_load_balancer() is
used within __mod_timer() to select a cpu on which a timer gets enqueued.
If printk_needs_cpu() returns 1 then the nohz_load_balancer cpu doesn't get
updated when a cpu gets offlined. It may contain the cpu number of an offline
cpu. In turn timers get enqueued on an offline cpu and not very surprisingly
they never expire and cause system hangs.

This has been observed 2.6.32 kernels. On current kernels __mod_timer() uses
get_nohz_timer_target() which doesn't have that problem. However there might
be other problems because of the too early exit tick_nohz_stop_sched_tick()
in case a cpu goes offline.

Easiest way to fix this is just to test if the current cpu is offline and
call printk_tick() directly which clears the condition.

Alternatively I tried a cpu hotplug notifier which would clear the condition,
however between calling the notifier function and printk_needs_cpu() something
could have called printk() again and the problem is back again. This seems to
be the safest fix.

Cc: stable@kernel.org
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/printk.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1082,6 +1082,8 @@ void printk_tick(void)
 
 int printk_needs_cpu(int cpu)
 {
+	if (unlikely(cpu_is_offline(cpu)))
+		printk_tick();
 	return per_cpu(printk_pending, cpu);
 }
 

