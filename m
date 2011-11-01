Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab1KACPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 22:15:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45773 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab1KACPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 22:15:16 -0400
Date: Mon, 31 Oct 2011 19:15:11 -0700
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, linux-pm@vger.kernel.org
Subject: [PATCH pm] freezer: fix wait_event_freezable/__thaw_task races
Message-ID: <20111101021511.GP18855@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

wait_event_freezable() and friends stop the waiting if try_to_freeze()
fails. This is not right, we can race with __thaw_task() and in this
case

	- wait_event_freezable() returns the wrong ERESTARTSYS

	- wait_event_freezable_timeout() can return the positive
	  value while condition == F

Change the code to always check __retval/condition before return.

Note: with or without this patch the timeout logic looks strange,
probably we should recalc timeout if try_to_freeze() returns T.

tj: Updated to apply to wait_event_freezekillable() too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
---

So, this should be the last of lost patches.  It's on top of

linus/master
+[1] freezer: fix various bugs and simplify implementation, take#2
+[2] usb_storage: don't use set_freezable_with_signal()" + [3]
+[3] freezer: kill unused set_freezable_with_signal()

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git pm-fix-wait_freezable

Thank you.

[1] http://thread.gmane.org/gmane.linux.kernel/1209247
[2] http://thread.gmane.org/gmane.linux.kernel/1209416
[3] http://thread.gmane.org/gmane.linux.kernel/1209416/focus=1209417

 include/linux/freezer.h |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 5f32321..4a1d933 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -113,42 +113,43 @@ static inline int freezer_should_skip(struct task_struct *p)
 #define wait_event_freezekillable(wq, condition)			\
 ({									\
 	int __retval;							\
-	do {								\
+	for (;;) {							\
 		__retval = wait_event_killable(wq,			\
 				(condition) || freezing(current));	\
-		if (__retval && !freezing(current))			\
+		if (__retval || (condition))				\
 			break;						\
-		else if (!(condition))					\
-			__retval = -ERESTARTSYS;			\
-	} while (try_to_freeze());					\
+		try_to_freeze();					\
+	}								\
 	__retval;							\
 })
 
 #define wait_event_freezable(wq, condition)				\
 ({									\
 	int __retval;							\
-	do {								\
+	for (;;) {							\
 		__retval = wait_event_interruptible(wq, 		\
 				(condition) || freezing(current));	\
-		if (__retval && !freezing(current))			\
+		if (__retval || (condition))				\
 			break;						\
-		else if (!(condition))					\
-			__retval = -ERESTARTSYS;			\
-	} while (try_to_freeze());					\
+		try_to_freeze();					\
+	}								\
 	__retval;							\
 })
 
-
 #define wait_event_freezable_timeout(wq, condition, timeout)		\
 ({									\
 	long __retval = timeout;					\
-	do {								\
+	for (;;) {							\
 		__retval = wait_event_interruptible_timeout(wq,		\
 				(condition) || freezing(current),	\
 				__retval); 				\
-	} while (try_to_freeze());					\
+		if (__retval <= 0 || (condition))			\
+			break;						\
+		try_to_freeze();					\
+	}								\
 	__retval;							\
 })
+
 #else /* !CONFIG_FREEZER */
 static inline bool frozen(struct task_struct *p) { return false; }
 static inline bool freezing(struct task_struct *p) { return false; }
-- 
1.7.3.1

