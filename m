Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161384Ab1FAIJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:09:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:43305 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161370Ab1FAIJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:09:18 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:00 2011
Message-Id: <20110601080259.927195947@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:30 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [034/146] iwlwifi: fix bugs in change_interface
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit a2b76b3b31568da9d281a393845f17689594ccdf upstream.

If change_interface gets invoked during a firmware
restart, it may crash; prevent that from happening
by checking if ctx->vif is assigned.

Additionally, in my initial commit I forgot to set
the vif->p2p variable correctly, so fix that too.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-core.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1879,6 +1879,15 @@ int iwl_mac_change_interface(struct ieee
 
 	mutex_lock(&priv->mutex);
 
+	if (!ctx->vif || !iwl_is_ready_rf(priv)) {
+		/*
+		 * Huh? But wait ... this can maybe happen when
+		 * we're in the middle of a firmware restart!
+		 */
+		err = -EBUSY;
+		goto out;
+	}
+
 	interface_modes = ctx->interface_modes | ctx->exclusive_interface_modes;
 
 	if (!(interface_modes & BIT(newtype))) {
@@ -1906,6 +1915,7 @@ int iwl_mac_change_interface(struct ieee
 	/* success */
 	iwl_teardown_interface(priv, vif, true);
 	vif->type = newtype;
+	vif->p2p = newp2p;
 	err = iwl_setup_interface(priv, ctx);
 	WARN_ON(err);
 	/*


