Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab1EBAuK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 20:50:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab1EBAtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 20:49:50 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 2/2] drm/nouveau: Check that the device is enabled before
 processing interrupt
To: airlied@linux.ie, dri-devel@lists.freedesktop.org
Cc: alex.williamson@redhat.com, linux-kernel@vger.kernel.org
Date: Sun, 01 May 2011 18:49:46 -0600
Message-ID: <20110502004940.2307.71738.stgit@ul30vt.home>
In-Reply-To: <20110502004806.2307.34136.stgit@ul30vt.home>
References: <20110502004806.2307.34136.stgit@ul30vt.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're likely to be sharing an interrupt line with other devices,
which means our handler might get called after we've turned off
the device via vga switcheroo.  This can lead to all sorts of
badness, like nv04_fifo_isr() spewing "PFIFO still angry after
100 spins, halt" to the console before the system enters a hard
hang.

We can avoid this by simply checking if the device is still
enabled before processing an interrupt.  To avoid races, flush
any inflight interrupts using synchronize_irq().  Note that
since pci_intx() is called after pci_save_state(),
pci_restore_state() will automatically re-enable INTx.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/gpu/drm/nouveau/nouveau_drv.c |    2 ++
 drivers/gpu/drm/nouveau/nouveau_irq.c |    3 +++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.c b/drivers/gpu/drm/nouveau/nouveau_drv.c
index 155ebdc..405d4f1 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.c
@@ -230,7 +230,9 @@ nouveau_pci_suspend(struct pci_dev *pdev, pm_message_t pm_state)
 	NV_INFO(dev, "And we're gone!\n");
 	pci_save_state(pdev);
 	if (pm_state.event == PM_EVENT_SUSPEND) {
+		pci_intx(pdev, 0);
 		pci_disable_device(pdev);
+		synchronize_irq(drm_dev_to_irq(dev));
 		pci_set_power_state(pdev, PCI_D3hot);
 	}
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_irq.c b/drivers/gpu/drm/nouveau/nouveau_irq.c
index 2ba7265..8fd17e6 100644
--- a/drivers/gpu/drm/nouveau/nouveau_irq.c
+++ b/drivers/gpu/drm/nouveau/nouveau_irq.c
@@ -78,6 +78,9 @@ nouveau_irq_handler(DRM_IRQ_ARGS)
 	u32 stat;
 	int i;
 
+	if (unlikely(!pci_is_enabled(dev->pdev)))
+		return IRQ_NONE;
+
 	stat = nv_rd32(dev, NV03_PMC_INTR_0);
 	if (!stat)
 		return IRQ_NONE;

