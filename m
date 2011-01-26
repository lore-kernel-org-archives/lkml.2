Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab1AZTB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:01:27 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45889 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab1AZTBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:01:25 -0500
Date: Wed, 26 Jan 2011 13:47:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: wireless-2.6 2011-01-26
Message-ID: <20110126184745.GB3084@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

Here is a collection of fixes intended for 2.6.38.  There is a
MAINTAINERS fix for iwlwifi, a fix to avoid disabling .11n on iwl4965, a
NULL pointer fix for rtlwifi, a powersaving wakeup fix for ath9k, and
some others.

Also included is a batch of Bluetooth fixes via Gustavo.  These include
a fix for an RFCOMM crash, a HCI blacklist leak fix, and a number of other
simple fixes.

Please let me know if there are problems!

Thanks,

John

---

The following changes since commit 3dce38a02d6370dca690cd923619d4b00024b723:

  dcbnl: make get_app handling symmetric for IEEE and CEE DCBx (2011-01-24 15:19:55 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master

Alexander Holler (1):
      Bluetooth: ath3k: reduce memory usage

David Sterba (1):
      Bluetooth: l2cap: fix misuse of logical operation in place of bitop

Felix Fietkau (2):
      ath9k: add missing ps wakeup/restore calls
      mac80211: fix a crash in ieee80211_beacon_get_tim on change_interface

Greg Kroah-Hartman (1):
      rt2x00: add device id for windy31 usb device

Jesper Juhl (1):
      rtlwifi: Fix possible NULL dereference

Johan Hedberg (6):
      Bluetooth: Fix leaking blacklist when unregistering a hci device
      Revert "Bluetooth: Update sec_level/auth_type for already existing connections"
      Bluetooth: Fix MITM protection requirement preservation
      Bluetooth: Create a unified auth_type evaluation function
      Bluetooth: Fix authentication request for L2CAP raw sockets
      Bluetooth: Fix race condition with conn->sec_level

Luis R. Rodriguez (1):
      ath9k_hw: disabled PAPRD for AR9003

Lukáš Turek (1):
      Bluetooth: Never deallocate a session when some DLC points to it

Reinette Chatre (1):
      MAINTAINERS: remove Reinette Chatre as iwlwifi maintainer

Wey-Yi Guy (1):
      iwlwifi: don't read sku information from EEPROM for 4965

 MAINTAINERS                                   |    1 -
 drivers/bluetooth/ath3k.c                     |   75 ++++++----------------
 drivers/net/wireless/ath/ath9k/hw.c           |    6 ++-
 drivers/net/wireless/ath/ath9k/hw.h           |    1 +
 drivers/net/wireless/ath/ath9k/main.c         |    8 ++-
 drivers/net/wireless/ath/ath9k/xmit.c         |    2 -
 drivers/net/wireless/iwlwifi/iwl-4965.c       |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |   11 ++-
 drivers/net/wireless/rt2x00/rt73usb.c         |    1 +
 drivers/net/wireless/rtlwifi/pci.c            |   11 +++-
 include/net/bluetooth/hci_core.h              |    1 +
 net/bluetooth/hci_conn.c                      |   16 +++--
 net/bluetooth/hci_core.c                      |    4 +
 net/bluetooth/hci_event.c                     |    9 ++-
 net/bluetooth/l2cap.c                         |   84 +++++++++---------------
 net/bluetooth/rfcomm/core.c                   |    3 +-
 net/mac80211/tx.c                             |    3 +
 17 files changed, 105 insertions(+), 132 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 23d0436..c9ec9d8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3209,7 +3209,6 @@ F:	drivers/net/wimax/i2400m/
 F:	include/linux/wimax/i2400m.h
 
 INTEL WIRELESS WIFI LINK (iwlwifi)
-M:	Reinette Chatre <reinette.chatre@intel.com>
 M:	Wey-Yi Guy <wey-yi.w.guy@intel.com>
 M:	Intel Linux Wireless <ilw@linux.intel.com>
 L:	linux-wireless@vger.kernel.org
diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index 949ed09..a126e61 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -47,46 +47,40 @@ MODULE_DEVICE_TABLE(usb, ath3k_table);
 #define USB_REQ_DFU_DNLOAD	1
 #define BULK_SIZE		4096
 
-struct ath3k_data {
-	struct usb_device *udev;
-	u8 *fw_data;
-	u32 fw_size;
-	u32 fw_sent;
-};
-
-static int ath3k_load_firmware(struct ath3k_data *data,
-				unsigned char *firmware,
-				int count)
+static int ath3k_load_firmware(struct usb_device *udev,
+				const struct firmware *firmware)
 {
 	u8 *send_buf;
 	int err, pipe, len, size, sent = 0;
+	int count = firmware->size;
 
-	BT_DBG("ath3k %p udev %p", data, data->udev);
+	BT_DBG("udev %p", udev);
 
-	pipe = usb_sndctrlpipe(data->udev, 0);
+	pipe = usb_sndctrlpipe(udev, 0);
 
-	if ((usb_control_msg(data->udev, pipe,
+	send_buf = kmalloc(BULK_SIZE, GFP_ATOMIC);
+	if (!send_buf) {
+		BT_ERR("Can't allocate memory chunk for firmware");
+		return -ENOMEM;
+	}
+
+	memcpy(send_buf, firmware->data, 20);
+	if ((err = usb_control_msg(udev, pipe,
 				USB_REQ_DFU_DNLOAD,
 				USB_TYPE_VENDOR, 0, 0,
-				firmware, 20, USB_CTRL_SET_TIMEOUT)) < 0) {
+				send_buf, 20, USB_CTRL_SET_TIMEOUT)) < 0) {
 		BT_ERR("Can't change to loading configuration err");
-		return -EBUSY;
+		goto error;
 	}
 	sent += 20;
 	count -= 20;
 
-	send_buf = kmalloc(BULK_SIZE, GFP_ATOMIC);
-	if (!send_buf) {
-		BT_ERR("Can't allocate memory chunk for firmware");
-		return -ENOMEM;
-	}
-
 	while (count) {
 		size = min_t(uint, count, BULK_SIZE);
-		pipe = usb_sndbulkpipe(data->udev, 0x02);
-		memcpy(send_buf, firmware + sent, size);
+		pipe = usb_sndbulkpipe(udev, 0x02);
+		memcpy(send_buf, firmware->data + sent, size);
 
-		err = usb_bulk_msg(data->udev, pipe, send_buf, size,
+		err = usb_bulk_msg(udev, pipe, send_buf, size,
 					&len, 3000);
 
 		if (err || (len != size)) {
@@ -112,57 +106,28 @@ static int ath3k_probe(struct usb_interface *intf,
 {
 	const struct firmware *firmware;
 	struct usb_device *udev = interface_to_usbdev(intf);
-	struct ath3k_data *data;
-	int size;
 
 	BT_DBG("intf %p id %p", intf, id);
 
 	if (intf->cur_altsetting->desc.bInterfaceNumber != 0)
 		return -ENODEV;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	data->udev = udev;
-
 	if (request_firmware(&firmware, "ath3k-1.fw", &udev->dev) < 0) {
-		kfree(data);
 		return -EIO;
 	}
 
-	size = max_t(uint, firmware->size, 4096);
-	data->fw_data = kmalloc(size, GFP_KERNEL);
-	if (!data->fw_data) {
+	if (ath3k_load_firmware(udev, firmware)) {
 		release_firmware(firmware);
-		kfree(data);
-		return -ENOMEM;
-	}
-
-	memcpy(data->fw_data, firmware->data, firmware->size);
-	data->fw_size = firmware->size;
-	data->fw_sent = 0;
-	release_firmware(firmware);
-
-	usb_set_intfdata(intf, data);
-	if (ath3k_load_firmware(data, data->fw_data, data->fw_size)) {
-		usb_set_intfdata(intf, NULL);
-		kfree(data->fw_data);
-		kfree(data);
 		return -EIO;
 	}
+	release_firmware(firmware);
 
 	return 0;
 }
 
 static void ath3k_disconnect(struct usb_interface *intf)
 {
-	struct ath3k_data *data = usb_get_intfdata(intf);
-
 	BT_DBG("ath3k_disconnect intf %p", intf);
-
-	kfree(data->fw_data);
-	kfree(data);
 }
 
 static struct usb_driver ath3k_driver = {
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1afb8bb..9f01e50 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -369,6 +369,9 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 	else
 		ah->config.ht_enable = 0;
 
+	/* PAPRD needs some more work to be enabled */
+	ah->config.paprd_disable = 1;
+
 	ah->config.rx_intr_mitigation = true;
 	ah->config.pcieSerDesWrite = true;
 
@@ -1933,7 +1936,8 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		pCap->rx_status_len = sizeof(struct ar9003_rxs);
 		pCap->tx_desc_len = sizeof(struct ar9003_txc);
 		pCap->txs_len = sizeof(struct ar9003_txs);
-		if (ah->eep_ops->get_eeprom(ah, EEP_PAPRD))
+		if (!ah->config.paprd_disable &&
+		    ah->eep_ops->get_eeprom(ah, EEP_PAPRD))
 			pCap->hw_caps |= ATH9K_HW_CAP_PAPRD;
 	} else {
 		pCap->tx_desc_len = sizeof(struct ath_desc);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 5a3dfec..ea9fde6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -225,6 +225,7 @@ struct ath9k_ops_config {
 	u32 pcie_waen;
 	u8 analog_shiftreg;
 	u8 ht_enable;
+	u8 paprd_disable;
 	u32 ofdm_trig_low;
 	u32 ofdm_trig_high;
 	u32 cck_trig_high;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f90a6ca..c79c97b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -592,14 +592,12 @@ void ath9k_tasklet(unsigned long data)
 	u32 status = sc->intrstatus;
 	u32 rxmask;
 
-	ath9k_ps_wakeup(sc);
-
 	if (status & ATH9K_INT_FATAL) {
 		ath_reset(sc, true);
-		ath9k_ps_restore(sc);
 		return;
 	}
 
+	ath9k_ps_wakeup(sc);
 	spin_lock(&sc->sc_pcu_lock);
 
 	if (!ath9k_hw_check_alive(ah))
@@ -969,6 +967,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	/* Stop ANI */
 	del_timer_sync(&common->ani.timer);
 
+	ath9k_ps_wakeup(sc);
 	spin_lock_bh(&sc->sc_pcu_lock);
 
 	ieee80211_stop_queues(hw);
@@ -1015,6 +1014,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 
 	/* Start ANI */
 	ath_start_ani(common);
+	ath9k_ps_restore(sc);
 
 	return r;
 }
@@ -1701,7 +1701,9 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 skip_chan_change:
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
 		sc->config.txpowlimit = 2 * conf->power_level;
+		ath9k_ps_wakeup(sc);
 		ath_update_txpow(sc);
+		ath9k_ps_restore(sc);
 	}
 
 	spin_lock_bh(&sc->wiphy_lock);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 332d1fe..33a37ed 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2113,9 +2113,7 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 	if (needreset) {
 		ath_dbg(ath9k_hw_common(sc->sc_ah), ATH_DBG_RESET,
 			"tx hung, resetting the chip\n");
-		ath9k_ps_wakeup(sc);
 		ath_reset(sc, true);
-		ath9k_ps_restore(sc);
 	}
 
 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 3f1e5f1..91a9f52 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2624,6 +2624,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.fw_name_pre = IWL4965_FW_PRE,
 	.ucode_api_max = IWL4965_UCODE_API_MAX,
 	.ucode_api_min = IWL4965_UCODE_API_MIN,
+	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_ABC,
 	.eeprom_ver = EEPROM_4965_EEPROM_VERSION,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
index 14ceb4d..27b5a3e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
@@ -152,11 +152,14 @@ int iwl_eeprom_check_sku(struct iwl_priv *priv)
 
 	eeprom_sku = iwl_eeprom_query16(priv, EEPROM_SKU_CAP);
 
-	priv->cfg->sku = ((eeprom_sku & EEPROM_SKU_CAP_BAND_SELECTION) >>
+	if (!priv->cfg->sku) {
+		/* not using sku overwrite */
+		priv->cfg->sku =
+			((eeprom_sku & EEPROM_SKU_CAP_BAND_SELECTION) >>
 			EEPROM_SKU_CAP_BAND_POS);
-	if (eeprom_sku & EEPROM_SKU_CAP_11N_ENABLE)
-		priv->cfg->sku |= IWL_SKU_N;
-
+		if (eeprom_sku & EEPROM_SKU_CAP_11N_ENABLE)
+			priv->cfg->sku |= IWL_SKU_N;
+	}
 	if (!priv->cfg->sku) {
 		IWL_ERR(priv, "Invalid device sku\n");
 		return -EINVAL;
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 0b4e859..029be3c 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2446,6 +2446,7 @@ static struct usb_device_id rt73usb_device_table[] = {
 	{ USB_DEVICE(0x04bb, 0x093d), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2671), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x0812, 0x3101), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Qcom */
 	{ USB_DEVICE(0x18e8, 0x6196), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x18e8, 0x6229), USB_DEVICE_DATA(&rt73usb_ops) },
diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 0fa36aa..1758d44 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -619,6 +619,13 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 					struct sk_buff *uskb = NULL;
 					u8 *pdata;
 					uskb = dev_alloc_skb(skb->len + 128);
+					if (!uskb) {
+						RT_TRACE(rtlpriv,
+							(COMP_INTR | COMP_RECV),
+							DBG_EMERG,
+							("can't alloc rx skb\n"));
+						goto done;
+					}
 					memcpy(IEEE80211_SKB_RXCB(uskb),
 							&rx_status,
 							sizeof(rx_status));
@@ -641,7 +648,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 			new_skb = dev_alloc_skb(rtlpci->rxbuffersize);
 			if (unlikely(!new_skb)) {
 				RT_TRACE(rtlpriv, (COMP_INTR | COMP_RECV),
-					 DBG_DMESG,
+					 DBG_EMERG,
 					 ("can't alloc skb for rx\n"));
 				goto done;
 			}
@@ -1066,9 +1073,9 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw)
 			struct sk_buff *skb =
 			    dev_alloc_skb(rtlpci->rxbuffersize);
 			u32 bufferaddress;
-			entry = &rtlpci->rx_ring[rx_queue_idx].desc[i];
 			if (!skb)
 				return 0;
+			entry = &rtlpci->rx_ring[rx_queue_idx].desc[i];
 
 			/*skb->dev = dev; */
 
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index a29feb0..d2cf884 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -184,6 +184,7 @@ struct hci_conn {
 	__u32		 link_mode;
 	__u8             auth_type;
 	__u8             sec_level;
+	__u8		 pending_sec_level;
 	__u8             power_save;
 	__u16            disc_timeout;
 	unsigned long	 pend;
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 6b90a41..99cd8d9 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -379,14 +379,10 @@ struct hci_conn *hci_connect(struct hci_dev *hdev, int type, bdaddr_t *dst, __u8
 	hci_conn_hold(acl);
 
 	if (acl->state == BT_OPEN || acl->state == BT_CLOSED) {
-		acl->sec_level = sec_level;
+		acl->sec_level = BT_SECURITY_LOW;
+		acl->pending_sec_level = sec_level;
 		acl->auth_type = auth_type;
 		hci_acl_connect(acl);
-	} else {
-		if (acl->sec_level < sec_level)
-			acl->sec_level = sec_level;
-		if (acl->auth_type < auth_type)
-			acl->auth_type = auth_type;
 	}
 
 	if (type == ACL_LINK)
@@ -442,11 +438,17 @@ static int hci_conn_auth(struct hci_conn *conn, __u8 sec_level, __u8 auth_type)
 {
 	BT_DBG("conn %p", conn);
 
+	if (conn->pending_sec_level > sec_level)
+		sec_level = conn->pending_sec_level;
+
 	if (sec_level > conn->sec_level)
-		conn->sec_level = sec_level;
+		conn->pending_sec_level = sec_level;
 	else if (conn->link_mode & HCI_LM_AUTH)
 		return 1;
 
+	/* Make sure we preserve an existing MITM requirement*/
+	auth_type |= (conn->auth_type & 0x01);
+
 	conn->auth_type = auth_type;
 
 	if (!test_and_set_bit(HCI_CONN_AUTH_PEND, &conn->pend)) {
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 8b602d8..9c4541b 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1011,6 +1011,10 @@ int hci_unregister_dev(struct hci_dev *hdev)
 
 	destroy_workqueue(hdev->workqueue);
 
+	hci_dev_lock_bh(hdev);
+	hci_blacklist_clear(hdev);
+	hci_dev_unlock_bh(hdev);
+
 	__hci_dev_put(hdev);
 
 	return 0;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 3810017..a290854 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -692,13 +692,13 @@ static int hci_outgoing_auth_needed(struct hci_dev *hdev,
 	if (conn->state != BT_CONFIG || !conn->out)
 		return 0;
 
-	if (conn->sec_level == BT_SECURITY_SDP)
+	if (conn->pending_sec_level == BT_SECURITY_SDP)
 		return 0;
 
 	/* Only request authentication for SSP connections or non-SSP
 	 * devices with sec_level HIGH */
 	if (!(hdev->ssp_mode > 0 && conn->ssp_mode > 0) &&
-					conn->sec_level != BT_SECURITY_HIGH)
+				conn->pending_sec_level != BT_SECURITY_HIGH)
 		return 0;
 
 	return 1;
@@ -1095,9 +1095,10 @@ static inline void hci_auth_complete_evt(struct hci_dev *hdev, struct sk_buff *s
 
 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(ev->handle));
 	if (conn) {
-		if (!ev->status)
+		if (!ev->status) {
 			conn->link_mode |= HCI_LM_AUTH;
-		else
+			conn->sec_level = conn->pending_sec_level;
+		} else
 			conn->sec_level = BT_SECURITY_LOW;
 
 		clear_bit(HCI_CONN_AUTH_PEND, &conn->pend);
diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
index c791fcd..7550abb 100644
--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -305,33 +305,44 @@ static void l2cap_chan_del(struct sock *sk, int err)
 	}
 }
 
-/* Service level security */
-static inline int l2cap_check_security(struct sock *sk)
+static inline u8 l2cap_get_auth_type(struct sock *sk)
 {
-	struct l2cap_conn *conn = l2cap_pi(sk)->conn;
-	__u8 auth_type;
+	if (sk->sk_type == SOCK_RAW) {
+		switch (l2cap_pi(sk)->sec_level) {
+		case BT_SECURITY_HIGH:
+			return HCI_AT_DEDICATED_BONDING_MITM;
+		case BT_SECURITY_MEDIUM:
+			return HCI_AT_DEDICATED_BONDING;
+		default:
+			return HCI_AT_NO_BONDING;
+		}
+	} else if (l2cap_pi(sk)->psm == cpu_to_le16(0x0001)) {
+		if (l2cap_pi(sk)->sec_level == BT_SECURITY_LOW)
+			l2cap_pi(sk)->sec_level = BT_SECURITY_SDP;
 
-	if (l2cap_pi(sk)->psm == cpu_to_le16(0x0001)) {
 		if (l2cap_pi(sk)->sec_level == BT_SECURITY_HIGH)
-			auth_type = HCI_AT_NO_BONDING_MITM;
+			return HCI_AT_NO_BONDING_MITM;
 		else
-			auth_type = HCI_AT_NO_BONDING;
-
-		if (l2cap_pi(sk)->sec_level == BT_SECURITY_LOW)
-			l2cap_pi(sk)->sec_level = BT_SECURITY_SDP;
+			return HCI_AT_NO_BONDING;
 	} else {
 		switch (l2cap_pi(sk)->sec_level) {
 		case BT_SECURITY_HIGH:
-			auth_type = HCI_AT_GENERAL_BONDING_MITM;
-			break;
+			return HCI_AT_GENERAL_BONDING_MITM;
 		case BT_SECURITY_MEDIUM:
-			auth_type = HCI_AT_GENERAL_BONDING;
-			break;
+			return HCI_AT_GENERAL_BONDING;
 		default:
-			auth_type = HCI_AT_NO_BONDING;
-			break;
+			return HCI_AT_NO_BONDING;
 		}
 	}
+}
+
+/* Service level security */
+static inline int l2cap_check_security(struct sock *sk)
+{
+	struct l2cap_conn *conn = l2cap_pi(sk)->conn;
+	__u8 auth_type;
+
+	auth_type = l2cap_get_auth_type(sk);
 
 	return hci_conn_security(conn->hcon, l2cap_pi(sk)->sec_level,
 								auth_type);
@@ -1068,39 +1079,7 @@ static int l2cap_do_connect(struct sock *sk)
 
 	err = -ENOMEM;
 
-	if (sk->sk_type == SOCK_RAW) {
-		switch (l2cap_pi(sk)->sec_level) {
-		case BT_SECURITY_HIGH:
-			auth_type = HCI_AT_DEDICATED_BONDING_MITM;
-			break;
-		case BT_SECURITY_MEDIUM:
-			auth_type = HCI_AT_DEDICATED_BONDING;
-			break;
-		default:
-			auth_type = HCI_AT_NO_BONDING;
-			break;
-		}
-	} else if (l2cap_pi(sk)->psm == cpu_to_le16(0x0001)) {
-		if (l2cap_pi(sk)->sec_level == BT_SECURITY_HIGH)
-			auth_type = HCI_AT_NO_BONDING_MITM;
-		else
-			auth_type = HCI_AT_NO_BONDING;
-
-		if (l2cap_pi(sk)->sec_level == BT_SECURITY_LOW)
-			l2cap_pi(sk)->sec_level = BT_SECURITY_SDP;
-	} else {
-		switch (l2cap_pi(sk)->sec_level) {
-		case BT_SECURITY_HIGH:
-			auth_type = HCI_AT_GENERAL_BONDING_MITM;
-			break;
-		case BT_SECURITY_MEDIUM:
-			auth_type = HCI_AT_GENERAL_BONDING;
-			break;
-		default:
-			auth_type = HCI_AT_NO_BONDING;
-			break;
-		}
-	}
+	auth_type = l2cap_get_auth_type(sk);
 
 	hcon = hci_connect(hdev, ACL_LINK, dst,
 					l2cap_pi(sk)->sec_level, auth_type);
@@ -1127,7 +1106,8 @@ static int l2cap_do_connect(struct sock *sk)
 		if (sk->sk_type != SOCK_SEQPACKET &&
 				sk->sk_type != SOCK_STREAM) {
 			l2cap_sock_clear_timer(sk);
-			sk->sk_state = BT_CONNECTED;
+			if (l2cap_check_security(sk))
+				sk->sk_state = BT_CONNECTED;
 		} else
 			l2cap_do_start(sk);
 	}
@@ -1893,8 +1873,8 @@ static int l2cap_sock_sendmsg(struct kiocb *iocb, struct socket *sock, struct ms
 		if (pi->mode == L2CAP_MODE_STREAMING) {
 			l2cap_streaming_send(sk);
 		} else {
-			if (pi->conn_state & L2CAP_CONN_REMOTE_BUSY &&
-					pi->conn_state && L2CAP_CONN_WAIT_F) {
+			if ((pi->conn_state & L2CAP_CONN_REMOTE_BUSY) &&
+					(pi->conn_state & L2CAP_CONN_WAIT_F)) {
 				err = len;
 				break;
 			}
diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index ff8aaa7..6b83776 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -1164,7 +1164,8 @@ static int rfcomm_recv_ua(struct rfcomm_session *s, u8 dlci)
 			 * initiator rfcomm_process_rx already calls
 			 * rfcomm_session_put() */
 			if (s->sock->sk->sk_state != BT_CLOSED)
-				rfcomm_session_put(s);
+				if (list_empty(&s->dlcs))
+					rfcomm_session_put(s);
 			break;
 		}
 	}
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5950e3a..b64b42b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2230,6 +2230,9 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 
 	sdata = vif_to_sdata(vif);
 
+	if (!ieee80211_sdata_running(sdata))
+		goto out;
+
 	if (tim_offset)
 		*tim_offset = 0;
 	if (tim_length)
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
