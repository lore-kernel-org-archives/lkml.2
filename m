Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab0C2SQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:16:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317Ab0C2SQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:16:24 -0400
Date: Mon, 29 Mar 2010 20:13:59 +0200
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
Subject: [PATCH -mm 3/4] cputimers: thread_group_times: make it rcu-safe
Message-ID: <20100329181359.GD16356@redhat.com>
References: <20100324204550.GA31777@redhat.com> <20100326035344.GQ3308@balbir.in.ibm.com> <20100326214906.GA18467@redhat.com> <20100329111731.GA4488@dhcp-lab-161.englab.brq.redhat.com> <20100329125415.GA22451@redhat.com> <20100329181204.GA16356@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329181204.GA16356@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thread_group_times() relies on ->siglock hold by the caller when it
updates sig->prev_Xtime members. Change the code to take cputimer.lock
around the assignment.

This makes it rcu-safe and fixes the theoretical race. wait_task_zombie()
calls it lockless and thus can race with do_task_stat().

Note: we are taking cputimer.lock under ->siglock but this dependency
is not new, thread_group_cputimer() already does this.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/sched.c |    3 +++
 1 file changed, 3 insertions(+)

--- 34-rc1/kernel/sched.c~cpuacct_3_thread_group_times_dont_rely_on_siglock	2010-03-29 19:44:25.000000000 +0200
+++ 34-rc1/kernel/sched.c	2010-03-29 19:46:21.000000000 +0200
@@ -3449,6 +3449,7 @@ void thread_group_times(struct task_stru
 	struct signal_struct *sig = p->signal;
 	struct task_cputime cputime;
 	cputime_t rtime, utime, total;
+	unsigned long flags;
 
 	thread_group_cputime(p, &cputime);
 
@@ -3464,9 +3465,11 @@ void thread_group_times(struct task_stru
 	} else
 		utime = rtime;
 
+	spin_lock_irqsave(&sig->cputimer.lock, flags);
 	sig->prev_utime = max(sig->prev_utime, utime);
 	sig->prev_stime = max(sig->prev_stime,
 			      cputime_sub(rtime, sig->prev_utime));
+	spin_unlock_irqrestore(&sig->cputimer.lock, flags);
 
 	*ut = sig->prev_utime;
 	*st = sig->prev_stime;

