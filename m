Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162466Ab2GLXB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:01:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162030Ab2GLWmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:42:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 123/187] iwlwifi: fix activating inactive stations
Date: Thu, 12 Jul 2012 15:34:39 -0700
Message-Id: <20120712191533.768080742@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit eac9ac6d1f5d0e9d33e4ded682187b630e7606cd upstream.

When authentication/association timed out, the driver would
complain bitterly, printing the message
ACTIVATE a non DRIVER active station id ... addr ...

The cause turns out to be that when the AP station is added
but we don't associate, the IWL_STA_UCODE_INPROGRESS is set
but never cleared. This then causes iwl_restore_stations()
to attempt to resend it because it uses the flag internally
and uploads even if it didn't set it itself.

To fix this issue and not upload the station again when it
has already been removed by mac80211, clear the flag after
adding it in case we add it only for association.

Reviewed-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -788,6 +788,18 @@ static int iwlagn_mac_sta_state(struct i
 	switch (op) {
 	case ADD:
 		ret = iwlagn_mac_sta_add(hw, vif, sta);
+		if (ret)
+			break;
+		/*
+		 * Clear the in-progress flag, the AP station entry was added
+		 * but we'll initialize LQ only when we've associated (which
+		 * would also clear the in-progress flag). This is necessary
+		 * in case we never initialize LQ because association fails.
+		 */
+		spin_lock_bh(&priv->sta_lock);
+		priv->stations[iwl_sta_id(sta)].used &=
+			~IWL_STA_UCODE_INPROGRESS;
+		spin_unlock_bh(&priv->sta_lock);
 		break;
 	case REMOVE:
 		ret = iwlagn_mac_sta_remove(hw, vif, sta);


