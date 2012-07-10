Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab2GJPzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:55:48 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61877 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab2GJPzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:55:42 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH 06/14] PCI: use PCIe cap access functions to simplify PCI core implementation
Date: Tue, 10 Jul 2012 23:54:07 +0800
Message-Id: <1341935655-5381-7-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341935655-5381-1-git-send-email-jiang.liu@huawei.com>
References: <1341935655-5381-1-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
References: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe cap access functions to simplify PCI core implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/pci.c    |  237 ++++++++++++++------------------------------------
 drivers/pci/probe.c  |   19 ++--
 drivers/pci/quirks.c |    8 +-
 3 files changed, 73 insertions(+), 191 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 4c6ab70..b8142f1 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -254,34 +254,6 @@ int pci_bus_find_capability(struct pci_bus *bus, unsigned int devfn, int cap)
 }
 
 /**
- * pci_pcie_cap2 - query for devices' PCI_CAP_ID_EXP v2 capability structure
- * @dev: PCI device to check
- *
- * Like pci_pcie_cap() but also checks that the PCIe capability version is
- * >= 2.  Note that v1 capability structures could be sparse in that not
- * all register fields were required.  v2 requires the entire structure to
- * be present size wise, while still allowing for non-implemented registers
- * to exist but they must be hardwired to 0.
- *
- * Due to the differences in the versions of capability structures, one
- * must be careful not to try and access non-existant registers that may
- * exist in early versions - v1 - of Express devices.
- *
- * Returns the offset of the PCIe capability structure as long as the
- * capability version is >= 2; otherwise 0 is returned.
- */
-static int pci_pcie_cap2(struct pci_dev *dev)
-{
-	int pos;
-
-	pos = pci_pcie_cap(dev);
-	if (pos && !pci_pcie_cap_has_cap2(dev))
-		pos = 0;
-
-	return pos;
-}
-
-/**
  * pci_find_ext_capability - Find an extended capability
  * @dev: PCI device to query
  * @cap: capability code
@@ -866,12 +838,11 @@ static struct pci_cap_saved_state *pci_find_saved_cap(
 
 static int pci_save_pcie_state(struct pci_dev *dev)
 {
-	int pos, i = 0;
+	int i = 0;
 	struct pci_cap_saved_state *save_state;
 	u16 *cap;
 
-	pos = pci_pcie_cap(dev);
-	if (!pos)
+	if (!pci_is_pcie(dev))
 		return 0;
 
 	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_EXP);
@@ -881,54 +852,35 @@ static int pci_save_pcie_state(struct pci_dev *dev)
 	}
 	cap = (u16 *)&save_state->cap.data[0];
 
+	pci_pcie_cap_read_word(dev, PCI_EXP_DEVCTL, &cap[i++]);
+	pci_pcie_cap_read_word(dev, PCI_EXP_LNKCTL, &cap[i++]);
+	pci_pcie_cap_read_word(dev, PCI_EXP_SLTCTL, &cap[i++]);
+	pci_pcie_cap_read_word(dev, PCI_EXP_RTCTL,  &cap[i++]);
+	pci_pcie_cap_read_word(dev, PCI_EXP_DEVCTL2, &cap[i++]);
+	pci_pcie_cap_read_word(dev, PCI_EXP_LNKCTL2, &cap[i++]);
+	pci_pcie_cap_read_word(dev, PCI_EXP_SLTCTL2, &cap[i++]);
 
-	if (pci_pcie_cap_has_devctl(dev))
-		pci_read_config_word(dev, pos + PCI_EXP_DEVCTL, &cap[i++]);
-	if (pci_pcie_cap_has_lnkctl(dev))
-		pci_read_config_word(dev, pos + PCI_EXP_LNKCTL, &cap[i++]);
-	if (pci_pcie_cap_has_sltctl(dev))
-		pci_read_config_word(dev, pos + PCI_EXP_SLTCTL, &cap[i++]);
-	if (pci_pcie_cap_has_rtctl(dev))
-		pci_read_config_word(dev, pos + PCI_EXP_RTCTL, &cap[i++]);
-
-	pos = pci_pcie_cap2(dev);
-	if (!pos)
-		return 0;
-
-	pci_read_config_word(dev, pos + PCI_EXP_DEVCTL2, &cap[i++]);
-	pci_read_config_word(dev, pos + PCI_EXP_LNKCTL2, &cap[i++]);
-	pci_read_config_word(dev, pos + PCI_EXP_SLTCTL2, &cap[i++]);
 	return 0;
 }
 
 static void pci_restore_pcie_state(struct pci_dev *dev)
 {
-	int i = 0, pos;
+	int i = 0;
 	struct pci_cap_saved_state *save_state;
 	u16 *cap;
 
 	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_EXP);
-	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
-	if (!save_state || pos <= 0)
+	if (!save_state)
 		return;
 	cap = (u16 *)&save_state->cap.data[0];
 
-	if (pci_pcie_cap_has_devctl(dev))
-		pci_write_config_word(dev, pos + PCI_EXP_DEVCTL, cap[i++]);
-	if (pci_pcie_cap_has_lnkctl(dev))
-		pci_write_config_word(dev, pos + PCI_EXP_LNKCTL, cap[i++]);
-	if (pci_pcie_cap_has_sltctl(dev))
-		pci_write_config_word(dev, pos + PCI_EXP_SLTCTL, cap[i++]);
-	if (pci_pcie_cap_has_rtctl(dev))
-		pci_write_config_word(dev, pos + PCI_EXP_RTCTL, cap[i++]);
-
-	pos = pci_pcie_cap2(dev);
-	if (!pos)
-		return;
-
-	pci_write_config_word(dev, pos + PCI_EXP_DEVCTL2, cap[i++]);
-	pci_write_config_word(dev, pos + PCI_EXP_LNKCTL2, cap[i++]);
-	pci_write_config_word(dev, pos + PCI_EXP_SLTCTL2, cap[i++]);
+	pci_pcie_cap_write_word(dev, PCI_EXP_DEVCTL, cap[i++]);
+	pci_pcie_cap_write_word(dev, PCI_EXP_LNKCTL, cap[i++]);
+	pci_pcie_cap_write_word(dev, PCI_EXP_SLTCTL, cap[i++]);
+	pci_pcie_cap_write_word(dev, PCI_EXP_RTCTL,  cap[i++]);
+	pci_pcie_cap_write_word(dev, PCI_EXP_DEVCTL2, cap[i++]);
+	pci_pcie_cap_write_word(dev, PCI_EXP_LNKCTL2, cap[i++]);
+	pci_pcie_cap_write_word(dev, PCI_EXP_SLTCTL2, cap[i++]);
 }
 
 
@@ -2042,7 +1994,6 @@ void pci_free_cap_save_buffers(struct pci_dev *dev)
  */
 void pci_enable_ari(struct pci_dev *dev)
 {
-	int pos;
 	u32 cap;
 	u16 ctrl;
 	struct pci_dev *bridge;
@@ -2050,8 +2001,7 @@ void pci_enable_ari(struct pci_dev *dev)
 	if (pcie_ari_disabled || !pci_is_pcie(dev) || dev->devfn)
 		return;
 
-	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI);
-	if (!pos)
+	if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI))
 		return;
 
 	bridge = dev->bus->self;
