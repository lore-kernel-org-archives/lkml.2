Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab2FMWYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:24:20 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:43969 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754913Ab2FMWWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:22:05 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/7ClxZJlj7ErdezTFFqTBnzhykUVwt2EtiRhLAAp
	Gq3slgO9IU6Owm
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Peter Huewe <peterhuewe@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/14] staging/xgifb: Remove duplicated code from XGINew_DDRSizing340
Date: Thu, 14 Jun 2012 00:21:44 +0200
Message-Id: <1339626112-20671-6-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
References: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since XGINew_SetDRAMSize20Reg now handles both cases we can remove
the code duplication in XGINew_DDRSizing340.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_init.c |   64 +++++++++++++++-----------------------
 1 files changed, 25 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 726c335..512284c 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -893,52 +893,38 @@ static void XGINew_CheckChannel(struct xgi_hw_device_info *HwDeviceExtension,
 static int XGINew_DDRSizing340(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
-	int i;
-	unsigned short memsize, addr;
+	u8 i, size;
+	unsigned short memsize, start_addr;
+	const unsigned short (*dram_table)[5];
 
 	xgifb_reg_set(pVBInfo->P3c4, 0x15, 0x00); /* noninterleaving */
 	xgifb_reg_set(pVBInfo->P3c4, 0x1C, 0x00); /* nontiling */
 	XGINew_CheckChannel(HwDeviceExtension, pVBInfo);
 
 	if (HwDeviceExtension->jChipType >= XG20) {
-		for (i = 0; i < 12; i++) {
-			XGINew_SetDRAMSizingType(i,
-						 XGINew_DDRDRAM_TYPE20,
-						 pVBInfo);
-			memsize = XGINew_SetDRAMSize20Reg(i,
-							  XGINew_DDRDRAM_TYPE20,
-							  pVBInfo);
-			if (memsize == 0)
-				continue;
-
-			addr = memsize + (pVBInfo->ram_channel - 2) + 20;
-			if ((HwDeviceExtension->ulVideoMemorySize - 1) <
-			    (unsigned long) (1 << addr))
-				continue;
-
-			if (XGINew_ReadWriteRest(addr, 5, pVBInfo) == 1)
-				return 1;
-		}
+		dram_table = XGINew_DDRDRAM_TYPE20;
+		size = ARRAY_SIZE(XGINew_DDRDRAM_TYPE20);
+		start_addr = 5;
 	} else {
-		for (i = 0; i < 4; i++) {
-			XGINew_SetDRAMSizingType(i,
-						 XGINew_DDRDRAM_TYPE340,
-						 pVBInfo);
-			memsize = XGINew_SetDRAMSize20Reg(i,
-							XGINew_DDRDRAM_TYPE340,
-							pVBInfo);
-
-			if (memsize == 0)
-				continue;
-
-			addr = memsize + (pVBInfo->ram_channel - 2) + 20;
-			if ((HwDeviceExtension->ulVideoMemorySize - 1) <
-			    (unsigned long) (1 << addr))
-				continue;
-
-			if (XGINew_ReadWriteRest(addr, 9, pVBInfo) == 1)
-				return 1;
-		}
+		dram_table = XGINew_DDRDRAM_TYPE340;
+		size = ARRAY_SIZE(XGINew_DDRDRAM_TYPE340);
+		start_addr = 9;
+	}
+
+	for (i = 0; i < size; i++) {
+		XGINew_SetDRAMSizingType(i, dram_table, pVBInfo);
+		memsize = XGINew_SetDRAMSize20Reg(i, dram_table, pVBInfo);
+
+		if (memsize == 0)
+			continue;
+
+		memsize += (pVBInfo->ram_channel - 2) + 20;
+		if ((HwDeviceExtension->ulVideoMemorySize - 1) <
+			(unsigned long) (1 << memsize))
+			continue;
+
+		if (XGINew_ReadWriteRest(memsize, start_addr, pVBInfo) == 1)
+			return 1;
 	}
 	return 0;
 }
-- 
1.7.3.4

