Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab2GIOiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:38:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38084 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754081Ab2GIOh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:37:56 -0400
Message-Id: <20120709143117.523948559@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:22 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Felix Fietkau <nbd@openwrt.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 06/48] ath9k: fix dynamic WEP related regression
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit bed3d9c0b71f9afbfec905cb6db3b9f16be29d4d upstream.

commit 7a532fe7131216a02c81a6c1b1f8632da1195a58
ath9k_hw: fix interpretation of the rx KeyMiss flag

This commit used the rx key miss indication to detect packets that were
passed from the hardware without being decrypted, however it seems that
this bit is not only undefined in the static WEP case, but also for
dynamically allocated WEP keys. This caused a regression when using
WEP-LEAP.

This patch fixes the regression by keeping track of which key indexes
refer to CCMP keys and only using the key miss indication for those.

Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath.h        |    1 +
 drivers/net/wireless/ath/ath9k/recv.c |    3 ++-
 drivers/net/wireless/ath/key.c        |    4 ++++
 3 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -143,6 +143,7 @@ struct ath_common {
 	u32 keymax;
 	DECLARE_BITMAP(keymap, ATH_KEYMAX);
 	DECLARE_BITMAP(tkip_keymap, ATH_KEYMAX);
+	DECLARE_BITMAP(ccmp_keymap, ATH_KEYMAX);
 	enum ath_crypt_caps crypt_caps;
 
 	unsigned int clockrate;
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -829,7 +829,8 @@ static bool ath9k_rx_accept(struct ath_c
 	 * descriptor does contain a valid key index. This has been observed
 	 * mostly with CCMP encryption.
 	 */
-	if (rx_stats->rs_keyix == ATH9K_RXKEYIX_INVALID)
+	if (rx_stats->rs_keyix == ATH9K_RXKEYIX_INVALID ||
+	    !test_bit(rx_stats->rs_keyix, common->ccmp_keymap))
 		rx_stats->rs_status &= ~ATH9K_RXERR_KEYMISS;
 
 	if (!rx_stats->rs_datalen)
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -556,6 +556,9 @@ int ath_key_config(struct ath_common *co
 		return -EIO;
 
 	set_bit(idx, common->keymap);
+	if (key->cipher == WLAN_CIPHER_SUITE_CCMP)
+		set_bit(idx, common->ccmp_keymap);
+
 	if (key->cipher == WLAN_CIPHER_SUITE_TKIP) {
 		set_bit(idx + 64, common->keymap);
 		set_bit(idx, common->tkip_keymap);
@@ -582,6 +585,7 @@ void ath_key_delete(struct ath_common *c
 		return;
 
 	clear_bit(key->hw_key_idx, common->keymap);
+	clear_bit(key->hw_key_idx, common->ccmp_keymap);
 	if (key->cipher != WLAN_CIPHER_SUITE_TKIP)
 		return;
 


