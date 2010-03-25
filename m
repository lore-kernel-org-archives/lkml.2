Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab0CYFTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 01:19:19 -0400
Received: from mail.perches.com ([173.55.12.10]:1092 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568Ab0CYFRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 01:17:31 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 06/13] drivers/staging/rt2870: Hoist assign from if
Date: Wed, 24 Mar 2010 22:17:00 -0700
Message-Id: <d314cf287493de6f5d036254f445f8ed463bcbec.1269493047.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1269493047.git.joe@perches.com>
References: <cover.1269493047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/rt2870/common/rtusb_bulk.c |   15 ++++++++++-----
 drivers/staging/rt2870/common/rtusb_io.c   |   10 +++++-----
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rt2870/common/rtusb_bulk.c b/drivers/staging/rt2870/common/rtusb_bulk.c
index 379780c..23e52ff 100644
--- a/drivers/staging/rt2870/common/rtusb_bulk.c
+++ b/drivers/staging/rt2870/common/rtusb_bulk.c
@@ -475,7 +475,8 @@ void RTUSBBulkOutDataPacket(struct rt_rtmp_adapter *pAd,
 			  (usb_complete_t) RTUSBBulkOutDataPacketComplete);
 
 	pUrb = pHTTXContext->pUrb;
-	if ((ret = RTUSB_SUBMIT_URB(pUrb)) != 0) {
+	ret = RTUSB_SUBMIT_URB(pUrb);
+	if (ret != 0) {
 		DBGPRINT(RT_DEBUG_ERROR,
 			 ("RTUSBBulkOutDataPacket: Submit Tx URB failed %d\n",
 			  ret));
@@ -573,7 +574,8 @@ void RTUSBBulkOutNullFrame(struct rt_rtmp_adapter *pAd)
 			(usb_complete_t) RTUSBBulkOutNullFrameComplete);
 
 	pUrb = pNullContext->pUrb;
-	if ((ret = RTUSB_SUBMIT_URB(pUrb)) != 0) {
+	ret = RTUSB_SUBMIT_URB(pUrb);
+	if (ret != 0) {
 		RTMP_IRQ_LOCK(&pAd->BulkOutLock[0], IrqFlags);
 		pAd->BulkOutPending[0] = FALSE;
 		pAd->watchDogTxPendingCnt[0] = 0;
@@ -667,7 +669,8 @@ void RTUSBBulkOutMLMEPacket(struct rt_rtmp_adapter *pAd, u8 Index)
 	pUrb->transfer_flags &= (~URB_NO_TRANSFER_DMA_MAP);
 
 	pUrb = pMLMEContext->pUrb;
-	if ((ret = RTUSB_SUBMIT_URB(pUrb)) != 0) {
+	ret = RTUSB_SUBMIT_URB(pUrb);
+	if (ret != 0) {
 		DBGPRINT(RT_DEBUG_ERROR,
 			 ("RTUSBBulkOutMLMEPacket: Submit MLME URB failed %d\n",
 			  ret));
@@ -742,7 +745,8 @@ void RTUSBBulkOutPsPoll(struct rt_rtmp_adapter *pAd)
 			(usb_complete_t) RTUSBBulkOutPsPollComplete);
 
 	pUrb = pPsPollContext->pUrb;
-	if ((ret = RTUSB_SUBMIT_URB(pUrb)) != 0) {
+	ret = RTUSB_SUBMIT_URB(pUrb);
+	if (ret != 0) {
 		RTMP_IRQ_LOCK(&pAd->BulkOutLock[0], IrqFlags);
 		pAd->BulkOutPending[0] = FALSE;
 		pAd->watchDogTxPendingCnt[0] = 0;
@@ -799,7 +803,8 @@ void DoBulkIn(struct rt_rtmp_adapter *pAd)
 	RTUSBInitRxDesc(pAd, pRxContext);
 
 	pUrb = pRxContext->pUrb;
-	if ((ret = RTUSB_SUBMIT_URB(pUrb)) != 0) {	/* fail */
+	ret = RTUSB_SUBMIT_URB(pUrb);
+	if (ret != 0) {	/* fail */
 
 		RTMP_IRQ_LOCK(&pAd->BulkInLock, IrqFlags);
 		pRxContext->InUse = FALSE;
diff --git a/drivers/staging/rt2870/common/rtusb_io.c b/drivers/staging/rt2870/common/rtusb_io.c
index cf0d2f5..f0b6972 100644
--- a/drivers/staging/rt2870/common/rtusb_io.c
+++ b/drivers/staging/rt2870/common/rtusb_io.c
@@ -1169,11 +1169,10 @@ void CMDHandler(struct rt_rtmp_adapter *pAd)
 								     (usb_complete_t)
 								     RTUSBBulkOutDataPacketComplete);
 
-								if ((ret =
-								     RTUSB_SUBMIT_URB
+								ret = RTUSB_SUBMIT_URB
 								     (pHTTXContext->
-								      pUrb)) !=
-								    0) {
+								      pUrb);
+								if (ret != 0) {
 									RTMP_INT_LOCK
 									    (&pAd->
 									     BulkOutLock
@@ -1545,7 +1544,8 @@ void CMDHandler(struct rt_rtmp_adapter *pAd)
 							RTUSBInitRxDesc(pAd,
 									pRxContext);
 							pUrb = pRxContext->pUrb;
-							if ((ret = RTUSB_SUBMIT_URB(pUrb)) != 0) {	/* fail */
+							ret = RTUSB_SUBMIT_URB(pUrb);
+							if (ret != 0) {	/* fail */
 
 								RTMP_IRQ_LOCK
 								    (&pAd->
-- 
1.7.0.14.g7e948

