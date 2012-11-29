Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab2K2Hsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 02:48:38 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:56251 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2K2Hsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 02:48:37 -0500
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/2] zsmalloc: add function to query object size
Date: Wed, 28 Nov 2012 23:48:30 -0800
Message-Id: <1354175311-30897-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog v2 vs v1
 - None

Adds zs_get_object_size(handle) which provides the size of
the given object. This is useful since the user (zram etc.)
now do not have to maintain object sizes separately, saving
on some metadata size (4b per page).

The object handle encodes <page, offset> pair which currently points
to the start of the object. Now, the handle implicitly stores the size
information by pointing to the object's end instead. Since zsmalloc is
a slab based allocator, the start of the object can be easily determined
and the difference between the end offset encoded in the handle and the
start gives us the object size.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/zsmalloc/zsmalloc-main.c |  177 +++++++++++++++++++++---------
 drivers/staging/zsmalloc/zsmalloc.h      |    1 +
 2 files changed, 127 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 09a9d35..65c9d3b 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -112,20 +112,20 @@
 #define MAX_PHYSMEM_BITS 36
 #else /* !CONFIG_HIGHMEM64G */
 /*
- * If this definition of MAX_PHYSMEM_BITS is used, OBJ_INDEX_BITS will just
+ * If this definition of MAX_PHYSMEM_BITS is used, OFFSET_BITS will just
  * be PAGE_SHIFT
  */
 #define MAX_PHYSMEM_BITS BITS_PER_LONG
 #endif
 #endif
 #define _PFN_BITS		(MAX_PHYSMEM_BITS - PAGE_SHIFT)
-#define OBJ_INDEX_BITS	(BITS_PER_LONG - _PFN_BITS)
-#define OBJ_INDEX_MASK	((_AC(1, UL) << OBJ_INDEX_BITS) - 1)
+#define OFFSET_BITS	(BITS_PER_LONG - _PFN_BITS)
+#define OFFSET_MASK	((_AC(1, UL) << OFFSET_BITS) - 1)
 
 #define MAX(a, b) ((a) >= (b) ? (a) : (b))
 /* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
 #define ZS_MIN_ALLOC_SIZE \
-	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
+	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OFFSET_BITS))
 #define ZS_MAX_ALLOC_SIZE	PAGE_SIZE
 
 /*
@@ -256,6 +256,11 @@ static int is_last_page(struct page *page)
 	return PagePrivate2(page);
 }
 
+static unsigned long get_page_index(struct page *page)
+{
+	return is_first_page(page) ? 0 : page->index;
+}
+
 static void get_zspage_mapping(struct page *page, unsigned int *class_idx,
 				enum fullness_group *fullness)
 {
@@ -433,39 +438,86 @@ static struct page *get_next_page(struct page *page)
 	return next;
 }
 
-/* Encode <page, obj_idx> as a single handle value */
-static void *obj_location_to_handle(struct page *page, unsigned long obj_idx)
+static struct page *get_prev_page(struct page *page)
 {
-	unsigned long handle;
+	struct page *prev, *first_page;
 
-	if (!page) {
-		BUG_ON(obj_idx);
-		return NULL;
-	}
+	first_page = get_first_page(page);
+	if (page == first_page)
+		prev = NULL;
+	else if (page == (struct page *)first_page->private)
+		prev = first_page;
+	else
+		prev = list_entry(page->lru.prev, struct page, lru);
 
-	handle = page_to_pfn(page) << OBJ_INDEX_BITS;
-	handle |= (obj_idx & OBJ_INDEX_MASK);
+	return prev;
 
-	return (void *)handle;
 }
 
-/* Decode <page, obj_idx> pair from the given object handle */
-static void obj_handle_to_location(unsigned long handle, struct page **page,
-				unsigned long *obj_idx)
+static void *encode_ptr(struct page *page, unsigned long offset)
 {
-	*page = pfn_to_page(handle >> OBJ_INDEX_BITS);
-	*obj_idx = handle & OBJ_INDEX_MASK;
+	unsigned long ptr;
+	ptr = page_to_pfn(page) << OFFSET_BITS;
+	ptr |= offset & OFFSET_MASK;
+	return (void *)ptr;
+}
+
+static void decode_ptr(unsigned long ptr, struct page **page,
+					unsigned int *offset)
+{
+	*page = pfn_to_page(ptr >> OFFSET_BITS);
+	*offset = ptr & OFFSET_MASK;
+}
+
+static struct page *obj_handle_to_page(unsigned long handle)
+{
+	struct page *page;
+	unsigned int offset;
+
+	decode_ptr(handle, &page, &offset);
+	if (offset < get_page_index(page))
+		page = get_prev_page(page);
+
+	return page;
+}
+
+static unsigned int obj_handle_to_offset(unsigned long handle,
+					unsigned int class_size)
+{
+	struct page *page;
+	unsigned int offset;
+
+	decode_ptr(handle, &page, &offset);
+	if (offset < get_page_index(page))
+		offset = PAGE_SIZE - class_size + get_page_index(page);
+	else
+		offset = roundup(offset, class_size) - class_size;
+
+	return offset;
 }
 
