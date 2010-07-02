Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab0GDMms (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 08:42:48 -0400
Received: from king.tilera.com ([72.1.168.226]:26089 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757306Ab0GDMmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 08:42:46 -0400
Message-Id: <201007041242.o64CggfV012188@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 2 Jul 2010 13:41:14 -0400
Subject: [PATCH -v2] Move list types from <linux/list.h> to <linux/types.h>.
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
X-OriginalArrivalTime: 04 Jul 2010 12:42:45.0486 (UTC) FILETIME=[66CAF8E0:01CB1B76]
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

Folks on the Cc: list who commented on the -v1 patch, let me know
if I can add your Acked-by to this patch.  Thanks.

 include/linux/list.h  |   13 +------------
 include/linux/types.h |   12 ++++++++++++
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 8392884..bc43e8a 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_LIST_H
 #define _LINUX_LIST_H
 
+#include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/poison.h>
 #include <linux/prefetch.h>
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
diff --git a/include/linux/types.h b/include/linux/types.h
index 23d237a..336cc39 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -197,6 +197,18 @@ typedef struct {
 } atomic64_t;
 #endif
 
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
 struct ustat {
 	__kernel_daddr_t	f_tfree;
 	__kernel_ino_t		f_tinode;
-- 
1.6.5.2

