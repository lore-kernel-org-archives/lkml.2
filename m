Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab1BTHIr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 02:08:47 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56590 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1BTHIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 02:08:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q716QTR8b30k1YvJNUkXoRyLBd2laSuDJOumVw7TSH4yMXTwE6RUbAUbsad3P96Xyl
         fZxnvFzENpiJ09s9eN31OAPMz5SfGGEuve4UqYRbJDe74dUmxp7fFnkuCFg7pwL7bAHQ
         B5GfLtr4LvB1DLnml1coh3EAXcZPtwaxVg8dY=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [PATCH 3/5] sched, autogroup: stop going ahead if autogroup is disabled
Date: Sun, 20 Feb 2011 15:08:14 +0800
Message-Id: <1298185696-4403-4-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
References: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when autogroup is disable from the beginning,
sched_autogroup_create_attach()
  autogroup_move_group()                    <== 1
    sched_move_task()                       <== 2
      task_move_group_fair()
        set_task_rq()
          task_group()
            autogroup_task_group()

We go the whole path without doing anything useful.

Then stop going further if autogroup is disabled.

But there will be a race window between 1 and 2, in which
sysctl_sched_autogroup_enabled is enabled. This issue
will be toke by following patch.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
---
 kernel/sched_autogroup.c |    4 ++++
 kernel/sched_autogroup.h |    5 +++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
index 9fb6562..137a096 100644
--- a/kernel/sched_autogroup.c
+++ b/kernel/sched_autogroup.c
@@ -161,11 +161,15 @@ autogroup_move_group(struct task_struct *p, struct autogroup *ag)
 
 	p->signal->autogroup = autogroup_kref_get(ag);
 
+	if (!ACCESS_ONCE(sysctl_sched_autogroup_enabled))
+		goto out;
+
 	t = p;
 	do {
 		sched_move_task(t);
 	} while_each_thread(p, t);
 
+out:
 	unlock_task_sighand(p, &flags);
 	autogroup_kref_put(prev);
 }
diff --git a/kernel/sched_autogroup.h b/kernel/sched_autogroup.h
index 7b859ff..0557705 100644
--- a/kernel/sched_autogroup.h
+++ b/kernel/sched_autogroup.h
@@ -1,6 +1,11 @@
 #ifdef CONFIG_SCHED_AUTOGROUP
 
 struct autogroup {
+	/*
+	 * reference doesn't mean how many thread attach to this
+	 * autogroup now. It just stands for the number of task
+	 * could use this autogroup.
+	 */
 	struct kref		kref;
 	struct task_group	*tg;
 	struct rw_semaphore	lock;
-- 
1.7.1

