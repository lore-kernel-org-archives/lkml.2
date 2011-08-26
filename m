Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab1HZKXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 06:23:39 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49233 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab1HZKXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 06:23:38 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 4/9] gma500: do a pass over the FIXME tags
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 26 Aug 2011 11:18:41 +0100
Message-ID: <20110826101824.16760.61174.stgit@localhost.localdomain>
In-Reply-To: <20110826101734.16760.64364.stgit@localhost.localdomain>
References: <20110826101734.16760.64364.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/cdv_device.c          |    1 -
 drivers/staging/gma500/framebuffer.c         |    7 ++++--
 drivers/staging/gma500/gem.c                 |    5 +---
 drivers/staging/gma500/gtt.c                 |   30 ++++++++++++++++----------
 drivers/staging/gma500/intel_opregion.c      |    1 +
 drivers/staging/gma500/mdfld_intel_display.c |   12 ++++++----
 drivers/staging/gma500/mrst_crtc.c           |   16 ++++----------
 drivers/staging/gma500/psb_drv.c             |    1 -
 drivers/staging/gma500/psb_intel_lvds.c      |    1 -
 drivers/staging/gma500/psb_lid.c             |    2 --
 10 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/gma500/cdv_device.c b/drivers/staging/gma500/cdv_device.c
index 87614e0..8ec10ca 100644
--- a/drivers/staging/gma500/cdv_device.c
+++ b/drivers/staging/gma500/cdv_device.c
@@ -30,7 +30,6 @@
 #define VGA_SR_INDEX		0x3c4
 #define VGA_SR_DATA		0x3c5
 
