Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751116Ab1GCEif (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 00:38:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65299 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab1GCEid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 00:38:33 -0400
From: Chris Forbes <chrisf@ijw.co.nz>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chris Forbes <chrisf@ijw.co.nz>
Subject: [PATCH] drivers: staging: bcm: sort: kill handrolled bubblesort
Date: Sun,  3 Jul 2011 16:38:20 +1200
Message-Id: <1309667900-2225-1-git-send-email-chrisf@ijw.co.nz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced the handrolled bubblesort with the kernel's sort() function.
Makes things considerably smaller & clearer.

Signed-off-by: Chris Forbes <chrisf@ijw.co.nz>
---
 drivers/staging/bcm/sort.c |   77 +++++++++++++++++++-------------------------
 1 files changed, 33 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/bcm/sort.c b/drivers/staging/bcm/sort.c
index fc5d07a..63c966a 100644
--- a/drivers/staging/bcm/sort.c
+++ b/drivers/staging/bcm/sort.c
@@ -1,4 +1,5 @@
 #include "headers.h"
+#include <linux/sort.h>
 
 /*
  * File Name: sort.c
@@ -10,54 +11,42 @@
  * Copyright (c) 2007 Beceem Communications Pvt. Ltd
  */
 
+static int compare_packet_info(void const *a, void const *b)
+{
+	PacketInfo const *pa = a;
+	PacketInfo const *pb = b;
+
+	if (!pa->bValid || !pb->bValid)
+		return 0;
+
+	return pa->u8TrafficPriority - pb->u8TrafficPriority;
+}
+
 VOID SortPackInfo(PMINI_ADAPTER Adapter)
 {
-	UINT nIndex1;
-	UINT nIndex2;
-
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL, "<=======");
-
-	for(nIndex1 = 0; nIndex1 < NO_OF_QUEUES -2 ; nIndex1++)
-	{
-		for(nIndex2 = nIndex1 + 1 ; nIndex2 < NO_OF_QUEUES -1  ; nIndex2++)
-		{
-			if(Adapter->PackInfo[nIndex1].bValid && Adapter->PackInfo[nIndex2].bValid)
-			{
-				if(Adapter->PackInfo[nIndex2].u8TrafficPriority <
-						Adapter->PackInfo[nIndex1].u8TrafficPriority)
-				{
-					PacketInfo stTemppackInfo = Adapter->PackInfo[nIndex2];
-					Adapter->PackInfo[nIndex2] = Adapter->PackInfo[nIndex1];
-					Adapter->PackInfo[nIndex1] = stTemppackInfo;
-
-				}
-			}
-		}
-	}
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, CONN_MSG,
+			DBG_LVL_ALL, "<=======");
+
+	sort(Adapter->PackInfo, NO_OF_QUEUES, sizeof(PacketInfo),
+		compare_packet_info, NULL);
+}
+
+static int compare_classifiers(void const *a, void const *b)
+{
+	S_CLASSIFIER_RULE const *pa = a;
+	S_CLASSIFIER_RULE const *pb = b;
+
+	if (!pa->bUsed || !pb->bUsed)
+		return 0;
+
+	return pa->u8ClassifierRulePriority - pb->u8ClassifierRulePriority;
 }
 
 VOID SortClassifiers(PMINI_ADAPTER Adapter)
 {
-	UINT nIndex1;
-	UINT nIndex2;
-
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL, "<=======");
-
-	for(nIndex1 = 0; nIndex1 < MAX_CLASSIFIERS -1 ; nIndex1++)
-	{
-		for(nIndex2 = nIndex1 + 1 ; nIndex2 < MAX_CLASSIFIERS  ; nIndex2++)
-		{
-			if(Adapter->astClassifierTable[nIndex1].bUsed && Adapter->astClassifierTable[nIndex2].bUsed)
-			{
-				if(Adapter->astClassifierTable[nIndex2].u8ClassifierRulePriority <
-					Adapter->astClassifierTable[nIndex1].u8ClassifierRulePriority)
-				{
-					S_CLASSIFIER_RULE stTempClassifierRule = Adapter->astClassifierTable[nIndex2];
-					Adapter->astClassifierTable[nIndex2] = Adapter->astClassifierTable[nIndex1];
-					Adapter->astClassifierTable[nIndex1] = stTempClassifierRule;
-
-				}
-			}
-		}
-	}
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, CONN_MSG,
+			DBG_LVL_ALL, "<=======");
+
+	sort(Adapter->astClassifierTable, MAX_CLASSIFIERS,
+		sizeof(S_CLASSIFIER_RULE), compare_classifiers, NULL);
 }
-- 
1.7.4.1