@@ -2059,17 +2009,14 @@ void pci_enable_ari(struct pci_dev *dev)
 		return;
 
 	/* ARI is a PCIe cap v2 feature */
-	pos = pci_pcie_cap2(bridge);
-	if (!pos)
+	if (pci_pcie_cap_read_dword(bridge, PCI_EXP_DEVCAP2, &cap) ||
+	   !(cap & PCI_EXP_DEVCAP2_ARI))
 		return;
 
-	pci_read_config_dword(bridge, pos + PCI_EXP_DEVCAP2, &cap);
-	if (!(cap & PCI_EXP_DEVCAP2_ARI))
+	if (pci_pcie_cap_read_word(bridge, PCI_EXP_DEVCTL2, &ctrl))
 		return;
-
-	pci_read_config_word(bridge, pos + PCI_EXP_DEVCTL2, &ctrl);
 	ctrl |= PCI_EXP_DEVCTL2_ARI;
-	pci_write_config_word(bridge, pos + PCI_EXP_DEVCTL2, ctrl);
+	pci_pcie_cap_write_word(bridge, PCI_EXP_DEVCTL2, ctrl);
 
 	bridge->ari_enabled = 1;
 }
@@ -2085,20 +2032,16 @@ void pci_enable_ari(struct pci_dev *dev)
  */
 void pci_enable_ido(struct pci_dev *dev, unsigned long type)
 {
-	int pos;
 	u16 ctrl;
 
 	/* ID-based Ordering is a PCIe cap v2 feature */
-	pos = pci_pcie_cap2(dev);
-	if (!pos)
+	if (pci_pcie_cap_read_word(dev, PCI_EXP_DEVCTL2, &ctrl))
 		return;
-
-	pci_read_config_word(dev, pos + PCI_EXP_DEVCTL2, &ctrl);
 	if (type & PCI_EXP_IDO_REQUEST)
 		ctrl |= PCI_EXP_IDO_REQ_EN;
 	if (type & PCI_EXP_IDO_COMPLETION)
 		ctrl |= PCI_EXP_IDO_CMP_EN;
-	pci_write_config_word(dev, pos + PCI_EXP_DEVCTL2, ctrl);
+	pci_pcie_cap_write_word(dev, PCI_EXP_DEVCTL2, ctrl);
 }
 EXPORT_SYMBOL(pci_enable_ido);
 
