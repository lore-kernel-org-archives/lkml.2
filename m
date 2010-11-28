Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab0K1VB0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 16:01:26 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:39970 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab0K1VAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 16:00:13 -0500
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 10/13] w35und: Merge mlmetxrx.c to mds.c
Date: Sun, 28 Nov 2010 23:00:05 +0200
Message-Id: <1290978008-29095-10-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1290978008-29095-1-git-send-email-penberg@kernel.org>
References: <1290978008-29095-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch merges mlmetxrx.c to mds.c because it's small and the functions are
only used in mto.c.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/Makefile     |    1 -
 drivers/staging/winbond/mds.c        |   39 +++++++++++++++++++++-
 drivers/staging/winbond/mlmetxrx.c   |   60 ----------------------------------
 drivers/staging/winbond/mlmetxrx_f.h |   19 -----------
 drivers/staging/winbond/wbusb.c      |    1 -
 5 files changed, 38 insertions(+), 82 deletions(-)
 delete mode 100644 drivers/staging/winbond/mlmetxrx.c
 delete mode 100644 drivers/staging/winbond/mlmetxrx_f.h

diff --git a/drivers/staging/winbond/Makefile b/drivers/staging/winbond/Makefile
index 79fa227..081d48d 100644
--- a/drivers/staging/winbond/Makefile
+++ b/drivers/staging/winbond/Makefile
@@ -1,6 +1,5 @@
 w35und-y :=			\
 	mds.o			\
-	mlmetxrx.o		\
 	mto.o			\
 	phy_calibration.o	\
 	reg.o			\
diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index 0daabdc..00e9756 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -1,5 +1,4 @@
 #include "mds_f.h"
-#include "mlmetxrx_f.h"
 #include "mto.h"
 #include "wbhal.h"
 #include "wblinux_f.h"
@@ -397,6 +396,44 @@ static void Mds_HeaderCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *
 
 }
 
+static void MLME_GetNextPacket(struct wbsoft_priv *adapter, struct wb35_descriptor *desc)
+{
+	desc->InternalUsed = desc->buffer_start_index + desc->buffer_number;
+	desc->InternalUsed %= MAX_DESCRIPTOR_BUFFER_INDEX;
+	desc->buffer_address[desc->InternalUsed] = adapter->sMlmeFrame.pMMPDU;
+	desc->buffer_size[desc->InternalUsed] = adapter->sMlmeFrame.len;
+	desc->buffer_total_size += adapter->sMlmeFrame.len;
+	desc->buffer_number++;
+	desc->Type = adapter->sMlmeFrame.DataType;
+}
+
+static void MLMEfreeMMPDUBuffer(struct wbsoft_priv *adapter, s8 *pData)
+{
+	int i;
+
+	/* Reclaim the data buffer */
+	for (i = 0; i < MAX_NUM_TX_MMPDU; i++) {
+		if (pData == (s8 *)&(adapter->sMlmeFrame.TxMMPDU[i]))
+			break;
+	}
+	if (adapter->sMlmeFrame.TxMMPDUInUse[i])
+		adapter->sMlmeFrame.TxMMPDUInUse[i] = false;
+	else  {
+		/* Something wrong
+		 PD43 Add debug code here??? */
+	}
+}
+
+static void MLME_SendComplete(struct wbsoft_priv *adapter, u8 PacketID, unsigned char SendOK)
+{
+    /* Reclaim the data buffer */
+	adapter->sMlmeFrame.len = 0;
+	MLMEfreeMMPDUBuffer(adapter, adapter->sMlmeFrame.pMMPDU);
+
+	/* Return resource */
+	adapter->sMlmeFrame.IsInUsed = PACKET_FREE_TO_USE;
+}
+
 void
 Mds_Tx(struct wbsoft_priv *adapter)
 {
diff --git a/drivers/staging/winbond/mlmetxrx.c b/drivers/staging/winbond/mlmetxrx.c
deleted file mode 100644
index 87f339f..0000000
--- a/drivers/staging/winbond/mlmetxrx.c
+++ /dev/null
@@ -1,60 +0,0 @@
-/* ============================================================================
-  Module Name:
-    MLMETxRx.C
-
-  Description:
-    The interface between MDS (MAC Data Service) and MLME.
-
-  Revision History:
-  --------------------------------------------------------------------------
-		200209      UN20 Jennifer Xu
-		Initial Release
-		20021108    PD43 Austin Liu
-		20030117    PD43 Austin Liu
-		Deleted MLMEReturnPacket and MLMEProcThread()
-
-  Copyright (c) 1996-2002 Winbond Electronics Corp. All Rights Reserved.
-============================================================================ */
-#include "mds_f.h"
-
-void MLME_GetNextPacket(struct wbsoft_priv *adapter, struct wb35_descriptor *desc)
-{
-	desc->InternalUsed = desc->buffer_start_index + desc->buffer_number;
-	desc->InternalUsed %= MAX_DESCRIPTOR_BUFFER_INDEX;
-	desc->buffer_address[desc->InternalUsed] = adapter->sMlmeFrame.pMMPDU;
-	desc->buffer_size[desc->InternalUsed] = adapter->sMlmeFrame.len;
-	desc->buffer_total_size += adapter->sMlmeFrame.len;
-	desc->buffer_number++;
-	desc->Type = adapter->sMlmeFrame.DataType;
-}
-
-static void MLMEfreeMMPDUBuffer(struct wbsoft_priv *adapter, s8 *pData)
-{
-	int i;
-
-	/* Reclaim the data buffer */
-	for (i = 0; i < MAX_NUM_TX_MMPDU; i++) {
-		if (pData == (s8 *)&(adapter->sMlmeFrame.TxMMPDU[i]))
-			break;
-	}
-	if (adapter->sMlmeFrame.TxMMPDUInUse[i])
-		adapter->sMlmeFrame.TxMMPDUInUse[i] = false;
-	else  {
-		/* Something wrong
-		 PD43 Add debug code here??? */
-	}
-}
-
-void
-MLME_SendComplete(struct wbsoft_priv *adapter, u8 PacketID, unsigned char SendOK)
-{
-    /* Reclaim the data buffer */
-	adapter->sMlmeFrame.len = 0;
-	MLMEfreeMMPDUBuffer(adapter, adapter->sMlmeFrame.pMMPDU);
-
-	/* Return resource */
-	adapter->sMlmeFrame.IsInUsed = PACKET_FREE_TO_USE;
-}
-
-
-
diff --git a/drivers/staging/winbond/mlmetxrx_f.h b/drivers/staging/winbond/mlmetxrx_f.h
deleted file mode 100644
index 6db423b..0000000
--- a/drivers/staging/winbond/mlmetxrx_f.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/* ================================================================
-// MLMETxRx.H --
-//
-//   Functions defined in MLMETxRx.c.
-//
-// Copyright (c) 2002 Winbond Electrics Corp. All Rights Reserved.
-//================================================================ */
-#ifndef _MLMETXRX_H
-#define _MLMETXRX_H
-
-#include "core.h"
-
-void MLME_GetNextPacket(struct wbsoft_priv *adapter, struct wb35_descriptor *pDes);
-
-void
-MLME_SendComplete(struct wbsoft_priv *adapter, u8 PacketID,
-		  unsigned char SendOK);
-
-#endif
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 9fc078f..c5a3107 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -14,7 +14,6 @@
 
 #include "core.h"
 #include "mds_f.h"
-#include "mlmetxrx_f.h"
 #include "mto.h"
 #include "wbhal.h"
 #include "wb35reg_f.h"
-- 
1.7.0.4

