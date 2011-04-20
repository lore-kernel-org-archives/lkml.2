Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab1DTUbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:31:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756216Ab1DTUbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:31:43 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v3 2/3] PCI: Add interfaces to store and load the device saved
	state
To: linux-pci@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com
Cc: linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        jan.kiszka@siemens.com, jbarnes@virtuousgeek.org
Date: Wed, 20 Apr 2011 14:31:39 -0600
Message-ID: <20110420203139.3189.89418.stgit@s20.home>
In-Reply-To: <20110420202523.3189.31306.stgit@s20.home>
References: <20110420202523.3189.31306.stgit@s20.home>
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

 drivers/pci/pci.c   |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |    4 ++
 2 files changed, 102 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d2500a0..7631acf 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -976,6 +976,104 @@ void pci_restore_state(struct pci_dev *dev)
 	dev->state_saved = false;
 }
 
+struct pci_saved_state {
+	u32 config_space[16];
+	struct pci_cap_saved cap_saved[0];
+};
+
+/**
+ * pci_store_saved_state - Allocate and return an opaque struct containing
+ *			   the device saved state.
+ * @dev: PCI device that we're dealing with
+ *
+ * Rerturn NULL if no state or error.
+ */
+struct pci_saved_state *pci_store_saved_state(struct pci_dev *dev)
+{
+	struct pci_saved_state *state;
+	struct pci_cap_saved_state *tmp;
+	struct pci_cap_saved *cap_saved;
+	struct hlist_node *pos;
+	size_t size;
+
+	if (!dev->state_saved)
+		return NULL;
+
+	size = sizeof(*state) + sizeof(struct pci_cap_saved);
+
+	hlist_for_each_entry(tmp, pos, &dev->saved_cap_space, next)
+		size += sizeof(struct pci_cap_saved) + tmp->saved.size;
+
+	state = kzalloc(size, GFP_KERNEL);
+	if (!state)
+		return NULL;
+
+	memcpy(state->config_space, dev->saved_config_space,
+	       sizeof(state->config_space));
+
+	cap_saved = state->cap_saved;
+	hlist_for_each_entry(tmp, pos, &dev->saved_cap_space, next) {
+		size_t len = sizeof(struct pci_cap_saved) + tmp->saved.size;
+		memcpy(cap_saved, &tmp->saved, len);
+		cap_saved = (struct pci_cap_saved *)((u8 *)cap_saved + len);
+	}
+	/* Empty cap_save terminates list */
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
+int pci_load_saved_state(struct pci_dev *dev, struct pci_saved_state *state)
+{
+	struct pci_cap_saved *cap_saved;
+
+	dev->state_saved = false;
+
+	if (!state)
+		return 0;
+
+	memcpy(dev->saved_config_space, state->config_space,
+	       sizeof(state->config_space));
+
+	cap_saved = state->cap_saved;
+	while (cap_saved->size) {
+		struct pci_cap_saved_state *tmp;
+
+		tmp = pci_find_saved_cap(dev, cap_saved->cap_nr);
+		if (!tmp || tmp->saved.size != cap_saved->size)
+			return -EINVAL;
+
+		memcpy(tmp->saved.data, cap_saved->data, tmp->saved.size);
+		cap_saved = (struct pci_cap_saved *)((u8 *)cap_saved +
+			    sizeof(struct pci_cap_saved) + cap_saved->size);
+	}
+
+	dev->state_saved = true;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_load_saved_state);
+
+/**
+ * pci_load_and_free_saved_state - Reload the save state pointed to by state,
+ *				   and free the memory allocated for it.
+ * @dev: PCI device that we're dealing with
+ * @state: Pointer to saved state returned from pci_store_saved_state()
+ */
+int pci_load_and_free_saved_state(struct pci_dev *dev,
+				  struct pci_saved_state **state)
+{
+	int ret = pci_load_saved_state(dev, *state);
+	kfree(*state);
+	*state = NULL;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pci_load_and_free_saved_state);
+
 static int do_pci_enable_device(struct pci_dev *dev, int bars)
 {
 	int err;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 46fd382..f2a6262 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -812,6 +812,10 @@ size_t pci_get_rom_size(struct pci_dev *pdev, void __iomem *rom, size_t size);
 /* Power management related routines */
 int pci_save_state(struct pci_dev *dev);
 void pci_restore_state(struct pci_dev *dev);
+struct pci_saved_state *pci_store_saved_state(struct pci_dev *dev);
+int pci_load_saved_state(struct pci_dev *dev, struct pci_saved_state *state);
+int pci_load_and_free_saved_state(struct pci_dev *dev,
+				  struct pci_saved_state **state);
 int __pci_complete_power_transition(struct pci_dev *dev, pci_power_t state);
 int pci_set_power_state(struct pci_dev *dev, pci_power_t state);
 pci_power_t pci_choose_state(struct pci_dev *dev, pm_message_t state);

