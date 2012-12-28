Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab2L1TUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:20:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55713 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932475Ab2L1TUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:20:00 -0500
Message-Id: <20121228190336.845327129@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:03 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 033/173] freezer: add missing mbs to freezer_count() and
 freezer_should_skip()
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context and indentation
 - freezer_do_not_count() and freezer_count() are no-ops for kernel tasks]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/freezer.h |   50 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 8 deletions(-)

--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -88,9 +88,16 @@ static inline int cgroup_freezing_or_fro
  * parent.
  */
 
-/*
- * If the current task is a user space one, tell the freezer not to count it as
- * freezable.
+/**
+ * freezer_do_not_count - tell freezer to ignore %current if a user space task
+ *
+ * Tell freezers to ignore the current task when determining whether the
+ * target frozen state is reached.  IOW, the current task will be
+ * considered frozen enough by freezers.
+ *
+ * The caller shouldn't do anything which isn't allowed for a frozen task
+ * until freezer_cont() is called.  Usually, freezer[_do_not]_count() pair
+ * wrap a scheduling operation and nothing much else.
  */
 static inline void freezer_do_not_count(void)
 {
@@ -98,24 +105,48 @@ static inline void freezer_do_not_count(
 		current->flags |= PF_FREEZER_SKIP;
 }
 
-/*
- * If the current task is a user space one, tell the freezer to count it as
- * freezable again and try to freeze it.
+/**
+ * freezer_count - tell freezer to stop ignoring %current if a user space task
+ *
+ * Undo freezer_do_not_count().  It tells freezers that %current should be
+ * considered again and tries to freeze if freezing condition is already in
+ * effect.
  */
 static inline void freezer_count(void)
 {
 	if (current->mm) {
 		current->flags &= ~PF_FREEZER_SKIP;
+		/*
+		 * If freezing is in progress, the following paired with smp_mb()
+		 * in freezer_should_skip() ensures that either we see %true
+		 * freezing() or freezer_should_skip() sees !PF_FREEZER_SKIP.
+		 */
+		smp_mb();
 		try_to_freeze();
 	}
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


