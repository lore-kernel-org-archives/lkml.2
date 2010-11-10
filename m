Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab0KJVri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 16:47:38 -0500
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:44852 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757085Ab0KJVrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 16:47:37 -0500
X-Greylist: delayed 899 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Nov 2010 16:47:37 EST
X-AuditID: 1209190e-b7b3bae000000a71-62-4cdb0f6db0ed
From: Andy Lutomirski <luto@MIT.EDU>
To: Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 2/2] nouveau: Acknowledge HPD irq in handler, not bottom half
Date: Wed, 10 Nov 2010 16:32:05 -0500
Message-Id: <cb559f4c96f82d5bf0c132b3330aecd4885a0dda.1289423199.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <cover.1289423299.git.luto@mit.edu>
References: <cover.1289423299.git.luto@mit.edu>
In-Reply-To: <cover.1289423299.git.luto@mit.edu>
References: <AANLkTimcEiBJtWx2tA=dqm6881g0B7NomXFsZauzfgy8@mail.gmail.com> <cover.1289423299.git.luto@mit.edu>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old code generated an interrupt storm bad enough to completely
take down my system.

This only fixes the bits that are defined nouveau_regs.h.  Newer hardware
uses another register that isn't described, and I don't have that hardware
to test.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Cc: <stable@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_drv.h  |    5 +++++
 drivers/gpu/drm/nouveau/nouveau_irq.c  |    1 +
 drivers/gpu/drm/nouveau/nv50_display.c |   17 +++++++++++++----
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.h b/drivers/gpu/drm/nouveau/nouveau_drv.h
index b1be617..b6c62cc 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -531,6 +531,11 @@ struct drm_nouveau_private {
 	struct work_struct irq_work;
 	struct work_struct hpd_work;
 
+	struct {
+		spinlock_t lock;
+		uint32_t hpd0_bits;
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
index 83a7d27..0df08e3 100644
--- a/drivers/gpu/drm/nouveau/nv50_display.c
+++ b/drivers/gpu/drm/nouveau/nv50_display.c
@@ -1014,7 +1014,12 @@ nv50_display_irq_hotplug_bh(struct work_struct *work)
 	uint32_t unplug_mask, plug_mask, change_mask;
 	uint32_t hpd0, hpd1 = 0;
 
-	hpd0 = nv_rd32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL) & nv_rd32(dev, NV50_PCONNECTOR_HOTPLUG_INTR);
+	spin_lock_irq(&dev_priv->hpd_state.lock);
+	hpd0 = dev_priv->hpd_state.hpd0_bits;
+	dev_priv->hpd_state.hpd0_bits = 0;
+	spin_unlock_irq(&dev_priv->hpd_state.lock);
+
+	hpd0 &= nv_rd32(dev, NV50_PCONNECTOR_HOTPLUG_INTR);
 	if (dev_priv->chipset >= 0x90)
 		hpd1 = nv_rd32(dev, 0xe074) & nv_rd32(dev, 0xe070);
 
@@ -1058,7 +1063,6 @@ nv50_display_irq_hotplug_bh(struct work_struct *work)
 			helper->dpms(connector->encoder, DRM_MODE_DPMS_OFF);
 	}
 
-	nv_wr32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL, nv_rd32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL));
 	if (dev_priv->chipset >= 0x90)
 		nv_wr32(dev, 0xe074, nv_rd32(dev, 0xe074));
 
@@ -1072,8 +1076,13 @@ nv50_display_irq_handler(struct drm_device *dev)
 	uint32_t delayed = 0;
 
 	if (nv_rd32(dev, NV50_PMC_INTR_0) & NV50_PMC_INTR_0_HOTPLUG) {
-		if (!work_pending(&dev_priv->hpd_work))
-			queue_work(dev_priv->wq, &dev_priv->hpd_work);
+		uint32_t hpd0_bits = nv_rd32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL);
+		nv_wr32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL, hpd0_bits);
+		spin_lock(&dev_priv->hpd_state.lock);
+		dev_priv->hpd_state.hpd0_bits |= hpd0_bits;
+		spin_unlock(&dev_priv->hpd_state.lock);
+
+		queue_work(dev_priv->wq, &dev_priv->hpd_work);
 	}
 
 	while (nv_rd32(dev, NV50_PMC_INTR_0) & NV50_PMC_INTR_0_DISPLAY) {
-- 
1.7.3.2

