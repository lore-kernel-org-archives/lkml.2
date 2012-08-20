Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab2HTO13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:27:29 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53579 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab2HTO10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:27:26 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] drm: stop vmgfx driver explosion
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Date: Mon, 20 Aug 2012 15:44:52 +0100
Message-ID: <20120820144438.6255.39723.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

If you do a page flip with no flags set then event is NULL. If event is
NULL then the vmw_gfx driver likes to go digging into NULL and extracts
NULL->base.file_priv.

On a modern kernel with NULL mapping protection it's just another oops,
without it there are some "intriguing" possibilities.

What it should do is an open question but that for the driver owners to
sort out.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 6b0078f..c50724b 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -1688,15 +1688,19 @@ int vmw_du_page_flip(struct drm_crtc *crtc,
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
 

