Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab1BWMGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 07:06:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:56462 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab1BWMGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 07:06:13 -0500
Date: Wed, 23 Feb 2011 12:05:42 GMT
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, yong.zhang0@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        yong.zhang0@gmail.com, mingo@elte.hu
In-Reply-To: <1298185696-4403-4-git-send-email-yong.zhang0@gmail.com>
References: <1298185696-4403-4-git-send-email-yong.zhang0@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, autogroup: Stop going ahead if autogroup is disabled
Message-ID: <tip-800d4d30c8f20bd728e5741a3b77c4859a613f7c@git.kernel.org>
Git-Commit-ID: 800d4d30c8f20bd728e5741a3b77c4859a613f7c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 12:05:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  800d4d30c8f20bd728e5741a3b77c4859a613f7c
Gitweb:     http://git.kernel.org/tip/800d4d30c8f20bd728e5741a3b77c4859a613f7c
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Sun, 20 Feb 2011 15:08:14 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Feb 2011 11:33:59 +0100

sched, autogroup: Stop going ahead if autogroup is disabled

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1298185696-4403-4-git-send-email-yong.zhang0@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
