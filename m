Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1I0Mo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 08:44:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37591 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab1I0MoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 08:44:24 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=CIpzJuBU2_UA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=2xwKcvEwBSQXABE6GbMA:9 a=zKFWLLvH8xWLoE6ZwCsA:7 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110927124423.128129033@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 27 Sep 2011 08:40:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH v2 2/3][RT] sched: Do not compare cpu masks in scheduler
References: <20110927124022.484200394@goodmis.org>
Content-Disposition: inline; filename=peterz-migrate-disable-no-cpu-compare.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

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

