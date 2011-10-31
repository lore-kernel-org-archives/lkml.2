Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934635Ab1JaTGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 15:06:33 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44909 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934612Ab1JaTGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 15:06:16 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, matthltc@us.ibm.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 17/17] freezer: fix set_freezable[_with_signal]() race
Date: Mon, 31 Oct 2011 12:05:28 -0700
Message-Id: <1320087928-32307-18-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1320087928-32307-1-git-send-email-tj@kernel.org>
References: <1320087928-32307-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A kthread doing set_freezable*() may race with on-going PM freeze and
the freezer might think all tasks are frozen while the new freezable
kthread is merrily proceeding to execute code paths which aren't
supposed to be executing during PM freeze.

Reimplement set_freezable[_with_signal]() using __set_freezable() such
that freezable PF flags are modified under freezer_lock and
try_to_freeze() is called afterwards.  This eliminates race condition
against freezing.

Note: Separated out from larger patch to resolve fix order dependency
      Oleg pointed out.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/freezer.h |    9 +++++----
 kernel/freezer.c        |   25 +++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 3dd2110..ac0513e 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -49,6 +49,7 @@ static inline bool try_to_freeze(void)
 }
 
 extern bool freeze_task(struct task_struct *p, bool sig_only);
+extern bool __set_freezable(bool with_signal);
 
 #ifdef CONFIG_CGROUP_FREEZER
 extern bool cgroup_freezing(struct task_struct *task);
@@ -106,18 +107,18 @@ static inline int freezer_should_skip(struct task_struct *p)
 /*
  * Tell the freezer that the current task should be frozen by it
  */
-static inline void set_freezable(void)
+static inline bool set_freezable(void)
 {
-	current->flags &= ~PF_NOFREEZE;
+	return __set_freezable(false);
 }
 
 /*
  * Tell the freezer that the current task should be frozen by it and that it
  * should send a fake signal to the task to freeze it.
  */
-static inline void set_freezable_with_signal(void)
+static inline bool set_freezable_with_signal(void)
 {
-	current->flags &= ~(PF_NOFREEZE | PF_FREEZER_NOSIG);
+	return __set_freezable(true);
 }
 
 /*
diff --git a/kernel/freezer.c b/kernel/freezer.c
index c89608d..a95250c 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -171,3 +171,28 @@ void __thaw_task(struct task_struct *p)
 	}
 	spin_unlock_irqrestore(&freezer_lock, flags);
 }
+
+/**
+ * __set_freezable - make %current freezable
+ * @with_signal: do we want %TIF_SIGPENDING for notification too?
+ *
+ * Mark %current freezable and enter refrigerator if necessary.
+ */
+bool __set_freezable(bool with_signal)
+{
+	might_sleep();
+
+	/*
+	 * Modify flags while holding freezer_lock.  This ensures the
+	 * freezer notices that we aren't frozen yet or the freezing
+	 * condition is visible to try_to_freeze() below.
+	 */
+	spin_lock_irq(&freezer_lock);
+	current->flags &= ~PF_NOFREEZE;
+	if (with_signal)
+		current->flags &= ~PF_FREEZER_NOSIG;
+	spin_unlock_irq(&freezer_lock);
+
+	return try_to_freeze();
+}
+EXPORT_SYMBOL(__set_freezable);
-- 
1.7.3.1

