Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab1BBAo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:33759 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab1BBAo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="598622478"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: luto@mit.edu, bskeggs@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [76/139] nouveau: Acknowledge HPD irq in handler, not bottom half
Message-Id: <20110202004433.522DD3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Andy Lutomirski <luto@mit.edu>

commit ab838338a2a9e0cb8346eb0cab9977be13e8dce5 upstream.

The old code generated an interrupt storm bad enough to completely
take down my system.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/nouveau/nouveau_drv.h  |    6 +++++
 drivers/gpu/drm/nouveau/nouveau_irq.c  |    1 
 drivers/gpu/drm/nouveau/nv50_display.c |   35 ++++++++++++++++++++++++---------
 3 files changed, 33 insertions(+), 9 deletions(-)

Index: linux-2.6.35.y/drivers/gpu/drm/nouveau/nouveau_drv.h
===================================================================
--- linux-2.6.35.y.orig/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ linux-2.6.35.y/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -522,6 +522,12 @@ struct drm_nouveau_private {
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
Index: linux-2.6.35.y/drivers/gpu/drm/nouveau/nouveau_irq.c
===================================================================
--- linux-2.6.35.y.orig/drivers/gpu/drm/nouveau/nouveau_irq.c
+++ linux-2.6.35.y/drivers/gpu/drm/nouveau/nouveau_irq.c
@@ -52,6 +52,7 @@ nouveau_irq_preinstall(struct drm_device
 	if (dev_priv->card_type == NV_50) {
 		INIT_WORK(&dev_priv->irq_work, nv50_display_irq_handler_bh);
 		INIT_WORK(&dev_priv->hpd_work, nv50_display_irq_hotplug_bh);
+		spin_lock_init(&dev_priv->hpd_state.lock);
 		INIT_LIST_HEAD(&dev_priv->vbl_waiting);
 	}
 }
Index: linux-2.6.35.y/drivers/gpu/drm/nouveau/nv50_display.c
===================================================================
--- linux-2.6.35.y.orig/drivers/gpu/drm/nouveau/nv50_display.c
+++ linux-2.6.35.y/drivers/gpu/drm/nouveau/nv50_display.c
@@ -930,11 +930,18 @@ nv50_display_irq_hotplug_bh(struct work_
 	struct drm_connector *connector;
 	const uint32_t gpio_reg[4] = { 0xe104, 0xe108, 0xe280, 0xe284 };
 	uint32_t unplug_mask, plug_mask, change_mask;
-	uint32_t hpd0, hpd1 = 0;
+	uint32_t hpd0, hpd1;
 
-	hpd0 = nv_rd32(dev, 0xe054) & nv_rd32(dev, 0xe050);
+	spin_lock_irq(&dev_priv->hpd_state.lock);
+	hpd0 = dev_priv->hpd_state.hpd0_bits;
+	dev_priv->hpd_state.hpd0_bits = 0;
+	hpd1 = dev_priv->hpd_state.hpd1_bits;
+	dev_priv->hpd_state.hpd1_bits = 0;
+	spin_unlock_irq(&dev_priv->hpd_state.lock);
+
+	hpd0 &= nv_rd32(dev, 0xe050);
 	if (dev_priv->chipset >= 0x90)
-		hpd1 = nv_rd32(dev, 0xe074) & nv_rd32(dev, 0xe070);
+		hpd1 &= nv_rd32(dev, 0xe070);
 
 	plug_mask   = (hpd0 & 0x0000ffff) | (hpd1 << 16);
 	unplug_mask = (hpd0 >> 16) | (hpd1 & 0xffff0000);
@@ -976,10 +983,6 @@ nv50_display_irq_hotplug_bh(struct work_
 			helper->dpms(connector->encoder, DRM_MODE_DPMS_OFF);
 	}
 
-	nv_wr32(dev, 0xe054, nv_rd32(dev, 0xe054));
-	if (dev_priv->chipset >= 0x90)
-		nv_wr32(dev, 0xe074, nv_rd32(dev, 0xe074));
-
 	drm_helper_hpd_irq_event(dev);
 }
 
@@ -990,8 +993,22 @@ nv50_display_irq_handler(struct drm_devi
 	uint32_t delayed = 0;
 
 	if (nv_rd32(dev, NV50_PMC_INTR_0) & NV50_PMC_INTR_0_HOTPLUG) {
-		if (!work_pending(&dev_priv->hpd_work))
-			queue_work(dev_priv->wq, &dev_priv->hpd_work);
+		uint32_t hpd0_bits, hpd1_bits = 0;
+
+		hpd0_bits = nv_rd32(dev, 0xe054);
+		nv_wr32(dev, 0xe054, hpd0_bits);
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
