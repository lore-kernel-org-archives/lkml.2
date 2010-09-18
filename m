Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803Ab0IRTsn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:48:43 -0400
Received: from kroah.org ([198.145.64.141]:51509 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651Ab0IRTBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:52 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:58 2010
Message-Id: <20100918185958.285024381@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Subject: [064/123] sched: Protect task->cpus_allowed access in sched_getaffinity()
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-protect-task-cpus_allowed-access-in-sched_getaffinity.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Thomas Gleixner <tglx@linutronix.de>

commit 3160568371da441b7f2fb57f2f1225404207e8f2 upstream

sched_getaffinity() is not protected against a concurrent
modification of the tasks affinity.

Serialize the access with task_rq_lock(task).

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20091208202026.769251187@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6686,6 +6686,8 @@ SYSCALL_DEFINE3(sched_setaffinity, pid_t
 long sched_getaffinity(pid_t pid, struct cpumask *mask)
 {
 	struct task_struct *p;
+	unsigned long flags;
+	struct rq *rq;
 	int retval;
 
 	get_online_cpus();
@@ -6700,7 +6702,9 @@ long sched_getaffinity(pid_t pid, struct
 	if (retval)
 		goto out_unlock;
 
+	rq = task_rq_lock(p, &flags);
 	cpumask_and(mask, &p->cpus_allowed, cpu_online_mask);
+	task_rq_unlock(rq, &flags);
 
 out_unlock:
 	read_unlock(&tasklist_lock);


