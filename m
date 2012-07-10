Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab2GJPzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:55:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43454 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab2GJPz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:55:29 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH 05/14] PCI: add access functions for PCIe capabilities to hide PCIe spec differences
Date: Tue, 10 Jul 2012 23:54:06 +0800
Message-Id: <1341935655-5381-6-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341935655-5381-1-git-send-email-jiang.liu@huawei.com>
References: <1341935655-5381-1-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
References: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Introduce four configuration access functions for PCIe capabilities to
hide difference among PCIe Base Spec versions. With these functions,
we can remove callers responsible for using pci_pcie_cap_has_*().

pci_pcie_cap_read_word/dword() functions will store the pcie cap register
value by passed parameter val,if related pcie cap register is not implemented
on the pcie device, the passed parameter val will be set 0 and return -EINVAL.

pci_pcie_capability_write_word/dowrd() functions will write the value to pcie
cap registers,if related pcie cap register is not implemented on the pcie
device, it will return -EINVAL.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/access.c     |   88 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h      |   10 ++++++
 include/linux/pci_regs.h |   19 ++++++++--
 3 files changed, 115 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index ba91a7e..80ae022 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -469,3 +469,91 @@ void pci_cfg_access_unlock(struct pci_dev *dev)
 	raw_spin_unlock_irqrestore(&pci_lock, flags);
 }
 EXPORT_SYMBOL_GPL(pci_cfg_access_unlock);
