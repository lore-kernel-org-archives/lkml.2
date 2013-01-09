Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934232Ab3AIUql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:46:41 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50420 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934194Ab3AIUng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:43:36 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-tegra@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: [PATCH 05/14] lib: Add I/O map cache implementation
Date: Wed,  9 Jan 2013 21:43:05 +0100
Message-Id: <1357764194-12677-6-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:G0jeGaixW1tLbo/Tz0Sgk0bMX1mc5nLMloVj+6p77IA
 GstWEp5ZU3blgU7dDnxsnAzWNhlnwye4Re+RtP3Y7cdHsw2LXO
 g+5WOhlJtMb+otDwgqiyxIWLIByU0YrsqYgySIWyWK3yzNv9g/
 yI5cHZEBF7rrYPuZX5Wi1pploI0lKskYMDOAxMRVxZ1chkFUis
 RmpsXgl8VOUxk3mPc/7WRvFr3PTNo3MbXJ4CxalycNqOWnD6o0
 1AmgjizzTBI2U9obwZ81jFAdzIswD+j6ZzPkBeG2pO5dXVUG6m
 vvqdNPuYp73PCqabKU92NGnIWlWIXlw4PVwstRBYH2Qi2bL4bv
 hlVTUtswfyiYjp0XbMw1K2nIAfxJUe7/NmJ9Ku85LYktuBcxJm
 2fYAbv1uX6DRcLu7VlyROJ2X8VOHr+W5Xx+S50/wA0pkRTUb63
 fI53y
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The I/O map cache is used to map large regions of physical memory in
smaller chunks to avoid running out of vmalloc()/ioremap() space.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 include/linux/io.h |  12 +++
 lib/ioremap.c      | 266 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 278 insertions(+)

diff --git a/include/linux/io.h b/include/linux/io.h
index 069e407..c5d296c 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -76,4 +76,16 @@ void devm_ioremap_release(struct device *dev, void *res);
 #define arch_has_dev_port()     (1)
 #endif
 
+struct iomap_cache;
+struct resource;
+
+struct iomap_cache *iomap_cache_create(const struct resource *region);
+void iomap_cache_free(struct iomap_cache *cache);
+void __iomem *iomap_cache_map(struct iomap_cache *cache, unsigned long offset);
+void iomap_cache_unmap(struct iomap_cache *cache, void __iomem *addr);
+
+struct iomap_cache *devm_iomap_cache_create(struct device *dev,
+					    const struct resource *region);
+void devm_iomap_cache_free(struct device *dev, struct iomap_cache *cache);
+
 #endif /* _LINUX_IO_H */
diff --git a/lib/ioremap.c b/lib/ioremap.c
index 0c9216c..8a13d97 100644
--- a/lib/ioremap.c
+++ b/lib/ioremap.c
@@ -5,11 +5,16 @@
  *
  * (C) Copyright 1995 1996 Linus Torvalds
  */
+
+#include <linux/device.h>
+#include <linux/err.h>
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/io.h>
+#include <linux/ioport.h>
 #include <linux/export.h>
+#include <linux/slab.h>
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 
@@ -92,3 +97,264 @@ int ioremap_page_range(unsigned long addr,
 	return err;
 }
 EXPORT_SYMBOL_GPL(ioremap_page_range);