-static unsigned long obj_idx_to_offset(struct page *page,
-				unsigned long obj_idx, int class_size)
+/* Encode <page, offset, size> as a single handle value */
+static void *obj_location_to_handle(struct page *page, unsigned int offset,
+				unsigned int size, unsigned int class_size)
 {
-	unsigned long off = 0;
+	struct page *endpage;
+	unsigned int endoffset;
 
-	if (!is_first_page(page))
-		off = page->index;
+	if (!page) {
+		BUG_ON(offset);
+		return NULL;
+	}
+	BUG_ON(offset >= PAGE_SIZE);
+
+	endpage = page;
+	endoffset = offset + size - 1;
+	if (endoffset >= PAGE_SIZE) {
+		endpage = get_next_page(page);
+		BUG_ON(!endpage);
+		endoffset -= PAGE_SIZE;
+	}
 
-	return off + obj_idx * class_size;
+	return encode_ptr(endpage, endoffset);
 }
 
 static void reset_page(struct page *page)
@@ -506,14 +558,13 @@ static void free_zspage(struct page *first_page)
 /* Initialize a newly allocated zspage */
 static void init_zspage(struct page *first_page, struct size_class *class)
 {
-	unsigned long off = 0;
+	unsigned long off = 0, next_off = 0;
 	struct page *page = first_page;
 
 	BUG_ON(!is_first_page(first_page));
 	while (page) {
 		struct page *next_page;
 		struct link_free *link;
-		unsigned int i, objs_on_page;
 
 		/*
 		 * page->index stores offset of first object starting
@@ -526,14 +577,12 @@ static void init_zspage(struct page *first_page, struct size_class *class)
 
 		link = (struct link_free *)kmap_atomic(page) +
 						off / sizeof(*link);
-		objs_on_page = (PAGE_SIZE - off) / class->size;
 
-		for (i = 1; i <= objs_on_page; i++) {
-			off += class->size;
-			if (off < PAGE_SIZE) {
-				link->next = obj_location_to_handle(page, i);
-				link += class->size / sizeof(*link);
-			}
+		next_off = off + class->size;
+		while (next_off < PAGE_SIZE) {
+			link->next = encode_ptr(page, next_off);
+			link += class->size / sizeof(*link);
+			next_off += class->size;
 		}
 
 		/*
@@ -542,10 +591,11 @@ static void init_zspage(struct page *first_page, struct size_class *class)
 		 * page (if present)
 		 */
 		next_page = get_next_page(page);
-		link->next = obj_location_to_handle(next_page, 0);
+		next_off = next_page ? next_off - PAGE_SIZE : 0;
+		link->next = encode_ptr(next_page, next_off);
 		kunmap_atomic(link);
 		page = next_page;
-		off = (off + class->size) % PAGE_SIZE;
+		off = next_off;
 	}
 }
 
@@ -596,7 +646,7 @@ static struct page *alloc_zspage(struct size_class *class, gfp_t flags)
 
 	init_zspage(first_page, class);
 
-	first_page->freelist = obj_location_to_handle(first_page, 0);
+	first_page->freelist = encode_ptr(first_page, 0);
 	/* Maximum number of objects we can store in this zspage */
 	first_page->objects = class->pages_per_zspage * PAGE_SIZE / class->size;
 
@@ -871,7 +921,7 @@ unsigned long zs_malloc(struct zs_pool *pool, size_t size)
 	struct size_class *class;
 
 	struct page *first_page, *m_page;
-	unsigned long m_objidx, m_offset;
+	unsigned int m_offset;
 
 	if (unlikely(!size || size > ZS_MAX_ALLOC_SIZE))
 		return 0;
@@ -895,8 +945,7 @@ unsigned long zs_malloc(struct zs_pool *pool, size_t size)
 	}
 
 	obj = (unsigned long)first_page->freelist;
-	obj_handle_to_location(obj, &m_page, &m_objidx);
-	m_offset = obj_idx_to_offset(m_page, m_objidx, class->size);
+	decode_ptr(obj, &m_page, &m_offset);
 
 	link = (struct link_free *)kmap_atomic(m_page) +
 					m_offset / sizeof(*link);
@@ -907,6 +956,9 @@ unsigned long zs_malloc(struct zs_pool *pool, size_t size)
 	first_page->inuse++;
 	/* Now move the zspage to another fullness group, if required */
 	fix_fullness_group(pool, first_page);
+
+	obj = (unsigned long)obj_location_to_handle(m_page, m_offset,
+						size, class->size);
 	spin_unlock(&class->lock);
 
 	return obj;
