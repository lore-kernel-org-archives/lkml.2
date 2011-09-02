Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1IBMls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 08:41:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55084 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab1IBMlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 08:41:44 -0400
Subject: [PATCH -rt] sched: teach migrate_disable about atomic contexts
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 02 Sep 2011 14:41:37 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314967297.1301.14.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: teach migrate_disable about atomic contexts
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri Sep 02 14:29:27 CEST 2011

 <NMI>  [<ffffffff812dafd8>] spin_bug+0x94/0xa8
 [<ffffffff812db07f>] do_raw_spin_lock+0x43/0xea
 [<ffffffff814fa9be>] _raw_spin_lock_irqsave+0x6b/0x85
 [<ffffffff8106ff9e>] ? migrate_disable+0x75/0x12d
 [<ffffffff81078aaf>] ? pin_current_cpu+0x36/0xb0
 [<ffffffff8106ff9e>] migrate_disable+0x75/0x12d
 [<ffffffff81115b9d>] pagefault_disable+0xe/0x1f
 [<ffffffff81047027>] copy_from_user_nmi+0x74/0xe6
 [<ffffffff810489d7>] perf_callchain_user+0xf3/0x135

Now clearly we can't go around taking locks from NMI context, cure
this by short-circuiting migrate_disable() when we're in an atomic
context already.

Add some extra debugging to avoid things like:

  preempt_disable()
  migrate_disable();

  preempt_enable();
  migrate_enable();

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-wbot4vsmwhi8vmbf83hsclk6@git.kernel.org
---
 include/linux/sched.h |    3 +++
 kernel/sched.c        |   21 +++++++++++++++++++++
 2 files changed, 24 insertions(+)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6135,6 +6135,17 @@ void migrate_disable(void)
 	unsigned long flags;
 	struct rq *rq;
 
+	if (in_atomic()) {
+#ifdef CONFIG_SCHED_DEBUG
+		p->migrate_disable_atomic++;
+#endif
+		return;
+	}
+
+#ifdef CONFIG_SCHED_DEBUG
+	WARN_ON_ONCE(p->migrate_disable_atomic);
+#endif
+
 	preempt_disable();
 	if (p->migrate_disable) {
 		p->migrate_disable++;
@@ -6183,6 +6194,16 @@ void migrate_enable(void)
 	unsigned long flags;
 	struct rq *rq;
 
+	if (in_atomic()) {
+#ifdef CONFIG_SCHED_DEBUG
+		p->migrate_disable_atomic--;
+#endif
+		return;
+	}
+
+#ifdef CONFIG_SCHED_DEBUG
+	WARN_ON_ONCE(p->migrate_disable_atomic);
+#endif
 	WARN_ON_ONCE(p->migrate_disable <= 0);
 
 	preempt_disable();
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1264,6 +1264,9 @@ struct task_struct {
 	unsigned int policy;
 #ifdef CONFIG_PREEMPT_RT_FULL
 	int migrate_disable;
+#ifdef CONFIG_SCHED_DEBUG
+	int migrate_disable_atomic;
+#endif
 #endif
 	cpumask_t cpus_allowed;
 

