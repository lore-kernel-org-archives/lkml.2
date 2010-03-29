Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0C2SRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:17:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab0C2SRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:17:00 -0400
Date: Mon, 29 Mar 2010 20:14:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Spencer Candland <spencer@bluehost.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 1/4] cputimers: do_task_stat: avoid ->siglock for
	while_each_thread()
Message-ID: <20100329181432.GE16356@redhat.com>
References: <20100324204550.GA31777@redhat.com> <20100326035344.GQ3308@balbir.in.ibm.com> <20100326214906.GA18467@redhat.com> <20100329111731.GA4488@dhcp-lab-161.englab.brq.redhat.com> <20100329125415.GA22451@redhat.com> <20100329181204.GA16356@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329181204.GA16356@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change do_task_stat() to walk through the ->thread_group list without
->siglock, we are doing while_each_thread() twice even if the "whole"
info is not necessarily needed, say, for /bin/ps.

We can rely on previous changes which made thread_group_times() rcu-
safe and move the "if (whole)" code from ->siglock to rcu_read_lock().

Note: do_task_stat() needs more cleanups, this series only cares about
thread_group_times() issues.

This is a user visible change. Without ->siglock we can't get the "whole"
info atomically, and if we race with exit() we can miss the exiting thread.

However, I hope this is OK for /bin/top. The next read from /proc/pid/stat
will see the updated info, we can never overestimate the reported numbers,
and they can never go back.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 fs/proc/array.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- 34-rc1/fs/proc/array.c~cpuacct_4_do_task_stat_walk_tg_under_rcu	2010-03-29 19:44:24.000000000 +0200
+++ 34-rc1/fs/proc/array.c	2010-03-29 19:47:03.000000000 +0200
@@ -421,8 +421,14 @@ static int do_task_stat(struct seq_file 
 		cgtime = sig->cgtime;
 		rsslim = ACCESS_ONCE(sig->rlim[RLIMIT_RSS].rlim_cur);
 
+		sid = task_session_nr_ns(task, ns);
+		ppid = task_tgid_nr_ns(task->real_parent, ns);
+		pgid = task_pgrp_nr_ns(task, ns);
+		unlock_task_sighand(task, &flags);
+
 		/* add up live thread stats at the group level */
-		if (whole) {
+		rcu_read_lock();
+		if (whole && pid_alive(task)) {
 			struct task_struct *t = task;
 			do {
 				min_flt += t->min_flt;
@@ -433,15 +439,11 @@ static int do_task_stat(struct seq_file 
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-			thread_group_times(task, &utime, &stime);
 			gtime = cputime_add(gtime, sig->gtime);
-		}
-
-		sid = task_session_nr_ns(task, ns);
-		ppid = task_tgid_nr_ns(task->real_parent, ns);
-		pgid = task_pgrp_nr_ns(task, ns);
 
-		unlock_task_sighand(task, &flags);
+			thread_group_times(task, &utime, &stime);
+		}
+		rcu_read_unlock();
 	}
 
 	if (permitted && (!whole || num_threads < 2))

