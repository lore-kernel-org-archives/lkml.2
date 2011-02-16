Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933538Ab1BPAwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:52:20 -0500
Received: from kroah.org ([198.145.64.141]:46303 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933502Ab1BPAwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:52:09 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:16 2011
Message-Id: <20110216002115.997475131@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:22:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [patch 170/176] drm/i915: Recognise non-VGA display devices
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 934f992c763ae1e5eefcce8af769c16444085df7 upstream.

Starting with SandyBridge (though possible with earlier hacked BIOSes),
the BIOS may initialise the IGFX as secondary to a discrete GPU. Prior,
it would simply disable the integrated GPU. So we adjust our PCI class
mask to match any DISPLAY_CLASS device.

In such a configuration, the IGFX is not a primary VGA controller and
so should not take part in VGA arbitration, and the error return from
vga_client_register() is expected.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_dma.c |   10 ++++++++--
 drivers/gpu/drm/i915/i915_drv.c |    2 +-
 drivers/gpu/vga/vgaarb.c        |    2 +-
 3 files changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1419,9 +1419,15 @@ static int i915_load_modeset_init(struct
 	if (ret)
 		DRM_INFO("failed to find VBIOS tables\n");
 
-	/* if we have > 1 VGA cards, then disable the radeon VGA resources */
+	/* If we have > 1 VGA cards, then we need to arbitrate access
+	 * to the common VGA resources.
+	 *
+	 * If we are a secondary display controller (!PCI_DISPLAY_CLASS_VGA),
+	 * then we do not take part in VGA arbitration and the
+	 * vga_client_register() fails with -ENODEV.
+	 */
 	ret = vga_client_register(dev->pdev, dev, NULL, i915_vga_set_decode);
-	if (ret)
+	if (ret && ret != -ENODEV)
 		goto cleanup_ringbuffer;
 
 	ret = vga_switcheroo_register_client(dev->pdev,
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -53,7 +53,7 @@ extern int intel_agp_enabled;
 
 #define INTEL_VGA_DEVICE(id, info) {		\
 	.class = PCI_CLASS_DISPLAY_VGA << 8,	\
-	.class_mask = 0xffff00,			\
+	.class_mask = 0xff0000,			\
 	.vendor = 0x8086,			\
 	.device = id,				\
 	.subvendor = PCI_ANY_ID,		\
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -636,7 +636,7 @@ int vga_client_register(struct pci_dev *
 			void (*irq_set_state)(void *cookie, bool state),
 			unsigned int (*set_vga_decode)(void *cookie, bool decode))
 {
-	int ret = -1;
+	int ret = -ENODEV;
 	struct vga_device *vgadev;
 	unsigned long flags;
 


