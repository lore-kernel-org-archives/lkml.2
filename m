Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab1AFA3C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:29:02 -0500
Received: from kroah.org ([198.145.64.141]:35413 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab1AFA24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:28:56 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:22:58 2011
Message-Id: <20110106002257.928654963@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:21:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [013/152] nohz: Fix printk_needs_cpu() return value on offline cpus
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
LKML-Reference: <20101126120235.406766476@de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/printk.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1062,6 +1062,8 @@ void printk_tick(void)
 
 int printk_needs_cpu(int cpu)
 {
+	if (unlikely(cpu_is_offline(cpu)))
+		printk_tick();
 	return per_cpu(printk_pending, cpu);
 }
 


