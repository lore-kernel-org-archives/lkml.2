Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161658Ab2GLWjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:39:24 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34975 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161628Ab2GLWjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:39:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        =?UTF-8?q?Thomas=20H=C3=BChn?= <thomas@net.t-labs.tu-berlin.de>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: =?y?q?=5B=20063/187=5D=20ath9k=3A=20fix=20invalid=20pointer=20access=20in=20the=20tx=20path?=
Date: Thu, 12 Jul 2012 15:33:39 -0700
Message-Id: <20120712191528.239527436@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 80b08a8d8829a58b5db14b1417151094cc28face upstream.

After setup_frame_info has been called, only info->control.rates is still
valid, other control fields have been overwritten by the ath_frame_info
data. Move the access to info->control.vif for checking short preamble
to setup_frame_info before it gets overwritten.

This regression was introduced in commit d47a61aa
"ath9k: Fix multi-VIF BSS handling"

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Thomas Hühn <thomas@net.t-labs.tu-berlin.de>
Acked-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/xmit.c  |   29 +++++++++++++++++------------
 2 files changed, 18 insertions(+), 12 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -213,6 +213,7 @@ struct ath_frame_info {
 	enum ath9k_key_type keytype;
 	u8 keyix;
 	u8 retries;
+	u8 rtscts_rate;
 };
 
 struct ath_buf_state {
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -938,6 +938,7 @@ static void ath_buf_set_rate(struct ath_
 	struct ieee80211_tx_rate *rates;
 	const struct ieee80211_rate *rate;
 	struct ieee80211_hdr *hdr;
+	struct ath_frame_info *fi = get_frame_info(bf->bf_mpdu);
 	int i;
 	u8 rix = 0;
 
@@ -948,18 +949,7 @@ static void ath_buf_set_rate(struct ath_
 
 	/* set dur_update_en for l-sig computation except for PS-Poll frames */
 	info->dur_update = !ieee80211_is_pspoll(hdr->frame_control);
-
-	/*
-	 * We check if Short Preamble is needed for the CTS rate by
-	 * checking the BSS's global flag.
-	 * But for the rate series, IEEE80211_TX_RC_USE_SHORT_PREAMBLE is used.
-	 */
-	rate = ieee80211_get_rts_cts_rate(sc->hw, tx_info);
-	info->rtscts_rate = rate->hw_value;
-
-	if (tx_info->control.vif &&
-	    tx_info->control.vif->bss_conf.use_short_preamble)
-		info->rtscts_rate |= rate->hw_value_short;
+	info->rtscts_rate = fi->rtscts_rate;
 
 	for (i = 0; i < 4; i++) {
 		bool is_40, is_sgi, is_sp;
@@ -1776,10 +1766,22 @@ static void setup_frame_info(struct ieee
 	struct ieee80211_sta *sta = tx_info->control.sta;
 	struct ieee80211_key_conf *hw_key = tx_info->control.hw_key;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	const struct ieee80211_rate *rate;
 	struct ath_frame_info *fi = get_frame_info(skb);
 	struct ath_node *an = NULL;
 	enum ath9k_key_type keytype;
+	bool short_preamble = false;
+
+	/*
+	 * We check if Short Preamble is needed for the CTS rate by
+	 * checking the BSS's global flag.
+	 * But for the rate series, IEEE80211_TX_RC_USE_SHORT_PREAMBLE is used.
+	 */
+	if (tx_info->control.vif &&
+	    tx_info->control.vif->bss_conf.use_short_preamble)
+		short_preamble = true;
 
+	rate = ieee80211_get_rts_cts_rate(hw, tx_info);
 	keytype = ath9k_cmn_get_hw_crypto_keytype(skb);
 
 	if (sta)
@@ -1794,6 +1796,9 @@ static void setup_frame_info(struct ieee
 		fi->keyix = ATH9K_TXKEYIX_INVALID;
 	fi->keytype = keytype;
 	fi->framelen = framelen;
+	fi->rtscts_rate = rate->hw_value;
+	if (short_preamble)
+		fi->rtscts_rate |= rate->hw_value_short;
 }
 
 u8 ath_txchainmask_reduction(struct ath_softc *sc, u8 chainmask, u32 rate)


