Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab1CHUQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:16:16 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:37904 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab1CHUQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:16:13 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 01/15] staging: xgifb: delete HW cursor memory allocation
Date: Tue,  8 Mar 2011 22:16:06 +0200
Message-Id: <1299615380-22922-2-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HW cursor area is not used in any way.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main.h    |    8 --------
 drivers/staging/xgifb/XGI_main_26.c |   18 ------------------
 2 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index 37f77ee..88d15c8 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -66,7 +66,6 @@ MODULE_DEVICE_TABLE(pci, xgifb_pci_table);
 
 #define MAX_ROM_SCAN              0x10000
 
-#define HW_CURSOR_CAP             0x80
 #define TURBO_QUEUE_CAP           0x40
 #define AGP_CMD_QUEUE_CAP         0x20
 #define VM_CMD_QUEUE_CAP          0x10
@@ -80,10 +79,6 @@ MODULE_DEVICE_TABLE(pci, xgifb_pci_table);
 #define COMMAND_QUEUE_THRESHOLD   0x1F
 
 
-/* TW */
-#define HW_CURSOR_AREA_SIZE_315   0x4000  /* 16K */
-#define HW_CURSOR_AREA_SIZE_300   0x1000  /* 4K */
-
 #define OH_ALLOC_SIZE             4000
 #define SENTINEL                  0x7fffffff
 
@@ -350,7 +345,6 @@ static int enable_dstn = 0;
 static int XGIfb_ypan = -1;
 
 
-static int XGIfb_hwcursor_size = 0;
 static int XGIfb_CRT2_write_enable = 0;
 
 static int XGIfb_crt2type = -1; /* TW: CRT2 type (for overriding autodetection) */
@@ -613,8 +607,6 @@ typedef struct _XGI_HEAP {
 	unsigned long max_freesize;
 } XGI_HEAP;
 
-static unsigned long XGIfb_hwcursor_vbase;
-
 static unsigned long XGIfb_heap_start;
 static unsigned long XGIfb_heap_end;
 static unsigned long XGIfb_heap_size;
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index faf7106..3998dd4 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -2122,19 +2122,6 @@ static int XGIfb_heap_init(void)
 	break;
 }
 
-	/* TW: Now reserve memory for the HWCursor. It is always located at the very
-	top of the videoRAM, right below the TB memory area (if used). */
-	if (XGIfb_heap_size >= XGIfb_hwcursor_size) {
-		XGIfb_heap_end -= XGIfb_hwcursor_size;
-		XGIfb_heap_size -= XGIfb_hwcursor_size;
-		XGIfb_hwcursor_vbase = XGIfb_heap_end;
-
-		XGIfb_caps |= HW_CURSOR_CAP;
-
-		DPRINTK("XGIfb: Hardware Cursor start at 0x%lx, size is %dK\n",
-				XGIfb_heap_end, XGIfb_hwcursor_size/1024);
-	}
-
 	XGIfb_heap.poha_chain = NULL;
 	XGIfb_heap.poh_freelist = NULL;
 
@@ -2772,27 +2759,22 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 			xgi_video_info.chip = XG21;
 		else
 			xgi_video_info.chip = XG20;
-		XGIfb_hwcursor_size = HW_CURSOR_AREA_SIZE_315 * 2;
 		XGIfb_CRT2_write_enable = IND_XGI_CRT2_WRITE_ENABLE_315;
 		break;
 	case PCI_DEVICE_ID_XG_40:
 		xgi_video_info.chip = XG40;
-		XGIfb_hwcursor_size = HW_CURSOR_AREA_SIZE_315 * 2;
 		XGIfb_CRT2_write_enable = IND_XGI_CRT2_WRITE_ENABLE_315;
 		break;
 	case PCI_DEVICE_ID_XG_41:
 		xgi_video_info.chip = XG41;
-		XGIfb_hwcursor_size = HW_CURSOR_AREA_SIZE_315 * 2;
 		XGIfb_CRT2_write_enable = IND_XGI_CRT2_WRITE_ENABLE_315;
 		break;
 	case PCI_DEVICE_ID_XG_42:
 		xgi_video_info.chip = XG42;
-		XGIfb_hwcursor_size = HW_CURSOR_AREA_SIZE_315 * 2;
 		XGIfb_CRT2_write_enable = IND_XGI_CRT2_WRITE_ENABLE_315;
 		break;
 	case PCI_DEVICE_ID_XG_27:
 		xgi_video_info.chip = XG27;
-		XGIfb_hwcursor_size = HW_CURSOR_AREA_SIZE_315 * 2;
 		XGIfb_CRT2_write_enable = IND_XGI_CRT2_WRITE_ENABLE_315;
 		break;
 	default:
-- 
1.5.6.5

