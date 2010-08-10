Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab0HJTxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 15:53:31 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:51768 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755116Ab0HJTxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 15:53:30 -0400
X-IronPort-AV: E=Sophos;i="4.55,349,1278280800"; 
   d="scan'208";a="56942663"
From: Tomasz Buchert <tomasz.buchert@inria.fr>
To: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Tomasz Buchert <tomasz.buchert@inria.fr>
Subject: [PATCH] cgroup_freezer: Freezing and task move race fix
Date: Tue, 10 Aug 2010 21:53:21 +0200
Message-Id: <1281470001-14320-1-git-send-email-tomasz.buchert@inria.fr>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Writing 'FROZEN' to freezer.state file does not
forbid the task to be moved away from its cgroup
(for a very short time). Nevertheless the moved task
can become frozen OUTSIDE its cgroup which puts
discussed task in a permanent 'D' state.

This patch forbids migration of either FROZEN
or FREEZING tasks.

This behavior was observed and easily reproduced on
a single core laptop. Program and instructions how
to reproduce the bug can be fetched from:
http://pentium.hopto.org/~thinred/repos/linux-misc/freezer_bug.c

Signed-off-by: Tomasz Buchert <tomasz.buchert@inria.fr>
---
 kernel/cgroup_freezer.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index ce71ed5..e49aa8c 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -161,6 +161,12 @@ static bool is_task_frozen_enough(struct task_struct *task)
 		(task_is_stopped_or_traced(task) && freezing(task));
 }
 
+/* Task is in a state that forbids any cgroup migration. */
+static bool is_task_pinned_down(struct task_struct *task)
+{
+	return freezing(task) || frozen(task);
+}
+
 /*
  * The call to cgroup_lock() in the freezer.state write method prevents
  * a write to that file racing against an attach, and hence the
@@ -179,7 +185,7 @@ static int freezer_can_attach(struct cgroup_subsys *ss,
 	 * frozen, so it's sufficient to check the latter condition.
 	 */
 
-	if (is_task_frozen_enough(task))
+	if (is_task_pinned_down(task))
 		return -EBUSY;
 
 	freezer = cgroup_freezer(new_cgroup);
@@ -191,7 +197,7 @@ static int freezer_can_attach(struct cgroup_subsys *ss,
 
 		rcu_read_lock();
 		list_for_each_entry_rcu(c, &task->thread_group, thread_group) {
-			if (is_task_frozen_enough(c)) {
+			if (is_task_pinned_down(c)) {
 				rcu_read_unlock();
 				return -EBUSY;
 			}
-- 
1.6.3.3

