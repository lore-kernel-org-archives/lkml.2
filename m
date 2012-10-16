Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab2JPWbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 18:31:50 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63115 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab2JPW24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 18:28:56 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, oleg@redhat.com
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/7] freezer: add missing mb's to freezer_count() and freezer_should_skip()
Date: Tue, 16 Oct 2012 15:28:41 -0700
Message-Id: <1350426526-14254-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1350426526-14254-1-git-send-email-tj@kernel.org>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A task is considered frozen enough between freezer_do_not_count() and
freezer_count() and freezers use freezer_should_skip() to test this
condition.  This supposedly works because freezer_count() always calls
try_to_freezer() after clearing %PF_FREEZER_SKIP.

However, there currently is nothing which guarantees that
freezer_count() sees %true freezing() after clearing %PF_FREEZER_SKIP
when freezing is in progress, and vice-versa.  A task can escape the
freezing condition in effect by freezer_count() seeing !freezing() and
freezer_should_skip() seeing %PF_FREEZER_SKIP.

This patch adds smp_mb()'s to freezer_count() and
freezer_should_skip() such that either %true freezing() is visible to
freezer_count() or !PF_FREEZER_SKIP is visible to
freezer_should_skip().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: stable@vger.kernel.org
---
 include/linux/freezer.h |   50 +++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index d09af4b..ee89932 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -75,28 +75,62 @@ static inline bool cgroup_freezing(struct task_struct *task)
  */
 
 
-/* Tell the freezer not to count the current task as freezable. */
+/**
+ * freezer_do_not_count - tell freezer to ignore %current
+ *
+ * Tell freezers to ignore the current task when determining whether the
+ * target frozen state is reached.  IOW, the current task will be
+ * considered frozen enough by freezers.
+ *
+ * The caller shouldn't do anything which isn't allowed for a frozen task
+ * until freezer_cont() is called.  Usually, freezer[_do_not]_count() pair
+ * wrap a scheduling operation and nothing much else.
+ */
 static inline void freezer_do_not_count(void)
 {
 	current->flags |= PF_FREEZER_SKIP;
 }
 
-/*
- * Tell the freezer to count the current task as freezable again and try to
- * freeze it.
+/**
+ * freezer_count - tell freezer to stop ignoring %current
+ *
+ * Undo freezer_do_not_count().  It tells freezers that %current should be
+ * considered again and tries to freeze if freezing condition is already in
+ * effect.
  */
 static inline void freezer_count(void)
 {
 	current->flags &= ~PF_FREEZER_SKIP;
+	/*
+	 * If freezing is in progress, the following paired with smp_mb()
+	 * in freezer_should_skip() ensures that either we see %true
+	 * freezing() or freezer_should_skip() sees !PF_FREEZER_SKIP.
+	 */
+	smp_mb();
 	try_to_freeze();
 }
 
-/*
- * Check if the task should be counted as freezable by the freezer
+/**
+ * freezer_should_skip - whether to skip a task when determining frozen
+ *			 state is reached
+ * @p: task in quesion
+ *
+ * This function is used by freezers after establishing %true freezing() to
+ * test whether a task should be skipped when determining the target frozen
+ * state is reached.  IOW, if this function returns %true, @p is considered
+ * frozen enough.
  */
-static inline int freezer_should_skip(struct task_struct *p)
+static inline bool freezer_should_skip(struct task_struct *p)
 {
-	return !!(p->flags & PF_FREEZER_SKIP);
+	/*
+	 * The following smp_mb() paired with the one in freezer_count()
+	 * ensures that either freezer_count() sees %true freezing() or we
+	 * see cleared %PF_FREEZER_SKIP and return %false.  This makes it
+	 * impossible for a task to slip frozen state testing after
+	 * clearing %PF_FREEZER_SKIP.
+	 */
+	smp_mb();
+	return p->flags & PF_FREEZER_SKIP;
 }
 
 /*
-- 
1.7.7.3

