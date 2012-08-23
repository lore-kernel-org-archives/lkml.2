Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589Ab2HWHTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 03:19:08 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57089 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab2HWHTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 03:19:00 -0400
MIME-Version: 1.0
Date: Thu, 23 Aug 2012 15:19:00 +0800
Message-ID: <CAPgLHd-VLPp-tpF77tTc9aj8-VO30jy2yhsi7KyW_NFQOqNqag@mail.gmail.com>
Subject: [PATCH] staging: rtl8192e: use is_zero_ether_addr() instead of memcmp()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using is_zero_ether_addr() instead of directly use
memcmp() to determine if the ethernet address is all
zeros.

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/rtl8192e/rtllib_softmac_wx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib_softmac_wx.c b/drivers/staging/rtl8192e/rtllib_softmac_wx.c
index 1bb6b52..3cedfd9 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac_wx.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac_wx.c
@@ -14,6 +14,8 @@
  */
 
 
+#include <linux/etherdevice.h>
+
 #include "rtllib.h"
 #include "dot11d.h"
 /* FIXME: add A freqs */
@@ -137,7 +139,6 @@ int rtllib_wx_set_wap(struct rtllib_device *ieee,
 {
 
 	int ret = 0;
-	u8 zero[] = {0, 0, 0, 0, 0, 0};
 	unsigned long flags;
 
 	short ifup = ieee->proto_started;
@@ -157,7 +158,7 @@ int rtllib_wx_set_wap(struct rtllib_device *ieee,
 		goto out;
 	}
 
-	if (memcmp(temp->sa_data, zero, ETH_ALEN) == 0) {
+	if (is_zero_ether_addr(temp->sa_data)) {
 		spin_lock_irqsave(&ieee->lock, flags);
 		memcpy(ieee->current_network.bssid, temp->sa_data, ETH_ALEN);
 		ieee->wap_set = 0;
@@ -177,7 +178,7 @@ int rtllib_wx_set_wap(struct rtllib_device *ieee,
 
 	ieee->cannot_notify = false;
 	memcpy(ieee->current_network.bssid, temp->sa_data, ETH_ALEN);
-	ieee->wap_set = (memcmp(temp->sa_data, zero, ETH_ALEN) != 0);
+	ieee->wap_set = (!is_zero_ether_addr(temp->sa_data));
 
 	spin_unlock_irqrestore(&ieee->lock, flags);
 


