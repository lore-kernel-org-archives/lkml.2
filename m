Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab1HCXZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:25:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33346 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920Ab1HCXZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:25:46 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:44 2011
Message-Id: <20110803221244.287613747@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:00:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Manoj Iyer <manoj.iyer@canonical.com>,
        Koji Matsumuro <matsumur@nts.ricoh.co.jp>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Chris Ball <cjb@laptop.org>
Subject: [002/102] mmc: Added quirks for Ricoh 1180:e823 lower base clock frequency
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Manoj Iyer <manoj.iyer@canonical.com>

commit 15bed0f2fa8e1d7db201692532c210a7823d2d21 upstream.

Ricoh 1180:e823 does not recognize certain types of SD/MMC cards,
as reported at http://launchpad.net/bugs/773524.  Lowering the SD
base clock frequency from 200Mhz to 50Mhz fixes this issue. This
solution was suggest by Koji Matsumuro, Ricoh Company, Ltd.

This change has no negative performance effect on standard SD
cards, though it's quite possible that there will be one on
UHS-1 cards.

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
Tested-by: Daniel Manrique <daniel.manrique@canonical.com>
Cc: Koji Matsumuro <matsumur@nts.ricoh.co.jp>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/quirks.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2758,6 +2758,29 @@ static void ricoh_mmc_fixup_r5c832(struc
 
 	dev_notice(&dev->dev, "proprietary Ricoh MMC controller disabled (via firewire function)\n");
 	dev_notice(&dev->dev, "MMC cards are now supported by standard SDHCI controller\n");
+
+	/*
+	 * RICOH 0xe823 SD/MMC card reader fails to recognize
+	 * certain types of SD/MMC cards. Lowering the SD base
+	 * clock frequency from 200Mhz to 50Mhz fixes this issue.
+	 *
+	 * 0x150 - SD2.0 mode enable for changing base clock
+	 *	   frequency to 50Mhz
+	 * 0xe1  - Base clock frequency
+	 * 0x32  - 50Mhz new clock frequency
+	 * 0xf9  - Key register for 0x150
+	 * 0xfc  - key register for 0xe1
+	 */
+	if (dev->device == PCI_DEVICE_ID_RICOH_R5CE823) {
+		pci_write_config_byte(dev, 0xf9, 0xfc);
+		pci_write_config_byte(dev, 0x150, 0x10);
+		pci_write_config_byte(dev, 0xf9, 0x00);
+		pci_write_config_byte(dev, 0xfc, 0x01);
+		pci_write_config_byte(dev, 0xe1, 0x32);
+		pci_write_config_byte(dev, 0xfc, 0x00);
+
+		dev_notice(&dev->dev, "MMC controller base frequency changed to 50Mhz.\n");
+	}
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);


