Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964830Ab2B2WFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 17:05:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49024 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756206Ab2B2WFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 17:05:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI / PCIe: Introduce command line option to disable ARI
Date: Wed, 29 Feb 2012 23:09:41 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202292309.42051.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

There are PCIe devices on the market that report ARI support but
then fail to initialize correctly when ARI is actually used.  This
leads to situations in which kernels 2.6.34 and newer fail to handle
systems where the previous kernels worked without any apparent
problems.  Unfortunately, it is currently unknown how many such
devices are there.

For this reason, introduce a new kernel command line option,
pci=noari, allowing users to disable PCIe ARI altogether if they
see problems with PCIe device initialization.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux/drivers/pci/pci.c
===================================================================
--- linux.orig/drivers/pci/pci.c
+++ linux/drivers/pci/pci.c
@@ -94,6 +94,9 @@ u8 pci_cache_line_size;
  */
 unsigned int pcibios_max_latency = 255;
 
+/* If set, the PCIe ARI capability will not be used. */
+static bool pcie_ari_disabled;
+
 /**
  * pci_bus_max_busnr - returns maximum PCI bus number of given bus' children
  * @bus: pointer to PCI bus structure to search
@@ -1922,7 +1925,7 @@ void pci_enable_ari(struct pci_dev *dev)
 	u16 flags, ctrl;
 	struct pci_dev *bridge;
 
-	if (!pci_is_pcie(dev) || dev->devfn)
+	if (pcie_ari_disabled || !pci_is_pcie(dev) || dev->devfn)
 		return;
 
 	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI);
@@ -3718,6 +3721,8 @@ static int __init pci_setup(char *str)
 				pci_realloc();
 			} else if (!strcmp(str, "nodomains")) {
 				pci_no_domains();
+			} else if (!strncmp(str, "noari", 5)) {
+				pcie_ari_disabled = true;
 			} else if (!strncmp(str, "cbiosize=", 9)) {
 				pci_cardbus_io_size = memparse(str + 9, &str);
 			} else if (!strncmp(str, "cbmemsize=", 10)) {
