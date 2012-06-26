Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab2FZEBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 00:01:04 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:36339 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750728Ab2FZEAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 00:00:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAM8y6U9bdWOb/2dsb2JhbABEtiyBB4IYAQEFJ1IQIDE8GwcSiA+5JJE3A5UukAGCYQ
X-IronPort-AV: E=Sophos;i="4.77,476,1336341600"; 
   d="scan'208";a="532687845"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com,
        boyod.yang@siliconmotion.com.cn
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 2/4] staging: sm7xxfb: dead code removal
Date: Tue, 26 Jun 2012 06:00:15 +0200
Message-Id: <1340683217-7986-3-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1340683217-7986-1-git-send-email-jmunhoz@igalia.com>
References: <1340683217-7986-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patch removes dead code related to BaseAddressInVRAM. It fixes
comment on RAM control bits too.

Tested with SM712.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index a8c5652..4ab149b 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -53,7 +53,7 @@ struct smtcfb_info {
 	u_int width;
 	u_int height;
 	u_int hz;
-	u_long BaseAddressInVRAM;
+
 	u8 chipRevID;
 };
 
@@ -220,17 +220,9 @@ static void sm712_set_timing(struct smtcfb_info *sfb)
 static void sm712_setpalette(int regno, unsigned red, unsigned green,
 			     unsigned blue, struct fb_info *info)
 {
-	struct smtcfb_info *sfb = info->par;
+	/* set bit 5:4 = 01 (write LCD RAM only) */
+	smtc_seqw(0x66, (smtc_seqr(0x66) & 0xC3) | 0x10);
 
-	if (sfb->BaseAddressInVRAM)
-		/*
-		 * second display palette for dual head. Enable CRT RAM, 6-bit
-		 * RAM
-		 */
-		smtc_seqw(0x66, (smtc_seqr(0x66) & 0xC3) | 0x20);
-	else
-		/* primary display palette. Enable LCD RAM only, 6-bit RAM */
-		smtc_seqw(0x66, (smtc_seqr(0x66) & 0xC3) | 0x10);
 	smtc_mmiowb(regno, dac_reg);
 	smtc_mmiowb(red >> 10, dac_val);
 	smtc_mmiowb(green >> 10, dac_val);
@@ -932,8 +924,6 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 		goto failed;
 
 	smtcfb_setmode(sfb);
-	/* Primary display starting from 0 position */
-	sfb->BaseAddressInVRAM = 0;
 
 	err = register_framebuffer(&sfb->fb);
 	if (err < 0)
-- 
1.7.10

