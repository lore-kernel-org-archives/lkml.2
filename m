Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221Ab2LMO1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:27:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44905 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933159Ab2LMOMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:12:19 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Skeggs <bskeggs@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 186/241] drm/nouveau: fix suspend/resume when in headless mode
Date: Thu, 13 Dec 2012 11:59:11 -0200
Message-Id: <1355407206-17100-187-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

Backport of fixes from upstream commit:
9430738d80223a1cd791a2baa74fa170d3df1262

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/nouveau/nouveau_drv.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.c b/drivers/gpu/drm/nouveau/nouveau_drv.c
index cad254c..714acfb 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.c
@@ -187,11 +187,13 @@ nouveau_pci_suspend(struct pci_dev *pdev, pm_message_t pm_state)
 	if (dev->switch_power_state == DRM_SWITCH_POWER_OFF)
 		return 0;
 
-	NV_INFO(dev, "Disabling display...\n");
-	nouveau_display_fini(dev);
+	if (dev->mode_config.num_crtc) {
+		NV_INFO(dev, "Disabling display...\n");
+		nouveau_display_fini(dev);
 
-	NV_INFO(dev, "Disabling fbcon...\n");
-	nouveau_fbcon_set_suspend(dev, 1);
+		NV_INFO(dev, "Disabling fbcon...\n");
+		nouveau_fbcon_set_suspend(dev, 1);
+	}
 
 	NV_INFO(dev, "Unpinning framebuffer(s)...\n");
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
@@ -358,10 +360,12 @@ nouveau_pci_resume(struct pci_dev *pdev)
 			NV_ERROR(dev, "Could not pin/map cursor.\n");
 	}
 
-	nouveau_fbcon_set_suspend(dev, 0);
-	nouveau_fbcon_zfill_all(dev);
+	if (dev->mode_config.num_crtc) {
+		nouveau_fbcon_set_suspend(dev, 0);
+		nouveau_fbcon_zfill_all(dev);
 
-	nouveau_display_init(dev);
+		nouveau_display_init(dev);
+	}
 
 	/* Force CLUT to get re-loaded during modeset */
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
-- 
1.7.9.5

