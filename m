Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab1LVBSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:18:40 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:38453 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1LVBSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 20:18:38 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: [RFC PATCH] cgroup: Remove task_lock() from cgroup_post_fork()
Date: Thu, 22 Dec 2011 02:18:31 +0100
Message-Id: <1324516711-26913-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_post_fork() is protected between threadgroup_change_begin()
and threadgroup_change_end() against concurrent changes of the
child's css_set in cgroup_task_migrate(). Also the child can't
exit and call cgroup_exit() at this stage, this means it's css_set
can't be changed with init_css_set concurrently.

For these reasons, we don't need to hold task_lock() on the child
because it's css_set can only remain stable in this place.

Let's remove the lock there.

NOTE: We could do something else: move threadgroup_change_end()
before cgroup_post_fork() and keep the task_lock() which, combined
with the css_set_lock, would be enough to synchronize against
cgroup_task_migrate()'s change on child->cgroup and its cglist.
Because outside that, the threadgroup lock doesn't appear to be
needed on cgroup_post_fork().

Let's debate!

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Containers <containers@lists.linux-foundation.org>
Cc: Cgroups <cgroups@vger.kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Mandeep Singh Baines <msb@chromium.org>
---
 kernel/cgroup.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4936d88..d0dbf72 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4622,10 +4622,15 @@ void cgroup_post_fork(struct task_struct *child)
 {
 	if (use_task_css_set_links) {
 		write_lock(&css_set_lock);
-		task_lock(child);
-		if (list_empty(&child->cg_list))
+		if (list_empty(&child->cg_list)) {
+			/*
+			 * It's safe to use child->cgroups without task_lock()
+			 * here because we are protected through
+			 * threadgroup_change_begin() against concurrent
+			 * css_set change in cgroup_task_migrate()
+			 */
 			list_add(&child->cg_list, &child->cgroups->tasks);
-		task_unlock(child);
+		}
 		write_unlock(&css_set_lock);
 	}
 }
-- 
1.7.5.4

