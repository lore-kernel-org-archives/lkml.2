Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934623Ab1JaTGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 15:06:18 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63571 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab1JaTGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 15:06:14 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, matthltc@us.ibm.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/17] freezer: remove should_send_signal() and update frozen()
Date: Mon, 31 Oct 2011 12:05:27 -0700
Message-Id: <1320087928-32307-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1320087928-32307-1-git-send-email-tj@kernel.org>
References: <1320087928-32307-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

should_send_signal() is only used in freezer.c.  Exporting them only
increases chance of abuse.  Open code the two users and remove it.

Update frozen() to return bool.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/freezer.h |    9 ++-------
 kernel/freezer.c        |    2 +-
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 6152e46..3dd2110 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -15,7 +15,7 @@ extern bool pm_nosig_freezing;		/* PM nosig freezing in effect */
 /*
  * Check if a process has been frozen
  */
-static inline int frozen(struct task_struct *p)
+static inline bool frozen(struct task_struct *p)
 {
 	return p->flags & PF_FROZEN;
 }
@@ -32,11 +32,6 @@ static inline bool freezing(struct task_struct *p)
 	return freezing_slow_path(p);
 }
 
-static inline bool should_send_signal(struct task_struct *p)
-{
-	return !(p->flags & PF_FREEZER_NOSIG);
-}
-
 /* Takes and releases task alloc lock using task_lock() */
 extern void __thaw_task(struct task_struct *t);
 
@@ -171,7 +166,7 @@ static inline void set_freezable_with_signal(void)
 	__retval;							\
 })
 #else /* !CONFIG_FREEZER */
-static inline int frozen(struct task_struct *p) { return 0; }
+static inline bool frozen(struct task_struct *p) { return false; }
 static inline bool freezing(struct task_struct *p) { return false; }
 
 static inline bool __refrigerator(bool check_kthr_stop) { return false; }
diff --git a/kernel/freezer.c b/kernel/freezer.c
index a797f41..c89608d 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -132,7 +132,7 @@ bool freeze_task(struct task_struct *p, bool sig_only)
 		return false;
 	}
 
-	if (should_send_signal(p)) {
+	if (!(p->flags & PF_FREEZER_NOSIG)) {
 		fake_signal_wake_up(p);
 		/*
 		 * fake_signal_wake_up() goes through p's scheduler
-- 
1.7.3.1

