Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab0GAVTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:19:07 -0400
Received: from kroah.org ([198.145.64.141]:33091 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759235Ab0GAVPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:07 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:43:00 2010
Message-Id: <20100701174300.739786513@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johannes Berg <johannes.berg@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [168/200] iwlwifi: add missing rcu_read_lock
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 6db6340c42d027b6364d49fa99d69019aca24de4 upstream.

Using ieee80211_find_sta() needs to be under
RCU read lock, which iwlwifi currently misses,
so fix it.

Reported-by: Miles Lane <miles.lane@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Miles Lane <miles.lane@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1198,6 +1198,7 @@ static void iwl_tx_status(struct iwl_pri
 	struct ieee80211_sta *sta;
 	struct iwl_station_priv *sta_priv;
 
+	rcu_read_lock();
 	sta = ieee80211_find_sta(priv->vif, hdr->addr1);
 	if (sta) {
 		sta_priv = (void *)sta->drv_priv;
@@ -1206,6 +1207,7 @@ static void iwl_tx_status(struct iwl_pri
 		    atomic_dec_return(&sta_priv->pending_frames) == 0)
 			ieee80211_sta_block_awake(priv->hw, sta, false);
 	}
+	rcu_read_unlock();
 
 	ieee80211_tx_status_irqsafe(priv->hw, skb);
 }


