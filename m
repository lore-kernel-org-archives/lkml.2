Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab2ILXk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:40:27 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58620 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab2ILXkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:40:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 45/85] ath9k: fix decrypt_error initialization in ath_rx_tasklet()
Date: Wed, 12 Sep 2012 16:36:28 -0700
Message-Id: <20120912233546.474974380@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>

commit e1352fde5682ab1bdd2a9e5d75c22d1fe210ef77 upstream.

ath_rx_tasklet() calls ath9k_rx_skb_preprocess() and ath9k_rx_skb_postprocess()
in a loop over the received frames. The decrypt_error flag is
initialized to false
just outside ath_rx_tasklet() loop. ath9k_rx_accept(), called by
ath9k_rx_skb_preprocess(),
only sets decrypt_error to true and never to false.
Then ath_rx_tasklet() calls ath9k_rx_skb_postprocess() and passes
decrypt_error to it.
So, after a decryption error, in ath9k_rx_skb_postprocess(), we can
have a leftover value
from another processed frame. In that case, the frame will not be marked with
RX_FLAG_DECRYPTED even if it is decrypted correctly.
When using CCMP encryption this issue can lead to connection stuck
because of CCMP
PN corruption and a waste of CPU time since mac80211 tries to decrypt an already
deciphered frame with ieee80211_aes_ccm_decrypt.
Fix the issue initializing decrypt_error flag at the begging of the
ath_rx_tasklet() loop.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/recv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1774,7 +1774,6 @@ int ath_rx_tasklet(struct ath_softc *sc,
 	struct ieee80211_hw *hw = sc->hw;
 	struct ieee80211_hdr *hdr;
 	int retval;
-	bool decrypt_error = false;
 	struct ath_rx_status rs;
 	enum ath9k_rx_qtype qtype;
 	bool edma = !!(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA);
@@ -1796,6 +1795,7 @@ int ath_rx_tasklet(struct ath_softc *sc,
 	tsf_lower = tsf & 0xffffffff;
 
 	do {
+		bool decrypt_error = false;
 		/* If handling rx interrupt and flush is in progress => exit */
 		if ((sc->sc_flags & SC_OP_RXFLUSH) && (flush == 0))
 			break;


