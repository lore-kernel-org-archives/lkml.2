Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab2GJPz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:55:28 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:49431 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab2GJPzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:55:21 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH 04/14] PCI: refine and move pcie_cap_has_*() macros to include/linux/pci.h
Date: Tue, 10 Jul 2012 23:54:05 +0800
Message-Id: <1341935655-5381-5-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341935655-5381-1-git-send-email-jiang.liu@huawei.com>
References: <1341935655-5381-1-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
References: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Move pcie_cap_has_*() macros to include/linux/pci.h, so they can be shared.
Since pcie_flags was introduced, rework these macros to take a struct pci_dev *
and use pcie_flags insead of type and flags.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/pci.c   |   50 ++++++++++++--------------------------------------
 include/linux/pci.h |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 38 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 28eb55b..4c6ab70 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -272,15 +272,11 @@ int pci_bus_find_capability(struct pci_bus *bus, unsigned int devfn, int cap)
  */
 static int pci_pcie_cap2(struct pci_dev *dev)
 {
-	u16 flags;
 	int pos;
 
 	pos = pci_pcie_cap(dev);
-	if (pos) {
-		pci_read_config_word(dev, pos + PCI_EXP_FLAGS, &flags);
-		if ((flags & PCI_EXP_FLAGS_VERS) < 2)
-			pos = 0;
-	}
+	if (pos && !pci_pcie_cap_has_cap2(dev))
+		pos = 0;
 
 	return pos;
 }
@@ -854,21 +850,6 @@ EXPORT_SYMBOL(pci_choose_state);
 
 #define PCI_EXP_SAVE_REGS	7
 
-#define pcie_cap_has_devctl(type, flags)	1
-#define pcie_cap_has_lnkctl(type, flags)		\
-		((flags & PCI_EXP_FLAGS_VERS) > 1 ||	\
-		 (type == PCI_EXP_TYPE_ROOT_PORT ||	\
-		  type == PCI_EXP_TYPE_ENDPOINT ||	\
-		  type == PCI_EXP_TYPE_LEG_END))
-#define pcie_cap_has_sltctl(type, flags)		\
-		((flags & PCI_EXP_FLAGS_VERS) > 1 ||	\
-		 ((type == PCI_EXP_TYPE_ROOT_PORT) ||	\
-		  (type == PCI_EXP_TYPE_DOWNSTREAM &&	\
-		   (flags & PCI_EXP_FLAGS_SLOT))))
-#define pcie_cap_has_rtctl(type, flags)			\
-		((flags & PCI_EXP_FLAGS_VERS) > 1 ||	\
-		 (type == PCI_EXP_TYPE_ROOT_PORT ||	\
-		  type == PCI_EXP_TYPE_RC_EC))
 
 static struct pci_cap_saved_state *pci_find_saved_cap(
 	struct pci_dev *pci_dev, char cap)
