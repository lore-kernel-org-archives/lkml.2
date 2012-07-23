Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab2GWBvb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:51:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54376 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753479Ab2GWBnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:24 -0400
Message-Id: <20120723010659.776106843@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:46 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 055/108] iwlegacy: dont mess up the SCD when removing a key
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit b48d96652626b315229b1b82c6270eead6a77a6d upstream.

When we remove a key, we put a key index which was supposed
to tell the fw that we are actually removing the key. But
instead the fw took that index as a valid index and messed
up the SRAM of the device.

This memory corruption on the device mangled the data of
the SCD. The impact on the user is that SCD queue 2 got
stuck after having removed keys.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2: adjust filename, context and variable name]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
@@ -466,7 +466,7 @@ int iwl4965_remove_dynamic_key(struct iw
 		return 0;
 	}
 
-	if (priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET) {
+	if (priv->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_INVALID) {
 		IWL_WARN(priv, "Removing wrong key %d 0x%x\n",
 			    keyconf->keyidx, key_flags);
 		spin_unlock_irqrestore(&priv->sta_lock, flags);
@@ -483,7 +483,7 @@ int iwl4965_remove_dynamic_key(struct iw
 					sizeof(struct iwl4965_keyinfo));
 	priv->stations[sta_id].sta.key.key_flags =
 			STA_KEY_FLG_NO_ENC | STA_KEY_FLG_INVALID;
-	priv->stations[sta_id].sta.key.key_offset = WEP_INVALID_OFFSET;
+	priv->stations[sta_id].sta.key.key_offset = keyconf->hw_key_idx;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 


