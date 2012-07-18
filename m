Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754Ab2GRALL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:11:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757475Ab2GRAEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:04:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Bolle <pebolle@tiscali.nl>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 17/37] iwlegacy: dont mess up the SCD when removing a key
Date: Tue, 17 Jul 2012 17:02:54 -0700
Message-Id: <20120717232432.764054845@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232431.399005532@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232431.399005532@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlegacy/4965-mac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -3405,7 +3405,7 @@ il4965_remove_dynamic_key(struct il_priv
 		return 0;
 	}
 
-	if (il->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET) {
+	if (il->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_INVALID) {
 		IL_WARN("Removing wrong key %d 0x%x\n", keyconf->keyidx,
 			key_flags);
 		spin_unlock_irqrestore(&il->sta_lock, flags);
@@ -3420,7 +3420,7 @@ il4965_remove_dynamic_key(struct il_priv
 	memset(&il->stations[sta_id].sta.key, 0, sizeof(struct il4965_keyinfo));
 	il->stations[sta_id].sta.key.key_flags =
 	    STA_KEY_FLG_NO_ENC | STA_KEY_FLG_INVALID;
-	il->stations[sta_id].sta.key.key_offset = WEP_INVALID_OFFSET;
+	il->stations[sta_id].sta.key.key_offset = keyconf->hw_key_idx;
 	il->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	il->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 


