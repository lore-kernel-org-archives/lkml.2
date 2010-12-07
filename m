Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab0LGKpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 05:45:14 -0500
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:37033 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab0LGKpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 05:45:12 -0500
Subject: Re: [patch v2 4/4] taskstats: Export "cdata_wait" CPU times with
 taskstats
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Oleg Nesterov <oleg@redhat.com>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20101201185128.GA7656@redhat.com>
References: <20101129164237.522034198@linux.vnet.ibm.com>
	 <20101129164435.903722027@linux.vnet.ibm.com>
	 <20101201185128.GA7656@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Tue, 07 Dec 2010 11:45:08 +0100
Message-ID: <1291718708.1910.63.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 19:51 +0100, Oleg Nesterov wrote:
> On 11/29, Michael Holzheu wrote:
> >
> > * I left the struct signal locking in the patch, because I think
> >   that in order to get consistent data this is necessary.
> 
> OK, I guess you mean that we want to read utime/stime "atomically",
> and thus we need ->siglock to prevent the race with __exit_signal().

Yes.

But I changed my mind. If I understand the code right, currently no
locking is done for reading the tasks statistics in both the taskstats
and also in the procfs interface. So e.g. it is not guaranteed to get a
consistent set of data when reading /proc/<pid>/stat, because of the
race with account_user/system/whatever_time() and other accounting
functions.

I assume that has been made by intention. Or am I missing something?

Because you said that since 2.6.35 accessing the signal_struct is save,
I think now also for cdata it is not necessary to lock anything. As a
result of this and the discussion regarding the group leader and cdata I
would propose the following patch:
---
Subject: taskstats: Export "cdata_wait" CPU times with taskstats

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Version 3
---------
* Remove signal struct locking because accessing signal_struct is save
  since 2.6.35.
* Report cdata for all tasks not only for the thread group leader.
  This is then the same behavior as for /proc/<tgid>/tasks/<tid>/stat.
* Add tgid to taskstats to allow userspace to group threads.

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
With this patch the cumulative CPU time and the tgid (thread group ID)
is added to "struct taskstats".

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 include/linux/taskstats.h |   10 +++++++++-
 kernel/tsacct.c           |    3 +++
 2 files changed, 12 insertions(+), 1 deletion(-)

--- a/include/linux/taskstats.h
+++ b/include/linux/taskstats.h
@@ -33,7 +33,7 @@
  */
 
 
-#define TASKSTATS_VERSION	7
+#define TASKSTATS_VERSION	8
 #define TS_COMM_LEN		32	/* should be >= TASK_COMM_LEN
 					 * in linux/sched.h */
 
@@ -163,6 +163,14 @@ struct taskstats {
 	/* Delay waiting for memory reclaim */
 	__u64	freepages_count;
 	__u64	freepages_delay_total;
+	/* version 7 ends here */
+
+	__u32	ac_tgid;		/* Thread group ID */
+
+	/* Cumulative CPU time of dead children */
+	__u64	ac_cutime;		/* User CPU time [usec] */
+	__u64	ac_cstime;		/* System CPU time [usec] */
+	/* version 8 ends here */
 };
 
 
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -71,6 +71,9 @@ void bacct_add_tsk(struct taskstats *sta
 	stats->ac_majflt = tsk->maj_flt;
 
 	strncpy(stats->ac_comm, tsk->comm, sizeof(stats->ac_comm));
+	stats->ac_cutime = cputime_to_usecs(tsk->signal->cdata_wait.utime);
+	stats->ac_cstime = cputime_to_usecs(tsk->signal->cdata_wait.stime);
+	stats->ac_tgid = tsk->tgid;
 }
 
 


