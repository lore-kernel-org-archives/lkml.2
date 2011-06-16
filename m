Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab1FPHBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:01:52 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36615 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756101Ab1FPHBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:46 -0400
X-Sasl-enc: P/IkI7CubM9zaRcrjhMM5AiCwlgpO1P/TCMXsy2P4t7Q 1308207705
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:37 2011
Message-Id: <20110616000236.920573231@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [81/89] x86: cpu-hotplug: Prevent softirq wakeup on wrong CPU
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit fd8a7de177b6f56a0fc59ad211c197a7df06b1ad upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/smpboot.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -285,6 +285,19 @@ notrace static void __cpuinit start_seco
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
 


