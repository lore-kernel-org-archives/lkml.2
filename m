Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab1IZPKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 11:10:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33133 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab1IZPJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 11:09:48 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=vhdKIqpQuCYA:10 a=_gCGRZm9PMgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=2xwKcvEwBSQXABE6GbMA:9 a=hJ9Z0Kl06-7O9IlSrY8A:7 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110926150946.844914281@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 26 Sep 2011 11:08:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/3][RT] sched: Do not compare cpu masks in scheduler
References: <20110926150835.107371360@goodmis.org>
Content-Disposition: inline; filename=peterz-migrate-disable-no-cpu-compare.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Index: linux-rt.git/kernel/sched.c
===================================================================
--- linux-rt.git.orig/kernel/sched.c
+++ linux-rt.git/kernel/sched.c
@@ -4235,16 +4235,12 @@ static inline void update_migrate_disabl
 	 */
 	mask = tsk_cpus_allowed(p);
 
-	WARN_ON(!cpumask_test_cpu(smp_processor_id(), mask));
+	if (p->sched_class->set_cpus_allowed)
+		p->sched_class->set_cpus_allowed(p, mask);
+	p->rt.nr_cpus_allowed = cpumask_weight(mask);
 
-	if (!cpumask_equal(&p->cpus_allowed, mask)) {
-		if (p->sched_class->set_cpus_allowed)
-			p->sched_class->set_cpus_allowed(p, mask);
-		p->rt.nr_cpus_allowed = cpumask_weight(mask);
-
-		/* Let migrate_enable know to fix things back up */
-		p->migrate_disable |= MIGRATE_DISABLE_SET_AFFIN;
-	}
+	/* Let migrate_enable know to fix things back up */
+	p->migrate_disable |= MIGRATE_DISABLE_SET_AFFIN;
 }
 
 void migrate_disable(void)