@@ -2109,20 +2052,16 @@ EXPORT_SYMBOL(pci_enable_ido);
  */
 void pci_disable_ido(struct pci_dev *dev, unsigned long type)
 {
-	int pos;
 	u16 ctrl;
 
 	/* ID-based Ordering is a PCIe cap v2 feature */
-	pos = pci_pcie_cap2(dev);
-	if (!pos)
+	if (pci_pcie_cap_read_word(dev, PCI_EXP_DEVCTL2, &ctrl))
 		return;
-
-	pci_read_config_word(dev, pos + PCI_EXP_DEVCTL2, &ctrl);
 	if (type & PCI_EXP_IDO_REQUEST)
 		ctrl &= ~PCI_EXP_IDO_REQ_EN;
 	if (type & PCI_EXP_IDO_COMPLETION)
 		ctrl &= ~PCI_EXP_IDO_CMP_EN;
-	pci_write_config_word(dev, pos + PCI_EXP_DEVCTL2, ctrl);
+	pci_pcie_cap_write_word(dev, PCI_EXP_DEVCTL2, ctrl);
 }
 EXPORT_SYMBOL(pci_disable_ido);
 
@@ -2147,18 +2086,12 @@ EXPORT_SYMBOL(pci_disable_ido);
  */
 int pci_enable_obff(struct pci_dev *dev, enum pci_obff_signal_type type)
 {
-	int pos;
 	u32 cap;
 	u16 ctrl;
 	int ret;
 
-	/* OBFF is a PCIe cap v2 feature */
-	pos = pci_pcie_cap2(dev);
-	if (!pos)
-		return -ENOTSUPP;
-
-	pci_read_config_dword(dev, pos + PCI_EXP_DEVCAP2, &cap);
-	if (!(cap & PCI_EXP_OBFF_MASK))
+	if (pci_pcie_cap_read_dword(dev, PCI_EXP_DEVCAP2, &cap) ||
+	    !(cap & PCI_EXP_OBFF_MASK))
 		return -ENOTSUPP; /* no OBFF support at all */
 
 	/* Make sure the topology supports OBFF as well */
@@ -2168,7 +2101,7 @@ int pci_enable_obff(struct pci_dev *dev, enum pci_obff_signal_type type)
 			return ret;
 	}
 
-	pci_read_config_word(dev, pos + PCI_EXP_DEVCTL2, &ctrl);
+	pci_pcie_cap_read_word(dev, PCI_EXP_DEVCTL2, &ctrl);
 	if (cap & PCI_EXP_OBFF_WAKE)
 		ctrl |= PCI_EXP_OBFF_WAKE_EN;
 	else {
@@ -2186,7 +2119,7 @@ int pci_enable_obff(struct pci_dev *dev, enum pci_obff_signal_type type)
 			return -ENOTSUPP;
 		}
 	}
-	pci_write_config_word(dev, pos + PCI_EXP_DEVCTL2, ctrl);
+	pci_pcie_cap_write_word(dev, PCI_EXP_DEVCTL2, ctrl);
 
 	return 0;
 }
