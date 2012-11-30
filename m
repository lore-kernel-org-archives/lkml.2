Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485Ab2K3TBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:01:25 -0500
Received: from mail.kernel.org ([198.145.19.201]:58704 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757820Ab2K3S4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 56/56] iwlwifi: fix 6000 series channel switch command
Date: Fri, 30 Nov 2012 10:55:48 -0800
Message-Id: <20121130185124.048181118@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   33 ++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -170,7 +170,7 @@ static int iwl6000_hw_channel_switch(str
 	 * See iwlagn_mac_channel_switch.
 	 */
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-	struct iwl6000_channel_switch_cmd cmd;
+	struct iwl6000_channel_switch_cmd *cmd;
 	const struct iwl_channel_info *ch_info;
 	u32 switch_time_in_usec, ucode_switch_time;
 	u16 ch;
@@ -180,18 +180,25 @@ static int iwl6000_hw_channel_switch(str
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
@@ -207,30 +214,32 @@ static int iwl6000_hw_channel_switch(str
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
+		cmd->switch_time = iwl_add_beacon_time(priv,
 						      priv->ucode_beacon_time,
 						      ucode_switch_time,
 						      beacon_interval);
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
 
-	return iwl_dvm_send_cmd(priv, &hcmd);
+	err = iwl_dvm_send_cmd(priv, &hcmd);
+	kfree(cmd);
+	return err;
 }
 
 static struct iwl_lib_ops iwl6000_lib = {


