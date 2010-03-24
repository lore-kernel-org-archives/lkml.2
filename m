Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967Ab0CXUsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:48:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932948Ab0CXUsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:48:16 -0400
Date: Wed, 24 Mar 2010 21:45:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Balbir Singh <balbir@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Spencer Candland <spencer@bluehost.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC,PATCH 2/2] cputimers/proc:
	do_task_stat()->thread_group_times() is racy and O(n) under
	->siglock
Message-ID: <20100324204554.GA31780@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nowadays ->siglock is overloaded, it would be really nice to change
do_task_stat() to walk through the list of threads lockless. And note
that we are doing while_each_thread() twice!

while_each_thread() is rcu-safe, but thread_group_times() also needs
->siglock to serialize the modifications of signal_struct->prev_Xtime
members.

(however, please note that currently do_task_stat() can race with
 wait_task_zombie() which calls thread_group_times() without siglock).

This patch changes the code back to use thread_group_cputime(), as we
did before 0cf55e1e "sched, cputime: Introduce thread_group_times()".

Of course, this makes the output from /proc/pid/stat less accurate, but
otoh this allows us to make do_task_stat() (apart from ->tty bits).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 fs/proc/array.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- 34-rc1/fs/proc/array.c~PROC_5_DTS_TGTS_IS_PITA	2010-03-24 20:47:19.000000000 +0100
+++ 34-rc1/fs/proc/array.c	2010-03-24 20:47:51.000000000 +0100
@@ -403,6 +403,7 @@ static int do_task_stat(struct seq_file 
 
 	if (lock_task_sighand(task, &flags)) {
 		struct signal_struct *sig = task->signal;
+		struct task_cputime cputime;
 
 		if (sig->tty) {
 			struct pid *pgrp = tty_get_pgrp(sig->tty);
@@ -433,8 +434,11 @@ static int do_task_stat(struct seq_file 
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-			thread_group_times(task, &utime, &stime);
+
 			gtime = cputime_add(gtime, sig->gtime);
+			thread_group_cputime(task, &cputime);
+			utime = cputime.utime;
+			stime = cputime.stime;
 		}
 
 		sid = task_session_nr_ns(task, ns);

