Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0KVMsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 07:48:01 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:53790 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab0KVMr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 07:47:59 -0500
Subject: Re: [patch 0/4] taskstats: Improve cumulative time accounting
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>, Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
In-Reply-To: <1290423780.1974.1.camel@holzheu-laptop>
References: <20101119201108.269346583@linux.vnet.ibm.com>
	 <1290197955.2109.1617.camel@laptop>
	 <1290423780.1974.1.camel@holzheu-laptop>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Mon, 22 Nov 2010 13:47:55 +0100
Message-ID: <1290430075.5655.3.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 12:03 +0100, Michael Holzheu wrote:
> Or maybe we could add a sysctl that allows to switch between the two
> semantics.

Then patch 03/04 would be something like the following:
---
Subject: taskstats: Introduce complete cumulative accounting

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Currently the cumulative time accounting in Linux is not complete.
Due to POSIX POSIX.1-2001, the CPU time of processes is not accounted
to the cumulative time of the parents, if the parents ignore SIGCHLD
or have set SA_NOCLDWAIT. This behaviour has the major drawback that
it is not possible to calculate all consumed CPU time of a system by
looking at the current tasks. CPU time can be lost.

This patch adds a new sysctl "kernel.full_cdata" that allows to switch
between the POSIX behavior and complete cumulative accounting.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 include/linux/sched.h |    1 +
 kernel/exit.c         |   12 ++++++++----
 kernel/sysctl.c       |    7 +++++++
 3 files changed, 16 insertions(+), 4 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1907,6 +1907,7 @@ enum sched_tunable_scaling {
 };
 extern enum sched_tunable_scaling sysctl_sched_tunable_scaling;
 
+extern unsigned int full_cdata_enabled;
 #ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -57,6 +57,8 @@
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 
+unsigned int full_cdata_enabled = 1;
+
 static void exit_mm(struct task_struct * tsk);
 
 static void __unhash_process(struct task_struct *p, bool group_dead)
@@ -77,7 +79,7 @@ static void __unhash_process(struct task
 static void __account_cdata(struct task_struct *p)
 {
 	struct cdata *cd, *pcd, *tcd;
-	unsigned long maxrss;
+	unsigned long maxrss, flags;
 	cputime_t tgutime, tgstime;
 
 	/*
@@ -100,7 +102,7 @@ static void __account_cdata(struct task_
 	 * group including the group leader.
 	 */
 	thread_group_times(p, &tgutime, &tgstime);
-	spin_lock_irq(&p->real_parent->sighand->siglock);
+	spin_lock_irqsave(&p->real_parent->sighand->siglock, flags);
 	pcd = &p->real_parent->signal->cdata_wait;
 	tcd = &p->signal->cdata_threads;
 	cd = &p->signal->cdata_wait;
@@ -137,7 +139,7 @@ static void __account_cdata(struct task_
 		pcd->maxrss = maxrss;
 	task_io_accounting_add(&p->real_parent->signal->ioac, &p->ioac);
 	task_io_accounting_add(&p->real_parent->signal->ioac, &p->signal->ioac);
-	spin_unlock_irq(&p->real_parent->sighand->siglock);
+	spin_unlock_irqrestore(&p->real_parent->sighand->siglock, flags);
 }
 
 /*
@@ -157,6 +159,8 @@ static void __exit_signal(struct task_st
 
 	posix_cpu_timers_exit(tsk);
 	if (group_dead) {
+		if (full_cdata_enabled)
+			__account_cdata(tsk);
 		posix_cpu_timers_exit_group(tsk);
 		tty = sig->tty;
 		sig->tty = NULL;
@@ -1292,7 +1296,7 @@ static int wait_task_zombie(struct wait_
 	 * It can be ptraced but not reparented, check
 	 * !task_detached() to filter out sub-threads.
 	 */
-	if (likely(!traced) && likely(!task_detached(p)))
+	if (likely(!traced) && likely(!task_detached(p)) && !full_cdata_enabled)
 		__account_cdata(p);
 
 	/*
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -963,6 +963,13 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+	{
+		.procname	= "full_cdata",
+		.data		= &full_cdata_enabled,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt


