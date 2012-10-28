Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab2J1Xgl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:36:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42126 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756904Ab2J1X2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:07 -0400
Message-Id: <20121028231552.773428037@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:27 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [ 051/105] iwlwifi: fix 6000 series channel switch command
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 8f7b8db6e0557c8437adf9371e020cd89a7e85dc upstream.

The channel switch command for 6000 series devices
is larger than the maximum inline command size of
320 bytes. The command is therefore refused with a
warning. Fix this by allocating the command and
using the NOCOPY mechanism.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[bwh: Backported to 3.2: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   39 +++++++++++++++++-----------
 1 file changed, 24 insertions(+), 15 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -193,7 +193,7 @@ static int iwl6000_hw_channel_switch(str
 	 * See iwlagn_mac_channel_switch.
 	 */
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-	struct iwl6000_channel_switch_cmd cmd;
+	struct iwl6000_channel_switch_cmd *cmd;
 	const struct iwl_channel_info *ch_info;
 	u32 switch_time_in_usec, ucode_switch_time;
 	u16 ch;
@@ -203,18 +203,25 @@ static int iwl6000_hw_channel_switch(str
 	struct ieee80211_vif *vif = ctx->vif;
 	struct iwl_host_cmd hcmd = {
 		.id = REPLY_CHANNEL_SWITCH,
-		.len = { sizeof(cmd), },
+		.len = { sizeof(*cmd), },
 		.flags = CMD_SYNC,
-		.data = { &cmd, },
+		.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
 	};
+	int err;
 
-	cmd.band = priv->band == IEEE80211_BAND_2GHZ;
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	hcmd.data[0] = cmd;
+
+	cmd->band = priv->band == IEEE80211_BAND_2GHZ;
 	ch = ch_switch->channel->hw_value;
 	IWL_DEBUG_11H(priv, "channel switch from %u to %u\n",
 		      ctx->active.channel, ch);
-	cmd.channel = cpu_to_le16(ch);
-	cmd.rxon_flags = ctx->staging.flags;
-	cmd.rxon_filter_flags = ctx->staging.filter_flags;
+	cmd->channel = cpu_to_le16(ch);
+	cmd->rxon_flags = ctx->staging.flags;
+	cmd->rxon_filter_flags = ctx->staging.filter_flags;
 	switch_count = ch_switch->count;
 	tsf_low = ch_switch->timestamp & 0x0ffffffff;
 	/*
@@ -230,30 +237,32 @@ static int iwl6000_hw_channel_switch(str
 			switch_count = 0;
 	}
 	if (switch_count <= 1)
-		cmd.switch_time = cpu_to_le32(priv->ucode_beacon_time);
+		cmd->switch_time = cpu_to_le32(priv->ucode_beacon_time);
 	else {
 		switch_time_in_usec =
 			vif->bss_conf.beacon_int * switch_count * TIME_UNIT;
 		ucode_switch_time = iwl_usecs_to_beacons(priv,
 							 switch_time_in_usec,
 							 beacon_interval);
-		cmd.switch_time = iwl_add_beacon_time(priv,
-						      priv->ucode_beacon_time,
-						      ucode_switch_time,
-						      beacon_interval);
+		cmd->switch_time = iwl_add_beacon_time(priv,
+						       priv->ucode_beacon_time,
+						       ucode_switch_time,
+						       beacon_interval);
 	}
 	IWL_DEBUG_11H(priv, "uCode time for the switch is 0x%x\n",
-		      cmd.switch_time);
+		      cmd->switch_time);
 	ch_info = iwl_get_channel_info(priv, priv->band, ch);
 	if (ch_info)
-		cmd.expect_beacon = is_channel_radar(ch_info);
+		cmd->expect_beacon = is_channel_radar(ch_info);
 	else {
 		IWL_ERR(priv, "invalid channel switch from %u to %u\n",
 			ctx->active.channel, ch);
 		return -EFAULT;
 	}
 
-	return iwl_trans_send_cmd(trans(priv), &hcmd);
+	err = iwl_trans_send_cmd(trans(priv), &hcmd);
+	kfree(cmd);
+	return err;
 }
 
 static struct iwl_lib_ops iwl6000_lib = {


