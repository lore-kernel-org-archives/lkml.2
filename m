Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab2LMOcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:32:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44800 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932941Ab2LMOLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:11:03 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Slaby <jslaby@suse.cz>, Grant Grundler <grundler@parisc-linux.org>,
        Nobin Mathew <nobin.mathew@gmail.com>,
        Robert Hancock <hancockr@shaw.ca>, Arnd Bergmann <arnd@arndb.de>,
        David Altobelli <david.altobelli@hp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 164/241] MISC: hpilo, remove pci_disable_device
Date: Thu, 13 Dec 2012 11:58:49 -0200
Message-Id: <1355407206-17100-165-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/misc/hpilo.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index fffc227..9c99680 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -735,7 +735,14 @@ static void ilo_remove(struct pci_dev *pdev)
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
-- 
1.7.9.5

