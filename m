Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab2JSIfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 04:35:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49749 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296Ab2JSIfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:35:43 -0400
From: Xiaotian Feng <xtfeng@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <xtfeng@gmail.com>, Xiaotian Feng <dannyfeng@tencent.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched, autogroup: fix kernel crashes caused by runtime disable autogroup
Date: Fri, 19 Oct 2012 16:36:10 +0800
Message-Id: <1350635770-9189-1-git-send-email-xtfeng@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a regression from commit 800d4d30, in autogroup_move_group()

	p->signal->autogroup = autogroup_kref_get(ag);

	if (!ACCESS_ONCE(sysctl_sched_autogroup_enabled))
		goto out;
	...
    out:
	autogroup_kref_put(prev);

So kernel changed p's autogroup to ag, but never sched_move_task(p).
Then previous autogroup of p is released, which may release task_group
related with p. After commit 8323f26ce, p->sched_task_group might point
to this stale value, and thus caused kernel crashes.

This is very easy to reproduce, add "kernel.sched_autogroup_enabled = 0"
to your /etc/sysctl.conf, your system will never boot up. It is not reasonable
to put the sysctl enabled check in autogroup_move_group(), kernel should check
it before autogroup_create in sched_autogroup_create_attach().

Reported-by: cwillu <cwillu@cwillu.com>
Reported-by: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/auto_group.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/auto_group.c b/kernel/sched/auto_group.c
index 0984a21..ac62415 100644
--- a/kernel/sched/auto_group.c
+++ b/kernel/sched/auto_group.c
@@ -143,15 +143,11 @@ autogroup_move_group(struct task_struct *p, struct autogroup *ag)
 
 	p->signal->autogroup = autogroup_kref_get(ag);
 
-	if (!ACCESS_ONCE(sysctl_sched_autogroup_enabled))
-		goto out;
-
 	t = p;
 	do {
 		sched_move_task(t);
 	} while_each_thread(p, t);
 
-out:
 	unlock_task_sighand(p, &flags);
 	autogroup_kref_put(prev);
 }
@@ -159,8 +155,12 @@ out:
 /* Allocates GFP_KERNEL, cannot be called under any spinlock */
 void sched_autogroup_create_attach(struct task_struct *p)
 {
-	struct autogroup *ag = autogroup_create();
+	struct autogroup *ag;
+
+	if (!ACCESS_ONCE(sysctl_sched_autogroup_enabled))
+		return;
 
+	ag = autogroup_create();
 	autogroup_move_group(p, ag);
 	/* drop extra reference added by autogroup_create() */
 	autogroup_kref_put(ag);
-- 
1.7.9.5

