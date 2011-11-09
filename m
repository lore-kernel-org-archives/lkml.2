Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965536Ab1KJDnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:43:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965518Ab1KJDnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:43:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:57 2011
Message-Id: <20111109213157.389166237@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:33:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [151/264] iwlagn: do not use interruptible waits
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit effd4d9aece9184f526e6556786a94d335e38b71 upstream.

Since the dawn of its time, iwlwifi has used
interruptible waits to wait for synchronous
commands and firmware loading.

This leads to "interesting" bugs, because it
can't actually handle the interruptions; for
example when a command sending is interrupted
it will assume the command completed fully,
and then leave it pending, which leads to all
kinds of trouble when the command finishes
later.

Since there's no easy way to gracefully deal
with interruptions, fix the driver to not use
interruptible waits.

This at least fixes the error
iwlagn 0000:02:00.0: Error: Response NULL in  'REPLY_SCAN_ABORT_CMD'

I have seen in P2P testing, but it is likely
that there are other errors caused by this.

Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>


---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c     |    9 ++-------
 drivers/net/wireless/iwlwifi/iwl-core.c          |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-rx.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c |    4 ++--
 5 files changed, 8 insertions(+), 13 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -113,13 +113,8 @@ static int iwlagn_load_section(struct iw
 		FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
 
 	IWL_DEBUG_FW(priv, "%s uCode section being loaded...\n", name);
-	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
-					priv->ucode_write_complete, 5 * HZ);
-	if (ret == -ERESTARTSYS) {
-		IWL_ERR(priv, "Could not load the %s uCode section due "
-			"to interrupt\n", name);
-		return ret;
-	}
+	ret = wait_event_timeout(priv->wait_command_queue,
+				 priv->ucode_write_complete, 5 * HZ);
 	if (!ret) {
 		IWL_ERR(priv, "Could not load the %s uCode section\n",
 			name);
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -867,7 +867,7 @@ void iwlagn_fw_error(struct iwl_priv *pr
 	 * commands by clearing the ready bit */
 	clear_bit(STATUS_READY, &priv->status);
 
-	wake_up_interruptible(&priv->wait_command_queue);
+	wake_up(&priv->wait_command_queue);
 
 	if (!ondemand) {
 		/*
@@ -918,7 +918,7 @@ void iwl_irq_handle_error(struct iwl_pri
 		 */
 		clear_bit(STATUS_READY, &priv->status);
 		clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
-		wake_up_interruptible(&priv->wait_command_queue);
+		wake_up(&priv->wait_command_queue);
 		IWL_ERR(priv, "RF is used by WiMAX\n");
 		return;
 	}
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -561,7 +561,7 @@ static void iwl_rx_card_state_notif(stru
 		wiphy_rfkill_set_hw_state(priv->hw->wiphy,
 			test_bit(STATUS_RF_KILL_HW, &priv->status));
 	else
-		wake_up_interruptible(&priv->wait_command_queue);
+		wake_up(&priv->wait_command_queue);
 }
 
 static void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -671,7 +671,7 @@ void iwl_irq_tasklet(struct iwl_priv *pr
 		handled |= CSR_INT_BIT_FH_TX;
 		/* Wake up uCode load routine, now that load is complete */
 		priv->ucode_write_complete = 1;
-		wake_up_interruptible(&priv->wait_command_queue);
+		wake_up(&priv->wait_command_queue);
 	}
 
 	if (inta & ~handled) {
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -790,7 +790,7 @@ void iwl_tx_cmd_complete(struct iwl_priv
 		clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 		IWL_DEBUG_INFO(priv, "Clearing HCMD_ACTIVE for command %s\n",
 			       get_cmd_string(cmd->hdr.cmd));
-		wake_up_interruptible(&priv->wait_command_queue);
+		wake_up(&priv->wait_command_queue);
 	}
 
 	meta->flags = 0;
@@ -957,7 +957,7 @@ static int iwl_send_cmd_sync(struct iwl_
 		return ret;
 	}
 
-	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
+	ret = wait_event_timeout(priv->wait_command_queue,
 			!test_bit(STATUS_HCMD_ACTIVE, &priv->status),
 			HOST_COMPLETE_TIMEOUT);
 	if (!ret) {


