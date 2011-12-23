Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab1LWDZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 22:25:33 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63892 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab1LWDZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 22:25:30 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: [PATCH v2] cgroup: Remove task_lock() from cgroup_post_fork()
Date: Fri, 23 Dec 2011 04:25:23 +0100
Message-Id: <1324610723-30080-1-git-send-email-fweisbec@gmail.com>
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

v2: Update comment to explain that we are safe against
cgroup_exit()

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
 kernel/cgroup.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1042b3c..0ccfc25 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4593,10 +4593,19 @@ void cgroup_post_fork(struct task_struct *child)
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
+			 * css_set change in cgroup_task_migrate(). Also
+			 * the task can't exit at that point until
+			 * wake_up_new_task() is called, so we are protected
+			 * against cgroup_exit() setting child->cgroup to
+			 * init_css_set.
+			 */
 			list_add(&child->cg_list, &child->cgroups->tasks);
-		task_unlock(child);
+		}
 		write_unlock(&css_set_lock);
 	}
 }
-- 
1.7.5.4

