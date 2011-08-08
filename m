Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab1HHVb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 17:31:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28722 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab1HHVbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 17:31:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=T7siPfUVS9PiEABakuzDVvxKz6Sm8yp2lkwTZn/aSF44keqWlVnq4iC9P5OBGcFQZ
	dQCX87zCi9ZiUzHWqf1bQ==
From: Iliyan Malchev <malchev@google.com>
To: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Iliyan Malchev <malchev@google.com>
Subject: [PATCH 2/2] slub: name kmalloc slabs at creation time
Date: Mon,  8 Aug 2011 14:31:11 -0700
Message-Id: <1312839071-18064-1-git-send-email-malchev@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During slub's initialization, most kmalloc slabs are named "kmalloc" at
creation time, and later, once slub is fully initialized, get renamed to
kmalloc-<size>.  The trouble is that slab names passed to option slub_debug
will not get recognized, because they will all be called "kmalloc" at the time
the command-line option is being processed.

This patch reserves a small static array to hold the names of the kmalloc
slabs, and uses a small helper function __uitoa (unsigned integer to ascii) to
format names as appropriately.

Signed-off-by: Iliyan Malchev <malchev@google.com>
---
 mm/slub.c |   35 +++++++++++++++++++++++++++--------
 1 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8e7a282..a4d02cf 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3070,6 +3070,11 @@ static struct kmem_cache *kmem_cache;
 static struct kmem_cache *kmalloc_dma_caches[SLUB_PAGE_SHIFT];
 #endif
 
+#define KMALLOC_NAME_SUFFIX_MAX	8
+#define KMALLOC_NAME_MAX	(strlen("kmalloc-") + KMALLOC_NAME_SUFFIX_MAX)
+#define KMALLOC_CACHE_NAME_LEN	(SLUB_PAGE_SHIFT - KMALLOC_SHIFT_LOW)
+static char kmalloc_cache_names[KMALLOC_CACHE_NAME_LEN * KMALLOC_NAME_MAX];
+
 static int __init setup_slub_min_order(char *str)
 {
 	get_option(&str, &slub_min_order);
@@ -3544,6 +3549,19 @@ static void __init kmem_cache_bootstrap_fixup(struct kmem_cache *s)
 	}
 }
 
+/* Convert a positive integer to its decimal string representation, starting at
+ * the end of the buffer and going backwards, not exceeding maxlen characters.
+ */
+static __init char *__pos_int_to_string(unsigned int value, char* string,
+					int maxindex, int maxlen)
+{
+	int i = maxindex - 1;
+	string[maxindex] = 0;
+	for (; value && i && maxlen; i--, maxlen--, value /= 10)
+		string[i] = '0' + (value % 10);
+	return string + i + 1;
+}
+
 void __init kmem_cache_init(void)
 {
 	int i;
@@ -3552,6 +3570,7 @@ void __init kmem_cache_init(void)
 	int order;
 	struct kmem_cache *temp_kmem_cache_node;
 	unsigned long kmalloc_size;
+	char *name_start;
 
 	kmem_size = offsetof(struct kmem_cache, node) +
 				nr_node_ids * sizeof(struct kmem_cache_node *);
@@ -3652,8 +3671,15 @@ void __init kmem_cache_init(void)
 		caches++;
 	}
 
+	name_start = kmalloc_cache_names;
 	for (i = KMALLOC_SHIFT_LOW; i < SLUB_PAGE_SHIFT; i++) {
-		kmalloc_caches[i] = create_kmalloc_cache("kmalloc", 1 << i, 0);
+		char *name = __pos_int_to_string(1 << i, name_start,
+					KMALLOC_NAME_MAX - 1,
+					KMALLOC_NAME_SUFFIX_MAX);
+		name -= 8;
+		strncpy(name, "kmalloc-", 8);
+		name_start += KMALLOC_NAME_MAX;
+		kmalloc_caches[i] = create_kmalloc_cache(name, 1 << i, 0);
 		caches++;
 	}
 
@@ -3670,13 +3696,6 @@ void __init kmem_cache_init(void)
 		BUG_ON(!kmalloc_caches[2]->name);
 	}
 
-	for (i = KMALLOC_SHIFT_LOW; i < SLUB_PAGE_SHIFT; i++) {
-		char *s = kasprintf(GFP_NOWAIT, "kmalloc-%d", 1 << i);
-
-		BUG_ON(!s);
-		kmalloc_caches[i]->name = s;
-	}
-
 #ifdef CONFIG_SMP
 	register_cpu_notifier(&slab_notifier);
 #endif
-- 
1.7.3.1

