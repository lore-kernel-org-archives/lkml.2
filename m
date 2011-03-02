Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab1CBG2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 01:28:06 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49558 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab1CBG2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 01:28:03 -0500
Date: Wed, 2 Mar 2011 17:27:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Arend van Spriel <arend@broadcom.com>,
        Roland Vossen <rvossen@broadcom.com>
Subject: linux-next: manual merge of the staging tree with the wireless tree
Message-Id: <20110302172754.412dca34.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/brcm80211/brcmsmac/wl_mac80211.c between commit
7bb4568372856688bc070917265bce0b88bb7d4d ("mac80211: make tx() operation
return void") from the wireless tree (where this file is called
drivers/staging/brcm80211/sys/wl_mac80211.c) and commits
62b54dca17ef40116491b0ca27ca35fbe9daedc6 ("staging: brcm80211: cleanup
function prototypes in header files") and
55182a10063c40eda4dc5afecff712e5c3617ffc ("staging: brcm80211: cosmetic
changes") from the staging tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 6363077,6059e4c..0000000
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@@ -104,7 -75,16 +75,13 @@@ static int wl_request_fw(struct wl_inf
  static void wl_release_fw(struct wl_info *wl);
  
  /* local prototypes */
 -static int wl_start(struct sk_buff *skb, struct wl_info *wl);
 -static int wl_start_int(struct wl_info *wl, struct ieee80211_hw *hw,
 -			struct sk_buff *skb);
  static void wl_dpc(unsigned long data);
+ static irqreturn_t wl_isr(int irq, void *dev_id);
+ 
+ static int __devinit wl_pci_probe(struct pci_dev *pdev,
+ 				  const struct pci_device_id *ent);
+ static void wl_remove(struct pci_dev *pdev);
+ static void wl_free(struct wl_info *wl);
  
  MODULE_AUTHOR("Broadcom Corporation");
  MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN driver.");
@@@ -132,6 -110,9 +107,8 @@@ module_param(phymsglevel, int, 0)
  
  #define HW_TO_WL(hw)	 (hw->priv)
  #define WL_TO_HW(wl)	  (wl->pub->ieee_hw)
+ 
+ /* MAC80211 callback functions */
 -static int wl_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
  static int wl_ops_start(struct ieee80211_hw *hw);
  static void wl_ops_stop(struct ieee80211_hw *hw);
  static int wl_ops_add_interface(struct ieee80211_hw *hw,
@@@ -161,17 -142,22 +138,21 @@@ static void wl_ops_sta_notify(struct ie
  static int wl_ops_conf_tx(struct ieee80211_hw *hw, u16 queue,
  			  const struct ieee80211_tx_queue_params *params);
  static u64 wl_ops_get_tsf(struct ieee80211_hw *hw);
- static int wl_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+ static int wl_ops_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
  		      struct ieee80211_sta *sta);
- static int wl_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+ static int wl_ops_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
  			 struct ieee80211_sta *sta);
- static int wl_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
- 			   enum ieee80211_ampdu_mlme_action action,
- 			   struct ieee80211_sta *sta, u16 tid, u16 *ssn);
+ static int wl_ops_ampdu_action(struct ieee80211_hw *hw,
+ 			       struct ieee80211_vif *vif,
+ 			       enum ieee80211_ampdu_mlme_action action,
+ 			       struct ieee80211_sta *sta, u16 tid, u16 *ssn,
+ 			       u8 buf_size);
+ static void wl_ops_rfkill_poll(struct ieee80211_hw *hw);
  
 -static int wl_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 +static void wl_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
  {
 -	int status;
  	struct wl_info *wl = hw->priv;
+ 
  	WL_LOCK(wl);
  	if (!wl->pub->up) {
  		WL_ERROR("ops->tx called while down\n");
@@@ -1319,6 -1401,28 +1395,9 @@@ static void wl_free(struct wl_info *wl
  	osl_detach(osh);
  }
  
+ /*
 - * transmit a packet
 - * precondition: perimeter lock has been acquired
 - */
 -static int BCMFASTPATH wl_start(struct sk_buff *skb, struct wl_info *wl)
 -{
 -	if (!wl)
 -		return -ENETDOWN;
 -
 -	return wl_start_int(wl, WL_TO_HW(wl), skb);
 -}
 -
 -static int BCMFASTPATH
 -wl_start_int(struct wl_info *wl, struct ieee80211_hw *hw, struct sk_buff *skb)
 -{
 -	wlc_sendpkt_mac80211(wl->wlc, skb, hw);
 -	return NETDEV_TX_OK;
 -}
 -
 -/*
+  * precondition: perimeter lock has been acquired
+  */
  void wl_txflowcontrol(struct wl_info *wl, struct wl_if *wlif, bool state,
  		      int prio)
  {