@@ -2200,17 +2133,13 @@ EXPORT_SYMBOL(pci_enable_obff);
  */
 void pci_disable_obff(struct pci_dev *dev)
 {
-	int pos;
 	u16 ctrl;
 
 	/* OBFF is a PCIe cap v2 feature */
-	pos = pci_pcie_cap2(dev);
-	if (!pos)
-		return;
-
-	pci_read_config_word(dev, pos + PCI_EXP_DEVCTL2, &ctrl);
-	ctrl &= ~PCI_EXP_OBFF_WAKE_EN;
-	pci_write_config_word(dev, pos + PCI_EXP_DEVCTL2, ctrl);
+	if (!pci_pcie_cap_read_word(dev, PCI_EXP_DEVCTL2, &ctrl)) {
+		ctrl &= ~PCI_EXP_OBFF_WAKE_EN;
+		pci_pcie_cap_write_word(dev, PCI_EXP_DEVCTL2, ctrl);
+	}
 }
 EXPORT_SYMBOL(pci_disable_obff);
 
@@ -2223,17 +2152,14 @@ EXPORT_SYMBOL(pci_disable_obff);
  */
 static bool pci_ltr_supported(struct pci_dev *dev)
 {
-	int pos;
 	u32 cap;
 
 	/* LTR is a PCIe cap v2 feature */
-	pos = pci_pcie_cap2(dev);
-	if (!pos)
+	if (pci_pcie_cap_read_dword(dev, PCI_EXP_DEVCAP2, &cap) ||
+	    !(cap & PCI_EXP_DEVCAP2_LTR))
 		return false;
 
-	pci_read_config_dword(dev, pos + PCI_EXP_DEVCAP2, &cap);
-
-	return cap & PCI_EXP_DEVCAP2_LTR;
+	return true;
 }
 
 /**
@@ -2248,22 +2174,16 @@ static bool pci_ltr_supported(struct pci_dev *dev)
  */
 int pci_enable_ltr(struct pci_dev *dev)
 {
-	int pos;
 	u16 ctrl;
 	int ret;
 
-	if (!pci_ltr_supported(dev))
-		return -ENOTSUPP;
-
-	/* LTR is a PCIe cap v2 feature */
-	pos = pci_pcie_cap2(dev);
-	if (!pos)
-		return -ENOTSUPP;
-
 	/* Only primary function can enable/disable LTR */
 	if (PCI_FUNC(dev->devfn) != 0)
 		return -EINVAL;
 
+	if (!pci_ltr_supported(dev))
+		return -ENOTSUPP;
+
 	/* Enable upstream ports first */
 	if (dev->bus->self) {
 		ret = pci_enable_ltr(dev->bus->self);
@@ -2271,9 +2191,10 @@ int pci_enable_ltr(struct pci_dev *dev)
 			return ret;
 	}
 
-	pci_read_config_word(dev, pos + PCI_EXP_DEVCTL2, &ctrl);
+	if (pci_pcie_cap_read_word(dev, PCI_EXP_DEVCTL2, &ctrl))
+		return -ENOTSUPP;
 	ctrl |= PCI_EXP_LTR_EN;
-	pci_write_config_word(dev, pos + PCI_EXP_DEVCTL2, ctrl);
+	pci_pcie_cap_write_word(dev, PCI_EXP_DEVCTL2, ctrl);
 
 	return 0;
 }
@@ -2285,24 +2206,19 @@ EXPORT_SYMBOL(pci_enable_ltr);
  */
 void pci_disable_ltr(struct pci_dev *dev)
 {
-	int pos;
 	u16 ctrl;
 
-	if (!pci_ltr_supported(dev))
-		return;
-
-	/* LTR is a PCIe cap v2 feature */
-	pos = pci_pcie_cap2(dev);
-	if (!pos)
-		return;
-
 	/* Only primary function can enable/disable LTR */
 	if (PCI_FUNC(dev->devfn) != 0)
 		return;
 
-	pci_read_config_word(dev, pos + PCI_EXP_DEVCTL2, &ctrl);
-	ctrl &= ~PCI_EXP_LTR_EN;
-	pci_write_config_word(dev, pos + PCI_EXP_DEVCTL2, ctrl);
+	if (!pci_ltr_supported(dev))
+		return;
+
+	if (!pci_pcie_cap_read_word(dev, PCI_EXP_DEVCTL2, &ctrl)) {
+		ctrl &= ~PCI_EXP_LTR_EN;
+		pci_pcie_cap_write_word(dev, PCI_EXP_DEVCTL2, ctrl);
+	}
 }
 EXPORT_SYMBOL(pci_disable_ltr);
 
