Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab1GHJ0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 05:26:22 -0400
Received: from adelie.canonical.com ([91.189.90.139]:49728 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab1GHJ0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 05:26:18 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
        kernel-team@lists.ubuntu.com
Subject: =?UTF-8?q?=5B2=2E6=2E32+drm33-longterm=5D=20Linux=202=2E6=2E32=2E42+drm33=2E19?=
Date: Fri,  8 Jul 2011 11:26:12 +0200
Message-Id: <1310117172-4762-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 2.6.32.42+drm33.19 longterm tree.

This tree is based on 2.6.32 and generally has all of the stable updates
applied. Except those to the DRM subsystem, which was based on 2.6.33 and
took updates from that upstream stable as long as that existed. It will
continue to add patches to the DRM subsystem as long as they are valid
according to the stable update rules (Documentation/stable_kernel_rules.txt).
DRM patches for this tree should be sent to kernel-team@lists.ubuntu.com.

This release updates the DRM subsystem only.

The updated 2.6.32.y-drm33.z tree can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git
and can be browsed through git web via:
  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=summary

-Stefan

------

* drm_mm: extract check_free_mm_node
* drm: implement helper functions for scanning lru list
* drm/i915: prepare for fair lru eviction
* drm/i915: Move the eviction logic to its own file.
* drm/i915: Implement fair lru eviction across both rings. (v2)
* drm/i915: Maintain LRU order of inactive objects upon access by CPU (v2)
* drm/i915/evict: Ensure we completely cleanup on failure
* drm/i915: Periodically flush the active lists and requests
* drm/i915: Add a no lvds quirk for the Asus EeeBox PC EB1007
* drm/radeon/kms: fix for radeon on systems >4GB without hardware iommu
* Linux 2.6.32.42+drm33.19

 Makefile                               |    2 +-
 drivers/gpu/drm/drm_mm.c               |  236 +++++++++++++++++++++++++-----
 drivers/gpu/drm/i915/Makefile          |    1 +
 drivers/gpu/drm/i915/i915_drv.h        |   13 ++
 drivers/gpu/drm/i915/i915_gem.c        |  228 ++++------------------------
 drivers/gpu/drm/i915/i915_gem_evict.c  |  253 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/intel_lvds.c      |    8 +
 drivers/gpu/drm/radeon/radeon_device.c |    1 +
 include/drm/drm_mm.h                   |   15 ++-
 9 files changed, 520 insertions(+), 237 deletions(-)

diff --git a/Makefile b/Makefile
index 1eb1010..2751c68 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .42+drm33.18
+EXTRAVERSION = .42+drm33.19
 NAME = Man-Eating Seals of Antiquity

 # *DOCUMENTATION*
diff --git a/drivers/gpu/drm/drm_mm.c b/drivers/gpu/drm/drm_mm.c
index 2ac074c8..f1d3314 100644
--- a/drivers/gpu/drm/drm_mm.c
+++ b/drivers/gpu/drm/drm_mm.c
@@ -83,9 +83,9 @@ static struct drm_mm_node *drm_mm_kmalloc(struct drm_mm *mm, int atomic)
 	struct drm_mm_node *child;

 	if (atomic)
-		child = kmalloc(sizeof(*child), GFP_ATOMIC);
+		child = kzalloc(sizeof(*child), GFP_ATOMIC);
 	else
-		child = kmalloc(sizeof(*child), GFP_KERNEL);
+		child = kzalloc(sizeof(*child), GFP_KERNEL);

 	if (unlikely(child == NULL)) {
 		spin_lock(&mm->unused_lock);
@@ -115,7 +115,7 @@ int drm_mm_pre_get(struct drm_mm *mm)
 	spin_lock(&mm->unused_lock);
 	while (mm->num_unused < MM_UNUSED_TARGET) {
 		spin_unlock(&mm->unused_lock);
-		node = kmalloc(sizeof(*node), GFP_KERNEL);
+		node = kzalloc(sizeof(*node), GFP_KERNEL);
 		spin_lock(&mm->unused_lock);

 		if (unlikely(node == NULL)) {
@@ -179,7 +179,6 @@ static struct drm_mm_node *drm_mm_split_at_start(struct drm_mm_node *parent,

 	INIT_LIST_HEAD(&child->fl_entry);

-	child->free = 0;
 	child->size = size;
 	child->start = parent->start;
 	child->mm = parent->mm;
@@ -280,6 +279,9 @@ void drm_mm_put_block(struct drm_mm_node *cur)

 	int merged = 0;

+	BUG_ON(cur->scanned_block || cur->scanned_prev_free
+				  || cur->scanned_next_free);
+
 	if (cur_head->prev != root_head) {
 		prev_node =
 		    list_entry(cur_head->prev, struct drm_mm_node, ml_entry);
@@ -328,6 +330,27 @@ void drm_mm_put_block(struct drm_mm_node *cur)

 EXPORT_SYMBOL(drm_mm_put_block);

+static int check_free_mm_node(struct drm_mm_node *entry, unsigned long size,
+			      unsigned alignment)
+{
+	unsigned wasted = 0;
+
+	if (entry->size < size)
+		return 0;
+
+	if (alignment) {
+		register unsigned tmp = entry->start % alignment;
+		if (tmp)
+			wasted = alignment - tmp;
+	}
+
+	if (entry->size >= size + wasted) {
+		return 1;
+	}
+
+	return 0;
+}
+
 struct drm_mm_node *drm_mm_search_free(const struct drm_mm *mm,
 				       unsigned long size,
 				       unsigned alignment, int best_match)
@@ -337,31 +360,24 @@ struct drm_mm_node *drm_mm_search_free(const struct drm_mm *mm,
 	struct drm_mm_node *entry;
 	struct drm_mm_node *best;
 	unsigned long best_size;
-	unsigned wasted;
+
+	BUG_ON(mm->scanned_blocks);

 	best = NULL;
 	best_size = ~0UL;

 	list_for_each(list, free_stack) {
 		entry = list_entry(list, struct drm_mm_node, fl_entry);
-		wasted = 0;

-		if (entry->size < size)
+		if (!check_free_mm_node(entry, size, alignment))
 			continue;

-		if (alignment) {
-			register unsigned tmp = entry->start % alignment;
-			if (tmp)
-				wasted += alignment - tmp;
-		}
+		if (!best_match)
+			return entry;

-		if (entry->size >= size + wasted) {
-			if (!best_match)
-				return entry;
-			if (entry->size < best_size) {
-				best = entry;
-				best_size = entry->size;
-			}
+		if (entry->size < best_size) {
+			best = entry;
+			best_size = entry->size;
 		}
 	}

@@ -381,38 +397,27 @@ struct drm_mm_node *drm_mm_search_free_in_range(const struct drm_mm *mm,
 	struct drm_mm_node *entry;
 	struct drm_mm_node *best;
 	unsigned long best_size;
-	unsigned wasted;
+
+	BUG_ON(mm->scanned_blocks);

 	best = NULL;
 	best_size = ~0UL;

 	list_for_each(list, free_stack) {
 		entry = list_entry(list, struct drm_mm_node, fl_entry);
-		wasted = 0;

-		if (entry->size < size)
+		if (entry->start > end || (entry->start+entry->size) < start)
 			continue;

-		if (entry->start > end || (entry->start+entry->size) < start)
+		if (!check_free_mm_node(entry, size, alignment))
 			continue;

-		if (entry->start < start)
-			wasted += start - entry->start;
+		if (!best_match)
+			return entry;

-		if (alignment) {
-			register unsigned tmp = (entry->start + wasted) % alignment;
-			if (tmp)
-				wasted += alignment - tmp;
-		}
-
-		if (entry->size >= size + wasted &&
-		    (entry->start + wasted + size) <= end) {
-			if (!best_match)
-				return entry;
-			if (entry->size < best_size) {
-				best = entry;
-				best_size = entry->size;
-			}
+		if (entry->size < best_size) {
+			best = entry;
+			best_size = entry->size;
 		}
 	}

@@ -420,6 +425,158 @@ struct drm_mm_node *drm_mm_search_free_in_range(const struct drm_mm *mm,
 }
 EXPORT_SYMBOL(drm_mm_search_free_in_range);

+/**
+ * Initializa lru scanning.
+ *
+ * This simply sets up the scanning routines with the parameters for the desired
+ * hole.
+ *
+ * Warning: As long as the scan list is non-empty, no other operations than
+ * adding/removing nodes to/from the scan list are allowed.
+ */
+void drm_mm_init_scan(struct drm_mm *mm, unsigned long size,
+		      unsigned alignment)
+{
+	mm->scan_alignment = alignment;
+	mm->scan_size = size;
+	mm->scanned_blocks = 0;
+	mm->scan_hit_start = 0;
+	mm->scan_hit_size = 0;
+}
+EXPORT_SYMBOL(drm_mm_init_scan);
+
+/**
+ * Add a node to the scan list that might be freed to make space for the desired
+ * hole.
+ *
+ * Returns non-zero, if a hole has been found, zero otherwise.
+ */
+int drm_mm_scan_add_block(struct drm_mm_node *node)
+{
+	struct drm_mm *mm = node->mm;
+	struct list_head *prev_free, *next_free;
+	struct drm_mm_node *prev_node, *next_node;
+
+	mm->scanned_blocks++;
+
+	prev_free = next_free = NULL;
+
+	BUG_ON(node->free);
+	node->scanned_block = 1;
+	node->free = 1;
+
+	if (node->ml_entry.prev != &mm->ml_entry) {
+		prev_node = list_entry(node->ml_entry.prev, struct drm_mm_node,
+				       ml_entry);
+
+		if (prev_node->free) {
+			list_del(&prev_node->ml_entry);
+
+			node->start = prev_node->start;
+			node->size += prev_node->size;
+
+			prev_node->scanned_prev_free = 1;
+
+			prev_free = &prev_node->fl_entry;
+		}
+	}
+
+	if (node->ml_entry.next != &mm->ml_entry) {
+		next_node = list_entry(node->ml_entry.next, struct drm_mm_node,
+				       ml_entry);
+
+		if (next_node->free) {
+			list_del(&next_node->ml_entry);
+
+			node->size += next_node->size;
+
+			next_node->scanned_next_free = 1;
+
+			next_free = &next_node->fl_entry;
+		}
+	}
+
+	/* The fl_entry list is not used for allocated objects, so these two
+	 * pointers can be abused (as long as no allocations in this memory
+	 * manager happens). */
+	node->fl_entry.prev = prev_free;
+	node->fl_entry.next = next_free;
+
+	if (check_free_mm_node(node, mm->scan_size, mm->scan_alignment)) {
+		mm->scan_hit_start = node->start;
+		mm->scan_hit_size = node->size;
+
+		return 1;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(drm_mm_scan_add_block);
+
+/**
+ * Remove a node from the scan list.
+ *
+ * Nodes _must_ be removed in the exact same order from the scan list as they
+ * have been added, otherwise the internal state of the memory manager will be
+ * corrupted.
+ *
+ * When the scan list is empty, the selected memory nodes can be freed. An
+ * immediatly following drm_mm_search_free with best_match = 0 will then return
+ * the just freed block (because its at the top of the fl_entry list).
+ *
+ * Returns one if this block should be evicted, zero otherwise. Will always
+ * return zero when no hole has been found.
+ */
+int drm_mm_scan_remove_block(struct drm_mm_node *node)
+{
+	struct drm_mm *mm = node->mm;
+	struct drm_mm_node *prev_node, *next_node;
+
+	mm->scanned_blocks--;
+
+	BUG_ON(!node->scanned_block);
+	node->scanned_block = 0;
+	node->free = 0;
+
+	prev_node = list_entry(node->fl_entry.prev, struct drm_mm_node,
+			       fl_entry);
+	next_node = list_entry(node->fl_entry.next, struct drm_mm_node,
+			       fl_entry);
+
+	if (prev_node) {
+		BUG_ON(!prev_node->scanned_prev_free);
+		prev_node->scanned_prev_free = 0;
+
+		list_add_tail(&prev_node->ml_entry, &node->ml_entry);
+
+		node->start = prev_node->start + prev_node->size;
+		node->size -= prev_node->size;
+	}
+
+	if (next_node) {
+		BUG_ON(!next_node->scanned_next_free);
+		next_node->scanned_next_free = 0;
+
+		list_add(&next_node->ml_entry, &node->ml_entry);
+
+		node->size -= next_node->size;
+	}
+
+	INIT_LIST_HEAD(&node->fl_entry);
+
+	/* Only need to check for containement because start&size for the
+	 * complete resulting free block (not just the desired part) is
+	 * stored. */
+	if (node->start >= mm->scan_hit_start &&
+	    node->start + node->size
+	    		<= mm->scan_hit_start + mm->scan_hit_size) {
+		return 1;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(drm_mm_scan_remove_block);
+
 int drm_mm_clean(struct drm_mm * mm)
 {
 	struct list_head *head = &mm->ml_entry;
@@ -434,6 +591,7 @@ int drm_mm_init(struct drm_mm * mm, unsigned long start, unsigned long size)
 	INIT_LIST_HEAD(&mm->fl_entry);
 	INIT_LIST_HEAD(&mm->unused_nodes);
 	mm->num_unused = 0;
+	mm->scanned_blocks = 0;
 	spin_lock_init(&mm->unused_lock);

 	return drm_mm_create_tail_node(mm, start, size, 0);
diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
index 9929f84..8a83bb7 100644
--- a/drivers/gpu/drm/i915/Makefile
+++ b/drivers/gpu/drm/i915/Makefile
@@ -8,6 +8,7 @@ i915-y := i915_drv.o i915_dma.o i915_irq.o i915_mem.o \
           i915_suspend.o \
 	  i915_gem.o \
 	  i915_gem_debug.o \
+	  i915_gem_evict.o \
 	  i915_gem_tiling.o \
 	  i915_trace_points.o \
 	  intel_display.o \
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index ecc4fbe..e0acd00 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -55,6 +55,8 @@ enum plane {

 #define I915_NUM_PIPE	2

+#define I915_GEM_GPU_DOMAINS	(~(I915_GEM_DOMAIN_CPU | I915_GEM_DOMAIN_GTT))
+
 /* Interface history:
  *
  * 1.1: Original.
@@ -608,6 +610,8 @@ struct drm_i915_gem_object {
 	struct list_head list;
 	/** This object's place on GPU write list */
 	struct list_head gpu_write_list;
+	/** This object's place on eviction list */
+	struct list_head evict_list;

 	/** This object's place on the fenced object LRU */
 	struct list_head fence_list;
@@ -858,6 +862,9 @@ int i915_gem_init_object(struct drm_gem_object *obj);
 void i915_gem_free_object(struct drm_gem_object *obj);
 int i915_gem_object_pin(struct drm_gem_object *obj, uint32_t alignment);
 void i915_gem_object_unpin(struct drm_gem_object *obj);
+void i915_gem_flush(struct drm_device *dev,
+		    uint32_t invalidate_domains,
+		    uint32_t flush_domains);
 int i915_gem_object_unbind(struct drm_gem_object *obj);
 void i915_gem_release_mmap(struct drm_gem_object *obj);
 void i915_gem_lastclose(struct drm_device *dev);
@@ -875,6 +882,7 @@ int i915_gem_init_ringbuffer(struct drm_device *dev);
 void i915_gem_cleanup_ringbuffer(struct drm_device *dev);
 int i915_gem_do_init(struct drm_device *dev, unsigned long start,
 		     unsigned long end);
+int i915_gpu_idle(struct drm_device *dev);
 int i915_gem_idle(struct drm_device *dev);
 uint32_t i915_add_request(struct drm_device *dev, struct drm_file *file_priv,
 			  uint32_t flush_domains);
@@ -896,6 +904,11 @@ void i915_gem_object_flush_write_domain(struct drm_gem_object *obj);
 void i915_gem_shrinker_init(void);
 void i915_gem_shrinker_exit(void);

+/* i915_gem_evict.c */
+int i915_gem_evict_something(struct drm_device *dev, int min_size, unsigned alignment);
+int i915_gem_evict_everything(struct drm_device *dev);
+int i915_gem_evict_inactive(struct drm_device *dev);
+
 /* i915_gem_tiling.c */
 void i915_gem_detect_bit_6_swizzle(struct drm_device *dev);
 void i915_gem_object_do_bit_17_swizzle(struct drm_gem_object *obj);
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index a34fd44..0314f7f 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -34,8 +34,7 @@
 #include <linux/swap.h>
 #include <linux/pci.h>

-#define I915_GEM_GPU_DOMAINS	(~(I915_GEM_DOMAIN_CPU | I915_GEM_DOMAIN_GTT))
-
+static uint32_t i915_gem_get_gtt_alignment(struct drm_gem_object *obj);
 static void i915_gem_object_flush_gpu_write_domain(struct drm_gem_object *obj);
 static void i915_gem_object_flush_gtt_write_domain(struct drm_gem_object *obj);
 static void i915_gem_object_flush_cpu_write_domain(struct drm_gem_object *obj);
@@ -49,8 +48,6 @@ static int i915_gem_object_wait_rendering(struct drm_gem_object *obj);
 static int i915_gem_object_bind_to_gtt(struct drm_gem_object *obj,
 					   unsigned alignment);
 static void i915_gem_clear_fence_reg(struct drm_gem_object *obj);
-static int i915_gem_evict_something(struct drm_device *dev, int min_size);
-static int i915_gem_evict_from_inactive_list(struct drm_device *dev);
 static int i915_gem_phys_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 				struct drm_i915_gem_pwrite *args,
 				struct drm_file *file_priv);
@@ -58,6 +55,14 @@ static int i915_gem_phys_pwrite(struct drm_device *dev, struct drm_gem_object *o
 static LIST_HEAD(shrink_list);
 static DEFINE_SPINLOCK(shrink_list_lock);

+static inline bool
+i915_gem_object_is_inactive(struct drm_i915_gem_object *obj_priv)
+{
+	return obj_priv->gtt_space &&
+		!obj_priv->active &&
+		obj_priv->pin_count == 0;
+}
+
 int i915_gem_do_init(struct drm_device *dev, unsigned long start,
 		     unsigned long end)
 {
@@ -334,7 +339,8 @@ i915_gem_object_get_pages_or_evict(struct drm_gem_object *obj)
 	if (ret == -ENOMEM) {
 		struct drm_device *dev = obj->dev;

-		ret = i915_gem_evict_something(dev, obj->size);
+		ret = i915_gem_evict_something(dev, obj->size,
+					       i915_gem_get_gtt_alignment(obj));
 		if (ret)
 			return ret;

@@ -1070,6 +1076,11 @@ i915_gem_set_domain_ioctl(struct drm_device *dev, void *data,
 		ret = i915_gem_object_set_to_cpu_domain(obj, write_domain != 0);
 	}

+
+	/* Maintain LRU order of "inactive" objects */
+	if (ret == 0 && i915_gem_object_is_inactive(obj_priv))
+		list_move_tail(&obj_priv->list, &dev_priv->mm.inactive_list);
+
 	drm_gem_object_unreference(obj);
 	mutex_unlock(&dev->struct_mutex);
 	return ret;
@@ -1205,6 +1216,9 @@ int i915_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 			goto unlock;
 	}

+	if (i915_gem_object_is_inactive(obj_priv))
+		list_move_tail(&obj_priv->list, &dev_priv->mm.inactive_list);
+
 	pfn = ((dev->agp->base + obj_priv->gtt_offset) >> PAGE_SHIFT) +
 		page_offset;

@@ -1848,9 +1862,16 @@ i915_gem_retire_work_handler(struct work_struct *work)

 	mutex_lock(&dev->struct_mutex);
 	i915_gem_retire_requests(dev);
+
+	if (!list_empty(&dev_priv->mm.gpu_write_list)) {
+		i915_gem_flush(dev, 0, I915_GEM_GPU_DOMAINS);
+		i915_add_request(dev, NULL, I915_GEM_GPU_DOMAINS);
+	}
+
 	if (!dev_priv->mm.suspended &&
 	    !list_empty(&dev_priv->mm.request_list))
 		queue_delayed_work(dev_priv->wq, &dev_priv->mm.retire_work, HZ);
+
 	mutex_unlock(&dev->struct_mutex);
 }

@@ -1924,7 +1945,7 @@ i915_wait_request(struct drm_device *dev, uint32_t seqno)
 	return i915_do_wait_request(dev, seqno, 1);
 }

-static void
+void
 i915_gem_flush(struct drm_device *dev,
 	       uint32_t invalidate_domains,
 	       uint32_t flush_domains)
@@ -2102,168 +2123,6 @@ i915_gem_object_unbind(struct drm_gem_object *obj)
 	return 0;
 }

-static struct drm_gem_object *
-i915_gem_find_inactive_object(struct drm_device *dev, int min_size)
-{
-	drm_i915_private_t *dev_priv = dev->dev_private;
-	struct drm_i915_gem_object *obj_priv;
-	struct drm_gem_object *best = NULL;
-	struct drm_gem_object *first = NULL;
-
-	/* Try to find the smallest clean object */
-	list_for_each_entry(obj_priv, &dev_priv->mm.inactive_list, list) {
-		struct drm_gem_object *obj = obj_priv->obj;
-		if (obj->size >= min_size) {
-			if ((!obj_priv->dirty ||
-			     i915_gem_object_is_purgeable(obj_priv)) &&
-			    (!best || obj->size < best->size)) {
-				best = obj;
-				if (best->size == min_size)
-					return best;
-			}
-			if (!first)
-			    first = obj;
-		}
-	}
-
-	return best ? best : first;
-}
-
-static int
-i915_gem_evict_everything(struct drm_device *dev)
-{
-	drm_i915_private_t *dev_priv = dev->dev_private;
-	int ret;
-	uint32_t seqno;
-	bool lists_empty;
-
-	spin_lock(&dev_priv->mm.active_list_lock);
-	lists_empty = (list_empty(&dev_priv->mm.inactive_list) &&
-		       list_empty(&dev_priv->mm.flushing_list) &&
-		       list_empty(&dev_priv->mm.active_list));
-	spin_unlock(&dev_priv->mm.active_list_lock);
-
-	if (lists_empty)
-		return -ENOSPC;
-
-	/* Flush everything (on to the inactive lists) and evict */
-	i915_gem_flush(dev, I915_GEM_GPU_DOMAINS, I915_GEM_GPU_DOMAINS);
-	seqno = i915_add_request(dev, NULL, I915_GEM_GPU_DOMAINS);
-	if (seqno == 0)
-		return -ENOMEM;
-
-	ret = i915_wait_request(dev, seqno);
-	if (ret)
-		return ret;
-
-	BUG_ON(!list_empty(&dev_priv->mm.flushing_list));
-
-	ret = i915_gem_evict_from_inactive_list(dev);
-	if (ret)
-		return ret;
-
-	spin_lock(&dev_priv->mm.active_list_lock);
-	lists_empty = (list_empty(&dev_priv->mm.inactive_list) &&
-		       list_empty(&dev_priv->mm.flushing_list) &&
-		       list_empty(&dev_priv->mm.active_list));
-	spin_unlock(&dev_priv->mm.active_list_lock);
-	BUG_ON(!lists_empty);
-
-	return 0;
-}
-
-static int
-i915_gem_evict_something(struct drm_device *dev, int min_size)
-{
-	drm_i915_private_t *dev_priv = dev->dev_private;
-	struct drm_gem_object *obj;
-	int ret;
-
-	for (;;) {
-		i915_gem_retire_requests(dev);
-
-		/* If there's an inactive buffer available now, grab it
-		 * and be done.
-		 */
-		obj = i915_gem_find_inactive_object(dev, min_size);
-		if (obj) {
-			struct drm_i915_gem_object *obj_priv;
-
-#if WATCH_LRU
-			DRM_INFO("%s: evicting %p\n", __func__, obj);
-#endif
-			obj_priv = obj->driver_private;
-			BUG_ON(obj_priv->pin_count != 0);
-			BUG_ON(obj_priv->active);
-
-			/* Wait on the rendering and unbind the buffer. */
-			return i915_gem_object_unbind(obj);
-		}
-
-		/* If we didn't get anything, but the ring is still processing
-		 * things, wait for the next to finish and hopefully leave us
-		 * a buffer to evict.
-		 */
-		if (!list_empty(&dev_priv->mm.request_list)) {
-			struct drm_i915_gem_request *request;
-
-			request = list_first_entry(&dev_priv->mm.request_list,
-						   struct drm_i915_gem_request,
-						   list);
-
-			ret = i915_wait_request(dev, request->seqno);
-			if (ret)
-				return ret;
-
-			continue;
-		}
-
-		/* If we didn't have anything on the request list but there
-		 * are buffers awaiting a flush, emit one and try again.
-		 * When we wait on it, those buffers waiting for that flush
-		 * will get moved to inactive.
-		 */
-		if (!list_empty(&dev_priv->mm.flushing_list)) {
-			struct drm_i915_gem_object *obj_priv;
-
-			/* Find an object that we can immediately reuse */
-			list_for_each_entry(obj_priv, &dev_priv->mm.flushing_list, list) {
-				obj = obj_priv->obj;
-				if (obj->size >= min_size)
-					break;
-
-				obj = NULL;
-			}
-
-			if (obj != NULL) {
-				uint32_t seqno;
-
-				i915_gem_flush(dev,
-					       obj->write_domain,
-					       obj->write_domain);
-				seqno = i915_add_request(dev, NULL, obj->write_domain);
-				if (seqno == 0)
-					return -ENOMEM;
-
-				ret = i915_wait_request(dev, seqno);
-				if (ret)
-					return ret;
-
-				continue;
-			}
-		}
-
-		/* If we didn't do any of the above, there's no single buffer
-		 * large enough to swap out for the new one, so just evict
-		 * everything and start again. (This should be rare.)
-		 */
-		if (!list_empty (&dev_priv->mm.inactive_list))
-			return i915_gem_evict_from_inactive_list(dev);
-		else
-			return i915_gem_evict_everything(dev);
-	}
-}
-
 int
 i915_gem_object_get_pages(struct drm_gem_object *obj,
 			  gfp_t gfpmask)
@@ -2672,7 +2531,7 @@ i915_gem_object_bind_to_gtt(struct drm_gem_object *obj, unsigned alignment)
 #if WATCH_LRU
 		DRM_INFO("%s: GTT full, evicting something\n", __func__);
 #endif
-		ret = i915_gem_evict_something(dev, obj->size);
+		ret = i915_gem_evict_something(dev, obj->size, alignment);
 		if (ret)
 			return ret;

@@ -2690,7 +2549,8 @@ i915_gem_object_bind_to_gtt(struct drm_gem_object *obj, unsigned alignment)

 		if (ret == -ENOMEM) {
 			/* first try to clear up some space from the GTT */
-			ret = i915_gem_evict_something(dev, obj->size);
+			ret = i915_gem_evict_something(dev, obj->size,
+						       alignment);
 			if (ret) {
 				/* now try to shrink everyone else */
 				if (gfpmask) {
@@ -2720,7 +2580,7 @@ i915_gem_object_bind_to_gtt(struct drm_gem_object *obj, unsigned alignment)
 		drm_mm_put_block(obj_priv->gtt_space);
 		obj_priv->gtt_space = NULL;

-		ret = i915_gem_evict_something(dev, obj->size);
+		ret = i915_gem_evict_something(dev, obj->size, alignment);
 		if (ret)
 			return ret;

@@ -4495,30 +4355,6 @@ void i915_gem_free_object(struct drm_gem_object *obj)
 	kfree(obj->driver_private);
 }

-/** Unbinds all inactive objects. */
-static int
-i915_gem_evict_from_inactive_list(struct drm_device *dev)
-{
-	drm_i915_private_t *dev_priv = dev->dev_private;
-
-	while (!list_empty(&dev_priv->mm.inactive_list)) {
-		struct drm_gem_object *obj;
-		int ret;
-
-		obj = list_first_entry(&dev_priv->mm.inactive_list,
-				       struct drm_i915_gem_object,
-				       list)->obj;
-
-		ret = i915_gem_object_unbind(obj);
-		if (ret != 0) {
-			DRM_ERROR("Error unbinding object: %d\n", ret);
-			return ret;
-		}
-	}
-
-	return 0;
-}
-
 int
 i915_gem_idle(struct drm_device *dev)
 {
@@ -4632,7 +4468,7 @@ i915_gem_idle(struct drm_device *dev)


 	/* Move all inactive buffers out of the GTT. */
-	ret = i915_gem_evict_from_inactive_list(dev);
+	ret = i915_gem_evict_inactive(dev);
 	WARN_ON(!list_empty(&dev_priv->mm.inactive_list));
 	if (ret) {
 		mutex_unlock(&dev->struct_mutex);
diff --git a/drivers/gpu/drm/i915/i915_gem_evict.c b/drivers/gpu/drm/i915/i915_gem_evict.c
new file mode 100644
index 0000000..9c1ec78
--- /dev/null
+++ b/drivers/gpu/drm/i915/i915_gem_evict.c
@@ -0,0 +1,253 @@
+/*
+ * Copyright © 2008-2010 Intel Corporation
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ *
+ * Authors:
+ *    Eric Anholt <eric@anholt.net>
+ *    Chris Wilson <chris@chris-wilson.co.uuk>
+ *
+ */
+
+#include "drmP.h"
+#include "drm.h"
+#include "i915_drv.h"
+#include "i915_drm.h"
+
+static struct drm_i915_gem_object *
+i915_gem_next_active_object(struct drm_device *dev,
+			    struct list_head **iter)
+{
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct drm_i915_gem_object *obj = NULL;
+
+	if (*iter != &dev_priv->mm.active_list)
+		obj = list_entry(*iter,
+				 struct drm_i915_gem_object,
+				 list);
+
+	*iter = (*iter)->next;
+	return obj;
+}
+
+static bool
+mark_free(struct drm_i915_gem_object *obj_priv,
+	   struct list_head *unwind)
+{
+	list_add(&obj_priv->evict_list, unwind);
+	return drm_mm_scan_add_block(obj_priv->gtt_space);
+}
+
+#define i915_for_each_active_object(OBJ, I) \
+	*(I) = dev_priv->mm.active_list.next; \
+	while (((OBJ) = i915_gem_next_active_object(dev, (I))) != NULL)
+
+int
+i915_gem_evict_something(struct drm_device *dev, int min_size, unsigned alignment)
+{
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct list_head eviction_list, unwind_list;
+	struct drm_i915_gem_object *obj_priv, *tmp_obj_priv;
+	struct list_head *iter;
+	int ret = 0;
+
+	i915_gem_retire_requests(dev);
+
+	/* Re-check for free space after retiring requests */
+	if (drm_mm_search_free(&dev_priv->mm.gtt_space,
+			       min_size, alignment, 0))
+		return 0;
+
+	/*
+	 * The goal is to evict objects and amalgamate space in LRU order.
+	 * The oldest idle objects reside on the inactive list, which is in
+	 * retirement order. The next objects to retire are those on the
+	 * active list that do not have an outstanding flush. Once the
+	 * hardware reports completion (the seqno is updated after the
+	 * batchbuffer has been finished) the clean buffer objects would
+	 * be retired to the inactive list. Any dirty objects would be added
+	 * to the tail of the flushing list. So after processing the clean
+	 * active objects we need to emit a MI_FLUSH to retire the flushing
+	 * list, hence the retirement order of the flushing list is in
+	 * advance of the dirty objects on the active list.
+	 *
+	 * The retirement sequence is thus:
+	 *   1. Inactive objects (already retired)
+	 *   2. Clean active objects
+	 *   3. Flushing list
+	 *   4. Dirty active objects.
+	 *
+	 * On each list, the oldest objects lie at the HEAD with the freshest
+	 * object on the TAIL.
+	 */
+
+	INIT_LIST_HEAD(&unwind_list);
+	drm_mm_init_scan(&dev_priv->mm.gtt_space, min_size, alignment);
+
+	/* First see if there is a large enough contiguous idle region... */
+	list_for_each_entry(obj_priv, &dev_priv->mm.inactive_list, list) {
+		if (mark_free(obj_priv, &unwind_list))
+			goto found;
+	}
+
+	/* Now merge in the soon-to-be-expired objects... */
+	i915_for_each_active_object(obj_priv, &iter) {
+		/* Does the object require an outstanding flush? */
+		if (obj_priv->obj->write_domain || obj_priv->pin_count)
+			continue;
+
+		if (mark_free(obj_priv, &unwind_list))
+			goto found;
+	}
+
+	/* Finally add anything with a pending flush (in order of retirement) */
+	list_for_each_entry(obj_priv, &dev_priv->mm.flushing_list, list) {
+		if (obj_priv->pin_count)
+			continue;
+
+		if (mark_free(obj_priv, &unwind_list))
+			goto found;
+	}
+	i915_for_each_active_object(obj_priv, &iter) {
+		if (! obj_priv->obj->write_domain || obj_priv->pin_count)
+			continue;
+
+		if (mark_free(obj_priv, &unwind_list))
+			goto found;
+	}
+
+	/* Nothing found, clean up and bail out! */
+	while (!list_empty(&unwind_list)) {
+		obj_priv = list_first_entry(&unwind_list,
+					    struct drm_i915_gem_object,
+					    evict_list);
+
+		ret = drm_mm_scan_remove_block(obj_priv->gtt_space);
+		BUG_ON(ret);
+
+		list_del_init(&obj_priv->evict_list);
+	}
+
+	/* We expect the caller to unpin, evict all and try again, or give up.
+	 * So calling i915_gem_evict_everything() is unnecessary.
+	 */
+	return -ENOSPC;
+
+found:
+	/* drm_mm doesn't allow any other other operations while
+	 * scanning, therefore store to be evicted objects on a
+	 * temporary list. */
+	INIT_LIST_HEAD(&eviction_list);
+	list_for_each_entry_safe(obj_priv, tmp_obj_priv,
+				 &unwind_list, evict_list) {
+		if (drm_mm_scan_remove_block(obj_priv->gtt_space)) {
+			list_move(&obj_priv->evict_list, &eviction_list);
+			continue;
+		}
+		list_del_init(&obj_priv->evict_list);
+	}
+
+	/* Unbinding will emit any required flushes */
+	while (!list_empty(&eviction_list)) {
+		obj_priv = list_first_entry(&eviction_list,
+					    struct drm_i915_gem_object,
+					    evict_list);
+		if (ret == 0)
+			ret = i915_gem_object_unbind(obj_priv->obj);
+
+		list_del_init(&obj_priv->evict_list);
+	}
+
+	/* The just created free hole should be on the top of the free stack
+	 * maintained by drm_mm, so this BUG_ON actually executes in O(1).
+	 * Furthermore all accessed data has just recently been used, so it
+	 * should be really fast, too. */
+	BUG_ON(!drm_mm_search_free(&dev_priv->mm.gtt_space, min_size,
+				   alignment, 0));
+
+	return 0;
+}
+
+int
+i915_gem_evict_everything(struct drm_device *dev)
+{
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	int ret;
+	uint32_t seqno;
+	bool lists_empty;
+
+	spin_lock(&dev_priv->mm.active_list_lock);
+	lists_empty = (list_empty(&dev_priv->mm.inactive_list) &&
+		       list_empty(&dev_priv->mm.flushing_list) &&
+		       list_empty(&dev_priv->mm.active_list));
+	spin_unlock(&dev_priv->mm.active_list_lock);
+
+	if (lists_empty)
+		return -ENOSPC;
+
+	/* Flush everything (on to the inactive lists) and evict */
+	i915_gem_flush(dev, I915_GEM_GPU_DOMAINS, I915_GEM_GPU_DOMAINS);
+	seqno = i915_add_request(dev, NULL, I915_GEM_GPU_DOMAINS);
+	if (seqno == 0)
+		return -ENOMEM;
+
+	ret = i915_do_wait_request(dev, seqno, true);
+	if (ret)
+		return ret;
+
+	BUG_ON(!list_empty(&dev_priv->mm.flushing_list));
+
+	ret = i915_gem_evict_inactive(dev);
+	if (ret)
+		return ret;
+
+	spin_lock(&dev_priv->mm.active_list_lock);
+	lists_empty = (list_empty(&dev_priv->mm.inactive_list) &&
+		       list_empty(&dev_priv->mm.flushing_list) &&
+		       list_empty(&dev_priv->mm.active_list));
+	spin_unlock(&dev_priv->mm.active_list_lock);
+	BUG_ON(!lists_empty);
+
+	return 0;
+}
+
+/** Unbinds all inactive objects. */
+int
+i915_gem_evict_inactive(struct drm_device *dev)
+{
+	drm_i915_private_t *dev_priv = dev->dev_private;
+
+	while (!list_empty(&dev_priv->mm.inactive_list)) {
+		struct drm_gem_object *obj;
+		int ret;
+
+		obj = list_first_entry(&dev_priv->mm.inactive_list,
+				       struct drm_i915_gem_object,
+				       list)->obj;
+
+		ret = i915_gem_object_unbind(obj);
+		if (ret != 0) {
+			DRM_ERROR("Error unbinding object: %d\n", ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index d34c09f..7cfc814 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -865,6 +865,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "U800"),
 		},
 	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Asus EeeBox PC EB1007",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "EB1007"),
+		},
+	},

 	{ }	/* terminating entry */
 };
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index ac47fd0..6a78b34 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -682,6 +682,7 @@ int radeon_device_init(struct radeon_device *rdev,
 	dma_bits = rdev->need_dma32 ? 32 : 40;
 	r = pci_set_dma_mask(rdev->pdev, DMA_BIT_MASK(dma_bits));
 	if (r) {
+		rdev->need_dma32 = true;
 		printk(KERN_WARNING "radeon: No suitable DMA available.\n");
 	}

diff --git a/include/drm/drm_mm.h b/include/drm/drm_mm.h
index 4c10be3..83a7495 100644
--- a/include/drm/drm_mm.h
+++ b/include/drm/drm_mm.h
@@ -44,7 +44,10 @@
 struct drm_mm_node {
 	struct list_head fl_entry;
 	struct list_head ml_entry;
-	int free;
+	unsigned free : 1;
+	unsigned scanned_block : 1;
+	unsigned scanned_prev_free : 1;
+	unsigned scanned_next_free : 1;
 	unsigned long start;
 	unsigned long size;
 	struct drm_mm *mm;
@@ -57,6 +60,11 @@ struct drm_mm {
 	struct list_head unused_nodes;
 	int num_unused;
 	spinlock_t unused_lock;
+	unsigned scan_alignment;
+	unsigned long scan_size;
+	unsigned long scan_hit_start;
+	unsigned scan_hit_size;
+	unsigned scanned_blocks;
 };

 /*
@@ -133,6 +141,11 @@ static inline struct drm_mm *drm_get_mm(struct drm_mm_node *block)
 	return block->mm;
 }

+void drm_mm_init_scan(struct drm_mm *mm, unsigned long size,
+		      unsigned alignment);
+int drm_mm_scan_add_block(struct drm_mm_node *node);
+int drm_mm_scan_remove_block(struct drm_mm_node *node);
+
 extern void drm_mm_debug_table(struct drm_mm *mm, const char *prefix);
 #ifdef CONFIG_DEBUG_FS
 int drm_mm_dump_table(struct seq_file *m, struct drm_mm *mm);
