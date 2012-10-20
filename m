Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab2JTWbY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 18:31:24 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41521 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab2JTWbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 18:31:23 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Benjamin Poirier <benjamin.poirier@gmail.com>
Cc: Jean Sacren <sakiwit@gmail.com>, Arnaud Lacombe <lacombar@gmail.com>,
        Wang YanQing <udknight@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Davidlohr Bueso <dave@gnu.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Yaakov Selkowitz <yselkowitz@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Benjamin Poirier <benjamin.poirier@gmail.com>
Subject: [PATCH] kconfig: fix building the qconf frontend
Date: Sun, 21 Oct 2012 00:31:13 +0200
Message-Id: <1350772273-3958-1-git-send-email-yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - 'offsetof' is already defined in stddef
    - to avoid issues with old systems still missing offsetof, just protect
      our definition between #ifndef...#endif

 - 'new' is a reserved keyword in C++:
    - rename the variable
    - protect the whole file with the usual #ifdef __cplusplus construct

Also, protect the whole file with the #ifdenf LIST_H, not only the macros
defintions.

Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Benjamin Poirier <benjamin.poirier@gmail.com>
---
 scripts/kconfig/list.h |   30 ++++++++++++++++++++----------
 1 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/scripts/kconfig/list.h b/scripts/kconfig/list.h
index 934bdba..c4fc349 100644
--- a/scripts/kconfig/list.h
+++ b/scripts/kconfig/list.h
@@ -5,7 +5,13 @@
  * Copied from include/linux/...
  */
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+#ifndef offsetof
 #define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
+#endif
 
 /**
  * container_of - cast a member of a structure out to the containing structure
@@ -49,8 +55,6 @@ struct list_head {
 	     &pos->member != (head); 	\
 	     pos = list_entry(pos->member.next, typeof(*pos), member))
 
-#endif
-
 /**
  * list_empty - tests whether a list is empty
  * @head: the list to test.
@@ -66,25 +70,31 @@ static inline int list_empty(const struct list_head *head)
  * This is only for internal list manipulation where we know
  * the prev/next entries already!
  */
-static inline void __list_add(struct list_head *new,
+static inline void __list_add(struct list_head *new_e,
 			      struct list_head *prev,
 			      struct list_head *next)
 {
-	next->prev = new;
-	new->next = next;
-	new->prev = prev;
-	prev->next = new;
+	next->prev = new_e;
+	new_e->next = next;
+	new_e->prev = prev;
+	prev->next = new_e;
 }
 
 /**
  * list_add_tail - add a new entry
- * @new: new entry to be added
+ * @new_e: new entry to be added
  * @head: list head to add it before
  *
  * Insert a new entry before the specified head.
  * This is useful for implementing queues.
  */
-static inline void list_add_tail(struct list_head *new, struct list_head *head)
+static inline void list_add_tail(struct list_head *new_e, struct list_head *head)
 {
-	__list_add(new, head->prev, head);
+	__list_add(new_e, head->prev, head);
 }
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif /* LIST_H */
-- 
1.7.2.5

