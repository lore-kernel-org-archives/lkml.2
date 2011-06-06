Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab1FFTQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:16:24 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37239 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768Ab1FFTQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:16:20 -0400
Date: Mon, 6 Jun 2011 15:04:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: wireless-2.6 2011-06-06
Message-ID: <20110606190427.GH2604@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

Here are a few more fixes intended for 3.0 -- a libertas fix for a
regression related to spurious interrupts, an ath5k fix to disable
"fast" channel switching (since it caused a number of devices to
regress in performance), an ssb fix for a regression that was applying
PCIe workarounds to PCI devices (causing a machine check), an fix for an
iwlagn locking regression, and a mac80211 fix for a device-naming
regression.

Please let me know if there are problems!

Thanks,

John

---

The following changes since commit 5fb9fb132c5a83010cd8d4bf6d0ee34fb3b9d488:

  net: fix smc91x.c device tree support (2011-06-05 17:02:51 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git for-davem

Daniel Drake (1):
      libertas_sdio: handle spurious interrupts

John W. Linville (1):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6 into for-davem

Nick Kossifidis (1):
      ath5k: Disable fast channel switching by default

Rafał Miłecki (1):
      ssb: fix PCI(e) driver regression causing oops on PCI cards

Stanislaw Gruszka (1):
      iwlagn: fix channel switch locking

Thadeu Lima de Souza Cascardo (1):
      mac80211: call dev_alloc_name before copying name to sdata

 drivers/net/wireless/ath/ath5k/base.c       |   11 ++++-
 drivers/net/wireless/ath/ath5k/reset.c      |    5 ++-
 drivers/net/wireless/iwlwifi/iwl-2000.c     |   74 ---------------------------
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 -
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    2 -
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   19 ++++---
 drivers/net/wireless/iwlwifi/iwl-core.c     |    6 +--
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   13 +----
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   24 ++++----
 drivers/net/wireless/libertas/if_sdio.c     |   21 ++++++--
 drivers/ssb/driver_pcicore.c                |   10 ++--
 net/mac80211/iface.c                        |    4 ++
 14 files changed, 68 insertions(+), 130 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 2204762..b6c5d37 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -72,6 +72,11 @@ static int modparam_all_channels;
 module_param_named(all_channels, modparam_all_channels, bool, S_IRUGO);
 MODULE_PARM_DESC(all_channels, "Expose all channels the device can use.");
 
+static int modparam_fastchanswitch;
+module_param_named(fastchanswitch, modparam_fastchanswitch, bool, S_IRUGO);
+MODULE_PARM_DESC(fastchanswitch, "Enable fast channel switching for AR2413/AR5413 radios.");
+
+
 /* Module info */
 MODULE_AUTHOR("Jiri Slaby");
 MODULE_AUTHOR("Nick Kossifidis");
@@ -2686,6 +2691,7 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
 	struct ath5k_hw *ah = sc->ah;
 	struct ath_common *common = ath5k_hw_common(ah);
 	int ret, ani_mode;
+	bool fast;
 
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "resetting\n");
 
@@ -2705,7 +2711,10 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
 	ath5k_drain_tx_buffs(sc);
 	if (chan)
 		sc->curchan = chan;
-	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, chan != NULL,
+
+	fast = ((chan != NULL) && modparam_fastchanswitch) ? 1 : 0;
+
+	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, fast,
 								skip_pcu);
 	if (ret) {
 		ATH5K_ERR(sc, "can't reset hardware (%d)\n", ret);
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 3510de2..126a4ea 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -1124,8 +1124,11 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 			/* Non fatal, can happen eg.
 			 * on mode change */
 			ret = 0;
-		} else
+		} else {
+			ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_RESET,
+				"fast chan change successful\n");
 			return 0;
+		}
 	}
 
 	/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 86feec8..2282279 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -177,79 +177,6 @@ static int iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 	return 0;
 }
 
-static int iwl2030_hw_channel_switch(struct iwl_priv *priv,
-                                    struct ieee80211_channel_switch *ch_switch)
-{
-	/*
-	 * MULTI-FIXME
-	 * See iwl_mac_channel_switch.
-	 */
-	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-	struct iwl6000_channel_switch_cmd cmd;
-	const struct iwl_channel_info *ch_info;
-	u32 switch_time_in_usec, ucode_switch_time;
-	u16 ch;
-	u32 tsf_low;
-	u8 switch_count;
-	u16 beacon_interval = le16_to_cpu(ctx->timing.beacon_interval);
-	struct ieee80211_vif *vif = ctx->vif;
-	struct iwl_host_cmd hcmd = {
-		.id = REPLY_CHANNEL_SWITCH,
-		.len = { sizeof(cmd), },
-		.flags = CMD_SYNC,
-		.data = { &cmd, },
-	};
-
-	cmd.band = priv->band == IEEE80211_BAND_2GHZ;
-	ch = ch_switch->channel->hw_value;
-	IWL_DEBUG_11H(priv, "channel switch from %u to %u\n",
-		ctx->active.channel, ch);
-	cmd.channel = cpu_to_le16(ch);
-	cmd.rxon_flags = ctx->staging.flags;
-	cmd.rxon_filter_flags = ctx->staging.filter_flags;
-	switch_count = ch_switch->count;
-	tsf_low = ch_switch->timestamp & 0x0ffffffff;
-	/*
-	 * calculate the ucode channel switch time
-	 * adding TSF as one of the factor for when to switch
-	 */
-	if ((priv->ucode_beacon_time > tsf_low) && beacon_interval) {
-		if (switch_count > ((priv->ucode_beacon_time - tsf_low) /
-		    beacon_interval)) {
-			switch_count -= (priv->ucode_beacon_time -
-				tsf_low) / beacon_interval;
-		} else
-			switch_count = 0;
-	}
-	if (switch_count <= 1)
-		cmd.switch_time = cpu_to_le32(priv->ucode_beacon_time);
-	else {
-		switch_time_in_usec =
-			vif->bss_conf.beacon_int * switch_count * TIME_UNIT;
-		ucode_switch_time = iwl_usecs_to_beacons(priv,
-						switch_time_in_usec,
-						beacon_interval);
-		cmd.switch_time = iwl_add_beacon_time(priv,
-						priv->ucode_beacon_time,
-						ucode_switch_time,
-						beacon_interval);
-	}
-	IWL_DEBUG_11H(priv, "uCode time for the switch is 0x%x\n",
-		      cmd.switch_time);
-	ch_info = iwl_get_channel_info(priv, priv->band, ch);
-	if (ch_info)
-		cmd.expect_beacon = is_channel_radar(ch_info);
-	else {
-		IWL_ERR(priv, "invalid channel switch from %u to %u\n",
-			ctx->active.channel, ch);
-		return -EFAULT;
-	}
-	priv->switch_rxon.channel = cmd.channel;
-	priv->switch_rxon.switch_in_progress = true;
-
-	return iwl_send_cmd_sync(priv, &hcmd);
-}
-
 static struct iwl_lib_ops iwl2000_lib = {
 	.set_hw_params = iwl2000_hw_set_hw_params,
 	.rx_handler_setup = iwlagn_rx_handler_setup,
@@ -258,7 +185,6 @@ static struct iwl_lib_ops iwl2000_lib = {
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
 	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
-	.set_channel_switch = iwl2030_hw_channel_switch,
 	.apm_ops = {
 		.init = iwl_apm_init,
 		.config = iwl2000_nic_config,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index a70b8cf..5b721c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -331,8 +331,6 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 			ctx->active.channel, ch);
 		return -EFAULT;
 	}
-	priv->switch_rxon.channel = cmd.channel;
-	priv->switch_rxon.switch_in_progress = true;
 
 	return iwl_send_cmd_sync(priv, &hcmd);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index fda6fe0..fbe565c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -270,8 +270,6 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 			ctx->active.channel, ch);
 		return -EFAULT;
 	}
-	priv->switch_rxon.channel = cmd.channel;
-	priv->switch_rxon.switch_in_progress = true;
 
 	return iwl_send_cmd_sync(priv, &hcmd);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index a95ad84..2532c7d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -342,10 +342,10 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	 * receive commit_rxon request
 	 * abort any previous channel switch if still in process
 	 */
-	if (priv->switch_rxon.switch_in_progress &&
-	    (priv->switch_rxon.channel != ctx->staging.channel)) {
+	if (test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status) &&
+	    (priv->switch_channel != ctx->staging.channel)) {
 		IWL_DEBUG_11H(priv, "abort channel switch on %d\n",
-		      le16_to_cpu(priv->switch_rxon.channel));
+			      le16_to_cpu(priv->switch_channel));
 		iwl_chswitch_done(priv, false);
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a662adc..8e1942e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2843,16 +2843,13 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 		goto out;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
-	    test_bit(STATUS_SCANNING, &priv->status))
+	    test_bit(STATUS_SCANNING, &priv->status) ||
+	    test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
 		goto out;
 
 	if (!iwl_is_associated_ctx(ctx))
 		goto out;
 
-	/* channel switch in progress */
-	if (priv->switch_rxon.switch_in_progress == true)
-		goto out;
-
 	if (priv->cfg->ops->lib->set_channel_switch) {
 
 		ch = channel->hw_value;
@@ -2901,15 +2898,19 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 			 * at this point, staging_rxon has the
 			 * configuration for channel switch
 			 */
+			set_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status);
+			priv->switch_channel = cpu_to_le16(ch);
 			if (priv->cfg->ops->lib->set_channel_switch(priv,
-								    ch_switch))
-				priv->switch_rxon.switch_in_progress = false;
+								    ch_switch)) {
+				clear_bit(STATUS_CHANNEL_SWITCH_PENDING,
+					  &priv->status);
+				priv->switch_channel = 0;
+				ieee80211_chswitch_done(ctx->vif, false);
+			}
 		}
 	}
 out:
 	mutex_unlock(&priv->mutex);
