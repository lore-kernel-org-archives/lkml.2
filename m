Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab0GBRrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 13:47:46 -0400
Received: from king.tilera.com ([72.1.168.226]:7680 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab0GBRrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 13:47:45 -0400
Message-Id: <201007021747.o62HlgmV019405@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 2 Jul 2010 13:41:14 -0400
Subject: [PATCH] Break out types from <linux/list.h> to <linux/list_types.h>.
In-Reply-To: <201007021811.04197.arnd@arndb.de>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
X-OriginalArrivalTime: 02 Jul 2010 17:47:43.0881 (UTC) FILETIME=[ACA8F790:01CB1A0E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows a list_head (or hlist_head, etc.) to be used from places
that used to be impractical, in particular <asm/processor.h>, which
used to cause include file recursion: <linux/list.h> includes
<linux/prefetch.h>, which always includes <asm/processor.h> for the
prefetch macros, as well as <asm/system.h>, which often includes
<asm/processor.h> directly or indirectly.

This avoids a lot of painful workaround hackery on the tile
architecture, where we use a list_head in the thread_struct to chain
together tasks that are activated on a particular hardwall.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---

 include/linux/list.h       |   13 +------------
 include/linux/list_types.h |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 12 deletions(-)
 create mode 100644 include/linux/list_types.h

diff --git a/include/linux/list.h b/include/linux/list.h
index 8392884..3a42003 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -4,6 +4,7 @@
 #include <linux/stddef.h>
 #include <linux/poison.h>
 #include <linux/prefetch.h>
+#include <linux/list_types.h>
 #include <asm/system.h>
 
 /*
@@ -16,10 +17,6 @@
  * using the generic single-entry routines.
  */
 
-struct list_head {
-	struct list_head *next, *prev;
-};
-
 #define LIST_HEAD_INIT(name) { &(name), &(name) }
 
 #define LIST_HEAD(name) \
@@ -551,14 +548,6 @@ static inline void list_splice_tail_init(struct list_head *list,
  * You lose the ability to access the tail in O(1).
  */
 
-struct hlist_head {
-	struct hlist_node *first;
-};
-
-struct hlist_node {
-	struct hlist_node *next, **pprev;
-};
-
 #define HLIST_HEAD_INIT { .first = NULL }
 #define HLIST_HEAD(name) struct hlist_head name = {  .first = NULL }
 #define INIT_HLIST_HEAD(ptr) ((ptr)->first = NULL)
diff --git a/include/linux/list_types.h b/include/linux/list_types.h
new file mode 100644
index 0000000..c991e28
--- /dev/null
+++ b/include/linux/list_types.h
@@ -0,0 +1,16 @@
+#ifndef _LINUX_LIST_TYPES_H
+#define _LINUX_LIST_TYPES_H
+
+struct list_head {
+	struct list_head *next, *prev;
+};
+
+struct hlist_head {
+	struct hlist_node *first;
+};
+
+struct hlist_node {
+	struct hlist_node *next, **pprev;
+};
+
+#endif
-- 
1.6.5.2

