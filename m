Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab1I2O5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:57:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43427 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab1I2O5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:57:24 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=cu7aa_lovUIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=meVymXHHAAAA:8 a=PgKtdZRyRZx6PLchiAUA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: [PATCH][RT] Fix warning about bounded threads migrating
From: Steven Rostedt <rostedt@goodmis.org>
To: Clark Williams <clark@redhat.com>
Cc: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu, 29 Sep 2011 10:57:21 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317308242.4588.21.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clark can you add this patch. You can fold it into the first one if you
want.

The warning for the PF_THREAD_BOUND migrating was causing false reports
because a task that is created on one CPU and bound to another CPU with
kthread_bind() may migrate on wakeup triggering this message. There is
nothing wrong with the use of migrating a thread that was recently
created.

Instead, only warn if the weight of the task's cpus_allowed is greater
than one. That is a clear warning that someone is abusing the
PF_THREAD_BOUND flag.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-mrg.git/kernel/sched.c
===================================================================
--- linux-mrg.git.orig/kernel/sched.c
+++ linux-mrg.git/kernel/sched.c
@@ -2246,9 +2246,11 @@ void set_task_cpu(struct task_struct *p,
 	if (task_cpu(p) != new_cpu) {
 		p->se.nr_migrations++;
 		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
-		if (WARN_ON(p->flags & PF_THREAD_BOUND))
-			printk(KERN_WARNING "migrating bounded task %s:%d\n",
-			       p->comm, p->pid);
+		if (WARN(p->flags & PF_THREAD_BOUND &&
+			 cpumask_weight(tsk_cpus_allowed(p)) > 1,
+			 "migrating bounded task %s:%d\n",
+			 p->comm, p->pid))
+			return;
 	}
 
 	__set_task_cpu(p, new_cpu);


