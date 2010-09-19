Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab0ISJ3E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 05:29:04 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:55893 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab0ISJ2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 05:28:48 -0400
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Lars Lindley <lindley@coyote.org>, Pavel Machek <pavel@ucw.cz>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: [PATCH 5/7] w35und: Inline mlme_s.h to core.h
Date: Sun, 19 Sep 2010 12:28:41 +0300
Message-Id: <1284888523-9625-5-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1284888523-9625-4-git-send-email-penberg@kernel.org>
References: <1284888523-9625-1-git-send-email-penberg@kernel.org>
 <1284888523-9625-2-git-send-email-penberg@kernel.org>
 <1284888523-9625-3-git-send-email-penberg@kernel.org>
 <1284888523-9625-4-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mlme_s.h header is included in one place. As the header is very small, just
inline it to core.h.

Cc: Lars Lindley <lindley@coyote.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Ruslan Pisarev <ruslan@rpisarev.org.ua>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/core.h   |   35 +++++++++++++++++++++++++++++-
 drivers/staging/winbond/mlme_s.h |   44 --------------------------------------
 2 files changed, 34 insertions(+), 45 deletions(-)
 delete mode 100644 drivers/staging/winbond/mlme_s.h

diff --git a/drivers/staging/winbond/core.h b/drivers/staging/winbond/core.h
index 2e9f02a..294d371 100644
--- a/drivers/staging/winbond/core.h
+++ b/drivers/staging/winbond/core.h
@@ -1,12 +1,45 @@
 #ifndef __WINBOND_CORE_H
 #define __WINBOND_CORE_H
 
+#include <linux/spinlock.h>
 #include <linux/wireless.h>
+#include <linux/types.h>
 
-#include "mlme_s.h"
 #include "wbhal_s.h"
 #include "mto.h"
 
+#include "mac_structures.h"
+#include "mds_s.h"
+
+#define MAX_NUM_TX_MMPDU		2
+#define MAX_MMPDU_SIZE			1512
+#define MAX_NUM_RX_MMPDU		6
+
+struct mlme_frame {
+	s8		*pMMPDU;
+	u16		len;
+	u8		DataType;
+	u8		IsInUsed;
+
+	spinlock_t	MLMESpinLock;
+
+	u8		TxMMPDU[MAX_NUM_TX_MMPDU][MAX_MMPDU_SIZE];
+	u8		TxMMPDUInUse[(MAX_NUM_TX_MMPDU + 3) & ~0x03];
+
+	u16		wNumTxMMPDU;
+	u16		wNumTxMMPDUDiscarded;
+
+	u8		RxMMPDU[MAX_NUM_RX_MMPDU][MAX_MMPDU_SIZE];
+	u8		SaveRxBufSlotInUse[(MAX_NUM_RX_MMPDU + 3) & ~0x03];
+
+	u16		wNumRxMMPDU;
+	u16		wNumRxMMPDUDiscarded;
+
+	u16		wNumRxMMPDUInMLME;	/* Number of the Rx MMPDU */
+	u16		reserved_1;		/*  in MLME. */
+						/*  excluding the discarded */
+};
+
 #define WBLINUX_PACKET_ARRAY_SIZE (ETHERNET_TX_DESCRIPTORS*4)
 
 #define WB_MAX_LINK_NAME_LEN 40
diff --git a/drivers/staging/winbond/mlme_s.h b/drivers/staging/winbond/mlme_s.h
deleted file mode 100644
index 0e7d2f6..0000000
--- a/drivers/staging/winbond/mlme_s.h
+++ /dev/null
@@ -1,44 +0,0 @@
-#ifndef __WINBOND_MLME_H
-#define __WINBOND_MLME_H
-
-#include <linux/types.h>
-#include <linux/spinlock.h>
-
-#include "mac_structures.h"
-#include "mds_s.h"
-
-/*
- * ==============================================
- * Global data structures
- * ==============================================
- */
-#define MAX_NUM_TX_MMPDU		2
-#define MAX_MMPDU_SIZE			1512
-#define MAX_NUM_RX_MMPDU		6
-
-struct mlme_frame {
-	s8		*pMMPDU;
-	u16		len;
-	u8		DataType;
-	u8		IsInUsed;
-
-	spinlock_t	MLMESpinLock;
-
-	u8		TxMMPDU[MAX_NUM_TX_MMPDU][MAX_MMPDU_SIZE];
-	u8		TxMMPDUInUse[(MAX_NUM_TX_MMPDU + 3) & ~0x03];
-
-	u16		wNumTxMMPDU;
-	u16		wNumTxMMPDUDiscarded;
-
-	u8		RxMMPDU[MAX_NUM_RX_MMPDU][MAX_MMPDU_SIZE];
-	u8		SaveRxBufSlotInUse[(MAX_NUM_RX_MMPDU + 3) & ~0x03];
-
-	u16		wNumRxMMPDU;
-	u16		wNumRxMMPDUDiscarded;
-
-	u16		wNumRxMMPDUInMLME;	/* Number of the Rx MMPDU */
-	u16		reserved_1;		/*  in MLME. */
-						/*  excluding the discarded */
-};
-
-#endif
-- 
1.6.3.3

