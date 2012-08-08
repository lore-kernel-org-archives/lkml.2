Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab2HHSLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 14:11:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38445 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758566Ab2HHSKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 14:10:44 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mingo@redhat.com, akpm@linux-foundation.org,
        tglx@linutronix.de, peterz@infradead.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] timer: relocate declarations of init_timer_on_stack_key()
Date: Wed,  8 Aug 2012 11:10:26 -0700
Message-Id: <1344449428-24962-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1344449428-24962-1-git-send-email-tj@kernel.org>
References: <1344449428-24962-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_timer_on_stack_key() is used by init macro definitions.  Move
init_timer_on_stack_key() and destroy_timer_on_stack() declarations
above init macro defs.  This will make the next init cleanup patch
easier to read.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/timer.h |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index cbd32ec..1d364ae 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -97,6 +97,21 @@ void init_timer_deferrable_key(struct timer_list *timer,
 			       const char *name,
 			       struct lock_class_key *key);
 
+#ifdef CONFIG_DEBUG_OBJECTS_TIMERS
+extern void init_timer_on_stack_key(struct timer_list *timer,
+				    const char *name,
+				    struct lock_class_key *key);
+extern void destroy_timer_on_stack(struct timer_list *timer);
+#else
+static inline void destroy_timer_on_stack(struct timer_list *timer) { }
+static inline void init_timer_on_stack_key(struct timer_list *timer,
+					   const char *name,
+					   struct lock_class_key *key)
+{
+	init_timer_key(timer, name, key);
+}
+#endif
+
 #ifdef CONFIG_LOCKDEP
 #define init_timer(timer)						\
 	do {								\
@@ -150,21 +165,6 @@ void init_timer_deferrable_key(struct timer_list *timer,
 	setup_deferrable_timer_on_stack_key((timer), NULL, NULL, (fn), (data))
 #endif
 
-#ifdef CONFIG_DEBUG_OBJECTS_TIMERS
-extern void init_timer_on_stack_key(struct timer_list *timer,
-				    const char *name,
-				    struct lock_class_key *key);
-extern void destroy_timer_on_stack(struct timer_list *timer);
-#else
-static inline void destroy_timer_on_stack(struct timer_list *timer) { }
-static inline void init_timer_on_stack_key(struct timer_list *timer,
-					   const char *name,
-					   struct lock_class_key *key)
-{
-	init_timer_key(timer, name, key);
-}
-#endif
-
 static inline void setup_timer_key(struct timer_list * timer,
 				const char *name,
 				struct lock_class_key *key,
-- 
1.7.7.3

