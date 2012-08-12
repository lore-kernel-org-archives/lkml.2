Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab2HLVUO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 17:20:14 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:34805 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab2HLVUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 17:20:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH] PCI: EHCI: fix crash during hibernation on ASUS computers
Date: Sun, 12 Aug 2012 23:26:07 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        AceLan Kao <acelan.kao@canonical.com>, alex.hung@canonical.com,
        Oleksij Rempel <bug-track@fisher-privat.net>,
        "Linux-pm mailing list" <linux-pm@vger.kernel.org>,
        linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1208110959320.21252-100000@netrider.rowland.org> <201208112356.26719.rjw@sisk.pl>
In-Reply-To: <201208112356.26719.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208122326.07318.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit dbf0e4c (PCI: EHCI: fix crash during suspend on ASUS
computers) added a workaround for an ASUS suspend issue related to
USB EHCI and a bug in a number of ASUS BIOSes that attemt to shut
down the EHCI controller during system suspend if its PCI command
register doesn't contain 0 at that time.

It turns out that the same workaround is necessary in the analogous
hibernation code path, so add it.

References: https://bugzilla.kernel.org/show_bug.cgi?id=45811
Reported-and-tested-by: Oleksij Rempel <bug-track@fisher-privat.net>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: stable@vger.kernel.org
---

Hi Bjorn,

Please push this to Linus ASAP, we need it in 3.6 and -stable.

Thanks,
Rafael

---
 drivers/pci/pci-driver.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux/drivers/pci/pci-driver.c
===================================================================
--- linux.orig/drivers/pci/pci-driver.c
+++ linux/drivers/pci/pci-driver.c
@@ -959,6 +959,13 @@ static int pci_pm_poweroff_noirq(struct
 	if (!pci_dev->state_saved && !pci_is_bridge(pci_dev))
 		pci_prepare_to_sleep(pci_dev);
 
+	/*
+	 * The reason for doing this here is the same as for the analogous code
+	 * in pci_pm_suspend_noirq().
+	 */
+	if (pci_dev->class == PCI_CLASS_SERIAL_USB_EHCI)
+		pci_write_config_word(pci_dev, PCI_COMMAND, 0);
+
 	return 0;
 }
 
