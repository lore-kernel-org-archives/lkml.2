Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab1E3PCC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 11:02:02 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39887
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355Ab1E3PCB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 11:02:01 -0400
Subject: [PATCH] perf, cgroup: Fix up for new API
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephane Eranian <eranian@gmail.com>, Ben Blum <bblum@andrew.cmu.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 30 May 2011 17:00:51 +0200
Message-ID: <1306767651.1200.2990.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: perf, cgroup: Fix up for new API
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon May 30 16:48:06 CEST 2011

Ben changed the API but forgot to convert everybody...

Cc: Ben Blum <bblum@andrew.cmu.edu>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/events/core.c |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

Index: linux-2.6/kernel/events/core.c
===================================================================
--- linux-2.6.orig/kernel/events/core.c
+++ linux-2.6/kernel/events/core.c
@@ -7394,26 +7394,12 @@ static int __perf_cgroup_move(void *info
 	return 0;
 }
 
-static void perf_cgroup_move(struct task_struct *task)
+static void
+perf_cgroup_attach_task(struct cgroup *cgrp, struct task_struct *task)
 {
 	task_function_call(task, __perf_cgroup_move, task);
 }
 
-static void perf_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
-		struct cgroup *old_cgrp, struct task_struct *task,
-		bool threadgroup)
-{
-	perf_cgroup_move(task);
-	if (threadgroup) {
-		struct task_struct *c;
-		rcu_read_lock();
-		list_for_each_entry_rcu(c, &task->thread_group, thread_group) {
-			perf_cgroup_move(c);
-		}
-		rcu_read_unlock();
-	}
-}
-
 static void perf_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
 		struct cgroup *old_cgrp, struct task_struct *task)
 {
@@ -7425,7 +7411,7 @@ static void perf_cgroup_exit(struct cgro
 	if (!(task->flags & PF_EXITING))
 		return;
 
-	perf_cgroup_move(task);
+	perf_cgroup_attach_task(cgrp, task);
 }
 
 struct cgroup_subsys perf_subsys = {
@@ -7434,6 +7420,6 @@ struct cgroup_subsys perf_subsys = {
 	.create		= perf_cgroup_create,
 	.destroy	= perf_cgroup_destroy,
 	.exit		= perf_cgroup_exit,
-	.attach		= perf_cgroup_attach,
+	.attach_task	= perf_cgroup_attach_task,
 };
 #endif /* CONFIG_CGROUP_PERF */

