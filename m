Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab2KBRHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:07:16 -0400
Received: from mail.kernel.org ([198.145.19.201]:33202 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762363Ab2KBRHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:07:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 11/11] drm/nouveau: headless mode by default if pci class != vga display
Date: Fri,  2 Nov 2012 10:06:46 -0700
Message-Id: <20121102170315.043690403@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121102170314.204845540@linuxfoundation.org>
References: <20121102170314.204845540@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

This is to prevent nouveau from taking over the console on headless boards
such as Tesla.

Backport of upstream commit: e412e95a268fa8544858ebfe066826b290430d51

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

--- a/drivers/gpu/drm/nouveau/nouveau_drv.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.c
@@ -488,9 +488,7 @@ static int __init nouveau_init(void)
 #ifdef CONFIG_VGA_CONSOLE
 		if (vgacon_text_force())
 			nouveau_modeset = 0;
-		else
 #endif
-			nouveau_modeset = 1;
 	}
 
 	if (!nouveau_modeset)
diff --git a/drivers/gpu/drm/nouveau/nouveau_state.c b/drivers/gpu/drm/nouveau/nouveau_state.c
index c610144..f5e9584 100644
--- a/drivers/gpu/drm/nouveau/nouveau_state.c
+++ b/drivers/gpu/drm/nouveau/nouveau_state.c
@@ -50,6 +50,7 @@ static int nouveau_init_engine_ptrs(struct drm_device *dev)
 {
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
 	struct nouveau_engine *engine = &dev_priv->engine;
+	u32 pclass = dev->pdev->class >> 8;
 
 	switch (dev_priv->chipset & 0xf0) {
 	case 0x00:
@@ -428,7 +429,8 @@ static int nouveau_init_engine_ptrs(struct drm_device *dev)
 	}
 
 	/* headless mode */
-	if (nouveau_modeset == 2) {
+	if (nouveau_modeset == 2 ||
+	    (nouveau_modeset < 0 && pclass != PCI_CLASS_DISPLAY_VGA)) {
 		engine->display.early_init = nouveau_stub_init;
 		engine->display.late_takedown = nouveau_stub_takedown;
 		engine->display.create = nouveau_stub_init;
-- 
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe stable" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



