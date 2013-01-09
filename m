Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933706Ab3AIVSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:18:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:42768 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933269Ab3AIUja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 54/80] freezer: add missing mbs to freezer_count() and freezer_should_skip()
Date: Wed,  9 Jan 2013 12:35:46 -0800
Message-Id: <20130109201507.379341968@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit dd67d32dbc5de299d70cc9e10c6c1e29ffa56b92 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/freezer.h |   50 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 8 deletions(-)

--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -75,28 +75,62 @@ static inline bool cgroup_freezing(struc
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


