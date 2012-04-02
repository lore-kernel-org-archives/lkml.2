Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab2DBDhX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 23:37:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:35226 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab2DBDhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 23:37:22 -0400
Message-ID: <1333337833.30734.29.camel@pasglop>
Subject: [PATCH] nouveau: Fix crash when pci_ram_rom() returns a size of 0
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: dri-devel@lists.freedesktop.org
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@gmail.com>
Date: Mon, 02 Apr 2012 13:37:13 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b15b244d6e6e20964bd4b85306722cb60c3c0809 Mon Sep 17 00:00:00 2001
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 2 Apr 2012 13:28:18 +1000
Subject: 

Under some circumstances, pci_map_rom() can return a valid mapping
but a size of 0 (if it cannot find an image in the header).

This causes nouveau to try to kmalloc() a 0 sized pointer and
dereference it, which crashes.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Please send to Linus asap, without this, it crashes on the G5

 drivers/gpu/drm/nouveau/nouveau_bios.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bios.c b/drivers/gpu/drm/nouveau/nouveau_bios.c
index 637afe7..80963d0 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bios.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bios.c
@@ -177,14 +177,15 @@ bios_shadow_pci(struct nvbios *bios)
 
 	if (!pci_enable_rom(pdev)) {
 		void __iomem *rom = pci_map_rom(pdev, &length);
-		if (rom) {
+		if (rom && length) {
 			bios->data = kmalloc(length, GFP_KERNEL);
 			if (bios->data) {
 				memcpy_fromio(bios->data, rom, length);
 				bios->length = length;
 			}
-			pci_unmap_rom(pdev, rom);
 		}
+		if (rom)
+			pci_unmap_rom(pdev, rom);
 
 		pci_disable_rom(pdev);
 	}
-- 
1.7.9.5



