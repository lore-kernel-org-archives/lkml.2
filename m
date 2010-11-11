Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab0KKRI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:08:57 -0500
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:53042 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab0KKRIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:08:20 -0500
Message-Id: <20101111170815.808518393@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Thu, 11 Nov 2010 18:03:58 +0100
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [RFC][PATCH v2 6/7] taskstats: Fix accounting for non-leader thread exec
References: <20101111170352.732381138@linux.vnet.ibm.com>
Content-Disposition: inline; filename=06-taskstats-top-fix-exec.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

If a non-leader thread calls exec(), in the de_thread() function it
gets some of the identity of the old thread group leader e.g. the PID
and the start time. But it keeps the old CPU times. This may lead to
confusion in user space, because CPU time can go backwards for the
thread group leader. For example the top command shows the following
for that test case:

# top -H
  PID USER  PR  NI  VIRT  RES  SHR S    %CPU      %MEM  TIME+   COMMAND  
17278 root  20   0 84128  664  500 R  >>9999.0<<  0.0  0:02.75 pthread_exec

To fix this problem, this patch exchanges the accounting data between the
exec() calling thread an the thread group leader in de_thread().
One problem with this patch could be that the scheduler might get confused
by the CPU time change.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 fs/exec.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -844,16 +844,32 @@ static int de_thread(struct task_struct
 
 		/*
 		 * The only record we have of the real-time age of a
-		 * process, regardless of execs it's done, is start_time.
+		 * process, regardless of execs it's done, is start_time
+		 * and the accounting data.
 		 * All the past CPU time is accumulated in signal_struct
 		 * from sister threads now dead.  But in this non-leader
 		 * exec, nothing survives from the original leader thread,
 		 * whose birth marks the true age of this process now.
 		 * When we take on its identity by switching to its PID, we
-		 * also take its birthdate (always earlier than our own).
+		 * also take its birthdate (always earlier than our own)
+		 * and the accounting data.
 		 */
 		tsk->start_time = leader->start_time;
-
+		swap(tsk->nvcsw, leader->nvcsw);
+		swap(tsk->nivcsw, leader->nivcsw);
+		swap(tsk->min_flt, leader->min_flt);
+		swap(tsk->ioac, leader->ioac);
+		swap(tsk->utime, leader->utime);
+		swap(tsk->stime, leader->stime);
+		swap(tsk->gtime, leader->gtime);
+		swap(tsk->sttime, leader->sttime);
+		swap(tsk->acct_time, leader->acct_time);
+		swap(tsk->real_start_time, leader->real_start_time);
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+		swap(tsk->prev_utime, leader->prev_utime);
+		swap(tsk->prev_stime, leader->prev_stime);
+		swap(tsk->prev_sttime, leader->prev_sttime);
+#endif
 		BUG_ON(!same_thread_group(leader, tsk));
 		BUG_ON(has_group_leader_pid(tsk));
 		/*

