Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab0KJLET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 06:04:19 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:40783 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab0KJLER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 06:04:17 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        lethal@linux-sh.org
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Subject: [PATCHv2] sisfb: limit POST memory test according to PCI resource length
Date: Wed, 10 Nov 2010 13:04:19 +0200
Message-Id: <1289387059-31760-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the POST memory test fails, the driver may access illegal
memory areas. Instead of hard coding the maximum size, set it
according to the PCI resource length (an additional check is needed in
sisfb_post_map_vram() to ensure it's big enough). DRAM sizing will later
adjust video_size to the correct value.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---

v2: Add a check to sisfb_post_map_vram().

 drivers/video/sis/sis_main.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index b52f8e4..3dde12b 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -4181,6 +4181,9 @@ static void __devinit
 sisfb_post_map_vram(struct sis_video_info *ivideo, unsigned int *mapsize,
 			unsigned int min)
 {
+	if (*mapsize < (min << 20))
+		return;
+
 	ivideo->video_vbase = ioremap(ivideo->video_base, (*mapsize));
 
 	if(!ivideo->video_vbase) {
@@ -4514,7 +4517,7 @@ sisfb_post_sis300(struct pci_dev *pdev)
 	} else {
 #endif
 		/* Need to map max FB size for finding out about RAM size */
-		mapsize = 64 << 20;
+		mapsize = ivideo->video_size;
 		sisfb_post_map_vram(ivideo, &mapsize, 4);
 
 		if(ivideo->video_vbase) {
@@ -4680,7 +4683,7 @@ sisfb_post_xgi_ramsize(struct sis_video_info *ivideo)
 	orSISIDXREG(SISSR, 0x20, (0x80 | 0x04));
 
 	/* Need to map max FB size for finding out about RAM size */
-	mapsize = 256 << 20;
+	mapsize = ivideo->video_size;
 	sisfb_post_map_vram(ivideo, &mapsize, 32);
 
 	if(!ivideo->video_vbase) {
@@ -5936,6 +5939,7 @@ sisfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	ivideo->video_base = pci_resource_start(pdev, 0);
+	ivideo->video_size = pci_resource_len(pdev, 0);
 	ivideo->mmio_base  = pci_resource_start(pdev, 1);
 	ivideo->mmio_size  = pci_resource_len(pdev, 1);
 	ivideo->SiS_Pr.RelIO = pci_resource_start(pdev, 2) + 0x30;
-- 
1.5.6.5