+
+static int
+pci_pcie_cap_get_offset(struct pci_dev *dev, int where, size_t sz)
+{
+	bool valid;
+
+	if (!pci_is_pcie(dev))
+		return -EINVAL;
+	if (where & (sz - 1))
+		return -EINVAL;
+
+	if (where < 0)
+		valid = false;
+	else if (where < PCI_EXP_DEVCAP)
+		valid = true;
+	else if (where < PCI_EXP_LNKCAP)
+		valid = pci_pcie_cap_has_devctl(dev);
+	else if (where < PCI_EXP_SLTCAP)
+		valid = pci_pcie_cap_has_lnkctl(dev);
+	else if (where < PCI_EXP_RTCTL)
+		valid = pci_pcie_cap_has_sltctl(dev);
+	else if (where < PCI_EXP_DEVCAP2)
+		valid = pci_pcie_cap_has_rtctl(dev);
+	else if (where < PCI_EXP_CAP2_SIZE)
+		valid = pci_pcie_cap_has_cap2(dev);
+	else
+		valid = false;
+
+	return valid ? where + pci_pcie_cap(dev) : -EINVAL;
+}
+
+int pci_pcie_cap_read_word(struct pci_dev *dev, int where, u16 *valp)
+{
+	*valp = 0;
+	where = pci_pcie_cap_get_offset(dev, where, sizeof(u16));
+	if (where >= 0)
+		return pci_read_config_word(dev, where, valp);
+
+	if (pci_is_pcie(dev) && where == PCI_EXP_SLTSTA &&
+	    pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM)
+		*valp = PCI_EXP_SLTSTA_PDS;
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(pci_pcie_cap_read_word);
+
+int pci_pcie_cap_read_dword(struct pci_dev *dev, int where, u32 *valp)
+{
+	*valp = 0;
+	where = pci_pcie_cap_get_offset(dev, where, sizeof(u32));
+	if (where >= 0)
+		return pci_read_config_dword(dev, where, valp);
+
+	/*
+	 * Quotation from PCIe Base Spec 3.0:
+	 * For Functions that do not implement the Slot Capabilities,
+	 * Slot Status, and Slot Control registers, these spaces must
+	 * be hardwired to 0b, with the exception of the Presence Detect
+	 * State bit in the Slot Status register of Downstream Ports,
+	 * which must be hardwired to 1b.
+	 */
+	if (pci_is_pcie(dev) && where == PCI_EXP_SLTCTL &&
+	    pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM)
+		*valp = PCI_EXP_SLTSTA_PDS << 16;
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(pci_pcie_cap_read_dword);
+
+int pci_pcie_cap_write_word(struct pci_dev *dev, int where, u16 val)
+{
+	where = pci_pcie_cap_get_offset(dev, where, sizeof(u16));
+	if (where >= 0)
+		return pci_write_config_word(dev, where, val);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(pci_pcie_cap_write_word);
+
+int pci_pcie_cap_write_dword(struct pci_dev *dev, int where, u32 val)
+{
+	where = pci_pcie_cap_get_offset(dev, where, sizeof(u32));
+	if (where >= 0)
+		return pci_write_config_dword(dev, where, val);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(pci_pcie_cap_write_dword);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 346b2d9..78767b2 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1703,6 +1703,11 @@ static inline bool pci_pcie_cap_has_rtctl(const struct pci_dev *pdev)
 	       type == PCI_EXP_TYPE_RC_EC;
 }
 
+extern int pci_pcie_cap_read_word(struct pci_dev *dev, int where, u16 *valp);
+extern int pci_pcie_cap_read_dword(struct pci_dev *dev, int where, u32 *valp);
+extern int pci_pcie_cap_write_word(struct pci_dev *dev, int where, u16 val);
+extern int pci_pcie_cap_write_dword(struct pci_dev *dev, int where, u32 val);
+
 void pci_request_acs(void);
 bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags);
 bool pci_acs_path_enabled(struct pci_dev *start,
@@ -1843,5 +1848,10 @@ static inline struct eeh_dev *pci_dev_to_eeh_dev(struct pci_dev *pdev)
  */
 struct pci_dev *pci_find_upstream_pcie_bridge(struct pci_dev *pdev);
 
+int pci_pcie_capability_read_word(struct pci_dev *dev, int where, u16 *val);
+int pci_pcie_capability_read_dword(struct pci_dev *dev, int where, u32 *val);
+int pci_pcie_capability_write_word(struct pci_dev *dev, int where, u16 val);
+int pci_pcie_capability_write_dword(struct pci_dev *dev, int where, u32 val);
+
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index 53274bf..ac60e22 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -542,9 +542,24 @@
 #define  PCI_EXP_OBFF_MSGA_EN	0x2000	/* OBFF enable with Message type A */
 #define  PCI_EXP_OBFF_MSGB_EN	0x4000	/* OBFF enable with Message type B */
 #define  PCI_EXP_OBFF_WAKE_EN	0x6000	/* OBFF using WAKE# signaling */
-#define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2	44	/* v2 endpoints end here */
+#define PCI_EXP_DEVSTA2		42	/* Device Status 2 */
+#define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2	44 /* v2 endpoints end here */
+#define PCI_EXP_LNKCAP2		44	/* Link Capabilities 2 */
 #define PCI_EXP_LNKCTL2		48	/* Link Control 2 */
-#define PCI_EXP_SLTCTL2		56	/* Slot Control 2 */
+#define  PCI_EXP_LNKCTL2_TLS	0x0f	/* Target Link Speed */
+#define  PCI_EXP_LNKCTL2_EC	0x10	/* Enter Compliance */
+#define  PCI_EXP_LNKCTL2_HASD	0x20	/* Hardware Autonomous Speed Disable */
+#define  PCI_EXP_LNKCTL2_SD	0x40	/* Selectable De-emphasis */
+#define  PCI_EXP_LNKCTL2_TM	0x380	/* Transmit Margin */
+#define  PCI_EXP_LNKCTL2_EMC	0x400	/* Enter Modified Compliance */
+#define  PCI_EXP_LNKCTL2_CS	0x800	/* Compliance SOS */
+#define  PCI_EXP_LNKCTL2_CD	0x1000	/* Compliance De-emphasis */
+#define PCI_EXP_LNKSTA2		50	/* Link Status 2 */
+#define  PCI_EXP_LNKSTA2_CDL	0x01	/* Current De-emphasis Level */
+#define PCI_EXP_SLTCAP2		52	/* Slot Capabilities 2 */
+#define PCI_EXP_SLTCTL2		56	/* Slot Control 2*/
+#define PCI_EXP_SLTSTA2		58	/* Slot Status 2*/
+#define	PCI_EXP_CAP2_SIZE	60
 
 /* Extended Capabilities (PCI-X 2.0 and Express) */
 #define PCI_EXT_CAP_ID(header)		(header & 0x0000ffff)
-- 
1.7.9.5

