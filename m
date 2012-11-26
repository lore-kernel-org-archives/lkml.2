Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab2KZRey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:34:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47958 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933674Ab2KZRMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:12:16 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 198/270] Revert "cgroup: Remove task_lock() from cgroup_post_fork()"
Date: Mon, 26 Nov 2012 14:58:08 -0200
Message-Id: <1353949160-26803-199-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit d87838321124061f6c935069d97f37010fa417e6 upstream.

This reverts commit 7e3aa30ac8c904a706518b725c451bb486daaae9.

The commit incorrectly assumed that fork path always performed
threadgroup_change_begin/end() and depended on that for
synchronization against task exit and cgroup migration paths instead
of explicitly grabbing task_lock().

threadgroup_change is not locked when forking a new process (as
opposed to a new thread in the same process) and even if it were it
wouldn't be effective as different processes use different threadgroup
locks.

Revert the incorrect optimization.

Signed-off-by: Tejun Heo <tj@kernel.org>
LKML-Reference: <20121008020000.GB2575@localhost>
Acked-by: Li Zefan <lizefan@huawei.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/cgroup.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 75d4318..a91aa0b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4805,19 +4805,10 @@ void cgroup_post_fork(struct task_struct *child)
 	 */
 	if (use_task_css_set_links) {
 		write_lock(&css_set_lock);
-		if (list_empty(&child->cg_list)) {
-			/*
-			 * It's safe to use child->cgroups without task_lock()
-			 * here because we are protected through
-			 * threadgroup_change_begin() against concurrent
-			 * css_set change in cgroup_task_migrate(). Also
-			 * the task can't exit at that point until
-			 * wake_up_new_task() is called, so we are protected
-			 * against cgroup_exit() setting child->cgroup to
-			 * init_css_set.
-			 */
+		task_lock(child);
+		if (list_empty(&child->cg_list))
 			list_add(&child->cg_list, &child->cgroups->tasks);
-		}
+		task_unlock(child);
 		write_unlock(&css_set_lock);
 	}
 }
-- 
1.7.9.5

