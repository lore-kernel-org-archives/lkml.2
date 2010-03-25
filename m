Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab0CYFRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 01:17:34 -0400
Received: from mail.perches.com ([173.55.12.10]:1082 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab0CYFR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 01:17:28 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 03/13] drivers/staging/otus/80211core: Hoist assign from if
Date: Wed, 24 Mar 2010 22:16:57 -0700
Message-Id: <6d63c907501b81a752f81497932bd761190e6593.1269493047.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1269493047.git.joe@perches.com>
References: <cover.1269493047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/otus/80211core/cagg.c     |   34 ++++---
 drivers/staging/otus/80211core/ccmd.c     |    3 +-
 drivers/staging/otus/80211core/cfunc.c    |    3 +-
 drivers/staging/otus/80211core/cic.c      |    9 +-
 drivers/staging/otus/80211core/cinit.c    |    3 +-
 drivers/staging/otus/80211core/cmm.c      |  144 +++++++++++++++++++----------
 drivers/staging/otus/80211core/cmmap.c    |  103 ++++++++++++++-------
 drivers/staging/otus/80211core/cmmsta.c   |  123 ++++++++++++++++---------
 drivers/staging/otus/80211core/coid.c     |    3 +-
 drivers/staging/otus/80211core/cpsmgr.c   |    3 +-
 drivers/staging/otus/80211core/ctxrx.c    |   81 +++++++++++------
 drivers/staging/otus/80211core/queue.c    |    5 +-
 drivers/staging/otus/80211core/ratectrl.c |    3 +-
 13 files changed, 339 insertions(+), 178 deletions(-)

diff --git a/drivers/staging/otus/80211core/cagg.c b/drivers/staging/otus/80211core/cagg.c
index f9514c0..c3cef1a 100644
--- a/drivers/staging/otus/80211core/cagg.c
+++ b/drivers/staging/otus/80211core/cagg.c
@@ -2485,7 +2485,7 @@ void zfAggTxRetransmit(zdev_t* dev, struct bufInfo *buf_info, struct aggControl
         BAW->insert(dev, buf_info->buf, tid_tx->bar_ssn >> 4, aggControl->tid_baw, buf_info->baw_retransmit, &header_r);
     }*/
 
