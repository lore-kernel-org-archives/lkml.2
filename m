Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab1DGRVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 13:21:22 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34347 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928Ab1DGRVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 13:21:20 -0400
Subject: [PATCH 2/2] make new alloc_pages_exact()
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Thu, 07 Apr 2011 10:21:05 -0700
References: <20110407172104.1F8B7329@kernel>
In-Reply-To: <20110407172104.1F8B7329@kernel>
Message-Id: <20110407172105.831B9A0A@kernel>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


What I really wanted in the end was a highmem-capable alloc_pages_exact(),
so here it is.

It's a bit unfortunate that we have __free_pages_exact() and
free_pages_exact(), but that mess already exists with __free_pages()
vs. free_pages_exact().  So, at worst, this mirrors the mess that we
already have.

I'm also a bit worried that I've not put in something named
alloc_pages_exact(), but that behaves differently than it did before this
set.  I got all of the in-tree cases, but I'm a bit worried about
stragglers elsewhere.  So, I'm calling this __alloc_pages_exact() for
the moment.  We can take out the __ some day if it bothers people.

Note that the __get_free_pages() has a !GFP_HIGHMEM check.  Now that
we are using alloc_pages_exact() instead of __get_free_pages() for
get_free_pages_exact(), we had to add a new check in
get_free_pages_exact().

This has been compile and boot tested, and I checked that

	echo 2 > /sys/kernel/profiling

still works, since it uses get_free_pages_exact().

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/drivers/video/pxafb.c |    4 -
 linux-2.6.git-dave/include/linux/gfp.h   |    4 +
 linux-2.6.git-dave/kernel/profile.c      |    4 -
 linux-2.6.git-dave/mm/page_alloc.c       |   81 +++++++++++++++++++++++--------
 4 files changed, 69 insertions(+), 24 deletions(-)

