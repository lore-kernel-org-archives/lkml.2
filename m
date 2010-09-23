Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab0IWOC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:02:27 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:42975 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab0IWOCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:02:25 -0400
Subject: [RFC][PATCH 09/10] taskstats: Fix exit CPU time accounting
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1285249681.1837.28.camel@holzheu-laptop>
References: <1285249681.1837.28.camel@holzheu-laptop>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Thu, 23 Sep 2010 16:02:21 +0200
Message-ID: <1285250541.1837.95.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] taskstats: Fix exit CPU time accounting

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Currently there are code pathes (e.g. for kthreads) where the consumed
CPU time is not accounted to the parents cumulative counters.
Now CPU time is accounted to the parent, if the exit accounting has not
been done correctly.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 include/linux/sched.h |    1 +
 kernel/exit.c         |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

Index: git-linux-2.6/include/linux/sched.h
===================================================================
--- git-linux-2.6.orig/include/linux/sched.h	2010-09-23 14:16:37.000000000 +0200
+++ git-linux-2.6/include/linux/sched.h	2010-09-23 14:17:20.000000000 +0200
@@ -1282,6 +1282,7 @@
 	cputime_t prev_utime, prev_stime, prev_sttime;
 #endif
 	unsigned long long acct_time;		/* Time for last accounting */
+	int exit_accounting_done;
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time; 		/* monotonic time */
 	struct timespec real_start_time;	/* boot based time */
Index: git-linux-2.6/kernel/exit.c
===================================================================
--- git-linux-2.6.orig/kernel/exit.c	2010-09-23 14:16:37.000000000 +0200
+++ git-linux-2.6/kernel/exit.c	2010-09-23 14:17:20.000000000 +0200
@@ -157,11 +157,45 @@
 	put_task_struct(tsk);
 }
 
+static void account_to_parent(struct task_struct *p)
+{
+	struct signal_struct *psig, *sig;
+	struct task_struct *tsk_parent;
+
+	read_lock(&tasklist_lock);
+	tsk_parent = p->real_parent;
+	if (!tsk_parent) {
+		read_unlock(&tasklist_lock);
+		return;
+	}
+	get_task_struct(tsk_parent);
+	read_unlock(&tasklist_lock);
+
+	// printk("XXX Fix accounting: pid=%d ppid=%d\n", p->pid, tsk_parent->pid);
+	spin_lock_irq(&tsk_parent->sighand->siglock);
+	psig = tsk_parent->signal;
+	sig = p->signal;
+	psig->cutime = cputime_add(psig->cutime,
+				   cputime_add(sig->cutime, p->utime));
+	psig->cstime = cputime_add(psig->cstime,
+				   cputime_add(sig->cstime, p->stime));
+	psig->csttime = cputime_add(psig->csttime,
+				    cputime_add(sig->csttime, p->sttime));
+	psig->cgtime = cputime_add(psig->cgtime,
+		       cputime_add(p->gtime,
+		       cputime_add(sig->gtime, sig->cgtime)));
+	p->exit_accounting_done = 1;
+	spin_unlock_irq(&tsk_parent->sighand->siglock);
+	put_task_struct(tsk_parent);
+}
 
 void release_task(struct task_struct * p)
 {
 	struct task_struct *leader;
 	int zap_leader;
+
+	if (!p->exit_accounting_done)
+		account_to_parent(p);
 repeat:
 	tracehook_prepare_release_task(p);
 	/* don't need to get the RCU readlock here - the process is dead and
@@ -1279,6 +1313,7 @@
 			psig->cmaxrss = maxrss;
 		task_io_accounting_add(&psig->ioac, &p->ioac);
 		task_io_accounting_add(&psig->ioac, &sig->ioac);
+		p->exit_accounting_done = 1;
 		spin_unlock_irq(&p->real_parent->sighand->siglock);
 	}
 


