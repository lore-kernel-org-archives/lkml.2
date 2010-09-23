Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab0IWOCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:02:13 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:42924 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506Ab0IWOCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:02:10 -0400
Subject: [RFC][PATCH 08/10] taskstats: Add cumulative CPU time (user,
 system and steal)
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
Date: Thu, 23 Sep 2010 16:02:06 +0200
Message-ID: <1285250526.1837.92.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] taskstats: Add cumulative CPU time (user, system and steal)

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Add cumulative time of dead childs (user, system and steal) to taskstats.
This can be used by tools like top to monitor 100% CPU time for each sample
interval.

The following algorithm can be used:

* Collect snapshot 1 of all running tasks
* Wait interval
* Collect snapshot 2 of all running tasks

All consumed CPU time in the interval can be calculated as follows:

  snapshot 2 minus snapshot 1 of
  utime, stime, sttime, cutime, cstime and csttime CPU time counters
  of all tasks that are in snapshot 2

  minus

  utime, stime, sttime, cutime, cstime and csttime CPU time counters of all
  tasks that are in snapshot 1, but not in snapshot 2 (tasks that have been
  exited)

To provide a consistent view, the top tool could show the following fields:
 * user:  task utime per interval
 * sys:   task stime per interval
 * ste:   task sttime per interval
 * cuser: utime of exited children per interval
 * csys:  stime of exited children per interval
 * cste:  sttime of exited children per interval
 * total: Sum of all above fields

If the top command notices that a pid disappeared between snapshot 1
and snapshot 2, it has to find its parent and subtract the CPU times
from snapshot 1 of the dead child from the parents cumulative times.

Example:
--------
pid     user   sys  ste  cuser  csys cste  total  Name
(#)      (%)   (%)  (%)    (%)   (%)  (%)    (%)  (str)
17944   0.10  0.01 0.00  54.29 14.36 0.22  68.98  make
18006   0.10  0.01 0.00  55.79 12.23 0.12  68.26  make
18041  48.18  1.51 0.29   0.00  0.00 0.00  49.98  cc1
...

The sum of all "total" CPU counters on a system that is 100% busy should
be exactly the number CPUs multiplied by the interval time. A good tescase
for this is to start a loop program for each CPU and then in parallel
starting a kernel build with "-j 5".

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 include/linux/taskstats.h |    3 +++
 kernel/tsacct.c           |   11 ++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/include/linux/taskstats.h
+++ b/include/linux/taskstats.h
@@ -169,6 +169,9 @@ struct taskstats {
 	__u64	time_ns;
 	__u32	ac_tgid;		/* Thread group ID */
 	__u64	ac_sttime;		/* Steal CPU time [usec] */
+	__u64	ac_cutime;		/* User CPU time of childs [usec] */
+	__u64	ac_cstime;		/* System CPU time of childs [usec] */
+	__u64	ac_csttime;		/* Steal CPU time of childs [usec] */
 };
 
 
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -63,6 +63,15 @@ void bacct_add_tsk(struct taskstats *sta
 	stats->ac_gid	 = tcred->gid;
 	stats->ac_ppid	 = pid_alive(tsk) ?
 				rcu_dereference(tsk->real_parent)->tgid : 0;
+	if (tsk->signal) {
+		stats->ac_cutime = cputime_to_usecs(tsk->signal->cutime);
+		stats->ac_cstime = cputime_to_usecs(tsk->signal->cstime);
+		stats->ac_csttime = cputime_to_usecs(tsk->signal->csttime);
+	} else {
+		stats->ac_cutime = 0;
+		stats->ac_cstime = 0;
+		stats->ac_csttime = 0;
+	}
 	rcu_read_unlock();
 	stats->ac_utime = cputime_to_usecs(tsk->utime);
 	stats->ac_stime = cputime_to_usecs(tsk->stime);