@@ -917,7 +969,7 @@ void zs_free(struct zs_pool *pool, unsigned long obj)
 {
 	struct link_free *link;
 	struct page *first_page, *f_page;
-	unsigned long f_objidx, f_offset;
+	unsigned long f_offset;
 
 	int class_idx;
 	struct size_class *class;
@@ -926,12 +978,12 @@ void zs_free(struct zs_pool *pool, unsigned long obj)
 	if (unlikely(!obj))
 		return;
 
-	obj_handle_to_location(obj, &f_page, &f_objidx);
+	f_page = obj_handle_to_page(obj);
 	first_page = get_first_page(f_page);
 
 	get_zspage_mapping(first_page, &class_idx, &fullness);
 	class = &pool->size_class[class_idx];
-	f_offset = obj_idx_to_offset(f_page, f_objidx, class->size);
+	f_offset = obj_handle_to_offset(obj, class->size);
 
 	spin_lock(&class->lock);
 
@@ -940,7 +992,7 @@ void zs_free(struct zs_pool *pool, unsigned long obj)
 							+ f_offset);
 	link->next = first_page->freelist;
 	kunmap_atomic(link);
-	first_page->freelist = (void *)obj;
+	first_page->freelist = encode_ptr(f_page, f_offset);
 
 	first_page->inuse--;
 	fullness = fix_fullness_group(pool, first_page);
@@ -970,10 +1022,10 @@ EXPORT_SYMBOL_GPL(zs_free);
  * This function returns with preemption and page faults disabled.
 */
 void *zs_map_object(struct zs_pool *pool, unsigned long handle,
-			enum zs_mapmode mm)
+					enum zs_mapmode mm)
 {
 	struct page *page;
-	unsigned long obj_idx, off;
+	unsigned long off;
 
 	unsigned int class_idx;
 	enum fullness_group fg;
@@ -990,10 +1042,10 @@ void *zs_map_object(struct zs_pool *pool, unsigned long handle,
 	 */
 	BUG_ON(in_interrupt());
 
-	obj_handle_to_location(handle, &page, &obj_idx);
+	page = obj_handle_to_page(handle);
 	get_zspage_mapping(get_first_page(page), &class_idx, &fg);
 	class = &pool->size_class[class_idx];
-	off = obj_idx_to_offset(page, obj_idx, class->size);
+	off = obj_handle_to_offset(handle, class->size);
 
 	area = &get_cpu_var(zs_map_area);
 	area->vm_mm = mm;
@@ -1015,7 +1067,7 @@ EXPORT_SYMBOL_GPL(zs_map_object);
 void zs_unmap_object(struct zs_pool *pool, unsigned long handle)
 {
 	struct page *page;
-	unsigned long obj_idx, off;
+	unsigned long off;
 
 	unsigned int class_idx;
 	enum fullness_group fg;
@@ -1024,10 +1076,10 @@ void zs_unmap_object(struct zs_pool *pool, unsigned long handle)
 
 	BUG_ON(!handle);
 
-	obj_handle_to_location(handle, &page, &obj_idx);
+	page = obj_handle_to_page(handle);
 	get_zspage_mapping(get_first_page(page), &class_idx, &fg);
 	class = &pool->size_class[class_idx];
-	off = obj_idx_to_offset(page, obj_idx, class->size);
+	off = obj_handle_to_offset(handle, class->size);
 
 	area = &__get_cpu_var(zs_map_area);
 	if (off + class->size <= PAGE_SIZE)
@@ -1045,6 +1097,29 @@ void zs_unmap_object(struct zs_pool *pool, unsigned long handle)
 }
 EXPORT_SYMBOL_GPL(zs_unmap_object);
 
+size_t zs_get_object_size(struct zs_pool *pool, unsigned long handle)
+{
+	struct page *endpage;
+	unsigned int endoffset, size;
+
+	unsigned int class_idx;
+	enum fullness_group fg;
+	struct size_class *class;
+
+	decode_ptr(handle, &endpage, &endoffset);
+	get_zspage_mapping(endpage, &class_idx, &fg);
+	class = &pool->size_class[class_idx];
+
+	size = endoffset + 1;
+	if (endoffset < get_page_index(endpage))
+		size += class->size - get_page_index(endpage);
+	else
+		size -= rounddown(endoffset, class->size);
+
+	return size;
+}
+EXPORT_SYMBOL_GPL(zs_get_object_size);
+
 u64 zs_get_total_size_bytes(struct zs_pool *pool)
 {
 	int i;
diff --git a/drivers/staging/zsmalloc/zsmalloc.h b/drivers/staging/zsmalloc/zsmalloc.h
index de2e8bf..2830fdf 100644
--- a/drivers/staging/zsmalloc/zsmalloc.h
+++ b/drivers/staging/zsmalloc/zsmalloc.h
@@ -38,6 +38,7 @@ void *zs_map_object(struct zs_pool *pool, unsigned long handle,
 			enum zs_mapmode mm);
 void zs_unmap_object(struct zs_pool *pool, unsigned long handle);
 
+size_t zs_get_object_size(struct zs_pool *pool, unsigned long handle);
 u64 zs_get_total_size_bytes(struct zs_pool *pool);
 
 #endif
-- 
1.7.10.4

