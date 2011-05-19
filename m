Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903Ab1ESSXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:23:25 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47239 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933850Ab1ESSH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:07:57 -0400
X-Sasl-enc: sB9xtvD3eCpsVNAuW/QsPyy4OExHrKWDDvRudzYIvezV 1305828476
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:55 2011
Message-Id: <20110519180555.450377572@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
        kernel@lists.fedoraproject.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kyle McMartin <kmcmartin@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [12/71] iwlwifi: add {ack, plpc}_check module parameters
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit b7977ffaab5187ad75edaf04ac854615cea93828 upstream.

Add module ack_check, and plcp_check parameters. Ack_check is disabled
by default since is proved that check ack health can cause troubles.
Plcp_check is enabled by default.

This prevent connection hangs with "low ack count detected" messages.

Resolves:
https://bugzilla.redhat.com/show_bug.cgi?id=666646

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-core.h    |    2 ++
 drivers/net/wireless/iwlwifi/iwl-rx.c      |    8 ++++++--
 4 files changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -604,6 +604,7 @@ const u8 *iwlagn_eeprom_query_addr(const
 struct iwl_mod_params iwlagn_mod_params = {
 	.amsdu_size_8K = 1,
 	.restart_fw = 1,
+	.plcp_check = true,
 	/* the rest are 0 by default */
 };
 
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4586,3 +4586,9 @@ MODULE_PARM_DESC(antenna_coupling,
 module_param_named(bt_ch_inhibition, iwlagn_bt_ch_announce, bool, S_IRUGO);
 MODULE_PARM_DESC(bt_ch_inhibition,
 		 "Disable BT channel inhibition (default: enable)");
+
+module_param_named(plcp_check, iwlagn_mod_params.plcp_check, bool, S_IRUGO);
+MODULE_PARM_DESC(plcp_check, "Check plcp health (default: 1 [enabled])");
+
+module_param_named(ack_check, iwlagn_mod_params.ack_check, bool, S_IRUGO);
+MODULE_PARM_DESC(ack_check, "Check ack health (default: 0 [disabled])");
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -263,6 +263,8 @@ struct iwl_mod_params {
 	int amsdu_size_8K;	/* def: 1 = enable 8K amsdu size */
 	int antenna;  		/* def: 0 = both antennas (use diversity) */
 	int restart_fw;		/* def: 1 = restart firmware */
+	bool plcp_check;	/* def: true = enable plcp health check */
+	bool ack_check;		/* def: false = disable ack health check */
 };
 
 /*
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -234,10 +234,13 @@ EXPORT_SYMBOL(iwl_rx_spectrum_measure_no
 void iwl_recover_from_statistics(struct iwl_priv *priv,
 				struct iwl_rx_packet *pkt)
 {
+	const struct iwl_mod_params *mod_params = priv->cfg->mod_params;
+
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 	if (iwl_is_any_associated(priv)) {
-		if (priv->cfg->ops->lib->check_ack_health) {
+		if (mod_params->ack_check &&
+		    priv->cfg->ops->lib->check_ack_health) {
 			if (!priv->cfg->ops->lib->check_ack_health(
 			    priv, pkt)) {
 				/*
@@ -250,7 +253,8 @@ void iwl_recover_from_statistics(struct
 					return;
 			}
 		}
-		if (priv->cfg->ops->lib->check_plcp_health) {
+		if (mod_params->plcp_check &&
+		    priv->cfg->ops->lib->check_plcp_health) {
 			if (!priv->cfg->ops->lib->check_plcp_health(
 			    priv, pkt)) {
 				/*


