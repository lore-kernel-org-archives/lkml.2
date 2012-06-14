Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab2FOAGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:06:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814Ab2FNX7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:59:44 -0400
Message-Id: <20120614235625.526099208@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 18/42] iwlwifi: dont mess up the SCD when removing a key
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -1222,7 +1222,7 @@ int iwl_remove_dynamic_key(struct iwl_pr
 		key_flags |= STA_KEY_MULTICAST_MSK;
 
 	sta_cmd.key.key_flags = key_flags;
-	sta_cmd.key.key_offset = WEP_INVALID_OFFSET;
+	sta_cmd.key.key_offset = keyconf->hw_key_idx;
 	sta_cmd.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	sta_cmd.mode = STA_CONTROL_MODIFY_MSK;
 


