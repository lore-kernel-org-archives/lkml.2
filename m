Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab1LTTBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:01:37 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33149 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab1LTTBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:01:22 -0500
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
Subject: [PATCH 2/2] cgroup: Drop task_lock(parent) on cgroup_fork()
Date: Tue, 20 Dec 2011 20:01:13 +0100
Message-Id: <1324407673-18975-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1324407673-18975-1-git-send-email-fweisbec@gmail.com>
References: <1324320274-18485-1-git-send-email-msb@chromium.org>
 <1324407673-18975-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to hold the parent task_lock() on the
parent in cgroup_fork() because we are already synchronized
against the two places that may change the parent css_set
concurrently:

- cgroup_exit(), but the parent obviously can't exit concurrently
- cgroup migration: we are synchronized against threadgroup_lock()

So we can safely remove the task_lock() there.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Containers <containers@lists.linux-foundation.org>
Cc: Cgroups <cgroups@vger.kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Mandeep Singh Baines <msb@chromium.org>
---
 kernel/cgroup.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6b5f693..a1e87a4 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4544,7 +4544,7 @@ static const struct file_operations proc_cgroupstats_operations = {
  *
  * A pointer to the shared css_set was automatically copied in
  * fork.c by dup_task_struct().  However, we ignore that copy, since
- * it was not made under the protection of RCU or cgroup_mutex, so
+ * it was not made under the protection of threadgroup_change_begin(), so
  * might no longer be a valid cgroup pointer.  cgroup_attach_task() might
  * have already changed current->cgroups, allowing the previously
  * referenced cgroup group to be removed and freed.
@@ -4554,10 +4554,14 @@ static const struct file_operations proc_cgroupstats_operations = {
  */
 void cgroup_fork(struct task_struct *child)
 {
-	task_lock(current);
+	/*
+	 * We don't need to task_lock() current because current->cgroups
+	 * can't be changed concurrently here. The parent obviously hasn't
+	 * exited and called cgroup_exit(), and we are synchronized against
+	 * cgroup migration through threadgroup_change_begin().
+	 */
 	child->cgroups = current->cgroups;
 	get_css_set(child->cgroups);
-	task_unlock(current);
 	INIT_LIST_HEAD(&child->cg_list);
 }
 
-- 
1.7.5.4

