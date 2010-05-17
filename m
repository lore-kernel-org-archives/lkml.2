Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab0EQXTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:19:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:46421 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab0EQXTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:19:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,250,1272870000"; 
   d="scan'208";a="568031819"
Subject: Re: kernel BUG in iwl-agn-rs.c:2076, WAS: iwlagn + some
 accesspoint == hardlock
From: reinette chatre <reinette.chatre@intel.com>
To: Nils Radtke <lkml@Think-Future.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100513150504.GB7535@localhost>
References: <20100513150504.GB7535@localhost>
Content-Type: multipart/mixed; boundary="=-Gtf1BeqoyfEeDwPw/I8S"
Date: Mon, 17 May 2010 16:19:41 -0700
Message-ID: <1274138381.2091.4864.camel@rchatre-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Gtf1BeqoyfEeDwPw/I8S
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi Nils,

On Thu, 2010-05-13 at 08:05 -0700, Nils Radtke wrote:
> Attached the output from the debug-enabled in-tree iwlwifi driver connects.

To keep track, this is 2.6.33.3.

> 
> The order of trial is: site A first, then site B. The sites have thus been visited 
> in the same order as last time and the commands executed have been equally the
> same. The failures evenly.. All the log entries that caught my eye last time
> can be found in the attached one also. I'm sending it bz2 compressed. My uplink
> is a poor man's volume limited UMTS one.

Thank you very much.

So from what I can tell (to summarize your previous emails) there are
three issues:

1) Error messages like: 
iwlagn 0000:03:00.0: expected_tpt should have been calculated by now

2) Frequent deaths with code like:
eth1: deauthenticated from 00:40:96:aa:aa:aa (Reason: 2)

3) Error as follows:
[ 4148.141064] iwlagn 0000:03:00.0: TX Power requested while scanning!
[ 4148.141070] iwlagn 0000:03:00.0: Error sending TX power (-11)


To address (1), could you please run with attached debug patch and also
enable rate scaling debugging. That will be "modprobe iwlagn
debug=0x143fff).

Regarding (2): This is a common issue in busy environments where AP
decides to deathenticate station after it does not receive an ack for
data sent after a few retries. Was this test done in busy environment?

Regarding (3): Seems like driver is getting a request to scan after a
request to remove interface. I am still inquiring about this.

Reinette


--=-Gtf1BeqoyfEeDwPw/I8S
Content-Disposition: attachment; filename="debug.patch"
Content-Type: text/x-patch; name="debug.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index b93e491..60e5323 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -361,6 +361,8 @@ static int rs_collect_tx_data(struct iwl_rate_scale_data *windows,
 	 * subtract "1" from the success counter (this is the main reason
 	 * we keep these bitmaps!).
 	 */
+	IWL_DEBUG_RATE(priv, "attempts = %d, window->counter = %d\n",
+			attempts, window->counter);
 	while (attempts > 0) {
 		if (window->counter >= IWL_RATE_MAX_WINDOW) {
 
@@ -389,6 +391,7 @@ static int rs_collect_tx_data(struct iwl_rate_scale_data *windows,
 		attempts--;
 	}
 
+	IWL_DEBUG_RATE(priv, "window counter = %d \n", window->counter);
 	/* Calculate current success ratio, avoid divide-by-0! */
 	if (window->counter > 0)
 		window->success_ratio = 128 * (100 * window->success_counter)
@@ -849,6 +852,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	 * first index into rate scale table.
 	 */
 	if (info->flags & IEEE80211_TX_STAT_AMPDU) {
+		IWL_DEBUG_RATE(priv, "Updating aggregation history\n");
 		tx_rate = le32_to_cpu(table->rs_table[0].rate_n_flags);
 		rs_get_tbl_info_from_mcs(tx_rate, priv->band, &tbl_type,
 				&rs_index);
@@ -868,6 +872,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	 * For legacy, update frame history with for each Tx retry.
 	 */
 		retries = info->status.rates[0].count - 1;
+		IWL_DEBUG_RATE(priv, "Updating legacy history. retries = %d \n", retries);
 		/* HW doesn't send more than 15 retries */
 		retries = min(retries, 15);
 

--=-Gtf1BeqoyfEeDwPw/I8S--