@@ -3152,16 +3068,11 @@ EXPORT_SYMBOL(pci_set_dma_seg_boundary);
 static int pcie_flr(struct pci_dev *dev, int probe)
 {
 	int i;
-	int pos;
 	u32 cap;
 	u16 status, control;
 
-	pos = pci_pcie_cap(dev);
-	if (!pos)
-		return -ENOTTY;
-
-	pci_read_config_dword(dev, pos + PCI_EXP_DEVCAP, &cap);
-	if (!(cap & PCI_EXP_DEVCAP_FLR))
+	if (pci_pcie_cap_read_dword(dev, PCI_EXP_DEVCAP, &cap) ||
+	    !(cap & PCI_EXP_DEVCAP_FLR))
 		return -ENOTTY;
 
 	if (probe)
@@ -3172,7 +3083,7 @@ static int pcie_flr(struct pci_dev *dev, int probe)
 		if (i)
 			msleep((1 << (i - 1)) * 100);
 
-		pci_read_config_word(dev, pos + PCI_EXP_DEVSTA, &status);
+		pci_pcie_cap_read_word(dev, PCI_EXP_DEVSTA, &status);
 		if (!(status & PCI_EXP_DEVSTA_TRPND))
 			goto clear;
 	}
@@ -3181,9 +3092,9 @@ static int pcie_flr(struct pci_dev *dev, int probe)
 			"proceeding with reset anyway\n");
 
 clear:
-	pci_read_config_word(dev, pos + PCI_EXP_DEVCTL, &control);
+	pci_pcie_cap_read_word(dev, PCI_EXP_DEVCTL, &control);
 	control |= PCI_EXP_DEVCTL_BCR_FLR;
-	pci_write_config_word(dev, pos + PCI_EXP_DEVCTL, control);
+	pci_pcie_cap_write_word(dev, PCI_EXP_DEVCTL, control);
 
 	msleep(100);
 
