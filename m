Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1DSUMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:12:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab1DSUMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:12:14 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 1/2] PCI: Add interfaces to store and load the device saved
	state
To: linux-pci@vger.kernel.org, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        jan.kiszka@siemens.com, avi@redhat.com, jbarnes@virtuousgeek.org
Date: Tue, 19 Apr 2011 14:12:11 -0600
Message-ID: <20110419201211.3739.85410.stgit@s20.home>
In-Reply-To: <20110419200912.3739.22895.stgit@s20.home>
References: <20110419200912.3739.22895.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For KVM device assignment, we'd like to save off the state of a device
prior to passing it to the guest and restore it later.  We also want
to allow pci_reset_funciton() to be called while the device is owned
by the guest.  This however overwrites and invalidates the struct pci_dev
buffers, so we can't just manually call save and restore.  Add generic
interfaces for the saved state to be stored and reloaded back into
struct pci_dev at a later time.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/pci/pci.c   |   94 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |    4 ++
 2 files changed, 98 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 2472e71..30e2ebd 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -975,6 +975,100 @@ void pci_restore_state(struct pci_dev *dev)
 	dev->state_saved = false;
 }
 
+struct pci_state {
+	u32 config_space[16];
+	u16 pcie_state[PCI_EXP_SAVE_REGS];
+	u16 pcix_state[1];
+};
+
+/**
+ * pci_store_saved_state - Allocate and return an opaque struct containing
+ *			   the device saved state.
+ * @dev: PCI device that we're dealing with
+ *
+ * NULL if no state or error.
+ */
+struct pci_state *pci_store_saved_state(struct pci_dev *dev)
+{
+	struct pci_state *state;
+	struct pci_cap_saved_state *cap_state;
+	int pos;
+
+	if (!dev->state_saved)
+		return NULL;
+
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (!state)
+		return NULL;
+
+	memcpy(state->config_space, dev->saved_config_space,
+	       sizeof(state->config_space));
+
+	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
+	cap_state = pci_find_saved_cap(dev, PCI_CAP_ID_EXP);
+	if (cap_state && pos)
+		memcpy(state->pcie_state, cap_state->data,
+		       sizeof(state->pcie_state));
+
+	pos = pci_find_capability(dev, PCI_CAP_ID_PCIX);
+	cap_state = pci_find_saved_cap(dev, PCI_CAP_ID_PCIX);
+	if (cap_state && pos)
+		memcpy(state->pcix_state, cap_state->data,
+		       sizeof(state->pcix_state));
+
+	return state;
+}
+EXPORT_SYMBOL_GPL(pci_store_saved_state);
+
+/**
+ * pci_load_saved_state - Reload the provided save state into struct pci_dev.
+ * @dev: PCI device that we're dealing with
+ * @state: Saved state returned from pci_store_saved_state()
+ */
+void pci_load_saved_state(struct pci_dev *dev, struct pci_state *state)
+{
+	struct pci_cap_saved_state *cap_state;
+	int pos;
+
+	if (!state) {
+		dev->state_saved = false;
+		return;
+	}
+
+	memcpy(dev->saved_config_space, state->config_space,
+	       sizeof(state->config_space));
+
+	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
+	cap_state = pci_find_saved_cap(dev, PCI_CAP_ID_EXP);
+	if (cap_state && pos)
+		memcpy(cap_state->data, state->pcie_state,
+		       sizeof(state->pcie_state));
+
+	pos = pci_find_capability(dev, PCI_CAP_ID_PCIX);
+	cap_state = pci_find_saved_cap(dev, PCI_CAP_ID_PCIX);
+	if (cap_state && pos)
+		memcpy(cap_state->data, state->pcix_state,
+		       sizeof(state->pcix_state));
+
+	dev->state_saved = true;
+}
+EXPORT_SYMBOL_GPL(pci_load_saved_state);
+
+/**
+ * pci_load_and_free_saved_state - Reload the save state pointed to by state,
+ *				   and free the memory allocated for it.
+ * @dev: PCI device that we're dealing with
+ * @state: Pointer to saved state returned from pci_store_saved_state()
+ */
+void pci_load_and_free_saved_state(struct pci_dev *dev,
+				   struct pci_state **state)
+{
+	pci_load_saved_state(dev, *state);
+	kfree(*state);
+	*state = NULL;
+}
+EXPORT_SYMBOL_GPL(pci_load_and_free_saved_state);
+
 static int do_pci_enable_device(struct pci_dev *dev, int bars)
 {
 	int err;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 96f70d7..b7c6c1a 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -807,6 +807,10 @@ size_t pci_get_rom_size(struct pci_dev *pdev, void __iomem *rom, size_t size);
 /* Power management related routines */
 int pci_save_state(struct pci_dev *dev);
 void pci_restore_state(struct pci_dev *dev);
+struct pci_state *pci_store_saved_state(struct pci_dev *dev);
+void pci_load_saved_state(struct pci_dev *dev, struct pci_state *state);
+void pci_load_and_free_saved_state(struct pci_dev *dev,
+				   struct pci_state **state);
 int __pci_complete_power_transition(struct pci_dev *dev, pci_power_t state);
 int pci_set_power_state(struct pci_dev *dev, pci_power_t state);
 pci_power_t pci_choose_state(struct pci_dev *dev, pm_message_t state);

