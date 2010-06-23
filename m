Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab0FWD4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 23:56:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938Ab0FWD4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 23:56:17 -0400
From: Dave Airlie <airlied@gmail.com>
To: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] vt/console: try harder to print output when panicing
Date: Wed, 23 Jun 2010 13:12:59 +1000
Message-Id: <1277262779-19338-1-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesse Barnes <jbarnes@virtuousgeek.org>

Jesse's initial patch commit said:

"At panic time (i.e. when oops_in_progress is set) we should try a bit
harder to update the screen and make sure output gets to the VT, since
some drivers are capable of flipping back to it.

So make sure we try to unblank and update the display if called from a
panic context."

I've enhanced this to add a flag to the vc that console layer can set
to indicate they want this behaviour to occur. This also adds support
to fbcon for that flag and adds an fb flag for drivers to indicate
they want to use the support. It enables this for KMS drivers.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/char/vt.c                       |   13 +++++++++----
 drivers/gpu/drm/i915/intel_fb.c         |    4 +---
 drivers/gpu/drm/nouveau/nouveau_fbcon.c |    1 +
 drivers/gpu/drm/radeon/radeon_fb.c      |    2 +-
 drivers/video/console/fbcon.c           |    4 +++-
 include/linux/console_struct.h          |    1 +
 include/linux/fb.h                      |    4 ++++
 include/linux/vt_kern.h                 |    7 +++++++
 8 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 7cdb6ee..6e04c9e 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -698,7 +698,10 @@ void redraw_screen(struct vc_data *vc, int is_switch)
 			update_attr(vc);
 			clear_buffer_attributes(vc);
 		}
-		if (update && vc->vc_mode != KD_GRAPHICS)
+
+		/* Forcibly update if we're panicing */
+		if ((update && vc->vc_mode != KD_GRAPHICS) ||
+		    vt_force_oops_output(vc))
 			do_update_region(vc, vc->vc_origin, vc->vc_screenbuf_size / 2);
 	}
 	set_cursor(vc);
@@ -736,6 +739,7 @@ static void visual_init(struct vc_data *vc, int num, int init)
 	vc->vc_hi_font_mask = 0;
 	vc->vc_complement_mask = 0;
 	vc->vc_can_do_color = 0;
+	vc->vc_panic_force_write = false;
 	vc->vc_sw->con_init(vc, init);
 	if (!vc->vc_complement_mask)
 		vc->vc_complement_mask = vc->vc_can_do_color ? 0x7700 : 0x0800;
@@ -2498,7 +2502,7 @@ static void vt_console_print(struct console *co, const char *b, unsigned count)
 		goto quit;
 	}
 
-	if (vc->vc_mode != KD_TEXT)
+	if (vc->vc_mode != KD_TEXT && !vt_force_oops_output(vc))
 		goto quit;
 
 	/* undraw cursor first */
@@ -3703,7 +3707,8 @@ void do_unblank_screen(int leaving_gfx)
 		return;
 	}
 	vc = vc_cons[fg_console].d;
-	if (vc->vc_mode != KD_TEXT)
+	/* Try to unblank in oops case too */
+	if (vc->vc_mode != KD_TEXT && !vt_force_oops_output(vc))
 		return; /* but leave console_blanked != 0 */
 
 	if (blankinterval) {
@@ -3712,7 +3717,7 @@ void do_unblank_screen(int leaving_gfx)
 	}
 
 	console_blanked = 0;
-	if (vc->vc_sw->con_blank(vc, 0, leaving_gfx))
+	if (vc->vc_sw->con_blank(vc, 0, leaving_gfx) || vt_force_oops_output(vc))
 		/* Low-level driver cannot restore -> do it ourselves */
 		update_screen(vc);
 	if (console_blank_hook)
