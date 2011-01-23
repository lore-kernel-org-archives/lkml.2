Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab1AWLBV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 06:01:21 -0500
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:51791
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751351Ab1AWLBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 06:01:20 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH] drm/i915,agp/intel: Do not clear stolen entries
Date: Sun, 23 Jan 2011 11:01:12 +0000
Message-Id: <1295780472-8475-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20110123011221.GB1805@nowhere>
References: <20110123011221.GB1805@nowhere>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can only utilize the stolen portion of the GTT if we are in sole
charge of the hardware. This is only true if using GEM and KMS,
otherwise VESA continues to access stolen memory.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---

Frederic, updated patch attached. The bug was that clear_range took (start,
count) and I was passing in (start, end) so we were dereferencing past the
end of the valid pages.
-Chris

---
 drivers/char/agp/intel-gtt.c        |   19 +++++++++----------
 drivers/gpu/drm/i915/i915_drv.h     |    5 ++++-
 drivers/gpu/drm/i915/i915_gem.c     |   10 +++++++---
 drivers/gpu/drm/i915/i915_gem_gtt.c |    4 ++++
 4 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 826ab09..fab3d32 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -68,6 +68,7 @@ static struct _intel_private {
 	phys_addr_t gma_bus_addr;
 	u32 PGETBL_save;
 	u32 __iomem *gtt;		/* I915G */
+	bool clear_fake_agp; /* on first access via agp, fill with scratch */
 	int num_dcache_entries;
 	union {
 		void __iomem *i9xx_flush_page;
@@ -869,21 +870,12 @@ static int intel_fake_agp_free_gatt_table(struct agp_bridge_data *bridge)
 
 static int intel_fake_agp_configure(void)
 {
-	int i;
-
 	if (!intel_enable_gtt())
 	    return -EIO;
 
+	intel_private.clear_fake_agp = true;
 	agp_bridge->gart_bus_addr = intel_private.gma_bus_addr;
 
-	for (i = 0; i < intel_private.base.gtt_total_entries; i++) {
-		intel_private.driver->write_entry(intel_private.scratch_page_dma,
-						  i, 0);
-	}
-	readl(intel_private.gtt+i-1);	/* PCI Posting. */
-
-	global_cache_flush();
-
 	return 0;
 }
 
@@ -945,6 +937,13 @@ static int intel_fake_agp_insert_entries(struct agp_memory *mem,
 {
 	int ret = -EINVAL;
 
+	if (intel_private.clear_fake_agp) {
+		int start = intel_private.base.stolen_size / PAGE_SIZE;
+		int end = intel_private.base.gtt_mappable_entries;
+		intel_gtt_clear_range(start, end - start);
+		intel_private.clear_fake_agp = false;
+	}
+
 	if (INTEL_GTT_GEN == 1 && type == AGP_DCACHE_MEMORY)
 		return i810_insert_dcache_entries(mem, pg_start, type);
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 5969f46..a0149c6 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -543,8 +543,11 @@ typedef struct drm_i915_private {
 		/** List of all objects in gtt_space. Used to restore gtt
 		 * mappings on resume */
 		struct list_head gtt_list;
-		/** End of mappable part of GTT */
+
+		/** Usable portion of the GTT for GEM */
+		unsigned long gtt_start;
 		unsigned long gtt_mappable_end;
+		unsigned long gtt_end;
 
 		struct io_mapping *gtt_mapping;
 		int gtt_mtrr;
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 812b97b..b1d7461 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -140,12 +140,16 @@ void i915_gem_do_init(struct drm_device *dev,
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
 
-	drm_mm_init(&dev_priv->mm.gtt_space, start,
-		    end - start);
+	drm_mm_init(&dev_priv->mm.gtt_space, start, end - start);
 
+	dev_priv->mm.gtt_start = start;
+	dev_priv->mm.gtt_mappable_end = mappable_end;
+	dev_priv->mm.gtt_end = end;
 	dev_priv->mm.gtt_total = end - start;
 	dev_priv->mm.mappable_gtt_total = min(end, mappable_end) - start;
-	dev_priv->mm.gtt_mappable_end = mappable_end;
+
+	/* Take over this portion of the GTT */
+	intel_gtt_clear_range(start / PAGE_SIZE, end / PAGE_SIZE);
 }
 
 int
diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c b/drivers/gpu/drm/i915/i915_gem_gtt.c
index 70433ae..9c41f54 100644
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -34,6 +34,10 @@ void i915_gem_restore_gtt_mappings(struct drm_device *dev)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct drm_i915_gem_object *obj;
 
+	/* First fill with scratch pages */
+	intel_gtt_clear_range(dev_priv->mm.gtt_start / PAGE_SIZE,
+			      dev_priv->mm.gtt_end / PAGE_SIZE);
+
 	list_for_each_entry(obj, &dev_priv->mm.gtt_list, gtt_list) {
 		i915_gem_clflush_object(obj);
 
-- 
1.7.2.3

