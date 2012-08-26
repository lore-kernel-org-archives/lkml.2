Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab2HZBEZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 21:04:25 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47130 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab2HZBEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 21:04:24 -0400
MIME-Version: 1.0
Date: Sun, 26 Aug 2012 09:04:23 +0800
Message-ID: <CAPgLHd9O-1TLxZRCUQKL3Bij98Zj9UyTukK91jLs7C6FfeXYmA@mail.gmail.com>
Subject: [PATCH] staging: rtl8192e: use is_broadcast_ether_addr() instead of memcmp()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using is_broadcast_ether_addr() instead of directly use
memcmp() to determine if the ethernet address is broadcast
address.

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)


Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/rtl8192e/rtllib_softmac.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index a21b4d9..ef4ed85 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -19,6 +19,7 @@
 #include <linux/random.h>
 #include <linux/delay.h>
 #include <linux/uaccess.h>
+#include <linux/etherdevice.h>
 #include "dot11d.h"
 
 short rtllib_is_54g(struct rtllib_network *net)
@@ -1843,7 +1844,7 @@ static short probe_rq_parse(struct rtllib_device *ieee, struct sk_buff *skb,
 
 	bssid_match =
 	  (memcmp(header->addr3, ieee->current_network.bssid, ETH_ALEN) != 0) &&
-	  (memcmp(header->addr3, "\xff\xff\xff\xff\xff\xff", ETH_ALEN) != 0);
+	  (!is_broadcast_ether_addr(header->addr3));
 	if (bssid_match)
 		return -1;
 
@@ -3361,9 +3362,7 @@ static int rtllib_wpa_set_encryption(struct rtllib_device *ieee,
 			       param->u.crypt.key_len);
 		return -EINVAL;
 	}
-	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
-	    param->sta_addr[2] == 0xff && param->sta_addr[3] == 0xff &&
-	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
+	if (is_broadcast_ether_addr(param->sta_addr)) {
 		if (param->u.crypt.idx >= NUM_WEP_KEYS)
 			return -EINVAL;
 		crypt = &ieee->crypt_info.crypt[param->u.crypt.idx];

