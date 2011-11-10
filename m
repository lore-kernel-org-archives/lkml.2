Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1KJSFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 13:05:17 -0500
Received: from www17.your-server.de ([213.133.104.17]:33758 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab1KJSE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 13:04:26 -0500
Message-ID: <1320948259.20155.19.camel@localhost.localdomain>
Subject: [PATCH] staging: rtl8192e: Use kzalloc rather than kmalloc v2
From: Thomas Meyer <thomas@m3y3r.de>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Larry Finger <Larry.Finger@lwfinger.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Thu, 10 Nov 2011 19:04:19 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzalloc rather than kmalloc followed by memset with 0

This considers some simple cases that are common and easy to validate
Note in particular that there are no ...s in the rule, so all of the
matched code has to be contiguous

The semantic patch that makes this change is available
in scripts/coccinelle/api/alloc/kzalloc-simple.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
--- a/drivers/staging/rtl8192e/rtllib_softmac.c 2011-11-07 19:38:11.780313813 +0100
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c 2011-11-08 09:40:07.649215930 +0100
@@ -3048,10 +3048,9 @@ void rtllib_softmac_init(struct rtllib_d
 	ieee->state = RTLLIB_NOLINK;
 	for (i = 0; i < 5; i++)
 		ieee->seq_ctrl[i] = 0;
-	ieee->pDot11dInfo = kmalloc(sizeof(struct rt_dot11d_info), GFP_ATOMIC);
+	ieee->pDot11dInfo = kzalloc(sizeof(struct rt_dot11d_info), GFP_ATOMIC);
 	if (!ieee->pDot11dInfo)
 		RTLLIB_DEBUG(RTLLIB_DL_ERR, "can't alloc memory for DOT11D\n");
-	memset(ieee->pDot11dInfo, 0, sizeof(struct rt_dot11d_info));
 	ieee->LinkDetectInfo.SlotIndex = 0;
 	ieee->LinkDetectInfo.SlotNum = 2;
 	ieee->LinkDetectInfo.NumRecvBcnInPeriod = 0;
diff -u -p a/drivers/staging/rtl8192e/rtllib_crypt_wep.c b/drivers/staging/rtl8192e/rtllib_crypt_wep.c
--- a/drivers/staging/rtl8192e/rtllib_crypt_wep.c 2011-11-07 19:38:11.773647045 +0100
+++ b/drivers/staging/rtl8192e/rtllib_crypt_wep.c 2011-11-08 09:40:08.842565261 +0100
@@ -38,10 +38,9 @@ static void *prism2_wep_init(int keyidx)
 {
 	struct prism2_wep_data *priv;
 
-	priv = kmalloc(sizeof(*priv), GFP_ATOMIC);
+	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
 	if (priv == NULL)
 		goto fail;
-	memset(priv, 0, sizeof(*priv));
 	priv->key_idx = keyidx;
 
 	priv->tx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
diff -u -p a/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c b/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c
--- a/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c 2011-11-07 19:38:11.773647045 +0100
+++ b/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c 2011-11-08 09:40:09.422573035 +0100
@@ -63,10 +63,9 @@ static void *rtllib_ccmp_init(int key_id
 {
 	struct rtllib_ccmp_data *priv;
 
-	priv = kmalloc(sizeof(*priv), GFP_ATOMIC);
+	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
 	if (priv == NULL)
 		goto fail;
-	memset(priv, 0, sizeof(*priv));
 	priv->key_idx = key_idx;
 
 	priv->tfm = (void *)crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
diff -u -p a/drivers/staging/rtl8192e/rtllib_crypt.c b/drivers/staging/rtl8192e/rtllib_crypt.c
--- a/drivers/staging/rtl8192e/rtllib_crypt.c 2011-11-07 19:38:11.773647045 +0100
+++ b/drivers/staging/rtl8192e/rtllib_crypt.c 2011-11-08 09:40:09.789244618 +0100
@@ -104,11 +104,10 @@ int rtllib_register_crypto_ops(struct rt
 	if (hcrypt == NULL)
 		return -1;
 
-	alg = kmalloc(sizeof(*alg), GFP_KERNEL);
+	alg = kzalloc(sizeof(*alg), GFP_KERNEL);
 	if (alg == NULL)
 		return -ENOMEM;
 
-	memset(alg, 0, sizeof(*alg));
 	alg->ops = ops;
 
 	spin_lock_irqsave(&hcrypt->lock, flags);
@@ -202,11 +201,10 @@ int __init rtllib_crypto_init(void)
 {
 	int ret = -ENOMEM;
 
-	hcrypt = kmalloc(sizeof(*hcrypt), GFP_KERNEL);
+	hcrypt = kzalloc(sizeof(*hcrypt), GFP_KERNEL);
 	if (!hcrypt)
 		goto out;
 
-	memset(hcrypt, 0, sizeof(*hcrypt));
 	INIT_LIST_HEAD(&hcrypt->algs);
 	spin_lock_init(&hcrypt->lock);
 
diff -u -p a/drivers/staging/rtl8192e/rtllib_crypt_tkip.c b/drivers/staging/rtl8192e/rtllib_crypt_tkip.c
--- a/drivers/staging/rtl8192e/rtllib_crypt_tkip.c 2011-11-07 19:38:11.773647045 +0100
+++ b/drivers/staging/rtl8192e/rtllib_crypt_tkip.c 2011-11-08 09:40:13.429293412 +0100
@@ -60,10 +60,9 @@ static void *rtllib_tkip_init(int key_id
 {
 	struct rtllib_tkip_data *priv;
 
-	priv = kmalloc(sizeof(*priv), GFP_ATOMIC);
+	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
 	if (priv == NULL)
 		goto fail;
-	memset(priv, 0, sizeof(*priv));
 	priv->key_idx = key_idx;
 	priv->tx_tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0,
 			CRYPTO_ALG_ASYNC);
diff -u -p a/drivers/staging/rtl8192e/rtllib_wx.c b/drivers/staging/rtl8192e/rtllib_wx.c
--- a/drivers/staging/rtl8192e/rtllib_wx.c 2011-11-07 19:38:11.783647197 +0100
+++ b/drivers/staging/rtl8192e/rtllib_wx.c 2011-11-08 09:40:14.075968748 +0100
@@ -368,11 +368,10 @@ int rtllib_wx_set_encode(struct rtllib_d
 		struct rtllib_crypt_data *new_crypt;
 
 		/* take WEP into use */
-		new_crypt = kmalloc(sizeof(struct rtllib_crypt_data),
+		new_crypt = kzalloc(sizeof(struct rtllib_crypt_data),
 				    GFP_KERNEL);
 		if (new_crypt == NULL)
 			return -ENOMEM;
-		memset(new_crypt, 0, sizeof(struct rtllib_crypt_data));
 		new_crypt->ops = rtllib_get_crypto_ops("WEP");
 		if (!new_crypt->ops) {
 			request_module("rtllib_crypt_wep");


