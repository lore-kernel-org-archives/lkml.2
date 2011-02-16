Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985Ab1BPBn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:43:58 -0500
Received: from kroah.org ([198.145.64.141]:38858 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756848Ab1BPAT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:19:29 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:30 2011
Message-Id: <20110216001430.636935930@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [055/272] iwlagn: enable only rfkill interrupt when device is down
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 554d1d027b19265c4aa3f718b3126d2b86e09a08 upstream.

Since commit 6cd0b1cb872b3bf9fc5de4536404206ab74bafdd "iwlagn: fix
hw-rfkill while the interface is down", we enable interrupts when
device is not ready to receive them. However hardware, when it is in
some inconsistent state, can generate other than rfkill interrupts
and crash the system. I can reproduce crash with "kernel BUG at
drivers/net/wireless/iwlwifi/iwl-agn.c:1010!" message, when forcing
firmware restarts.

To fix only enable rfkill interrupt when down device and after probe.
I checked patch on laptop with 5100 device, rfkill change is still
passed to user space when device is down.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    9 +++++----
 drivers/net/wireless/iwlwifi/iwl-helpers.h |    6 ++++++
 2 files changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3530,9 +3530,10 @@ static void iwl_mac_stop(struct ieee8021
 
 	flush_workqueue(priv->workqueue);
 
-	/* enable interrupts again in order to receive rfkill changes */
+	/* User space software may expect getting rfkill changes
+	 * even if interface is down */
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
-	iwl_enable_interrupts(priv);
+	iwl_enable_rfkill_int(priv);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
@@ -4515,14 +4516,14 @@ static int iwl_pci_probe(struct pci_dev
 	 * 8. Enable interrupts and read RFKILL state
 	 *********************************************/
 
-	/* enable interrupts if needed: hw bug w/a */
+	/* enable rfkill interrupt: hw bug w/a */
 	pci_read_config_word(priv->pci_dev, PCI_COMMAND, &pci_cmd);
 	if (pci_cmd & PCI_COMMAND_INTX_DISABLE) {
 		pci_cmd &= ~PCI_COMMAND_INTX_DISABLE;
 		pci_write_config_word(priv->pci_dev, PCI_COMMAND, pci_cmd);
 	}
 
-	iwl_enable_interrupts(priv);
+	iwl_enable_rfkill_int(priv);
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
 	if (iwl_read32(priv, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -163,6 +163,12 @@ static inline void iwl_disable_interrupt
 	IWL_DEBUG_ISR(priv, "Disabled interrupts\n");
 }
 
+static inline void iwl_enable_rfkill_int(struct iwl_priv *priv)
+{
+	IWL_DEBUG_ISR(priv, "Enabling rfkill interrupt\n");
+	iwl_write32(priv, CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
+}
+
 static inline void iwl_enable_interrupts(struct iwl_priv *priv)
 {
 	IWL_DEBUG_ISR(priv, "Enabling interrupts\n");


