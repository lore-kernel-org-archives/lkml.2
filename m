Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab1FPHLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:11:13 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:60529 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756615Ab1FPHLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:11:03 -0400
X-Sasl-enc: RzF+1yP0f2MA5uI8nnHcrE7oECfKtJG/bRtlrkICZkow 1308208262
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:09 2011
Message-Id: <20110616002909.524496984@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:28:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanoharan@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [57/85] ath9k: set 40 Mhz rate only if hw is configured in ht40
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Rajkumar Manoharan <rmanoharan@atheros.com>

commit 41e2b05b9598d6bdf91fc20280bfc538d853f769 upstream.

Whenever there is a channel width change from 40 Mhz to 20 Mhz,
the hardware is reconfigured to ht20. Meantime before doing
the rate control updation, the packets are being transmitted are
selected rate with IEEE80211_TX_RC_40_MHZ_WIDTH.

While transmitting ht40 rate packets in ht20 mode is causing
baseband panic with AR9003 based chips.

==== BB update: BB status=0x02001109 ====
ath: ** BB state: wd=1 det=1 rdar=0 rOFDM=1 rCCK=1 tOFDM=0 tCCK=0 agc=2
src=0 **
ath: ** BB WD cntl: cntl1=0xffff0085 cntl2=0x00000004 **
ath: ** BB mode: BB_gen_controls=0x000033c0 **
ath: ** BB busy times: rx_clear=99%, rx_frame=0%, tx_frame=0% **
ath: ==== BB update: done ====

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/rc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -614,7 +614,8 @@ static void ath_rc_rate_set_series(const
 
 	if (WLAN_RC_PHY_HT(rate_table->info[rix].phy)) {
 		rate->flags |= IEEE80211_TX_RC_MCS;
-		if (WLAN_RC_PHY_40(rate_table->info[rix].phy))
+		if (WLAN_RC_PHY_40(rate_table->info[rix].phy) &&
+		    conf_is_ht40(&txrc->hw->conf))
 			rate->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
 		if (WLAN_RC_PHY_SGI(rate_table->info[rix].phy))
 			rate->flags |= IEEE80211_TX_RC_SHORT_GI;


