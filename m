Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab1E0UBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 16:01:11 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57574 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1E0UBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 16:01:09 -0400
Date: Fri, 27 May 2011 15:50:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: wireless-2.6 2011-05-27
Message-ID: <20110527195008.GA5092@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

This is a quick batch of fixes intended for 2.6.40.  They are all
small(-ish), and several of them fix either build breakage or some
sort of regression.  At least one fixes an uninitialized variable
that could potentially cause a crash.

Please let me know if there are problems!

Thanks,

John

---

The following changes since commit c5c177b4aca83338781e72be2e6dd1601c560cb3:

  net: Kill ratelimit.h dependency in linux/net.h (2011-05-27 13:41:33 -0400)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git for-davem

Adrian Chadd (1):
      ath9k: Fix AR9287 calibration

Eliad Peller (1):
      mac80211: clear local->ps_data on disassoc

Jesper Juhl (1):
      mac80211: Remove duplicate linux/slab.h include from net/mac80211/scan.c

John W. Linville (1):
      Merge git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem

Larry Finger (2):
      rtlwifi: Fix kernel panic resulting from RX buffer allocation failure
      rtlwifi: Use order 2 RX buffer allocation only if necessary

Luciano Coelho (1):
      nl80211: fix check for valid SSID size in scan operations

Rafał Miłecki (1):
      b43: N-PHY: initialize last var in calibration function

Rajkumar Manoharan (4):
      ath9k: Reset chip on baseband hang
      ath9k_hw: disable phy restart on baseband panic caused by RXSM
      ath9k: set 40 Mhz rate only if hw is configured in ht40
      mac80211: stop queues before rate control updation

Stanislaw Gruszka (1):
      iwl4965: fix 5GHz operation

Tao Ma (1):
      wireless: Default to 'n' for 2 new added devices in Kconfig.

Yogesh Ashok Powar (1):
      mwifiex: correct event header length

 drivers/net/wireless/ath/ath9k/Kconfig        |    1 -
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c   |   22 +++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c           |    5 +++-
 drivers/net/wireless/ath/ath9k/hw.h           |    2 +
 drivers/net/wireless/ath/ath9k/main.c         |    4 ++-
 drivers/net/wireless/ath/ath9k/rc.c           |    3 +-
 drivers/net/wireless/b43/phy_n.c              |    2 +-
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c  |    4 +-
 drivers/net/wireless/mwifiex/sdio.h           |    4 +-
 drivers/net/wireless/rt2x00/Kconfig           |    1 -
 drivers/net/wireless/rtlwifi/pci.c            |   35 +++++++++++++++---------
 net/mac80211/mlme.c                           |    7 +++++
 net/mac80211/scan.c                           |    1 -
 net/wireless/nl80211.c                        |    4 +-
 15 files changed, 70 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index d9ff841..d9c08c6 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -26,7 +26,6 @@ config ATH9K
 config ATH9K_PCI
 	bool "Atheros ath9k PCI/PCIe bus support"
 	depends on ATH9K && PCI
-	default PCI
 	---help---
 	  This option enables the PCI bus support in ath9k.
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index 015d974..2d4c091 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -829,7 +829,7 @@ static bool ar9002_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 	if (AR_SREV_9271(ah)) {
 		if (!ar9285_hw_cl_cal(ah, chan))
 			return false;
-	} else if (AR_SREV_9285_12_OR_LATER(ah)) {
+	} else if (AR_SREV_9285(ah) && AR_SREV_9285_12_OR_LATER(ah)) {
 		if (!ar9285_hw_clc(ah, chan))
 			return false;
 	} else {
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index eee23ec..892c48b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1381,3 +1381,25 @@ void ar9003_hw_bb_watchdog_dbg_info(struct ath_hw *ah)
 		"==== BB update: done ====\n\n");
 }
 EXPORT_SYMBOL(ar9003_hw_bb_watchdog_dbg_info);
+
+void ar9003_hw_disable_phy_restart(struct ath_hw *ah)
+{
+	u32 val;
+
+	/* While receiving unsupported rate frame rx state machine
+	 * gets into a state 0xb and if phy_restart happens in that
+	 * state, BB would go hang. If RXSM is in 0xb state after
+	 * first bb panic, ensure to disable the phy_restart.
+	 */
+	if (!((MS(ah->bb_watchdog_last_status,
+		  AR_PHY_WATCHDOG_RX_OFDM_SM) == 0xb) ||
+	    ah->bb_hang_rx_ofdm))
+		return;
+
+	ah->bb_hang_rx_ofdm = true;
+	val = REG_READ(ah, AR_PHY_RESTART);
+	val &= ~AR_PHY_RESTART_ENA;
+
+	REG_WRITE(ah, AR_PHY_RESTART, val);
+}
+EXPORT_SYMBOL(ar9003_hw_disable_phy_restart);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 72543ce..1be7c8b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1555,9 +1555,12 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (ah->btcoex_hw.enabled)
 		ath9k_hw_btcoex_enable(ah);
 
