Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899Ab2AKTKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 14:10:32 -0500
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:48173 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933244Ab2AKTK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 14:10:28 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: benh@kernel.crashing.org
Cc: paulus@samba.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: [PATCH] ppc/eeh: fix crash when error happens during device probe
Date: Wed, 11 Jan 2012 17:09:58 -0200
Message-Id: <1326308998-24263-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.4
x-cbid: 12011119-2194-0000-0000-000000A9327F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EEH may happen during a PCI driver probe. If the driver is trying to
access some register in a loop, the EEH code will try to print the
driver name. But the driver pointer in struct pci_dev is not set until
probe returns successfully.

Use a function to test if the device and the driver pointer is NULL
before accessing the driver's name.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/ppc-pci.h   |    5 +++++
 arch/powerpc/platforms/pseries/eeh.c |    4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/ppc-pci.h b/arch/powerpc/include/asm/ppc-pci.h
index 43268f1..6d42297 100644
--- a/arch/powerpc/include/asm/ppc-pci.h
+++ b/arch/powerpc/include/asm/ppc-pci.h
@@ -142,6 +142,11 @@ static inline const char *eeh_pci_name(struct pci_dev *pdev)
 	return pdev ? pci_name(pdev) : "<null>";
 } 
 
+static inline const char *eeh_driver_name(struct pci_dev *pdev)
+{
+	return (pdev && pdev->driver) ? pdev->driver->name : "<null>";
+}
+
 #endif /* CONFIG_EEH */
 
 #else /* CONFIG_PCI */
diff --git a/arch/powerpc/platforms/pseries/eeh.c b/arch/powerpc/platforms/pseries/eeh.c
index 5658690..c0b40af 100644
--- a/arch/powerpc/platforms/pseries/eeh.c
+++ b/arch/powerpc/platforms/pseries/eeh.c
@@ -551,9 +551,9 @@ int eeh_dn_check_failure(struct device_node *dn, struct pci_dev *dev)
 			printk (KERN_ERR "EEH: %d reads ignored for recovering device at "
 				"location=%s driver=%s pci addr=%s\n",
 				pdn->eeh_check_count, location,
-				dev->driver->name, eeh_pci_name(dev));
+				eeh_driver_name(dev), eeh_pci_name(dev));
 			printk (KERN_ERR "EEH: Might be infinite loop in %s driver\n",
-				dev->driver->name);
+				eeh_driver_name(dev));
 			dump_stack();
 		}
 		goto dn_unlock;
-- 
1.7.4.4

