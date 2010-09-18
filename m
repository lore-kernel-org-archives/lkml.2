Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab0IRTpt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:45:49 -0400
Received: from kroah.org ([198.145.64.141]:51598 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474Ab0IRTB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:59 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:59 2010
Message-Id: <20100918185959.142903861@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Subject: [074/123] sched: Use rcu in sched_get/set_affinity()
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-use-rcu-in-sched_get-set_affinity.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 23f5d142519621b16cf2b378cf8adf4dcf01a616 upstream

tasklist_lock is held read locked to protect the
find_task_by_vpid() call and to prevent the task going away.
sched_setaffinity acquires a task struct ref and drops tasklist
lock right away. The access to the cpus_allowed mask is
protected by rq->lock.

rcu_read_lock() provides the same protection here.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20091209100706.789059966@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6563,22 +6563,18 @@ long sched_setaffinity(pid_t pid, const
 	int retval;
 
 	get_online_cpus();
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 
 	p = find_process_by_pid(pid);
 	if (!p) {
-		read_unlock(&tasklist_lock);
+		rcu_read_unlock();
 		put_online_cpus();
 		return -ESRCH;
 	}
 
-	/*
-	 * It is not safe to call set_cpus_allowed with the
-	 * tasklist_lock held. We will bump the task_struct's
-	 * usage count and then drop tasklist_lock.
-	 */
+	/* Prevent p going away */
 	get_task_struct(p);
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	if (!alloc_cpumask_var(&cpus_allowed, GFP_KERNEL)) {
 		retval = -ENOMEM;
@@ -6664,7 +6660,7 @@ long sched_getaffinity(pid_t pid, struct
 	int retval;
 
 	get_online_cpus();
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 
 	retval = -ESRCH;
 	p = find_process_by_pid(pid);
@@ -6680,7 +6676,7 @@ long sched_getaffinity(pid_t pid, struct
 	task_rq_unlock(rq, &flags);
 
 out_unlock:
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	put_online_cpus();
 
 	return retval;


