Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683Ab0IRTqD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:46:03 -0400
Received: from kroah.org ([198.145.64.141]:51586 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841Ab0IRTB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:58 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:59 2010
Message-Id: <20100918185959.052029509@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Subject: [073/123] sched: Use rcu in sys_sched_getscheduler/sys_sched_getparam()
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-use-rcu-in-sys_sched_getscheduler-sys_sched_getparam.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 5fe85be081edf0ac92d83f9c39e0ab5c1371eb82 upstream

read_lock(&tasklist_lock) does not protect
sys_sched_getscheduler and sys_sched_getparam() against a
concurrent update of the policy or scheduler parameters as
do_sched_setscheduler() does not take the tasklist_lock. The
accessed integers can be retrieved w/o locking and are snapshots
anyway.

Using rcu_read_lock() to protect find_task_by_vpid() and prevent
the task struct from going away is not changing the above
situation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20091209100706.753790977@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6505,7 +6505,7 @@ SYSCALL_DEFINE1(sched_getscheduler, pid_
 		return -EINVAL;
 
 	retval = -ESRCH;
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	p = find_process_by_pid(pid);
 	if (p) {
 		retval = security_task_getscheduler(p);
@@ -6513,7 +6513,7 @@ SYSCALL_DEFINE1(sched_getscheduler, pid_
 			retval = p->policy
 				| (p->sched_reset_on_fork ? SCHED_RESET_ON_FORK : 0);
 	}
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	return retval;
 }
 
@@ -6531,7 +6531,7 @@ SYSCALL_DEFINE2(sched_getparam, pid_t, p
 	if (!param || pid < 0)
 		return -EINVAL;
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	p = find_process_by_pid(pid);
 	retval = -ESRCH;
 	if (!p)
@@ -6542,7 +6542,7 @@ SYSCALL_DEFINE2(sched_getparam, pid_t, p
 		goto out_unlock;
 
 	lp.sched_priority = p->rt_priority;
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	/*
 	 * This one might sleep, we cannot do it with a spinlock held ...
@@ -6552,7 +6552,7 @@ SYSCALL_DEFINE2(sched_getparam, pid_t, p
 	return retval;
 
 out_unlock:
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	return retval;
 }
 


