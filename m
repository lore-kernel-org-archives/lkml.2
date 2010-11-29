Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab0K2Qou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:44:50 -0500
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:39607 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab0K2Qom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:44:42 -0500
Message-Id: <20101129164435.903722027@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Mon, 29 Nov 2010 17:42:41 +0100
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
Subject: [patch v2 4/4] taskstats: Export "cdata_wait" CPU times with taskstats
References: <20101129164237.522034198@linux.vnet.ibm.com>
Content-Disposition: inline; filename=04-taskstats-top-improve-ctime-taskstats.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Version 2
---------
* Use thread_group_leader() instead of (tsk->pid == tsk->tgid)
* Use cdata_wait instead of cdata_acct
* I left the struct signal locking in the patch, because I think
  that in order to get consistent data this is necessary. See also
  do_task_stat() in fs/proc/array.c. One problem is that we
  report wrong values (zero) for cdata, if lock_task_sighand()
  fails. This will be the same behavior as for /proc/<pid>/stat.
  But maybe we should somehow return to userspace that the
  information is not correct. Any ideas?

Description
-----------
With this patch the cumulative CPU time is added to "struct taskstats".
The CPU time is only returned for the thread group leader.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 include/linux/taskstats.h |    7 ++++++-
 kernel/tsacct.c           |    7 +++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/include/linux/taskstats.h
+++ b/include/linux/taskstats.h
@@ -33,7 +33,7 @@
  */
 
 
-#define TASKSTATS_VERSION	7
+#define TASKSTATS_VERSION	8
 #define TS_COMM_LEN		32	/* should be >= TASK_COMM_LEN
 					 * in linux/sched.h */
 
@@ -163,6 +163,11 @@ struct taskstats {
 	/* Delay waiting for memory reclaim */
 	__u64	freepages_count;
 	__u64	freepages_delay_total;
+	/* version 7 ends here */
+
+	/* Cumulative CPU time of dead children */
+	__u64	ac_cutime;		/* User CPU time [usec] */
+	__u64	ac_cstime;		/* System CPU time [usec] */
 };
 
 
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -30,6 +30,7 @@ void bacct_add_tsk(struct taskstats *sta
 {
 	const struct cred *tcred;
 	struct timespec uptime, ts;
+	unsigned long flags;
 	u64 ac_etime;
 
 	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
@@ -71,6 +72,12 @@ void bacct_add_tsk(struct taskstats *sta
 	stats->ac_majflt = tsk->maj_flt;
 
 	strncpy(stats->ac_comm, tsk->comm, sizeof(stats->ac_comm));
+	if (thread_group_leader(tsk) && lock_task_sighand(tsk, &flags)) {
+		struct cdata *cd = &tsk->signal->cdata_wait;
+		stats->ac_cutime = cputime_to_usecs(cd->utime);
+		stats->ac_cstime = cputime_to_usecs(cd->stime);
+		unlock_task_sighand(tsk, &flags);
+	}
 }
 
 

