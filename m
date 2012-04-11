Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933988Ab2DKXvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:51:41 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:63303 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964954Ab2DKXSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:18:04 -0400
Message-Id: <20120411231029.344840735@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 65/78] iwlegacy: do not nulify il->vif on reset
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 883a649b737cdbe3ede7e50f3f939fd706ed5c4e upstream.

This il->vif is dereferenced in different part of iwlegacy code, so do
not nullify it. This should fix random crashes observed in companion
with microcode errors i.e. crash in il3945_config_ap().

Additionally this should address also
WARNING: at drivers/net/wireless/iwlegacy/common.c:4656 il_mac_remove_interface
at least one of the possible reasons of that warning.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlegacy/3945-mac.c |    1 -
 drivers/net/wireless/iwlegacy/4965-mac.c |    1 -
 drivers/net/wireless/iwlegacy/common.c   |   18 ++++++++++++++++--
 3 files changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -2684,7 +2684,6 @@ il3945_bg_restart(struct work_struct *da
 
 	if (test_and_clear_bit(S_FW_ERROR, &il->status)) {
 		mutex_lock(&il->mutex);
-		il->ctx.vif = NULL;
 		il->is_open = 0;
 		mutex_unlock(&il->mutex);
 		il3945_down(il);
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5381,7 +5381,6 @@ il4965_bg_restart(struct work_struct *da
 
 	if (test_and_clear_bit(S_FW_ERROR, &il->status)) {
 		mutex_lock(&il->mutex);
-		il->ctx.vif = NULL;
 		il->is_open = 0;
 
 		__il4965_down(il);
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4575,6 +4575,7 @@ il_mac_add_interface(struct ieee80211_hw
 	struct il_priv *il = hw->priv;
 	struct il_vif_priv *vif_priv = (void *)vif->drv_priv;
 	int err;
+	bool reset;
 	u32 modes;
 
 	D_MAC80211("enter: type %d, addr %pM\n", vif->type, vif->addr);
@@ -4594,6 +4595,16 @@ il_mac_add_interface(struct ieee80211_hw
 		goto out;
 	}
 
+	/*
+	 * We do not support multiple virtual interfaces, but on hardware reset
+	 * we have to add the same interface again.
+	 */
+	reset = (il->ctx.vif == vif);
+	if (il->ctx.vif && !reset) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	modes = il->ctx.interface_modes | il->ctx.exclusive_interface_modes;
 	if (!(modes & BIT(vif->type))) {
 		err = -EOPNOTSUPP;
@@ -4605,8 +4616,11 @@ il_mac_add_interface(struct ieee80211_hw
 
 	err = il_setup_interface(il, &il->ctx);
 	if (err) {
-		il->ctx.vif = NULL;
-		il->iw_mode = NL80211_IFTYPE_STATION;
+		IL_WARN("Fail to set mode %d\n", vif->type);
+		if (!reset) {
+			il->ctx.vif = NULL;
+			il->iw_mode = NL80211_IFTYPE_STATION;
+		}
 	}
 
 out:


