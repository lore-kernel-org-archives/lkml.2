Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab2L1TR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:17:27 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55026 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754483Ab2L1TRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:21 -0500
Message-Id: <20121228190401.272715699@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:06:10 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>,
        Grant Grundler <grundler@parisc-linux.org>,
        Nobin Mathew <nobin.mathew@gmail.com>,
        Robert Hancock <hancockr@shaw.ca>, Arnd Bergmann <arnd@arndb.de>,
        David Altobelli <david.altobelli@hp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 160/173] MISC: hpilo, remove pci_disable_device
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit bcdee04ea7ae0406ae69094f6df1aacb66a69a0b upstream.

pci_disable_device(pdev) used to be in pci remove function. But this
PCI device has two functions with interrupt lines connected to a
single pin. The other one is a USB host controller. So when we disable
the PIN there e.g. by rmmod hpilo, the controller stops working. It is
because the interrupt link is disabled in ACPI since it is not
refcounted yet. See acpi_pci_link_free_irq called from
acpi_pci_irq_disable.

It is not the best solution whatsoever, but as a workaround until the
ACPI irq link refcounting is sorted out this should fix the reported
errors.

References: https://lkml.org/lkml/2008/11/4/535

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Nobin Mathew <nobin.mathew@gmail.com>
Cc: Robert Hancock <hancockr@shaw.ca>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Altobelli <david.altobelli@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/misc/hpilo.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -735,7 +735,14 @@ static void ilo_remove(struct pci_dev *p
 	free_irq(pdev->irq, ilo_hw);
 	ilo_unmap_device(pdev, ilo_hw);
 	pci_release_regions(pdev);
-	pci_disable_device(pdev);
+	/*
+	 * pci_disable_device(pdev) used to be here. But this PCI device has
+	 * two functions with interrupt lines connected to a single pin. The
+	 * other one is a USB host controller. So when we disable the PIN here
+	 * e.g. by rmmod hpilo, the controller stops working. It is because
+	 * the interrupt link is disabled in ACPI since it is not refcounted
+	 * yet. See acpi_pci_link_free_irq called from acpi_pci_irq_disable.
+	 */
 	kfree(ilo_hw);
 	ilo_hwdev[(minor / MAX_CCB)] = 0;
 }
@@ -820,7 +827,7 @@ unmap:
 free_regions:
 	pci_release_regions(pdev);
 disable:
-	pci_disable_device(pdev);
+/*	pci_disable_device(pdev);  see comment in ilo_remove */
 free:
 	kfree(ilo_hw);
 out:


