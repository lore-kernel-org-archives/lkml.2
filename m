Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab0FPEhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 00:37:05 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60480 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab0FPEhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 00:37:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mempolicy: reduce stack size of migrate_pages()
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100616130040.3831.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 16 Jun 2010 13:36:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now, migrate_pages() are using >500 bytes stack. This patch reduce it.

   mm/mempolicy.c: In function 'sys_migrate_pages':
   mm/mempolicy.c:1344: warning: the frame size of 528 bytes is larger than
   512 bytes

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 mm/mempolicy.c |   35 ++++++++++++++++++++++-------------
 1 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 13b09bd..1116427 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1275,33 +1275,39 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
 		const unsigned long __user *, new_nodes)
 {
 	const struct cred *cred = current_cred(), *tcred;
-	struct mm_struct *mm;
+	struct mm_struct *mm = NULL;
 	struct task_struct *task;
-	nodemask_t old;
-	nodemask_t new;
 	nodemask_t task_nodes;
 	int err;
+	NODEMASK_SCRATCH(scratch);
+	nodemask_t *old = &scratch->mask1;
+	nodemask_t *new = &scratch->mask2;
+
+	if (!scratch)
+		return -ENOMEM;
 
-	err = get_nodes(&old, old_nodes, maxnode);
+	err = get_nodes(old, old_nodes, maxnode);
 	if (err)
-		return err;
+		goto out;
 
-	err = get_nodes(&new, new_nodes, maxnode);
+	err = get_nodes(new, new_nodes, maxnode);
 	if (err)
-		return err;
+		goto out;
 
 	/* Find the mm_struct */
 	read_lock(&tasklist_lock);
 	task = pid ? find_task_by_vpid(pid) : current;
 	if (!task) {
 		read_unlock(&tasklist_lock);
-		return -ESRCH;
+		err = -ESRCH;
+		goto out;
 	}
 	mm = get_task_mm(task);
 	read_unlock(&tasklist_lock);
 
+	err = -EINVAL;
 	if (!mm)
-		return -EINVAL;
+		goto out;
 
 	/*
 	 * Check if this process has the right to modify the specified
@@ -1322,12 +1328,12 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
 
 	task_nodes = cpuset_mems_allowed(task);
 	/* Is the user allowed to access the target nodes? */
-	if (!nodes_subset(new, task_nodes) && !capable(CAP_SYS_NICE)) {
+	if (!nodes_subset(*new, task_nodes) && !capable(CAP_SYS_NICE)) {
 		err = -EPERM;
 		goto out;
 	}
 
-	if (!nodes_subset(new, node_states[N_HIGH_MEMORY])) {
+	if (!nodes_subset(*new, node_states[N_HIGH_MEMORY])) {
 		err = -EINVAL;
 		goto out;
 	}
@@ -1336,10 +1342,13 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
 	if (err)
 		goto out;
 
-	err = do_migrate_pages(mm, &old, &new,
+	err = do_migrate_pages(mm, old, new,
 		capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL : MPOL_MF_MOVE);
 out:
-	mmput(mm);
+	if (mm)
+		mmput(mm);
+	NODEMASK_SCRATCH_FREE(scratch);
+
 	return err;
 }
 
-- 
1.6.5.2



