Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670Ab0IRTpY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:45:24 -0400
Received: from kroah.org ([198.145.64.141]:51600 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862Ab0IRTB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:59 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:59 2010
Message-Id: <20100918185959.231710721@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Subject: [075/123] sched: Use rcu in sched_get_rr_param()
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-use-rcu-in-sched_get_rr_param.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 1a551ae715825bb2a2107a2dd68de024a1fa4e32 upstream

read_lock(&tasklist_lock) does not protect
sys_sched_get_rr_param() against a concurrent update of the
policy or scheduler parameters as do_sched_scheduler() does not
take the tasklist_lock.

The access to task->sched_class->get_rr_interval is protected by
task_rq_lock(task).

Use rcu_read_lock() to protect find_task_by_vpid() and prevent
the task struct from going away.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20091209100706.862897167@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6924,7 +6924,7 @@ SYSCALL_DEFINE2(sched_rr_get_interval, p
 		return -EINVAL;
 
 	retval = -ESRCH;
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	p = find_process_by_pid(pid);
 	if (!p)
 		goto out_unlock;
@@ -6937,13 +6937,13 @@ SYSCALL_DEFINE2(sched_rr_get_interval, p
 	time_slice = p->sched_class->get_rr_interval(rq, p);
 	task_rq_unlock(rq, &flags);
 
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	jiffies_to_timespec(time_slice, &t);
 	retval = copy_to_user(interval, &t, sizeof(t)) ? -EFAULT : 0;
 	return retval;
 
 out_unlock:
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	return retval;
 }
 