-	if (!priv->switch_rxon.switch_in_progress)
-		ieee80211_chswitch_done(ctx->vif, false);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 4653dea..213c80c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -843,12 +843,8 @@ void iwl_chswitch_done(struct iwl_priv *priv, bool is_success)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	if (priv->switch_rxon.switch_in_progress) {
+	if (test_and_clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
 		ieee80211_chswitch_done(ctx->vif, is_success);
-		mutex_lock(&priv->mutex);
-		priv->switch_rxon.switch_in_progress = false;
-		mutex_unlock(&priv->mutex);
-	}
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUG
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 3bb76f6..a54d416 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -560,6 +560,7 @@ void iwlcore_free_geos(struct iwl_priv *priv);
 #define STATUS_POWER_PMI	16
 #define STATUS_FW_ERROR		17
 #define STATUS_DEVICE_ENABLED	18
+#define STATUS_CHANNEL_SWITCH_PENDING 19
 
 
 static inline int iwl_is_ready(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 22a6e3e..c8de236 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -982,17 +982,6 @@ struct traffic_stats {
 };
 
 /*
- * iwl_switch_rxon: "channel switch" structure
- *
- * @ switch_in_progress: channel switch in progress
- * @ channel: new channel
- */
-struct iwl_switch_rxon {
-	bool switch_in_progress;
-	__le16 channel;
-};
-
-/*
  * schedule the timer to wake up every UCODE_TRACE_PERIOD milliseconds
  * to perform continuous uCode event logging operation if enabled
  */
@@ -1287,7 +1276,7 @@ struct iwl_priv {
 
 	struct iwl_rxon_context contexts[NUM_IWL_RXON_CTX];
 
-	struct iwl_switch_rxon switch_rxon;
+	__le16 switch_channel;
 
 	struct {
 		u32 error_event_table;
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 0053e9e..b774517 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -250,19 +250,19 @@ static void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	struct iwl_rxon_cmd *rxon = (void *)&ctx->active;
 
-	if (priv->switch_rxon.switch_in_progress) {
-		if (!le32_to_cpu(csa->status) &&
-		    (csa->channel == priv->switch_rxon.channel)) {
-			rxon->channel = csa->channel;
-			ctx->staging.channel = csa->channel;
-			IWL_DEBUG_11H(priv, "CSA notif: channel %d\n",
-			      le16_to_cpu(csa->channel));
-			iwl_chswitch_done(priv, true);
-		} else {
-			IWL_ERR(priv, "CSA notif (fail) : channel %d\n",
+	if (!test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
+		return;
+
+	if (!le32_to_cpu(csa->status) && csa->channel == priv->switch_channel) {
+		rxon->channel = csa->channel;
+		ctx->staging.channel = csa->channel;
+		IWL_DEBUG_11H(priv, "CSA notif: channel %d\n",
 			      le16_to_cpu(csa->channel));
-			iwl_chswitch_done(priv, false);
-		}
+		iwl_chswitch_done(priv, true);
+	} else {
+		IWL_ERR(priv, "CSA notif (fail) : channel %d\n",
+			le16_to_cpu(csa->channel));
+		iwl_chswitch_done(priv, false);
 	}
 }
 
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index a7b5cb0..224e985 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -907,7 +907,7 @@ static void if_sdio_interrupt(struct sdio_func *func)
 	card = sdio_get_drvdata(func);
 
 	cause = sdio_readb(card->func, IF_SDIO_H_INT_STATUS, &ret);
-	if (ret)
+	if (ret || !cause)
 		goto out;
 
 	lbs_deb_sdio("interrupt: 0x%X\n", (unsigned)cause);
@@ -1008,10 +1008,6 @@ static int if_sdio_probe(struct sdio_func *func,
 	if (ret)
 		goto release;
 
-	ret = sdio_claim_irq(func, if_sdio_interrupt);
-	if (ret)
-		goto disable;
-
 	/* For 1-bit transfers to the 8686 model, we need to enable the
 	 * interrupt flag in the CCCR register. Set the MMC_QUIRK_LENIENT_FN0
 	 * bit to allow access to non-vendor registers. */
@@ -1083,6 +1079,21 @@ static int if_sdio_probe(struct sdio_func *func,
 		card->rx_unit = 0;
 
 	/*
+	 * Set up the interrupt handler late.
+	 *
+	 * If we set it up earlier, the (buggy) hardware generates a spurious
+	 * interrupt, even before the interrupt has been enabled, with
+	 * CCCR_INTx = 0.
+	 *
+	 * We register the interrupt handler late so that we can handle any
+	 * spurious interrupts, and also to avoid generation of that known
+	 * spurious interrupt in the first place.
+	 */
+	ret = sdio_claim_irq(func, if_sdio_interrupt);
+	if (ret)
+		goto disable;
+
+	/*
 	 * Enable interrupts now that everything is set up
 	 */
 	sdio_writeb(func, 0x0f, IF_SDIO_H_INT_MASK, &ret);
diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
index 82feb34..2a20dab 100644
--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -539,10 +539,12 @@ void ssb_pcicore_init(struct ssb_pcicore *pc)
 	if (!pc->hostmode)
 		ssb_pcicore_init_clientmode(pc);
 
-	/* Additional always once-executed workarounds */
-	ssb_pcicore_serdes_workaround(pc);
-	/* TODO: ASPM */
-	/* TODO: Clock Request Update */
+	/* Additional PCIe always once-executed workarounds */
+	if (dev->id.coreid == SSB_DEV_PCIE) {
+		ssb_pcicore_serdes_workaround(pc);
+		/* TODO: ASPM */
+		/* TODO: Clock Request Update */
+	}
 }
 
 static u32 ssb_pcie_read(struct ssb_pcicore *pc, u32 address)
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 49d4f86..dee30ae 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1145,6 +1145,10 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 				+ IEEE80211_ENCRYPT_HEADROOM;
 	ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
 
+	ret = dev_alloc_name(ndev, ndev->name);
+	if (ret < 0)
+		goto fail;
+
 	ieee80211_assign_perm_addr(local, ndev, type);
 	memcpy(ndev->dev_addr, ndev->perm_addr, ETH_ALEN);
 	SET_NETDEV_DEV(ndev, wiphy_dev(local->hw.wiphy));
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
