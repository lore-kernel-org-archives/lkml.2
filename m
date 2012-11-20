Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab2KTMM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:12:58 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55427 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2KTMM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:12:57 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 11/16] staging/rtl8187se: Use pr_ printks in ieee80211/ieee80211_crypt_ccmp.c
Date: Tue, 20 Nov 2012 21:12:52 +0900
Message-Id: <1353413572-24786-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353413395-24444-1-git-send-email-yamanetoshi@gmail.com>
References: <1353413395-24444-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings fixed.
- WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...

and add pr_fmt.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 .../rtl8187se/ieee80211/ieee80211_crypt_ccmp.c     |   26 +++++++++-----------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
index 5465b09..40217b7 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
@@ -9,6 +9,8 @@
  * more details.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 //#include <linux/config.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -75,8 +77,7 @@ static void *ieee80211_ccmp_init(int key_idx)
 
 	priv->tfm = (void *)crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->tfm)) {
-		printk(KERN_DEBUG "ieee80211_crypt_ccmp: could not allocate "
-		       "crypto API aes\n");
+		pr_debug("could not allocate crypto API aes\n");
 		priv->tfm = NULL;
 		goto fail;
 	}
@@ -282,23 +283,22 @@ static int ieee80211_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	keyidx = pos[3];
 	if (!(keyidx & (1 << 5))) {
 		if (net_ratelimit()) {
-			printk(KERN_DEBUG "CCMP: received packet without ExtIV"
-			       " flag from %pM\n", hdr->addr2);
+			pr_debug("received packet without ExtIV flag from %pM\n",
+				 hdr->addr2);
 		}
 		key->dot11RSNAStatsCCMPFormatErrors++;
 		return -2;
 	}
 	keyidx >>= 6;
 	if (key->key_idx != keyidx) {
-		printk(KERN_DEBUG "CCMP: RX tkey->key_idx=%d frame "
-		       "keyidx=%d priv=%p\n", key->key_idx, keyidx, priv);
+		pr_debug("RX tkey->key_idx=%d frame keyidx=%d priv=%p\n",
+			 key->key_idx, keyidx, priv);
 		return -6;
 	}
 	if (!key->key_set) {
 		if (net_ratelimit()) {
-			printk(KERN_DEBUG "CCMP: received packet from %pM"
-			       " with keyid=%d that does not have a configured"
-			       " key\n", hdr->addr2, keyidx);
+			pr_debug("received packet from %pM with keyid=%d that does not have a configured key\n",
+				 hdr->addr2, keyidx);
 		}
 		return -3;
 	}
@@ -313,9 +313,8 @@ static int ieee80211_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 
 	if (memcmp(pn, key->rx_pn, CCMP_PN_LEN) <= 0) {
 		if (net_ratelimit()) {
-			printk(KERN_DEBUG "CCMP: replay detected: STA=%pM"
-			       " previous PN %pm received PN %pm\n",
-			       hdr->addr2, key->rx_pn, pn);
+			pr_debug("replay detected: STA=%pM previous PN %pm received PN %pm\n",
+				 hdr->addr2, key->rx_pn, pn);
 		}
 		key->dot11RSNAStatsCCMPReplays++;
 		return -4;
@@ -342,8 +341,7 @@ static int ieee80211_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 
 	if (memcmp(mic, a, CCMP_MIC_LEN) != 0) {
 		if (net_ratelimit()) {
-			printk(KERN_DEBUG "CCMP: decrypt failed: STA="
-			       "%pM\n", hdr->addr2);
+			pr_debug("decrypt failed: STA=%pM\n", hdr->addr2);
 		}
 		key->dot11RSNAStatsCCMPDecryptErrors++;
 		return -5;
-- 
1.7.9.5

