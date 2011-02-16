Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab1BPAXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:23:50 -0500
Received: from kroah.org ([198.145.64.141]:49398 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757603Ab1BPAXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:43 2011
Message-Id: <20110216001443.708202620@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>
Subject: [186/272] sched, cgroup: Use exit hook to avoid use-after-free crash
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 068c5cc5ac7414a8e9eb7856b4bf3cc4d4744267 upstream.

By not notifying the controller of the on-exit move back to
init_css_set, we fail to move the task out of the previous
cgroup's cfs_rq. This leads to an opportunity for a
cgroup-destroy to come in and free the cgroup (there are no
active tasks left in it after all) to which the not-quite dead
task is still enqueued.

Reported-by: Miklos Vajna <vmiklos@frugalware.org>
Fixed-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <1293206353.29444.205.camel@laptop>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -607,6 +607,9 @@ static inline struct task_group *task_gr
 {
 	struct cgroup_subsys_state *css;
 
+	if (p->flags & PF_EXITING)
+		return &root_task_group;
+
 	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
 			lockdep_is_held(&task_rq(p)->lock));
 	return container_of(css, struct task_group, css);
@@ -9178,6 +9181,20 @@ cpu_cgroup_attach(struct cgroup_subsys *
 	}
 }
 
+static void
+cpu_cgroup_exit(struct cgroup_subsys *ss, struct task_struct *task)
+{
+	/*
+	 * cgroup_exit() is called in the copy_process() failure path.
+	 * Ignore this case since the task hasn't ran yet, this avoids
+	 * trying to poke a half freed task state from generic code.
+	 */
+	if (!(task->flags & PF_EXITING))
+		return;
+
+	sched_move_task(task);
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static int cpu_shares_write_u64(struct cgroup *cgrp, struct cftype *cftype,
 				u64 shareval)
@@ -9250,6 +9267,7 @@ struct cgroup_subsys cpu_cgroup_subsys =
 	.destroy	= cpu_cgroup_destroy,
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
+	.exit		= cpu_cgroup_exit,
 	.populate	= cpu_cgroup_populate,
 	.subsys_id	= cpu_cgroup_subsys_id,
 	.early_init	= 1,


