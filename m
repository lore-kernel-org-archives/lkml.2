Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab0JDSXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:23:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129Ab0JDSXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:23:06 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 5/5] pci: Add support for polling PME state on suspended legacy PCI devices
Date: Mon,  4 Oct 2010 14:22:29 -0400
Message-Id: <1286216549-5438-6-git-send-email-mjg@redhat.com>
In-Reply-To: <1286216549-5438-1-git-send-email-mjg@redhat.com>
References: <1286216549-5438-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all hardware vendors hook up the PME line for legacy PCI devices,
meaning that wakeup events get lost. The only way around this is to poll
the devices to see if their state has changed, so add support for doing
that on legacy PCI devices that aren't part of the core chipset.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/pci/pci.c |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 77 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 7fa3cbd..0b61263 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -38,6 +38,19 @@ EXPORT_SYMBOL(pci_pci_problems);
 
 unsigned int pci_pm_d3_delay;
 
+static void pci_pme_list_scan(struct work_struct *work);
+
+static LIST_HEAD(pci_pme_list);
+static DEFINE_MUTEX(pci_pme_list_mutex);
+static DECLARE_DELAYED_WORK(pci_pme_work, pci_pme_list_scan);
+
+struct pci_pme_device {
+	struct list_head list;
+	struct pci_dev *dev;
+};
+
+#define PME_TIMEOUT 1000 /* How long between PME checks */
+
 static void pci_dev_d3_sleep(struct pci_dev *dev)
 {
 	unsigned int delay = dev->d3_delay;
@@ -1331,6 +1344,32 @@ bool pci_pme_capable(struct pci_dev *dev, pci_power_t state)
 	return !!(dev->pme_support & (1 << state));
 }
 
+static void pci_pme_list_scan(struct work_struct *work)
+{
+	struct pci_pme_device *pme_dev;
+
+	mutex_lock(&pci_pme_list_mutex);
+	if (!list_empty(&pci_pme_list)) {
+		list_for_each_entry(pme_dev, &pci_pme_list, list)
+			pci_pme_wakeup(pme_dev->dev, NULL);
+		schedule_delayed_work(&pci_pme_work, msecs_to_jiffies(PME_TIMEOUT));
+	}
+	mutex_unlock(&pci_pme_list_mutex);
+}
+
+/**
+ * pci_external_pme - is a device an external PCI PME source?
+ * @dev: PCI device to check
+ *
+ */
+
+static bool pci_external_pme(struct pci_dev *dev)
+{
+	if (pci_is_pcie(dev) || dev->bus->number == 0)
+		return false;
+	return true;
+}
+
 /**
  * pci_pme_active - enable or disable PCI device's PME# function
  * @dev: PCI device to handle.
@@ -1354,6 +1393,44 @@ void pci_pme_active(struct pci_dev *dev, bool enable)
 
 	pci_write_config_word(dev, dev->pm_cap + PCI_PM_CTRL, pmcsr);
 
+	/* PCI (as opposed to PCIe) PME requires that the device have
+	   its PME# line hooked up correctly. Not all hardware vendors
+	   do this, so the PME never gets delivered and the device
+	   remains asleep. The easiest way around this is to
+	   periodically walk the list of suspended devices and check
+	   whether any have their PME flag set. The assumption is that
+	   we'll wake up often enough anyway that this won't be a huge
+	   hit, and the power savings from the devices will still be a
+	   win. */
+
+	if (pci_external_pme(dev)) {
+		struct pci_pme_device *pme_dev;
+		if (enable) {
+			pme_dev = kmalloc(sizeof(struct pci_pme_device),
+					  GFP_KERNEL);
+			if (!pme_dev)
+				goto out;
+			pme_dev->dev = dev;
+			mutex_lock(&pci_pme_list_mutex);
+			list_add(&pme_dev->list, &pci_pme_list);
+			if (list_is_singular(&pci_pme_list))
+				schedule_delayed_work(&pci_pme_work,
+						      msecs_to_jiffies(PME_TIMEOUT));
+			mutex_unlock(&pci_pme_list_mutex);
+		} else {
+			mutex_lock(&pci_pme_list_mutex);
+			list_for_each_entry(pme_dev, &pci_pme_list, list) {
+				if (pme_dev->dev == dev) {
+					list_del(&pme_dev->list);
+					kfree(pme_dev);
+					break;
+				}
+			}
+			mutex_unlock(&pci_pme_list_mutex);
+		}
+	}
+
+out:
 	dev_printk(KERN_DEBUG, &dev->dev, "PME# %s\n",
 			enable ? "enabled" : "disabled");
 }
-- 
1.7.3.1

