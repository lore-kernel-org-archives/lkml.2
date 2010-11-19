Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab0KSULw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:11:52 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:60474 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab0KSULu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:11:50 -0500
Message-Id: <20101119201144.206992156@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 19 Nov 2010 21:11:10 +0100
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
Subject: [patch 2/4] taskstats: Introduce __account_cdata() function
References: <20101119201108.269346583@linux.vnet.ibm.com>
Content-Disposition: inline; filename=02-taskstats-top-improve-ctime-add_cdata-func.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

This patch introduces the function __account_cdata() that does the
cummulative resource accounting for dead processes in sys_wait().
No functional changes are done. This patch is a preparation for cdata_acct
accounting.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 kernel/exit.c |  133 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 68 insertions(+), 65 deletions(-)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -74,6 +74,72 @@ static void __unhash_process(struct task
 	list_del_rcu(&p->thread_group);
 }
 
+static void __account_cdata(struct task_struct *p)
+{
+	struct cdata *cd, *pcd, *tcd;
+	unsigned long maxrss;
+	cputime_t tgutime, tgstime;
+
+	/*
+	 * The resource counters for the group leader are in its
+	 * own task_struct.  Those for dead threads in the group
+	 * are in its signal_struct, as are those for the child
+	 * processes it has previously reaped.  All these
+	 * accumulate in the parent's signal_struct c* fields.
+	 *
+	 * We don't bother to take a lock here to protect these
+	 * p->signal fields, because they are only touched by
+	 * __exit_signal, which runs with tasklist_lock
+	 * write-locked anyway, and so is excluded here.  We do
+	 * need to protect the access to parent->signal fields,
+	 * as other threads in the parent group can be right
+	 * here reaping other children at the same time.
+	 *
+	 * We use thread_group_times() to get times for the thread
+	 * group, which consolidates times for all threads in the
+	 * group including the group leader.
+	 */
+	thread_group_times(p, &tgutime, &tgstime);
+	spin_lock_irq(&p->real_parent->sighand->siglock);
+	pcd = &p->real_parent->signal->cdata_wait;
+	tcd = &p->signal->cdata_threads;
+	cd = &p->signal->cdata_wait;
+
+	pcd->utime =
+		cputime_add(pcd->utime,
+		cputime_add(tgutime,
+			    cd->utime));
+	pcd->stime =
+		cputime_add(pcd->stime,
+		cputime_add(tgstime,
+			    cd->stime));
+	pcd->gtime =
+		cputime_add(pcd->gtime,
+		cputime_add(p->gtime,
+		cputime_add(tcd->gtime,
+			    cd->gtime)));
+	pcd->min_flt +=
+		p->min_flt + tcd->min_flt + cd->min_flt;
+	pcd->maj_flt +=
+		p->maj_flt + tcd->maj_flt + cd->maj_flt;
+	pcd->nvcsw +=
+		p->nvcsw + tcd->nvcsw + cd->nvcsw;
+	pcd->nivcsw +=
+		p->nivcsw + tcd->nivcsw + cd->nivcsw;
+	pcd->inblock +=
+		task_io_get_inblock(p) +
+		tcd->inblock + cd->inblock;
+	pcd->oublock +=
+		task_io_get_oublock(p) +
+		tcd->oublock + cd->oublock;
+	maxrss = max(tcd->maxrss, cd->maxrss);
+	if (pcd->maxrss < maxrss)
+		pcd->maxrss = maxrss;
+	task_io_accounting_add(&p->real_parent->signal->ioac, &p->ioac);
+	task_io_accounting_add(&p->real_parent->signal->ioac, &p->signal->ioac);
+	spin_unlock_irq(&p->real_parent->sighand->siglock);
+}
+
 /*
  * This function expects the tasklist_lock write-locked.
  */
@@ -1226,71 +1292,8 @@ static int wait_task_zombie(struct wait_
 	 * It can be ptraced but not reparented, check
 	 * !task_detached() to filter out sub-threads.
 	 */
-	if (likely(!traced) && likely(!task_detached(p))) {
-		struct cdata *cd, *pcd, *tcd;
-		unsigned long maxrss;
-		cputime_t tgutime, tgstime;
-
-		/*
-		 * The resource counters for the group leader are in its
-		 * own task_struct.  Those for dead threads in the group
-		 * are in its signal_struct, as are those for the child
-		 * processes it has previously reaped.  All these
-		 * accumulate in the parent's signal_struct c* fields.
-		 *
-		 * We don't bother to take a lock here to protect these
-		 * p->signal fields, because they are only touched by
-		 * __exit_signal, which runs with tasklist_lock
-		 * write-locked anyway, and so is excluded here.  We do
-		 * need to protect the access to parent->signal fields,
-		 * as other threads in the parent group can be right
-		 * here reaping other children at the same time.
-		 *
-		 * We use thread_group_times() to get times for the thread
-		 * group, which consolidates times for all threads in the
-		 * group including the group leader.
-		 */
-		thread_group_times(p, &tgutime, &tgstime);
-		spin_lock_irq(&p->real_parent->sighand->siglock);
-		pcd = &p->real_parent->signal->cdata_wait;
-		tcd = &p->signal->cdata_threads;
-		cd = &p->signal->cdata_wait;
-
-		pcd->utime =
-			cputime_add(pcd->utime,
-			cputime_add(tgutime,
-				    cd->utime));
-		pcd->stime =
-			cputime_add(pcd->stime,
-			cputime_add(tgstime,
-				    cd->stime));
-		pcd->gtime =
-			cputime_add(pcd->gtime,
-			cputime_add(p->gtime,
-			cputime_add(tcd->gtime,
-				    cd->gtime)));
-		pcd->min_flt +=
-			p->min_flt + tcd->min_flt + cd->min_flt;
-		pcd->maj_flt +=
-			p->maj_flt + tcd->maj_flt + cd->maj_flt;
-		pcd->nvcsw +=
-			p->nvcsw + tcd->nvcsw + cd->nvcsw;
-		pcd->nivcsw +=
-			p->nivcsw + tcd->nivcsw + cd->nivcsw;
-		pcd->inblock +=
-			task_io_get_inblock(p) +
-			tcd->inblock + cd->inblock;
-		pcd->oublock +=
-			task_io_get_oublock(p) +
-			tcd->oublock + cd->oublock;
-		maxrss = max(tcd->maxrss, cd->maxrss);
-		if (pcd->maxrss < maxrss)
-			pcd->maxrss = maxrss;
-		task_io_accounting_add(&p->real_parent->signal->ioac, &p->ioac);
-		task_io_accounting_add(&p->real_parent->signal->ioac,
-				       &p->signal->ioac);
-		spin_unlock_irq(&p->real_parent->sighand->siglock);
-	}
+	if (likely(!traced) && likely(!task_detached(p)))
+		__account_cdata(p);
 
 	/*
 	 * Now we are sure this task is interesting, and no other

