Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab1CJCoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 21:44:08 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65349 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab1CJCoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 21:44:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Nfz+4AUe8W3s6MrHaPFqb8Fu1zZKCEQelIe1wGbMpz0rHM4Gv0JqxR8t6p8GrZ1zGe
         /zGX+0aPViqngt6yvY2BqvQPIlqfSR5yLyexOVJimNV5vqfxLKEgk/QbpxGa9e1Ijwrc
         RZjs4NEucvL0sLo0gVyHHgjVzgiA/acQa073A=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH next 2/6] staging: bcm: fix memory leaks
Date: Thu, 10 Mar 2011 05:43:04 +0300
Message-Id: <1299724988-25351-2-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299724988-25351-1-git-send-email-a.beregalov@gmail.com>
References: <1299724988-25351-1-git-send-email-a.beregalov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free resources before exit.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/bcm/Bcmchar.c |    1 +
 drivers/staging/bcm/CmHost.c  |   46 ++++++++++++++++++++++++++++------------
 2 files changed, 33 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 867dbf1..0013315 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -311,6 +311,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 			{
 				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "RDM Done On invalid Address : %x Access Denied.\n",
 					(int)sRdmBuffer.Register);
+				kfree(temp_buff);
 				return -EINVAL;
 			}
 
diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
index 017b471..6b9d8b1 100644
--- a/drivers/staging/bcm/CmHost.c
+++ b/drivers/staging/bcm/CmHost.c
@@ -1671,6 +1671,7 @@ ULONG StoreCmControlResponseMessage(PMINI_ADAPTER Adapter,PVOID pvBuffer,UINT *p
 	stLocalSFDeleteRequest *pstDeletionRequest;
 	UINT uiSearchRuleIndex;
 	ULONG ulSFID;
+	ULONG ret;
 
 	pstAddIndicationAlt = (stLocalSFAddIndicationAlt *)(pvBuffer);
 
@@ -1709,12 +1710,16 @@ ULONG StoreCmControlResponseMessage(PMINI_ADAPTER Adapter,PVOID pvBuffer,UINT *p
 	/* AUTHORIZED SET */
 	pstAddIndication->psfAuthorizedSet = (stServiceFlowParamSI *)
 			GetNextTargetBufferLocation(Adapter, pstAddIndicationAlt->u16TID);
-	if(!pstAddIndication->psfAuthorizedSet)
-		return 0;
+	if(!pstAddIndication->psfAuthorizedSet) {
+		ret = 0
+		goto exit;
+	}
 
 	if(StoreSFParam(Adapter,(PUCHAR)&pstAddIndicationAlt->sfAuthorizedSet,
-				(ULONG)pstAddIndication->psfAuthorizedSet)!= 1)
-		return 0;
+				(ULONG)pstAddIndication->psfAuthorizedSet)!= 1) {
+		ret = 0;
+		goto exit;
+	}
 
 	/* this can't possibly be right */
 	pstAddIndication->psfAuthorizedSet = (stServiceFlowParamSI *)ntohl((ULONG)pstAddIndication->psfAuthorizedSet);
@@ -1731,7 +1736,8 @@ ULONG StoreCmControlResponseMessage(PMINI_ADAPTER Adapter,PVOID pvBuffer,UINT *p
 		AddRequest.psfParameterSet =pstAddIndication->psfAuthorizedSet ;
 		(*puBufferLength) = sizeof(stLocalSFAddRequest);
 		memcpy(pvBuffer,&AddRequest,sizeof(stLocalSFAddRequest));
-		return 1;
+		ret = 1;
+		goto exit;
 	}
 
 	// Since it's not DSA_REQ, we can access all field in pstAddIndicationAlt
@@ -1748,10 +1754,14 @@ ULONG StoreCmControlResponseMessage(PMINI_ADAPTER Adapter,PVOID pvBuffer,UINT *p
 	/* ADMITTED SET */
 	pstAddIndication->psfAdmittedSet = (stServiceFlowParamSI *)
 		GetNextTargetBufferLocation(Adapter, pstAddIndicationAlt->u16TID);
-	if(!pstAddIndication->psfAdmittedSet)
-		return 0;
-	if(StoreSFParam(Adapter,(PUCHAR)&pstAddIndicationAlt->sfAdmittedSet,(ULONG)pstAddIndication->psfAdmittedSet) != 1)
-		return 0;
+	if(!pstAddIndication->psfAdmittedSet) {
+		ret = 0;
+		goto exit;
+	}
+	if(StoreSFParam(Adapter,(PUCHAR)&pstAddIndicationAlt->sfAdmittedSet,(ULONG)pstAddIndication->psfAdmittedSet) != 1) {
+		ret = 0;
+		goto exit;
+	}
 
 	pstAddIndication->psfAdmittedSet = (stServiceFlowParamSI *)ntohl((ULONG)pstAddIndication->psfAdmittedSet);
 
@@ -1759,17 +1769,25 @@ ULONG StoreCmControlResponseMessage(PMINI_ADAPTER Adapter,PVOID pvBuffer,UINT *p
 	/* ACTIVE SET */
 	pstAddIndication->psfActiveSet = (stServiceFlowParamSI *)
 		GetNextTargetBufferLocation(Adapter, pstAddIndicationAlt->u16TID);
-	if(!pstAddIndication->psfActiveSet)
-		return 0;
-	if(StoreSFParam(Adapter,(PUCHAR)&pstAddIndicationAlt->sfActiveSet,(ULONG)pstAddIndication->psfActiveSet) != 1)
-		return 0;
+	if(!pstAddIndication->psfActiveSet) {
+		ret = 0;
+		goto exit;
+	}
+	if(StoreSFParam(Adapter,(PUCHAR)&pstAddIndicationAlt->sfActiveSet,(ULONG)pstAddIndication->psfActiveSet) != 1) {
+		ret = 0;
+		goto exit;
+	}
 
 	pstAddIndication->psfActiveSet = (stServiceFlowParamSI *)ntohl((ULONG)pstAddIndication->psfActiveSet);
 
 	(*puBufferLength) = sizeof(stLocalSFAddIndication);
 	*(stLocalSFAddIndication *)pvBuffer = *pstAddIndication;
+
+	ret = 1;
+
+exit:
 	kfree(pstAddIndication);
-	return 1;
+	return ret;
 }
 
 
-- 
1.7.4.1

