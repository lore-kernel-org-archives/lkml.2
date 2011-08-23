Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab1HWI62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 04:58:28 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:43797 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754967Ab1HWI44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 04:56:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkDAN5pU055LIxDgWdsb2JhbAA5CKgnFQEBFiYlgUABAQUnLyMQCBgxOQMbGb9JgyqDHgSkJQ
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, khlebnikov@openvz.org
Subject: [PATCH 08/13] list: add a new LRU list type
Date: Tue, 23 Aug 2011 18:56:21 +1000
Message-Id: <1314089786-20535-9-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1314089786-20535-1-git-send-email-david@fromorbit.com>
References: <1314089786-20535-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Several subsystems use the same construct for LRU lists - a list
head, a spin lock and and item count. They also use exactly the same
code for adding and removing items from the LRU. Create a generic
type for these LRU lists.

This is the beginning of generic, node aware LRUs for shrinkers to
work with.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/linux/list_lru.h |   30 ++++++++++++
 lib/Makefile             |    3 +-
 lib/list_lru.c           |  112 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 144 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/list_lru.h
 create mode 100644 lib/list_lru.c

diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
new file mode 100644
index 0000000..b112ca3
--- /dev/null
+++ b/include/linux/list_lru.h
@@ -0,0 +1,30 @@
+#ifndef _LRU_LIST_H
+#define _LRU_LIST_H 0
+
+#include <linux/list.h>
+
+struct list_lru {
+	spinlock_t		lock;
+	struct list_head	list;
+	long			nr_items;
+};
+
+int list_lru_init(struct list_lru *lru);
+int list_lru_add(struct list_lru *lru, struct list_head *item);
+int list_lru_del(struct list_lru *lru, struct list_head *item);
+
+static inline long list_lru_count(struct list_lru *lru)
+{
+	return lru->nr_items;
+}
+
+typedef int (*list_lru_walk_cb)(struct list_head *item, spinlock_t *lock,
+				void *cb_arg);
+typedef void (*list_lru_dispose_cb)(struct list_head *dispose_list);
+
+long list_lru_walk(struct list_lru *lru, list_lru_walk_cb isolate,
+		   void *cb_arg, long nr_to_walk);
+
+long list_lru_dispose_all(struct list_lru *lru, list_lru_dispose_cb dispose);
+
+#endif /* _LRU_LIST_H */
diff --git a/lib/Makefile b/lib/Makefile
index d5d175c..a08212f 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -12,7 +12,8 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o find_next_bit.o
+	 is_single_threaded.o plist.o decompress.o find_next_bit.o \
+	 list_lru.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
diff --git a/lib/list_lru.c b/lib/list_lru.c
new file mode 100644
index 0000000..8c18c63
--- /dev/null
+++ b/lib/list_lru.c
@@ -0,0 +1,112 @@
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/list_lru.h>
+
+int
+list_lru_add(
+	struct list_lru	*lru,
+	struct list_head *item)
+{
+	spin_lock(&lru->lock);
+	if (list_empty(item)) {
+		list_add_tail(item, &lru->list);
+		lru->nr_items++;
+		spin_unlock(&lru->lock);
+		return 1;
+	}
+	spin_unlock(&lru->lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(list_lru_add);
+
+int
+list_lru_del(
+	struct list_lru	*lru,
+	struct list_head *item)
+{
+	spin_lock(&lru->lock);
+	if (!list_empty(item)) {
+		list_del_init(item);
+		lru->nr_items--;
+		spin_unlock(&lru->lock);
+		return 1;
+	}
+	spin_unlock(&lru->lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(list_lru_del);
+
+long
+list_lru_walk(
+	struct list_lru *lru,
+	list_lru_walk_cb isolate,
+	void		*cb_arg,
+	long		nr_to_walk)
+{
+	struct list_head *item, *n;
+	long removed = 0;
+restart:
+	spin_lock(&lru->lock);
+	list_for_each_safe(item, n, &lru->list) {
+		int ret;
+
+		if (nr_to_walk-- < 0)
+			break;
+
+		ret = isolate(item, &lru->lock, cb_arg);
+		switch (ret) {
+		case 0:	/* item removed from list */
+			lru->nr_items--;
+			removed++;
+			break;
+		case 1: /* item referenced, give another pass */
+			list_move_tail(item, &lru->list);
+			break;
+		case 2: /* item cannot be locked, skip */
+			break;
+		case 3: /* item not freeable, lock dropped */
+			goto restart;
+		default:
+			BUG();
+		}
+	}
+	spin_unlock(&lru->lock);
+	return removed;
+}
+EXPORT_SYMBOL_GPL(list_lru_walk);
+
+long
+list_lru_dispose_all(
+	struct list_lru *lru,
+	list_lru_dispose_cb dispose)
+{
+	long disposed = 0;
+	LIST_HEAD(dispose_list);
+
+	spin_lock(&lru->lock);
+	while (!list_empty(&lru->list)) {
+		list_splice_init(&lru->list, &dispose_list);
+		disposed += lru->nr_items;
+		lru->nr_items = 0;
+		spin_unlock(&lru->lock);
+
+		dispose(&dispose_list);
+
+		spin_lock(&lru->lock);
+	}
+	spin_unlock(&lru->lock);
+	return disposed;
+}
+
+int
+list_lru_init(
+	struct list_lru	*lru)
+{
+	spin_lock_init(&lru->lock);
+	INIT_LIST_HEAD(&lru->list);
+	lru->nr_items = 0;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(list_lru_init);
-- 
1.7.5.4

