Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab2KNGLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:11:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54916 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751776Ab2KNFt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:49:56 -0500
Message-Id: <20121114053934.360360087@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:39:37 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Skeggs <bskeggs@redhat.com>, Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 04/82] drm/nouveau: fix suspend/resume when in headless mode
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

commit 9430738d80223a1cd791a2baa74fa170d3df1262 upstream.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
[jrnieder@gmail.com: backport to 3.2: make fbcon suspend/resume
 handling conditional in a vague hope that this will approximate what
 the original does for 3.3+]
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/nouveau/nouveau_drv.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.c b/drivers/gpu/drm/nouveau/nouveau_drv.c
index 9791d13c9e3b..4ab35b588664 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.c
@@ -178,8 +178,10 @@ nouveau_pci_suspend(struct pci_dev *pdev, pm_message_t pm_state)
 	if (dev->switch_power_state == DRM_SWITCH_POWER_OFF)
 		return 0;
 
-	NV_INFO(dev, "Disabling fbcon acceleration...\n");
-	nouveau_fbcon_save_disable_accel(dev);
+	if (dev->mode_config.num_crtc) {
+		NV_INFO(dev, "Disabling fbcon acceleration...\n");
+		nouveau_fbcon_save_disable_accel(dev);
+	}
 
 	NV_INFO(dev, "Unpinning framebuffer(s)...\n");
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
@@ -246,10 +248,12 @@ nouveau_pci_suspend(struct pci_dev *pdev, pm_message_t pm_state)
 		pci_set_power_state(pdev, PCI_D3hot);
 	}
 
-	console_lock();
-	nouveau_fbcon_set_suspend(dev, 1);
-	console_unlock();
-	nouveau_fbcon_restore_accel(dev);
+	if (dev->mode_config.num_crtc) {
+		console_lock();
+		nouveau_fbcon_set_suspend(dev, 1);
+		console_unlock();
+		nouveau_fbcon_restore_accel(dev);
+	}
 	return 0;
 
 out_abort:
@@ -275,7 +279,8 @@ nouveau_pci_resume(struct pci_dev *pdev)
 	if (dev->switch_power_state == DRM_SWITCH_POWER_OFF)
 		return 0;
 
-	nouveau_fbcon_save_disable_accel(dev);
+	if (dev->mode_config.num_crtc)
+		nouveau_fbcon_save_disable_accel(dev);
 
 	NV_INFO(dev, "We're back, enabling device...\n");
 	pci_set_power_state(pdev, PCI_D0);
@@ -376,15 +381,18 @@ nouveau_pci_resume(struct pci_dev *pdev)
 		nv_crtc->lut.depth = 0;
 	}
 
-	console_lock();
-	nouveau_fbcon_set_suspend(dev, 0);
-	console_unlock();
+	if (dev->mode_config.num_crtc) {
+		console_lock();
+		nouveau_fbcon_set_suspend(dev, 0);
+		console_unlock();
 
-	nouveau_fbcon_zfill_all(dev);
+		nouveau_fbcon_zfill_all(dev);
+	}
 
 	drm_helper_resume_force_mode(dev);
 
-	nouveau_fbcon_restore_accel(dev);
+	if (dev->mode_config.num_crtc)
+		nouveau_fbcon_restore_accel(dev);
 	return 0;
 }
 


