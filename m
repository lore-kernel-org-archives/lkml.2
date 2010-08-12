Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759643Ab0HLJpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 05:45:41 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:51253
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759254Ab0HLJpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 05:45:34 -0400
X-IronPort-AV: E=Sophos;i="4.55,357,1278280800"; 
   d="scan'208";a="67527461"
From: Tomasz Buchert <tomasz.buchert@inria.fr>
To: Matt Helsley <matthltc@us.ibm.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Tomasz Buchert <tomasz.buchert@inria.fr>
Subject: [PATCH 2/3] cgroup_freezer: Fix can_attach to prohibit moving from/to freezing/frozen cgroups
Date: Thu, 12 Aug 2010 11:45:22 +0200
Message-Id: <1281606323-16245-3-git-send-email-tomasz.buchert@inria.fr>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1281606323-16245-2-git-send-email-tomasz.buchert@inria.fr>
References: <1281470001-14320-1-git-send-email-tomasz.buchert@inria.fr>
 <1281606323-16245-1-git-send-email-tomasz.buchert@inria.fr>
 <1281606323-16245-2-git-send-email-tomasz.buchert@inria.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to move a task from its cgroup
even if this group is 'FREEZING'. This results in
a nasty bug - the moved task will become frozen OUTSIDE
its original cgroup and will remain in a permanent 'D' state.

This patch allows to migrate the task only between THAWED cgroups.

This behavior was observed and easily reproduced on
a single core laptop. Notice that reproducibility depends
highly on the machine used. Program and instructions how
to reproduce the bug can be fetched from:
http://pentium.hopto.org/~thinred/repos/linux-misc/freezer_bug.c

Signed-off-by: Tomasz Buchert <tomasz.buchert@inria.fr>
---
 kernel/cgroup_freezer.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 321e2a0..c287627 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -173,24 +173,25 @@ static int freezer_can_attach(struct cgroup_subsys *ss,
 
 	/*
 	 * Anything frozen can't move or be moved to/from.
-	 *
-	 * Since orig_freezer->state == FROZEN means that @task has been
-	 * frozen, so it's sufficient to check the latter condition.
 	 */
 
-	if (is_task_frozen_enough(task))
+	freezer = cgroup_freezer(new_cgroup);
+	if (freezer->state != CGROUP_THAWED)
 		return -EBUSY;
 
-	freezer = cgroup_freezer(new_cgroup);
-	if (freezer->state == CGROUP_FROZEN)
+	rcu_read_lock();
+	if (__cgroup_freezing_or_frozen(task)) {
+		rcu_read_unlock();
 		return -EBUSY;
+	}
+	rcu_read_unlock();
 
 	if (threadgroup) {
 		struct task_struct *c;
 
 		rcu_read_lock();
 		list_for_each_entry_rcu(c, &task->thread_group, thread_group) {
-			if (is_task_frozen_enough(c)) {
+			if (__cgroup_freezing_or_frozen(c)) {
 				rcu_read_unlock();
 				return -EBUSY;
 			}
-- 
1.6.3.3