-	if (AR_SREV_9300_20_OR_LATER(ah))
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		ar9003_hw_bb_watchdog_config(ah);
 
+		ar9003_hw_disable_phy_restart(ah);
+	}
+
 	ath9k_hw_apply_gpio_override(ah);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 57435ce..4b157c5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -842,6 +842,7 @@ struct ath_hw {
 
 	u32 bb_watchdog_last_status;
 	u32 bb_watchdog_timeout_ms; /* in ms, 0 to disable */
+	u8 bb_hang_rx_ofdm; /* true if bb hang due to rx_ofdm */
 
 	unsigned int paprd_target_power;
 	unsigned int paprd_training_power;
@@ -990,6 +991,7 @@ void ar9002_hw_enable_wep_aggregation(struct ath_hw *ah);
 void ar9003_hw_bb_watchdog_config(struct ath_hw *ah);
 void ar9003_hw_bb_watchdog_read(struct ath_hw *ah);
 void ar9003_hw_bb_watchdog_dbg_info(struct ath_hw *ah);
+void ar9003_hw_disable_phy_restart(struct ath_hw *ah);
 void ar9003_paprd_enable(struct ath_hw *ah, bool val);
 void ar9003_paprd_populate_single_table(struct ath_hw *ah,
 					struct ath9k_hw_cal_data *caldata,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a198ee3..2ca351f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -670,7 +670,8 @@ void ath9k_tasklet(unsigned long data)
 	u32 status = sc->intrstatus;
 	u32 rxmask;
 
-	if (status & ATH9K_INT_FATAL) {
+	if ((status & ATH9K_INT_FATAL) ||
+	    (status & ATH9K_INT_BB_WATCHDOG)) {
 		ath_reset(sc, true);
 		return;
 	}
@@ -737,6 +738,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 {
 #define SCHED_INTR (				\
 		ATH9K_INT_FATAL |		\
+		ATH9K_INT_BB_WATCHDOG |		\
 		ATH9K_INT_RXORN |		\
 		ATH9K_INT_RXEOL |		\
 		ATH9K_INT_RX |			\
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 1754221..ba7f36a 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -689,7 +689,8 @@ static void ath_rc_rate_set_series(const struct ath_rate_table *rate_table,
 
 	if (WLAN_RC_PHY_HT(rate_table->info[rix].phy)) {
 		rate->flags |= IEEE80211_TX_RC_MCS;
-		if (WLAN_RC_PHY_40(rate_table->info[rix].phy))
+		if (WLAN_RC_PHY_40(rate_table->info[rix].phy) &&
+		    conf_is_ht40(&txrc->hw->conf))
 			rate->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
 		if (WLAN_RC_PHY_SGI(rate_table->info[rix].phy))
 			rate->flags |= IEEE80211_TX_RC_SHORT_GI;
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 9ed6515..05960dd 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3093,7 +3093,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 	int freq;
 	bool avoid = false;
 	u8 length;
-	u16 tmp, core, type, count, max, numb, last, cmd;
+	u16 tmp, core, type, count, max, numb, last = 0, cmd;
 	const u16 *table;
 	bool phy6or5x;
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
index 7e5e85a..a7a4739 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
@@ -628,11 +628,11 @@ void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 
 	/* rx_status carries information about the packet to mac80211 */
 	rx_status.mactime = le64_to_cpu(phy_res->timestamp);
+	rx_status.band = (phy_res->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
+				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
 	rx_status.freq =
 		ieee80211_channel_to_frequency(le16_to_cpu(phy_res->channel),
 							rx_status.band);
-	rx_status.band = (phy_res->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
-				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
 	rx_status.rate_idx =
 		iwl4965_hwrate_to_mac80211_idx(rate_n_flags, rx_status.band);
 	rx_status.flag = 0;
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index a0e9bc5..4e97e90 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -167,8 +167,8 @@
 /* Rx unit register */
 #define CARD_RX_UNIT_REG		0x63
 
-/* Event header Len*/
-#define MWIFIEX_EVENT_HEADER_LEN           8
+/* Event header len w/o 4 bytes of interface header */
+#define MWIFIEX_EVENT_HEADER_LEN           4
 
 /* Max retry number of CMD53 write */
 #define MAX_WRITE_IOMEM_RETRY		2
diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 9def1e5..b2f8b8f 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -166,7 +166,6 @@ config RT2800USB_RT35XX
 config RT2800USB_RT53XX
        bool "rt2800usb - Include support for rt53xx devices (EXPERIMENTAL)"
        depends on EXPERIMENTAL
-       default y
        ---help---
          This adds support for rt53xx wireless chipset family to the
          rt2800pci driver.
diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index a409528..89100e7 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -669,11 +669,6 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 							 &rx_status,
 							 (u8 *) pdesc, skb);
 
-			pci_unmap_single(rtlpci->pdev,
-					 *((dma_addr_t *) skb->cb),
-					 rtlpci->rxbuffersize,
-					 PCI_DMA_FROMDEVICE);
-
 			skb_put(skb, rtlpriv->cfg->ops->get_desc((u8 *) pdesc,
 							 false,
 							 HW_DESC_RXPKT_LEN));
@@ -690,6 +685,21 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 			hdr = rtl_get_hdr(skb);
 			fc = rtl_get_fc(skb);
 
+			/* try for new buffer - if allocation fails, drop
+			 * frame and reuse old buffer
+			 */
+			new_skb = dev_alloc_skb(rtlpci->rxbuffersize);
+			if (unlikely(!new_skb)) {
+				RT_TRACE(rtlpriv, (COMP_INTR | COMP_RECV),
+					 DBG_DMESG,
+					 ("can't alloc skb for rx\n"));
+				goto done;
+			}
+			pci_unmap_single(rtlpci->pdev,
+					 *((dma_addr_t *) skb->cb),
+					 rtlpci->rxbuffersize,
+					 PCI_DMA_FROMDEVICE);
+
 			if (!stats.crc || !stats.hwerror) {
 				memcpy(IEEE80211_SKB_RXCB(skb), &rx_status,
 				       sizeof(rx_status));
@@ -758,15 +768,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 				rtl_lps_leave(hw);
 			}
 
-			new_skb = dev_alloc_skb(rtlpci->rxbuffersize);
-			if (unlikely(!new_skb)) {
-				RT_TRACE(rtlpriv, (COMP_INTR | COMP_RECV),
-					 DBG_DMESG,
-					 ("can't alloc skb for rx\n"));
-				goto done;
-			}
 			skb = new_skb;
-			/*skb->dev = dev; */
 
 			rtlpci->rx_ring[rx_queue_idx].rx_buf[rtlpci->
 							     rx_ring
@@ -1113,6 +1115,13 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw)
 
 		rtlpci->rx_ring[rx_queue_idx].idx = 0;
 
+		/* If amsdu_8k is disabled, set buffersize to 4096. This
+		 * change will reduce memory fragmentation.
+		 */
+		if (rtlpci->rxbuffersize > 4096 &&
+		    rtlpriv->rtlhal.disable_amsdu_8k)
+			rtlpci->rxbuffersize = 4096;
+
 		for (i = 0; i < rtlpci->rxringcount; i++) {
 			struct sk_buff *skb =
 			    dev_alloc_skb(rtlpci->rxbuffersize);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4f6b267..456cccf 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -232,6 +232,9 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		WARN_ON(!ieee80211_set_channel_type(local, sdata, channel_type));
 	}
 
+	ieee80211_stop_queues_by_reason(&sdata->local->hw,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
+
 	/* channel_type change automatically detected */
 	ieee80211_hw_config(local, 0);
 
@@ -245,6 +248,9 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		rcu_read_unlock();
 	}
 
+	ieee80211_wake_queues_by_reason(&sdata->local->hw,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
+
 	ht_opmode = le16_to_cpu(hti->operation_mode);
 
 	/* if bss configuration changed store the new one */
@@ -1089,6 +1095,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
 		config_changed |= IEEE80211_CONF_CHANGE_PS;
 	}
+	local->ps_sdata = NULL;
 
 	ieee80211_hw_config(local, config_changed);
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 27af672..58ffa7d 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -15,7 +15,6 @@
 #include <linux/if_arp.h>
 #include <linux/rtnetlink.h>
 #include <linux/pm_qos_params.h>
-#include <linux/slab.h>
 #include <net/sch_generic.h>
 #include <linux/slab.h>
 #include <net/mac80211.h>
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ec83f41..88a565f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3406,12 +3406,12 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	i = 0;
 	if (info->attrs[NL80211_ATTR_SCAN_SSIDS]) {
 		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS], tmp) {
+			request->ssids[i].ssid_len = nla_len(attr);
 			if (request->ssids[i].ssid_len > IEEE80211_MAX_SSID_LEN) {
 				err = -EINVAL;
 				goto out_free;
 			}
 			memcpy(request->ssids[i].ssid, nla_data(attr), nla_len(attr));
-			request->ssids[i].ssid_len = nla_len(attr);
 			i++;
 		}
 	}
@@ -3572,6 +3572,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (info->attrs[NL80211_ATTR_SCAN_SSIDS]) {
 		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS],
 				    tmp) {
+			request->ssids[i].ssid_len = nla_len(attr);
 			if (request->ssids[i].ssid_len >
 			    IEEE80211_MAX_SSID_LEN) {
 				err = -EINVAL;
@@ -3579,7 +3580,6 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 			}
 			memcpy(request->ssids[i].ssid, nla_data(attr),
 			       nla_len(attr));
-			request->ssids[i].ssid_len = nla_len(attr);
 			i++;
 		}
 	}
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
