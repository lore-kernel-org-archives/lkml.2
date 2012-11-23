Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920Ab2KWCvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 21:51:31 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61715 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757395Ab2KWCva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 21:51:30 -0500
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH] powerpc/pseries: Fix kernel crash caused by NULL PE
Date: Fri, 23 Nov 2012 13:51:10 +1100
Message-Id: <1353639070-11195-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.8.0.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gavin Shan <shangw@linux.vnet.ibm.com>

While hooking MSI interrupts, the corresponding device tree node
of the PE that the PCI device has been put into should be checked.
However, those PCI devices (e.g. VirtIO based PCI devices) that
don't have EEH capability shouldn't have the associated PE. So we
shouldn't try to get the PE's device tree node. Otherwise, it
would cause kernel crash.

Actually, it was introduced by commit 66523d9f ("powerpc/eeh: Trace
error based on PE from beginning").

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/msi.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/msi.c b/arch/powerpc/platforms/pseries/msi.c
index d19f497..9284e42 100644
--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -218,9 +218,16 @@ static struct device_node *find_pe_dn(struct pci_dev *dev, int *total)
 	if (!dn)
 		return NULL;
 
-	/* Get the top level device in the PE */
+	/*
+	 * Get the top level device in the PE, but some PCI devices
+	 * without EEH capability (e.g. VirtIO based PCI devices)
+	 * don't have the associated PE. So we should not get the
+	 * top level device from PE for those PCI devices.
+	 */
 	edev = of_node_to_eeh_dev(dn);
-	edev = list_first_entry(&edev->pe->edevs, struct eeh_dev, list);
+	if (edev->pe)
+		edev = list_first_entry(&edev->pe->edevs,
+				struct eeh_dev, list);
 	dn = eeh_dev_to_of_node(edev);
 	if (!dn)
 		return NULL;
-- 
1.7.5.4

