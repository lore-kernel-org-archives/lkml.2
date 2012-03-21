Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239Ab2CUPcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:32:11 -0400
Received: from mail.vyatta.com ([76.74.103.46]:58005 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119Ab2CUPcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:32:08 -0400
Date: Wed, 21 Mar 2012 08:32:05 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Knut Petersen <Knut_Petersen@t-online.de>,
        "David S. Miller" <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, arekm@maven.pl,
        Jared <nitro@legroom.net>, dilieto@lineone.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] sky2: override for PCI legacy power management
Message-ID: <20120321083205.360a7a3b@nehalam.linuxnetplumber.net>
In-Reply-To: <4F69BE2E.7070903@t-online.de>
References: <4F69BE2E.7070903@t-online.de>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some BIOS's don't setup power management correctly (what else is
new) and don't allow use of PCI Express power control. Add a special
exception module parameter to allow working around this issue.
Based on slightly different patch by Knut Petersen.

Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
---
Patch against -net (ie. 3.3.0)

--- a/drivers/net/ethernet/marvell/sky2.c	2012-01-10 10:56:56.855156017 -0800
+++ b/drivers/net/ethernet/marvell/sky2.c	2012-03-21 08:25:52.400929532 -0700
@@ -95,6 +95,10 @@ static int disable_msi = 0;
 module_param(disable_msi, int, 0);
 MODULE_PARM_DESC(disable_msi, "Disable Message Signaled Interrupt (MSI)");
 
+static int legacy_pme = 0;
+module_param(legacy_pme, int, 0);
+MODULE_PARM_DESC(legacy_pme, "Legacy power management");
+
 static DEFINE_PCI_DEVICE_TABLE(sky2_id_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SYSKONNECT, 0x9000) }, /* SK-9Sxx */
 	{ PCI_DEVICE(PCI_VENDOR_ID_SYSKONNECT, 0x9E00) }, /* SK-9Exx */
@@ -867,6 +871,13 @@ static void sky2_wol_init(struct sky2_po
 	/* Disable PiG firmware */
 	sky2_write16(hw, B0_CTST, Y2_HW_WOL_OFF);
 
+	/* Needed by some broken BIOSes, use PCI rather than PCI-e for WOL */
+	if (legacy_pme) {
+		u32 reg1 = sky2_pci_read32(hw, PCI_DEV_REG1);
+		reg1 |= PCI_Y2_PME_LEGACY;
+		sky2_pci_write32(hw, PCI_DEV_REG1, reg1);
+	}
+
 	/* block receiver */
 	sky2_write8(hw, SK_REG(port, RX_GMF_CTRL_T), GMF_RST_SET);
 	sky2_read32(hw, B0_CTST);
