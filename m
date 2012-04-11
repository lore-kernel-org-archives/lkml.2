Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965183Ab2DKXWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:22:43 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:51108 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965161Ab2DKXWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:22:39 -0400
Message-Id: <20120411231039.651814727@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 25/59] drm: Validate requested virtual size against allocated fb size
In-Reply-To: <20120411231213.GA13124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 62fb376e214d3c1bfdf6fbb77dac162f6da04d7e upstream.

mplayer -vo fbdev tries to create a screen that is twice as tall as the
allocated framebuffer for "doublebuffering". By default, and all in-tree
users, only sufficient memory is allocated and mapped to satisfy the
smallest framebuffer and the virtual size is no larger than the actual.
For these users, we should therefore reject any userspace request to
create a screen that requires a buffer larger than the framebuffer
originally allocated.

References: https://bugs.freedesktop.org/show_bug.cgi?id=38138
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_fb_helper.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -610,9 +610,13 @@ int drm_fb_helper_check_var(struct fb_va
 		return -EINVAL;
 
 	/* Need to resize the fb object !!! */
-	if (var->bits_per_pixel > fb->bits_per_pixel || var->xres > fb->width || var->yres > fb->height) {
+	if (var->bits_per_pixel > fb->bits_per_pixel ||
+	    var->xres > fb->width || var->yres > fb->height ||
+	    var->xres_virtual > fb->width || var->yres_virtual > fb->height) {
 		DRM_DEBUG("fb userspace requested width/height/bpp is greater than current fb "
-			  "object %dx%d-%d > %dx%d-%d\n", var->xres, var->yres, var->bits_per_pixel,
+			  "request %dx%d-%d (virtual %dx%d) > %dx%d-%d\n",
+			  var->xres, var->yres, var->bits_per_pixel,
+			  var->xres_virtual, var->yres_virtual,
 			  fb->width, fb->height, fb->bits_per_pixel);
 		return -EINVAL;
 	}


