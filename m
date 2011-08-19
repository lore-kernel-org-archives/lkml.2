Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab1HSORh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 10:17:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63671 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab1HSOQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 10:16:57 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/16] freezer: remove should_send_signal() and update frozen()
Date: Fri, 19 Aug 2011 16:16:22 +0200
Message-Id: <1313763382-12341-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313763382-12341-1-git-send-email-tj@kernel.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
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
index 11b2bd9..122b5ce 100644
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
 
@@ -156,7 +151,7 @@ static inline bool set_freezable_with_signal(void)
 	__retval;							\
 })
 #else /* !CONFIG_FREEZER */
-static inline int frozen(struct task_struct *p) { return 0; }
+static inline bool frozen(struct task_struct *p) { return false; }
 static inline bool freezing(struct task_struct *p) { return false; }
 
 static inline bool __refrigerator(bool check_kthr_stop) { return false; }
diff --git a/kernel/freezer.c b/kernel/freezer.c
index 995bddf..466ea6b 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -129,7 +129,7 @@ bool freeze_task(struct task_struct *p, bool sig_only)
 		return false;
 	}
 
-	if (should_send_signal(p)) {
+	if (!(p->flags & PF_FREEZER_NOSIG)) {
 		fake_signal_wake_up(p);
 		/*
 		 * fake_signal_wake_up() goes through p's scheduler
-- 
1.7.6

