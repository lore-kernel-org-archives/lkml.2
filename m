Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293Ab2ILXnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:43:45 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36222 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933274Ab2ILXnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:43:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [ 26/46] PCI: EHCI: Fix crash during hibernation on ASUS computers
Date: Wed, 12 Sep 2012 16:39:16 -0700
Message-Id: <20120912233820.402770707@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233817.662663809@linuxfoundation.org>
References: <20120912233817.662663809@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pci-driver.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -936,6 +936,13 @@ static int pci_pm_poweroff_noirq(struct
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
 


