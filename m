Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab0IRTCp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:02:45 -0400
Received: from kroah.org ([198.145.64.141]:51637 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893Ab0IRTCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:03 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:59 2010
Message-Id: <20100918185959.668292300@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Mike Galbraith <efault@gmx.de>
Subject: [080/123] sched: Fix broken assertion
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-fix-broken-assertion.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 077614ee1e93245a3b9a4e1213659405dbeb0ba6 upstream

There's a preemption race in the set_task_cpu() debug check in
that when we get preempted after setting task->state we'd still
be on the rq proper, but fail the test.

Check for preempted tasks, since those are always on the RQ.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20091217121830.137155561@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2071,7 +2071,8 @@ void set_task_cpu(struct task_struct *p,
 	 * We should never call set_task_cpu() on a blocked task,
 	 * ttwu() will sort out the placement.
 	 */
-	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING);
+	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING &&
+			!(task_thread_info(p)->preempt_count & PREEMPT_ACTIVE));
 #endif
 
 	trace_sched_migrate_task(p, new_cpu);