@@ -885,10 +866,9 @@ static struct pci_cap_saved_state *pci_find_saved_cap(
 
 static int pci_save_pcie_state(struct pci_dev *dev)
 {
-	int type, pos, i = 0;
+	int pos, i = 0;
 	struct pci_cap_saved_state *save_state;
 	u16 *cap;
-	u16 flags;
 
 	pos = pci_pcie_cap(dev);
 	if (!pos)
@@ -901,16 +881,14 @@ static int pci_save_pcie_state(struct pci_dev *dev)
 	}
 	cap = (u16 *)&save_state->cap.data[0];
 
-	pci_read_config_word(dev, pos + PCI_EXP_FLAGS, &flags);
 
-	type = pci_pcie_type(dev);
-	if (pcie_cap_has_devctl(type, flags))
+	if (pci_pcie_cap_has_devctl(dev))
 		pci_read_config_word(dev, pos + PCI_EXP_DEVCTL, &cap[i++]);
-	if (pcie_cap_has_lnkctl(type, flags))
+	if (pci_pcie_cap_has_lnkctl(dev))
 		pci_read_config_word(dev, pos + PCI_EXP_LNKCTL, &cap[i++]);
-	if (pcie_cap_has_sltctl(type, flags))
+	if (pci_pcie_cap_has_sltctl(dev))
 		pci_read_config_word(dev, pos + PCI_EXP_SLTCTL, &cap[i++]);
-	if (pcie_cap_has_rtctl(type, flags))
+	if (pci_pcie_cap_has_rtctl(dev))
 		pci_read_config_word(dev, pos + PCI_EXP_RTCTL, &cap[i++]);
 
 	pos = pci_pcie_cap2(dev);
@@ -925,10 +903,9 @@ static int pci_save_pcie_state(struct pci_dev *dev)
 
 static void pci_restore_pcie_state(struct pci_dev *dev)
 {
-	int i = 0, pos, type;
+	int i = 0, pos;
 	struct pci_cap_saved_state *save_state;
 	u16 *cap;
-	u16 flags;
 
 	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_EXP);
 	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
@@ -936,16 +913,13 @@ static void pci_restore_pcie_state(struct pci_dev *dev)
 		return;
 	cap = (u16 *)&save_state->cap.data[0];
 
-	pci_read_config_word(dev, pos + PCI_EXP_FLAGS, &flags);
-
-	type = pci_pcie_type(dev);
-	if (pcie_cap_has_devctl(type, flags))
+	if (pci_pcie_cap_has_devctl(dev))
 		pci_write_config_word(dev, pos + PCI_EXP_DEVCTL, cap[i++]);
-	if (pcie_cap_has_lnkctl(type, flags))
+	if (pci_pcie_cap_has_lnkctl(dev))
 		pci_write_config_word(dev, pos + PCI_EXP_LNKCTL, cap[i++]);
-	if (pcie_cap_has_sltctl(type, flags))
+	if (pci_pcie_cap_has_sltctl(dev))
 		pci_write_config_word(dev, pos + PCI_EXP_SLTCTL, cap[i++]);
-	if (pcie_cap_has_rtctl(type, flags))
+	if (pci_pcie_cap_has_rtctl(dev))
 		pci_write_config_word(dev, pos + PCI_EXP_RTCTL, cap[i++]);
 
 	pos = pci_pcie_cap2(dev);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 1837354..346b2d9 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1659,6 +1659,49 @@ static inline int pci_pcie_type(const struct pci_dev *dev)
 	return (dev->pcie_flags & PCI_EXP_FLAGS_TYPE) >> 4;
 }
 
+static inline int pci_pcie_cap_version(const struct pci_dev *pdev)
+{
+	return pdev->pcie_flags & PCI_EXP_FLAGS_VERS;
+}
+
+static inline int pci_pcie_cap_has_cap2(const struct pci_dev *pdev)
+{
+	return pci_pcie_cap_version(pdev) > 1;
+}
+
+static inline bool pci_pcie_cap_has_devctl(const struct pci_dev *pdev)
+{
+	return true;
+}
+
+static inline bool pci_pcie_cap_has_lnkctl(const struct pci_dev *pdev)
+{
+	int type = pci_pcie_type(pdev);
+
+	return pci_pcie_cap_version(pdev) > 1 ||
+	       type == PCI_EXP_TYPE_ROOT_PORT ||
+	       type == PCI_EXP_TYPE_ENDPOINT ||
+	       type == PCI_EXP_TYPE_LEG_END;
+}
+
+static inline bool pci_pcie_cap_has_sltctl(const struct pci_dev *pdev)
+{
+	int type = pci_pcie_type(pdev);
+
+	return pci_pcie_cap_version(pdev) > 1 ||
+	       type == PCI_EXP_TYPE_ROOT_PORT ||
+	       (type == PCI_EXP_TYPE_DOWNSTREAM &&
+		pdev->pcie_flags & PCI_EXP_FLAGS_SLOT);
+}
+
+static inline bool pci_pcie_cap_has_rtctl(const struct pci_dev *pdev)
+{
+	int type = pci_pcie_type(pdev);
+
+	return pci_pcie_cap_version(pdev) > 1 ||
+	       type == PCI_EXP_TYPE_ROOT_PORT ||
+	       type == PCI_EXP_TYPE_RC_EC;
+}
 
 void pci_request_acs(void);
 bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags);
-- 
1.7.9.5

