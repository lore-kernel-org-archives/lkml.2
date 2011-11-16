Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab1KPQmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:42:07 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:54656 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756754Ab1KPQmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:42:03 -0500
Date: Wed, 16 Nov 2011 08:42:49 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Dave Airlie <airlied@linux.ie>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Clark <rob.clark@linaro.org>
Subject: Re: linux-next: build failure after merge of the drm tree
Message-ID: <20111116084249.24749230@jbarnes-desktop>
In-Reply-To: <20111116101623.7a59b686@lxorguk.ukuu.org.uk>
References: <20111116113007.5656a7b4823ba085a46c57ae@canb.auug.org.au>
	<20111116101623.7a59b686@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011 10:16:23 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > drivers/staging/gma500/framebuffer.c: In function 'psb_framebuffer_init':
> > drivers/staging/gma500/framebuffer.c:297:2: warning: passing argument 2 of 'drm_helper_mode_fill_fb_struct' from incompatible pointer type [enabled by default]
> > include/drm/drm_crtc_helper.h:121:12: note: expected 'struct drm_mode_fb_cmd2 *' but argument is of type 'struct drm_mode_fb_cmd *'
> > drivers/staging/gma500/framebuffer.c:564:2: warning: passing argument 2 of 'psb_framebuffer_create' from incompatible pointer type [enabled by default]
> > drivers/staging/gma500/framebuffer.c:314:32: note: expected 'struct drm_mode_fb_cmd *' but argument is of type 'struct drm_mode_fb_cmd2 *'
> 
> gma500 is frozen pending Dave Airlie's applying the patches moving it out
> of staging.
> 
> <Prod, prod>

Here's a patch to move things over to the new addfb2 interfaces at
least.

-- 
Jesse Barnes, Intel Open Source Technology Center

diff --git a/drivers/staging/gma500/framebuffer.c b/drivers/staging/gma500/framebuffer.c
index 1e77229..29f25b5 100644
--- a/drivers/staging/gma500/framebuffer.c
+++ b/drivers/staging/gma500/framebuffer.c
@@ -32,6 +32,7 @@
 #include <drm/drmP.h>
 #include <drm/drm.h>
 #include <drm/drm_crtc.h>
+#include <drm/drm_fb_helper.h>
 
 #include "psb_drv.h"
 #include "psb_intel_reg.h"
@@ -273,14 +274,17 @@ static struct fb_ops psbfb_unaccel_ops = {
  */
 static int psb_framebuffer_init(struct drm_device *dev,
 					struct psb_framebuffer *fb,
-					struct drm_mode_fb_cmd *mode_cmd,
+					struct drm_mode_fb_cmd2 *mode_cmd,
 					struct gtt_range *gt)
 {
+	u32 bpp, depth;
 	int ret;
 
-	if (mode_cmd->pitch & 63)
+	drm_helper_get_fb_bpp_depth(mode_cmd->pixel_format, &depth, &bpp);
+
+	if (mode_cmd->pitches[0] & 63)
 		return -EINVAL;
-	switch (mode_cmd->bpp) {
+	switch (bpp) {
 	case 8:
 	case 16:
 	case 24:
@@ -313,7 +317,7 @@ static int psb_framebuffer_init(struct drm_device *dev,
 
 static struct drm_framebuffer *psb_framebuffer_create
 			(struct drm_device *dev,
-			 struct drm_mode_fb_cmd *mode_cmd,
+			 struct drm_mode_fb_cmd2 *mode_cmd,
 			 struct gtt_range *gt)
 {
 	struct psb_framebuffer *fb;
@@ -387,27 +391,28 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	struct fb_info *info;
 	struct drm_framebuffer *fb;
 	struct psb_framebuffer *psbfb = &fbdev->pfb;
-	struct drm_mode_fb_cmd mode_cmd;
+	struct drm_mode_fb_cmd2 mode_cmd;
 	struct device *device = &dev->pdev->dev;
 	int size;
 	int ret;
 	struct gtt_range *backing;
 	int gtt_roll = 1;
+	u32 bpp, depth;
 
 	mode_cmd.width = sizes->surface_width;
 	mode_cmd.height = sizes->surface_height;
-	mode_cmd.bpp = sizes->surface_bpp;
+	bpp = sizes->surface_bpp;
 
 	/* No 24bit packed */
-	if (mode_cmd.bpp == 24)
-		mode_cmd.bpp = 32;
+	if (bpp == 24)
+		bpp = 32;
 
 	/* Acceleration via the GTT requires pitch to be 4096 byte aligned 
 	   (ie 1024 or 2048 pixels in normal use) */
-	mode_cmd.pitch =  ALIGN(mode_cmd.width * ((mode_cmd.bpp + 7) / 8), 4096);
-	mode_cmd.depth = sizes->surface_depth;
+	mode_cmd.pitches[0] =  ALIGN(mode_cmd.width * ((bpp + 7) / 8), 4096);
+	depth = sizes->surface_depth;
 
-	size = mode_cmd.pitch * mode_cmd.height;
+	size = mode_cmd.pitches[0] * mode_cmd.height;
 	size = ALIGN(size, PAGE_SIZE);
 
 	/* Allocate the framebuffer in the GTT with stolen page backing */
@@ -421,10 +426,10 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 
 		gtt_roll = 0;	/* Don't use GTT accelerated scrolling */
 
-		mode_cmd.pitch =  ALIGN(mode_cmd.width * ((mode_cmd.bpp + 7) / 8), 64);
-		mode_cmd.depth = sizes->surface_depth;
+		mode_cmd.pitches[0] =  ALIGN(mode_cmd.width * ((bpp + 7) / 8), 64);
+		depth = sizes->surface_depth;
 
-		size = mode_cmd.pitch * mode_cmd.height;
+		size = mode_cmd.pitches[0] * mode_cmd.height;
 		size = ALIGN(size, PAGE_SIZE);
 
 		/* Allocate the framebuffer in the GTT with stolen page
@@ -443,6 +448,8 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	}
 	info->par = fbdev;
 
+	mode_cmd.pixel_format = drm_mode_legacy_fb_format(bpp, depth);
+
 	ret = psb_framebuffer_init(dev, psbfb, &mode_cmd, backing);
 	if (ret)
 		goto out_unref;
@@ -555,7 +562,7 @@ static struct drm_framebuffer *psb_user_framebuffer_create
 	 *	Find the GEM object and thus the gtt range object that is
 	 *	to back this space
 	 */
-	obj = drm_gem_object_lookup(dev, filp, cmd->handle);
+	obj = drm_gem_object_lookup(dev, filp, cmd->handles[0]);
 	if (obj == NULL)
 		return ERR_PTR(-ENOENT);
 
