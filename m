Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab1CONO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 09:14:27 -0400
Received: from smtp.nokia.com ([147.243.1.48]:35805 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757750Ab1CONOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 09:14:25 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: menage@google.com, lizf@cn.fujitsu.com
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, ext-phil.2.carmody@nokia.com
Subject: [PATCH 1/2] list.h: add debug version of list_empty
Date: Tue, 15 Mar 2011 15:08:42 +0200
Message-Id: <1300194523-19325-2-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.rc1.37.gf8c40
In-Reply-To: <1300194523-19325-1-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1300194523-19325-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heed the notice in list_del: "Note: list_empty() on entry does not
return true after this, the entry is in an undefined state.", and
check for precisely that condition.

There are currently a few instances in the code of this sequence:
    if(!list_empty(pnode))
        list_del(pnode);
which seems to be useless or dangerous if intended to protect from
repeated del's. And given that I've seen an oops pointing to a
dereference of poison in such a list_empty, I'm veering towards
dangerous. This patch would make such errors obvious.

Nothing is changed in the non-DEBUG_LIST build.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 include/linux/list.h |    4 ++++
 lib/list_debug.c     |   18 ++++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 3a54266..59bebd1 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -183,10 +183,14 @@ static inline int list_is_last(const struct list_head *list,
  * list_empty - tests whether a list is empty
  * @head: the list to test.
  */
+#ifndef CONFIG_DEBUG_LIST
 static inline int list_empty(const struct list_head *head)
 {
 	return head->next == head;
 }
+#else
+extern int list_empty(const struct list_head *head);
+#endif
 
 /**
  * list_empty_careful - tests whether a list is empty and not being modified
diff --git a/lib/list_debug.c b/lib/list_debug.c
index b8029a5..aaba728 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -73,3 +73,21 @@ void list_del(struct list_head *entry)
 	entry->prev = LIST_POISON2;
 }
 EXPORT_SYMBOL(list_del);
+
+/**
+ * list_empty - tests whether a list is empty
+ * @head: the list to test.
+ */
+int list_empty(const struct list_head *head)
+{
+	if ((head->prev == LIST_POISON2) || (head->prev == LIST_POISON1))
+		WARN(1, "list_empty performed on a node "
+		     "at %p removed from a list.\n", head);
+	else
+		WARN((head->prev == head) != (head->next == head),
+		     "list_empty corruption. %p<-%p->%p is half-empty.\n",
+		     head->prev, head, head->next);
+
+	return head->next == head;
+}
+EXPORT_SYMBOL(list_empty);
-- 
1.7.2.rc1.37.gf8c40