@@ -3551,14 +3462,10 @@ EXPORT_SYMBOL(pcix_set_mmrbc);
  */
 int pcie_get_readrq(struct pci_dev *dev)
 {
-	int ret, cap;
+	int ret;
 	u16 ctl;
 
-	cap = pci_pcie_cap(dev);
-	if (!cap)
-		return -EINVAL;
-
-	ret = pci_read_config_word(dev, cap + PCI_EXP_DEVCTL, &ctl);
+	ret = pci_pcie_cap_read_word(dev, PCI_EXP_DEVCTL, &ctl);
 	if (!ret)
 		ret = 128 << ((ctl & PCI_EXP_DEVCTL_READRQ) >> 12);
 
@@ -3576,17 +3483,13 @@ EXPORT_SYMBOL(pcie_get_readrq);
  */
 int pcie_set_readrq(struct pci_dev *dev, int rq)
 {
-	int cap, err = -EINVAL;
+	int err = -EINVAL;
 	u16 ctl, v;
 
 	if (rq < 128 || rq > 4096 || !is_power_of_2(rq))
 		goto out;
 
-	cap = pci_pcie_cap(dev);
-	if (!cap)
-		goto out;
-
-	err = pci_read_config_word(dev, cap + PCI_EXP_DEVCTL, &ctl);
+	err = pci_pcie_cap_read_word(dev, PCI_EXP_DEVCTL, &ctl);
 	if (err)
 		goto out;
 	/*
@@ -3609,7 +3512,7 @@ int pcie_set_readrq(struct pci_dev *dev, int rq)
 	if ((ctl & PCI_EXP_DEVCTL_READRQ) != v) {
 		ctl &= ~PCI_EXP_DEVCTL_READRQ;
 		ctl |= v;
-		err = pci_write_config_word(dev, cap + PCI_EXP_DEVCTL, ctl);
+		err = pci_pcie_cap_write_word(dev, PCI_EXP_DEVCTL, ctl);
 	}
 
 out:
@@ -3626,14 +3529,10 @@ EXPORT_SYMBOL(pcie_set_readrq);
  */
 int pcie_get_mps(struct pci_dev *dev)
 {
-	int ret, cap;
+	int ret;
 	u16 ctl;
 
-	cap = pci_pcie_cap(dev);
-	if (!cap)
-		return -EINVAL;
-
-	ret = pci_read_config_word(dev, cap + PCI_EXP_DEVCTL, &ctl);
+	ret = pci_pcie_cap_read_word(dev, PCI_EXP_DEVCTL, &ctl);
 	if (!ret)
 		ret = 128 << ((ctl & PCI_EXP_DEVCTL_PAYLOAD) >> 5);
 
@@ -3650,7 +3549,7 @@ int pcie_get_mps(struct pci_dev *dev)
  */
 int pcie_set_mps(struct pci_dev *dev, int mps)
 {
-	int cap, err = -EINVAL;
+	int err = -EINVAL;
 	u16 ctl, v;
 
 	if (mps < 128 || mps > 4096 || !is_power_of_2(mps))
@@ -3661,18 +3560,14 @@ int pcie_set_mps(struct pci_dev *dev, int mps)
 		goto out;
 	v <<= 5;
 
-	cap = pci_pcie_cap(dev);
-	if (!cap)
-		goto out;
-
-	err = pci_read_config_word(dev, cap + PCI_EXP_DEVCTL, &ctl);
+	err = pci_pcie_cap_read_word(dev, PCI_EXP_DEVCTL, &ctl);
 	if (err)
 		goto out;
 
 	if ((ctl & PCI_EXP_DEVCTL_PAYLOAD) != v) {
 		ctl &= ~PCI_EXP_DEVCTL_PAYLOAD;
 		ctl |= v;
-		err = pci_write_config_word(dev, cap + PCI_EXP_DEVCTL, ctl);
+		err = pci_pcie_cap_write_word(dev, PCI_EXP_DEVCTL, ctl);
 	}
 out:
 	return err;
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 446933d..5112ff5 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -603,10 +603,10 @@ static void pci_set_bus_speed(struct pci_bus *bus)
 		u32 linkcap;
 		u16 linksta;
 
-		pci_read_config_dword(bridge, pos + PCI_EXP_LNKCAP, &linkcap);
+		pci_pcie_cap_read_dword(bridge, PCI_EXP_LNKCAP, &linkcap);
 		bus->max_bus_speed = pcie_link_speed[linkcap & 0xf];
 
-		pci_read_config_word(bridge, pos + PCI_EXP_LNKSTA, &linksta);
+		pci_pcie_cap_read_word(bridge, PCI_EXP_LNKSTA, &linksta);
 		pcie_update_link_speed(bus, linksta);
 	}
 }
@@ -936,18 +936,10 @@ void set_pcie_port_type(struct pci_dev *pdev)
 
 void set_pcie_hotplug_bridge(struct pci_dev *pdev)
 {
-	int pos;
-	u16 reg16;
 	u32 reg32;
 
-	pos = pci_pcie_cap(pdev);
-	if (!pos)
-		return;
-	pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
-	if (!(reg16 & PCI_EXP_FLAGS_SLOT))
-		return;
-	pci_read_config_dword(pdev, pos + PCI_EXP_SLTCAP, &reg32);
-	if (reg32 & PCI_EXP_SLTCAP_HPC)
+	if (!pci_pcie_cap_read_dword(pdev, PCI_EXP_SLTCAP, &reg32) &&
+	    (reg32 & PCI_EXP_SLTCAP_HPC))
 		pdev->is_hotplug_bridge = 1;
 }
 
@@ -1160,8 +1152,7 @@ int pci_cfg_space_size(struct pci_dev *dev)
 	if (class == PCI_CLASS_BRIDGE_HOST)
 		return pci_cfg_space_size_ext(dev);
 
-	pos = pci_pcie_cap(dev);
-	if (!pos) {
+	if (!pci_is_pcie(dev)) {
 		pos = pci_find_capability(dev, PCI_CAP_ID_PCIX);
 		if (!pos)
 			goto fail;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 52f44b5..7586c24 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3093,17 +3093,13 @@ static int reset_intel_generic_dev(struct pci_dev *dev, int probe)
 
 static int reset_intel_82599_sfp_virtfn(struct pci_dev *dev, int probe)
 {
-	int pos;
-
-	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
-	if (!pos)
+	if (!pci_is_pcie(dev))
 		return -ENOTTY;
 
 	if (probe)
 		return 0;
 
-	pci_write_config_word(dev, pos + PCI_EXP_DEVCTL,
-				PCI_EXP_DEVCTL_BCR_FLR);
+	pci_pcie_cap_write_word(dev, PCI_EXP_DEVCTL, PCI_EXP_DEVCTL_BCR_FLR);
 	msleep(100);
 
 	return 0;
-- 
1.7.9.5

