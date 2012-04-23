Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab2DWOiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 10:38:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56437 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab2DWOiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 10:38:51 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, Ingo Molnar <mingo@elte.hu>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v1 3/3] DCA, x86: support mutitple PCI root complexes in DCA core logic
Date: Mon, 23 Apr 2012 22:34:02 +0800
Message-Id: <1335191642-6869-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335191642-6869-1-git-send-email-jiang.liu@huawei.com>
References: <1335191642-6869-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To maintain backward compatibility with old interface dca_get_tag(), currently
the DCA core logic is limited to support only one domain (PCI root complex).
This effectively disables DCA on systems with multiple PCI root complexes,
such as IBM x3850, Quantan S4R etc.

This patch enhances the DCA core logic only to disable DCA operations when
both dca_get_tag() has been used and there are multiple PCI root complexes
in the system.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/dca/dca-core.c |  138 ++++++++++++++++++++++--------------------------
 1 files changed, 64 insertions(+), 74 deletions(-)

diff --git a/drivers/dca/dca-core.c b/drivers/dca/dca-core.c
index f8cfa58..ff9017d 100644
--- a/drivers/dca/dca-core.c
+++ b/drivers/dca/dca-core.c
@@ -42,7 +42,14 @@ static LIST_HEAD(dca_domains);
 
 static BLOCKING_NOTIFIER_HEAD(dca_provider_chain);
 
-static int dca_providers_blocked;
+static enum {
+	DCA_COMPAT_INITIAL = 0,		/* Initial state */
+	DCA_COMPAT_MULTI_DOMAINS = 1,	/* Multiple Root Complexes detected */
+	DCA_COMPAT_LEGACY_INTERFACE = 2,/* Legacy interface has been used */
+	DCA_COMPAT_DISABLED = 3		/* DCA disabled due to legacy interface
+					 * has been used and there are multiple
+					 * RCs in the system */
+} dca_compat_state;
 
 static struct pci_bus *dca_pci_rc_from_dev(struct device *dev)
 {
@@ -75,26 +82,11 @@ static void dca_free_domain(struct dca_domain *domain)
 	kfree(domain);
 }
 
