Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab0K1VAc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 16:00:32 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:37403 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab0K1VAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 16:00:21 -0500
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 13/13] w35und: Kill struct wb_usb
Date: Sun, 28 Nov 2010 23:00:08 +0200
Message-Id: <1290978008-29095-13-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1290978008-29095-1-git-send-email-penberg@kernel.org>
References: <1290978008-29095-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch kills struct wb_usb which now only contains a pointer to  struct
usb_device.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/wb35reg.c |   12 ++++++------
 drivers/staging/winbond/wb35rx.c  |    4 ++--
 drivers/staging/winbond/wb35tx.c  |    6 +++---
 drivers/staging/winbond/wbhal.h   |    3 +--
 drivers/staging/winbond/wbusb.c   |    4 +---
 drivers/staging/winbond/wbusb_s.h |   16 ----------------
 6 files changed, 13 insertions(+), 32 deletions(-)
 delete mode 100644 drivers/staging/winbond/wbusb_s.h

diff --git a/drivers/staging/winbond/wb35reg.c b/drivers/staging/winbond/wb35reg.c
index a15de1e..42ae610 100644
--- a/drivers/staging/winbond/wb35reg.c
+++ b/drivers/staging/winbond/wb35reg.c
@@ -139,8 +139,8 @@ unsigned char Wb35Reg_WriteSync(struct hw_data *pHwData, u16 RegisterNo, u32 Reg
 
 	/* Sync IoCallDriver */
 	reg->EP0vm_state = VM_RUNNING;
-	ret = usb_control_msg(pHwData->WbUsb.udev,
-			       usb_sndctrlpipe(pHwData->WbUsb.udev, 0),
+	ret = usb_control_msg(pHwData->udev,
+			       usb_sndctrlpipe(pHwData->udev, 0),
 			       0x03, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
 			       0x0, RegisterNo, &RegisterValue, 4, HZ * 100);
 	reg->EP0vm_state = VM_STOP;
@@ -302,8 +302,8 @@ unsigned char Wb35Reg_ReadSync(struct hw_data *pHwData, u16 RegisterNo, u32 *pRe
 		msleep(10);
 
 	reg->EP0vm_state = VM_RUNNING;
-	ret = usb_control_msg(pHwData->WbUsb.udev,
-			       usb_rcvctrlpipe(pHwData->WbUsb.udev, 0),
+	ret = usb_control_msg(pHwData->udev,
+			       usb_rcvctrlpipe(pHwData->udev, 0),
 			       0x01, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
 			       0x0, RegisterNo, pltmp, 4, HZ * 100);
 
@@ -427,8 +427,8 @@ void Wb35Reg_EP0VM(struct hw_data *pHwData)
 	if (reg_queue->DIRECT == 1) /* output */
 		pBuffer = &reg_queue->VALUE;
 
-	usb_fill_control_urb(urb, pHwData->WbUsb.udev,
-			      REG_DIRECTION(pHwData->WbUsb.udev, reg_queue),
+	usb_fill_control_urb(urb, pHwData->udev,
+			      REG_DIRECTION(pHwData->udev, reg_queue),
 			      (u8 *)dr, pBuffer, cpu_to_le16(dr->wLength),
 			      Wb35Reg_EP0VM_complete, (void *)pHwData);
 
diff --git a/drivers/staging/winbond/wb35rx.c b/drivers/staging/winbond/wb35rx.c
index 190758e..f118eeb 100644
--- a/drivers/staging/winbond/wb35rx.c
+++ b/drivers/staging/winbond/wb35rx.c
@@ -260,8 +260,8 @@ static void Wb35Rx(struct ieee80211_hw *hw)
 	}
 	pRxBufferAddress = pWb35Rx->pDRx;
 
-	usb_fill_bulk_urb(urb, pHwData->WbUsb.udev,
-			  usb_rcvbulkpipe(pHwData->WbUsb.udev, 3),
+	usb_fill_bulk_urb(urb, pHwData->udev,
+			  usb_rcvbulkpipe(pHwData->udev, 3),
 			  pRxBufferAddress, MAX_USB_RX_BUFFER,
 			  Wb35Rx_Complete, hw);
 
diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
index 5e9e21a..44fc3fe 100644
--- a/drivers/staging/winbond/wb35tx.c
+++ b/drivers/staging/winbond/wb35tx.c
@@ -88,8 +88,8 @@ static void Wb35Tx(struct wbsoft_priv *adapter)
 	//
 	// Issuing URB
 	//
-	usb_fill_bulk_urb(pUrb, pHwData->WbUsb.udev,
-			  usb_sndbulkpipe(pHwData->WbUsb.udev, 4),
+	usb_fill_bulk_urb(pUrb, pHwData->udev,
+			  usb_sndbulkpipe(pHwData->udev, 4),
 			  pTxBufferAddress, pMds->TxBufferSize[ SendIndex ],
 			  Wb35Tx_complete, adapter);
 
@@ -265,7 +265,7 @@ static void Wb35Tx_EP2VM(struct wbsoft_priv *adapter)
 	//
 	// Issuing URB
 	//
-	usb_fill_int_urb( pUrb, pHwData->WbUsb.udev, usb_rcvintpipe(pHwData->WbUsb.udev,2),
+	usb_fill_int_urb( pUrb, pHwData->udev, usb_rcvintpipe(pHwData->udev,2),
 			  pltmp, MAX_INTERRUPT_LENGTH, Wb35Tx_EP2VM_complete, adapter, 32);
 
 	pWb35Tx->EP2vm_state = VM_RUNNING;
diff --git a/drivers/staging/winbond/wbhal.h b/drivers/staging/winbond/wbhal.h
index dcf3b21..39e84a0 100644
--- a/drivers/staging/winbond/wbhal.h
+++ b/drivers/staging/winbond/wbhal.h
@@ -356,7 +356,6 @@ struct txvga_for_50 {
  * ==============================================
  */
 
-#include "wbusb_s.h"
 #include "wb35reg_s.h"
 #include "wb35tx_s.h"
 #include "wb35rx_s.h"
@@ -437,7 +436,7 @@ struct hw_data {
 	 * Variable for each module
 	 * ==================================================
 	 */
-	struct wb_usb		WbUsb;	/* Need WbUsb.h */
+	struct usb_device	*udev;
 	struct wb35_reg		reg;	/* Need Wb35Reg.h */
 	struct wb35_tx		Wb35Tx; /* Need Wb35Tx.h */
 	struct wb35_rx		Wb35Rx; /* Need Wb35Rx.h */
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 3f5baa7..2163d60 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -747,7 +747,6 @@ static int wb35_probe(struct usb_interface *intf,
 	struct usb_host_interface *interface;
 	struct ieee80211_hw *dev;
 	struct wbsoft_priv *priv;
-	struct wb_usb *pWbUsb;
 	int nr, err;
 	u32 ltmp;
 
@@ -778,8 +777,7 @@ static int wb35_probe(struct usb_interface *intf,
 
 	priv = dev->priv;
 
-	pWbUsb = &priv->sHwData.WbUsb;
-	pWbUsb->udev = udev;
+	priv->sHwData.udev = udev;
 
 	interface = intf->cur_altsetting;
 	endpoint = &interface->endpoint[0].desc;
diff --git a/drivers/staging/winbond/wbusb_s.h b/drivers/staging/winbond/wbusb_s.h
deleted file mode 100644
index f626391..0000000
--- a/drivers/staging/winbond/wbusb_s.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/* =========================================================
- * Copyright (c) 1996-2004 Winbond Electronic Corporation
- *
- *  Module Name:
- *    wbusb_s.h
- * =========================================================
- */
-#ifndef __WINBOND_WBUSB_S_H
-#define __WINBOND_WBUSB_S_H
-
-#include <linux/types.h>
-
-struct wb_usb {
-	struct	usb_device *udev;
-};
-#endif
-- 
1.7.0.4

