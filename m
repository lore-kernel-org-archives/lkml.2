Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab0HYTfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 15:35:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45459 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab0HYTfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 15:35:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the final tree (pci-current tree related)
Date: Wed, 25 Aug 2010 21:33:29 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc2-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20100825115604.07928f97.sfr@canb.auug.org.au>
In-Reply-To: <20100825115604.07928f97.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201008252133.29525.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 25, 2010, Stephen Rothwell wrote:
> Hi Jesse,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/pci/hotplug/pciehp_core.c: In function 'pciehp_probe':
> drivers/pci/hotplug/pciehp_core.c:238: error: implicit declaration of function 'pciehp_acpi_slot_detection_check'
> 
> Caused by commit 28eb5f274a305bf3a13b2c80c4804d4515d05c64 ("PCI: PCIe:
> Ask BIOS for control of all native services at once").  This function is
> only declared if CONFIG_ACPI is defined.
> 
> I have reverted that commit for today (and the two that interact with it:
> 2bd50dd800b52245294cfceb56be62020cdc7515 "PCI: PCIe: Disable PCIe port
> services during port initialization" and
> 271fb719cc472af3b1e96d8c527bb0da7060a172 "PCI: PCIe: Move PCIe PME code
> to the pcie directory").

Sorry, my bad.

The patch below should fix this issue.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PCI / hot-plug: Fix build with CONFIG_ACPI unset

One of the recent changes caused complilation of
drivers/pci/hotplug/pciehp_core.c to fail.  Fix this issue.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/hotplug/pciehp.h |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/drivers/pci/hotplug/pciehp.h
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp.h
+++ linux-2.6/drivers/pci/hotplug/pciehp.h
@@ -178,5 +178,9 @@ static inline void pciehp_firmware_init(
 }
 #else
 #define pciehp_firmware_init()				do {} while (0)
+static inline int pciehp_acpi_slot_detection_check(struct pci_dev *dev)
+{
+	return 0;
+}
 #endif 				/* CONFIG_ACPI */
 #endif				/* _PCIEHP_H */
