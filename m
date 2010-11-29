Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab0K2Qoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:44:46 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:58236 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129Ab0K2Qon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:44:43 -0500
Message-Id: <20101129164435.557525646@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Mon, 29 Nov 2010 17:42:40 +0100
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>, Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch v2 3/4] taskstats: Introduce kernel.full_cdata sysctl
References: <20101129164237.522034198@linux.vnet.ibm.com>
Content-Disposition: inline; filename=03-taskstats-top-improve-ctime-account-cdata_acct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Version 2
---------
* Implement sysctl instead of adding parallel cdata_acct
* Call __account_cdata() in __exit_signal() without tsk siglock

Description
-----------
Currently the cumulative time accounting in Linux is not complete.
Due to POSIX POSIX.1-2001, the CPU time of processes is not accounted
to the cumulative time of the parents, if the parents ignore SIGCHLD
or have set SA_NOCLDWAIT. This behaviour has the major drawback that
it is not possible to calculate all consumed CPU time of a system by
looking at the current tasks. CPU time can be lost.

This patch adds a new sysctl "kernel.full_cdata" that allows to switch
between the POSIX behavior and complete cumulative accounting.
The default is the POSIX semantics.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 Documentation/sysctl/kernel.txt |   12 ++++++++++++
 kernel/exit.c                   |   13 +++++++++----
 kernel/sysctl.c                 |   10 ++++++++++
 3 files changed, 31 insertions(+), 4 deletions(-)

--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -247,6 +247,18 @@ see the hostname(1) man page.
 
 ==============================================================
 
+full_cdata:
+
+With "full_cdata = 0" (default) cumulative resource accounting
+under Linux is done according to POSIX.1-2001: The resource
+counters of processes are not accounted to the cumulative counters
+of their parents, if the parents ignore SIGCHLD or have set
+SA_NOCLDWAIT. With "full_cdata = 1" it is possible to enforce
+that all dead processes without exception are accounted to their
+parents.
+
+==============================================================
+
 hotplug:
 
 Path for the hotplug policy agent.
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -57,6 +57,8 @@
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 
+int full_cdata_enabled;
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
@@ -104,7 +106,7 @@ static void __account_cdata(struct task_
 	tcd = &p->signal->cdata_threads;
 	cd = &p->signal->cdata_wait;
 
-	spin_lock_irq(&p->real_parent->sighand->siglock);
+	spin_lock_irqsave(&p->real_parent->sighand->siglock, flags);
 	pcd->utime =
 		cputime_add(pcd->utime,
 		cputime_add(tgutime,
@@ -137,7 +139,7 @@ static void __account_cdata(struct task_
 		pcd->maxrss = maxrss;
 	task_io_accounting_add(&p->real_parent->signal->ioac, &p->ioac);
 	task_io_accounting_add(&p->real_parent->signal->ioac, &p->signal->ioac);
-	spin_unlock_irq(&p->real_parent->sighand->siglock);
+	spin_unlock_irqrestore(&p->real_parent->sighand->siglock, flags);
 }
 
 /*
@@ -150,6 +152,9 @@ static void __exit_signal(struct task_st
 	struct sighand_struct *sighand;
 	struct tty_struct *uninitialized_var(tty);
 
+	if (group_dead && full_cdata_enabled)
+		__account_cdata(tsk);
+
 	sighand = rcu_dereference_check(tsk->sighand,
 					rcu_read_lock_held() ||
 					lockdep_tasklist_lock_is_held());
@@ -1292,7 +1297,7 @@ static int wait_task_zombie(struct wait_
 	 * It can be ptraced but not reparented, check
 	 * !task_detached() to filter out sub-threads.
 	 */
-	if (likely(!traced) && likely(!task_detached(p)))
+	if (likely(!traced) && likely(!task_detached(p)) && !full_cdata_enabled)
 		__account_cdata(p);
 
 	/*
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -85,6 +85,7 @@
 #if defined(CONFIG_SYSCTL)
 
 /* External variables not in a header file. */
+extern int full_cdata_enabled;
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern int max_threads;
@@ -963,6 +964,15 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+	{
+		.procname	= "full_cdata",
+		.data		= &full_cdata_enabled,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt

