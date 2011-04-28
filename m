Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab1D1FUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 01:20:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab1D1FUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 01:20:35 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] drm/nouveau: Remove interrupt handler around suspend/resume
To: airlied@linux.ie, dri-devel@lists.freedesktop.org
Cc: alex.williamson@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 27 Apr 2011 23:20:17 -0600
Message-ID: <20110428051926.10111.28554.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're often using a shared interrupt line for nouveau, so we have
to be prepared that it could be called at any point in time.  If
we've suspended the device via vga switcheroo and get a stray
interrupt on the line from another device, we'll read back -1 from
the device and head down all sorts of strange paths, most of which
eventually lock the system.

On my system (Asus UL30VT) the interrupt line is shared with USB.
Attempting to disable the USB bluetooth device seems to trigger
a stray interrupt that ends up in nv04_fifo_isr() where we
eventually hit the "PFIFO still angry after 100 spins, halt",
which kills the system.

Using free_irq/request_irq around the suspend seems to be a
reliable fix.  Attempting to flag the device state in
nouvea_irq_handler(), similar to the intel_lid_notify() fix
is too racy since we can power off the device as an interrupt
is being processed.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/gpu/drm/nouveau/nouveau_drv.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.c b/drivers/gpu/drm/nouveau/nouveau_drv.c
index 155ebdc..91f2aca 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.c
@@ -229,6 +229,10 @@ nouveau_pci_suspend(struct pci_dev *pdev, pm_message_t pm_state)
 
 	NV_INFO(dev, "And we're gone!\n");
 	pci_save_state(pdev);
+
+	pci_intx(pdev, 0);
+	free_irq(drm_dev_to_irq(dev), dev);
+
 	if (pm_state.event == PM_EVENT_SUSPEND) {
 		pci_disable_device(pdev);
 		pci_set_power_state(pdev, PCI_D3hot);
@@ -255,6 +259,8 @@ nouveau_pci_resume(struct pci_dev *pdev)
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
 	struct nouveau_engine *engine = &dev_priv->engine;
 	struct drm_crtc *crtc;
+	char *irqname;
+	unsigned long sh_flags = 0;
 	int ret, i;
 
 	if (dev->switch_power_state == DRM_SWITCH_POWER_OFF)
@@ -265,6 +271,22 @@ nouveau_pci_resume(struct pci_dev *pdev)
 	NV_INFO(dev, "We're back, enabling device...\n");
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
+
+	if (drm_core_check_feature(dev, DRIVER_IRQ_SHARED))
+		sh_flags = IRQF_SHARED;
+
+	if (dev->devname)
+		irqname = dev->devname;
+	else
+		irqname = dev->driver->name;
+
+	ret = request_irq(drm_dev_to_irq(dev), dev->driver->irq_handler,
+			  sh_flags, irqname, dev);
+	if (ret < 0) {
+		NV_ERROR(dev, "error re-requesting irq: %d\n", ret);
+		return ret;
+	}
+
 	if (pci_enable_device(pdev))
 		return -1;
 	pci_set_master(dev->pdev);

