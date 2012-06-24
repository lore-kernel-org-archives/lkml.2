Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab2FXX5O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 19:57:14 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12285 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab2FXX5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 19:57:08 -0400
Date: Mon, 25 Jun 2012 01:57:07 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/14] staging: vt6656: iwctl: remove unneeded scope block
 in iwctl_siwessid()
In-Reply-To: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1206250151290.30361@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce indentation by removing completely redundant scope block in the
iwctl_siwessid() function.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/iwctl.c | 71 ++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index eeaee59..3249a01 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -748,23 +748,41 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 		//so here need not associate??
 		if(pDevice->bWPASuppWextEnabled == TRUE)  {
 			/*******search if  in hidden ssid mode ****/
-			{
-				PKnownBSS pCurr = NULL;
-				BYTE abyTmpDesireSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
-				unsigned ii;
-				unsigned uSameBssidNum = 0;
-
-				memcpy(abyTmpDesireSSID,pMgmt->abyDesireSSID,sizeof(abyTmpDesireSSID));
-				pCurr = BSSpSearchBSSList(pDevice,
-							NULL,
-							abyTmpDesireSSID,
-							pDevice->eConfigPHYMode
-					);
-
-				if (pCurr == NULL){
-					PRINT_K("SIOCSIWESSID:hidden ssid site survey before associate.......\n");
+			PKnownBSS pCurr = NULL;
+			BYTE abyTmpDesireSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
+			unsigned ii;
+			unsigned uSameBssidNum = 0;
+
+			memcpy(abyTmpDesireSSID,pMgmt->abyDesireSSID,sizeof(abyTmpDesireSSID));
+			pCurr = BSSpSearchBSSList(pDevice, NULL,
+						abyTmpDesireSSID,
+						pDevice->eConfigPHYMode
+				);
+
+			if (pCurr == NULL){
+				PRINT_K("SIOCSIWESSID:hidden ssid site survey before associate.......\n");
+				vResetCommandTimer((void *) pDevice);
+				pMgmt->eScanType = WMAC_SCAN_ACTIVE;
+				bScheduleCommand((void *) pDevice,
+						WLAN_CMD_BSSID_SCAN,
+						pMgmt->abyDesireSSID);
+				bScheduleCommand((void *) pDevice,
+						WLAN_CMD_SSID,
+						pMgmt->abyDesireSSID);
+			}
+			else {  //mike:to find out if that desired SSID is a hidden-ssid AP ,
+				//         by means of judging if there are two same BSSID exist in list ?
+				for (ii = 0; ii < MAX_BSS_NUM; ii++) {
+					if (pMgmt->sBSSList[ii].bActive &&
+						!compare_ether_addr(pMgmt->sBSSList[ii].abyBSSID,
+								pCurr->abyBSSID)) {
+						uSameBssidNum++;
+					}
+				}
+				if(uSameBssidNum >= 2) {  //hit: desired AP is in hidden ssid mode!!!
+					PRINT_K("SIOCSIWESSID:hidden ssid directly associate.......\n");
 					vResetCommandTimer((void *) pDevice);
-					pMgmt->eScanType = WMAC_SCAN_ACTIVE;
+					pMgmt->eScanType = WMAC_SCAN_PASSIVE;          //this scan type,you'll submit scan result!
 					bScheduleCommand((void *) pDevice,
 							WLAN_CMD_BSSID_SCAN,
 							pMgmt->abyDesireSSID);
@@ -772,27 +790,6 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 							WLAN_CMD_SSID,
 							pMgmt->abyDesireSSID);
 				}
-				else {  //mike:to find out if that desired SSID is a hidden-ssid AP ,
-					//         by means of judging if there are two same BSSID exist in list ?
-					for (ii = 0; ii < MAX_BSS_NUM; ii++) {
-						if (pMgmt->sBSSList[ii].bActive &&
-							!compare_ether_addr(pMgmt->sBSSList[ii].abyBSSID,
-									pCurr->abyBSSID)) {
-							uSameBssidNum++;
-						}
-					}
-					if(uSameBssidNum >= 2) {  //hit: desired AP is in hidden ssid mode!!!
-						PRINT_K("SIOCSIWESSID:hidden ssid directly associate.......\n");
-						vResetCommandTimer((void *) pDevice);
-						pMgmt->eScanType = WMAC_SCAN_PASSIVE;          //this scan type,you'll submit scan result!
-						bScheduleCommand((void *) pDevice,
-								WLAN_CMD_BSSID_SCAN,
-								pMgmt->abyDesireSSID);
-						bScheduleCommand((void *) pDevice,
-								WLAN_CMD_SSID,
-								pMgmt->abyDesireSSID);
-					}
-				}
 			}
 			return 0;
 		}
-- 
1.7.11


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

