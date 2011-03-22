Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab1CVSAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:00:14 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54081 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab1CVSAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:00:12 -0400
Date: Tue, 22 Mar 2011 13:46:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: wireless-2.6 2011-03-22
Message-ID: <20110322174616.GB2512@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

Here is a batch of fixes intended for 2.6.39.  Included are a lock
leak fix for iwlwifi, a "hold the lock longer" fix for orinoco, an
rtlwifi fix for a memset argument ordering problem, a sta structure
initialization fix for mac80211, an ath9k NULL pointer fix, a
kernel-doc fix, and a handful of device IDs.

Please let me know if there are problems!

Thanks,

John

---

The following changes since commit 736561a01f11114146b1b7f82d486fa9c95828ef:

  IPVS: Use global mutex in ip_vs_app.c (2011-03-21 20:39:24 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master

Dan Carpenter (1):
      iwlwifi: missing unlock on error path

Felix Fietkau (1):
      mac80211: initialize sta->last_rx in sta_info_alloc

Ilia Mirkin (1):
      rtlwifi: Fix memset argument order

Joe Gunn (1):
      orinoco: Maintain lock until entry removed from list

Mohammed Shafi Shajakhan (1):
      ath9k: Fix kernel panic in AR2427

Peter Lemenkov (4):
      rt2x00: Add rt2870 device id
      rt2x00: Add Planex Communications, Inc. RT8070
      rt2x00: Add 2L Central Europe BV 8070
      rt2x00: Add unknown Toshiba device

Randy Dunlap (1):
      wireless: fix 80211 kernel-doc warnings

Tõnu Samuel (1):
      zd1211rw: TrendNet TEW-509UB id added

 drivers/net/wireless/ath/ath9k/xmit.c   |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    7 +++++--
 drivers/net/wireless/orinoco/main.c     |    2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c |    7 ++++++-
 drivers/net/wireless/rtlwifi/efuse.c    |   31 +++++++++++++++----------------
 drivers/net/wireless/zd1211rw/zd_usb.c  |    1 +
 include/net/cfg80211.h                  |    3 ++-
 include/net/mac80211.h                  |    2 +-
 net/mac80211/sta_info.c                 |    1 +
 9 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index ef22096..26734e5 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1725,8 +1725,8 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 	u8 tidno;
 
 	spin_lock_bh(&txctl->txq->axq_lock);
-
-	if (ieee80211_is_data_qos(hdr->frame_control) && txctl->an) {
+	if ((sc->sc_flags & SC_OP_TXAGGR) && txctl->an &&
+		ieee80211_is_data_qos(hdr->frame_control)) {
 		tidno = ieee80211_get_qos_ctl(hdr)[0] &
 			IEEE80211_QOS_CTL_TID_MASK;
 		tid = ATH_AN_2_TID(txctl->an, tidno);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 581dc9f..321b18b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3009,14 +3009,17 @@ static int iwl_mac_offchannel_tx_cancel_wait(struct ieee80211_hw *hw)
 
 	mutex_lock(&priv->mutex);
 
-	if (!priv->_agn.offchan_tx_skb)
-		return -EINVAL;
+	if (!priv->_agn.offchan_tx_skb) {
+		ret = -EINVAL;
+		goto unlock;
+	}
 
 	priv->_agn.offchan_tx_skb = NULL;
 
 	ret = iwl_scan_cancel_timeout(priv, 200);
 	if (ret)
 		ret = -EIO;
+unlock:
 	mutex_unlock(&priv->mutex);
 
 	return ret;
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index f3d396e..62c6b2b 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -1376,13 +1376,13 @@ static void orinoco_process_scan_results(struct work_struct *work)
 
 	spin_lock_irqsave(&priv->scan_lock, flags);
 	list_for_each_entry_safe(sd, temp, &priv->scan_list, list) {
-		spin_unlock_irqrestore(&priv->scan_lock, flags);
 
 		buf = sd->buf;
 		len = sd->len;
 		type = sd->type;
 
 		list_del(&sd->list);
+		spin_unlock_irqrestore(&priv->scan_lock, flags);
 		kfree(sd);
 
 		if (len > 0) {
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index f1a9214..4e36865 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -719,6 +719,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0b05, 0x1732), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0b05, 0x1742), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0b05, 0x1784), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x1761, 0x0b05), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* AzureWave */
 	{ USB_DEVICE(0x13d3, 0x3247), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x13d3, 0x3273), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -913,7 +914,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0b05, 0x1760), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0b05, 0x1761), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0b05, 0x1790), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x1761, 0x0b05), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* AzureWave */
 	{ USB_DEVICE(0x13d3, 0x3262), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x13d3, 0x3284), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -937,6 +937,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x07d1, 0x3c13), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c15), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c17), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* Edimax */
