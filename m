Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab2CARSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 12:18:24 -0500
Received: from mga14.intel.com ([143.182.124.37]:5758 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab2CARSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 12:18:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="72388042"
Date: Thu, 01 Mar 2012 17:18:14 +0000
From: tadeusz.struk@intel.com
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, tadeusz.struk@intel.com
Subject: [PATCH] Added functionality that allows dynamically add and
 remove device specific reset functions
Message-ID: <4f4faf56.55WpOIn/0L6OUf5o%tadeusz.struk@intel.com>
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b4cf24d5987475862de799c78773f13f25ed2af8 Mon Sep 17 00:00:00 2001
From: Tadeusz Struk <tadeusz.struk@intel.com>
Date: Tue, 17 Jan 2012 16:45:46 +0000
Subject: [PATCH] Added functionality that allows dynamically add and remove
 device specific reset functions

I have a use case where I need to cleanup resource allocated for Virtual
Functions after a guest OS that used it crashed. This cleanup needs to
be done before the VF is being FLRed. The only possible way to do this
seems to be by using pci_dev_specific_reset() function. Unfortunately
this function only works for devices defined in a static table in the
drivers/pci/quirks.c file. This patch changes it so that specific reset
functions can be added and deleted dynamically.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

---
 drivers/pci/pci.h    |   19 ++++++++++++++-
 drivers/pci/quirks.c |   63 ++++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 71 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 1009a5e..10929d8 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -312,18 +312,35 @@ static inline resource_size_t pci_resource_alignment(struct pci_dev *dev,
 extern void pci_enable_acs(struct pci_dev *dev);
 
 struct pci_dev_reset_methods {
+	struct list_head list;
 	u16 vendor;
 	u16 device;
 	int (*reset)(struct pci_dev *dev, int probe);
 };
 
 #ifdef CONFIG_PCI_QUIRKS
-extern int pci_dev_specific_reset(struct pci_dev *dev, int probe);
+extern int
+pci_dev_specific_reset(struct pci_dev *dev, int probe);
+extern int
+pci_dev_specific_reset_add(const struct pci_dev_reset_methods *reset_method);
+extern int
+pci_dev_specific_reset_remove(const struct pci_dev_reset_methods *reset_method);
+
 #else
 static inline int pci_dev_specific_reset(struct pci_dev *dev, int probe)
 {
 	return -ENOTTY;
 }
+int
+pci_dev_specific_reset_add(const struct pci_dev_reset_methods *reset_method)
+{
+	return 0;
+}
+int
+pci_dev_specific_reset_remove(const struct pci_dev_reset_methods *reset_method)
+{
+	return 0;
+}
 #endif
 
 #endif /* DRIVERS_PCI_H */
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 6476547..963e527 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3070,26 +3070,69 @@ static int reset_intel_82599_sfp_virtfn(struct pci_dev *dev, int probe)
 }
 
 #define PCI_DEVICE_ID_INTEL_82599_SFP_VF   0x10ed
+static struct pci_dev_reset_methods intel_82599_sfp_vf_reset = {
+	.vendor = PCI_VENDOR_ID_INTEL,
+	.device = PCI_DEVICE_ID_INTEL_82599_SFP_VF,
+	.reset = reset_intel_82599_sfp_virtfn,
+	.list = LIST_HEAD_INIT(intel_82599_sfp_vf_reset.list)
+} ;
 
-static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82599_SFP_VF,
-		 reset_intel_82599_sfp_virtfn },
-	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
-		reset_intel_generic_dev },
-	{ 0 }
-};
+static struct pci_dev_reset_methods intel_generic_reset = {
+	.vendor = PCI_VENDOR_ID_INTEL,
+	.device = PCI_ANY_ID,
+	.reset = reset_intel_generic_dev,
+	.list = LIST_HEAD_INIT(intel_generic_reset.list)
+} ;
+
+static DEFINE_SPINLOCK(reset_list_lock);
+static LIST_HEAD(reset_list);
+
+
+static int __init pci_dev_specific_reset_init(void)
+{
+	pci_dev_specific_reset_add(&intel_82599_sfp_vf_reset);
+	pci_dev_specific_reset_add(&intel_generic_reset);
+	return 0;
+}
+
+late_initcall(pci_dev_specific_reset_init);
+
+int
+pci_dev_specific_reset_add(const struct pci_dev_reset_methods *reset_method)
+{
+	if (reset_method && reset_method->reset) {
+		spin_lock(&reset_list_lock);
+		list_add((struct list_head *)&reset_method->list,
+			 &reset_list);
+		spin_unlock(&reset_list_lock);
+		return 0;
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL(pci_dev_specific_reset_add);
+
+int
+pci_dev_specific_reset_remove(const struct pci_dev_reset_methods *reset_method)
+{
+	if (reset_method) {
+		spin_lock(&reset_list_lock);
+		list_del((struct list_head *)(&reset_method->list));
+		spin_unlock(&reset_list_lock);
+		return 0;
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL(pci_dev_specific_reset_remove);
 
 int pci_dev_specific_reset(struct pci_dev *dev, int probe)
 {
 	const struct pci_dev_reset_methods *i;
-
-	for (i = pci_dev_reset_methods; i->reset; i++) {
+	list_for_each_entry(i, &reset_list, list) {
 		if ((i->vendor == dev->vendor ||
 		     i->vendor == (u16)PCI_ANY_ID) &&
 		    (i->device == dev->device ||
 		     i->device == (u16)PCI_ANY_ID))
 			return i->reset(dev, probe);
 	}
-
 	return -ENOTTY;
 }
-- 
1.7.7.6

--------------------------------------------------------------
Intel Shannon Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263
Business address: Dromore House, East Park, Shannon, Co. Clare

This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). Any review or distribution by others is strictly prohibited. If you are not the intended recipient, please contact the sender and delete all copies.


