Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab0KJXEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:04:52 -0500
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:55583 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757427Ab0KJXEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:04:49 -0500
X-AuditID: 12074423-b7bd0ae000000a00-da-4cdb2510685f
From: Andy Lutomirski <luto@MIT.EDU>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 2/2] nouveau: Acknowledge HPD irq in handler, not bottom half
Date: Wed, 10 Nov 2010 18:04:15 -0500
Message-Id: <4cfbe0d94276d29512cd5945ac93818cdbb6e2f7.1289430026.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <cover.1289430026.git.luto@mit.edu>
References: <cover.1289430026.git.luto@mit.edu>
In-Reply-To: <cover.1289430026.git.luto@mit.edu>
References: <cover.1289430026.git.luto@mit.edu>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old code generated an interrupt storm bad enough to completely
take down my system.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 drivers/gpu/drm/nouveau/nouveau_drv.h  |    6 +++++
 drivers/gpu/drm/nouveau/nouveau_irq.c  |    1 +
 drivers/gpu/drm/nouveau/nv50_display.c |   35 +++++++++++++++++++++++--------
 3 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.h b/drivers/gpu/drm/nouveau/nouveau_drv.h
index b1be617..c926d88 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -531,6 +531,12 @@ struct drm_nouveau_private {
 	struct work_struct irq_work;
 	struct work_struct hpd_work;
 
+	struct {
+		spinlock_t lock;
+		uint32_t hpd0_bits;
+		uint32_t hpd1_bits;
+	} hpd_state;
+
 	struct list_head vbl_waiting;
 
 	struct {
diff --git a/drivers/gpu/drm/nouveau/nouveau_irq.c b/drivers/gpu/drm/nouveau/nouveau_irq.c
index 794b0ee..b62a601 100644
--- a/drivers/gpu/drm/nouveau/nouveau_irq.c
+++ b/drivers/gpu/drm/nouveau/nouveau_irq.c
@@ -52,6 +52,7 @@ nouveau_irq_preinstall(struct drm_device *dev)
 	if (dev_priv->card_type >= NV_50) {
 		INIT_WORK(&dev_priv->irq_work, nv50_display_irq_handler_bh);
 		INIT_WORK(&dev_priv->hpd_work, nv50_display_irq_hotplug_bh);
+		spin_lock_init(&dev_priv->hpd_state.lock);
 		INIT_LIST_HEAD(&dev_priv->vbl_waiting);
 	}
 }
diff --git a/drivers/gpu/drm/nouveau/nv50_display.c b/drivers/gpu/drm/nouveau/nv50_display.c
index 83a7d27..014f69c 100644
--- a/drivers/gpu/drm/nouveau/nv50_display.c
+++ b/drivers/gpu/drm/nouveau/nv50_display.c
@@ -1012,11 +1012,18 @@ nv50_display_irq_hotplug_bh(struct work_struct *work)
 	struct drm_connector *connector;
 	const uint32_t gpio_reg[4] = { 0xe104, 0xe108, 0xe280, 0xe284 };
 	uint32_t unplug_mask, plug_mask, change_mask;
-	uint32_t hpd0, hpd1 = 0;
+	uint32_t hpd0, hpd1;
 
-	hpd0 = nv_rd32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL) & nv_rd32(dev, NV50_PCONNECTOR_HOTPLUG_INTR);
+	spin_lock_irq(&dev_priv->hpd_state.lock);
+	hpd0 = dev_priv->hpd_state.hpd0_bits;
+	dev_priv->hpd_state.hpd0_bits = 0;
+	hpd1 = dev_priv->hpd_state.hpd1_bits;
+	dev_priv->hpd_state.hpd1_bits = 0;
+	spin_unlock_irq(&dev_priv->hpd_state.lock);
+
+	hpd0 &= nv_rd32(dev, NV50_PCONNECTOR_HOTPLUG_INTR);
 	if (dev_priv->chipset >= 0x90)
-		hpd1 = nv_rd32(dev, 0xe074) & nv_rd32(dev, 0xe070);
+		hpd1 &= nv_rd32(dev, 0xe070);
 
 	plug_mask   = (hpd0 & 0x0000ffff) | (hpd1 << 16);
 	unplug_mask = (hpd0 >> 16) | (hpd1 & 0xffff0000);
@@ -1058,10 +1065,6 @@ nv50_display_irq_hotplug_bh(struct work_struct *work)
 			helper->dpms(connector->encoder, DRM_MODE_DPMS_OFF);
 	}
 
-	nv_wr32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL, nv_rd32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL));
-	if (dev_priv->chipset >= 0x90)
-		nv_wr32(dev, 0xe074, nv_rd32(dev, 0xe074));
-
 	drm_helper_hpd_irq_event(dev);
 }
 
@@ -1072,8 +1075,22 @@ nv50_display_irq_handler(struct drm_device *dev)
 	uint32_t delayed = 0;
 
 	if (nv_rd32(dev, NV50_PMC_INTR_0) & NV50_PMC_INTR_0_HOTPLUG) {
-		if (!work_pending(&dev_priv->hpd_work))
-			queue_work(dev_priv->wq, &dev_priv->hpd_work);
+		uint32_t hpd0_bits, hpd1_bits = 0;
+
+		hpd0_bits = nv_rd32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL);
+		nv_wr32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL, hpd0_bits);
+
+		if (dev_priv->chipset >= 0x90) {
+			hpd1_bits = nv_rd32(dev, 0xe074);
+			nv_wr32(dev, 0xe074, hpd1_bits);
+		}
+
+		spin_lock(&dev_priv->hpd_state.lock);
+		dev_priv->hpd_state.hpd0_bits |= hpd0_bits;
+		dev_priv->hpd_state.hpd1_bits |= hpd1_bits;
+		spin_unlock(&dev_priv->hpd_state.lock);
+
+		queue_work(dev_priv->wq, &dev_priv->hpd_work);
 	}
 
 	while (nv_rd32(dev, NV50_PMC_INTR_0) & NV50_PMC_INTR_0_DISPLAY) {
-- 
1.7.3.2

