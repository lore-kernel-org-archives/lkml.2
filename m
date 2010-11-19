Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab0KSUMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:12:35 -0500
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:35105 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab0KSULr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:11:47 -0500
Message-Id: <20101119201144.542948128@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 19 Nov 2010 21:11:11 +0100
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>, Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 3/4] taskstats: Introduce cdata_acct for complete cumulative accounting
References: <20101119201108.269346583@linux.vnet.ibm.com>
Content-Disposition: inline; filename=03-taskstats-top-improve-ctime-account-cdata_acct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Currently the cumulative time accounting in Linux is not complete.
Due to POSIX POSIX.1-2001, the CPU time of processes is not accounted
to the cumulative time of the parents, if the parents ignore SIGCHLD
or have set SA_NOCLDWAIT. This behaviour has the major drawback that
it is not possible to calculate all consumed CPU time of a system by
looking at the current tasks. CPU time can be lost.

This patch adds a new set of cumulative time counters. We then have two
cumulative counter sets:

* cdata_wait: Traditional cumulative time used e.g. by getrusage.
* cdata_acct: Cumulative time that also includes dead processes with
              parents that ignore SIGCHLD or have set SA_NOCLDWAIT.
              cdata_acct will be exported by taskstats.

TODO:
-----
With this patch we take the siglock twice. First for the dead task
and second for the parent of the dead task. This give the following
lockdep warning (probably a lockdep annotation is needed here):
=============================================
[ INFO: possible recursive locking detected ]
2.6.37-rc1-00116-g151f52f-dirty #19
---------------------------------------------
kworker/u:0/15 is trying to acquire lock:
 (&(&sighand->siglock)->rlock){......}, at: [<000000000014a426>] __account_cdata+0x6e/0x444
but task is already holding lock:
 (&(&sighand->siglock)->rlock){......}, at: [<000000000014b634>] release_task+0x160/0x6a0

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 include/linux/sched.h |    2 ++
 kernel/exit.c         |   36 +++++++++++++++++++++++++-----------
 2 files changed, 27 insertions(+), 11 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -595,6 +595,8 @@ struct signal_struct {
 	 */
 	struct cdata cdata_wait;
 	struct cdata cdata_threads;
+	struct cdata cdata_acct;
+	struct task_io_accounting ioac_acct;
 	struct task_io_accounting ioac;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	cputime_t prev_utime, prev_stime;
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -74,10 +74,10 @@ static void __unhash_process(struct task
 	list_del_rcu(&p->thread_group);
 }
 
-static void __account_cdata(struct task_struct *p)
+static void __account_cdata(struct task_struct *p, int wait)
 {
 	struct cdata *cd, *pcd, *tcd;
-	unsigned long maxrss;
+	unsigned long maxrss, flags;
 	cputime_t tgutime, tgstime;
 
 	/*
@@ -100,11 +100,16 @@ static void __account_cdata(struct task_
 	 * group including the group leader.
 	 */
 	thread_group_times(p, &tgutime, &tgstime);
-	spin_lock_irq(&p->real_parent->sighand->siglock);
-	pcd = &p->real_parent->signal->cdata_wait;
-	tcd = &p->signal->cdata_threads;
-	cd = &p->signal->cdata_wait;
-
+	spin_lock_irqsave(&p->real_parent->sighand->siglock, flags);
+	if (wait) {
+		pcd = &p->real_parent->signal->cdata_wait;
+		tcd = &p->signal->cdata_threads;
+		cd = &p->signal->cdata_wait;
+	} else {
+		pcd = &p->real_parent->signal->cdata_acct;
+		tcd = &p->signal->cdata_threads;
+		cd = &p->signal->cdata_acct;
+	}
 	pcd->utime =
 		cputime_add(pcd->utime,
 		cputime_add(tgutime,
@@ -135,9 +140,17 @@ static void __account_cdata(struct task_
 	maxrss = max(tcd->maxrss, cd->maxrss);
 	if (pcd->maxrss < maxrss)
 		pcd->maxrss = maxrss;
-	task_io_accounting_add(&p->real_parent->signal->ioac, &p->ioac);
-	task_io_accounting_add(&p->real_parent->signal->ioac, &p->signal->ioac);
-	spin_unlock_irq(&p->real_parent->sighand->siglock);
+	if (wait) {
+		task_io_accounting_add(&p->real_parent->signal->ioac, &p->ioac);
+		task_io_accounting_add(&p->real_parent->signal->ioac,
+				       &p->signal->ioac);
+	} else {
+		task_io_accounting_add(&p->real_parent->signal->ioac_acct,
+				       &p->ioac);
+		task_io_accounting_add(&p->real_parent->signal->ioac_acct,
+				       &p->signal->ioac_acct);
+	}
+	spin_unlock_irqrestore(&p->real_parent->sighand->siglock, flags);
 }
 
 /*
@@ -157,6 +170,7 @@ static void __exit_signal(struct task_st
 
 	posix_cpu_timers_exit(tsk);
 	if (group_dead) {
+		__account_cdata(tsk, 0);
 		posix_cpu_timers_exit_group(tsk);
 		tty = sig->tty;
 		sig->tty = NULL;
@@ -1293,7 +1307,7 @@ static int wait_task_zombie(struct wait_
 	 * !task_detached() to filter out sub-threads.
 	 */
 	if (likely(!traced) && likely(!task_detached(p)))
-		__account_cdata(p);
+		__account_cdata(p, 1);
 
 	/*
 	 * Now we are sure this task is interesting, and no other

