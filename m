Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189Ab2LMOM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:12:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44909 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933157Ab2LMOMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:12:22 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Skeggs <bskeggs@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 187/241] drm/nouveau: headless mode by default if pci class != vga display
Date: Thu, 13 Dec 2012 11:59:12 -0200
Message-Id: <1355407206-17100-188-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit e412e95a268fa8544858ebfe066826b290430d51 upstream.

This is to prevent nouveau from taking over the console on headless boards
such as Tesla.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/nouveau/nouveau_drv.c   |    2 --
 drivers/gpu/drm/nouveau/nouveau_state.c |    4 +++-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.c b/drivers/gpu/drm/nouveau/nouveau_drv.c
index 714acfb..83b9bde 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.c
@@ -473,9 +473,7 @@ static int __init nouveau_init(void)
 #ifdef CONFIG_VGA_CONSOLE
 		if (vgacon_text_force())
 			nouveau_modeset = 0;
-		else
 #endif
-			nouveau_modeset = 1;
 	}
 
 	if (!nouveau_modeset)
diff --git a/drivers/gpu/drm/nouveau/nouveau_state.c b/drivers/gpu/drm/nouveau/nouveau_state.c
index 22a90a0..91a5064 100644
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
1.7.9.5

