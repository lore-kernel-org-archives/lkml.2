Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab2AXCog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:44:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756769Ab2AXCoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:44:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:28 2012
Message-Id: <20120124023928.261553652@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Gary Morain <gmorain@google.com>,
        Paul Stewart <pstew@google.com>,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [049/129] ath9k: Fix regression in channelwidth switch at the same channel
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 2247
Lines: 59

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

commit 1a19f77f3642b8194ad9cf55548cc5d92e841766 upstream.

The commit "ath9k: Fix invalid noisefloor reading due to channel update"
preserves the current channel noisefloor readings before updating
channel type at the same channel index. It is also updating the curchan
pointer. As survey updation is also referring curchan pointer to fetch
the appropriate index, which might leads to invalid memory access. This
patch partially reverts the change and stores the noise floor history
buffer before updating channel type w/o updating curchan.

Cc: Gary Morain <gmorain@google.com>
Cc: Paul Stewart <pstew@google.com>
Reported-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/calib.c |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |    8 ++------
 2 files changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -402,6 +402,7 @@ bool ath9k_hw_getnf(struct ath_hw *ah, s
 	ah->noise = ath9k_hw_getchan_noise(ah, chan);
 	return true;
 }
+EXPORT_SYMBOL(ath9k_hw_getnf);
 
 void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah,
 				  struct ath9k_channel *chan)
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1667,7 +1667,6 @@ static int ath9k_config(struct ieee80211
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		struct ieee80211_channel *curchan = hw->conf.channel;
-		struct ath9k_channel old_chan;
 		int pos = curchan->hw_value;
 		int old_pos = -1;
 		unsigned long flags;
@@ -1693,11 +1692,8 @@ static int ath9k_config(struct ieee80211
 		 * Preserve the current channel values, before updating
 		 * the same channel
 		 */
-		if (old_pos == pos) {
-			memcpy(&old_chan, &sc->sc_ah->channels[pos],
-				sizeof(struct ath9k_channel));
-			ah->curchan = &old_chan;
-		}
+		if (ah->curchan && (old_pos == pos))
+			ath9k_hw_getnf(ah, ah->curchan);
 
 		ath9k_cmn_update_ichannel(&sc->sc_ah->channels[pos],
 					  curchan, conf->channel_type);


