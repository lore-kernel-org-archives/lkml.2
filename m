Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab1FJMw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:52:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:38150 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab1FJMw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:52:27 -0400
Date: Fri, 10 Jun 2011 14:52:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: LKML <linux-kernel@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: 2.6.39: crash w/threadirqs option enabled
In-Reply-To: <alpine.DEB.2.02.1106100414550.32450@p34.internal.lan>
Message-ID: <alpine.LFD.2.02.1106101450030.11814@ionos>
References: <alpine.DEB.2.02.1105200405210.24033@p34.internal.lan> <alpine.LFD.2.02.1105201445300.3078@ionos> <alpine.DEB.2.02.1105200850080.19553@p34.internal.lan> <alpine.LFD.2.02.1105201528500.3078@ionos> <alpine.DEB.2.02.1105200945300.19553@p34.internal.lan>
 <alpine.LFD.2.02.1105201712501.3078@ionos> <alpine.DEB.2.02.1105201210030.19553@p34.internal.lan> <alpine.LFD.2.02.1105201819310.3078@ionos> <alpine.DEB.2.02.1106100414550.32450@p34.internal.lan>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011, Justin Piszcz wrote:
> On Fri, 20 May 2011, Thomas Gleixner wrote:
> Crashed again and it rebooted too:
> 
> reboot   system boot  2.6.39             Thu Jun  9 23:58 - 04:05  (04:06)
> user1      pts/0        X                Thu Jun  9 19:25 - 19:30  (00:04)
> user1      pts/10       X                Thu Jun  9 18:23 - crash  (05:35)
> 
> Any thoughts on what could be causing this?
> Should I go back to 2.6.38?

If you remove the threadirqs option from the commandline it does not
happen, right?

Can you try the following patch ?

Thanks,

	tglx
---
commit fd8a7de177b6f56a0fc59ad211c197a7df06b1ad
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Tue Jul 20 14:34:50 2010 +0200

    x86: cpu-hotplug: Prevent softirq wakeup on wrong CPU
    
    After a newly plugged CPU sets the cpu_online bit it enables
    interrupts and goes idle. The cpu which brought up the new cpu waits
    for the cpu_online bit and when it observes it, it sets the cpu_active
    bit for this cpu. The cpu_active bit is the relevant one for the
    scheduler to consider the cpu as a viable target.
    
    With forced threaded interrupt handlers which imply forced threaded
    softirqs we observed the following race:
    
    cpu 0                         cpu 1
    
    bringup(cpu1);
                                  set_cpu_online(smp_processor_id(), true);
    		              local_irq_enable();
    while (!cpu_online(cpu1));
                                  timer_interrupt()
                                    -> wake_up(softirq_thread_cpu1);
                                         -> enqueue_on(softirq_thread_cpu1, cpu0);
    
                                                                            ^^^^
    
    cpu_notify(CPU_ONLINE, cpu1);
      -> sched_cpu_active(cpu1)
         -> set_cpu_active((cpu1, true);
    
    When an interrupt happens before the cpu_active bit is set by the cpu
    which brought up the newly onlined cpu, then the scheduler refuses to
    enqueue the woken thread which is bound to that newly onlined cpu on
    that newly onlined cpu due to the not yet set cpu_active bit and
    selects a fallback runqueue. Not really an expected and desirable
    behaviour.
    
    So far this has only been observed with forced hard/softirq threading,
    but in theory this could happen without forced threaded hard/softirqs
    as well. It's probably unobservable as it would take a massive
    interrupt storm on the newly onlined cpu which causes the softirq loop
    to wake up the softirq thread and an even longer delay of the cpu
    which waits for the cpu_online bit.
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Reviewed-by: Peter Zijlstra <peterz@infradead.org>
    Cc: stable@kernel.org # 2.6.39

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 33a0c11..9fd3137 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -285,6 +285,19 @@ notrace static void __cpuinit start_secondary(void *unused)
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 	x86_platform.nmi_init();
 
+	/*
+	 * Wait until the cpu which brought this one up marked it
+	 * online before enabling interrupts. If we don't do that then
+	 * we can end up waking up the softirq thread before this cpu
+	 * reached the active state, which makes the scheduler unhappy
+	 * and schedule the softirq thread on the wrong cpu. This is
+	 * only observable with forced threaded interrupts, but in
+	 * theory it could also happen w/o them. It's just way harder
+	 * to achieve.
+	 */
+	while (!cpumask_test_cpu(smp_processor_id(), cpu_active_mask))
+		cpu_relax();
+
 	/* enable local interrupts */
 	local_irq_enable();
 
