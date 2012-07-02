Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117Ab2GBVQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 17:16:51 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45630 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209Ab2GBVQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 17:16:50 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] zsmalloc: remove x86 dependency
Date: Mon,  2 Jul 2012 16:15:49 -0500
Message-Id: <1341263752-10210-2-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070221-5806-0000-0000-000016E6E300
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the page table assisted object mapping
method, which has x86 dependencies, with a arch-independent
method that does a simple copy into a temporary per-cpu
buffer.

While a copy seems like it would be worse than mapping the pages,
tests demonstrate the copying is always faster and, in the case of
running inside a KVM guest, roughly 4x faster.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zsmalloc/Kconfig         |    4 --
 drivers/staging/zsmalloc/zsmalloc-main.c |   99 +++++++++++++++++++++---------
 drivers/staging/zsmalloc/zsmalloc_int.h  |    5 +-
 3 files changed, 72 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/zsmalloc/Kconfig b/drivers/staging/zsmalloc/Kconfig
index a5ab720..9084565 100644
--- a/drivers/staging/zsmalloc/Kconfig
+++ b/drivers/staging/zsmalloc/Kconfig
@@ -1,9 +1,5 @@
 config ZSMALLOC
 	tristate "Memory allocator for compressed pages"
-	# X86 dependency is because of the use of __flush_tlb_one and set_pte
-	# in zsmalloc-main.c.
-	# TODO: convert these to portable functions
-	depends on X86
 	default n
 	help
 	  zsmalloc is a slab-based memory allocator designed to store
diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 10b0d60..a7a6f22 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -470,6 +470,57 @@ static struct page *find_get_zspage(struct size_class *class)
 	return page;
 }
 
+static void zs_copy_map_object(char *buf, struct page *firstpage,
+				int off, int size)
+{
+	struct page *pages[2];
+	int sizes[2];
+	void *addr;
+
+	pages[0] = firstpage;
+	pages[1] = get_next_page(firstpage);
+	BUG_ON(!pages[1]);
+
+	sizes[0] = PAGE_SIZE - off;
+	sizes[1] = size - sizes[0];
+
+	/* disable page faults to match kmap_atomic() return conditions */
+	pagefault_disable();
+
+	/* copy object to per-cpu buffer */
+	addr = kmap_atomic(pages[0]);
+	memcpy(buf, addr + off, sizes[0]);
+	kunmap_atomic(addr);
+	addr = kmap_atomic(pages[1]);
+	memcpy(buf + sizes[0], addr, sizes[1]);
+	kunmap_atomic(addr);
+}
+
+static void zs_copy_unmap_object(char *buf, struct page *firstpage,
+				int off, int size)
+{
+	struct page *pages[2];
+	int sizes[2];
+	void *addr;
+
+	pages[0] = firstpage;
+	pages[1] = get_next_page(firstpage);
+	BUG_ON(!pages[1]);
+
+	sizes[0] = PAGE_SIZE - off;
+	sizes[1] = size - sizes[0];
+
+	/* copy per-cpu buffer to object */
+	addr = kmap_atomic(pages[0]);
+	memcpy(addr + off, buf, sizes[0]);
+	kunmap_atomic(addr);
+	addr = kmap_atomic(pages[1]);
+	memcpy(addr, buf + sizes[0], sizes[1]);
+	kunmap_atomic(addr);
+
+	/* enable page faults to match kunmap_atomic() return conditions */
+	pagefault_enable();
+}
 
 static int zs_cpu_notifier(struct notifier_block *nb, unsigned long action,
 				void *pcpu)
@@ -480,18 +531,23 @@ static int zs_cpu_notifier(struct notifier_block *nb, unsigned long action,
 	switch (action) {
 	case CPU_UP_PREPARE:
 		area = &per_cpu(zs_map_area, cpu);
-		if (area->vm)
-			break;
-		area->vm = alloc_vm_area(2 * PAGE_SIZE, area->vm_ptes);
-		if (!area->vm)
-			return notifier_from_errno(-ENOMEM);
+		/*
+		 * Make sure we don't leak memory if a cpu UP notification
+		 * and zs_init() race and both call zs_cpu_up() on the same cpu
+		 */
+		if (area->vm_buf)
+			return 0;
+		area->vm_buf = (char *)__get_free_page(GFP_KERNEL);
+		if (!area->vm_buf)
+			return -ENOMEM;
+		return 0;
 		break;
 	case CPU_DEAD:
 	case CPU_UP_CANCELED:
 		area = &per_cpu(zs_map_area, cpu);
-		if (area->vm)
-			free_vm_area(area->vm);
-		area->vm = NULL;
+		if (area->vm_buf)
+			free_page((unsigned long)area->vm_buf);
+		area->vm_buf = NULL;
 		break;
 	}
 
@@ -714,22 +770,11 @@ void *zs_map_object(struct zs_pool *pool, unsigned long handle)
 	if (off + class->size <= PAGE_SIZE) {
 		/* this object is contained entirely within a page */
 		area->vm_addr = kmap_atomic(page);
-	} else {
-		/* this object spans two pages */
-		struct page *nextp;
-
-		nextp = get_next_page(page);
-		BUG_ON(!nextp);
-
-
-		set_pte(area->vm_ptes[0], mk_pte(page, PAGE_KERNEL));
-		set_pte(area->vm_ptes[1], mk_pte(nextp, PAGE_KERNEL));
-
-		/* We pre-allocated VM area so mapping can never fail */
-		area->vm_addr = area->vm->addr;
+		return area->vm_addr + off;
 	}
 
-	return area->vm_addr + off;
+	zs_copy_map_object(area->vm_buf, page, off, class->size);
+	return area->vm_buf;
 }
 EXPORT_SYMBOL_GPL(zs_map_object);
 
@@ -751,14 +796,10 @@ void zs_unmap_object(struct zs_pool *pool, unsigned long handle)
 	off = obj_idx_to_offset(page, obj_idx, class->size);
 
 	area = &__get_cpu_var(zs_map_area);
-	if (off + class->size <= PAGE_SIZE) {
+	if (off + class->size <= PAGE_SIZE)
 		kunmap_atomic(area->vm_addr);
-	} else {
-		set_pte(area->vm_ptes[0], __pte(0));
-		set_pte(area->vm_ptes[1], __pte(0));
-		__flush_tlb_one((unsigned long)area->vm_addr);
-		__flush_tlb_one((unsigned long)area->vm_addr + PAGE_SIZE);
-	}
+	else
+		zs_copy_unmap_object(area->vm_buf, page, off, class->size);
 	put_cpu_var(zs_map_area);
 }
 EXPORT_SYMBOL_GPL(zs_unmap_object);
diff --git a/drivers/staging/zsmalloc/zsmalloc_int.h b/drivers/staging/zsmalloc/zsmalloc_int.h
index 6fd32a9..f760dae 100644
--- a/drivers/staging/zsmalloc/zsmalloc_int.h
+++ b/drivers/staging/zsmalloc/zsmalloc_int.h
@@ -110,9 +110,8 @@ enum fullness_group {
 static const int fullness_threshold_frac = 4;
 
 struct mapping_area {
-	struct vm_struct *vm;
-	pte_t *vm_ptes[2];
-	char *vm_addr;
+	char *vm_buf; /* copy buffer for objects that span pages */
+	char *vm_addr; /* address of kmap_atomic()'ed pages */
 };
 
 struct size_class {
-- 
1.7.9.5

