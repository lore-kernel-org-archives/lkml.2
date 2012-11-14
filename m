Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab2KNFuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:50:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54913 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751723Ab2KNFtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:49:55 -0500
Message-Id: <20121114053934.489149439@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:39:38 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 05/82] drm/nouveau: headless mode by default if pci class != vga display
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit e412e95a268fa8544858ebfe066826b290430d51 upstream.

This is to prevent nouveau from taking over the console on headless boards
such as Tesla.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/nouveau/nouveau_drv.c   | 2 --
 drivers/gpu/drm/nouveau/nouveau_state.c | 4 +++-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.c b/drivers/gpu/drm/nouveau/nouveau_drv.c
index 1fcc69a..a06eb3d 100644
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


