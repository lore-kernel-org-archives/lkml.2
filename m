Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab0ETObv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 10:31:51 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:48141 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab0ETObu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 10:31:50 -0400
Date: Thu, 20 May 2010 14:31:44 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG in iwl-agn-rs.c:2076, WAS: iwlagn + some
 accesspoint == hardlock
Message-ID: <20100520123144.GA8153@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
References: <20100513150504.GB7535@localhost>
 <1274138381.2091.4864.camel@rchatre-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274138381.2091.4864.camel@rchatre-DESK>
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Reinette,

  Did the fix like the patch below, applied on top of yours. Builds well, 
  not tested yet.

  Do you ACK this patch?

  Thanks,

          Nils


# 1) Error messages like: 
# iwlagn 0000:03:00.0: expected_tpt should have been calculated by now
# To address (1), could you please run with attached debug patch and also
# enable rate scaling debugging. That will be "modprobe iwlagn
# debug=0x143fff).

# diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
# index b93e491..60e5323 100644
# --- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
# +++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
# @@ -361,6 +361,8 @@ static int rs_collect_tx_data(struct iwl_rate_scale_data *windows,
#  	 * subtract "1" from the success counter (this is the main reason
#  	 * we keep these bitmaps!).
#  	 */
# +	IWL_DEBUG_RATE(priv, "attempts = %d, window->counter = %d\n",
# +			attempts, window->counter);
#  	while (attempts > 0) {
#  		if (window->counter >= IWL_RATE_MAX_WINDOW) {
#  
# @@ -389,6 +391,7 @@ static int rs_collect_tx_data(struct iwl_rate_scale_data *windows,
#  		attempts--;
#  	}
#  
# +	IWL_DEBUG_RATE(priv, "window counter = %d \n", window->counter);
#  	/* Calculate current success ratio, avoid divide-by-0! */
#  	if (window->counter > 0)
#  		window->success_ratio = 128 * (100 * window->success_counter)
# @@ -849,6 +852,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
#  	 * first index into rate scale table.
#  	 */
#  	if (info->flags & IEEE80211_TX_STAT_AMPDU) {
# +		IWL_DEBUG_RATE(priv, "Updating aggregation history\n");
#  		tx_rate = le32_to_cpu(table->rs_table[0].rate_n_flags);
#  		rs_get_tbl_info_from_mcs(tx_rate, priv->band, &tbl_type,
#  				&rs_index);
# @@ -868,6 +872,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
#  	 * For legacy, update frame history with for each Tx retry.
#  	 */
#  		retries = info->status.rates[0].count - 1;
# +		IWL_DEBUG_RATE(priv, "Updating legacy history. retries = %d \n", retries);
#  		/* HW doesn't send more than 15 retries */
#  		retries = min(retries, 15);
#  

---

 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.33.3_clean/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
===================================================================
--- linux-2.6.33.3_clean.orig/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2010-05-20 14:25:42.000000000 +0200
+++ linux-2.6.33.3_clean/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2010-05-20 14:26:50.000000000 +0200
@@ -341,7 +341,7 @@
  */
 static int rs_collect_tx_data(struct iwl_rate_scale_data *windows,
 			      int scale_index, s32 tpt, int attempts,
-			      int successes)
+			      int successes, struct iwl_priv *priv)
 {
 	struct iwl_rate_scale_data *window = NULL;
 	static const u64 mask = (((u64)1) << (IWL_RATE_MAX_WINDOW - 1));
@@ -859,7 +859,7 @@
 		tpt = get_expected_tpt(curr_tbl, rs_index);
 		rs_collect_tx_data(window, rs_index, tpt,
 				   info->status.ampdu_ack_len,
-				   info->status.ampdu_ack_map);
+				   info->status.ampdu_ack_map, priv);
 
 		/* Update success/fail counts if not searching for new mode */
 		if (lq_sta->stay_in_tbl) {
@@ -897,10 +897,10 @@
 			/* Constants mean 1 transmission, 0 successes */
 			if (i < retries)
 				rs_collect_tx_data(window, rs_index, tpt, 1,
-						0);
+						0, priv);
 			else
 				rs_collect_tx_data(window, rs_index, tpt, 1,
-						legacy_success);
+						legacy_success, priv);
 		}
 
 		/* Update success/fail counts if not searching for new mode */
