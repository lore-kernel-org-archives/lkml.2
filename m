Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936256Ab2C3Vgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:36:40 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58309 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966208Ab2C3Vcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:32:31 -0400
X-Sasl-enc: 0/a3FHYyCPA1XE4bM1kLA8w7bLKL0Q+fXDJxQGOGOCJ0 1333143150
X-Mailbox-Line: From gregkh@linuxfoundation.org Fri Mar 30 12:48:59 2012
Message-Id: <20120330194859.368872589@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:51:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Arkadiusz Miskiewicz <arekm@maven.pl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 165/175] sky2: override for PCI legacy power management
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


From: stephen hemminger <shemminger@vyatta.com>

[ Upstream commit 5676cc7bfe1e388e87843f71daa229610385b41e ]

Some BIOS's don't setup power management correctly (what else is
new) and don't allow use of PCI Express power control. Add a special
exception module parameter to allow working around this issue.
Based on slightly different patch by Knut Petersen.

Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/sky2.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
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