-/* FIXME: should check if we are the active VGA device ?? */
 static void cdv_disable_vga(struct drm_device *dev)
 {
 	u8 sr1;
diff --git a/drivers/staging/gma500/framebuffer.c b/drivers/staging/gma500/framebuffer.c
index ebfde13..7748331 100644
--- a/drivers/staging/gma500/framebuffer.c
+++ b/drivers/staging/gma500/framebuffer.c
@@ -733,9 +733,12 @@ static void psb_setup_outputs(struct drm_device *dev)
 			clone_mask = (1 << INTEL_OUTPUT_MIPI2);
 			break;
 		case INTEL_OUTPUT_HDMI:
-			if (IS_MFLD(dev))
+		        /* HDMI on crtc 1 for SoC devices and crtc 0 for
+                           Cedarview. HDMI on Poulsbo is only via external
+			   logic */
+			if (IS_MFLD(dev) || IS_MRST(dev))
 				crtc_mask = (1 << 1);
-			else	/* FIXME: review Oaktrail */
+			else
 				crtc_mask = (1 << 0);	/* Cedarview */
 			clone_mask = (1 << INTEL_OUTPUT_HDMI);
 			break;
diff --git a/drivers/staging/gma500/gem.c b/drivers/staging/gma500/gem.c
index 65fdd6b..f6433c0 100644
--- a/drivers/staging/gma500/gem.c
+++ b/drivers/staging/gma500/gem.c
@@ -120,8 +120,7 @@ static int psb_gem_create(struct drm_file *file,
 	/* Initialize the extra goodies GEM needs to do all the hard work */
 	if (drm_gem_object_init(dev, &r->gem, size) != 0) {
 		psb_gtt_free_range(dev, r);
-		/* GEM doesn't give an error code and we don't have an
-		   EGEMSUCKS so make something up for now - FIXME */
+		/* GEM doesn't give an error code so use -ENOMEM */
 		dev_err(dev->dev, "GEM init failed for %lld\n", size);
 		return -ENOMEM;
 	}
@@ -191,8 +190,6 @@ int psb_gem_dumb_destroy(struct drm_file *file, struct drm_device *dev,
  *	The VMA was set up by GEM. In doing so it also ensured that the
  *	vma->vm_private_data points to the GEM object that is backing this
  *	mapping.
- *
- *	FIXME
  */
 int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
diff --git a/drivers/staging/gma500/gtt.c b/drivers/staging/gma500/gtt.c
index 461ead2..a246239 100644
--- a/drivers/staging/gma500/gtt.c
+++ b/drivers/staging/gma500/gtt.c
@@ -72,9 +72,8 @@ u32 *psb_gtt_entry(struct drm_device *dev, struct gtt_range *r)
  *	@r: our GTT range
  *
  *	Take our preallocated GTT range and insert the GEM object into
- *	the GTT.
- *
- *	FIXME: gtt lock ?
+ *	the GTT. This is protected via the gtt mutex which the caller
+ *	must hold.
  */
 static int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
 {
@@ -111,7 +110,8 @@ static int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
  *	@r: our GTT range
  *
  *	Remove a preallocated GTT range from the GTT. Overwrite all the
- *	page table entries with the dummy page
+ *	page table entries with the dummy page. This is protected via the gtt
+ *	mutex which the caller must hold.
  */
 
 static void psb_gtt_remove(struct drm_device *dev, struct gtt_range *r)
@@ -136,7 +136,8 @@ static void psb_gtt_remove(struct drm_device *dev, struct gtt_range *r)
  *	@gt: the gtt range
  *
  *	Pin and build an in kernel list of the pages that back our GEM object.
- *	While we hold this the pages cannot be swapped out
+ *	While we hold this the pages cannot be swapped out. This is protected
+ *	via the gtt mutex which the caller must hold.
  */
 static int psb_gtt_attach_pages(struct gtt_range *gt)
 {
@@ -158,7 +159,7 @@ static int psb_gtt_attach_pages(struct gtt_range *gt)
 	gt->npage = pages;
 
 	for (i = 0; i < pages; i++) {
-		/* FIXME: review flags later */
+		/* FIXME: needs updating as per mail from Hugh Dickins */
 		p = read_cache_page_gfp(mapping, i,
 					__GFP_COLD | GFP_KERNEL);
 		if (IS_ERR(p))
@@ -181,7 +182,8 @@ err:
  *
  *	Undo the effect of psb_gtt_attach_pages. At this point the pages
  *	must have been removed from the GTT as they could now be paged out
- *	and move bus address.
+ *	and move bus address. This is protected via the gtt mutex which the
+ *	caller must hold.
  */
 static void psb_gtt_detach_pages(struct gtt_range *gt)
 {
@@ -390,15 +392,18 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 	pg->gtt_phys_start = dev_priv->pge_ctl & PAGE_MASK;
 
 	/*
-	 *	FIXME: video mmu has hw bug to access 0x0D0000000,
-	 *	then make gatt start at 0x0e000,0000
+	 *	The video mmu has a hw bug when accessing 0x0D0000000.
+	 *	Make gatt start at 0x0e000,0000. This doesn't actually
+	 *	matter for us but may do if the video acceleration ever
+	 *	gets opened up.
 	 */
 	pg->mmu_gatt_start = 0xE0000000;
 
 	pg->gtt_start = pci_resource_start(dev->pdev, PSB_GTT_RESOURCE);
 	gtt_pages = pci_resource_len(dev->pdev, PSB_GTT_RESOURCE)
 								>> PAGE_SHIFT;
-	/* CDV workaround */
+	/* Some CDV firmware doesn't report this currently. In which case the
+	   system has 64 gtt pages */
 	if (pg->gtt_start == 0 || gtt_pages == 0) {
 		dev_err(dev->dev, "GTT PCI BAR not initialized.\n");
 		gtt_pages = 64;
@@ -412,13 +417,16 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 
 	if (pg->gatt_pages == 0 || pg->gatt_start == 0) {
 		static struct resource fudge;	/* Preferably peppermint */
-
 		/* This can occur on CDV SDV systems. Fudge it in this case.
 		   We really don't care what imaginary space is being allocated
 		   at this point */
 		dev_err(dev->dev, "GATT PCI BAR not initialized.\n");
 		pg->gatt_start = 0x40000000;
 		pg->gatt_pages = (128 * 1024 * 1024) >> PAGE_SHIFT;
+		/* This is a little confusing but in fact the GTT is providing
+		   a view from the GPU into memory and not vice versa. As such
+		   this is really allocating space that is not the same as the
+		   CPU address space on CDV */
 		fudge.start = 0x40000000;
 		fudge.end = 0x40000000 + 128 * 1024 * 1024 - 1;
 		fudge.name = "fudge";
diff --git a/drivers/staging/gma500/intel_opregion.c b/drivers/staging/gma500/intel_opregion.c
index d2e6037..d946bc1 100644
--- a/drivers/staging/gma500/intel_opregion.c
+++ b/drivers/staging/gma500/intel_opregion.c
@@ -20,6 +20,7 @@
  * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  * DEALINGS IN THE SOFTWARE.
  *
+ * FIXME: resolve with the i915 version
  */
 
 #include "psb_drv.h"
diff --git a/drivers/staging/gma500/mdfld_intel_display.c b/drivers/staging/gma500/mdfld_intel_display.c
index aa2ff55..8eb827e 100644
--- a/drivers/staging/gma500/mdfld_intel_display.c
+++ b/drivers/staging/gma500/mdfld_intel_display.c
@@ -282,7 +282,7 @@ static int mdfld_intel_crtc_cursor_move(struct drm_crtc *crtc, int x, int y)
 		return -EINVAL;
 	}
 		
-#if 1 /* FIXME_JLIU7 can't enalbe cursorB/C HW issue. need to remove after HW fix */
+#if 1 /* FIXME_JLIU7 can't enable cursorB/C HW issue. need to remove after HW fix */
 	if (pipe != 0)
 		return 0;
 #endif 
@@ -484,7 +484,7 @@ void mdfld_disable_crtc (struct drm_device *dev, int pipe)
 
 	/* FIXME_JLIU7 MDFLD_PO revisit */
 	/* Wait for vblank for the disable to take effect */
-// MDFLD_PO_JLIU7		psb_intel_wait_for_vblank(dev);
+/* MDFLD_PO_JLIU7		psb_intel_wait_for_vblank(dev); */
 
 	/* Next, disable display pipes */
 	temp = REG_READ(pipeconf_reg);
@@ -561,7 +561,6 @@ static void mdfld_crtc_dpms(struct drm_crtc *crtc, int mode)
 	    //gbdispstatus = true;
 	}
 
-
 /* FIXME_JLIU7 MDFLD_PO replaced w/ the following function */
 /* mdfld_dbi_dpms (struct drm_device *dev, int pipe, bool enabled) */
 
@@ -1150,8 +1149,11 @@ static int mdfld_crtc_mode_set(struct drm_crtc *crtc,
 			dev->mode_config.scaling_mode_property, &scalingType);
 
 	if (scalingType == DRM_MODE_SCALE_NO_SCALE) {
-		/*Moorestown doesn't have register support for centering so we need to
-		  mess with the h/vblank and h/vsync start and ends to get centering*/
+		/*
+		 *	Medfield doesn't have register support for centering so
+		 *	we need to mess with the h/vblank and h/vsync start and
+		 *	ends to get central
+		 */
 		int offsetX = 0, offsetY = 0;
 
 		offsetX = (adjusted_mode->crtc_hdisplay - mode->crtc_hdisplay) / 2;
diff --git a/drivers/staging/gma500/mrst_crtc.c b/drivers/staging/gma500/mrst_crtc.c
index 72464dd..c9311a5 100644
--- a/drivers/staging/gma500/mrst_crtc.c
+++ b/drivers/staging/gma500/mrst_crtc.c
@@ -521,12 +521,11 @@ int mrst_pipe_set_base(struct drm_crtc *crtc,
 			    int x, int y, struct drm_framebuffer *old_fb)
 {
 	struct drm_device *dev = crtc->dev;
-	/* struct drm_i915_master_private *master_priv; */
 	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
 	struct psb_framebuffer *psbfb = to_psb_fb(crtc->fb);
 	int pipe = psb_intel_crtc->pipe;
 	unsigned long start, offset;
-	/* FIXME: check if we need this surely MRST is pipe 0 only */
+
 	int dspbase = (pipe == 0 ? DSPALINOFF : DSPBBASE);
 	int dspsurf = (pipe == 0 ? DSPASURF : DSPBSURF);
 	int dspstride = (pipe == 0) ? DSPASTRIDE : DSPBSTRIDE;
@@ -572,15 +571,10 @@ int mrst_pipe_set_base(struct drm_crtc *crtc,
 	}
 	REG_WRITE(dspcntr_reg, dspcntr);
 
-	if (0 /* FIXMEAC - check what PSB needs */) {
-		REG_WRITE(dspbase, offset);
-		REG_READ(dspbase);
-		REG_WRITE(dspsurf, start);
-		REG_READ(dspsurf);
-	} else {
-		REG_WRITE(dspbase, start + offset);
-		REG_READ(dspbase);
-	}
+	REG_WRITE(dspbase, offset);
+	REG_READ(dspbase);
+	REG_WRITE(dspsurf, start);
+	REG_READ(dspsurf);
 
 pipe_set_base_exit:
 	gma_power_end(dev);
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 10c8ecd..34cf24a 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -183,7 +183,6 @@ static void psb_lastclose(struct drm_device *dev)
 
 static void psb_do_takedown(struct drm_device *dev)
 {
-	/* FIXME: do we need to clean up the gtt here ? */
 }
 
 static int psb_do_init(struct drm_device *dev)
diff --git a/drivers/staging/gma500/psb_intel_lvds.c b/drivers/staging/gma500/psb_intel_lvds.c
index c6436da..8b951e3 100644
--- a/drivers/staging/gma500/psb_intel_lvds.c
+++ b/drivers/staging/gma500/psb_intel_lvds.c
@@ -382,7 +382,6 @@ bool psb_intel_lvds_mode_fixup(struct drm_encoder *encoder,
 	if (psb_intel_output->type == INTEL_OUTPUT_MIPI2)
 		panel_fixed_mode = mode_dev->panel_fixed_mode2;
 
-	/* FIXME: review for Medfield */
 	/* PSB requires the LVDS is on pipe B, MRST has only one pipe anyway */
 	if (!IS_MRST(dev) && psb_intel_crtc->pipe == 0) {
 		printk(KERN_ERR "Can't support LVDS on pipe A\n");
diff --git a/drivers/staging/gma500/psb_lid.c b/drivers/staging/gma500/psb_lid.c
index af32851..b867aab 100644
--- a/drivers/staging/gma500/psb_lid.c
+++ b/drivers/staging/gma500/psb_lid.c
@@ -52,8 +52,6 @@ static void psb_lid_timer_func(unsigned long data)
 			pp_status = REG_READ(PP_STATUS);
 		} while ((pp_status & PP_ON) == 0);
 	}
-		/* printk(KERN_INFO"%s: lid: closed\n", __FUNCTION__); */
-
 	dev_priv->lid_last_state =  readl(lid_state);
 
 lid_timer_schedule:

