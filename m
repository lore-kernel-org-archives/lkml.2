Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab0KSULx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:11:53 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:48206 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab0KSULu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:11:50 -0500
Message-Id: <20101119201144.871656307@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 19 Nov 2010 21:11:12 +0100
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
Subject: [patch 4/4] taskstats: Export "cdata_acct" with taskstats
References: <20101119201108.269346583@linux.vnet.ibm.com>
Content-Disposition: inline; filename=04-taskstats-top-improve-ctime-taskstats.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

With this patch the (full) cumulative CPU time is added to "struct taskstats".
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
+	/* All cumulative CPU time of dead children */
+	__u64	ac_cutime_acct;		/* User CPU time [usec] */
+	__u64	ac_cstime_acct;		/* System CPU time [usec] */
 };
 
 
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -31,6 +31,7 @@ void bacct_add_tsk(struct taskstats *sta
 	const struct cred *tcred;
 	struct timespec uptime, ts;
 	u64 ac_etime;
+	unsigned long flags;
 
 	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
 
@@ -71,6 +72,12 @@ void bacct_add_tsk(struct taskstats *sta
 	stats->ac_majflt = tsk->maj_flt;
 
 	strncpy(stats->ac_comm, tsk->comm, sizeof(stats->ac_comm));
+	if (tsk->tgid == tsk->pid && lock_task_sighand(tsk, &flags)) {
+		struct cdata *cd = &tsk->signal->cdata_acct;
+		stats->ac_cutime_acct = cputime_to_usecs(cd->utime);
+		stats->ac_cstime_acct = cputime_to_usecs(cd->stime);
+		unlock_task_sighand(tsk, &flags);
+	}
 }
 
 

