Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1AFA32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:29:28 -0500
Received: from kroah.org ([198.145.64.141]:35580 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030Ab1AFA30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:26 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:00 2011
Message-Id: <20110106002300.227845945@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [038/152] ath9k: Fix STA disconnect issue due to received MIC failed bcast frames
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Senthil Balasubramanian <senthilkumar@atheros.com>

commit 916448e77f6bcaaa7f13c3de0c3851783ae2bfd0 upstream.

AR_RxKeyIdxValid will not be set for bcast/mcast frames and so relying
this status for MIC failed frames is buggy.

Due to this, MIC failure events for broadcast frames are not sent to
supplicant resulted in AP disconnecting the STA.

Able to pass Wifi Test case 5.2.18 with this fix.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/mac.c  |    3 +--
 drivers/net/wireless/ath/ath9k/recv.c |    4 +++-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -711,8 +711,7 @@ int ath9k_hw_rxprocdesc(struct ath_hw *a
 			rs->rs_phyerr = phyerr;
 		} else if (ads.ds_rxstatus8 & AR_DecryptCRCErr)
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
-		else if ((ads.ds_rxstatus8 & AR_MichaelErr) &&
-		         rs->rs_keyix != ATH9K_RXKEYIX_INVALID)
+		else if (ads.ds_rxstatus8 & AR_MichaelErr)
 			rs->rs_status |= ATH9K_RXERR_MIC;
 		else if (ads.ds_rxstatus8 & AR_KeyMiss)
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1035,9 +1035,11 @@ static void ath9k_rx_skb_postprocess(str
 	int hdrlen, padpos, padsize;
 	u8 keyix;
 	__le16 fc;
+	bool is_mc;
 
 	/* see if any padding is done by the hw and remove it */
 	hdr = (struct ieee80211_hdr *) skb->data;
+	is_mc = !!is_multicast_ether_addr(hdr->addr1);
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 	fc = hdr->frame_control;
 	padpos = ath9k_cmn_padpos(hdr->frame_control);
@@ -1058,7 +1060,7 @@ static void ath9k_rx_skb_postprocess(str
 
 	keyix = rx_stats->rs_keyix;
 
-	if (!(keyix == ATH9K_RXKEYIX_INVALID) && !decrypt_error &&
+	if ((is_mc || !(keyix == ATH9K_RXKEYIX_INVALID)) && !decrypt_error &&
 	    ieee80211_has_protected(fc)) {
 		rxs->flag |= RX_FLAG_DECRYPTED;
 	} else if (ieee80211_has_protected(fc)