-    if ((err = zfHpSend(dev,
+    err = zfHpSend(dev,
                     buf_info->baw_header->header,
                     buf_info->baw_header->headerLen,
                     buf_info->baw_header->snap,
@@ -2496,7 +2496,8 @@ void zfAggTxRetransmit(zdev_t* dev, struct bufInfo *buf_info, struct aggControl
                     buf_info->baw_header->removeLen,
                     ZM_EXTERNAL_ALLOC_BUF,
                     (u8_t)tid_tx->ac,
-                    buf_info->baw_header->keyIdx)) != ZM_SUCCESS)
+                    buf_info->baw_header->keyIdx);
+    if (err != ZM_SUCCESS)
     {
         goto zlError;
     }
@@ -2797,9 +2798,10 @@ u16_t zfAggTxSendEth(zdev_t* dev, zbuf_t* buf, u16_t port, u16_t bufType, u8_t f
             BAW->insert(dev, buf, tid_tx->bar_ssn >> 4, aggControl->tid_baw, 0, &header_r);
         }*/
 
-        if ((err = zfHpSend(dev, header, headerLen, snap, snapLen,
+        err = zfHpSend(dev, header, headerLen, snap, snapLen,
                              mic, micLen, frag.buf[i], removeLen,
-                             frag.bufType[i], zcUpToAc[up&0x7], keyIdx)) != ZM_SUCCESS)
+                             frag.bufType[i], zcUpToAc[up&0x7], keyIdx);
+        if (err != ZM_SUCCESS)
         {
             goto zlError;
         }
@@ -2849,7 +2851,8 @@ u16_t   zfAggSendAddbaRequest(zdev_t* dev, u16_t *dst, u16_t ac, u16_t up)
     /*
      * TBD : Maximum size of management frame
      */
-    if ((buf = zfwBufAllocate(dev, 1024)) == NULL)
+    buf = zfwBufAllocate(dev, 1024);
+    if (buf == NULL)
     {
         zm_msg0_mm(ZM_LV_0, "Alloc mm buf Fail!");
         return ZM_SUCCESS;
@@ -2892,8 +2895,9 @@ u16_t   zfAggSendAddbaRequest(zdev_t* dev, u16_t *dst, u16_t ac, u16_t up)
     //zm_msg2_mm(ZM_LV_2, "buf->data=", buf->data);
 
     #if 0
-    if ((err = zfHpSend(dev, NULL, 0, NULL, 0, NULL, 0, buf, 0,
-            ZM_INTERNAL_ALLOC_BUF, 0, 0xff)) != ZM_SUCCESS)
+    err = zfHpSend(dev, NULL, 0, NULL, 0, NULL, 0, buf, 0,
+		   ZM_INTERNAL_ALLOC_BUF, 0, 0xff);
+    if (err != ZM_SUCCESS)
     {
         goto zlError;
     }
@@ -3290,7 +3294,8 @@ u16_t   zfAggSendAddbaResponse(zdev_t* dev, struct aggBaFrameParameter *bf)
     /*
      * TBD : Maximum size of management frame
      */
-    if ((buf = zfwBufAllocate(dev, 1024)) == NULL)
+    buf = zfwBufAllocate(dev, 1024);
+    if (buf == NULL)
     {
         zm_msg0_mm(ZM_LV_0, "Alloc mm buf Fail!");
         return ZM_SUCCESS;
@@ -3337,8 +3342,9 @@ u16_t   zfAggSendAddbaResponse(zdev_t* dev, struct aggBaFrameParameter *bf)
     //zm_msg2_mm(ZM_LV_2, "buf->data=", buf->data);
 
     #if 0
-    if ((err = zfHpSend(dev, NULL, 0, NULL, 0, NULL, 0, buf, 0,
-            ZM_INTERNAL_ALLOC_BUF, 0, 0xff)) != ZM_SUCCESS)
+    err = zfHpSend(dev, NULL, 0, NULL, 0, NULL, 0, buf, 0,
+		   ZM_INTERNAL_ALLOC_BUF, 0, 0xff);
+    if (err != ZM_SUCCESS)
     {
         goto zlError;
     }
@@ -3443,7 +3449,8 @@ u16_t   zfAggSendBar(zdev_t* dev, TID_TX tid_tx, struct aggBarControl *aggBarCon
     /*
      * TBD : Maximum size of management frame
      */
-    if ((buf = zfwBufAllocate(dev, 1024)) == NULL)
+    buf = zfwBufAllocate(dev, 1024);
+    if (buf == NULL)
     {
         zm_msg0_mm(ZM_LV_0, "Alloc mm buf Fail!");
         return ZM_SUCCESS;
@@ -3486,8 +3493,9 @@ u16_t   zfAggSendBar(zdev_t* dev, TID_TX tid_tx, struct aggBarControl *aggBarCon
     //zm_msg2_mm(ZM_LV_2, "buf->data=", buf->data);
 
     #if 0
-    if ((err = zfHpSend(dev, NULL, 0, NULL, 0, NULL, 0, buf, 0,
-            ZM_INTERNAL_ALLOC_BUF, 0, 0xff)) != ZM_SUCCESS)
+    err = zfHpSend(dev, NULL, 0, NULL, 0, NULL, 0, buf, 0,
+		   ZM_INTERNAL_ALLOC_BUF, 0, 0xff);
+    if (err != ZM_SUCCESS)
     {
         goto zlError;
     }
diff --git a/drivers/staging/otus/80211core/ccmd.c b/drivers/staging/otus/80211core/ccmd.c
index 3e3d9b5..ab300df 100644
--- a/drivers/staging/otus/80211core/ccmd.c
+++ b/drivers/staging/otus/80211core/ccmd.c
@@ -1436,7 +1436,8 @@ u16_t zfiWlanDeauth(zdev_t *dev, u16_t *macAddr, u16_t reason)
 		*/
 
 		/*
-		if ((id = zfApFindSta(dev, macAddr)) != 0xffff)
+		id = zfApFindSta(dev, macAddr);
+		if (id != 0xffff)
 		{
 			u32_t key[8];
 			u16_t nullAddr[3] = { 0x0, 0x0, 0x0 };
diff --git a/drivers/staging/otus/80211core/cfunc.c b/drivers/staging/otus/80211core/cfunc.c
index e0a9f38..3b9341b 100644
--- a/drivers/staging/otus/80211core/cfunc.c
+++ b/drivers/staging/otus/80211core/cfunc.c
@@ -1072,7 +1072,8 @@ u16_t zfFindCleanFrequency(zdev_t* dev, u32_t adhocMode)
 
     zmw_get_wlan_dev(dev);
 
-    if ((pBssInfo = wd->sta.bssList.head) == NULL)
+    pBssInfo = wd->sta.bssList.head;
+    if (pBssInfo == NULL)
     {
         if( adhocMode == ZM_ADHOCBAND_B || adhocMode == ZM_ADHOCBAND_G ||
             adhocMode == ZM_ADHOCBAND_BG || adhocMode == ZM_ADHOCBAND_ABG )
diff --git a/drivers/staging/otus/80211core/cic.c b/drivers/staging/otus/80211core/cic.c
index c84f079..53c09a0 100644
--- a/drivers/staging/otus/80211core/cic.c
+++ b/drivers/staging/otus/80211core/cic.c
@@ -329,7 +329,8 @@ void zfCoreEvent(zdev_t* dev, u16_t event, u8_t* rsp)
         if (wd->wlanMode == ZM_MODE_AP)
         {
             zmw_enter_critical_section(dev);
-            if ((i=zfApFindSta(dev, (u16_t*)rsp)) != 0xffff)
+            i = zfApFindSta(dev, (u16_t*)rsp);
+            if (i != 0xffff)
             {
                 zfRateCtrlTxFailEvent(dev, &wd->ap.staTable[i].rcCell, 0,(u32_t)zfPhyCtrlToRate(retryRate));
             }
@@ -357,7 +358,8 @@ void zfCoreEvent(zdev_t* dev, u16_t event, u8_t* rsp)
         if (wd->wlanMode == ZM_MODE_AP)
         {
             zmw_enter_critical_section(dev);
-            if ((i=zfApFindSta(dev, (u16_t*)rsp)) != 0xffff)
+            i = zfApFindSta(dev, (u16_t*)rsp);
+            if (i != 0xffff)
             {
                 zfRateCtrlTxFailEvent(dev, &wd->ap.staTable[i].rcCell, 0,(u32_t)zfPhyCtrlToRate(retryRate));
             }
@@ -387,7 +389,8 @@ void zfCoreEvent(zdev_t* dev, u16_t event, u8_t* rsp)
         if (wd->wlanMode == ZM_MODE_AP)
         {
             zmw_enter_critical_section(dev);
-            if ((i=zfApFindSta(dev, (u16_t*)rsp)) != 0xffff)
+            i = zfApFindSta(dev, (u16_t*)rsp);
+            if (i != 0xffff)
             {
                 zfRateCtrlTxSuccessEvent(dev, &wd->ap.staTable[i].rcCell, zfPhyCtrlToRate(retryRate));
             }
diff --git a/drivers/staging/otus/80211core/cinit.c b/drivers/staging/otus/80211core/cinit.c
index 5f853ce..1182331 100644
--- a/drivers/staging/otus/80211core/cinit.c
+++ b/drivers/staging/otus/80211core/cinit.c
@@ -622,7 +622,8 @@ u16_t zfTxGenWlanHeader(zdev_t* dev, zbuf_t* buf, u16_t* header, u16_t seq,
             phyCtrl = 0xc0001;   //PHY control L
 
             /* WDS port checking */
-            if ((wdsPort = (port - 0x20)) >= ZM_MAX_WDS_SUPPORT)
+            wdsPort = port - 0x20;
+            if (wdsPort >= ZM_MAX_WDS_SUPPORT)
             {
                 wdsPort = 0;
             }
diff --git a/drivers/staging/otus/80211core/cmm.c b/drivers/staging/otus/80211core/cmm.c
index 484e753..007ef3b 100644
--- a/drivers/staging/otus/80211core/cmm.c
+++ b/drivers/staging/otus/80211core/cmm.c
@@ -83,7 +83,8 @@ u16_t zfFindElement(zdev_t* dev, zbuf_t* buf, u8_t eid)
 
     /* Get offset of first element */
     subType = (zmw_rx_buf_readb(dev, buf, 0) >> 4);
-    if ((offset = zgElementOffsetTable[subType]) == 0xff)
+    offset = zgElementOffsetTable[subType];
+    if (offset == 0xff)
     {
         zm_assert(0);
     }
@@ -107,10 +108,12 @@ u16_t zfFindElement(zdev_t* dev, zbuf_t* buf, u8_t eid)
     while ((offset+2)<bufLen)                   // including element ID and length (2bytes)
     {
         /* Search target element */
-        if ((id = zmw_rx_buf_readb(dev, buf, offset)) == eid)
+        id = zmw_rx_buf_readb(dev, buf, offset);
+        if (id == eid)
         {
             /* Bingo */
-            if ((elen = zmw_rx_buf_readb(dev, buf, offset+1))>(bufLen - offset))
+            elen = zmw_rx_buf_readb(dev, buf, offset+1);
+            if (elen > bufLen - offset)
             {
                 /* Element length error */
                 return 0xffff;
@@ -151,7 +154,8 @@ u16_t zfFindElement(zdev_t* dev, zbuf_t* buf, u8_t eid)
         #if 1
         elen = zmw_rx_buf_readb(dev, buf, offset+1);
         #else
-        if ((elen = zmw_rx_buf_readb(dev, buf, offset+1)) == 0)
+        elen = zmw_rx_buf_readb(dev, buf, offset+1);
+        if (elen == 0)
         {
             return 0xffff;
         }
@@ -194,7 +198,8 @@ u16_t zfFindWifiElement(zdev_t* dev, zbuf_t* buf, u8_t type, u8_t subtype)
     /* Get offset of first element */
     subType = (zmw_rx_buf_readb(dev, buf, 0) >> 4);
 
-    if ((offset = zgElementOffsetTable[subType]) == 0xff)
+    offset = zgElementOffsetTable[subType];
+    if (offset == 0xff)
     {
         zm_assert(0);
     }
@@ -207,10 +212,12 @@ u16_t zfFindWifiElement(zdev_t* dev, zbuf_t* buf, u8_t type, u8_t subtype)
     while ((offset+2)<bufLen)                   // including element ID and length (2bytes)
     {
         /* Search target element */
-        if ((id = zmw_rx_buf_readb(dev, buf, offset)) == ZM_WLAN_EID_WIFI_IE)
+        id = zmw_rx_buf_readb(dev, buf, offset);
+        if (id == ZM_WLAN_EID_WIFI_IE)
         {
             /* Bingo */
-            if ((elen = zmw_rx_buf_readb(dev, buf, offset+1))>(bufLen - offset))
+            elen = zmw_rx_buf_readb(dev, buf, offset+1);
+            if (elen > bufLen - offset)
             {
                 /* Element length error */
                 return 0xffff;
@@ -229,7 +236,8 @@ u16_t zfFindWifiElement(zdev_t* dev, zbuf_t* buf, u8_t type, u8_t subtype)
             {
                 if ( subtype != 0xff )
                 {
-                    if ( (tmp = zmw_rx_buf_readb(dev, buf, offset+6)) == subtype  )
+                    tmp = zmw_rx_buf_readb(dev, buf, offset+6);
+                    if (tmp == subtype)
                     {
                         return offset;
                     }
@@ -241,7 +249,8 @@ u16_t zfFindWifiElement(zdev_t* dev, zbuf_t* buf, u8_t type, u8_t subtype)
             }
         }
         /* Advance to next element */
-        if ((elen = zmw_rx_buf_readb(dev, buf, offset+1)) == 0)
+        elen = zmw_rx_buf_readb(dev, buf, offset+1);
+        if (elen == 0)
         {
             return 0xffff;
         }
@@ -348,7 +357,8 @@ u16_t zfFindSuperGElement(zdev_t* dev, zbuf_t* buf, u8_t type)
 
     /* Get offset of first element */
     subType = (zmw_rx_buf_readb(dev, buf, 0) >> 4);
-    if ((offset = zgElementOffsetTable[subType]) == 0xff)
+    offset = zgElementOffsetTable[subType];
+    if (offset == 0xff)
     {
         zm_assert(0);
     }
@@ -361,10 +371,12 @@ u16_t zfFindSuperGElement(zdev_t* dev, zbuf_t* buf, u8_t type)
     while ((offset+2)<bufLen)                   // including element ID and length (2bytes)
     {
         /* Search target element */
-        if ((id = zmw_rx_buf_readb(dev, buf, offset)) == ZM_WLAN_EID_VENDOR_PRIVATE)
+        id = zmw_rx_buf_readb(dev, buf, offset);
+        if (id == ZM_WLAN_EID_VENDOR_PRIVATE)
         {
             /* Bingo */
-            if ((elen = zmw_rx_buf_readb(dev, buf, offset+1))>(bufLen - offset))
+            elen = zmw_rx_buf_readb(dev, buf, offset+1);
+            if (elen > bufLen - offset)
             {
                 /* Element length error */
                 return 0xffff;
@@ -389,7 +401,8 @@ u16_t zfFindSuperGElement(zdev_t* dev, zbuf_t* buf, u8_t type)
         #if 1
         elen = zmw_rx_buf_readb(dev, buf, offset+1);
         #else
-        if ((elen = zmw_rx_buf_readb(dev, buf, offset+1)) == 0)
+        elen = zmw_rx_buf_readb(dev, buf, offset+1);
+        if (elen == 0)
         {
             return 0xffff;
         }
@@ -411,7 +424,8 @@ u16_t zfFindXRElement(zdev_t* dev, zbuf_t* buf, u8_t type)
 
     /* Get offset of first element */
     subType = (zmw_rx_buf_readb(dev, buf, 0) >> 4);
-    if ((offset = zgElementOffsetTable[subType]) == 0xff)
+    offset = zgElementOffsetTable[subType];
+    if (offset == 0xff)
     {
         zm_assert(0);
     }
@@ -424,10 +438,12 @@ u16_t zfFindXRElement(zdev_t* dev, zbuf_t* buf, u8_t type)
     while ((offset+2)<bufLen)                   // including element ID and length (2bytes)
     {
         /* Search target element */
-        if ((id = zmw_rx_buf_readb(dev, buf, offset)) == ZM_WLAN_EID_VENDOR_PRIVATE)
+        id = zmw_rx_buf_readb(dev, buf, offset);
+        if (id == ZM_WLAN_EID_VENDOR_PRIVATE)
         {
             /* Bingo */
-            if ((elen = zmw_rx_buf_readb(dev, buf, offset+1))>(bufLen - offset))
+            elen = zmw_rx_buf_readb(dev, buf, offset+1);
+            if (elen > bufLen - offset)
             {
                 /* Element length error */
                 return 0xffff;
@@ -447,7 +463,8 @@ u16_t zfFindXRElement(zdev_t* dev, zbuf_t* buf, u8_t type)
         #if 1
         elen = zmw_rx_buf_readb(dev, buf, offset+1);
         #else
-        if ((elen = zmw_rx_buf_readb(dev, buf, offset+1)) == 0)
+        elen = zmw_rx_buf_readb(dev, buf, offset+1);
+        if (elen == 0)
         {
             return 0xffff;
         }
@@ -868,7 +885,8 @@ void zfSendMmFrame(zdev_t* dev, u8_t frameType, u16_t* dst,
 
     zm_msg2_mm(ZM_LV_2, "Send mm frame, type=", frameType);
     /* TBD : Maximum size of management frame */
-    if ((buf = zfwBufAllocate(dev, 1024)) == NULL)
+    buf = zfwBufAllocate(dev, 1024);
+    if (buf == NULL)
     {
         zm_msg0_mm(ZM_LV_0, "Alloc mm buf Fail!");
         return;
@@ -1257,7 +1275,8 @@ void zfSendMmFrame(zdev_t* dev, u8_t frameType, u16_t* dst,
             {
               vap = (u16_t) p3;
 
-              if ((aid = zfApFindSta(dev, dst)) != 0xffff)
+              aid = zfApFindSta(dev, dst);
+              if (aid != 0xffff)
               {
                   zmw_enter_critical_section(dev);
                   /* Clear STA table */
@@ -1303,8 +1322,9 @@ void zfSendMmFrame(zdev_t* dev, u8_t frameType, u16_t* dst,
     //zm_msg2_mm(ZM_LV_2, "buf->data=", buf->data);
 
     #if 0
-    if ((err = zfHpSend(dev, NULL, 0, NULL, 0, NULL, 0, buf, 0,
-            ZM_INTERNAL_ALLOC_BUF, 0, 0xff)) != ZM_SUCCESS)
+    err = zfHpSend(dev, NULL, 0, NULL, 0, NULL, 0, buf, 0,
+		   ZM_INTERNAL_ALLOC_BUF, 0, 0xff);
+    if (err != ZM_SUCCESS)
     {
         goto zlError;
     }
@@ -1366,7 +1386,8 @@ void zfProcessManagement(zdev_t* dev, zbuf_t* buf, struct zsAdditionInfo* AddInf
         if ((ra[0] & 0x1) != 1)
         {
             /* AP : Find virtual AP */
-            if ((index = zfApFindSta(dev, ta)) != 0xffff)
+            index = zfApFindSta(dev, ta);
+            if (index != 0xffff)
             {
                 vap = wd->ap.staTable[index].vap;
             }
@@ -1534,7 +1555,8 @@ void zfProcessProbeReq(zdev_t* dev, zbuf_t* buf, u16_t* src)
     }
 
     /* check SSID */
-    if ((offset = zfFindElement(dev, buf, ZM_WLAN_EID_SSID)) == 0xffff)
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_SSID);
+    if (offset == 0xffff)
     {
         zm_msg0_mm(ZM_LV_3, "probe req SSID not found");
         return;
@@ -1561,8 +1583,8 @@ void zfProcessProbeReq(zdev_t* dev, zbuf_t* buf, u16_t* src)
             {
                 for (j=0; j<len; j++)
                 {
-                    if ((ch = zmw_rx_buf_readb(dev, buf, offset+2+j))
-                            != wd->ap.ssid[i][j])
+                    ch = zmw_rx_buf_readb(dev, buf, offset+2+j);
+                    if (ch != wd->ap.ssid[i][j])
                     {
                         break;
                     }
@@ -1814,7 +1836,8 @@ u16_t zfFindATHExtCap(zdev_t* dev, zbuf_t* buf, u8_t type, u8_t subtype)
     /* Get offset of first element */
     subType = (zmw_rx_buf_readb(dev, buf, 0) >> 4);
 
-    if ((offset = zgElementOffsetTable[subType]) == 0xff)
+    offset = zgElementOffsetTable[subType];
+    if (offset == 0xff)
     {
         zm_assert(0);
     }
@@ -1828,10 +1851,12 @@ u16_t zfFindATHExtCap(zdev_t* dev, zbuf_t* buf, u8_t type, u8_t subtype)
     while ((offset+2)<bufLen)                   // including element ID and length (2bytes)
     {
         /* Search target element */
-        if ((id = zmw_rx_buf_readb(dev, buf, offset)) == ZM_WLAN_EID_WIFI_IE)
+        id = zmw_rx_buf_readb(dev, buf, offset);
+        if (id == ZM_WLAN_EID_WIFI_IE)
         {
             /* Bingo */
-            if ((elen = zmw_rx_buf_readb(dev, buf, offset+1))>(bufLen - offset))
+            elen = zmw_rx_buf_readb(dev, buf, offset+1);
+            if (elen > bufLen - offset)
             {
                 /* Element length error */
                 return 0xffff;
@@ -1850,7 +1875,8 @@ u16_t zfFindATHExtCap(zdev_t* dev, zbuf_t* buf, u8_t type, u8_t subtype)
             {
                 if ( subtype != 0xff )
                 {
-                    if ( (tmp = zmw_rx_buf_readb(dev, buf, offset+6)) == subtype  )
+                    tmp = zmw_rx_buf_readb(dev, buf, offset+6);
+                    if (tmp == subtype  )
                     {
                         return offset;
                     }
@@ -1863,7 +1889,8 @@ u16_t zfFindATHExtCap(zdev_t* dev, zbuf_t* buf, u8_t type, u8_t subtype)
         }
 
         /* Advance to next element */
-        if ((elen = zmw_rx_buf_readb(dev, buf, offset+1)) == 0)
+        elen = zmw_rx_buf_readb(dev, buf, offset+1);
+        if (elen == 0)
         {
             return 0xffff;
         }
@@ -1884,7 +1911,8 @@ u16_t zfFindBrdcmMrvlRlnkExtCap(zdev_t* dev, zbuf_t* buf)
     /* Get offset of first element */
     subType = (zmw_rx_buf_readb(dev, buf, 0) >> 4);
 
-    if ((offset = zgElementOffsetTable[subType]) == 0xff)
+    offset = zgElementOffsetTable[subType];
+    if (offset == 0xff)
     {
         zm_assert(0);
     }
@@ -1898,10 +1926,12 @@ u16_t zfFindBrdcmMrvlRlnkExtCap(zdev_t* dev, zbuf_t* buf)
     while ((offset+2)<bufLen)                   // including element ID and length (2bytes)
     {
         /* Search target element */
-        if ((id = zmw_rx_buf_readb(dev, buf, offset)) == ZM_WLAN_EID_WIFI_IE)
+        id = zmw_rx_buf_readb(dev, buf, offset);
+        if (id == ZM_WLAN_EID_WIFI_IE)
         {
             /* Bingo */
-            if ((elen = zmw_rx_buf_readb(dev, buf, offset+1))>(bufLen - offset))
+            elen = zmw_rx_buf_readb(dev, buf, offset+1);
+            if (elen > bufLen - offset)
             {
                 /* Element length error */
                 return 0xffff;
@@ -1930,7 +1960,8 @@ u16_t zfFindBrdcmMrvlRlnkExtCap(zdev_t* dev, zbuf_t* buf)
         else if ((id = zmw_rx_buf_readb(dev, buf, offset)) == 0x7F)
         {
             /* Bingo */
-            if ((elen = zmw_rx_buf_readb(dev, buf, offset+1))>(bufLen - offset))
+            elen = zmw_rx_buf_readb(dev, buf, offset+1);
+            if (elen > bufLen - offset)
             {
                 /* Element length error */
                 return 0xffff;
@@ -1941,7 +1972,8 @@ u16_t zfFindBrdcmMrvlRlnkExtCap(zdev_t* dev, zbuf_t* buf)
                 return 0xffff;
             }
 
-            if ((tmp = zmw_rx_buf_readb(dev, buf, offset+2)) == 0x01)
+            tmp = zmw_rx_buf_readb(dev, buf, offset+2);
+            if (tmp == 0x01)
 
             {
                 return offset;
@@ -1949,7 +1981,8 @@ u16_t zfFindBrdcmMrvlRlnkExtCap(zdev_t* dev, zbuf_t* buf)
         }
 
         /* Advance to next element */
-        if ((elen = zmw_rx_buf_readb(dev, buf, offset+1)) == 0)
+        elen = zmw_rx_buf_readb(dev, buf, offset+1);
+        if (elen == 0)
         {
             return 0xffff;
         }
@@ -1970,7 +2003,8 @@ u16_t zfFindMarvelExtCap(zdev_t* dev, zbuf_t* buf)
     /* Get offset of first element */
     subType = (zmw_rx_buf_readb(dev, buf, 0) >> 4);
 
-    if ((offset = zgElementOffsetTable[subType]) == 0xff)
+    offset = zgElementOffsetTable[subType];
+    if (offset == 0xff)
     {
         zm_assert(0);
     }
@@ -1984,10 +2018,12 @@ u16_t zfFindMarvelExtCap(zdev_t* dev, zbuf_t* buf)
     while ((offset+2)<bufLen)                   // including element ID and length (2bytes)
     {
         /* Search target element */
-        if ((id = zmw_rx_buf_readb(dev, buf, offset)) == ZM_WLAN_EID_WIFI_IE)
+        id = zmw_rx_buf_readb(dev, buf, offset);
+        if (id == ZM_WLAN_EID_WIFI_IE)
         {
             /* Bingo */
-            if ((elen = zmw_rx_buf_readb(dev, buf, offset+1))>(bufLen - offset))
+            elen = zmw_rx_buf_readb(dev, buf, offset+1);
+            if (elen>(bufLen - offset))
             {
                 /* Element length error */
                 return 0xffff;
@@ -2008,7 +2044,8 @@ u16_t zfFindMarvelExtCap(zdev_t* dev, zbuf_t* buf)
         }
 
         /* Advance to next element */
-        if ((elen = zmw_rx_buf_readb(dev, buf, offset+1)) == 0)
+        elen = zmw_rx_buf_readb(dev, buf, offset+1);
+        if (elen == 0)
         {
             return 0xffff;
         }
@@ -2029,7 +2066,8 @@ u16_t zfFindBroadcomExtCap(zdev_t* dev, zbuf_t* buf)
     /* Get offset of first element */
     subType = (zmw_rx_buf_readb(dev, buf, 0) >> 4);
 
-    if ((offset = zgElementOffsetTable[subType]) == 0xff)
+    offset = zgElementOffsetTable[subType];
+    if (offset == 0xff)
     {
         zm_assert(0);
     }
@@ -2043,10 +2081,12 @@ u16_t zfFindBroadcomExtCap(zdev_t* dev, zbuf_t* buf)
     while((offset+2) < bufLen)                   // including element ID and length (2bytes)
     {
         /* Search target element */
-        if ((id = zmw_rx_buf_readb(dev, buf, offset)) == ZM_WLAN_EID_WIFI_IE)
+        id = zmw_rx_buf_readb(dev, buf, offset);
+        if (id == ZM_WLAN_EID_WIFI_IE)
         {
             /* Bingo */
-            if ((elen = zmw_rx_buf_readb(dev, buf, offset+1)) > (bufLen - offset))
+            elen = zmw_rx_buf_readb(dev, buf, offset+1);
+            if (elen > (bufLen - offset))
             {
                 /* Element length error */
                 return 0xffff;
@@ -2066,7 +2106,8 @@ u16_t zfFindBroadcomExtCap(zdev_t* dev, zbuf_t* buf)
         }
 
         /* Advance to next element */
-        if ((elen = zmw_rx_buf_readb(dev, buf, offset+1)) == 0)
+        elen = zmw_rx_buf_readb(dev, buf, offset+1);
+        if (elen == 0)
         {
             return 0xffff;
         }
@@ -2089,7 +2130,8 @@ u16_t zfFindRlnkExtCap(zdev_t* dev, zbuf_t* buf)
     /* Get offset of first element */
     subType = (zmw_rx_buf_readb(dev, buf, 0) >> 4);
 
-    if ((offset = zgElementOffsetTable[subType]) == 0xff)
+    offset = zgElementOffsetTable[subType];
+    if (offset == 0xff)
     {
         zm_assert(0);
     }
@@ -2103,10 +2145,12 @@ u16_t zfFindRlnkExtCap(zdev_t* dev, zbuf_t* buf)
     while((offset+2) < bufLen)                   // including element ID and length (2bytes)
     {
         /* Search target element */
-        if ((id = zmw_rx_buf_readb(dev, buf, offset)) == 0x7F)
+        id = zmw_rx_buf_readb(dev, buf, offset);
+        if (id == 0x7F)
         {
             /* Bingo */
-            if ((elen = zmw_rx_buf_readb(dev, buf, offset+1)) > (bufLen - offset))
+            elen = zmw_rx_buf_readb(dev, buf, offset+1);
+            if (elen > bufLen - offset)
             {
                 /* Element length error */
                 return 0xffff;
@@ -2117,7 +2161,8 @@ u16_t zfFindRlnkExtCap(zdev_t* dev, zbuf_t* buf)
                 return 0xffff;
             }
 
-            if ((tmp = zmw_rx_buf_readb(dev, buf, offset+2)) == 0x01)
+            tmp = zmw_rx_buf_readb(dev, buf, offset+2);
+            if (tmp == 0x01)
 
             {
                 return offset;
@@ -2125,7 +2170,8 @@ u16_t zfFindRlnkExtCap(zdev_t* dev, zbuf_t* buf)
         }
 
         /* Advance to next element */
-        if ((elen = zmw_rx_buf_readb(dev, buf, offset+1)) == 0)
+        elen = zmw_rx_buf_readb(dev, buf, offset+1);
+        if (elen == 0)
         {
             return 0xffff;
         }
diff --git a/drivers/staging/otus/80211core/cmmap.c b/drivers/staging/otus/80211core/cmmap.c
index 7f09fde..8ec3830 100644
--- a/drivers/staging/otus/80211core/cmmap.c
+++ b/drivers/staging/otus/80211core/cmmap.c
@@ -141,7 +141,8 @@ u16_t zfApGetSTAInfo(zdev_t* dev, u16_t* addr, u16_t* state, u8_t* vap)
 
     zmw_enter_critical_section(dev);
 
-    if ((id = zfApFindSta(dev, addr)) != 0xffff)
+    id = zfApFindSta(dev, addr);
+    if (id != 0xffff)
     {
         *vap = wd->ap.staTable[id].vap;
         *state = wd->ap.staTable[id++].state;
@@ -163,7 +164,8 @@ void zfApGetStaQosType(zdev_t* dev, u16_t* addr, u8_t* qosType)
 
     zmw_enter_critical_section(dev);
 
-    if ((id = zfApFindSta(dev, addr)) != 0xffff)
+    id = zfApFindSta(dev, addr);
+    if (id != 0xffff)
     {
         *qosType = wd->ap.staTable[id].qosType;
     }
@@ -189,7 +191,8 @@ void zfApGetStaTxRateAndQosType(zdev_t* dev, u16_t* addr, u32_t* phyCtrl,
 
     zmw_enter_critical_section(dev);
 
-    if ((id = zfApFindSta(dev, addr)) != 0xffff)
+    id = zfApFindSta(dev, addr);
+    if (id != 0xffff)
     {
         rate = (u8_t)zfRateCtrlGetTxRate(dev, &wd->ap.staTable[id].rcCell, rcProbingFlag);
 #ifdef ZM_AP_DEBUG
@@ -234,7 +237,8 @@ void zfApGetStaEncryType(zdev_t* dev, u16_t* addr, u8_t* encryType)
 
     zmw_enter_critical_section(dev);
 
-    if ((id = zfApFindSta(dev, addr)) != 0xffff)
+    id = zfApFindSta(dev, addr);
+    if (id != 0xffff)
     {
         *encryType = wd->ap.staTable[id].encryMode;
     }
@@ -260,7 +264,8 @@ void zfApGetStaWpaIv(zdev_t* dev, u16_t* addr, u16_t* iv16, u32_t* iv32)
 
     zmw_enter_critical_section(dev);
 
-    if ((id = zfApFindSta(dev, addr)) != 0xffff)
+    id = zfApFindSta(dev, addr);
+    if (id != 0xffff)
     {
         *iv16 = wd->ap.staTable[id].iv16;
         *iv32 = wd->ap.staTable[id].iv32;
@@ -289,7 +294,8 @@ void zfApSetStaWpaIv(zdev_t* dev, u16_t* addr, u16_t iv16, u32_t iv32)
 
     zmw_enter_critical_section(dev);
 
-    if ((id = zfApFindSta(dev, addr)) != 0xffff)
+    id = zfApFindSta(dev, addr);
+    if (id != 0xffff)
     {
         wd->ap.staTable[id].iv16 = iv16;
         wd->ap.staTable[id].iv32 = iv32;
@@ -321,7 +327,8 @@ void zfApClearStaKey(zdev_t* dev, u16_t* addr)
 
         zmw_enter_critical_section(dev);
 
-        if ((id = zfApFindSta(dev, addr)) != 0xffff)
+        id = zfApFindSta(dev, addr);
+        if (id != 0xffff)
         {
             /* Turn off STA's key information */
             zfHpRemoveKey(dev, id+1);
@@ -348,7 +355,8 @@ void zfApGetStaCencIvAndKeyIdx(zdev_t* dev, u16_t* addr, u32_t *iv, u8_t *keyIdx
 
     zmw_enter_critical_section(dev);
 
-    if ((id = zfApFindSta(dev, addr)) != 0xffff)
+    id = zfApFindSta(dev, addr);
+    if (id != 0xffff)
     {
         *iv++ = wd->ap.staTable[id].txiv[0];
         *iv++ = wd->ap.staTable[id].txiv[1];
@@ -379,7 +387,8 @@ void zfApSetStaCencIv(zdev_t* dev, u16_t* addr, u32_t *iv)
 
     zmw_enter_critical_section(dev);
 
-    if ((id = zfApFindSta(dev, addr)) != 0xffff)
+    id = zfApFindSta(dev, addr);
+    if (id != 0xffff)
     {
         wd->ap.staTable[id].txiv[0] = *iv++;
         wd->ap.staTable[id].txiv[1] = *iv++;
@@ -539,7 +548,8 @@ u16_t zfApBufferPsFrame(zdev_t* dev, zbuf_t* buf, u16_t port)
     {
         zmw_enter_critical_section(dev);
 
-        if ((id = zfApFindSta(dev, addr)) != 0xffff)
+        id = zfApFindSta(dev, addr);
+        if (id != 0xffff)
         {
             if (wd->ap.staTable[id].psMode == 1)
             {
@@ -603,7 +613,8 @@ u16_t zfApGetSTAInfoAndUpdatePs(zdev_t* dev, u16_t* addr, u16_t* state,
     //psMode=0;
 #endif
 
-    if ((id = zfApFindSta(dev, addr)) != 0xffff)
+    id = zfApFindSta(dev, addr);
+    if (id != 0xffff)
     {
         if (psMode != 0)
         {
@@ -648,7 +659,8 @@ u16_t zfApGetSTAInfoAndUpdatePs(zdev_t* dev, u16_t* addr, u16_t* state,
 
         while (1)
         {
-            if ((psBuf = zfQueueGetWithMac(dev, wd->ap.uapsdQ, (u8_t*)addr, &mb)) != NULL)
+            psBuf = zfQueueGetWithMac(dev, wd->ap.uapsdQ, (u8_t*)addr, &mb);
+            if (psBuf != NULL)
             {
                 zfTxSendEth(dev, psBuf, 0, ZM_EXTERNAL_ALLOC_BUF, 0);
             }
@@ -730,7 +742,8 @@ u16_t zfApAddSta(zdev_t* dev, u16_t* addr, u16_t state, u16_t apId, u8_t type,
 
     zmw_enter_critical_section(dev);
 
-    if ((index = zfApFindSta(dev, addr)) != 0xffff)
+    index = zfApFindSta(dev, addr);
+    if (index != 0xffff)
     {
         zm_msg0_mm(ZM_LV_2, "found");
         /* Update STA state */
@@ -963,7 +976,8 @@ void zfApProcessBeacon(zdev_t* dev, zbuf_t* buf)
     zm_msg0_mm(ZM_LV_3, "Rx beacon");
 
     /* update Non-ERP flag(wd->ap.nonErpObss) */
-    if ((offset = zfFindElement(dev, buf, ZM_WLAN_EID_ERP)) == 0xffff)
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_ERP);
+    if (offset == 0xffff)
     {
         /* 11b OBSS */
         wd->ap.protectedObss++;
@@ -1046,7 +1060,8 @@ void zfApProcessAuth(zdev_t* dev, zbuf_t* buf, u16_t* src, u16_t apId)
             if (seq == 1)
             {
                 /* AP : update STA to auth */
-                if ((ret = zfApAddSta(dev, src, ZM_STATE_AUTH, apId, 0, 0, 0)) != 0xffff)
+                ret = zfApAddSta(dev, src, ZM_STATE_AUTH, apId, 0, 0, 0);
+                if (ret != 0xffff)
                 {
                     /* AP : call zfwAuthNotify() for host to judge */
                     //zfwAuthNotify(dev, src);
@@ -1177,12 +1192,14 @@ void zfApProcessAsocReq(zdev_t* dev, zbuf_t* buf, u16_t* src, u16_t apId)
 
     zmw_get_wlan_dev(dev);
     /* AP : check SSID */
-    if ((offset = zfFindElement(dev, buf, ZM_WLAN_EID_SSID)) != 0xffff)
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_SSID);
+    if (offset != 0xffff)
     {
         k = 0;
         for (j = 0; j < wd->ap.vapNumber; j++)
         {
-            if ((tmp = zmw_buf_readb(dev, buf, offset+1))
+            tmp = zmw_buf_readb(dev, buf, offset+1);
+            if (tmp
                         != wd->ap.ssidLen[j])
             {
                 k++;
@@ -1198,7 +1215,8 @@ void zfApProcessAsocReq(zdev_t* dev, zbuf_t* buf, u16_t* src, u16_t apId)
         {
             for (i=0; i<wd->ap.ssidLen[j]; i++)
             {
-                if ((tmp = zmw_buf_readb(dev, buf, offset+2+i))
+                tmp = zmw_buf_readb(dev, buf, offset+2+i);
+                if (tmp
                         != wd->ap.ssid[j][i])
                 {
                     break;
@@ -1222,13 +1240,15 @@ void zfApProcessAsocReq(zdev_t* dev, zbuf_t* buf, u16_t* src, u16_t apId)
     /* TODO : check capability */
 
     /* AP : check support rate */
-    if ((offset = zfFindElement(dev, buf, ZM_WLAN_EID_EXTENDED_RATE)) != 0xffff)
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_EXTENDED_RATE);
+    if (offset != 0xffff)
     {
         /* 11g STA */
         staType = 1;
     }
     //CWYang(+)
-    if ((offset = zfFindElement(dev, buf, ZM_WLAN_EID_HT_CAPABILITY)) != 0xffff)
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_HT_CAPABILITY);
+    if (offset != 0xffff)
     {
         /* 11n STA */
         staType = 2;
@@ -1251,7 +1271,8 @@ void zfApProcessAsocReq(zdev_t* dev, zbuf_t* buf, u16_t* src, u16_t apId)
     /* AP : check 11h */
 
     /* AP : check WME */
-    if ((offset = zfFindWifiElement(dev, buf, 2, 0)) != 0xffff)
+    offset = zfFindWifiElement(dev, buf, 2, 0);
+    if (offset != 0xffff)
     {
         /* WME STA */
         qosType = 1;
@@ -1265,7 +1286,8 @@ void zfApProcessAsocReq(zdev_t* dev, zbuf_t* buf, u16_t* src, u16_t apId)
 
     if (wd->ap.wpaSupport[apId] == 1)
     {
-        if ( (offset = zfFindElement(dev, buf, ZM_WLAN_EID_WPA_IE)) != 0xffff )
+        offset = zfFindElement(dev, buf, ZM_WLAN_EID_WPA_IE);
+        if (offset != 0xffff)
         {
             /* get WPA IE */
             u8_t length = zmw_rx_buf_readb(dev, buf, offset+1);
@@ -1406,12 +1428,14 @@ void zfApStoreAsocReqIe(zdev_t* dev, zbuf_t* buf, u16_t aid)
     offset = 28;
 
     /* supported rates */
-    if ((offset = zfFindElement(dev, buf, ZM_WLAN_EID_SUPPORT_RATE)) == 0xffff)
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_SUPPORT_RATE);
+    if (offset == 0xffff)
         return;
     length = zmw_rx_buf_readb(dev, buf, offset + 1);
 
     /* extended supported rates */
-    if ((offset = zfFindElement(dev, buf, ZM_WLAN_EID_EXTENDED_RATE)) == 0xffff)
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_EXTENDED_RATE);
+    if (offset == 0xffff)
         return;
     length = zmw_rx_buf_readb(dev, buf, offset + 1);
 
@@ -1426,7 +1450,8 @@ void zfApStoreAsocReqIe(zdev_t* dev, zbuf_t* buf, u16_t aid)
     /* QoS */
 
     /* HT capabilities: 28 octets */
-    if ((offset = zfFindElement(dev, buf, ZM_WLAN_EID_HT_CAPABILITY)) != 0xffff) {
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_HT_CAPABILITY);
+    if (offset != 0xffff) {
         /* atheros pre n */
         htcap = (u8_t *)&wd->ap.ie[aid].HtCap;
         htcap[0] = zmw_rx_buf_readb(dev, buf, offset);
@@ -1479,7 +1504,8 @@ void zfApProcessDeauth(zdev_t* dev, zbuf_t* buf, u16_t* src, u16_t apId)
 
     zmw_enter_critical_section(dev);
     /* AP : if SA=associated STA then deauthenticate STA */
-    if ((aid = zfApFindSta(dev, src)) != 0xffff)
+    aid = zfApFindSta(dev, src);
+    if (aid != 0xffff)
     {
         /* Clear STA table */
         wd->ap.staTable[aid].valid = 0;
@@ -1500,7 +1526,8 @@ void zfApProcessDisasoc(zdev_t* dev, zbuf_t* buf, u16_t* src, u16_t apId)
 
     zmw_enter_critical_section(dev);
     /* AP : if SA=associated STA then deauthenticate STA */
-    if ((aid = zfApFindSta(dev, src)) != 0xffff)
+    aid = zfApFindSta(dev, src);
+    if (aid != 0xffff)
     {
         /* Clear STA table */
         wd->ap.staTable[aid].valid = 0;
@@ -1674,7 +1701,8 @@ u16_t zfApAddIeTim(zdev_t* dev, zbuf_t* buf, u16_t offset, u16_t vap)
         dst[0] = zmw_tx_buf_readh(dev, psBuf, 0);
         dst[1] = zmw_tx_buf_readh(dev, psBuf, 2);
         dst[2] = zmw_tx_buf_readh(dev, psBuf, 4);
-        if ((aid = zfApFindSta(dev, dst)) != 0xffff)
+        aid = zfApFindSta(dev, dst);
+        if (aid != 0xffff)
         {
             if (wd->ap.staTable[aid].psMode != 0)
             {
@@ -1896,7 +1924,8 @@ void zfApSendBeacon(zdev_t* dev)
     zm_msg1_mm(ZM_LV_2, "Send beacon, vap=", vap);
 
     /* TBD : Maximum size of beacon */
-    if ((buf = zfwBufAllocate(dev, 1024)) == NULL)
+    buf = zfwBufAllocate(dev, 1024);
+    if (buf == NULL)
     {
         zm_msg0_mm(ZM_LV_0, "Alloc beacon buf Fail!");
         return;
@@ -2101,8 +2130,8 @@ u16_t zfIntrabssForward(zdev_t* dev, zbuf_t* buf, u8_t srcVap)
     if ((asocFlag == 1) || ((dst[0]&0x1) == 0x1))
     {
         /* Allocate frame */
-        if ((txBuf = zfwBufAllocate(dev, ZM_RX_FRAME_SIZE))
-                == NULL)
+        txBuf = zfwBufAllocate(dev, ZM_RX_FRAME_SIZE);
+        if (txBuf == NULL)
         {
             zm_msg0_rx(ZM_LV_1, "Alloc intra-bss buf Fail!");
             goto zlAllocError;
@@ -2133,7 +2162,8 @@ u16_t zfIntrabssForward(zdev_t* dev, zbuf_t* buf, u8_t srcVap)
 
         /* Transmit frame */
         /* Return error if port is disabled */
-        if ((err = zfTxPortControl(dev, txBuf, vap)) == ZM_PORT_DISABLED)
+        err = zfTxPortControl(dev, txBuf, vap);
+        if (err == ZM_PORT_DISABLED)
         {
             err = ZM_ERR_TX_PORT_DISABLED;
             goto zlTxError;
@@ -2141,7 +2171,8 @@ u16_t zfIntrabssForward(zdev_t* dev, zbuf_t* buf, u8_t srcVap)
 
 #if 1
         /* AP : Buffer frame for power saving STA */
-        if ((ret = zfApBufferPsFrame(dev, txBuf, vap)) == 0)
+        ret = zfApBufferPsFrame(dev, txBuf, vap);
+        if (ret == 0)
         {
             /* forward frame if not been buffered */
             #if 1
@@ -2177,7 +2208,8 @@ struct zsMicVar* zfApGetRxMicKey(zdev_t* dev, zbuf_t* buf)
     macAddr[1] = sa[2] + (sa[3] << 8);
     macAddr[2] = sa[4] + (sa[5] << 8);
 
-    if ((id = zfApFindSta(dev, macAddr)) != 0xffff)
+    id = zfApFindSta(dev, macAddr);
+    if (id != 0xffff)
         return (&wd->ap.staTable[id].rxMicKey);
 
     return NULL;
@@ -2369,7 +2401,8 @@ void zfApSendFailure(zdev_t* dev, u8_t* addr)
     staAddr[1] = addr[2] + (((u16_t)addr[3])<<8);
     staAddr[2] = addr[4] + (((u16_t)addr[5])<<8);
     zmw_enter_critical_section(dev);
-    if ((id = zfApFindSta(dev, staAddr)) != 0xffff)
+    id = zfApFindSta(dev, staAddr);
+    if (id != 0xffff)
     {
         /* Send failture : Add 3 minutes to inactive time that will */
         /*                 will make STA been kicked out soon */
diff --git a/drivers/staging/otus/80211core/cmmsta.c b/drivers/staging/otus/80211core/cmmsta.c
index c3fd475..0fda30d 100644
--- a/drivers/staging/otus/80211core/cmmsta.c
+++ b/drivers/staging/otus/80211core/cmmsta.c
@@ -602,7 +602,8 @@ void zfStaProtErpMonitor(zdev_t* dev, zbuf_t* buf)
 
         if (zfRxBufferEqualToStr(dev, buf, bssid, ZM_WLAN_HEADER_A2_OFFSET, 6))
         {
-            if ( (offset=zfFindElement(dev, buf, ZM_WLAN_EID_ERP)) != 0xffff )
+            offset = zfFindElement(dev, buf, ZM_WLAN_EID_ERP);
+            if (offset != 0xffff)
             {
                 erp = zmw_rx_buf_readb(dev, buf, offset+2);
 
@@ -628,7 +629,8 @@ void zfStaProtErpMonitor(zdev_t* dev, zbuf_t* buf)
         }
 		//Check the existence of Non-N AP
 		//Follow the check the "pBssInfo->EnableHT"
-			if ((offset = zfFindElement(dev, buf, ZM_WLAN_EID_HT_CAPABILITY)) != 0xffff)
+			offset = zfFindElement(dev, buf, ZM_WLAN_EID_HT_CAPABILITY);
+			if (offset != 0xffff)
 			{}
 			else if ((offset = zfFindElement(dev, buf, ZM_WLAN_PREN2_EID_HTCAPABILITY)) != 0xffff)
 			{}
@@ -658,9 +660,11 @@ void zfStaUpdateWmeParameter(zdev_t* dev, zbuf_t* buf)
     if (wd->sta.wmeConnected != 0)
     {
         /* Find WME parameter element */
-        if ((offset = zfFindWifiElement(dev, buf, 2, 1)) != 0xffff)
+        offset = zfFindWifiElement(dev, buf, 2, 1);
+        if (offset != 0xffff)
         {
-            if ((len = zmw_rx_buf_readb(dev, buf, offset+1)) >= 7)
+            len = zmw_rx_buf_readb(dev, buf, offset+1);
+            if (len >= 7)
             {
                 rxWmeParameterSetCount=zmw_rx_buf_readb(dev, buf, offset+8);
                 if (rxWmeParameterSetCount != wd->sta.wmeParameterSetCount)
@@ -741,7 +745,8 @@ void zfStaUpdateDot11HDFS(zdev_t* dev, zbuf_t* buf)
     */
 
     /* get EID(Channel Switch Announcement) */
-    if ( (offset = zfFindElement(dev, buf, ZM_WLAN_EID_CHANNEL_SWITCH_ANNOUNCE)) == 0xffff )
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_CHANNEL_SWITCH_ANNOUNCE);
+    if (offset == 0xffff)
     {
         //zm_debug_msg0("EID(Channel Switch Announcement) not found");
         return;
@@ -1216,7 +1221,8 @@ void zfStaSendBeacon(zdev_t* dev)
     //zm_debug_msg0("\n");
 
     /* TBD : Maximum size of beacon */
-    if ((buf = zfwBufAllocate(dev, 1024)) == NULL)
+    buf = zfwBufAllocate(dev, 1024);
+    if (buf == NULL)
     {
         zm_debug_msg0("Allocate beacon buffer failed");
         return;
@@ -1370,7 +1376,8 @@ struct zsBssInfo* zfStaFindBssInfo(zdev_t* dev, zbuf_t* buf, struct zsWlanProbeR
 
     zmw_get_wlan_dev(dev);
 
-    if ((pBssInfo = wd->sta.bssList.head) == NULL)
+    pBssInfo = wd->sta.bssList.head;
+    if (pBssInfo == NULL)
     {
         return NULL;
     }
@@ -1420,8 +1427,10 @@ struct zsBssInfo* zfStaFindBssInfo(zdev_t* dev, zbuf_t* buf, struct zsWlanProbeR
         /* Check channel */
         /* Add check channel to solve the bug #31222 */
         if (isMatched) {
-            if ((offset = zfFindElement(dev, buf, ZM_WLAN_EID_DS)) != 0xffff) {
-                if ((length = zmw_rx_buf_readb(dev, buf, offset+1)) == 1) {
+            offset = zfFindElement(dev, buf, ZM_WLAN_EID_DS);
+            if (offset != 0xffff) {
+                length = zmw_rx_buf_readb(dev, buf, offset+1);
+                if (length == 1) {
                     channel = zmw_rx_buf_readb(dev, buf, offset+2);
                     if (zfHpIsAllowedChannel(dev, zfChNumToFreq(dev, channel, 0)) == 0) {
                         frequency = 0;
@@ -1473,7 +1482,8 @@ u8_t zfStaInitBssInfo(zdev_t* dev, zbuf_t* buf,
     }
 
     /* get SSID */
-    if ( (offset = zfFindElement(dev, buf, ZM_WLAN_EID_SSID)) == 0xffff )
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_SSID);
+    if (offset == 0xffff)
     {
         zm_debug_msg0("EID(SSID) not found");
         goto zlError;
@@ -1506,7 +1516,8 @@ u8_t zfStaInitBssInfo(zdev_t* dev, zbuf_t* buf,
     zfCopyFromRxBuffer(dev, buf, pBssInfo->ssid, offset, length+2);
 
     /* get DS parameter */
-    if ( (offset = zfFindElement(dev, buf, ZM_WLAN_EID_DS)) != 0xffff )
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_DS);
+    if (offset != 0xffff)
     {
         length = zmw_rx_buf_readb(dev, buf, offset+1);
         if ( length != 1 )
@@ -1590,7 +1601,8 @@ u8_t zfStaInitBssInfo(zdev_t* dev, zbuf_t* buf,
     pBssInfo->frameBodysize = accumulateLen;
 
     /* get supported rates */
-    if ( (offset = zfFindElement(dev, buf, ZM_WLAN_EID_SUPPORT_RATE)) == 0xffff )
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_SUPPORT_RATE);
+    if (offset == 0xffff)
     {
         zm_debug_msg0("EID(supported rates) not found");
         goto zlError;
@@ -1607,7 +1619,8 @@ u8_t zfStaInitBssInfo(zdev_t* dev, zbuf_t* buf,
 
 
     /* get Country information */
-    if ( (offset = zfFindElement(dev, buf, ZM_WLAN_EID_COUNTRY)) != 0xffff )
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_COUNTRY);
+    if (offset != 0xffff)
     {
         length = zmw_rx_buf_readb(dev, buf, offset+1);
         if (length > ZM_MAX_COUNTRY_INFO_SIZE)
@@ -1625,13 +1638,15 @@ u8_t zfStaInitBssInfo(zdev_t* dev, zbuf_t* buf,
     }
 
     /* get ERP information */
-    if ( (offset = zfFindElement(dev, buf, ZM_WLAN_EID_ERP)) != 0xffff )
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_ERP);
+    if (offset != 0xffff)
     {
         pBssInfo->erp = zmw_rx_buf_readb(dev, buf, offset+2);
     }
 
     /* get extended supported rates */
-    if ( (offset = zfFindElement(dev, buf, ZM_WLAN_EID_EXTENDED_RATE)) != 0xffff )
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_EXTENDED_RATE);
+    if (offset != 0xffff)
     {
         length = zmw_rx_buf_readb(dev, buf, offset+1);
         if (length > ZM_MAX_SUPP_RATES_IE_SIZE)
@@ -1648,7 +1663,8 @@ u8_t zfStaInitBssInfo(zdev_t* dev, zbuf_t* buf,
     }
 
     /* get WPA IE */
-    if ( (offset = zfFindElement(dev, buf, ZM_WLAN_EID_WPA_IE)) != 0xffff )
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_WPA_IE);
+    if (offset != 0xffff)
     {
         length = zmw_rx_buf_readb(dev, buf, offset+1);
         if (length > ZM_MAX_IE_SIZE)
@@ -1664,7 +1680,8 @@ u8_t zfStaInitBssInfo(zdev_t* dev, zbuf_t* buf,
     }
 
     /* get WPS IE */
-    if ((offset = zfFindWifiElement(dev, buf, 4, 0xff)) != 0xffff)
+    offset = zfFindWifiElement(dev, buf, 4, 0xff);
+    if (offset != 0xffff)
     {
         length = zmw_rx_buf_readb(dev, buf, offset+1);
         if (length > ZM_MAX_WPS_IE_SIZE )
@@ -1679,19 +1696,22 @@ u8_t zfStaInitBssInfo(zdev_t* dev, zbuf_t* buf,
     }
 
     /* get SuperG IE */
-    if ((offset = zfFindSuperGElement(dev, buf, ZM_WLAN_EID_VENDOR_PRIVATE)) != 0xffff)
+    offset = zfFindSuperGElement(dev, buf, ZM_WLAN_EID_VENDOR_PRIVATE);
+    if (offset != 0xffff)
     {
         pBssInfo->apCap |= ZM_SuperG_AP;
     }
 
     /* get XR IE */
-    if ((offset = zfFindXRElement(dev, buf, ZM_WLAN_EID_VENDOR_PRIVATE)) != 0xffff)
+    offset = zfFindXRElement(dev, buf, ZM_WLAN_EID_VENDOR_PRIVATE);
+    if (offset != 0xffff)
     {
         pBssInfo->apCap |= ZM_XR_AP;
     }
 
     /* get RSN IE */
-    if ( (offset = zfFindElement(dev, buf, ZM_WLAN_EID_RSN_IE)) != 0xffff )
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_RSN_IE);
+    if (offset != 0xffff)
     {
         length = zmw_rx_buf_readb(dev, buf, offset+1);
         if (length > ZM_MAX_IE_SIZE)
@@ -1707,7 +1727,8 @@ u8_t zfStaInitBssInfo(zdev_t* dev, zbuf_t* buf,
     }
 #ifdef ZM_ENABLE_CENC
     /* get CENC IE */
-    if ( (offset = zfFindElement(dev, buf, ZM_WLAN_EID_CENC_IE)) != 0xffff )
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_CENC_IE);
+    if (offset != 0xffff)
     {
         length = zmw_rx_buf_readb(dev, buf, offset+1);
         if (length > ZM_MAX_IE_SIZE )
@@ -1726,7 +1747,8 @@ u8_t zfStaInitBssInfo(zdev_t* dev, zbuf_t* buf,
     /* get WME Parameter IE, probe rsp may contain WME parameter element */
     //if ( wd->bQoSEnable )
     {
-        if ((offset = zfFindWifiElement(dev, buf, 2, 1)) != 0xffff)
+        offset = zfFindWifiElement(dev, buf, 2, 1);
+        if (offset != 0xffff)
         {
             apQosInfo = zmw_rx_buf_readb(dev, buf, offset+8) & 0x80;
             pBssInfo->wmeSupport = 1 | apQosInfo;
@@ -1742,7 +1764,8 @@ u8_t zfStaInitBssInfo(zdev_t* dev, zbuf_t* buf,
         }
     }
     //CWYang(+)
-    if ((offset = zfFindElement(dev, buf, ZM_WLAN_EID_HT_CAPABILITY)) != 0xffff)
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_HT_CAPABILITY);
+    if (offset != 0xffff)
     {
         /* 11n AP */
         pBssInfo->EnableHT = 1;
@@ -1792,7 +1815,8 @@ u8_t zfStaInitBssInfo(zdev_t* dev, zbuf_t* buf,
         pBssInfo->EnableHT = 0;
     }
     /* HT information */
-    if ((offset = zfFindElement(dev, buf, ZM_WLAN_EID_EXTENDED_HT_CAPABILITY)) != 0xffff)
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_EXTENDED_HT_CAPABILITY);
+    if (offset != 0xffff)
     {
         /* atheros pre n */
         pBssInfo->extChOffset = zmw_rx_buf_readb(dev, buf, offset+2) & 0x03;
@@ -1848,7 +1872,8 @@ u8_t zfStaInitBssInfo(zdev_t* dev, zbuf_t* buf,
     }
 
     /* get Marvel Extended Capability */
-    if ((offset = zfFindMarvelExtCap(dev, buf)) != 0xffff)
+    offset = zfFindMarvelExtCap(dev, buf);
+    if (offset != 0xffff)
     {
         pBssInfo->marvelAp = 1;
     }
@@ -1858,7 +1883,8 @@ u8_t zfStaInitBssInfo(zdev_t* dev, zbuf_t* buf,
     }
 
     /* get ATIM window */
-    if ( (offset = zfFindElement(dev, buf, ZM_WLAN_EID_IBSS)) != 0xffff )
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_IBSS);
+    if (offset != 0xffff )
     {
         pBssInfo->atimWindow = zmw_rx_buf_readh(dev, buf,offset+2);
     }
@@ -2017,7 +2043,8 @@ zlUpdateRssi:
     pBssInfo->tick = wd->tick;
 
     /* Update ERP information */
-    if ( (offset = zfFindElement(dev, buf, ZM_WLAN_EID_ERP)) != 0xffff )
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_ERP);
+    if (offset != 0xffff)
     {
         pBssInfo->erp = zmw_rx_buf_readb(dev, buf, offset+2);
     }
@@ -2116,7 +2143,8 @@ void zfStaProcessBeacon(zdev_t* dev, zbuf_t* buf, struct zsAdditionInfo* AddInfo
 #if 0
             else if ( wd->sta.oppositeCount == 0 )
             {   /* IBSS merge if SSID matched */
-                if ( (offset = zfFindElement(dev, buf, ZM_WLAN_EID_SSID)) != 0xffff )
+                offset = zfFindElement(dev, buf, ZM_WLAN_EID_SSID);
+                if (offset != 0xffff)
                 {
                     if ( (wd->sta.ssidLen == zmw_buf_readb(dev, buf, offset+1))&&
                          (zfRxBufferEqualToStr(dev, buf, wd->sta.ssid,
@@ -2410,7 +2438,8 @@ void zfStaProcessAsocRsp(zdev_t* dev, zbuf_t* buf)
             if ((wd->sta.wmeEnabled & ZM_STA_WME_ENABLE_BIT) != 0) //WME enabled
             {
                 /* Asoc rsp may contain WME parameter element */
-                if ((offset = zfFindWifiElement(dev, buf, 2, 1)) != 0xffff)
+                offset = zfFindWifiElement(dev, buf, 2, 1);
+                if (offset != 0xffff)
                 {
                     zm_debug_msg0("WME enable");
                     wd->sta.wmeConnected = 1;
@@ -2605,7 +2634,8 @@ void zfStaStoreAsocRspIe(zdev_t* dev, zbuf_t* buf)
         return;
     }
 
-    if ((offset = zfFindElement(dev, buf, ZM_WLAN_EID_HT_CAPABILITY)) != 0xffff)
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_HT_CAPABILITY);
+    if (offset != 0xffff)
     {
         /* atheros pre n */
         zm_debug_msg0("atheros pre n");
@@ -2645,7 +2675,8 @@ void zfStaStoreAsocRspIe(zdev_t* dev, zbuf_t* buf)
     asocBw40 = (u8_t)((wd->sta.ie.HtCap.HtCapInfo & HTCAP_SupChannelWidthSet) >> 1);
 
     /* HT information */
-    if ((offset = zfFindElement(dev, buf, ZM_WLAN_EID_EXTENDED_HT_CAPABILITY)) != 0xffff)
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_EXTENDED_HT_CAPABILITY);
+    if (offset != 0xffff)
     {
         /* atheros pre n */
         zm_debug_msg0("atheros pre n HTINFO");
@@ -2815,7 +2846,8 @@ void zfStaProcessProbeReq(zdev_t* dev, zbuf_t* buf, u16_t* src)
     }
 
     /* check SSID */
-    if ((offset = zfFindElement(dev, buf, ZM_WLAN_EID_SSID)) == 0xffff)
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_SSID);
+    if (offset == 0xffff)
     {
         zm_msg0_mm(ZM_LV_3, "probe req SSID not found");
         return;
@@ -3774,7 +3806,8 @@ static struct zsBssInfo* zfInfraFindAPToConnect(zdev_t* dev,
             }
 
             /* Skip if AP in blocking list */
-            if ((ret = zfStaIsApInBlockingList(dev, pBssInfo->bssid)) == TRUE)
+            ret = zfStaIsApInBlockingList(dev, pBssInfo->bssid);
+            if (ret == TRUE)
             {
                 zm_msg0_mm(ZM_LV_0, "Candidate AP in blocking List, skip if there's stilla choice!");
                 pNowBssInfo = pBssInfo;
@@ -5007,7 +5040,8 @@ void zfSendNullData(zdev_t* dev, u8_t type)
 
     zmw_get_wlan_dev(dev);
 
-    if ((buf = zfwBufAllocate(dev, 1024)) == NULL)
+    buf = zfwBufAllocate(dev, 1024);
+    if (buf == NULL)
     {
         zm_msg0_mm(ZM_LV_0, "Alloc mm buf Fail!");
         return;
@@ -5056,8 +5090,9 @@ void zfSendNullData(zdev_t* dev, u8_t type)
     /*increase unicast frame counter*/
     wd->commTally.txUnicastFrm++;
 
-    if ((err = zfHpSend(dev, header, hlen, NULL, 0, NULL, 0, buf, 0,
-            ZM_INTERNAL_ALLOC_BUF, 0, 0xff)) != ZM_SUCCESS)
+    err = zfHpSend(dev, header, hlen, NULL, 0, NULL, 0, buf, 0,
+            ZM_INTERNAL_ALLOC_BUF, 0, 0xff);
+    if (err != ZM_SUCCESS)
     {
         goto zlError;
     }
@@ -5083,7 +5118,8 @@ void zfSendPSPoll(zdev_t* dev)
 
     zmw_get_wlan_dev(dev);
 
-    if ((buf = zfwBufAllocate(dev, 1024)) == NULL)
+    buf = zfwBufAllocate(dev, 1024);
+    if (buf == NULL)
     {
         zm_msg0_mm(ZM_LV_0, "Alloc mm buf Fail!");
         return;
@@ -5107,8 +5143,9 @@ void zfSendPSPoll(zdev_t* dev)
     //    goto zlError;
     //}
 
-    if ((err = zfHpSend(dev, header, hlen, NULL, 0, NULL, 0, buf, 0,
-            ZM_INTERNAL_ALLOC_BUF, 0, 0xff)) != ZM_SUCCESS)
+    err = zfHpSend(dev, header, hlen, NULL, 0, NULL, 0, buf, 0,
+		   ZM_INTERNAL_ALLOC_BUF, 0, 0xff);
+    if (err != ZM_SUCCESS)
     {
         goto zlError;
     }
@@ -5134,7 +5171,8 @@ void zfSendBA(zdev_t* dev, u16_t start_seq, u8_t *bitmap)
 
     zmw_get_wlan_dev(dev);
 
-    if ((buf = zfwBufAllocate(dev, 1024)) == NULL)
+    buf = zfwBufAllocate(dev, 1024);
+    if (buf == NULL)
     {
         zm_msg0_mm(ZM_LV_0, "Alloc mm buf Fail!");
         return;
@@ -5166,8 +5204,9 @@ void zfSendBA(zdev_t* dev, u16_t start_seq, u8_t *bitmap)
         offset++;
     }
 
-    if ((err = zfHpSend(dev, header, hlen, NULL, 0, NULL, 0, buf, 0,
-            ZM_INTERNAL_ALLOC_BUF, 0, 0xff)) != ZM_SUCCESS)
+    err = zfHpSend(dev, header, hlen, NULL, 0, NULL, 0, buf, 0,
+		   ZM_INTERNAL_ALLOC_BUF, 0, 0xff);
+    if (err != ZM_SUCCESS)
     {
         goto zlError;
     }
diff --git a/drivers/staging/otus/80211core/coid.c b/drivers/staging/otus/80211core/coid.c
index 0524e1f..229aed8 100644
--- a/drivers/staging/otus/80211core/coid.c
+++ b/drivers/staging/otus/80211core/coid.c
@@ -553,7 +553,8 @@ u8_t zfiWlanSetKey(zdev_t* dev, struct zsKeyInfo keyInfo)
         if (keyInfo.flag & ZM_KEY_FLAG_PK)
         {
             /* Find STA's information */
-            if ((id = zfApFindSta(dev, keyInfo.macAddr)) == 0xffff)
+            id = zfApFindSta(dev, keyInfo.macAddr);
+            if (id == 0xffff)
             {
                 /* Can't STA in the staTable */
                 return ZM_STATUS_FAILURE;
diff --git a/drivers/staging/otus/80211core/cpsmgr.c b/drivers/staging/otus/80211core/cpsmgr.c
index 98e1f0c..32313be 100644
--- a/drivers/staging/otus/80211core/cpsmgr.c
+++ b/drivers/staging/otus/80211core/cpsmgr.c
@@ -602,7 +602,8 @@ void zfPowerSavingMgrProcessBeacon(zdev_t* dev, zbuf_t* buf)
 
     wd->sta.psMgr.isSleepAllowed = 1;
 
-    if ( (offset=zfFindElement(dev, buf, ZM_WLAN_EID_TIM)) != 0xffff )
+    offset = zfFindElement(dev, buf, ZM_WLAN_EID_TIM);
+    if (offset != 0xffff)
     {
         length = zmw_rx_buf_readb(dev, buf, offset+1);
 
diff --git a/drivers/staging/otus/80211core/ctxrx.c b/drivers/staging/otus/80211core/ctxrx.c
index 4e7f4bd..a127196 100644
--- a/drivers/staging/otus/80211core/ctxrx.c
+++ b/drivers/staging/otus/80211core/ctxrx.c
@@ -109,7 +109,8 @@ void zfGetRxIvIcvLength(zdev_t* dev, zbuf_t* buf, u8_t vap, u16_t* pIvLen,
                 addr[2] = zmw_rx_buf_readh(dev, buf, ZM_WLAN_HEADER_A2_OFFSET+4);
 
                 /* Find STA's information */
-                if ((id = zfApFindSta(dev, addr)) != 0xffff)
+                id = zfApFindSta(dev, addr);
+                if (id != 0xffff)
                 {
                     if (wd->ap.staTable[id].encryMode == ZM_TKIP)
                     {
@@ -132,7 +133,8 @@ void zfGetRxIvIcvLength(zdev_t* dev, zbuf_t* buf, u8_t vap, u16_t* pIvLen,
                 }
             }
             /* WDS port checking */
-            if ((wdsPort = vap - 0x20) >= ZM_MAX_WDS_SUPPORT)
+            wdsPort = vap - 0x20;
+            if (wdsPort >= ZM_MAX_WDS_SUPPORT)
             {
                 wdsPort = 0;
             }
@@ -741,8 +743,9 @@ u16_t zfiTxSend80211Mgmt(zdev_t* dev, zbuf_t* buf, u16_t port)
 
     zfwBufRemoveHead(dev, buf, 24);
 
-    if ((err = zfHpSend(dev, header, hlen, NULL, 0, NULL, 0, buf, 0,
-            ZM_EXTERNAL_ALLOC_BUF, 0, 0)) != ZM_SUCCESS)
+    err = zfHpSend(dev, header, hlen, NULL, 0, NULL, 0, buf, 0,
+		   ZM_EXTERNAL_ALLOC_BUF, 0, 0);
+    if (err != ZM_SUCCESS)
     {
         goto zlError;
     }
@@ -799,7 +802,8 @@ u16_t zfiTxSendEth(zdev_t* dev, zbuf_t* buf, u16_t port)
     ZM_PERFORMANCE_TX_MSDU(dev, wd->tick);
     zm_msg1_tx(ZM_LV_2, "zfiTxSendEth(), port=", port);
     /* Return error if port is disabled */
-    if ((err = zfTxPortControl(dev, buf, port)) == ZM_PORT_DISABLED)
+    err = zfTxPortControl(dev, buf, port);
+    if (err == ZM_PORT_DISABLED)
     {
         err = ZM_ERR_TX_PORT_DISABLED;
         goto zlError;
@@ -809,7 +813,8 @@ u16_t zfiTxSendEth(zdev_t* dev, zbuf_t* buf, u16_t port)
     if ((wd->wlanMode == ZM_MODE_AP) && (port < 0x20))
     {
         /* AP : Buffer frame for power saving STA */
-        if ((ret = zfApBufferPsFrame(dev, buf, port)) == 1)
+        ret = zfApBufferPsFrame(dev, buf, port);
+        if (ret == 1)
         {
             return ZM_SUCCESS;
         }
@@ -1119,7 +1124,8 @@ u16_t zfTxSendEth(zdev_t* dev, zbuf_t* buf, u16_t port, u16_t bufType, u16_t fla
             i = 0;
             while( frameLen > 0 )
             {
-                if ((frag.buf[i] = zfwBufAllocate(dev, fragLen+32)) != NULL)
+                frag.buf[i] = zfwBufAllocate(dev, fragLen+32);
+                if (frag.buf[i] != NULL)
                 {
                     frag.bufType[i] = ZM_INTERNAL_ALLOC_BUF;
                     frag.seq[i] = frag.seq[0] + i;
@@ -1276,7 +1282,8 @@ void zfCoreRecv(zdev_t* dev, zbuf_t* buf, struct zsAdditionInfo* addInfo)
     bssid[2] = zmw_buf_readh(dev, buf, 20);
 
     /* Validate Rx frame */
-    if ((ret = zfWlanRxValidate(dev, buf)) != ZM_SUCCESS)
+    ret = zfWlanRxValidate(dev, buf);
+    if (ret != ZM_SUCCESS)
     {
         zm_msg1_rx(ZM_LV_1, "Rx invalid:", ret);
         goto zlError;
@@ -1301,7 +1308,8 @@ void zfCoreRecv(zdev_t* dev, zbuf_t* buf, struct zsAdditionInfo* addInfo)
 #endif
 
     /* Filter Rx frame */
-    if ((ret = zfWlanRxFilter(dev, buf)) != ZM_SUCCESS)
+    ret = zfWlanRxFilter(dev, buf);
+    if (ret != ZM_SUCCESS)
     {
         zm_msg1_rx(ZM_LV_1, "Rx duplicated:", ret);
         goto zlError;
@@ -2086,7 +2094,8 @@ void zfiRecv80211(zdev_t* dev, zbuf_t* buf, struct zsAdditionInfo* addInfo)
         //zm_msg0_rx(ZM_LV_0, "Rx data");
         if (wd->wlanMode == ZM_MODE_AP)
         {
-            if ((ret = zfApUpdatePsBit(dev, buf, &vap, &uapsdTrig)) != ZM_SUCCESS)
+            ret = zfApUpdatePsBit(dev, buf, &vap, &uapsdTrig);
+            if (ret != ZM_SUCCESS)
             {
                 zfwBufFree(dev, buf, 0);
                 return;
@@ -2115,7 +2124,8 @@ void zfiRecv80211(zdev_t* dev, zbuf_t* buf, struct zsAdditionInfo* addInfo)
                     for (ii=0; ii<pktNum; ii++)
                     {
                         //if ((psBuf = zfQueueGet(dev, wd->ap.uapsdQ)) != NULL)
-                        if ((psBuf = zfQueueGetWithMac(dev, wd->ap.uapsdQ, src, &mb)) != NULL)
+                        psBuf = zfQueueGetWithMac(dev, wd->ap.uapsdQ, src, &mb);
+                        if (psBuf != NULL)
                         {
                             if ((ii+1) == pktNum)
                             {
@@ -2232,7 +2242,8 @@ void zfiRecv80211(zdev_t* dev, zbuf_t* buf, struct zsAdditionInfo* addInfo)
         }
         else
         {
-            if ( (buf = zfDefragment(dev, buf, &bIsDefrag, addInfo)) == NULL )
+            buf = zfDefragment(dev, buf, &bIsDefrag, addInfo);
+            if (buf == NULL)
             {
                 /* In this case, the buffer has been freed in zfDefragment */
                 return;
@@ -2836,7 +2847,8 @@ void zfiRecv80211(zdev_t* dev, zbuf_t* buf, struct zsAdditionInfo* addInfo)
                 zfwBufRemoveHead(dev, buf, 18+offset);
 #endif  // ZM_ENABLE_NATIVE_WIFI
                 #if 1
-                if ((ret = zfIntrabssForward(dev, buf, vap)) == 1)
+                ret = zfIntrabssForward(dev, buf, vap);
+                if (ret == 1)
                 {
                     /* Free Rx buffer if intra-BSS unicast frame */
                     zm_msg0_rx(ZM_LV_2, "Free intra-BSS unicast frame");
@@ -3037,7 +3049,8 @@ u16_t zfWlanRxValidate(zdev_t* dev, zbuf_t* buf)
     }
     else if ( wd->wlanMode != ZM_MODE_PSEUDO )
     {
-        if ( (ret=zfStaRxValidateFrame(dev, buf))!=ZM_SUCCESS )
+        ret = zfStaRxValidateFrame(dev, buf);
+        if (ret != ZM_SUCCESS)
         {
             //zm_debug_msg1("discard frame, code = ", ret);
             return ret;
@@ -3787,12 +3800,14 @@ void zfPushVtxq(zdev_t* dev)
         /* 2006.12.20, Serve Management queue */
         while( zfHpGetFreeTxdCount(dev) > 0 )
         {
-            if ((buf = zfGetVmmq(dev)) != 0)
+            buf = zfGetVmmq(dev);
+            if (buf != 0)
             {
                 txed = 1;
                 //zm_debug_msg2("send buf = ", buf);
-                if ((err = zfHpSend(dev, NULL, 0, NULL, 0, NULL, 0, buf, 0,
-                        ZM_INTERNAL_ALLOC_BUF, 0, 0xff)) != ZM_SUCCESS)
+                err = zfHpSend(dev, NULL, 0, NULL, 0, NULL, 0, buf, 0,
+			       ZM_INTERNAL_ALLOC_BUF, 0, 0xff);
+                if (err != ZM_SUCCESS)
                 {
                     zfwBufFree(dev, buf, 0);
                 }
@@ -3831,9 +3846,11 @@ void zfPushVtxq(zdev_t* dev)
         /* Service VTxQ[3] */
         for (i=0; i<4; i++)
         {
-            if ((freeTxd = zfHpGetFreeTxdCount(dev)) >= 3)
+            freeTxd = zfHpGetFreeTxdCount(dev);
+            if (freeTxd >= 3)
             {
-                if ((buf = zfGetVtxq(dev, 3)) != 0)
+                buf = zfGetVtxq(dev, 3);
+                if (buf != 0)
                 {
                     txed = 1;
                     //zm_debug_msg2("send buf = ", buf);
@@ -3850,9 +3867,11 @@ void zfPushVtxq(zdev_t* dev)
         /* Service VTxQ[2] */
         for (i=0; i<3; i++)
         {
-            if ((freeTxd = zfHpGetFreeTxdCount(dev)) >= (zfHpGetMaxTxdCount(dev)*1/4))
+            freeTxd = zfHpGetFreeTxdCount(dev);
+            if (freeTxd >= (zfHpGetMaxTxdCount(dev)*1/4))
             {
-                if ((buf = zfGetVtxq(dev, 2)) != 0)
+                buf = zfGetVtxq(dev, 2);
+                if (buf != 0)
                 {
                     txed = 1;
                     zfTxSendEth(dev, buf, 0, ZM_EXTERNAL_ALLOC_BUF, 0);
@@ -3860,7 +3879,8 @@ void zfPushVtxq(zdev_t* dev)
                 }
                 if (wd->sta.ac0PriorityHigherThanAc2 == 1)
                 {
-                    if ((buf = zfGetVtxq(dev, 0)) != 0)
+                    buf = zfGetVtxq(dev, 0);
+                    if (buf != 0)
                     {
                         txed = 1;
                         zfTxSendEth(dev, buf, 0, ZM_EXTERNAL_ALLOC_BUF, 0);
@@ -3877,9 +3897,11 @@ void zfPushVtxq(zdev_t* dev)
         /* Service VTxQ[0] */
         for (i=0; i<2; i++)
         {
-            if ((freeTxd = zfHpGetFreeTxdCount(dev)) >= (zfHpGetMaxTxdCount(dev)*2/4))
+            freeTxd = zfHpGetFreeTxdCount(dev);
+            if (freeTxd >= (zfHpGetMaxTxdCount(dev)*2/4))
             {
-                if ((buf = zfGetVtxq(dev, 0)) != 0)
+                buf = zfGetVtxq(dev, 0);
+                if (buf != 0)
                 {
                     txed = 1;
                     zfTxSendEth(dev, buf, 0, ZM_EXTERNAL_ALLOC_BUF, 0);
@@ -3894,9 +3916,11 @@ void zfPushVtxq(zdev_t* dev)
         }
 
         /* Service VTxQ[1] */
-        if ((freeTxd = zfHpGetFreeTxdCount(dev)) >= (zfHpGetMaxTxdCount(dev)*3/4))
+        freeTxd = zfHpGetFreeTxdCount(dev);
+        if (freeTxd >= (zfHpGetMaxTxdCount(dev)*3/4))
         {
-            if ((buf = zfGetVtxq(dev, 1)) != 0)
+            buf = zfGetVtxq(dev, 1);
+            if (buf != 0)
             {
                 txed = 1;
                 zfTxSendEth(dev, buf, 0, ZM_EXTERNAL_ALLOC_BUF, 0);
@@ -3983,9 +4007,10 @@ void zf80211FrameSend(zdev_t* dev, zbuf_t* buf, u16_t* header, u16_t snapLen,
     }
     wd->ledStruct.txTraffic++;
 
-    if ((err = zfHpSend(dev, header, headerLen, snap, snapLen,
+    err = zfHpSend(dev, header, headerLen, snap, snapLen,
                         tail, tailLen, buf, offset,
-                        bufType, ac, keyIdx)) != ZM_SUCCESS)
+                        bufType, ac, keyIdx);
+    if (err != ZM_SUCCESS)
     {
         if (bufType == ZM_EXTERNAL_ALLOC_BUF)
         {
diff --git a/drivers/staging/otus/80211core/queue.c b/drivers/staging/otus/80211core/queue.c
index d294831..29be4bd 100644
--- a/drivers/staging/otus/80211core/queue.c
+++ b/drivers/staging/otus/80211core/queue.c
@@ -31,8 +31,9 @@ struct zsQueue* zfQueueCreate(zdev_t* dev, u16_t size)
 {
     struct zsQueue* q;
 
-    if ((q = (struct zsQueue*)zfwMemAllocate(dev, sizeof(struct zsQueue)
-            + (sizeof(struct zsQueueCell)*(size-1)))) != NULL)
+    q = (struct zsQueue*)zfwMemAllocate(dev, sizeof(struct zsQueue)
+            + (sizeof(struct zsQueueCell)*(size-1)));
+    if (q != NULL)
     {
         q->size = size;
         q->sizeMask = size-1;
diff --git a/drivers/staging/otus/80211core/ratectrl.c b/drivers/staging/otus/80211core/ratectrl.c
index a43104c..a1abe2f 100644
--- a/drivers/staging/otus/80211core/ratectrl.c
+++ b/drivers/staging/otus/80211core/ratectrl.c
@@ -538,7 +538,8 @@ u16_t zfRateCtrlGetTxRate(zdev_t* dev, struct zsRcCell* rcCell, u16_t* probing)
             ((rcCell->currentRate <= 16) &&
             ((wd->PER[rcCell->currentRate]/2) <= ZM_RATE_PROBING_THRESHOLD)))
         {
-            if ((newRate=zfRateCtrlGetHigherRate(rcCell)) != rcCell->currentRate)
+            newRate = zfRateCtrlGetHigherRate(rcCell);
+            if (newRate != rcCell->currentRate)
             {
                 *probing = 1;
                 wd->probeCount++;
-- 
1.7.0.14.g7e948

