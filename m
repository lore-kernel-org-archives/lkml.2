Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab2HZBWf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 21:22:35 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:48950 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab2HZBWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 21:22:34 -0400
MIME-Version: 1.0
Date: Sun, 26 Aug 2012 09:22:33 +0800
Message-ID: <CAPgLHd9raeBjQ0utQZ1u5P=55RMC2gMu-2hPxk3P4m83SMnTOw@mail.gmail.com>
Subject: [PATCH] staging: r8712u: use is_broadcast_ether_addr() to simplify
 the code
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

Using is_broadcast_ether_addr() to simplify the code.

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)


Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/rtl8712/ethernet.h            | 8 --------
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c | 4 +---
 drivers/staging/rtl8712/rtl871x_ioctl_set.c   | 6 ++----
 3 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/rtl8712/ethernet.h b/drivers/staging/rtl8712/ethernet.h
index 882d61b..9095420 100644
--- a/drivers/staging/rtl8712/ethernet.h
+++ b/drivers/staging/rtl8712/ethernet.h
@@ -35,14 +35,6 @@
 
 /*!< Is Multicast Address? */
 #define RT_ETH_IS_MULTICAST(_pAddr)	((((u8 *)(_pAddr))[0]&0x01) != 0)
-/*!< Is Broadcast Address? */
-#define RT_ETH_IS_BROADCAST(_pAddr)	(				\
-			((u8 *)(_pAddr))[0] == 0xff	&&		\
-			((u8 *)(_pAddr))[1] == 0xff	&&		\
-			((u8 *)(_pAddr))[2] == 0xff	&&		\
-			((u8 *)(_pAddr))[3] == 0xff	&&		\
-			((u8 *)(_pAddr))[4] == 0xff	&&		\
-			((u8 *)(_pAddr))[5] == 0xff)
 
 #endif /* #ifndef __INC_ETHERNET_H */
 

diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index 35e781f..c9a6a7f 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -407,9 +407,7 @@ static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param,
 	if (param_len != (u32)((u8 *) param->u.crypt.key - (u8 *)param) +
 			 param->u.crypt.key_len)
 		return -EINVAL;
-	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
-	    param->sta_addr[2] == 0xff && param->sta_addr[3] == 0xff &&
-	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
+	if (is_broadcast_ether_addr(param->sta_addr)) {
 		if (param->u.crypt.idx >= WEP_KEYS) {
 			/* for large key indices, set the default (0) */
 			param->u.crypt.idx = 0;

diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_set.c b/drivers/staging/rtl8712/rtl871x_ioctl_set.c
index f352b32..5ab70ab 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_set.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_set.c
@@ -131,10 +131,7 @@ u8 r8712_set_802_11_bssid(struct _adapter *padapter, u8 *bssid)
 	u8 status = true;
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 
-	if ((bssid[0] == 0x00 && bssid[1] == 0x00 && bssid[2] == 0x00 &&
-	     bssid[3] == 0x00 && bssid[4] == 0x00 && bssid[5] == 0x00) ||
-	    (bssid[0] == 0xFF && bssid[1] == 0xFF && bssid[2] == 0xFF &&
-	     bssid[3] == 0xFF && bssid[4] == 0xFF && bssid[5] == 0xFF)) {
+	if (is_zero_ether_addr(bssid) || is_broadcast_ether_addr(bssid)) {
 		status = false;
 		return status;
 	}


