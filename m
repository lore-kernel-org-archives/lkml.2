Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab2DPQMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:12:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45905 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab2DPQMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:12:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikko Vinni <mmvinni@yahoo.com>
Subject: Re: [linux-pm] "i8042: Can't reactivate AUX port" after s2ram on 3.4-rc2
Date: Mon, 16 Apr 2012 18:17:21 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Allen Kay <allen.m.kay@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <1334310754.17013.YahooMailNeo@web161804.mail.bf1.yahoo.com> <201204152256.03198.rjw@sisk.pl> <1334560992.32851.YahooMailNeo@web161806.mail.bf1.yahoo.com>
In-Reply-To: <1334560992.32851.YahooMailNeo@web161806.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204161817.21800.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 16, 2012, Mikko Vinni wrote:
> From: Rafael J. Wysocki
> 
> >>  OK, I know.  There simply are fewer BARs for bridges (and PCIe ports)
> >>  and here we're attempting to overwrite the secondary status register.  
> > Sigh.
> >> 
> >>  Well, I guess we should only retry the writes to BARs for Type 0 headers.
> > 
> > Which is done by the appended updated patch.  Can you please give it a try?
> 
> 
> Ok, I tested v4 and also v3, which is in 3.4-rc3. On this laptop both versions
> work equally: touchpad works after resume (no help for the card reader
> problem, though).

[...]

> Difference from v3:
> --- /tmp/v3-uniq        2012-04-16 09:57:42.880521878 +0300
> +++ /tmp/v4-uniq        2012-04-16 09:58:03.880545386 +0300
> @@ -1019,11 +1018,11 @@
>        1 Booting Node 0 Processor 1 APIC 0x1
>        1 CPU1 is up
>        1 ACPI: Waking up from system sleep state S3
> -     11 pcieport 0000:00:02.0: restoring config space at offset 0x1c (was 0x20005151, writing 0x5151)
> +      1 pcieport 0000:00:02.0: restoring config space at offset 0x1c (was 0x20005151, writing 0x5151)

OK, so clearly we need to prevent the writes into the secondary status register
of the PCIe port from being repreated pointlessly.

Can you please test the appended patch from completness on top of 3.4-rc3?

Rafael


---
 drivers/pci/pci.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

Index: linux/drivers/pci/pci.c
===================================================================
--- linux.orig/drivers/pci/pci.c
+++ linux/drivers/pci/pci.c
@@ -1015,13 +1015,17 @@ void pci_restore_state(struct pci_dev *d
 	pci_restore_pcie_state(dev);
 	pci_restore_ats_state(dev);
 
-	pci_restore_config_space(dev, 10, 15, 0);
-	/*
-	 * The Base Address register should be programmed before the command
-	 * register(s)
-	 */
-	pci_restore_config_space(dev, 4, 9, 10);
-	pci_restore_config_space(dev, 0, 3, 0);
+	if (dev->hdr_type == PCI_HEADER_TYPE_NORMAL) {
+		pci_restore_config_space(dev, 10, 15, 0);
+		/*
+		 * The Base Address register should be programmed before the
+		 * command register(s)
+		 */
+		pci_restore_config_space(dev, 4, 9, 10);
+		pci_restore_config_space(dev, 0, 3, 0);
+	} else {
+		pci_restore_config_space(dev, 0, 15, 0);
+	}
 
 	pci_restore_pcix_state(dev);
 	pci_restore_msi_state(dev);
