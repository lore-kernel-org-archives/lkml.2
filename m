Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176Ab0JAE0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 00:26:45 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53597 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750864Ab0JAE0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 00:26:44 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18kiLcllOMkJC0rfkqvq0hF/p6vfkASEZn/8SXIKv
	oXpwl+wdbKc2ly
Subject: [PATCH] fix 2.6.32.23 suspend regression caused by commit 6f6198a
From: Mike Galbraith <efault@gmx.de>
To: stable <stable@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 01 Oct 2010 06:27:16 +0200
Message-Id: <1285907236.7425.42.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings -stable/Greg,

Thoroughly tested scheduler fixes series was not so thoroughly tested
with suspend.. like at all (my nvidia card doesn't do the resume part).

Sorry about that.

	-Mike

From: Mike Galbraith <efault@gmx.de>
Date: Fri, 1 Oct 2010 05:57:59 +0200
Subject: [PATCH] fix 2.6.32.23 suspend regression caused by commit 6f6198a

6f6198a sched: kill migration thread in CPU_POST_DEAD instead of CPU_DEAD
leaves migration threads lying about.  Mask out CPU_TASKS_FROZEN.

Signed-off-by: Mike Galbraith <efault@gmx.de>
---
 kernel/sched.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3480822..a675fd6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7752,10 +7752,9 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	unsigned long flags;
 	struct rq *rq;
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		p = kthread_create(migration_thread, hcpu, "migration/%d", cpu);
 		if (IS_ERR(p))
 			return NOTIFY_BAD;
@@ -7770,7 +7769,6 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 		/* Strictly unnecessary, as first user will wake it. */
 		wake_up_process(cpu_rq(cpu)->migration_thread);
 
@@ -7787,7 +7785,6 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 		if (!cpu_rq(cpu)->migration_thread)
 			break;
 		/* Unbind it from offline cpu so it can run. Fall thru. */
@@ -7812,7 +7809,6 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		migrate_live_tasks(cpu);
 		rq = cpu_rq(cpu);
 		/* Idle task back to normal (off runqueue, low prio) */
@@ -7846,7 +7842,6 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 
 	case CPU_DYING:
-	case CPU_DYING_FROZEN:
 		/* Update our root-domain */
 		rq = cpu_rq(cpu);
 		spin_lock_irqsave(&rq->lock, flags);
-- 
1.7.1



