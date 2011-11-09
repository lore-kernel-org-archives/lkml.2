Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab1KITpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 14:45:18 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37514 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab1KITpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 14:45:16 -0500
Date: Wed, 9 Nov 2011 14:35:04 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: wireless 2011-11-09
Message-ID: <20111109193504.GA32400@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

Here is another batch of fixes intended for 3.2.  First up is a NULL
pointer fix for brcm80211.  Next is a mac80211 fix to use the min
supported rate for APs that fail to advertise their basic rate set in
their associate response.  After that is a wl12xx fix that corrects
an SSID list check.  The ath regulatory code gets a NULL pointer
fix, and the mac80211 uAPSD code gets a fix to set the "more data"
flag properly.  The mwifiex driver gets a fix for a memory leak.
The code in net/wireless gets a flurry of fixes from Johannes,
including a kerneldoc fix.  Finally, b43 rounds-out the list with a
couple of PHY-related fixes.

Regarding the Bluetooth fixes, Gustavo says this:

Please let me know if there are problems!

Thanks,

John

---

The following changes since commit 2bc8ca40f951163b3bb75949479e2755c12c1b96:

  ipv4: Fix inetpeer expire time information (2011-11-08 14:40:40 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git for-davem

Andrzej Kaczmarek (1):
      Bluetooth: Use miliseconds for L2CAP channel timeouts

Arek Lichwa (1):
      Bluetooth: Revert: Fix L2CAP connection establishment

Arend van Spriel (1):
      brcm80211: smac: eliminate a null pointer dereference in dma.c

Eliad Peller (1):
      mac80211: use min rate as basic rate for buggy APs

Eyal Shapira (1):
      wl12xx: fix wl12xx_scan_sched_scan_ssid_list() check that all given ssids are in filters

Helmut Schaa (1):
      ath: Fix NULL ptr dereference in ath_reg_apply_world_flags

Janusz.Dziedzic@tieto.com (1):
      mac80211: uAPSD - fix IEEE80211_FCTL_MOREDATA bit setting

Jesper Juhl (1):
      net, wireless, mwifiex: Fix mem leak in mwifiex_update_curr_bss_params()

Johannes Berg (4):
      nl80211: fix HT capability attribute validation
      cfg80211: allow setting TXQ parameters only in AP mode
      cfg80211: fix cmp_ies
      cfg80211: fix missing kernel-doc

John W. Linville (2):
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth
      Merge branch 'master' of ssh://ra.kernel.org/.../linville/wireless into for-davem

Rafał Miłecki (2):
      b43: fill ctl1 word on all newer PHYs, fix PHY errors
      b43: HT-PHY: report signal to mac80211

Wen-chien Jesse Sung (1):
      Bluetooth: Add support for Broadcom BCM20702A0

 drivers/bluetooth/btusb.c                     |    3 +++
 drivers/net/wireless/ath/regd.c               |    2 ++
 drivers/net/wireless/b43/xmit.c               |   15 +++++++++++++--
 drivers/net/wireless/b43/xmit.h               |   16 +++++++++++++++-
 drivers/net/wireless/brcm80211/brcmsmac/dma.c |    5 +++--
 drivers/net/wireless/mwifiex/scan.c           |    3 ++-
 drivers/net/wireless/wl12xx/scan.c            |    2 +-
 include/net/bluetooth/l2cap.h                 |    7 +++++--
 include/net/cfg80211.h                        |    4 ++++
 net/bluetooth/hci_conn.c                      |    2 +-
 net/bluetooth/l2cap_core.c                    |   16 ++++++++--------
 net/mac80211/mlme.c                           |   19 +++++++++++++++++++
 net/mac80211/sta_info.c                       |    8 ++++----
 net/wireless/nl80211.c                        |    9 +++++++--
 net/wireless/scan.c                           |   13 ++++++++-----
 15 files changed, 95 insertions(+), 29 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index f9b7260..fe4ebc3 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -100,6 +100,9 @@ static struct usb_device_id btusb_table[] = {
 	/* Canyon CN-BTU1 with HID interfaces */
 	{ USB_DEVICE(0x0c10, 0x0000) },
 
+	/* Broadcom BCM20702A0 */
+	{ USB_DEVICE(0x413c, 0x8197) },
+
 	{ }	/* Terminating entry */
 };
 
diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 028310f..f1be57f 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -253,6 +253,8 @@ ath_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	int r;
 
 	sband = wiphy->bands[IEEE80211_BAND_2GHZ];
+	if (!sband)
+		return;
 
 	/*
 	 * If no country IE has been received always enable active scan
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index 58ea0e5..5f77cbe 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -175,6 +175,7 @@ void b43_generate_plcp_hdr(struct b43_plcp_hdr4 *plcp,
 	}
 }
 
+/* TODO: verify if needed for SSLPN or LCN  */
 static u16 b43_generate_tx_phy_ctl1(struct b43_wldev *dev, u8 bitrate)
 {
 	const struct b43_phy *phy = &dev->phy;
@@ -256,6 +257,9 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 	unsigned int plcp_fragment_len;
 	u32 mac_ctl = 0;
 	u16 phy_ctl = 0;
+	bool fill_phy_ctl1 = (phy->type == B43_PHYTYPE_LP ||
+			      phy->type == B43_PHYTYPE_N ||
+			      phy->type == B43_PHYTYPE_HT);
 	u8 extra_ft = 0;
 	struct ieee80211_rate *txrate;
 	struct ieee80211_tx_rate *rates;
@@ -531,7 +535,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 			extra_ft |= B43_TXH_EFT_RTSFB_CCK;
 
 		if (rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS &&
-		    phy->type == B43_PHYTYPE_N) {
+		    fill_phy_ctl1) {
 			txhdr->phy_ctl1_rts = cpu_to_le16(
 				b43_generate_tx_phy_ctl1(dev, rts_rate));
 			txhdr->phy_ctl1_rts_fb = cpu_to_le16(
@@ -552,7 +556,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 		break;
 	}
 
-	if (phy->type == B43_PHYTYPE_N) {
+	if (fill_phy_ctl1) {
 		txhdr->phy_ctl1 =
 			cpu_to_le16(b43_generate_tx_phy_ctl1(dev, rate));
 		txhdr->phy_ctl1_fb =
@@ -736,7 +740,14 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 
 	/* Link quality statistics */
 	switch (chanstat & B43_RX_CHAN_PHYTYPE) {
+	case B43_PHYTYPE_HT:
+		/* TODO: is max the right choice? */
+		status.signal = max_t(__s8,
+			max(rxhdr->phy_ht_power0, rxhdr->phy_ht_power1),
+			rxhdr->phy_ht_power2);
+		break;
 	case B43_PHYTYPE_N:
+		/* Broadcom has code for min and avg, but always uses max */
 		if (rxhdr->power0 == 16 || rxhdr->power0 == 32)
 			status.signal = max(rxhdr->power1, rxhdr->power2);
 		else
diff --git a/drivers/net/wireless/b43/xmit.h b/drivers/net/wireless/b43/xmit.h
index 16c514d..98d9074 100644
--- a/drivers/net/wireless/b43/xmit.h
+++ b/drivers/net/wireless/b43/xmit.h
@@ -249,6 +249,12 @@ struct b43_rxhdr_fw4 {
 		} __packed;
 	} __packed;
 	union {
+		/* HT-PHY */
+		struct {
+			PAD_BYTES(1);
+			__s8 phy_ht_power0;
+		} __packed;
+
 		/* RSSI for N-PHYs */
 		struct {
 			__s8 power2;
@@ -257,7 +263,15 @@ struct b43_rxhdr_fw4 {
 
 		__le16 phy_status2;	/* PHY RX Status 2 */
 	} __packed;
-	__le16 phy_status3;	/* PHY RX Status 3 */
+	union {
+		/* HT-PHY */
+		struct {
+			__s8 phy_ht_power1;
+			__s8 phy_ht_power2;
+		} __packed;
+
+		__le16 phy_status3;	/* PHY RX Status 3 */
+	} __packed;
 	union {
 		/* Tested with 598.314, 644.1001 and 666.2 */
 		struct {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index b56a302..6ebec8f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -358,13 +358,14 @@ static uint nrxdactive(struct dma_info *di, uint h, uint t)
 
 static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags)
 {
-	uint dmactrlflags = di->dma.dmactrlflags;
+	uint dmactrlflags;
 
 	if (di == NULL) {
-		DMA_ERROR(("%s: _dma_ctrlflags: NULL dma handle\n", di->name));
+		DMA_ERROR(("_dma_ctrlflags: NULL dma handle\n"));
 		return 0;
 	}
 
+	dmactrlflags = di->dma.dmactrlflags;
 	dmactrlflags &= ~mask;
 	dmactrlflags |= flags;
 
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index dae8dbb..8a3f959 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1469,7 +1469,7 @@ mwifiex_update_curr_bss_params(struct mwifiex_private *priv, u8 *bssid,
 			       s32 rssi, const u8 *ie_buf, size_t ie_len,
 			       u16 beacon_period, u16 cap_info_bitmap, u8 band)
 {
-	struct mwifiex_bssdescriptor *bss_desc = NULL;
+	struct mwifiex_bssdescriptor *bss_desc;
 	int ret;
 	unsigned long flags;
 	u8 *beacon_ie;
@@ -1484,6 +1484,7 @@ mwifiex_update_curr_bss_params(struct mwifiex_private *priv, u8 *bssid,
 
 	beacon_ie = kmemdup(ie_buf, ie_len, GFP_KERNEL);
 	if (!beacon_ie) {
+		kfree(bss_desc);
 		dev_err(priv->adapter->dev, " failed to alloc beacon_ie\n");
 		return -ENOMEM;
 	}
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 128ccb7..fc29c67 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -559,7 +559,7 @@ wl12xx_scan_sched_scan_ssid_list(struct wl1271 *wl,
 						break;
 					}
 				/* Fail if SSID isn't present in the filters */
-				if (j == req->n_ssids) {
+				if (j == cmd->n_ssids) {
 					ret = -EINVAL;
 					goto out_free;
 				}
diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index ab90ae0..6cc18f3 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -39,8 +39,11 @@
 #define L2CAP_DEFAULT_ACK_TO		200
 #define L2CAP_LE_DEFAULT_MTU		23
 
-#define L2CAP_CONN_TIMEOUT	(40000) /* 40 seconds */
-#define L2CAP_INFO_TIMEOUT	(4000)  /*  4 seconds */
+#define L2CAP_DISC_TIMEOUT             (100)
+#define L2CAP_DISC_REJ_TIMEOUT         (5000)  /*  5 seconds */
+#define L2CAP_ENC_TIMEOUT              (5000)  /*  5 seconds */
+#define L2CAP_CONN_TIMEOUT             (40000) /* 40 seconds */
+#define L2CAP_INFO_TIMEOUT             (4000)  /*  4 seconds */
 
 /* L2CAP socket address */
 struct sockaddr_l2 {
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 92cf1c2..95852e3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -456,6 +456,9 @@ enum station_parameters_apply_mask {
  *	as the AC bitmap in the QoS info field
  * @max_sp: max Service Period. same format as the MAX_SP in the
  *	QoS info field (but already shifted down)
+ * @sta_modify_mask: bitmap indicating which parameters changed
+ *	(for those that don't have a natural "no change" value),
+ *	see &enum station_parameters_apply_mask
  */
 struct station_parameters {
 	u8 *supported_rates;
@@ -615,6 +618,7 @@ struct sta_bss_parameters {
  *	user space MLME/SME implementation. The information is provided for
  *	the cfg80211_new_sta() calls to notify user space of the IEs.
  * @assoc_req_ies_len: Length of assoc_req_ies buffer in octets.
+ * @sta_flags: station flags mask & values
  */
 struct station_info {
 	u32 filled;
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index c1c597e..e0af723 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -673,7 +673,7 @@ int hci_conn_security(struct hci_conn *conn, __u8 sec_level, __u8 auth_type)
 		goto encrypt;
 
 auth:
-	if (test_bit(HCI_CONN_ENCRYPT_PEND, &conn->pend))
+	if (test_and_set_bit(HCI_CONN_ENCRYPT_PEND, &conn->pend))
 		return 0;
 
 	if (!hci_conn_auth(conn, sec_level, auth_type))
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 8cd1291..5ea94a1 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -251,7 +251,7 @@ static void l2cap_chan_timeout(unsigned long arg)
 
 	if (sock_owned_by_user(sk)) {
 		/* sk is owned by user. Try again later */
-		__set_chan_timer(chan, HZ / 5);
+		__set_chan_timer(chan, L2CAP_DISC_TIMEOUT);
 		bh_unlock_sock(sk);
 		chan_put(chan);
 		return;
@@ -2488,7 +2488,7 @@ static inline int l2cap_connect_rsp(struct l2cap_conn *conn, struct l2cap_cmd_hd
 		if (sock_owned_by_user(sk)) {
 			l2cap_state_change(chan, BT_DISCONN);
 			__clear_chan_timer(chan);
-			__set_chan_timer(chan, HZ / 5);
+			__set_chan_timer(chan, L2CAP_DISC_TIMEOUT);
 			break;
 		}
 
@@ -2661,7 +2661,7 @@ static inline int l2cap_config_rsp(struct l2cap_conn *conn, struct l2cap_cmd_hdr
 
 	default:
 		sk->sk_err = ECONNRESET;
-		__set_chan_timer(chan, HZ * 5);
+		__set_chan_timer(chan, L2CAP_DISC_REJ_TIMEOUT);
 		l2cap_send_disconn_req(conn, chan, ECONNRESET);
 		goto done;
 	}
@@ -2718,7 +2718,7 @@ static inline int l2cap_disconnect_req(struct l2cap_conn *conn, struct l2cap_cmd
 	if (sock_owned_by_user(sk)) {
 		l2cap_state_change(chan, BT_DISCONN);
 		__clear_chan_timer(chan);
-		__set_chan_timer(chan, HZ / 5);
+		__set_chan_timer(chan, L2CAP_DISC_TIMEOUT);
 		bh_unlock_sock(sk);
 		return 0;
 	}
@@ -2752,7 +2752,7 @@ static inline int l2cap_disconnect_rsp(struct l2cap_conn *conn, struct l2cap_cmd
 	if (sock_owned_by_user(sk)) {
 		l2cap_state_change(chan,BT_DISCONN);
 		__clear_chan_timer(chan);
-		__set_chan_timer(chan, HZ / 5);
+		__set_chan_timer(chan, L2CAP_DISC_TIMEOUT);
 		bh_unlock_sock(sk);
 		return 0;
 	}
@@ -3998,7 +3998,7 @@ static inline void l2cap_check_encryption(struct l2cap_chan *chan, u8 encrypt)
 	if (encrypt == 0x00) {
 		if (chan->sec_level == BT_SECURITY_MEDIUM) {
 			__clear_chan_timer(chan);
-			__set_chan_timer(chan, HZ * 5);
+			__set_chan_timer(chan, L2CAP_ENC_TIMEOUT);
 		} else if (chan->sec_level == BT_SECURITY_HIGH)
 			l2cap_chan_close(chan, ECONNREFUSED);
 	} else {
@@ -4066,7 +4066,7 @@ static int l2cap_security_cfm(struct hci_conn *hcon, u8 status, u8 encrypt)
 					L2CAP_CONN_REQ, sizeof(req), &req);
 			} else {
 				__clear_chan_timer(chan);
-				__set_chan_timer(chan, HZ / 10);
+				__set_chan_timer(chan, L2CAP_DISC_TIMEOUT);
 			}
 		} else if (chan->state == BT_CONNECT2) {
 			struct l2cap_conn_rsp rsp;
@@ -4086,7 +4086,7 @@ static int l2cap_security_cfm(struct hci_conn *hcon, u8 status, u8 encrypt)
 				}
 			} else {
 				l2cap_state_change(chan, BT_DISCONN);
-				__set_chan_timer(chan, HZ / 10);
+				__set_chan_timer(chan, L2CAP_DISC_TIMEOUT);
 				res = L2CAP_CR_SEC_BLOCK;
 				stat = L2CAP_CS_NO_INFO;
 			}
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 17258fe..d3b408c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1485,6 +1485,7 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 	int i, j, err;
 	bool have_higher_than_11mbit = false;
 	u16 ap_ht_cap_flags;
+	int min_rate = INT_MAX, min_rate_index = -1;
 
 	/* AssocResp and ReassocResp have identical structure */
 
@@ -1551,6 +1552,10 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 				rates |= BIT(j);
 				if (is_basic)
 					basic_rates |= BIT(j);
+				if (rate < min_rate) {
+					min_rate = rate;
+					min_rate_index = j;
+				}
 				break;
 			}
 		}
@@ -1568,11 +1573,25 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 				rates |= BIT(j);
 				if (is_basic)
 					basic_rates |= BIT(j);
+				if (rate < min_rate) {
+					min_rate = rate;
+					min_rate_index = j;
+				}
 				break;
 			}
 		}
 	}
 
+	/*
+	 * some buggy APs don't advertise basic_rates. use the lowest
+	 * supported rate instead.
+	 */
+	if (unlikely(!basic_rates) && min_rate_index >= 0) {
+		printk(KERN_DEBUG "%s: No basic rates in AssocResp. "
+		       "Using min supported rate instead.\n", sdata->name);
+		basic_rates = BIT(min_rate_index);
+	}
+
 	sta->sta.supp_rates[wk->chan->band] = rates;
 	sdata->vif.bss_conf.basic_rates = basic_rates;
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index ce962d2..8eaa746 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1354,12 +1354,12 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 			 * Use MoreData flag to indicate whether there are
 			 * more buffered frames for this STA
 			 */
-			if (!more_data)
-				hdr->frame_control &=
-					cpu_to_le16(~IEEE80211_FCTL_MOREDATA);
-			else
+			if (more_data || !skb_queue_empty(&frames))
 				hdr->frame_control |=
 					cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+			else
+				hdr->frame_control &=
+					cpu_to_le16(~IEEE80211_FCTL_MOREDATA);
 
 			if (ieee80211_is_data_qos(hdr->frame_control) ||
 			    ieee80211_is_qos_nullfunc(hdr->frame_control))
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 48260c2..b3a476f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -132,8 +132,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_MESH_CONFIG] = { .type = NLA_NESTED },
 	[NL80211_ATTR_SUPPORT_MESH_AUTH] = { .type = NLA_FLAG },
 
-	[NL80211_ATTR_HT_CAPABILITY] = { .type = NLA_BINARY,
-					 .len = NL80211_HT_CAPABILITY_LEN },
+	[NL80211_ATTR_HT_CAPABILITY] = { .len = NL80211_HT_CAPABILITY_LEN },
 
 	[NL80211_ATTR_MGMT_SUBTYPE] = { .type = NLA_U8 },
 	[NL80211_ATTR_IE] = { .type = NLA_BINARY,
@@ -1253,6 +1252,12 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			goto bad_res;
 		}
 
+		if (netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+		    netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO) {
+			result = -EINVAL;
+			goto bad_res;
+		}
+
 		nla_for_each_nested(nl_txq_params,
 				    info->attrs[NL80211_ATTR_WIPHY_TXQ_PARAMS],
 				    rem_txq_params) {
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 0fb1424..dc23b31 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -259,17 +259,20 @@ static int cmp_ies(u8 num, u8 *ies1, size_t len1, u8 *ies2, size_t len2)
 {
 	const u8 *ie1 = cfg80211_find_ie(num, ies1, len1);
 	const u8 *ie2 = cfg80211_find_ie(num, ies2, len2);
-	int r;
 
+	/* equal if both missing */
 	if (!ie1 && !ie2)
 		return 0;
-	if (!ie1 || !ie2)
+	/* sort missing IE before (left of) present IE */
+	if (!ie1)
 		return -1;
+	if (!ie2)
+		return 1;
 
-	r = memcmp(ie1 + 2, ie2 + 2, min(ie1[1], ie2[1]));
-	if (r == 0 && ie1[1] != ie2[1])
+	/* sort by length first, then by contents */
+	if (ie1[1] != ie2[1])
 		return ie2[1] - ie1[1];
-	return r;
+	return memcmp(ie1 + 2, ie2 + 2, ie1[1]);
 }
 
 static bool is_bss(struct cfg80211_bss *a,
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
