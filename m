Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab1AFAql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:46:41 -0500
Received: from kroah.org ([198.145.64.141]:35824 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356Ab1AFAaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:16 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:04 2011
Message-Id: <20110106002304.390336880@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andy Lutomirski <luto@mit.edu>, Ben Skeggs <bskeggs@redhat.com>
Subject: [081/152] nouveau: Acknowledge HPD irq in handler, not bottom half
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andy Lutomirski <luto@mit.edu>

commit ab838338a2a9e0cb8346eb0cab9977be13e8dce5 upstream.

The old code generated an interrupt storm bad enough to completely
take down my system.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/nouveau/nouveau_drv.h  |    6 +++++
 drivers/gpu/drm/nouveau/nouveau_irq.c  |    1 
 drivers/gpu/drm/nouveau/nv50_display.c |   35 ++++++++++++++++++++++++---------
 3 files changed, 33 insertions(+), 9 deletions(-)

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
--- a/drivers/gpu/drm/nouveau/nouveau_irq.c
+++ b/drivers/gpu/drm/nouveau/nouveau_irq.c
@@ -52,6 +52,7 @@ nouveau_irq_preinstall(struct drm_device
 	if (dev_priv->card_type >= NV_50) {
 		INIT_WORK(&dev_priv->irq_work, nv50_display_irq_handler_bh);
 		INIT_WORK(&dev_priv->hpd_work, nv50_display_irq_hotplug_bh);
+		spin_lock_init(&dev_priv->hpd_state.lock);
 		INIT_LIST_HEAD(&dev_priv->vbl_waiting);
 	}
 }
--- a/drivers/gpu/drm/nouveau/nv50_display.c
+++ b/drivers/gpu/drm/nouveau/nv50_display.c
@@ -1012,11 +1012,18 @@ nv50_display_irq_hotplug_bh(struct work_
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
@@ -1058,10 +1065,6 @@ nv50_display_irq_hotplug_bh(struct work_
 			helper->dpms(connector->encoder, DRM_MODE_DPMS_OFF);
 	}
 
-	nv_wr32(dev, 0xe054, nv_rd32(dev, 0xe054));
-	if (dev_priv->chipset >= 0x90)
-		nv_wr32(dev, 0xe074, nv_rd32(dev, 0xe074));
-
 	drm_helper_hpd_irq_event(dev);
 }
 
@@ -1072,8 +1075,22 @@ nv50_display_irq_handler(struct drm_devi
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


