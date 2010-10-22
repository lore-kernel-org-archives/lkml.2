Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab0JVSjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:39:10 -0400
Received: from kroah.org ([198.145.64.141]:45881 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758333Ab0JVSjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:39:05 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:36:01 2010
Message-Id: <20101022183601.551335503@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:35:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Galbraith <efault@gmx.de>
Subject: [60/66] fix 2.6.32.23 suspend regression caused by commit 6f6198a
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Galbraith <efault@gmx.de>

[Not upstream in the same way, as it was fixed differently there]

6f6198a sched: kill migration thread in CPU_POST_DEAD instead of CPU_DEAD
leaves migration threads lying about.  Mask out CPU_TASKS_FROZEN.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7752,10 +7752,9 @@ migration_call(struct notifier_block *nf
 	unsigned long flags;
 	struct rq *rq;
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		p = kthread_create(migration_thread, hcpu, "migration/%d", cpu);
 		if (IS_ERR(p))
 			return NOTIFY_BAD;
@@ -7770,7 +7769,6 @@ migration_call(struct notifier_block *nf
 		break;
 
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 		/* Strictly unnecessary, as first user will wake it. */
 		wake_up_process(cpu_rq(cpu)->migration_thread);
 
@@ -7787,7 +7785,6 @@ migration_call(struct notifier_block *nf
 
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 		if (!cpu_rq(cpu)->migration_thread)
 			break;
 		/* Unbind it from offline cpu so it can run. Fall thru. */
@@ -7812,7 +7809,6 @@ migration_call(struct notifier_block *nf
 		break;
 
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		migrate_live_tasks(cpu);
 		rq = cpu_rq(cpu);
 		/* Idle task back to normal (off runqueue, low prio) */
@@ -7846,7 +7842,6 @@ migration_call(struct notifier_block *nf
 		break;
 
 	case CPU_DYING:
-	case CPU_DYING_FROZEN:
 		/* Update our root-domain */
 		rq = cpu_rq(cpu);
 		spin_lock_irqsave(&rq->lock, flags);


