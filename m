Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab0KJV0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 16:26:37 -0500
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:57690 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756633Ab0KJV0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 16:26:36 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Nov 2010 16:26:36 EST
X-AuditID: 12074425-b7c98ae000000a04-d8-4cdb0cdfa315
From: Andy Lutomirski <luto@MIT.EDU>
To: Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 0/2] Fix nouveau-related freezes
Date: Wed, 10 Nov 2010 16:21:26 -0500
Message-Id: <cover.1289423199.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <AANLkTimcEiBJtWx2tA=dqm6881g0B7NomXFsZauzfgy8@mail.gmail.com>
References: <AANLkTimcEiBJtWx2tA=dqm6881g0B7NomXFsZauzfgy8@mail.gmail.com>
X-Brightmail-Tracker: AAAAARagEl4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nouveau takes down my system quite reliably when any hotplug event occurs.
The bug happens because the IRQ handler didn't acknowledge the hotplug
state until the bottom half, so the card generated a new interrupt
immediately, starving the bottom half and permanently starving that CPU
(and hence the bottom half).

Even with this fix, a lot of the IRQ code looks rather broken.

This is tested on 2.6.36 (and makes the system stable for me), but it also
applies cleanly to 2.6.37 (untested, but surely also necessary).  Fedora 14's
2.6.35 kernels seem to have to same problem for me, so I suspect that 2.6.35
needs this fix as well.  (All of my tests are on an NV50 card.)

Andy Lutomirski (2):
  Use existing defines for NV50 hotplug registers
  nouveau: Acknowledge HPD irq in handler, not bottom half

 drivers/gpu/drm/nouveau/nouveau_drv.h  |    5 +++++
 drivers/gpu/drm/nouveau/nouveau_irq.c  |    1 +
 drivers/gpu/drm/nouveau/nv50_display.c |   21 +++++++++++++++------
 3 files changed, 21 insertions(+), 6 deletions(-)

-- 
1.7.3.2

>From 8055e8485f28491fe6219c512e379b4b89bcd465 Mon Sep 17 00:00:00 2001
Message-Id: <8055e8485f28491fe6219c512e379b4b89bcd465.1289423199.git.luto@mit.edu>
In-Reply-To: <cover.1289423199.git.luto@mit.edu>
References: <AANLkTimcEiBJtWx2tA=dqm6881g0B7NomXFsZauzfgy8@mail.gmail.com>
	<cover.1289423199.git.luto@mit.edu>
From: Andy Lutomirski <luto@mit.edu>
Date: Wed, 10 Nov 2010 14:49:12 -0500
Subject: [PATCH 1/2] Use existing defines for NV50 hotplug registers

This doesn't change code at all, but it makes it a lot easier
to understand.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Cc: <stable@kernel.org>
---
 drivers/gpu/drm/nouveau/nv50_display.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nv50_display.c b/drivers/gpu/drm/nouveau/nv50_display.c
index 612fa6d..83a7d27 100644
--- a/drivers/gpu/drm/nouveau/nv50_display.c
+++ b/drivers/gpu/drm/nouveau/nv50_display.c
@@ -453,8 +453,8 @@ static int nv50_display_disable(struct drm_device *dev)
 	nv_wr32(dev, NV50_PDISPLAY_INTR_EN, 0x00000000);
 
 	/* disable hotplug interrupts */
-	nv_wr32(dev, 0xe054, 0xffffffff);
-	nv_wr32(dev, 0xe050, 0x00000000);
+	nv_wr32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL, 0xffffffff);
+	nv_wr32(dev, NV50_PCONNECTOR_HOTPLUG_INTR, 0x00000000);
 	if (dev_priv->chipset >= 0x90) {
 		nv_wr32(dev, 0xe074, 0xffffffff);
 		nv_wr32(dev, 0xe070, 0x00000000);
@@ -1014,7 +1014,7 @@ nv50_display_irq_hotplug_bh(struct work_struct *work)
 	uint32_t unplug_mask, plug_mask, change_mask;
 	uint32_t hpd0, hpd1 = 0;
 
-	hpd0 = nv_rd32(dev, 0xe054) & nv_rd32(dev, 0xe050);
+	hpd0 = nv_rd32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL) & nv_rd32(dev, NV50_PCONNECTOR_HOTPLUG_INTR);
 	if (dev_priv->chipset >= 0x90)
 		hpd1 = nv_rd32(dev, 0xe074) & nv_rd32(dev, 0xe070);
 
@@ -1058,7 +1058,7 @@ nv50_display_irq_hotplug_bh(struct work_struct *work)
 			helper->dpms(connector->encoder, DRM_MODE_DPMS_OFF);
 	}
 
-	nv_wr32(dev, 0xe054, nv_rd32(dev, 0xe054));
+	nv_wr32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL, nv_rd32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL));
 	if (dev_priv->chipset >= 0x90)
 		nv_wr32(dev, 0xe074, nv_rd32(dev, 0xe074));
 
-- 
1.7.3.2


>From cb559f4c96f82d5bf0c132b3330aecd4885a0dda Mon Sep 17 00:00:00 2001
Message-Id: <cb559f4c96f82d5bf0c132b3330aecd4885a0dda.1289423199.git.luto@mit.edu>
In-Reply-To: <cover.1289423199.git.luto@mit.edu>
References: <AANLkTimcEiBJtWx2tA=dqm6881g0B7NomXFsZauzfgy8@mail.gmail.com>
	<cover.1289423199.git.luto@mit.edu>
From: Andy Lutomirski <luto@mit.edu>
Date: Wed, 10 Nov 2010 15:08:39 -0500
Subject: [PATCH 2/2] nouveau: Acknowledge HPD irq in handler, not bottom half

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

