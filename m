Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab2BKITD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 03:19:03 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:42216 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab2BKITA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 03:19:00 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] PCI: move pci_find_saved_cap out of linux/pci.h
Date: Sat, 11 Feb 2012 00:18:41 -0800
Message-Id: <1328948321-14791-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4F362472.00A3,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only have user in driver/pci/pci.c

Don't need to put it in global pci.h

Signed-off-by: Yinghai Lu <yinghai@kernel.org.

---
 drivers/pci/pci.c   |   19 +++++++++++++++++++
 include/linux/pci.h |   19 -------------------
 2 files changed, 19 insertions(+), 19 deletions(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -825,6 +825,19 @@ EXPORT_SYMBOL(pci_choose_state);
 #define pcie_cap_has_sltctl2(type, flags)		\
 		((flags & PCI_EXP_FLAGS_VERS) > 1)
 
+static struct pci_cap_saved_state *pci_find_saved_cap(
+	struct pci_dev *pci_dev, char cap)
+{
+	struct pci_cap_saved_state *tmp;
+	struct hlist_node *pos;
+
+	hlist_for_each_entry(tmp, pos, &pci_dev->saved_cap_space, next) {
+		if (tmp->cap.cap_nr == cap)
+			return tmp;
+	}
+	return NULL;
+}
+
 static int pci_save_pcie_state(struct pci_dev *dev)
 {
 	int pos, i = 0;
@@ -1869,6 +1882,12 @@ void platform_pci_wakeup_init(struct pci
 	platform_pci_sleep_wake(dev, false);
 }
 
+static void pci_add_saved_cap(struct pci_dev *pci_dev,
+	struct pci_cap_saved_state *new_cap)
+{
+	hlist_add_head(&new_cap->next, &pci_dev->saved_cap_space);
+}
+
 /**
  * pci_add_save_buffer - allocate buffer for saving given capability registers
  * @dev: the PCI device
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -368,25 +368,6 @@ static inline int pci_channel_offline(st
 	return (pdev->error_state != pci_channel_io_normal);
 }
 
-static inline struct pci_cap_saved_state *pci_find_saved_cap(
-	struct pci_dev *pci_dev, char cap)
-{
-	struct pci_cap_saved_state *tmp;
-	struct hlist_node *pos;
-
-	hlist_for_each_entry(tmp, pos, &pci_dev->saved_cap_space, next) {
-		if (tmp->cap.cap_nr == cap)
-			return tmp;
-	}
-	return NULL;
-}
-
-static inline void pci_add_saved_cap(struct pci_dev *pci_dev,
-	struct pci_cap_saved_state *new_cap)
-{
-	hlist_add_head(&new_cap->next, &pci_dev->saved_cap_space);
-}
-
 /*
  * The first PCI_BRIDGE_RESOURCE_NUM PCI bus resources (those that correspond
  * to P2P or CardBus bridge windows) go in a table.  Additional ones (for