+	{ USB_DEVICE(0x7392, 0x4085), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Encore */
 	{ USB_DEVICE(0x203d, 0x14a1), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Gemtek */
@@ -961,6 +963,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x1d4d, 0x0010), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1d4d, 0x0011), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Planex */
+	{ USB_DEVICE(0x2019, 0x5201), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x2019, 0xab24), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Qcom */
 	{ USB_DEVICE(0x18e8, 0x6259), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -972,6 +975,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Sweex */
 	{ USB_DEVICE(0x177f, 0x0153), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x177f, 0x0313), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* Toshiba */
+	{ USB_DEVICE(0x0930, 0x0a07), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Zyxel */
 	{ USB_DEVICE(0x0586, 0x341a), USB_DEVICE_DATA(&rt2800usb_ops) },
 #endif
diff --git a/drivers/net/wireless/rtlwifi/efuse.c b/drivers/net/wireless/rtlwifi/efuse.c
index 4f92cba..f74a870 100644
--- a/drivers/net/wireless/rtlwifi/efuse.c
+++ b/drivers/net/wireless/rtlwifi/efuse.c
@@ -410,8 +410,8 @@ bool efuse_shadow_update(struct ieee80211_hw *hw)
 
 	if (!efuse_shadow_update_chk(hw)) {
 		efuse_read_all_map(hw, &rtlefuse->efuse_map[EFUSE_INIT_MAP][0]);
-		memcpy((void *)&rtlefuse->efuse_map[EFUSE_MODIFY_MAP][0],
-		       (void *)&rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
+		memcpy(&rtlefuse->efuse_map[EFUSE_MODIFY_MAP][0],
+		       &rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
 		       rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]);
 
 		RT_TRACE(rtlpriv, COMP_EFUSE, DBG_LOUD,
@@ -446,9 +446,9 @@ bool efuse_shadow_update(struct ieee80211_hw *hw)
 
 		if (word_en != 0x0F) {
 			u8 tmpdata[8];
-			memcpy((void *)tmpdata,
-			       (void *)(&rtlefuse->
-					efuse_map[EFUSE_MODIFY_MAP][base]), 8);
+			memcpy(tmpdata,
+			       &rtlefuse->efuse_map[EFUSE_MODIFY_MAP][base],
+			       8);
 			RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_LOUD,
 				      ("U-efuse\n"), tmpdata, 8);
 
@@ -465,8 +465,8 @@ bool efuse_shadow_update(struct ieee80211_hw *hw)
 	efuse_power_switch(hw, true, false);
 	efuse_read_all_map(hw, &rtlefuse->efuse_map[EFUSE_INIT_MAP][0]);
 
-	memcpy((void *)&rtlefuse->efuse_map[EFUSE_MODIFY_MAP][0],
-	       (void *)&rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
+	memcpy(&rtlefuse->efuse_map[EFUSE_MODIFY_MAP][0],
+	       &rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
 	       rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]);
 
 	RT_TRACE(rtlpriv, COMP_EFUSE, DBG_LOUD, ("<---\n"));
@@ -479,13 +479,12 @@ void rtl_efuse_shadow_map_update(struct ieee80211_hw *hw)
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 
 	if (rtlefuse->autoload_failflag == true) {
-		memset((void *)(&rtlefuse->efuse_map[EFUSE_INIT_MAP][0]), 128,
-		       0xFF);
+		memset(&rtlefuse->efuse_map[EFUSE_INIT_MAP][0], 0xFF, 128);
 	} else
 		efuse_read_all_map(hw, &rtlefuse->efuse_map[EFUSE_INIT_MAP][0]);
 
-	memcpy((void *)&rtlefuse->efuse_map[EFUSE_MODIFY_MAP][0],
-	       (void *)&rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
+	memcpy(&rtlefuse->efuse_map[EFUSE_MODIFY_MAP][0],
+	       &rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
 	       rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]);
 
 }
@@ -694,8 +693,8 @@ static int efuse_pg_packet_read(struct ieee80211_hw *hw, u8 offset, u8 *data)
 	if (offset > 15)
 		return false;
 
-	memset((void *)data, PGPKT_DATA_SIZE * sizeof(u8), 0xff);
-	memset((void *)tmpdata, PGPKT_DATA_SIZE * sizeof(u8), 0xff);
+	memset(data, 0xff, PGPKT_DATA_SIZE * sizeof(u8));
+	memset(tmpdata, 0xff, PGPKT_DATA_SIZE * sizeof(u8));
 
 	while (bcontinual && (efuse_addr < EFUSE_MAX_SIZE)) {
 		if (readstate & PG_STATE_HEADER) {
@@ -862,7 +861,7 @@ static void efuse_write_data_case2(struct ieee80211_hw *hw, u16 *efuse_addr,
 
 		tmp_word_cnts = efuse_calculate_word_cnts(tmp_pkt.word_en);
 
-		memset((void *)originaldata, 8 * sizeof(u8), 0xff);
+		memset(originaldata, 0xff, 8 * sizeof(u8));
 
 		if (efuse_pg_packet_read(hw, tmp_pkt.offset, originaldata)) {
 			badworden = efuse_word_enable_data_write(hw,
@@ -917,7 +916,7 @@ static int efuse_pg_packet_write(struct ieee80211_hw *hw,
 	target_pkt.offset = offset;
 	target_pkt.word_en = word_en;
 
-	memset((void *)target_pkt.data, 8 * sizeof(u8), 0xFF);
+	memset(target_pkt.data, 0xFF, 8 * sizeof(u8));
 
 	efuse_word_enable_data_read(word_en, data, target_pkt.data);
 	target_word_cnts = efuse_calculate_word_cnts(target_pkt.word_en);
@@ -1022,7 +1021,7 @@ static u8 efuse_word_enable_data_write(struct ieee80211_hw *hw,
 	u8 badworden = 0x0F;
 	u8 tmpdata[8];
 
-	memset((void *)tmpdata, PGPKT_DATA_SIZE, 0xff);
+	memset(tmpdata, 0xff, PGPKT_DATA_SIZE);
 	RT_TRACE(rtlpriv, COMP_EFUSE, DBG_LOUD,
 		 ("word_en = %x efuse_addr=%x\n", word_en, efuse_addr));
 
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 81e8048..58236e6 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -60,6 +60,7 @@ static struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x157e, 0x300a), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x157e, 0x300b), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x157e, 0x3204), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x157e, 0x3207), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x1740, 0x2000), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x6891, 0xa727), .driver_info = DEVICE_ZD1211 },
 	/* ZD1211B */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 60f7876..b2b9d28 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -486,7 +486,8 @@ struct rate_info {
  * @plink_state: mesh peer link state
  * @signal: signal strength of last received packet in dBm
  * @signal_avg: signal strength average in dBm
- * @txrate: current unicast bitrate to this station
+ * @txrate: current unicast bitrate from this station
+ * @rxrate: current unicast bitrate to this station
  * @rx_packets: packets received from this station
  * @tx_packets: packets transmitted to this station
  * @tx_retries: cumulative retry counts
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8650e7b..cefe1b3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1160,7 +1160,7 @@ enum ieee80211_hw_flags {
  * @napi_weight: weight used for NAPI polling.  You must specify an
  *	appropriate value here if a napi_poll operation is provided
  *	by your driver.
-
+ *
  * @max_rx_aggregation_subframes: maximum buffer size (number of
  *	sub-frames) to be used for A-MPDU block ack receiver
  *	aggregation.
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 5a11078..d0311a3 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -243,6 +243,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	memcpy(sta->sta.addr, addr, ETH_ALEN);
 	sta->local = local;
 	sta->sdata = sdata;
+	sta->last_rx = jiffies;
 
 	ewma_init(&sta->avg_signal, 1024, 8);
 
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