diff -puN include/linux/gfp.h~make_new_alloc_pages_exact include/linux/gfp.h
--- linux-2.6.git/include/linux/gfp.h~make_new_alloc_pages_exact	2011-04-07 08:41:08.158387017 -0700
+++ linux-2.6.git-dave/include/linux/gfp.h	2011-04-07 08:41:08.174387016 -0700
@@ -351,6 +351,10 @@ extern struct page *alloc_pages_vma(gfp_
 extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
 extern unsigned long get_zeroed_page(gfp_t gfp_mask);
 
+/* 'struct page' version */
+struct page *__alloc_pages_exact(gfp_t, size_t);
+void __free_pages_exact(struct page *, size_t);
+/* virtual address version */
 void *get_free_pages_exact(gfp_t gfp_mask, size_t size);
 void free_pages_exact(void *virt, size_t size);
 
diff -puN mm/page_alloc.c~make_new_alloc_pages_exact mm/page_alloc.c
--- linux-2.6.git/mm/page_alloc.c~make_new_alloc_pages_exact	2011-04-07 08:41:08.162387016 -0700
+++ linux-2.6.git-dave/mm/page_alloc.c	2011-04-07 09:44:33.937537711 -0700
@@ -2318,36 +2318,83 @@ void free_pages(unsigned long addr, unsi
 EXPORT_SYMBOL(free_pages);
 
 /**
- * get_free_pages_exact - allocate an exact number physically-contiguous pages.
+ * __alloc_pages_exact - allocate an exact number physically-contiguous pages.
  * @gfp_mask: GFP flags for the allocation
  * @size: the number of bytes to allocate
+ * returns: struct page for allocated memory
  *
- * This function is similar to __get_free_pages(), except that it allocates the
- * minimum number of pages to satisfy the request.  get_free_pages() can only
+ * This function is similar to alloc_pages(), except that it allocates the
+ * minimum number of pages to satisfy the request.  alloc_pages() can only
  * allocate memory in power-of-two pages.
  *
  * This function is also limited by MAX_ORDER.
  *
  * Memory allocated by this function must be released by free_pages_exact().
  */
-void *get_free_pages_exact(gfp_t gfp_mask, size_t size)
+struct page *__alloc_pages_exact(gfp_t gfp_mask, size_t size)
 {
 	unsigned int order = get_order(size);
-	unsigned long addr;
+	struct page *page;
 
-	addr = __get_free_pages(gfp_mask, order);
-	if (addr) {
-		unsigned long alloc_end = addr + (PAGE_SIZE << order);
-		unsigned long used = addr + PAGE_ALIGN(size);
+	page = alloc_pages(gfp_mask, order);
+	if (page) {
+		struct page *alloc_end = page + (1 << order);
+		struct page *used = page + PAGE_ALIGN(size)/PAGE_SIZE;
 
-		split_page(virt_to_page((void *)addr), order);
+		split_page(page, order);
 		while (used < alloc_end) {
-			free_page(used);
-			used += PAGE_SIZE;
+			__free_page(used);
+			used++;
 		}
 	}
 
-	return (void *)addr;
+	return page;
+}
+EXPORT_SYMBOL(__alloc_pages_exact);
+
+/**
+ * __free_pages_exact - release memory allocated via __alloc_pages_exact()
+ * @virt: the value returned by alloc_pages_exact().
+ * @size: size of allocation, same value as passed to __alloc_pages_exact().
+ *
+ * Release the memory allocated by a previous call to __alloc_pages_exact().
+ */
+void __free_pages_exact(struct page *page, size_t size)
+{
+	struct page *end = page + PAGE_ALIGN(size)/PAGE_SIZE;
+
+	while (page < end) {
+		__free_page(page);
+		page++;
+	}
+}
+EXPORT_SYMBOL(__free_pages_exact);
+
+/**
+ * get_free_pages_exact - allocate an exact number physically-contiguous pages.
+ * @gfp_mask: GFP flags for the allocation
+ * @size: the number of bytes to allocate
+ * returns: virtual address of allocated memory
+ *
+ * This function is similar to __get_free_pages(), except that it allocates the
+ * minimum number of pages to satisfy the request.  get_free_pages() can only
+ * allocate memory in power-of-two pages.
+ *
+ * This function is also limited by MAX_ORDER.
+ *
+ * Memory allocated by this function must be released by free_pages_exact().
+ */
+void *get_free_pages_exact(gfp_t gfp_mask, size_t size)
+{
+	struct page *page;
+
+	/* If we are using page_address(), we can not allow highmem */
+	VM_BUG_ON((gfp_mask & __GFP_HIGHMEM) != 0);
+
+	page = __alloc_pages_exact(gfp_mask, size);
+	if (page)
+		return (void *) page_address(page);
+	return NULL;
 }
 EXPORT_SYMBOL(get_free_pages_exact);
 
@@ -2360,13 +2407,7 @@ EXPORT_SYMBOL(get_free_pages_exact);
  */
 void free_pages_exact(void *virt, size_t size)
 {
-	unsigned long addr = (unsigned long)virt;
-	unsigned long end = addr + PAGE_ALIGN(size);
-
-	while (addr < end) {
-		free_page(addr);
-		addr += PAGE_SIZE;
-	}
+	__free_pages_exact(virt_to_page(virt), size);
 }
 EXPORT_SYMBOL(free_pages_exact);
 
diff -puN kernel/profile.c~make_new_alloc_pages_exact kernel/profile.c
--- linux-2.6.git/kernel/profile.c~make_new_alloc_pages_exact	2011-04-07 08:41:08.166387016 -0700
+++ linux-2.6.git-dave/kernel/profile.c	2011-04-07 09:42:16.393582339 -0700
@@ -121,8 +121,8 @@ int __ref profile_init(void)
 	if (prof_buffer)
 		return 0;
 
-	prof_buffer = get_free_pages_exact(buffer_bytes,
-					GFP_KERNEL|__GFP_ZERO|__GFP_NOWARN);
+	prof_buffer = get_free_pages_exact(GFP_KERNEL|__GFP_ZERO|__GFP_NOWARN,
+						buffer_bytes);
 	if (prof_buffer)
 		return 0;
 
diff -puN mm/swapfile.c~make_new_alloc_pages_exact mm/swapfile.c
diff -L git -puN /dev/null /dev/null
diff -puN include/linux/page-flags.h~make_new_alloc_pages_exact include/linux/page-flags.h
diff -puN drivers/video/pxafb.c~make_new_alloc_pages_exact drivers/video/pxafb.c
--- linux-2.6.git/drivers/video/pxafb.c~make_new_alloc_pages_exact	2011-04-07 09:42:40.805576050 -0700
+++ linux-2.6.git-dave/drivers/video/pxafb.c	2011-04-07 09:44:02.357555082 -0700
@@ -905,8 +905,8 @@ static int __devinit pxafb_overlay_map_v
 	/* We assume that user will use at most video_mem_size for overlay fb,
 	 * anyway, it's useless to use 16bpp main plane and 24bpp overlay
 	 */
-	ofb->video_mem = get_free_pages_exact(PAGE_ALIGN(pxafb->video_mem_size),
-		GFP_KERNEL | __GFP_ZERO);
+	ofb->video_mem = get_free_pages_exact(GFP_KERNEL | __GFP_ZERO,
+				PAGE_ALIGN(pxafb->video_mem_size));
 	if (ofb->video_mem == NULL)
 		return -ENOMEM;
 
_
