Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab2IMOG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 10:06:57 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:50438 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab2IMOGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 10:06:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Grant Grundler <grundler@parisc-linux.org>,
        Nobin Mathew <nobin.mathew@gmail.com>,
        Robert Hancock <hancockr@shaw.ca>, Arnd Bergmann <arnd@arndb.de>,
        David Altobelli <david.altobelli@hp.com>
Subject: [RFC 1/1] MISC: hpilo, remove pci_disable_device
Date: Thu, 13 Sep 2012 16:06:48 +0200
Message-Id: <1347545208-18512-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.11.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Altobelli <david.altobelli@hp.com>
---
 drivers/misc/hpilo.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index 6df0da4..12ccdf9 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -736,7 +736,14 @@ static void ilo_remove(struct pci_dev *pdev)
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
 	ilo_hwdev[(minor / max_ccb)] = 0;
 }
@@ -826,7 +833,7 @@ unmap:
 free_regions:
 	pci_release_regions(pdev);
 disable:
-	pci_disable_device(pdev);
+/*	pci_disable_device(pdev);  see comment in ilo_remove */
 free:
 	kfree(ilo_hw);
 out:
-- 
1.7.11.5


