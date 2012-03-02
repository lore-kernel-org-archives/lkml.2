Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965340Ab2CBL4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 06:56:21 -0500
Received: from mga03.intel.com ([143.182.124.21]:14615 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214Ab2CBL4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 06:56:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="72748262"
Date: Fri, 02 Mar 2012 11:55:44 +0000
From: tadeusz.struk@intel.com
To: jbarnes@virtuousgeek.org, bhelgaas@google.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, tadeusz.struk@intel.com
Subject: [PATCH v2] Dynamically add and remove device specific reset
 functions
Message-ID: <4f50b540.6AzyOmpHR+z7jLk1%tadeusz.struk@intel.com>
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Reworked according to comments.
I have a use case where I need to cleanup resource allocated for Virtual
Functions after a guest OS that used it crashed. This cleanup needs to
be done before the VF is being FLRed. The only possible way to do this
seems to be by using pci_dev_specific_reset() function. Unfortunately
this function only works for devices defined in a static table in the
drivers/pci/quirks.c file. This patch changes it so that specific reset
functions can be added and deleted dynamically.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

---
 drivers/pci/pci.h    |   14 +++++++++++
 drivers/pci/quirks.c |   61 +++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 65 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 1009a5e..3e95df6 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -312,6 +312,7 @@ static inline resource_size_t pci_resource_alignment(struct pci_dev *dev,
 extern void pci_enable_acs(struct pci_dev *dev);
 
 struct pci_dev_reset_methods {
+	struct list_head list;
 	u16 vendor;
 	u16 device;
 	int (*reset)(struct pci_dev *dev, int probe);
@@ -319,11 +320,24 @@ struct pci_dev_reset_methods {
 
 #ifdef CONFIG_PCI_QUIRKS
 extern int pci_dev_specific_reset(struct pci_dev *dev, int probe);
+extern int pci_dev_specific_reset_add(struct pci_dev_reset_methods
+					*reset_method);
+extern int pci_dev_specific_reset_remove(struct pci_dev_reset_methods
+					*reset_method);
 #else
 static inline int pci_dev_specific_reset(struct pci_dev *dev, int probe)
 {
 	return -ENOTTY;
 }
+int pci_dev_specific_reset_add(struct pci_dev_reset_methods *reset_method)
+{
+	return 0;
+}
+int
+pci_dev_specific_reset_remove(struct pci_dev_reset_methods *reset_method)
+{
+	return 0;
+}
 #endif
 
 #endif /* DRIVERS_PCI_H */
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 6476547..a0152fd 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3070,26 +3070,67 @@ static int reset_intel_82599_sfp_virtfn(struct pci_dev *dev, int probe)
 }
 
 #define PCI_DEVICE_ID_INTEL_82599_SFP_VF   0x10ed
-
-static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82599_SFP_VF,
-		 reset_intel_82599_sfp_virtfn },
-	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
+static struct pci_dev_reset_methods pci_dev_reset_methods[] = {
+	{ {NULL, NULL}, PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82599_SFP_VF,
+		reset_intel_82599_sfp_virtfn },
+	{ {NULL, NULL}, PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
 		reset_intel_generic_dev },
-	{ 0 }
 };
 
+static DEFINE_SPINLOCK(reset_list_lock);
+static LIST_HEAD(reset_list);
+
+static int __init pci_dev_specific_reset_init(void)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(pci_dev_reset_methods); i++) {
+		pci_dev_specific_reset_add(&pci_dev_reset_methods[i]);
+	}
+	return 0;
+}
+
+late_initcall(pci_dev_specific_reset_init);
+
+int pci_dev_specific_reset_add(struct pci_dev_reset_methods *reset_method)
+{
+	WARN_ON(!reset_method->reset);
+	INIT_LIST_HEAD(&reset_method->list);
+	spin_lock(&reset_list_lock);
+	list_add(&reset_method->list, &reset_list);
+	spin_unlock(&reset_list_lock);
+	return 0;
+}
+EXPORT_SYMBOL(pci_dev_specific_reset_add);
+
+int pci_dev_specific_reset_remove(struct pci_dev_reset_methods *reset_method)
+{
+	spin_lock(&reset_list_lock);
+	list_del(&reset_method->list);
+	spin_unlock(&reset_list_lock);
+	return 0;
+}
+EXPORT_SYMBOL(pci_dev_specific_reset_remove);
+
 int pci_dev_specific_reset(struct pci_dev *dev, int probe)
 {
 	const struct pci_dev_reset_methods *i;
+	spin_lock(&reset_list_lock);
+	list_for_each_entry(i, &reset_list, list) {
+		if (i->vendor == dev->vendor &&
+		    i->device == dev->device) {
+			spin_unlock(&reset_list_lock);
+			return i->reset(dev, probe);
+		}
+	}
 
-	for (i = pci_dev_reset_methods; i->reset; i++) {
+	list_for_each_entry(i, &reset_list, list) {
 		if ((i->vendor == dev->vendor ||
 		     i->vendor == (u16)PCI_ANY_ID) &&
-		    (i->device == dev->device ||
-		     i->device == (u16)PCI_ANY_ID))
+		     i->device == (u16)PCI_ANY_ID) {
+			spin_unlock(&reset_list_lock);
 			return i->reset(dev, probe);
+		}
 	}
-
+	spin_unlock(&reset_list_lock);
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


