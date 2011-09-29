Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857Ab1I2UeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:34:25 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45077 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757625Ab1I2UeV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:34:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, thellstrom@vmware.com,
        dri-devel@lists.freedesktop.org, bskeggs@redhat.com,
        j.glisse@redhat.com, thomas@shipmail.org, airlied@redhat.com,
        airlied@linux.ie, alexdeucher@gmail.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5/9] ttm: Provide a DMA aware TTM page pool code.
Date: Thu, 29 Sep 2011 16:33:48 -0400
Message-Id: <1317328432-25620-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317328432-25620-1-git-send-email-konrad.wilk@oracle.com>
References: <1317328432-25620-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E84D63E.0192:SCFMA922111,ss=1,re=-6.601,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In TTM world the pages for the graphic drivers are kept in three different
pools: write combined, uncached, and cached (write-back). When the pages
are used by the graphic driver the graphic adapter via its built in MMU
(or AGP) programs these pages in. The programming requires the virtual address
(from the graphic adapter perspective) and the physical address (either System RAM
or the memory on the card) which is obtained using the pci_map_* calls (which does the
virtual to physical - or bus address translation). During the graphic application's
"life" those pages can be shuffled around, swapped out to disk, moved from the
VRAM to System RAM or vice-versa. This all works with the existing TTM pool code
- except when we want to use the software IOTLB (SWIOTLB) code to "map" the physical
addresses to the graphic adapter MMU. We end up programming the bounce buffer's
physical address instead of the TTM pool memory's and get a non-worky driver.
There are two solutions:
1) using the DMA API to allocate pages that are screened by the DMA API, or
2) using the pci_sync_* calls to copy the pages from the bounce-buffer and back.

This patch fixes the issue by allocating pages using the DMA API. The second
is a viable option - but it has performance drawbacks and potential correctness
issues - think of the write cache page being bounced (SWIOTLB->TTM), the
WC is set on the TTM page and the copy from SWIOTLB not making it to the TTM
page until the page has been recycled in the pool (and used by another application).

The bounce buffer does not get activated often - only in cases where we have
a 32-bit capable card and we want to use a page that is allocated above the
4GB limit. The bounce buffer offers the solution of copying the contents
of that 4GB page to an location below 4GB and then back when the operation has been
completed (or vice-versa). This is done by using the 'pci_sync_*' calls.
Note: If you look carefully enough in the existing TTM page pool code you will
notice the GFP_DMA32 flag is used  - which should guarantee that the provided page
is under 4GB. It certainly is the case, except this gets ignored in two cases:
 - If user specifies 'swiotlb=force' which bounces _every_ page.
 - If user is using a Xen's PV Linux guest (which uses the SWIOTLB and the
   underlaying PFN's aren't necessarily under 4GB).

To not have this extra copying done the other option is to allocate the pages
using the DMA API so that there is not need to map the page and perform the
expensive 'pci_sync_*' calls.

This DMA API capable TTM pool requires for this the 'struct device' to
properly call the DMA API. It also has to track the virtual and bus address of
the page being handed out in case it ends up being swapped out or de-allocated -
to make sure it is de-allocated using the proper's 'struct device'.

Implementation wise the code keeps two lists: one that is attached to the
'struct device' (via the dev->dma_pools list) and a global one to be used when
the 'struct device' is unavailable (think shrinker code). The global list can
iterate over all of the 'struct device' and its associated dma_pool. The list
in dev->dma_pools can only iterate the device's dma_pool.
                                                            /[struct device_pool]\
        /---------------------------------------------------| dev                |
       /                                            +-------| dma_pool           |
 /-----+------\                                    /        \--------------------/
 |struct device|     /-->[struct dma_pool for WC]</         /[struct device_pool]\
 | dma_pools   +----+                                     /-| dev                |
 |  ...        |    \--->[struct dma_pool for uncached]<-/--| dma_pool           |
 \-----+------/                                         /   \--------------------/
        \----------------------------------------------/
[Two pools associated with the device (WC and UC), and the parallel list
containing the 'struct dev' and 'struct dma_pool' entries]

The maximum amount of dma pools a device can have is six: write-combined,
uncached, and cached; then there are the DMA32 variants which are:
write-combined dma32, uncached dma32, and cached dma32.

Currently this code only gets activated when any variant of the SWIOTLB IOMMU
code is running (Intel without VT-d, AMD without GART, IBM Calgary and Xen PV
with PCI devices).

Tested-by: Michel Dänzer <michel@daenzer.net>
[v1: Using swiotlb_nr_tbl instead of swiotlb_enabled]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/ttm/Makefile             |    3 +
 drivers/gpu/drm/ttm/ttm_memory.c         |    2 +
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c | 1313 ++++++++++++++++++++++++++++++
 include/drm/ttm/ttm_page_alloc.h         |   32 +-
 4 files changed, 1346 insertions(+), 4 deletions(-)
 create mode 100644 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c

diff --git a/drivers/gpu/drm/ttm/Makefile b/drivers/gpu/drm/ttm/Makefile
index f3cf6f0..8300bc0 100644
--- a/drivers/gpu/drm/ttm/Makefile
+++ b/drivers/gpu/drm/ttm/Makefile
@@ -7,4 +7,7 @@ ttm-y := ttm_agp_backend.o ttm_memory.o ttm_tt.o ttm_bo.o \
 	ttm_object.o ttm_lock.o ttm_execbuf_util.o ttm_page_alloc.o \
 	ttm_bo_manager.o
 
+ifeq ($(CONFIG_SWIOTLB),y)
+ttm-y += ttm_page_alloc_dma.o
+endif
 obj-$(CONFIG_DRM_TTM) += ttm.o
diff --git a/drivers/gpu/drm/ttm/ttm_memory.c b/drivers/gpu/drm/ttm/ttm_memory.c
index c7d97a5..57323fe 100644
--- a/drivers/gpu/drm/ttm/ttm_memory.c
+++ b/drivers/gpu/drm/ttm/ttm_memory.c
@@ -397,6 +397,8 @@ int ttm_mem_global_init(struct ttm_mem_global *glob)
 		       zone->name, (unsigned long long) zone->max_mem >> 10);
 	}
 	ttm_page_alloc = &ttm_page_alloc_default;
+	if (ttm_page_alloc_need_dma())
+		printk(KERN_INFO TTM_PFX "Using DMA aware pool.\n");
 	ttm_page_alloc_init(glob, glob->zone_kernel->max_mem/(2*PAGE_SIZE));
 	return 0;
 out_no_zone:
diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
new file mode 100644
index 0000000..5a5739c
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
@@ -0,0 +1,1313 @@
+/*
+ * Copyright 2011 (c) Oracle Corp.
+
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sub license,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+ */
+
+/*
+ * A simple DMA pool losely based on dmapool.c. It has certain advantages
+ * over the DMA pools:
+ * - Pool collects resently freed pages for reuse (and hooks up to
+ *   the shrinker).
+ * - Tracks currently in use pages
+ * - Tracks whether the page is UC, WB or cached (and reverts to WB
+ *   when freed).
+ */
+
+#include <linux/dma-mapping.h>
+#include <linux/list.h>
+#include <linux/seq_file.h> /* for seq_printf */
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/highmem.h>
+#include <linux/mm_types.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/atomic.h>
+#include <linux/device.h>
+#include <linux/kthread.h>
+#include "ttm/ttm_bo_driver.h"
+#include "ttm/ttm_page_alloc.h"
+#ifdef TTM_HAS_AGP
+#include <asm/agp.h>
+#endif
+
+#define NUM_PAGES_TO_ALLOC		(PAGE_SIZE/sizeof(struct page *))
+#define SMALL_ALLOCATION		16
+#define FREE_ALL_PAGES			(~0U)
+/* times are in msecs */
+#define IS_UNDEFINED			(0)
+#define IS_WC				(1<<1)
+#define IS_UC				(1<<2)
+#define IS_CACHED			(1<<3)
+#define IS_DMA32			(1<<4)
+
+enum pool_type {
+	POOL_IS_UNDEFINED,
+	POOL_IS_WC = IS_WC,
+	POOL_IS_UC = IS_UC,
+	POOL_IS_CACHED = IS_CACHED,
+	POOL_IS_WC_DMA32 = IS_WC | IS_DMA32,
+	POOL_IS_UC_DMA32 = IS_UC | IS_DMA32,
+	POOL_IS_CACHED_DMA32 = IS_CACHED | IS_DMA32,
+};
+/*
+ * The pool structure. There are usually six pools:
+ *  - generic (not restricted to DMA32):
+ *      - write combined, uncached, cached.
+ *  - dma32 (up to 2^32 - so up 4GB):
+ *      - write combined, uncached, cached.
+ * for each 'struct device'. The 'cached' is for pages that are actively used.
+ * The other ones can be shrunk by the shrinker API if neccessary.
+ * @pools: The 'struct device->dma_pools' link.
+ * @type: Type of the pool
+ * @lock: Protects the page_list from concurrnet access. Must be used with
+ * irqsave/irqrestore variants because pool allocator maybe called from
+ * delayed work.
+ * @page_list: Pool of all pages (both in use and free).
+ * @dev: The device that is associated with these pools.
+ * @size: Size used during DMA allocation.
+ * @npages_free: Count of available pages for re-use.
+ * @npages_in_use: Count of pages that are in use (each of them
+ *   is marked in_use.
+ * @nfrees: Stats when pool is shrinking.
+ * @nrefills: Stats when the pool is grown.
+ * @gfp_flags: Flags to pass for alloc_page.
+ * @name: Name of the pool.
+ * @dev_name: Name derieved from dev - similar to how dev_info works.
+ *   Used during shutdown as the dev_info during release is unavailable.
+ */
+struct dma_pool {
+	struct list_head pools; /* The 'struct device->dma_pools link */
+	enum pool_type type;
+	spinlock_t lock;
+	struct list_head page_list;
+	struct device *dev;
+	unsigned size;
+	unsigned npages_free;
+	unsigned npages_in_use;
+	unsigned long nfrees; /* Stats when shrunk. */
+	unsigned long nrefills; /* Stats when grown. */
+	gfp_t gfp_flags;
+	char name[13]; /* "cached dma32" */
+	char dev_name[64]; /* Constructed from dev */
+};
+
+/*
+ * The accounting page keeping track of the allocated page along with
+ * the DMA address.
+ * @page_list: The link to the 'page_list' in 'struct dma_pool'.
+ * @vaddr: The virtual address of the page
+ * @dma: The bus address of the page. If the page is not allocated
+ *   via the DMA API, it will be -1.
+ * @in_use: Set to true if in use. Should not be freed.
+ */
+struct dma_page {
+	struct list_head page_list;
+	void *vaddr;
+	dma_addr_t dma;
+	unsigned int in_use:1;
+};
+
+/*
+ * Limits for the pool. They are handled without locks because only place where
+ * they may change is in sysfs store. They won't have immediate effect anyway
+ * so forcing serialization to access them is pointless.
+ */
+
+struct ttm_pool_opts {
+	unsigned	alloc_size;
+	unsigned	max_size;
+	unsigned	small;
+};
+
+/*
+ * Contains the list of all of the 'struct device' and their corresponding
+ * DMA pools. Guarded by _mutex->lock.
+ * @pools: The link to 'struct ttm_pool_manager->pools'
+ * @dev: The 'struct device' associated with the 'pool'
+ * @pool: The 'struct dma_pool' associated with the 'dev'
+ */
+struct device_pools {
+	struct list_head pools;
+	struct device *dev;
+	struct dma_pool *pool;
+};
+
+/*
+ * struct ttm_pool_manager - Holds memory pools for fast allocation
+ *
+ * @lock: Lock used when adding/removing from pools
+ * @pools: List of 'struct device' and 'struct dma_pool' tuples.
+ * @options: Limits for the pool.
+ * @npools: Total amount of pools in existence.
+ * @shrinker: The structure used by [un|]register_shrinker
+ */
+struct ttm_pool_manager {
+	struct mutex		lock;
+	struct list_head	pools;
+	struct ttm_pool_opts	options;
+	unsigned		npools;
+	struct shrinker		mm_shrink;
+	struct kobject		kobj;
+};
+
+static struct ttm_pool_manager *_manager;
+
+static struct attribute ttm_page_pool_max = {
+	.name = "pool_max_size",
+	.mode = S_IRUGO | S_IWUSR
+};
+static struct attribute ttm_page_pool_small = {
+	.name = "pool_small_allocation",
+	.mode = S_IRUGO | S_IWUSR
+};
+static struct attribute ttm_page_pool_alloc_size = {
+	.name = "pool_allocation_size",
+	.mode = S_IRUGO | S_IWUSR
+};
+
+static struct attribute *ttm_pool_attrs[] = {
+	&ttm_page_pool_max,
+	&ttm_page_pool_small,
+	&ttm_page_pool_alloc_size,
+	NULL
+};
+
+static void ttm_pool_kobj_release(struct kobject *kobj)
+{
+	struct ttm_pool_manager *m =
+		container_of(kobj, struct ttm_pool_manager, kobj);
+	kfree(m);
+}
+
+static ssize_t ttm_pool_store(struct kobject *kobj, struct attribute *attr,
+			      const char *buffer, size_t size)
+{
+	struct ttm_pool_manager *m =
+		container_of(kobj, struct ttm_pool_manager, kobj);
+	int chars;
+	unsigned val;
+	chars = sscanf(buffer, "%u", &val);
+	if (chars == 0)
+		return size;
+
+	/* Convert kb to number of pages */
+	val = val / (PAGE_SIZE >> 10);
+
+	if (attr == &ttm_page_pool_max)
+		m->options.max_size = val;
+	else if (attr == &ttm_page_pool_small)
+		m->options.small = val;
+	else if (attr == &ttm_page_pool_alloc_size) {
+		if (val > NUM_PAGES_TO_ALLOC*8) {
+			printk(KERN_ERR TTM_PFX
+			       "Setting allocation size to %lu "
+			       "is not allowed. Recommended size is "
+			       "%lu\n",
+			       NUM_PAGES_TO_ALLOC*(PAGE_SIZE >> 7),
+			       NUM_PAGES_TO_ALLOC*(PAGE_SIZE >> 10));
+			return size;
+		} else if (val > NUM_PAGES_TO_ALLOC) {
+			printk(KERN_WARNING TTM_PFX
+			       "Setting allocation size to "
+			       "larger than %lu is not recommended.\n",
+			       NUM_PAGES_TO_ALLOC*(PAGE_SIZE >> 10));
+		}
+		m->options.alloc_size = val;
+	}
+
+	return size;
+}
+
+static ssize_t ttm_pool_show(struct kobject *kobj, struct attribute *attr,
+			     char *buffer)
+{
+	struct ttm_pool_manager *m =
+		container_of(kobj, struct ttm_pool_manager, kobj);
+	unsigned val = 0;
+
+	if (attr == &ttm_page_pool_max)
+		val = m->options.max_size;
+	else if (attr == &ttm_page_pool_small)
+		val = m->options.small;
+	else if (attr == &ttm_page_pool_alloc_size)
+		val = m->options.alloc_size;
+
+	val = val * (PAGE_SIZE >> 10);
+
+	return snprintf(buffer, PAGE_SIZE, "%u\n", val);
+}
+
+static const struct sysfs_ops ttm_pool_sysfs_ops = {
+	.show = &ttm_pool_show,
+	.store = &ttm_pool_store,
+};
+
+static struct kobj_type ttm_pool_kobj_type = {
+	.release = &ttm_pool_kobj_release,
+	.sysfs_ops = &ttm_pool_sysfs_ops,
+	.default_attrs = ttm_pool_attrs,
+};
+
+#ifndef CONFIG_X86
+static int set_pages_array_wb(struct page **pages, int addrinarray)
+{
+#ifdef TTM_HAS_AGP
+	int i;
+
+	for (i = 0; i < addrinarray; i++)
+		unmap_page_from_agp(pages[i]);
+#endif
+	return 0;
+}
+
+static int set_pages_array_wc(struct page **pages, int addrinarray)
+{
+#ifdef TTM_HAS_AGP
+	int i;
+
+	for (i = 0; i < addrinarray; i++)
+		map_page_into_agp(pages[i]);
+#endif
+	return 0;
+}
+
+static int set_pages_array_uc(struct page **pages, int addrinarray)
+{
+#ifdef TTM_HAS_AGP
+	int i;
+
+	for (i = 0; i < addrinarray; i++)
+		map_page_into_agp(pages[i]);
+#endif
+	return 0;
+}
+#endif /* for !CONFIG_X86 */
+
+static int ttm_set_pages_caching(struct dma_pool *pool,
+				 struct page **pages, unsigned cpages)
+{
+	int r = 0;
+	/* Set page caching */
+	if (pool->type & IS_UC) {
+		r = set_pages_array_uc(pages, cpages);
+		if (r)
+			pr_err(TTM_PFX
+			       "%s: Failed to set %d pages to uc!\n",
+			       pool->dev_name, cpages);
+	}
+	if (pool->type & IS_WC) {
+		r = set_pages_array_wc(pages, cpages);
+		if (r)
+			pr_err(TTM_PFX
+			       "%s: Failed to set %d pages to wc!\n",
+			       pool->dev_name, cpages);
+	}
+	return r;
+}
+
+static void __ttm_dma_free_page(struct dma_pool *pool, struct dma_page *d_page)
+{
+	dma_addr_t dma = d_page->dma;
+
+	pr_debug("%s: (%s:%d) Freeing %p (%p) (DMA:0x%lx)\n",
+		pool->dev_name, pool->name, current->pid, d_page->vaddr,
+		virt_to_page(d_page->vaddr), (unsigned long)dma);
+
+	dma_free_coherent(pool->dev, pool->size, d_page->vaddr, dma);
+
+	kfree(d_page);
+	d_page = NULL;
+}
+static struct dma_page *__ttm_dma_alloc_page(struct dma_pool *pool)
+{
+	struct dma_page *d_page;
+
+	d_page = kmalloc(sizeof(struct dma_page), GFP_KERNEL);
+	if (!d_page)
+		return NULL;
+
+	d_page->vaddr = dma_alloc_coherent(pool->dev, pool->size,
+					   &d_page->dma,
+					   pool->gfp_flags);
+	if (d_page->vaddr) {
+		pr_debug("%s: (%s:%d) Allocated %p (%p) (DMA:0x%lx)\n",
+			pool->dev_name, pool->name, current->pid, d_page->vaddr,
+			virt_to_page(d_page->vaddr),
+			(unsigned long)d_page->dma);
+		d_page->in_use = 0;
+	} else {
+		kfree(d_page);
+		d_page = NULL;
+	}
+
+	return d_page;
+}
+static enum pool_type ttm_to_type(int flags, enum ttm_caching_state cstate)
+{
+	enum pool_type type = IS_UNDEFINED;
+
+	if (flags & TTM_PAGE_FLAG_DMA32)
+		type |= IS_DMA32;
+	if (cstate == tt_cached)
+		type |= IS_CACHED;
+	else if (cstate == tt_uncached)
+		type |= IS_UC;
+	else
+		type |= IS_WC;
+
+	return type;
+}
+static void ttm_pool_update_inuse(struct dma_pool *pool, unsigned count)
+{
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&pool->lock, irq_flags);
+	pool->npages_free += count;
+	pool->npages_in_use -= count;
+	spin_unlock_irqrestore(&pool->lock, irq_flags);
+}
+static void ttm_pool_update_free_locked(struct dma_pool *pool,
+					unsigned freed_pages)
+{
+	pool->npages_free -= freed_pages;
+	pool->nfrees += freed_pages;
+
+}
+/* set memory back to wb and free the pages. */
+static void ttm_dma_pages_put(struct dma_pool *pool, struct list_head *d_pages,
+			struct page *pages[], unsigned npages)
+{
+	struct dma_page *d_page, *tmp;
+
+	if (npages && set_pages_array_wb(pages, npages))
+		pr_err(TTM_PFX "%s: Failed to set %d pages to wb!\n",
+			pool->dev_name, npages);
+
+	pr_debug("%s: (%s:%d) Freeing %d pages at once.\n",
+		pool->dev_name, pool->name, current->pid, npages);
+
+	list_for_each_entry_safe(d_page, tmp, d_pages, page_list) {
+		list_del(&d_page->page_list);
+		__ttm_dma_free_page(pool, d_page);
+	}
+}
+/*
+ * Free pages from pool.
+ *
+ * To prevent hogging the ttm_swap process we only free NUM_PAGES_TO_ALLOC
+ * number of pages in one go.
+ *
+ * @pool: to free the pages from
+ * @nr_free: If set to true will free all pages in pool
+ **/
+static unsigned ttm_dma_page_pool_free(struct dma_pool *pool, unsigned nr_free)
+{
+	unsigned long irq_flags;
+	struct dma_page *dma_p, *tmp;
+	struct page **pages_to_free;
+	struct list_head d_pages;
+	unsigned freed_pages = 0,
+		 npages_to_free = nr_free;
+
+	if (NUM_PAGES_TO_ALLOC < nr_free)
+		npages_to_free = NUM_PAGES_TO_ALLOC;
+
+	pages_to_free = kmalloc(npages_to_free * sizeof(struct dma_page *),
+			GFP_KERNEL);
+
+	if (!pages_to_free) {
+		pr_err(TTM_PFX
+		       "%s: Failed to allocate memory for pool free operation.\n",
+			pool->dev_name);
+		return 0;
+	}
+	INIT_LIST_HEAD(&d_pages);
+restart:
+	spin_lock_irqsave(&pool->lock, irq_flags);
+	list_for_each_entry_safe_reverse(dma_p, tmp, &pool->page_list,
+					 page_list) {
+		if (freed_pages >= npages_to_free)
+			break;
+
+		if (dma_p->in_use)
+			continue;
+
+		pr_debug("%s: (%s:%d) %p (%p) (DMA:0x%lx) is expunged.\n",
+			pool->dev_name, pool->name, current->pid, dma_p->vaddr,
+			virt_to_page(dma_p->vaddr),
+			(unsigned long)dma_p->dma);
+
+		/* Move the dma_page from one list to another. */
+		list_del(&dma_p->page_list);
+		list_add(&dma_p->page_list, &d_pages);
+
+		pages_to_free[freed_pages++] = virt_to_page(dma_p->vaddr);
+		/* We can only remove NUM_PAGES_TO_ALLOC at a time. */
+		if (freed_pages >= NUM_PAGES_TO_ALLOC) {
+
+			ttm_pool_update_free_locked(pool, freed_pages);
+			/**
+			 * Because changing page caching is costly
+			 * we unlock the pool to prevent stalling.
+			 */
+			spin_unlock_irqrestore(&pool->lock, irq_flags);
+
+			ttm_dma_pages_put(pool, &d_pages, pages_to_free,
+				      freed_pages);
+
+			INIT_LIST_HEAD(&d_pages);
+
+			if (likely(nr_free != FREE_ALL_PAGES))
+				nr_free -= freed_pages;
+
+			if (NUM_PAGES_TO_ALLOC >= nr_free)
+				npages_to_free = nr_free;
+			else
+				npages_to_free = NUM_PAGES_TO_ALLOC;
+
+			freed_pages = 0;
+
+			/* free all so restart the processing */
+			if (nr_free)
+				goto restart;
+
+			/* Not allowed to fall tough or break because
+			 * following context is inside spinlock while we are
+			 * outside here.
+			 */
+			goto out;
+
+		}
+	}
+
+	/* remove range of pages from the pool */
+	if (freed_pages) {
+		ttm_pool_update_free_locked(pool, freed_pages);
+		nr_free -= freed_pages;
+	}
+
+	spin_unlock_irqrestore(&pool->lock, irq_flags);
+
+	if (freed_pages)
+		ttm_dma_pages_put(pool, &d_pages, pages_to_free, freed_pages);
+out:
+	kfree(pages_to_free);
+	return nr_free;
+}
+
+static void ttm_dma_free_pool(struct device *dev, enum pool_type type)
+{
+	struct device_pools *p;
+	struct dma_pool *pool;
+	struct dma_page *d_page, *d_tmp;
+
+	if (!dev)
+		return;
+
+	mutex_lock(&_manager->lock);
+	list_for_each_entry_reverse(p, &_manager->pools, pools) {
+		if (p->dev != dev)
+			continue;
+		pool = p->pool;
+		if (pool->type != type)
+			continue;
+		pr_debug("%s: (%s:%d) of device pool freed "\
+			"(has %d free, and %d in use).\n",
+			pool->dev_name, pool->name, current->pid,
+			pool->npages_free, pool->npages_in_use);
+		list_del(&p->pools);
+		kfree(p);
+		_manager->npools--;
+		break;
+	}
+	list_for_each_entry_reverse(pool, &dev->dma_pools, pools) {
+		unsigned long irq_save;
+		if (pool->type != type)
+			continue;
+		/* Takes a spinlock.. */
+		ttm_dma_page_pool_free(pool, FREE_ALL_PAGES);
+		/* .. but afterwards we can take it too */
+		spin_lock_irqsave(&pool->lock, irq_save);
+		list_for_each_entry_safe(d_page, d_tmp, &pool->page_list,
+					 page_list) {
+			if (d_page->in_use) {
+				pr_err("%s: (%s:%d) %p (%p DMA:0x%lx) busy!\n",
+					pool->dev_name, pool->name,
+					current->pid, d_page->vaddr,
+					virt_to_page(d_page->vaddr),
+					(unsigned long)d_page->dma);
+				list_del(&d_page->page_list);
+				kfree(d_page);
+				pool->npages_in_use--;
+			}
+		}
+		spin_unlock_irqrestore(&pool->lock, irq_save);
+		WARN_ON(((pool->npages_in_use + pool->npages_free) != 0));
+		/* This code path is called after _all_ references to the
+		 * struct device has been dropped - so nobody should be
+		 * touching it. In case somebody is trying to _add_ we are
+		 * guarded by the mutex. */
+		list_del(&pool->pools);
+		kfree(pool);
+		break;
+	}
+	mutex_unlock(&_manager->lock);
+}
+/*
+ * On free-ing of the 'struct device' this deconstructor is run.
+ * Albeit the pool might have already been freed earlier.
+ */
+static void ttm_dma_pool_release(struct device *dev, void *res)
+{
+	struct dma_pool *pool = *(struct dma_pool **)res;
+
+	if (pool)
+		ttm_dma_free_pool(dev, pool->type);
+}
+
+static int ttm_dma_pool_match(struct device *dev, void *res, void *match_data)
+{
+	return *(struct dma_pool **)res == match_data;
+}
+
+static struct dma_pool *ttm_dma_pool_init(struct device *dev, gfp_t flags,
+					  enum pool_type type)
+{
+	char *n[] = {"wc", "uc", "cached", " dma32", "unknown",};
+	enum pool_type t[] = {IS_WC, IS_UC, IS_CACHED, IS_DMA32, IS_UNDEFINED};
+	struct device_pools *sec_pool = NULL;
+	struct dma_pool *pool = NULL, **ptr;
+	unsigned i;
+	int ret = -ENODEV;
+	char *p;
+
+	if (!dev)
+		return NULL;
+
+	ptr = devres_alloc(ttm_dma_pool_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return NULL;
+
+	ret = -ENOMEM;
+
+	pool = kmalloc_node(sizeof(struct dma_pool), GFP_KERNEL,
+			    dev_to_node(dev));
+	if (!pool)
+		goto err_mem;
+
+	sec_pool = kmalloc_node(sizeof(struct device_pools), GFP_KERNEL,
+				dev_to_node(dev));
+	if (!sec_pool)
+		goto err_mem;
+
+	INIT_LIST_HEAD(&sec_pool->pools);
+	sec_pool->dev = dev;
+	sec_pool->pool =  pool;
+
+	INIT_LIST_HEAD(&pool->page_list);
+	INIT_LIST_HEAD(&pool->pools);
+	spin_lock_init(&pool->lock);
+	pool->dev = dev;
+	pool->npages_free = pool->npages_in_use = 0;
+	pool->nfrees = 0;
+	pool->gfp_flags = flags;
+	pool->size = PAGE_SIZE;
+	pool->type = type;
+	pool->nrefills = 0;
+	p = pool->name;
+	for (i = 0; i < 5; i++) {
+		if (type & t[i]) {
+			p += snprintf(p, sizeof(pool->name) - (p - pool->name),
+				      "%s", n[i]);
+		}
+	}
+	*p = 0;
+	/* We copy the name for pr_ calls b/c when dma_pool_destroy is called
+	 * - the kobj->name has already been deallocated.*/
+	snprintf(pool->dev_name, sizeof(pool->dev_name), "%s %s",
+		 dev_driver_string(dev), dev_name(dev));
+	mutex_lock(&_manager->lock);
+	/* You can get the dma_pool from either the global: */
+	list_add(&sec_pool->pools, &_manager->pools);
+	_manager->npools++;
+	/* or from 'struct device': */
+	list_add(&pool->pools, &dev->dma_pools);
+	mutex_unlock(&_manager->lock);
+
+	*ptr = pool;
+	devres_add(dev, ptr);
+
+	return pool;
+err_mem:
+	devres_free(ptr);
+	kfree(sec_pool);
+	kfree(pool);
+	return ERR_PTR(ret);
+}
+static struct dma_pool *ttm_dma_find_pool(struct device *dev,
+					  enum pool_type type)
+{
+	struct dma_pool *pool, *tmp, *found = NULL;
+
+	if (type == IS_UNDEFINED)
+		return found;
+	/* NB: We iterate on the 'struct dev' which has no spinlock, but
+	 * it does have a kref which we have taken. */
+	list_for_each_entry_safe(pool, tmp, &dev->dma_pools, pools) {
+		if (pool->type != type)
+			continue;
+		found = pool;
+	}
+	if (found)
+		pr_debug("%s: (%s:%d) Found. It has %d free pages (%d in use)\n",
+			found->dev_name, found->name, current->pid,
+			found->npages_free, found->npages_in_use);
+	return found;
+}
+
+/*
+ * Free pages the pages that failed to change the caching state. If there is
+ * any pages that have changed their caching state already put them to the
+ * pool.
+ */
+static void ttm_dma_handle_caching_state_failure(struct dma_pool *pool,
+						 struct page **failed_pages,
+						 unsigned cpages)
+{
+	unsigned long irq_flags;
+	unsigned i;
+	struct dma_page *dma_p, *t;
+	struct list_head d_pages;
+
+	/* Failed pages have to be freed */
+	i = cpages;
+
+	INIT_LIST_HEAD(&d_pages);
+
+	/* To make it faster we only take the spinlock on list
+	 * removal, and later on do the free-ing at our leisure. */
+	spin_lock_irqsave(&pool->lock, irq_flags);
+	list_for_each_entry_safe(dma_p, t, &pool->page_list, page_list) {
+		struct page *p = failed_pages[i];
+		if (virt_to_page(dma_p->vaddr) != p) {
+			pr_debug("%s: (%s:%d) Skipping %p (%p) (DMA:0x%lx)\n",
+				pool->dev_name, pool->name, current->pid,
+				dma_p->vaddr,
+				virt_to_page(dma_p->vaddr),
+				(unsigned long)dma_p->dma);
+			continue;
+		}
+		list_del(&dma_p->page_list);
+		list_add(&dma_p->page_list, &d_pages);
+		list_del(&failed_pages[i]->lru);
+		if (--i == 0)
+			break;
+	}
+	ttm_pool_update_free_locked(pool, (cpages - i));
+	spin_unlock_irqrestore(&pool->lock, irq_flags);
+
+	ttm_dma_pages_put(pool, &d_pages, NULL/* Don't try to set WB on them */,
+			  cpages - i);
+}
+
+static int ttm_dma_pool_alloc_new_pages(struct dma_pool *pool,
+					struct list_head *pages,
+					dma_addr_t *dma_address,
+					unsigned dma_offset, unsigned count)
+{
+	struct page **caching_array;
+	struct dma_page *dma_p;
+	struct page *p;
+	int r = 0;
+	unsigned i, cpages;
+	unsigned long irq_flags;
+	unsigned max_cpages = min(count,
+			(unsigned)(PAGE_SIZE/sizeof(struct page *)));
+
+	/* allocate array for page caching change */
+	caching_array = kmalloc(max_cpages*sizeof(struct page *), GFP_KERNEL);
+
+	if (!caching_array) {
+		pr_err(TTM_PFX
+		       "%s: Unable to allocate table for new pages.",
+			pool->dev_name);
+		return -ENOMEM;
+	}
+	pr_debug("%s: (%s:%d) Getting %d pages @ %d idx\n",
+		pool->dev_name, pool->name, current->pid,
+		count, dma_offset);
+	for (i = 0, cpages = 0; i < count; ++i) {
+		dma_p = __ttm_dma_alloc_page(pool);
+		if (!dma_p) {
+			pr_err(TTM_PFX "%s: Unable to get page %u.\n",
+				pool->dev_name, i);
+
+			/* store already allocated pages in the pool after
+			 * setting the caching state */
+			if (cpages) {
+				r = ttm_set_pages_caching(pool, caching_array,
+							  cpages);
+				if (r)
+					ttm_dma_handle_caching_state_failure(
+						pool, caching_array, cpages);
+			}
+			r = -ENOMEM;
+			goto out;
+		}
+		p = virt_to_page(dma_p->vaddr);
+		/* Take ownership of that page. */
+		dma_p->in_use = true;
+		/* And now add it in without having to worry about it being
+		 * immediately picked up by another thread. */
+		spin_lock_irqsave(&pool->lock, irq_flags);
+		list_add(&dma_p->page_list, &pool->page_list);
+		pool->npages_in_use++;
+		spin_unlock_irqrestore(&pool->lock, irq_flags);
+#ifdef CONFIG_HIGHMEM
+		/* gfp flags of highmem page should never be dma32 so we
+		 * we should be fine in such case
+		 */
+		if (!PageHighMem(p))
+#endif
+		{
+			caching_array[cpages++] = p;
+			if (cpages == max_cpages) {
+
+				r = ttm_set_pages_caching(pool, caching_array,
+						 cpages);
+				if (r) {
+					ttm_dma_handle_caching_state_failure(
+						pool, caching_array, cpages);
+					goto out;
+				}
+				cpages = 0;
+			}
+		}
+		/* Note: We do _not_ add the pages to the cached pool here. */
+		list_add_tail(&p->lru, pages);
+		dma_address[dma_offset + i] = dma_p->dma;
+	}
+
+	if (cpages) {
+		r = ttm_set_pages_caching(pool, caching_array, cpages);
+		if (r)
+			ttm_dma_handle_caching_state_failure(pool,
+					caching_array, cpages);
+	}
+out:
+	kfree(caching_array);
+	return r;
+}
+/*
+ * Recycle (or delete) the 'pages' that are on the 'pool'.
+ * @pool: The pool that the pages are associated with.
+ * @pages: The list of pages we are done with.
+ * @page_count: Count of how many pages (or zero if all).
+ * @erase: Instead of recycling - just free them.
+ */
+static int ttm_dma_put_pages_in_pool(struct dma_pool *pool,
+				     struct list_head *pages,
+				     unsigned page_count,
+				     bool erase)
+{
+	unsigned long uninitialized_var(irq_flags);
+	struct list_head uninitialized_var(d_pages);
+	struct page **uninitialized_var(pages_to_free);
+	unsigned uninitialized_var(freed_pages);
+	struct dma_page *d_page, *d_tmp;
+	struct page *p, *tmp;
+	bool found = false;
+	unsigned count = 0;
+
+	if (list_empty(pages))
+		return 0;
+
+	if (page_count == 0) {
+		list_for_each_entry_safe(p, tmp, pages, lru)
+			++page_count;
+	}
+	pr_debug("%s: (%s:%d) %s %d pages\n",
+		pool->dev_name, pool->name, current->pid,
+		erase ? "Destroying" : "Recycling", page_count);
+
+	if (erase) {
+		INIT_LIST_HEAD(&d_pages);
+		pages_to_free = kmalloc(page_count * sizeof(struct dma_page *),
+				GFP_KERNEL);
+		if (!pages_to_free) {
+			dev_err(pool->dev, TTM_PFX
+			"Failed to allocate memory for pool free operation.\n");
+			return 0;
+		}
+		spin_lock_irqsave(&pool->lock, irq_flags);
+		freed_pages = 0;
+	}
+	list_for_each_entry_safe_reverse(p, tmp, pages, lru) {
+		found = false;
+		/* We only hold the lock when erasing. Otherwise we just
+		 * set the d_page->in_use bit. */
+		list_for_each_entry_safe(d_page, d_tmp, &pool->page_list,
+					 page_list) {
+			if (p != virt_to_page(d_page->vaddr))
+				continue;
+			found = true;
+			break;
+		}
+		if (!found)
+			break; /* We could continue, but why bother..*/
+
+		WARN_ON(!d_page->in_use);
+		d_page->in_use = false;
+		count++;
+		list_del_init(&p->lru);
+		if (erase) {
+			list_del(&d_page->page_list);
+			list_add(&d_page->page_list, &d_pages);
+			pages_to_free[freed_pages++] =
+					virt_to_page(d_page->vaddr);
+		}
+		/* Do not advance past what we were asked to delete. */
+		if (count == page_count)
+			break;
+	}
+	if (erase) {
+		spin_unlock_irqrestore(&pool->lock, irq_flags);
+		ttm_dma_pages_put(pool, &d_pages, pages_to_free /* to set WB */,
+				  freed_pages);
+		kfree(pages_to_free);
+	}
+	pr_debug("%s: (%s:%d) Put %d/%d pages in the pool.\n",
+		pool->dev_name, pool->name, current->pid, count, page_count);
+	return count;
+}
+/*
+ * @return count of pages still required to fulfill the request.
+*/
+static int ttm_dma_page_pool_fill_locked(struct dma_pool *pool,
+					 struct list_head *pages,
+					 dma_addr_t *dma_address,
+					 unsigned count,
+					 unsigned long *irq_flags)
+{
+	int r = count;
+
+	if (count < _manager->options.small &&
+	    count > pool->npages_free) {
+		/* Do NOT try to get more than count. This is b/c
+		 * dma_address[count++] will fail. */
+		unsigned alloc_size = min(count, _manager->options.alloc_size);
+
+		spin_unlock_irqrestore(&pool->lock, *irq_flags);
+		/* Returns how many more are neccessary to fulfill the
+		 * request. */
+		r = ttm_dma_pool_alloc_new_pages(pool, pages, dma_address,
+						 0 /* no offset */, alloc_size);
+		spin_lock_irqsave(&pool->lock, *irq_flags);
+
+		if (!r) {
+			++pool->nrefills;
+		} else {
+			pr_err(TTM_PFX "%s: Failed to fill %s pool (r:%d)!\n",
+				pool->dev_name, pool->name, r);
+			spin_unlock_irqrestore(&pool->lock, *irq_flags);
+			count = ttm_dma_put_pages_in_pool(pool, pages,
+							  0 /* no WB */,
+							  false /* recycle */);
+			spin_lock_irqsave(&pool->lock, *irq_flags);
+			pool->npages_free += count;
+			pool->npages_in_use -= count;
+		}
+	}
+	return r;
+
+}
+
+/*
+ * @return count of pages still required to fulfill the request.
+ */
+static int ttm_dma_pool_get_pages(struct dma_pool *pool,
+				  struct list_head *pages,
+				  dma_addr_t *dma_address, unsigned count)
+{
+	unsigned long irq_flags;
+	int r = 0;
+	unsigned i;
+	struct page *p;
+	struct dma_page *dma_p;
+
+	spin_lock_irqsave(&pool->lock, irq_flags);
+	r = ttm_dma_page_pool_fill_locked(pool, pages, dma_address,
+					  count, &irq_flags);
+	pr_debug("%s: (%s:%d) Asked for %d, got %d %s.\n",
+		pool->dev_name, pool->name, current->pid, count, r,
+		(r < 0) ? "err:" : "pages");
+
+	if (r < 0)
+		goto out;
+
+	if (r > count) {
+		/* This should never happen. */
+		WARN_ON(1);
+		/* But just in case, limit it to what we requested. */
+		r = count;
+	}
+	/* How many "left" we need to pick off the free list */
+	count = r;
+	/* And in case we have gotten all the pages we need - we exit. */
+	if (count == 0)
+		goto out;
+	/* NB: Don't set r=0 at the start of the loop, otherwise you will
+	 * overwrite the previously dma_address[x] fields. */
+	r = count - r;
+	i = 0;
+	pr_debug("%s: (%s:%d) Scavenging for %d pages - inserting @ %d idx " \
+		 "(have %d pages free)\n",
+		 pool->dev_name, pool->name, current->pid, count, r,
+		 pool->npages_free);
+	/* Copy as many as we need from the pool to fulfill the request.*/
+	list_for_each_entry(dma_p, &pool->page_list, page_list) {
+		if (dma_p->in_use)
+			continue;
+		p = virt_to_page(dma_p->vaddr);
+		list_add_tail(&p->lru, pages);
+		dma_address[r++] = dma_p->dma;
+		pr_debug("%s: (%s:%d) Salvaged %p (%p) (DMA:0x%lx)\n",
+			pool->dev_name, pool->name, current->pid, dma_p->vaddr,
+			virt_to_page(dma_p->vaddr),
+			(unsigned long)dma_p->dma);
+
+		/* Take ownership of that page. */
+		dma_p->in_use = true;
+		if (++i == count)
+			break;
+	}
+	pool->npages_in_use += i;
+	pool->npages_free -= i;
+	count -= i;
+	pr_debug("%s: (%s:%d) Have taken %d pages, need %d more.\n",
+		pool->dev_name, pool->name, current->pid, r, count);
+out:
+	spin_unlock_irqrestore(&pool->lock, irq_flags);
+	return count;
+}
+/*
+ * On success pages list will hold count number of correctly
+ * cached pages. On failure will hold the negative return value (-ENOMEM, etc).
+ */
+static int ttm_dma_get_pages(struct list_head *pages, int flags,
+			     enum ttm_caching_state cstate, unsigned count,
+			     dma_addr_t *dma_address, struct device *dev)
+
+{
+	int r = -ENOMEM;
+	struct dma_pool *pool;
+	gfp_t gfp_flags;
+	enum pool_type type;
+	unsigned pages_got = count;
+
+	type = ttm_to_type(flags, cstate);
+
+	if (flags & TTM_PAGE_FLAG_DMA32)
+		gfp_flags = GFP_USER | GFP_DMA32;
+	else
+		gfp_flags = GFP_HIGHUSER;
+
+	if (flags & TTM_PAGE_FLAG_ZERO_ALLOC)
+		gfp_flags |= __GFP_ZERO;
+
+	pool = ttm_dma_find_pool(dev, type);
+	if (!pool) {
+		pool = ttm_dma_pool_init(dev, gfp_flags, type);
+		if (IS_ERR_OR_NULL(pool))
+			return -ENOMEM;
+	}
+	/* Take pages out of a pool (if applicable) */
+	r = ttm_dma_pool_get_pages(pool, pages, dma_address, count);
+	/* clear the pages coming from the pool if requested */
+	if (flags & TTM_PAGE_FLAG_ZERO_ALLOC) {
+		struct page *p;
+		list_for_each_entry(p, pages, lru) {
+			clear_page(page_address(p));
+		}
+	}
+	pages_got = count - r;
+	/* If pool didn't have enough pages allocate new one. */
+	if (r > 0) {
+		unsigned pages_need = r;
+		r = ttm_dma_pool_alloc_new_pages(pool, pages, dma_address,
+					 pages_got /* offset in dma_address*/,
+					 pages_need);
+		if (r >= 0)
+			pages_got += pages_need - r;
+
+		pr_debug("%s: (%s:%d) have %d pages, %s %d.\n",
+			pool->dev_name,
+			pool->name, current->pid, pages_got,
+			pages_got == count ?
+			"got them all" : "need more - (err):", r);
+		if (r) {
+			/* If there is any pages in the list put them back to
+			 * the pool. */
+			pr_err(TTM_PFX
+			       "%s: Failed to allocate extra pages "
+			       "for large request.",
+				pool->dev_name);
+			count = ttm_dma_put_pages_in_pool(pool, pages,
+							  0 /* no WB */,
+							  false /* recycle */);
+			INIT_LIST_HEAD(pages);
+			ttm_pool_update_inuse(pool, count);
+			return count;
+		}
+	}
+	return r;
+}
+
+/* Put all pages in pages list to correct pool to wait for reuse */
+static void ttm_dma_put_pages(struct list_head *pages, unsigned page_count,
+			      int flags, enum ttm_caching_state cstate,
+			      dma_addr_t *dma_address, struct device *dev)
+{
+	struct dma_pool *pool;
+	enum pool_type type;
+	bool is_cached = false;
+	unsigned count, i;
+	unsigned long irq_flags;
+
+	if (list_empty(pages))
+		return;
+
+	type = ttm_to_type(flags, cstate);
+	pool = ttm_dma_find_pool(dev, type);
+	if (!pool) {
+		WARN_ON(!pool);
+		return;
+	}
+	is_cached = (ttm_dma_find_pool(pool->dev,
+				       ttm_to_type(flags, tt_cached)) == pool);
+
+	dev_dbg(pool->dev, "(%s:%d) %s %d pages.\n", pool->name, current->pid,
+		(is_cached) ?  "Destroying" : "Recycling", page_count);
+
+	count = ttm_dma_put_pages_in_pool(pool, pages, page_count, is_cached);
+
+	for (i = 0; i < count; i++)
+		dma_address[i] = 0;
+
+	spin_lock_irqsave(&pool->lock, irq_flags);
+	pool->npages_in_use -= count;
+	if (!is_cached)
+		pool->npages_free += count;
+	spin_unlock_irqrestore(&pool->lock, irq_flags);
+
+	page_count -= count;
+	WARN(page_count != 0,
+		"Only freed %d page(s) in %s. Could not free %d rest!\n",
+		count, pool->name, page_count);
+
+	if (pool->npages_free > _manager->options.max_size) {
+		page_count = pool->npages_free - _manager->options.max_size;
+		if (page_count < NUM_PAGES_TO_ALLOC)
+			page_count = NUM_PAGES_TO_ALLOC;
+	}
+	if (page_count)
+		ttm_dma_page_pool_free(pool, page_count);
+}
+
+/* Get good estimation how many pages are free in pools */
+static int ttm_pool_get_num_unused_pages(void)
+{
+	struct device_pools *p;
+	unsigned total = 0;
+
+	mutex_lock(&_manager->lock);
+	list_for_each_entry(p, &_manager->pools, pools)
+		total += p->pool->npages_free;
+	mutex_unlock(&_manager->lock);
+	return total;
+}
+
+/**
+ * Callback for mm to request pool to reduce number of page held.
+ */
+static int ttm_pool_mm_shrink(struct shrinker *shrink,
+			      struct shrink_control *sc)
+{
+	static atomic_t start_pool = ATOMIC_INIT(0);
+	unsigned idx = 0;
+	unsigned pool_offset = atomic_add_return(1, &start_pool);
+	unsigned shrink_pages = sc->nr_to_scan;
+	struct device_pools *p;
+
+	mutex_lock(&_manager->lock);
+	pool_offset = pool_offset % _manager->npools;
+
+	list_for_each_entry(p, &_manager->pools, pools) {
+		unsigned nr_free;
+
+		if (!p->dev)
+			continue;
+		if (shrink_pages == 0)
+			break;
+		/* Do it in round-robin fashion. */
+		if (++idx < pool_offset)
+			continue;
+		nr_free = shrink_pages;
+		shrink_pages = ttm_dma_page_pool_free(p->pool, nr_free);
+		pr_debug("%s: (%s:%d) Asked to shrink %d, have %d more to go\n",
+			p->pool->dev_name, p->pool->name, current->pid, nr_free,
+			shrink_pages);
+	}
+	mutex_unlock(&_manager->lock);
+	/* return estimated number of unused pages in pool */
+	return ttm_pool_get_num_unused_pages();
+}
+
+static void ttm_pool_mm_shrink_init(struct ttm_pool_manager *manager)
+{
+	manager->mm_shrink.shrink = &ttm_pool_mm_shrink;
+	manager->mm_shrink.seeks = 1;
+	register_shrinker(&manager->mm_shrink);
+}
+static void ttm_pool_mm_shrink_fini(struct ttm_pool_manager *manager)
+{
+	unregister_shrinker(&manager->mm_shrink);
+}
+
+static int ttm_dma_page_alloc_init(struct ttm_mem_global *glob,
+				   unsigned max_pages)
+{
+	int ret = -ENOMEM;
+
+	WARN_ON(_manager);
+
+	printk(KERN_INFO TTM_PFX "Initializing DMA pool allocator.\n");
+
+	_manager = kzalloc(sizeof(*_manager), GFP_KERNEL);
+	if (!_manager)
+		goto err_manager;
+
+	mutex_init(&_manager->lock);
+	INIT_LIST_HEAD(&_manager->pools);
+
+	_manager->options.max_size = max_pages;
+	_manager->options.small = SMALL_ALLOCATION;
+	_manager->options.alloc_size = NUM_PAGES_TO_ALLOC;
+
+	/* This takes care of auto-freeing the _manager */
+	ret = kobject_init_and_add(&_manager->kobj, &ttm_pool_kobj_type,
+				   &glob->kobj, "pool");
+	if (unlikely(ret != 0)) {
+		kobject_put(&_manager->kobj);
+		goto err;
+	}
+	ttm_pool_mm_shrink_init(_manager);
+
+	return 0;
+err_manager:
+	kfree(_manager);
+	_manager = NULL;
+err:
+	return ret;
+}
+static void ttm_dma_page_alloc_fini(void)
+{
+	struct device_pools *p, *t;
+
+	printk(KERN_INFO TTM_PFX "Finalizing DMA pool allocator.\n");
+
+	ttm_pool_mm_shrink_fini(_manager);
+
+	list_for_each_entry_safe_reverse(p, t, &_manager->pools, pools) {
+		dev_dbg(p->dev, "(%s:%d) Freeing.\n", p->pool->name,
+			current->pid);
+		WARN_ON(devres_destroy(p->dev, ttm_dma_pool_release,
+			ttm_dma_pool_match, p->pool));
+		ttm_dma_free_pool(p->dev, p->pool->type);
+	}
+	kobject_put(&_manager->kobj);
+	_manager = NULL;
+}
+
+static int ttm_dma_page_alloc_debugfs(struct seq_file *m, void *data)
+{
+	struct device_pools *p;
+	struct dma_pool *pool = NULL;
+	char *h[] = {"pool", "refills", "pages freed", "inuse", "available",
+		     "name", "virt", "busaddr"};
+
+	if (!_manager) {
+		seq_printf(m, "No pool allocator running.\n");
+		return 0;
+	}
+	seq_printf(m, "%13s %12s %13s %8s %8s %8s\n",
+		   h[0], h[1], h[2], h[3], h[4], h[5]);
+	mutex_lock(&_manager->lock);
+	list_for_each_entry(p, &_manager->pools, pools) {
+		struct device *dev = p->dev;
+		if (!dev)
+			continue;
+		pool = p->pool;
+		seq_printf(m, "%13s %12ld %13ld %8d %8d %8s\n",
+				pool->name, pool->nrefills,
+				pool->nfrees, pool->npages_in_use,
+				pool->npages_free,
+				pool->dev_name);
+	}
+#ifdef DEBUG
+	seq_printf(m, "%13s %8s %12s %12s %8s\n",
+			h[0], h[3], h[6], h[7], h[5]);
+	list_for_each_entry(p, &_manager->pools, pools) {
+		struct dma_page *d_page;
+		struct device *dev = p->dev;
+		if (!dev)
+			continue;
+		pool = p->pool;
+
+		if ((pool->npages_free + pool->npages_in_use) == 0)
+			continue;
+
+		spin_lock(&pool->lock);
+		list_for_each_entry(d_page, &pool->page_list, page_list) {
+			seq_printf(m,
+				"%13s %8s %12lx %12lx %8s\n",
+				pool->name, d_page->in_use ? "Busy" : "Free",
+				(unsigned long)d_page->vaddr,
+				(unsigned long)d_page->dma,
+				pool->dev_name);
+		}
+		spin_unlock(&pool->lock);
+	}
+#endif
+	mutex_unlock(&_manager->lock);
+	return 0;
+}
+
+struct ttm_page_alloc_func ttm_page_alloc_dma = {
+	.get_pages	= ttm_dma_get_pages,
+	.put_pages	= ttm_dma_put_pages,
+	.alloc_init	= ttm_dma_page_alloc_init,
+	.alloc_fini	= ttm_dma_page_alloc_fini,
+	.debugfs	= ttm_dma_page_alloc_debugfs,
+};
diff --git a/include/drm/ttm/ttm_page_alloc.h b/include/drm/ttm/ttm_page_alloc.h
index 8fc92f2..a58331d 100644
--- a/include/drm/ttm/ttm_page_alloc.h
+++ b/include/drm/ttm/ttm_page_alloc.h
@@ -29,6 +29,11 @@
 #include "ttm_bo_driver.h"
 #include "ttm_memory.h"
 
+#ifdef CONFIG_SWIOTLB
+#include <linux/dma-mapping.h>
+#include <linux/swiotlb.h>
+#endif
+
 struct ttm_page_alloc_func {
 	/**
 	 * struct ttm_page_alloc_func member get_pages
@@ -38,7 +43,8 @@ struct ttm_page_alloc_func {
 	 * @flags: ttm flags for page allocation.
 	 * @cstate: ttm caching state for the page.
 	 * @count: number of pages to allocate.
-	 * @dma_address: The DMA (bus) address of pages (by default zero).
+	 * @dma_address: The DMA (bus) address of pages (if
+	 * TTM DMA pool is used - otherwise it is zero).
 	 * @dev: The device that needs this.
 	 */
 	int (*get_pages) (struct list_head *pages,
@@ -57,7 +63,8 @@ struct ttm_page_alloc_func {
 	 * unknown count.
 	 * @flags: ttm flags for page allocation.
 	 * @cstate: ttm caching state.
-	 * @dma_address: The DMA (bus) address of pages (by default zero).
+	 * @dma_address: The DMA (bus) address of pages (if
+	 * TTM DMA pool is used - otherwise it is zero).
 	 * @dev: The device that needs this.
 	 */
 	void (*put_pages)(struct list_head *pages,
@@ -93,6 +100,21 @@ extern struct ttm_page_alloc_func *ttm_page_alloc;
 /* Defined in ttm_page_alloc.c */
 extern struct ttm_page_alloc_func ttm_page_alloc_default;
 
+#ifdef CONFIG_SWIOTLB
+/* Defined in ttm_page_alloc_dma.c */
+extern struct ttm_page_alloc_func ttm_page_alloc_dma;
+
+static inline bool ttm_page_alloc_need_dma(void)
+{
+	if (swiotlb_nr_tbl()) {
+		ttm_page_alloc = &ttm_page_alloc_dma;
+		return true;
+	}
+	return false;
+}
+#else
+static inline bool ttm_page_alloc_need_dma(void) { return false; }
+#endif
 /**
  * Get count number of pages from pool to pages list.
  *
@@ -100,7 +122,8 @@ extern struct ttm_page_alloc_func ttm_page_alloc_default;
  * @flags: ttm flags for page allocation.
  * @cstate: ttm caching state for the page.
  * @count: number of pages to allocate.
- * @dma_address: The DMA (bus) address of pages - (by default zero).
+ * @dma_address: The DMA (bus) address of pages (if TTM DMA pool is used -
+ *  otherwise the value is zero).
  * @dev: The device that needs this.
  */
 int ttm_get_pages(struct list_head *pages,
@@ -117,7 +140,8 @@ int ttm_get_pages(struct list_head *pages,
  * count.
  * @flags: ttm flags for page allocation.
  * @cstate: ttm caching state.
- * @dma_address: The DMA (bus) address of pages (by default zero).
+ * @dma_address: The DMA (bus) address of pages (if TTM DMA pool is used -
+ *  otherwise the value is zero).
  * @dev: The device that needs this.
  */
 void ttm_put_pages(struct list_head *pages,
-- 
1.7.4.1

