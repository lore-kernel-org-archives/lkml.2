Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab2IIXP4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:15:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51053 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755491Ab2IIXPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:15:49 -0400
Message-Id: <20120909224155.251179942@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:22 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [ 32/95] PCI: EHCI: Fix crash during hibernation on ASUS computers
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rjw@sisk.pl>

commit 0b68c8e2c3afaf9807eb1ebe0ccfb3b809570aa4 upstream.

Commit dbf0e4c (PCI: EHCI: fix crash during suspend on ASUS
computers) added a workaround for an ASUS suspend issue related to
USB EHCI and a bug in a number of ASUS BIOSes that attempt to shut
down the EHCI controller during system suspend if its PCI command
register doesn't contain 0 at that time.

It turns out that the same workaround is necessary in the analogous
hibernation code path, so add it.

References: https://bugzilla.kernel.org/show_bug.cgi?id=45811
Reported-and-tested-by: Oleksij Rempel <bug-track@fisher-privat.net>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/pci-driver.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 185be37..5270f1a 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -959,6 +959,13 @@ static int pci_pm_poweroff_noirq(struct device *dev)
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
 


