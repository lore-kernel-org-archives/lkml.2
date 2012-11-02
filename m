Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763109Ab2KBRIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:08:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:33544 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755283Ab2KBRIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:08:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 23/24] drm/nouveau: fix suspend/resume when in headless mode
Date: Fri,  2 Nov 2012 10:07:11 -0700
Message-Id: <20121102170249.073389025@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121102170247.406319110@linuxfoundation.org>
References: <20121102170247.406319110@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

Backport of fixes from upstream commit:
9430738d80223a1cd791a2baa74fa170d3df1262

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_drv.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_drv.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.c
@@ -188,11 +188,13 @@ nouveau_pci_suspend(struct pci_dev *pdev
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
@@ -359,10 +361,12 @@ nouveau_pci_resume(struct pci_dev *pdev)
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


