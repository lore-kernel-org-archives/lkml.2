Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab0HBMoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 08:44:32 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:54867 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab0HBMob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 08:44:31 -0400
X-Loopcount0: from 143.166.82.43
Date: Mon, 2 Aug 2010 07:44:29 -0500
From: Narendra K <Narendra_K@dell.com>
To: sfr@canb.auug.org.au, jbarnes@virtuousgeek.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        jordan_hargrave@dell.com, matt_domsch@dell.com, charles_rose@dell.com
Subject: Re: linux-next: build warnings after merge of the pci tree
Message-ID: <20100802124429.GA8013@auslistsprd01.us.dell.com>
References: <EDA0A4495861324DA2618B4C45DCB3EE612CE1@blrx3m08.blr.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <EDA0A4495861324DA2618B4C45DCB3EE612CE1@blrx3m08.blr.amer.dell.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au] 
> Sent: Monday, August 02, 2010 6:49 AM
> To: Jesse Barnes
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; K,
> Narendra; Hargrave, Jordan
> Subject: linux-next: build warnings after merge of the pci tree
> 
> Hi Jesse,
> 
> After merging the rr tree, today's linux-next build (powerpc
> ppc64_defconfig) produced lots of these warnings:
> 
> drivers/pci/pci.h: In function 'pci_create_firmware_label_files':
> drivers/pci/pci.h:16: warning: 'return' with a value, in function
> returning void
> drivers/pci/pci.h: In function 'pci_remove_firmware_label_files':
> drivers/pci/pci.h:18: warning: 'return' with a value, in function
> returning void
> 
> Introduced by commit 911e1c9b05a8e3559a7aa89083930700a0b9e7ee ("PCI:
> export SMBIOS provided firmware instance and label to sysfs").
> 
> Please build with and without the CONFIG options your new code depends
> on ...  This adds considerably to the build noise.

Jesse,

Sorry, I missed fixing these warnings that come when CONFIG_DMI is
unset. I have fixed them in the below patch. Please consider it for
inclusion.

From: Narendra K <narendra_k@dell.com>
Subject: [PATCH] PCI: Fix warnings when CONFIG_DMI unset

This patch fixes the below warnings introduced by the commit
911e1c9b05a8e3559a7aa89083930700a0b9e7ee ("PCI:
export SMBIOS provided firmware instance and label to sysfs").

drivers/pci/pci.h: In function ‘pci_create_firmware_label_files’:
drivers/pci/pci.h:16: warning: ‘return’ with a value, in function returning void
drivers/pci/pci.h: In function ‘pci_remove_firmware_label_files’:
drivers/pci/pci.h:18: warning: ‘return’ with a value, in function returning void

The warnings are seen because of the below code, doing a retun 0
from the functions 'pci_create_firmware_label_files' and
'pci_remove_firmware_label_files' defined as void.

+#ifndef CONFIG_DMI
+static inline void pci_create_firmware_label_files(struct pci_dev *pdev)
+{ return 0; }
+static inline void pci_remove_firmware_label_files(struct pci_dev *pdev)
+{ return 0; }

Signed-off-by: Narendra K <narendra_k@dell.com>
---
 drivers/pci/pci.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index d930338..95186ca 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -13,9 +13,9 @@ extern int pci_create_sysfs_dev_files(struct pci_dev *pdev);
 extern void pci_remove_sysfs_dev_files(struct pci_dev *pdev);
 #ifndef CONFIG_DMI
 static inline void pci_create_firmware_label_files(struct pci_dev *pdev)
-{ return 0; }
+{ return; }
 static inline void pci_remove_firmware_label_files(struct pci_dev *pdev)
-{ return 0; }
+{ return; }
 #else
 extern void pci_create_firmware_label_files(struct pci_dev *pdev);
 extern void pci_remove_firmware_label_files(struct pci_dev *pdev);
-- 
1.7.0.1

With regards,
Narendra K
