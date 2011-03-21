Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab1CUDiu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 23:38:50 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:7244 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab1CUDir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 23:38:47 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Mar 2011 23:38:47 EDT
From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
To: jbarnes@virtuousgeek.org
Cc: rjw@sisk.pl, mjg59@srcf.ucam.org,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Message-Id: <20110321032504.2353.59070.sendpatchset@nchumbalkar.americas.hpqcorp.net>
Subject: [RFC][PATCH v3 1/3]: PCI: PCIe links may not get configured for ASPM under POWERSAVE mode
Date: Mon, 21 Mar 2011 03:29:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v3 -> v2: Moved ASPM enabling logic to pci_set_power_state()
v2 -> v1: Preserved the logic in pci_raw_set_power_state()
	: Added ASPM enabling logic after scanning Root Bridge
	: http://marc.info/?l=linux-pci&m=130046996216391&w=2
v1	: http://marc.info/?l=linux-pci&m=130013164703283&w=2

The assumption made in commit 41cd766b065970ff6f6c89dd1cf55fa706c84a3d
(PCI: Don't enable aspm before drivers have had a chance to veto it) that
pci_enable_device() will result in re-configuring ASPM when aspm_policy is
POWERSAVE is no longer valid.  This is due to commit
97c145f7c87453cec90e91238fba5fe2c1561b32 (PCI: read current power state
at enable time) which resets dev->current_state to D0. Due to this the
call to pcie_aspm_pm_state_change() is never made. Note the equality check
(below) that returns early:
./drivers/pci/pci.c: pci_raw_set_pci_power_state()
546         /* Check if we're already there */
547         if (dev->current_state == state)
548                 return 0;

Therefore OSPM never configures the PCIe links for ASPM to turn them "on".

Fix it by configuring ASPM from the pci_enable_device() code path. This 
also allows a driver such as the e1000e networking driver a chance to 
disable ASPM (L0s, L1), if need be, prior to enabling the device. A 
driver may perform this action if the device is known to mis-behave 
wrt ASPM.

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>

---
 drivers/pci/pci.c        |    6 ++++++
 drivers/pci/pcie/aspm.c  |   22 ++++++++++++++++++++++
 include/linux/pci-aspm.h |    4 ++++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b714d78..2472e71 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -740,6 +740,12 @@ int pci_set_power_state(struct pci_dev *dev, pci_power_t state)
 
 	if (!__pci_complete_power_transition(dev, state))
 		error = 0;
+	/*
+	 * When aspm_policy is "powersave" this call ensures
+	 * that ASPM is configured.
+	 */
+	if (!error && dev->bus->self)
+		pcie_aspm_powersave_config_link(dev->bus->self);
 
 	return error;
 }
diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 3188cd9..e768620 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -707,6 +707,28 @@ void pcie_aspm_pm_state_change(struct pci_dev *pdev)
 	up_read(&pci_bus_sem);
 }
 
+void pcie_aspm_powersave_config_link(struct pci_dev *pdev)
+{
+	struct pcie_link_state *link = pdev->link_state;
+
+	if (aspm_disabled || !pci_is_pcie(pdev) || !link)
+		return;
+
+	if (aspm_policy != POLICY_POWERSAVE)
+		return;
+
+	if ((pdev->pcie_type != PCI_EXP_TYPE_ROOT_PORT) &&
+	    (pdev->pcie_type != PCI_EXP_TYPE_DOWNSTREAM))
+		return;
+
+	down_read(&pci_bus_sem);
+	mutex_lock(&aspm_lock);
+	pcie_config_aspm_path(link);
+	pcie_set_clkpm(link, policy_to_clkpm_state(link));
+	mutex_unlock(&aspm_lock);
+	up_read(&pci_bus_sem);
+}
+
 /*
  * pci_disable_link_state - disable pci device's link state, so the link will
  * never enter specific states
diff --git a/include/linux/pci-aspm.h b/include/linux/pci-aspm.h
index ce68105..67cb3ae 100644
--- a/include/linux/pci-aspm.h
+++ b/include/linux/pci-aspm.h
@@ -26,6 +26,7 @@
 extern void pcie_aspm_init_link_state(struct pci_dev *pdev);
 extern void pcie_aspm_exit_link_state(struct pci_dev *pdev);
 extern void pcie_aspm_pm_state_change(struct pci_dev *pdev);
+extern void pcie_aspm_powersave_config_link(struct pci_dev *pdev);
 extern void pci_disable_link_state(struct pci_dev *pdev, int state);
 extern void pcie_clear_aspm(void);
 extern void pcie_no_aspm(void);
@@ -39,6 +40,9 @@ static inline void pcie_aspm_exit_link_state(struct pci_dev *pdev)
 static inline void pcie_aspm_pm_state_change(struct pci_dev *pdev)
 {
 }
+static inline void pcie_aspm_powersave_config_link(struct pci_dev *pdev)
+{
+}
 static inline void pci_disable_link_state(struct pci_dev *pdev, int state)
 {
 }
-- 
1.7.1.2

