Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506Ab1C3WIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:08:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:53540 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933184Ab1C3VGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447185"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: sgruszka@redhat.com, wey-yi.w.guy@intel.com, linville@tuxdriver.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [35/275] iwlagn: enable only rfkill interrupt when device is down
Message-Id: <20110330210430.8BB013E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    9 +++++----
 drivers/net/wireless/iwlwifi/iwl-helpers.h |    6 ++++++
 2 files changed, 11 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/drivers/net/wireless/iwlwifi/iwl-agn.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-03-29 22:51:54.909318176 -0700
+++ linux-2.6.35.y/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-03-29 23:55:19.919957475 -0700
@@ -3112,9 +3112,10 @@
 
 	flush_workqueue(priv->workqueue);
 
-	/* enable interrupts again in order to receive rfkill changes */
+	/* User space software may expect getting rfkill changes
+	 * even if interface is down */
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
-	iwl_enable_interrupts(priv);
+	iwl_enable_rfkill_int(priv);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
@@ -3832,14 +3833,14 @@
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
Index: linux-2.6.35.y/drivers/net/wireless/iwlwifi/iwl-helpers.h
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/iwlwifi/iwl-helpers.h	2011-03-29 22:51:54.908318202 -0700
+++ linux-2.6.35.y/drivers/net/wireless/iwlwifi/iwl-helpers.h	2011-03-29 23:02:58.917327873 -0700
@@ -163,6 +163,12 @@
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
