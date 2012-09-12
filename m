Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab2ILXdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:33:20 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64318 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab2ILXdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:33:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Alan Cox <alan@linux.intel.com>,
        Jakob Bornecrantz <jakob@vmware.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 045/108] drm: stop vmgfx driver explosion
Date: Wed, 12 Sep 2012 16:28:43 -0700
Message-Id: <20120912232455.254695257@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit f5869a8308f77e3dfdc2e3640842b285aa788ff8 upstream.

If you do a page flip with no flags set then event is NULL. If event is
NULL then the vmw_gfx driver likes to go digging into NULL and extracts
NULL->base.file_priv.

On a modern kernel with NULL mapping protection it's just another oops,
without it there are some "intriguing" possibilities.

What it should do is an open question but that for the driver owners to
sort out.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -1688,15 +1688,19 @@ int vmw_du_page_flip(struct drm_crtc *cr
 	struct vmw_private *dev_priv = vmw_priv(crtc->dev);
 	struct drm_framebuffer *old_fb = crtc->fb;
 	struct vmw_framebuffer *vfb = vmw_framebuffer_to_vfb(fb);
-	struct drm_file *file_priv = event->base.file_priv;
+	struct drm_file *file_priv ;
 	struct vmw_fence_obj *fence = NULL;
 	struct drm_clip_rect clips;
 	int ret;
 
+	if (event == NULL)
+		return -EINVAL;
+
 	/* require ScreenObject support for page flipping */
 	if (!dev_priv->sou_priv)
 		return -ENOSYS;
 
+	file_priv = event->base.file_priv;
 	if (!vmw_kms_screen_object_flippable(dev_priv, crtc))
 		return -EINVAL;
 


