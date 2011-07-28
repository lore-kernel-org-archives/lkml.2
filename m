Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab1G1XpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:45:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:29735 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203Ab1G1Xos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="33352130"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: Larry.Finger@lwfinger.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [43/50] staging: r8192e_pci: Handle duplicate PCI ID 0x10ec:0x8192
Message-Id: <20110728234448.13F172403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Larry Finger <Larry.Finger@lwfinger.net>

[ upstream commit 1c50bf7e415cf6ce9545dbecc2ac0d89d3916c53 ]
 conflict with rtl8192se

There are two devices with PCI ID 0x10ec:0x8192, namely RTL8192E and
RTL8192SE. The method of distinguishing them is by the revision ID
at offset 0x8 of the PCI configuration space. If the value is 0x10,
then the device uses rtl8192se for a driver.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/staging/rtl8192e/r8192E_core.c
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/rtl8192e/r8192E_core.c
+++ linux-2.6.35.y/drivers/staging/rtl8192e/r8192E_core.c
@@ -6334,6 +6334,7 @@ static int __devinit rtl8192_pci_probe(s
 	struct net_device *dev = NULL;
 	struct r8192_priv *priv= NULL;
 	u8 unit = 0;
+	u8 revisionid;
 
 #ifdef CONFIG_RTL8192_IO_MAP
 	unsigned long pio_start, pio_len, pio_flags;
@@ -6423,6 +6424,11 @@ static int __devinit rtl8192_pci_probe(s
          pci_write_config_byte(pdev, 0x41, 0x00);
 
 
+	pci_read_config_byte(pdev, 0x08, &revisionid);
+	/* If the revisionid is 0x10, the device uses rtl8192se. */
+	if (pdev->device == 0x8192 && revisionid == 0x10)
+		goto fail1;
+
 	pci_read_config_byte(pdev, 0x05, &unit);
 	pci_write_config_byte(pdev, 0x05, unit & (~0x04));
 
