Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab1DTUbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:31:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192Ab1DTUbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:31:36 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v3 1/3] PCI: Track the size of each saved capability data area
To: linux-pci@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com
Cc: linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        jan.kiszka@siemens.com, jbarnes@virtuousgeek.org
Date: Wed, 20 Apr 2011 14:31:33 -0600
Message-ID: <20110420203133.3189.22786.stgit@s20.home>
In-Reply-To: <20110420202523.3189.31306.stgit@s20.home>
References: <20110420202523.3189.31306.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow us to store and load it later.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/pci/pci.c   |   12 +++++++-----
 include/linux/pci.h |   11 ++++++++---
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 2472e71..d2500a0 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -830,7 +830,7 @@ static int pci_save_pcie_state(struct pci_dev *dev)
 		dev_err(&dev->dev, "buffer not found in %s\n", __func__);
 		return -ENOMEM;
 	}
-	cap = (u16 *)&save_state->data[0];
+	cap = (u16 *)&save_state->saved.data[0];
 
 	pci_read_config_word(dev, pos + PCI_EXP_FLAGS, &flags);
 
@@ -863,7 +863,7 @@ static void pci_restore_pcie_state(struct pci_dev *dev)
 	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
 	if (!save_state || pos <= 0)
 		return;
-	cap = (u16 *)&save_state->data[0];
+	cap = (u16 *)&save_state->saved.data[0];
 
 	pci_read_config_word(dev, pos + PCI_EXP_FLAGS, &flags);
 
@@ -899,7 +899,8 @@ static int pci_save_pcix_state(struct pci_dev *dev)
 		return -ENOMEM;
 	}
 
-	pci_read_config_word(dev, pos + PCI_X_CMD, (u16 *)save_state->data);
+	pci_read_config_word(dev, pos + PCI_X_CMD,
+			     (u16 *)save_state->saved.data);
 
 	return 0;
 }
@@ -914,7 +915,7 @@ static void pci_restore_pcix_state(struct pci_dev *dev)
 	pos = pci_find_capability(dev, PCI_CAP_ID_PCIX);
 	if (!save_state || pos <= 0)
 		return;
-	cap = (u16 *)&save_state->data[0];
+	cap = (u16 *)&save_state->saved.data[0];
 
 	pci_write_config_word(dev, pos + PCI_X_CMD, cap[i++]);
 }
@@ -1771,7 +1772,8 @@ static int pci_add_cap_save_buffer(
 	if (!save_state)
 		return -ENOMEM;
 
-	save_state->cap_nr = cap;
+	save_state->saved.cap_nr = cap;
+	save_state->saved.size = size;
 	pci_add_saved_cap(dev, save_state);
 
 	return 0;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 96f70d7..46fd382 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -214,12 +214,17 @@ enum pci_bus_speed {
 	PCI_SPEED_UNKNOWN		= 0xff,
 };
 
-struct pci_cap_saved_state {
-	struct hlist_node next;
+struct pci_cap_saved {
 	char cap_nr;
+	unsigned int size;
 	u32 data[0];
 };
 
+struct pci_cap_saved_state {
+	struct hlist_node next;
+	struct pci_cap_saved saved;
+};
+
 struct pcie_link_state;
 struct pci_vpd;
 struct pci_sriov;
@@ -366,7 +371,7 @@ static inline struct pci_cap_saved_state *pci_find_saved_cap(
 	struct hlist_node *pos;
 
 	hlist_for_each_entry(tmp, pos, &pci_dev->saved_cap_space, next) {
-		if (tmp->cap_nr == cap)
+		if (tmp->saved.cap_nr == cap)
 			return tmp;
 	}
 	return NULL;