-static int dca_provider_ioat_ver_3_0(struct device *dev)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-
-	return ((pdev->vendor == PCI_VENDOR_ID_INTEL) &&
-		((pdev->device == PCI_DEVICE_ID_INTEL_IOAT_TBG0) ||
-		(pdev->device == PCI_DEVICE_ID_INTEL_IOAT_TBG1) ||
-		(pdev->device == PCI_DEVICE_ID_INTEL_IOAT_TBG2) ||
-		(pdev->device == PCI_DEVICE_ID_INTEL_IOAT_TBG3) ||
-		(pdev->device == PCI_DEVICE_ID_INTEL_IOAT_TBG4) ||
-		(pdev->device == PCI_DEVICE_ID_INTEL_IOAT_TBG5) ||
-		(pdev->device == PCI_DEVICE_ID_INTEL_IOAT_TBG6) ||
-		(pdev->device == PCI_DEVICE_ID_INTEL_IOAT_TBG7)));
-}
-
 static void unregister_dca_providers(void)
 {
 	struct dca_provider *dca, *_dca;
 	struct list_head unregistered_providers;
-	struct dca_domain *domain;
+	struct dca_domain *domain, *_domain;
 	unsigned long flags;
 
 	blocking_notifier_call_chain(&dca_provider_chain,
@@ -103,20 +95,11 @@ static void unregister_dca_providers(void)
 	INIT_LIST_HEAD(&unregistered_providers);
 
 	raw_spin_lock_irqsave(&dca_lock, flags);
-
-	if (list_empty(&dca_domains)) {
-		raw_spin_unlock_irqrestore(&dca_lock, flags);
-		return;
+	list_for_each_entry_safe(domain, _domain, &dca_domains, node) {
+		list_splice_init(&domain->dca_providers,
+				 &unregistered_providers);
+		dca_free_domain(domain);
 	}
-
-	/* at this point only one domain in the list is expected */
-	domain = list_first_entry(&dca_domains, struct dca_domain, node);
-
-	list_for_each_entry_safe(dca, _dca, &domain->dca_providers, node)
-		list_move(&dca->node, &unregistered_providers);
-
-	dca_free_domain(domain);
-
 	raw_spin_unlock_irqrestore(&dca_lock, flags);
 
 	list_for_each_entry_safe(dca, _dca, &unregistered_providers, node) {
@@ -136,22 +119,6 @@ static struct dca_domain *dca_find_domain(struct pci_bus *rc)
 	return NULL;
 }
 
-static struct dca_domain *dca_get_domain(struct device *dev)
-{
-	struct pci_bus *rc;
-	struct dca_domain *domain;
-
-	rc = dca_pci_rc_from_dev(dev);
-	domain = dca_find_domain(rc);
-
-	if (!domain) {
-		if (dca_provider_ioat_ver_3_0(dev) && !list_empty(&dca_domains))
-			dca_providers_blocked = 1;
-	}
-
-	return domain;
-}
-
 static struct dca_provider *dca_find_provider_by_dev(struct device *dev)
 {
 	struct dca_provider *dca;
@@ -278,6 +245,11 @@ u8 dca_common_get_tag(struct device *dev, int cpu)
 
 	raw_spin_lock_irqsave(&dca_lock, flags);
 
+	if (dca_compat_state == DCA_COMPAT_DISABLED) {
+		raw_spin_unlock_irqrestore(&dca_lock, flags);
+		return -ENODEV;
+	}
+
 	dca = dca_find_provider_by_dev(dev);
 	if (!dca) {
 		raw_spin_unlock_irqrestore(&dca_lock, flags);
@@ -311,6 +283,21 @@ EXPORT_SYMBOL_GPL(dca3_get_tag);
 u8 dca_get_tag(int cpu)
 {
 	struct device *dev = NULL;
+	unsigned long flags;
+
+	if (unlikely(dca_compat_state == DCA_COMPAT_INITIAL)) {
+		raw_spin_lock_irqsave(&dca_lock, flags);
+		if (dca_compat_state == DCA_COMPAT_INITIAL)
+			dca_compat_state = DCA_COMPAT_LEGACY_INTERFACE;
+		raw_spin_unlock_irqrestore(&dca_lock, flags);
+	}
+	if (unlikely(dca_compat_state == DCA_COMPAT_MULTI_DOMAINS)) {
+		unregister_dca_providers();
+		raw_spin_lock_irqsave(&dca_lock, flags);
+		if (dca_compat_state == DCA_COMPAT_MULTI_DOMAINS)
+			dca_compat_state = DCA_COMPAT_DISABLED;
+		raw_spin_unlock_irqrestore(&dca_lock, flags);
+	}
 
 	return dca_common_get_tag(dev, cpu);
 }
@@ -357,43 +344,38 @@ int register_dca_provider(struct dca_provider *dca, struct device *dev)
 	int err;
 	unsigned long flags;
 	struct dca_domain *domain, *newdomain = NULL;
+	struct pci_bus *rc;
 
-	raw_spin_lock_irqsave(&dca_lock, flags);
-	if (dca_providers_blocked) {
-		raw_spin_unlock_irqrestore(&dca_lock, flags);
-		return -ENODEV;
-	}
-	raw_spin_unlock_irqrestore(&dca_lock, flags);
+	rc = dca_pci_rc_from_dev(dev);
+	newdomain = dca_allocate_domain(rc);
+	if (!newdomain)
+		return -ENOMEM;
 
 	err = dca_sysfs_add_provider(dca, dev);
 	if (err)
-		return err;
+		goto out_free;
 
 	raw_spin_lock_irqsave(&dca_lock, flags);
-	domain = dca_get_domain(dev);
-	if (!domain) {
-		struct pci_bus *rc;
+	if (dca_compat_state == DCA_COMPAT_DISABLED) {
+		raw_spin_unlock_irqrestore(&dca_lock, flags);
+		goto out_remove_sysfs;
+	}
 
-		if (dca_providers_blocked) {
-			raw_spin_unlock_irqrestore(&dca_lock, flags);
-			dca_sysfs_remove_provider(dca);
-			unregister_dca_providers();
-			return -ENODEV;
+	domain = dca_find_domain(rc);
+	if (!domain) {
+		if (!list_empty(&dca_domains)) {
+			if (dca_compat_state == DCA_COMPAT_LEGACY_INTERFACE) {
+				dca_compat_state = DCA_COMPAT_DISABLED;
+				raw_spin_unlock_irqrestore(&dca_lock, flags);
+				err = -ENODEV;
+				goto out_unregister_dca;
+			} else if (dca_compat_state == DCA_COMPAT_INITIAL)
+				dca_compat_state = DCA_COMPAT_MULTI_DOMAINS;
 		}
 
-		raw_spin_unlock_irqrestore(&dca_lock, flags);
-		rc = dca_pci_rc_from_dev(dev);
-		newdomain = dca_allocate_domain(rc);
-		if (!newdomain)
-			return -ENODEV;
-		raw_spin_lock_irqsave(&dca_lock, flags);
-		/* Recheck, we might have raced after dropping the lock */
-		domain = dca_get_domain(dev);
-		if (!domain) {
-			domain = newdomain;
-			newdomain = NULL;
-			list_add(&domain->node, &dca_domains);
-		}
+		domain = newdomain;
+		newdomain = NULL;
+		list_add(&domain->node, &dca_domains);
 	}
 	list_add(&dca->node, &domain->dca_providers);
 	raw_spin_unlock_irqrestore(&dca_lock, flags);
@@ -402,6 +384,14 @@ int register_dca_provider(struct dca_provider *dca, struct device *dev)
 				     DCA_PROVIDER_ADD, NULL);
 	kfree(newdomain);
 	return 0;
+
+out_unregister_dca:
+	unregister_dca_providers();
+out_remove_sysfs:
+	dca_sysfs_remove_provider(dca);
+out_free:
+	kfree(newdomain);
+	return err;
 }
 EXPORT_SYMBOL_GPL(register_dca_provider);
 
-- 
1.7.5.4

