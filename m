Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828Ab1DZUlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:41:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39189 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab1DZUls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:41:48 -0400
From: Jesse Gross <jesse@nicira.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH] flex_array: Avoid divisions when accessing elements.
Date: Tue, 26 Apr 2011 13:41:41 -0700
Message-Id: <1303850501-16249-1-git-send-email-jesse@nicira.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On most architectures division is an expensive operation and
accessing an element currently requires four of them.  This
performance penalty effectively precludes flex arrays from
being used on any kind of fast path.  However, two of these
divisions can be handled at creation time and the others can
be replaced by a reciprocal divide, completely avoiding real
divisions on access.

Signed-off-by: Jesse Gross <jesse@nicira.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: David Rientjes <rientjes@google.com>
---
 include/linux/flex_array.h |    2 ++
 lib/flex_array.c           |   21 ++++++++++++---------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/include/linux/flex_array.h b/include/linux/flex_array.h
index 70e4efa..9641a8f 100644
--- a/include/linux/flex_array.h
+++ b/include/linux/flex_array.h
@@ -21,6 +21,8 @@ struct flex_array {
 		struct {
 			int element_size;
 			int total_nr_elements;
+			int elems_per_part;
+			u32 reciprocal_elems;
 			struct flex_array_part *parts[];
 		};
 		/*
diff --git a/lib/flex_array.c b/lib/flex_array.c
index c0ea40b..17ed599 100644
--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/stddef.h>
 #include <linux/module.h>
+#include <linux/reciprocal_div.h>
 
 struct flex_array_part {
 	char elements[FLEX_ARRAY_PART_SIZE];
@@ -88,8 +89,8 @@ struct flex_array *flex_array_alloc(int element_size, unsigned int total,
 					gfp_t flags)
 {
 	struct flex_array *ret;
-	int max_size = FLEX_ARRAY_NR_BASE_PTRS *
-				FLEX_ARRAY_ELEMENTS_PER_PART(element_size);
+	int elems_per_part = FLEX_ARRAY_ELEMENTS_PER_PART(element_size);
+	int max_size = FLEX_ARRAY_NR_BASE_PTRS * elems_per_part;
 
 	/* max_size will end up 0 if element_size > PAGE_SIZE */
 	if (total > max_size)
@@ -99,6 +100,8 @@ struct flex_array *flex_array_alloc(int element_size, unsigned int total,
 		return NULL;
 	ret->element_size = element_size;
 	ret->total_nr_elements = total;
+	ret->elems_per_part = elems_per_part;
+	ret->reciprocal_elems = reciprocal_value(elems_per_part);
 	if (elements_fit_in_base(ret) && !(flags & __GFP_ZERO))
 		memset(&ret->parts[0], FLEX_ARRAY_FREE,
 						FLEX_ARRAY_BASE_BYTES_LEFT);
@@ -109,7 +112,7 @@ EXPORT_SYMBOL(flex_array_alloc);
 static int fa_element_to_part_nr(struct flex_array *fa,
 					unsigned int element_nr)
 {
-	return element_nr / FLEX_ARRAY_ELEMENTS_PER_PART(fa->element_size);
+	return reciprocal_divide(element_nr, fa->reciprocal_elems);
 }
 
 /**
@@ -138,12 +141,12 @@ void flex_array_free(struct flex_array *fa)
 EXPORT_SYMBOL(flex_array_free);
 
 static unsigned int index_inside_part(struct flex_array *fa,
-					unsigned int element_nr)
+					unsigned int element_nr,
+					unsigned int part_nr)
 {
 	unsigned int part_offset;
 
-	part_offset = element_nr %
-				FLEX_ARRAY_ELEMENTS_PER_PART(fa->element_size);
+	part_offset = element_nr - part_nr * fa->elems_per_part;
 	return part_offset * fa->element_size;
 }
 
@@ -196,7 +199,7 @@ int flex_array_put(struct flex_array *fa, unsigned int element_nr, void *src,
 		if (!part)
 			return -ENOMEM;
 	}
-	dst = &part->elements[index_inside_part(fa, element_nr)];
+	dst = &part->elements[index_inside_part(fa, element_nr, part_nr)];
 	memcpy(dst, src, fa->element_size);
 	return 0;
 }
@@ -224,7 +227,7 @@ int flex_array_clear(struct flex_array *fa, unsigned int element_nr)
 		if (!part)
 			return -EINVAL;
 	}
-	dst = &part->elements[index_inside_part(fa, element_nr)];
+	dst = &part->elements[index_inside_part(fa, element_nr, part_nr)];
 	memset(dst, FLEX_ARRAY_FREE, fa->element_size);
 	return 0;
 }
@@ -293,7 +296,7 @@ void *flex_array_get(struct flex_array *fa, unsigned int element_nr)
 		if (!part)
 			return NULL;
 	}
-	return &part->elements[index_inside_part(fa, element_nr)];
+	return &part->elements[index_inside_part(fa, element_nr, part_nr)];
 }
 EXPORT_SYMBOL(flex_array_get);
 
-- 
1.7.1

