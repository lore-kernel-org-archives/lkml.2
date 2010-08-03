Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab0HCPol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:44:41 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37607 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186Ab0HCPob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:44:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bL+7KwW9N4yevrwCUlIiQi7p63SobCrOLrRBlOYZ78tAafZZ2Wyb+XxpgoWhDzMmzg
         0lBEOyDL0yagjKF5SxU9HVWEKf43/m/T1As/PozS6QSl7cBn4cudZWkiisjw1Baed4Aj
         iZwd9pz3onPLocyzIctlM/fyx2DbxBP8Z8kx4=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Thomas Winischhofer <thomas@winischhofer.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roel Kluin <roel.kluin@gmail.com>, Dan Carpenter <error27@gmail.com>,
        Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] sis: do not use PCI resources before pci_enable_device()
Date: Tue,  3 Aug 2010 19:44:27 +0400
Message-Id: <1280850268-6298-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ and resource[] may not have correct values until
after PCI hotplug setup occurs at pci_enable_device() time.

The semantic match that finds this problem is as follows:

// <smpl>
@@
identifier x;
identifier request ~= "pci_request.*|pci_resource.*";
@@

(
* x->irq
|
* x->resource
|
* request(x, ...)
)
 ...
*pci_enable_device(x)
// </smpl>

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/video/sis/sis_main.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 559bf17..47ba64e 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -5782,6 +5782,11 @@ sisfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ivideo->subsysvendor = pdev->subsystem_vendor;
 	ivideo->subsysdevice = pdev->subsystem_device;
 
+	if (!ivideo->sisvga_enabled && pci_enable_device(pdev)) {
+		framebuffer_release(sis_fb_info);
+		return -EIO;
+	}
+
 #ifndef MODULE
 	if(sisfb_mode_idx == -1) {
 		sisfb_get_vga_mode_from_kernel();
@@ -5923,14 +5928,6 @@ sisfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 #endif
 
-	if(!ivideo->sisvga_enabled) {
-		if(pci_enable_device(pdev)) {
-			if(ivideo->nbridge) pci_dev_put(ivideo->nbridge);
-			pci_set_drvdata(pdev, NULL);
-			framebuffer_release(sis_fb_info);
-			return -EIO;
-		}
-	}
 
 	ivideo->video_base = pci_resource_start(pdev, 0);
 	ivideo->mmio_base  = pci_resource_start(pdev, 1);
-- 
1.7.0.4

