Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab1DUS6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 14:58:12 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38578 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab1DUS6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 14:58:10 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: [PATCH] pci: Export pci device msi table via sysfs
Date: Thu, 21 Apr 2011 14:57:47 -0400
Message-Id: <1303412267-1948-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.7.4.2
X-Spam-Score: -2.5 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been working on some improvements to how we balance irqs for high volume
interrupt sources.  The consensus so far has been that what would be really
helpful is a irqbalance mechanism that operates in a one shot mode in response
to the addition of high volume interrupt sources (i.e. network devices mainly).
In attempting to implement this, I've found that it would be really useful to
have 2 bits of information:

1) A clear correlation of which interrupts belong to which devices.  Parsing
/proc/interrupts is an exercize in guessing what naming pattern a given driver
follows, and requires some amount of stateful information to be kept in user
space, lest every device addition require a rebalancing of every interrupt in
the system.

2) A indicator as to which kind of interrupts a given device is using.  The irq
attribute for a pci device is always accurate in that it simply reads whats in
the appropriate pci config space register, but devices using msi interrupts have
no use for that register, and never request that interrupt number.

This patch adds the requisite information.  It creates two per-pci-device irq
attribute files:

a) irq_mode - identifies which kind of irqs the device in question is using,
intx/msi/msix

b) msi_table - populated only if msi(x) is enabled, it lists the irqs allocated
to the pci device

Using this information I can implement a stateless irq one-shot balancer that
reacts to various udev events quite well

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-pci@vger.kernel.org
---
 drivers/pci/pci-sysfs.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index f8deb3e..1397dfb 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -26,6 +26,7 @@
 #include <linux/security.h>
 #include <linux/pci-aspm.h>
 #include <linux/slab.h>
+#include <linux/msi.h>
 #include "pci.h"
 
 static int sysfs_initialized;	/* = 0 */
@@ -71,6 +72,34 @@ static ssize_t broken_parity_status_store(struct device *dev,
 	return count;
 }
 
+static ssize_t irq_mode_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	return sprintf(buf, "%s\n", pdev->msix_enabled ? "msix" :
+				   (pdev->msi_enabled ? "msi" : "intx"));
+}
+
+#ifdef CONFIG_PCI_MSI
+static ssize_t msi_list_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct msi_desc *entry;
+	int first, last;
+	ssize_t count = 0;
+
+	if (!(pdev->msi_enabled || pdev->msix_enabled))
+		return 0;
+
+	list_for_each_entry(entry, &pdev->msi_list, list)
+		count += sprintf(&buf[count], "%d ", entry->irq);
+
+	return count;
+}
+#endif
+
 static ssize_t local_cpus_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {		
@@ -328,6 +357,10 @@ struct device_attribute pci_dev_attrs[] = {
 	__ATTR_RO(subsystem_device),
 	__ATTR_RO(class),
 	__ATTR_RO(irq),
+	__ATTR_RO(irq_mode),
+#ifdef CONFIG_PCI_MSI
+	__ATTR_RO(msi_list),
+#endif
 	__ATTR_RO(local_cpus),
 	__ATTR_RO(local_cpulist),
 	__ATTR_RO(modalias),
-- 
1.7.4.2

