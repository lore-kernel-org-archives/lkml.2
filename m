Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab0KHVyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:54:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33943 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab0KHVyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:54:44 -0500
From: Andi Kleen <andi@firstfloor.org>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Johannes.berg@intel.com
Subject: [PATCH] iwl3945: Fix oops at module load
Date: Mon,  8 Nov 2010 22:54:31 +0100
Message-Id: <1289253271-19981-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

On my laptop the iwl3945 driver oopsed at boot with 2.6.37-rc1
in __dev_printk.

The problem is that for some reason it prints the sw scan
warning, but does that before the pci device is initialized
in the driver private structure. This leads to an oops
in the warning print code.

Move the warning after the device has been initialized.

Cc: Johannes.berg@intel.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 8f8c4b7..3910ec2 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3995,6 +3995,11 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->contexts[IWL_RXON_CTX_BSS].station_devtype = RXON_DEV_TYPE_ESS;
 	priv->contexts[IWL_RXON_CTX_BSS].unused_devtype = RXON_DEV_TYPE_ESS;
 
+	IWL_DEBUG_INFO(priv, "*** LOAD DRIVER ***\n");
+	priv->cfg = cfg;
+	priv->pci_dev = pdev;
+	priv->inta_mask = CSR_INI_SET_MASK;
+
 	/*
 	 * Disabling hardware scan means that mac80211 will perform scans
 	 * "the hard way", rather than using device's scan.
@@ -4004,12 +4009,6 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		iwl3945_hw_ops.hw_scan = NULL;
 	}
 
-
-	IWL_DEBUG_INFO(priv, "*** LOAD DRIVER ***\n");
-	priv->cfg = cfg;
-	priv->pci_dev = pdev;
-	priv->inta_mask = CSR_INI_SET_MASK;
-
 	if (iwl_alloc_traffic_mem(priv))
 		IWL_ERR(priv, "Not enough memory to generate traffic log\n");
 
-- 
1.7.1

