Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab1I3N75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 09:59:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:51995 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab1I3N74 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 09:59:56 -0400
Subject: [PATCH -rt] softirq: Fix unplug deadlock
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: rostedt <rostedt@goodmis.org>, Clark Williams <williams@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 30 Sep 2011 15:59:16 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317391156.12973.3.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [RT] softirq: Fix unplug deadlock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri Sep 30 15:52:14 CEST 2011

If ksoftirqd gets woken during hot-unplug, __thread_do_softirq() will
call pin_current_cpu() which will block on the held cpu_hotplug.lock.
Moving the offline check in __thread_do_softirq() before the
pin_current_cpu() call doesn't work, since the wakeup can happen
before we mark the cpu offline.

So here we have the ksoftirq thread stuck until hotplug finishes, but
then the ksoftirq CPU_DOWN notifier issues kthread_stop() which will
wait for the ksoftirq thread to go away -- while holding the hotplug
lock.

Sort this by delaying the kthread_stop() until CPU_POST_DEAD, which is
outside of the cpu_hotplug.lock, but still serialized by the
cpu_add_remove_lock.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/softirq.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: linux-rt/kernel/softirq.c
===================================================================
--- linux-rt.orig/kernel/softirq.c
+++ linux-rt/kernel/softirq.c
@@ -1104,9 +1104,8 @@ static int __cpuinit cpu_callback(struct
 	int hotcpu = (unsigned long)hcpu;
 	struct task_struct *p;
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		p = kthread_create_on_node(run_ksoftirqd,
 					   hcpu,
 					   cpu_to_node(hotcpu),
@@ -1119,19 +1118,16 @@ static int __cpuinit cpu_callback(struct
   		per_cpu(ksoftirqd, hotcpu) = p;
  		break;
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 		wake_up_process(per_cpu(ksoftirqd, hotcpu));
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 		if (!per_cpu(ksoftirqd, hotcpu))
 			break;
 		/* Unbind so it can run.  Fall thru. */
 		kthread_bind(per_cpu(ksoftirqd, hotcpu),
 			     cpumask_any(cpu_online_mask));
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN: {
+	case CPU_POST_DEAD: {
 		static const struct sched_param param = {
 			.sched_priority = MAX_RT_PRIO-1
 		};