+
+/**
+ * struct iomap_cache_page - page in an I/O map cache
+ * @region: subregion mapped by the page
+ * @list: chain in cache list
+ * @virt: virtual address of mapped region
+ */
+struct iomap_cache_page {
+	struct resource *region;
+	struct list_head list;
+	void __iomem *virt;
+};
+
+static struct iomap_cache_page *iomap_cache_page_create(void)
+{
+	struct iomap_cache_page *page;
+
+	page = kzalloc(sizeof(*page), GFP_KERNEL);
+	if (!page)
+		return NULL;
+
+	INIT_LIST_HEAD(&page->list);
+
+	return page;
+}
+
+static void iomap_cache_page_unmap(struct iomap_cache_page *page)
+{
+	release_resource(page->region);
+	page->region = NULL;
+
+	iounmap(page->virt);
+	page->virt = NULL;
+}
+
+static void iomap_cache_page_free(struct iomap_cache_page *page)
+{
+	iomap_cache_page_unmap(page);
+	list_del(&page->list);
+	kfree(page);
+}
+
+/**
+ * struct iomap_cache - cache of I/O mapped pages
+ * @region: region mapped by the cache
+ * @pages: list of pages in the cache
+ * @num_pages: number of pages in the cache
+ * @max_pages: maximum number of pages that the cache can map simultaneously
+ */
+struct iomap_cache {
+	struct resource region;
+	struct list_head pages;
+	unsigned int num_pages;
+	unsigned int max_pages;
+};
+
+/**
+ * iomap_cache_create() - create an I/O map cache
+ * @region: memory region to map
+ *
+ * Returns a new I/O map cache that can be used to map the given region on a
+ * page by page basis. On failure, a negative error code is returned.
+ */
+struct iomap_cache *iomap_cache_create(const struct resource *region)
+{
+	struct iomap_cache *cache;
+
+	cache = kzalloc(sizeof(*cache), GFP_KERNEL);
+	if (!cache)
+		return ERR_PTR(-ENOMEM);
+
+	memcpy(&cache->region, region, sizeof(*region));
+	INIT_LIST_HEAD(&cache->pages);
+	cache->num_pages = 0;
+	cache->max_pages = 1;
+
+	return cache;
+}
+
+/**
+ * iomap_cache_free() - free an I/O map cache
+ * @cache: I/O map cache
+ */
+void iomap_cache_free(struct iomap_cache *cache)
+{
+	struct iomap_cache_page *page, *tmp;
+
+	if (!cache)
+		return;
+
+	list_for_each_entry_safe(page, tmp, &cache->pages, list)
+		iomap_cache_page_free(page);
+
+	kfree(cache);
+}
+
+/**
+ * iomap_cache_map() - map a given offset in the cache's region
+ * @cache: I/O map cache
+ * @offset: offset into the cache's region of the address to map
+ *
+ * Returns the virtual address of mapped offset into the cache's region or
+ * NULL if the offset is outside of the region or if not enough memory is
+ * available to map the page.
+ */
+void __iomem *iomap_cache_map(struct iomap_cache *cache, unsigned long offset)
+{
+	struct iomap_cache_page *page;
+	struct resource *region;
+	unsigned long phys;
+
+	if (!cache || offset >= resource_size(&cache->region))
+		return NULL;
+
+	phys = cache->region.start + (offset & PAGE_MASK);
+
+	list_for_each_entry(page, &cache->pages, list) {
+		resource_size_t start, end;
+
+		if (!page->region || !page->virt)
+			continue;
+
+		start = page->region->start - cache->region.start;
+		end = page->region->end - cache->region.start;
+
+		/* address is within an already mapped page */
+		if (offset >= start && offset <= end) {
+			/* move page to end of the LRU list */
+			list_del_init(&page->list);
+			list_add_tail(&page->list, &cache->pages);
+			goto out;
+		}
+	}
+
+	/* find an unmapped page */
+	list_for_each_entry(page, &cache->pages, list) {
+		if (!page->region || !page->virt) {
+			list_del_init(&page->list);
+			break;
+		}
+	}
+
+	/* no unmapped page found */
+	if (&page->list == &cache->pages) {
+		/* add a new page if more space is available */
+		if (cache->num_pages < cache->max_pages) {
+			page = iomap_cache_page_create();
+			if (!page)
+				return NULL;
+
+			cache->num_pages++;
+		} else {
+			/*
+			 * If all pages are in use and there's no space left
+			 * for a new one, evict the first page in the list.
+			 */
+			page = list_first_entry(&cache->pages,
+						struct iomap_cache_page,
+						list);
+			iomap_cache_page_unmap(page);
+			list_del_init(&page->list);
+		}
+	}
+
+	/* insert page at the end of the LRU list */
+	list_add_tail(&page->list, &cache->pages);
+
+	region = __request_region(&cache->region, phys, PAGE_SIZE, NULL,
+				  cache->region.flags);
+	if (!region)
+		return NULL;
+
+	page->virt = ioremap(region->start, resource_size(region));
+	if (!page->virt) {
+		release_resource(region);
+		return NULL;
+	}
+
+	page->region = region;
+
+out:
+	return page->virt + (offset & ~PAGE_MASK);
+}
+
+/**
+ * iomap_cache_unmap() - remove a mapping from the cache
+ * @cache: I/O map cache
+ * @addr: virtual address of the mapping to remove
+ */
+void iomap_cache_unmap(struct iomap_cache *cache, void __iomem *addr)
+{
+	struct iomap_cache_page *page;
+
+	if (!cache)
+		return;
+
+	list_for_each_entry(page, &cache->pages, list) {
+		if (page->virt == addr) {
+			iomap_cache_page_unmap(page);
+			break;
+		}
+	}
+}
+
+static void devm_iomap_cache_release(struct device *dev, void *res)
+{
+	iomap_cache_free(*(struct iomap_cache **)res);
+}
+
+static int devm_iomap_cache_match(struct device *dev, void *res, void *data)
+{
+	struct iomap_cache **p = res;
+
+	if (WARN_ON(!p || !*p))
+		return 0;
+
+	return *p == data;
+}
+
+/**
+ * devm_iomap_cache_create() - create an I/O map cache
+ * @dev: device to attach this I/O map cache to
+ * @region: memory region to map
+ *
+ * Returns a new I/O map cache that can be used to map the given region on a
+ * page by page basis. On failure, a negative error code is returned.
+ *
+ * This function is a device-managed version of iomap_cache_create() which
+ * will automatically be freed when the device disappears.
+ */
+struct iomap_cache *devm_iomap_cache_create(struct device *dev,
+					    const struct resource *region)
+{
+	struct iomap_cache **ptr, *cache;
+
+	ptr = devres_alloc(devm_iomap_cache_release, sizeof(**ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	cache = iomap_cache_create(region);
+	if (IS_ERR(cache)) {
+		devres_free(ptr);
+		return cache;
+	}
+
+	*ptr = cache;
+	devres_add(dev, ptr);
+
+	return cache;
+}
+
+/**
+ * devm_iomap_cache_free() - free an I/O map cache
+ * @dev: device that this I/O map cached was attached to
+ * @cache: I/O map cache
+ */
+void devm_iomap_cache_free(struct device *dev, struct iomap_cache *cache)
+{
+	WARN_ON(devres_release(dev, devm_iomap_cache_release,
+			       devm_iomap_cache_match, cache));
+}
-- 
1.8.1

