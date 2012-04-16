Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab2DPU0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:26:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab2DPU00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:26:26 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, airlied@redhat.com
Subject: [PATCH V2 2/4] vga-switcheroo: Use vga_default_device()
Date: Mon, 16 Apr 2012 16:26:03 -0400
Message-Id: <1334607965-9582-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1334607965-9582-1-git-send-email-mjg@redhat.com>
References: <1334607965-9582-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vga-switcheroo currently changes the default VGA device by fiddling with
the IORESOURCE_ROM_SHADOW flag on the device. This isn't strictly accurate,
since there's no guarantee that switching also changes the ROM decoding.
Switch over to using the vgaarb functions for this.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: airlied@redhat.com
---
 drivers/gpu/vga/vga_switcheroo.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index 9a2c805..44c664e 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -28,6 +28,8 @@
 #include <linux/pci.h>
 #include <linux/vga_switcheroo.h>
 
+#include <linux/vgaarb.h>
+
 struct vga_switcheroo_client {
 	struct pci_dev *pdev;
 	struct fb_info *fb_info;
@@ -140,7 +142,7 @@ int vga_switcheroo_register_client(struct pci_dev *pdev,
 	vgasr_priv.clients[index].reprobe = reprobe;
 	vgasr_priv.clients[index].can_switch = can_switch;
 	vgasr_priv.clients[index].id = -1;
-	if (pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW)
+	if (pdev == vga_default_device())
 		vgasr_priv.clients[index].active = true;
 
 	vgasr_priv.registered_clients |= (1 << index);
@@ -248,9 +250,8 @@ static int vga_switchto_stage1(struct vga_switcheroo_client *new_client)
 	if (new_client->pwr_state == VGA_SWITCHEROO_OFF)
 		vga_switchon(new_client);
 
-	/* swap shadow resource to denote boot VGA device has changed so X starts on new device */
-	active->pdev->resource[PCI_ROM_RESOURCE].flags &= ~IORESOURCE_ROM_SHADOW;
-	new_client->pdev->resource[PCI_ROM_RESOURCE].flags |= IORESOURCE_ROM_SHADOW;
+	vga_set_default_device(new_client->pdev);
+
 	return 0;
 }
 
-- 
1.7.10

