Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab2HWGkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 02:40:33 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51343 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799Ab2HWGk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 02:40:29 -0400
MIME-Version: 1.0
Date: Thu, 23 Aug 2012 14:40:28 +0800
Message-ID: <CAPgLHd86=bmD30y6h0UT5ZM7mBgg6BNv2KNdvq5sHOqrO1dnsw@mail.gmail.com>
Subject: [PATCH] staging: r8712u: use is_zero_ether_addr() instead of memcmp()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using is_zero_ether_addr() instead of directly use
memcmp(addr, "\x00\x00\x00\x00\x00\x00", ETH_ALEN)
to determine if the ethernet address is all zeros.

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/rtl8712/rtl871x_recv.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_recv.c b/drivers/staging/rtl8712/rtl871x_recv.c
index c9d1743..23ec684 100644
--- a/drivers/staging/rtl8712/rtl871x_recv.c
+++ b/drivers/staging/rtl8712/rtl871x_recv.c
@@ -32,6 +32,7 @@
 #include <linux/slab.h>
 #include <linux/if_ether.h>
 #include <linux/kmemleak.h>
+#include <linux/etherdevice.h>
 
 #include "osdep_service.h"
 #include "drv_types.h"
@@ -331,8 +332,8 @@ static sint sta2sta_data_frame(struct _adapter *adapter,
 			return _FAIL;
 		if ((memcmp(myhwaddr, pattrib->dst, ETH_ALEN)) && (!bmcast))
 			return _FAIL;
-		if (!memcmp(pattrib->bssid, "\x0\x0\x0\x0\x0\x0", ETH_ALEN) ||
-		    !memcmp(mybssid, "\x0\x0\x0\x0\x0\x0", ETH_ALEN) ||
+		if (is_zero_ether_addr(pattrib->bssid) ||
+		    is_zero_ether_addr(mybssid) ||
 		    (memcmp(pattrib->bssid, mybssid, ETH_ALEN)))
 			return _FAIL;
 		sta_addr = pattrib->src;
@@ -409,8 +410,8 @@ static sint ap2sta_data_frame(struct _adapter *adapter,
 		if ((memcmp(myhwaddr, pattrib->dst, ETH_ALEN)) && (!bmcast))
 			return _FAIL;
 		/* check BSSID */
-		if (!memcmp(pattrib->bssid, "\x0\x0\x0\x0\x0\x0", ETH_ALEN) ||
-		     !memcmp(mybssid, "\x0\x0\x0\x0\x0\x0", ETH_ALEN) ||
+		if (is_zero_ether_addr(pattrib->bssid) ||
+		     is_zero_ether_addr(mybssid) ||
 		     (memcmp(pattrib->bssid, mybssid, ETH_ALEN)))
 			return _FAIL;
 		if (bmcast)

