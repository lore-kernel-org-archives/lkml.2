Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab1LGQ2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:28:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757849Ab1LGQZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:25:50 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:22 2011
Message-Id: <20111207161222.409553047@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:12:35 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Johannes Berg <johannes.berg@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [093/104] iwlagn: fix HW crypto for TX-only keys
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 274b89ca3b006926cb9b45d78ab5906f4c0fc0aa upstream.

Group keys in IBSS or AP mode are not programmed
into the device since we give the key to it with
every TX packet. However, we do need mac80211 to
create the MMIC & PN in all cases. Move the code
around to set the key flags all the time. We set
them even when the key is removed again but that
is obviously harmless.

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |    5 -----
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   11 +++++++++++
 2 files changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -440,9 +440,6 @@ int iwl_set_dynamic_key(struct iwl_priv
 
 	switch (keyconf->cipher) {
 	case WLAN_CIPHER_SUITE_TKIP:
-		keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
-		keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-
 		if (sta)
 			addr = sta->addr;
 		else /* station mode case only */
@@ -455,8 +452,6 @@ int iwl_set_dynamic_key(struct iwl_priv
 					  seq.tkip.iv32, p1k, CMD_SYNC);
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
-		keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-		/* fall through */
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
 		ret = iwlagn_send_sta_key(priv, keyconf, sta_id,
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2793,6 +2793,17 @@ static int iwlagn_mac_set_key(struct iee
 		return -EOPNOTSUPP;
 	}
 
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_TKIP:
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+		/* fall through */
+	case WLAN_CIPHER_SUITE_CCMP:
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+		break;
+	default:
+		break;
+	}
+
 	/*
 	 * We could program these keys into the hardware as well, but we
 	 * don't expect much multicast traffic in IBSS and having keys


