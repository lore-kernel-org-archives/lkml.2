Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab2FMWYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:24:38 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:43838 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754897Ab2FMWWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:22:04 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX199fvE8cZt9kuD3QzeWrQ/QexSP9uh1QJbZ4efCfx
	eEI3EkpZhDypmd
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Peter Huewe <peterhuewe@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/14] staging/xgifb: Consolidate XGINew_SetDRAMSize{,20}Reg
Date: Thu, 14 Jun 2012 00:21:43 +0200
Message-Id: <1339626112-20671-5-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
References: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch consolidates the almost identical functions
XGINew_SetDRAMSizeReg and XGINew_SetDRAMSize20Reg as they are
implemented identically except one division factor.

The changed factor is now reflected in the input data.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_init.c |   54 +++-----------------------------------
 1 files changed, 5 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index dd6a519..726c335 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -7,10 +7,10 @@
 #include "vb_setmode.h"
 
 static const unsigned short XGINew_DDRDRAM_TYPE340[4][5] = {
-	{ 2, 13, 9, 64, 0x45},
-	{ 2, 12, 9, 32, 0x35},
-	{ 2, 12, 8, 16, 0x31},
-	{ 2, 11, 8,  8, 0x21} };
+	{ 2, 13, 9, 16, 0x45},
+	{ 2, 12, 9,  8, 0x35},
+	{ 2, 12, 8,  4, 0x31},
+	{ 2, 11, 8,  2, 0x21} };
 
 static const unsigned short XGINew_DDRDRAM_TYPE20[12][5] = {
 	{ 2, 14, 11, 128, 0x5D},
@@ -591,50 +591,6 @@ static void XGINew_SetDRAMSizingType(int index,
 	/* should delay 50 ns */
 }
 
-static unsigned short XGINew_SetDRAMSizeReg(int index,
-		const unsigned short DRAMTYPE_TABLE[][5],
-		struct vb_device_info *pVBInfo)
-{
-	unsigned short data = 0, memsize = 0;
-	int RankSize;
-	unsigned char ChannelNo;
-
-	RankSize = DRAMTYPE_TABLE[index][3] * pVBInfo->ram_bus / 32;
-	data = xgifb_reg_get(pVBInfo->P3c4, 0x13);
-	data &= 0x80;
-
-	if (data == 0x80)
-		RankSize *= 2;
-
-	data = 0;
-
-	if (pVBInfo->ram_channel == 3)
-		ChannelNo = 4;
-	else
-		ChannelNo = pVBInfo->ram_channel;
-
-	if (ChannelNo * RankSize <= 256) {
-		while ((RankSize >>= 1) > 0)
-			data += 0x10;
-
-		memsize = data >> 4;
-
-		/* [2004/03/25] Vicent, Fix DRAM Sizing Error */
-		xgifb_reg_set(pVBInfo->P3c4,
-			      0x14,
-			      (xgifb_reg_get(pVBInfo->P3c4, 0x14) & 0x0F) |
-			       (data & 0xF0));
-
-		/* data |= pVBInfo->ram_channel << 2; */
-		/* data |= (pVBInfo->ram_bus / 64) << 1; */
-		/* xgifb_reg_set(pVBInfo->P3c4, 0x14, data); */
-
-		/* should delay */
-		/* XGINew_SetDRAMModeRegister340(pVBInfo); */
-	}
-	return memsize;
-}
-
 static unsigned short XGINew_SetDRAMSize20Reg(int index,
 		const unsigned short DRAMTYPE_TABLE[][5],
 		struct vb_device_info *pVBInfo)
@@ -968,7 +924,7 @@ static int XGINew_DDRSizing340(struct xgi_hw_device_info *HwDeviceExtension,
 			XGINew_SetDRAMSizingType(i,
 						 XGINew_DDRDRAM_TYPE340,
 						 pVBInfo);
-			memsize = XGINew_SetDRAMSizeReg(i,
+			memsize = XGINew_SetDRAMSize20Reg(i,
 							XGINew_DDRDRAM_TYPE340,
 							pVBInfo);
 
-- 
1.7.3.4