diff --git a/drivers/gpu/drm/i915/intel_fb.c b/drivers/gpu/drm/i915/intel_fb.c
index c3c5052..bd5d87a 100644
--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -128,7 +128,7 @@ static int intelfb_create(struct intel_fbdev *ifbdev,
 
 	strcpy(info->fix.id, "inteldrmfb");
 
-	info->flags = FBINFO_DEFAULT;
+	info->flags = FBINFO_DEFAULT | FBINFO_CAN_FORCE_OUTPUT;
 	info->fbops = &intelfb_ops;
 
 	/* setup aperture base/size for vesafb takeover */
@@ -146,8 +146,6 @@ static int intelfb_create(struct intel_fbdev *ifbdev,
 	info->fix.smem_start = dev->mode_config.fb_base + obj_priv->gtt_offset;
 	info->fix.smem_len = size;
 
-	info->flags = FBINFO_DEFAULT;
-
 	info->screen_base = ioremap_wc(dev->agp->base + obj_priv->gtt_offset,
 				       size);
 	if (!info->screen_base) {
diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index c9a4a0d..9b2d3b7 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -250,6 +250,7 @@ nouveau_fbcon_create(struct nouveau_fbdev *nfbdev,
 		info->flags = FBINFO_DEFAULT | FBINFO_HWACCEL_COPYAREA |
 			      FBINFO_HWACCEL_FILLRECT |
 			      FBINFO_HWACCEL_IMAGEBLIT;
+	info->flags |= FBINFO_CAN_FORCE_OUTPUT;
 	info->fbops = &nouveau_fbcon_ops;
 	info->fix.smem_start = dev->mode_config.fb_base + nvbo->bo.offset -
 			       dev_priv->vm_vram_base;
diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
index dc1634b..dbf8696 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -224,7 +224,7 @@ static int radeonfb_create(struct radeon_fbdev *rfbdev,
 
 	drm_fb_helper_fill_fix(info, fb->pitch, fb->depth);
 
-	info->flags = FBINFO_DEFAULT;
+	info->flags = FBINFO_DEFAULT | FBINFO_CAN_FORCE_OUTPUT;
 	info->fbops = &radeonfb_ops;
 
 	tmp = radeon_bo_gpu_offset(rbo) - rdev->mc.vram_start;
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index b0a3fa0..7eadb35 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -283,7 +283,8 @@ static inline int fbcon_is_inactive(struct vc_data *vc, struct fb_info *info)
 	struct fbcon_ops *ops = info->fbcon_par;
 
 	return (info->state != FBINFO_STATE_RUNNING ||
-		vc->vc_mode != KD_TEXT || ops->graphics);
+		vc->vc_mode != KD_TEXT || ops->graphics) &&
+		!vt_force_oops_output(vc);
 }
 
 static inline int get_color(struct vc_data *vc, struct fb_info *info,
@@ -1073,6 +1074,7 @@ static void fbcon_init(struct vc_data *vc, int init)
 	if (p->userfont)
 		charcnt = FNTCHARCNT(p->fontdata);
 
+	vc->vc_panic_force_write = !!(info->flags & FBINFO_CAN_FORCE_OUTPUT);
 	vc->vc_can_do_color = (fb_get_color_depth(&info->var, &info->fix)!=1);
 	vc->vc_complement_mask = vc->vc_can_do_color ? 0x7700 : 0x0800;
 	if (charcnt == 256) {
diff --git a/include/linux/console_struct.h b/include/linux/console_struct.h
index 38fe59d..d7d9acd 100644
--- a/include/linux/console_struct.h
+++ b/include/linux/console_struct.h
@@ -105,6 +105,7 @@ struct vc_data {
 	struct vc_data **vc_display_fg;		/* [!] Ptr to var holding fg console for this display */
 	unsigned long	vc_uni_pagedir;
 	unsigned long	*vc_uni_pagedir_loc;  /* [!] Location of uni_pagedir variable for this console */
+	bool vc_panic_force_write; /* when oops/panic this VC can accept forced output/blanking */
 	/* additional information is in vt_kern.h */
 };
 
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 8e5a9df..25f4950 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -812,6 +812,10 @@ struct fb_tile_ops {
  */
 #define FBINFO_BE_MATH  0x100000
 
+/* report to the VT layer that this fb driver can accept forced console
+   output like oopses */
+#define FBINFO_CAN_FORCE_OUTPUT     0x200000
+
 struct fb_info {
 	int node;
 	int flags;
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 7f56db4..56cce34 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -100,6 +100,13 @@ extern int unbind_con_driver(const struct consw *csw, int first, int last,
 			     int deflt);
 int vty_init(const struct file_operations *console_fops);
 
+static inline bool vt_force_oops_output(struct vc_data *vc)
+{
+	if (oops_in_progress && vc->vc_panic_force_write)
+		return true;
+	return false;
+}
+
 /*
  * vc_screen.c shares this temporary buffer with the console write code so that
  * we can easily avoid touching user space while holding the console spinlock.
-- 
1.7.1

