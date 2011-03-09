Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab1CIAyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:54:20 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37526 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab1CIAyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:54:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QHxcHs7yGB7AejON/zR4Tq8dZ3wSRmIUWdfgFphy7Cz1fb2Rm+XbMY57fY12G/KSg3
         DU+1MTK1EturThniKxavvBJbaHG9uRwLOdevN4Rz8fap7fFpECBjWLq6AjfbN7mXNvjk
         WyntTAX1r32KafLoXa32143+ilsQAu5p6sinY=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH next 1/5] staging: bcm: optimize kmalloc to kzalloc
Date: Wed,  9 Mar 2011 03:53:34 +0300
Message-Id: <1299632018-6774-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzalloc rather than kmalloc followed by memset with 0.
Found by coccinelle.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/bcm/Bcmchar.c |    4 +---
 drivers/staging/bcm/Misc.c    |    6 ++----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 3d9055a..867dbf1 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -19,12 +19,10 @@ static int bcm_char_open(struct inode *inode, struct file * filp)
 	PPER_TARANG_DATA    pTarang = NULL;
 
 	Adapter = GET_BCM_ADAPTER(gblpnetdev);
-	pTarang = (PPER_TARANG_DATA)kmalloc(sizeof(PER_TARANG_DATA),
-					    GFP_KERNEL);
+	pTarang = kzalloc(sizeof(PER_TARANG_DATA), GFP_KERNEL);
 	if (!pTarang)
 		return -ENOMEM;
 
-	memset(pTarang, 0, sizeof(PER_TARANG_DATA));
 	pTarang->Adapter = Adapter;
 	pTarang->RxCntrlMsgBitMask = 0xFFFFFFFF & ~(1 << 0xB);
 
diff --git a/drivers/staging/bcm/Misc.c b/drivers/staging/bcm/Misc.c
index f585aae..d624f35 100644
--- a/drivers/staging/bcm/Misc.c
+++ b/drivers/staging/bcm/Misc.c
@@ -498,13 +498,12 @@ VOID LinkMessage(PMINI_ADAPTER Adapter)
 	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, LINK_UP_MSG, DBG_LVL_ALL, "=====>");
 	if(Adapter->LinkStatus == SYNC_UP_REQUEST && Adapter->AutoSyncup)
 	{
-		pstLinkRequest=kmalloc(sizeof(LINK_REQUEST), GFP_ATOMIC);
+		pstLinkRequest = kzalloc(sizeof(LINK_REQUEST), GFP_ATOMIC);
 		if(!pstLinkRequest)
 		{
 			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, LINK_UP_MSG, DBG_LVL_ALL, "Can not allocate memory for Link request!");
 			return;
 		}
-		memset(pstLinkRequest,0,sizeof(LINK_REQUEST));
 		//sync up request...
 		Adapter->LinkStatus = WAIT_FOR_SYNC;// current link status
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, LINK_UP_MSG, DBG_LVL_ALL, "Requesting For SyncUp...");
@@ -516,13 +515,12 @@ VOID LinkMessage(PMINI_ADAPTER Adapter)
 	}
 	else if(Adapter->LinkStatus == PHY_SYNC_ACHIVED && Adapter->AutoLinkUp)
 	{
-		pstLinkRequest=kmalloc(sizeof(LINK_REQUEST), GFP_ATOMIC);
+		pstLinkRequest = kzalloc(sizeof(LINK_REQUEST), GFP_ATOMIC);
 		if(!pstLinkRequest)
 		{
 			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, LINK_UP_MSG, DBG_LVL_ALL, "Can not allocate memory for Link request!");
 			return;
 		}
-		memset(pstLinkRequest,0,sizeof(LINK_REQUEST));
 		//LINK_UP_REQUEST
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, LINK_UP_MSG, DBG_LVL_ALL, "Requesting For LinkUp...");
 		pstLinkRequest->szData[0]=LINK_UP_REQ_PAYLOAD;
-- 
1.7.4.1

