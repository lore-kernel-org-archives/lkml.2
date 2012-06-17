Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428Ab2FQSWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:22:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50127 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757959Ab2FQSWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:15 -0400
Message-Id: <20120617175943.621986751@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 18:59:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 16/69] iwlwifi: dont mess up the SCD when removing a key
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit d6ee27eb13beab94056e0de52d81220058ca2297 upstream.

When we remove a key, we put a key index which was supposed
to tell the fw that we are actually removing the key. But
instead the fw took that index as a valid index and messed
up the SRAM of the device.

This memory corruption on the device mangled the data of
the SCD. The impact on the user is that SCD queue 2 got
stuck after having removed keys.
The message is the log that was printed is:

Queue 2 stuck for 10000ms

This doesn't seem to fix the higher queues that get stuck
from time to time.

Reviewed-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index aea07aa..eb6a8ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -1267,7 +1267,7 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 		key_flags |= STA_KEY_MULTICAST_MSK;
 
 	sta_cmd.key.key_flags = key_flags;
-	sta_cmd.key.key_offset = WEP_INVALID_OFFSET;
+	sta_cmd.key.key_offset = keyconf->hw_key_idx;
 	sta_cmd.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	sta_cmd.mode = STA_CONTROL_MODIFY_MSK;
 


