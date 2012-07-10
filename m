Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab2GJP5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:57:04 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:64056 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab2GJP5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:57:00 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH 14/14] qib/PCI: use PCIe cap access functions to simplify implementation
Date: Tue, 10 Jul 2012 23:54:15 +0800
Message-Id: <1341935655-5381-15-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341935655-5381-1-git-send-email-jiang.liu@huawei.com>
References: <1341935655-5381-1-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
References: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe cap access functions to simplify qib implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/infiniband/hw/qib/qib_pcie.c |   34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index 790646e..3c30249 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -271,10 +271,9 @@ int qib_pcie_params(struct qib_devdata *dd, u32 minw, u32 *nent,
 		    struct qib_msix_entry *entry)
 {
 	u16 linkstat, speed;
-	int pos = 0, pose, ret = 1;
+	int pos = 0, ret = 1;
 
-	pose = pci_pcie_cap(dd->pcidev);
-	if (!pose) {
+	if (!pci_is_pcie(dd->pcidev)) {
 		qib_dev_err(dd, "Can't find PCI Express capability!\n");
 		/* set up something... */
 		dd->lbus_width = 1;
@@ -296,7 +295,7 @@ int qib_pcie_params(struct qib_devdata *dd, u32 minw, u32 *nent,
 	if (!pos)
 		qib_enable_intx(dd->pcidev);
 
-	pci_read_config_word(dd->pcidev, pose + PCI_EXP_LNKSTA, &linkstat);
+	pci_pcie_cap_read_word(dd->pcidev, PCI_EXP_LNKSTA, &linkstat);
 	/*
 	 * speed is bits 0-3, linkwidth is bits 4-8
 	 * no defines for them in headers
@@ -514,7 +513,6 @@ static int qib_tune_pcie_coalesce(struct qib_devdata *dd)
 {
 	int r;
 	struct pci_dev *parent;
-	int ppos;
 	u16 devid;
 	u32 mask, bits, val;
 
@@ -527,8 +525,7 @@ static int qib_tune_pcie_coalesce(struct qib_devdata *dd)
 		qib_devinfo(dd->pcidev, "Parent not root\n");
 		return 1;
 	}
-	ppos = pci_pcie_cap(parent);
-	if (!ppos)
+	if (!pci_is_pcie(parent))
 		return 1;
 	if (parent->vendor != 0x8086)
 		return 1;
@@ -585,7 +582,6 @@ static int qib_tune_pcie_caps(struct qib_devdata *dd)
 {
 	int ret = 1; /* Assume the worst */
 	struct pci_dev *parent;
-	int ppos, epos;
 	u16 pcaps, pctl, ecaps, ectl;
 	int rc_sup, ep_sup;
 	int rc_cur, ep_cur;
@@ -596,17 +592,15 @@ static int qib_tune_pcie_caps(struct qib_devdata *dd)
 		qib_devinfo(dd->pcidev, "Parent not root\n");
 		goto bail;
 	}
-	ppos = pci_pcie_cap(parent);
-	if (ppos) {
-		pci_read_config_word(parent, ppos + PCI_EXP_DEVCAP, &pcaps);
-		pci_read_config_word(parent, ppos + PCI_EXP_DEVCTL, &pctl);
+	if (pci_is_pcie(parent)) {
+		pci_pcie_cap_read_word(parent, PCI_EXP_DEVCAP, &pcaps);
+		pci_pcie_cap_read_word(parent, PCI_EXP_DEVCTL, &pctl);
 	} else
 		goto bail;
 	/* Find out supported and configured values for endpoint (us) */
-	epos = pci_pcie_cap(dd->pcidev);
-	if (epos) {
-		pci_read_config_word(dd->pcidev, epos + PCI_EXP_DEVCAP, &ecaps);
-		pci_read_config_word(dd->pcidev, epos + PCI_EXP_DEVCTL, &ectl);
+	if (pci_is_pcie(dd->pcidev)) {
+		pci_pcie_cap_read_word(dd->pcidev, PCI_EXP_DEVCAP, &ecaps);
+		pci_pcie_cap_read_word(dd->pcidev, PCI_EXP_DEVCTL, &ectl);
 	} else
 		goto bail;
 	ret = 0;
@@ -627,14 +621,14 @@ static int qib_tune_pcie_caps(struct qib_devdata *dd)
 		rc_cur = rc_sup;
 		pctl = (pctl & ~PCI_EXP_DEVCTL_PAYLOAD) |
 			val2fld(rc_cur, PCI_EXP_DEVCTL_PAYLOAD);
-		pci_write_config_word(parent, ppos + PCI_EXP_DEVCTL, pctl);
+		pci_pcie_cap_write_word(parent, PCI_EXP_DEVCTL, pctl);
 	}
 	/* If less than (allowed, supported), bump endpoint payload */
 	if (rc_sup > ep_cur) {
 		ep_cur = rc_sup;
 		ectl = (ectl & ~PCI_EXP_DEVCTL_PAYLOAD) |
 			val2fld(ep_cur, PCI_EXP_DEVCTL_PAYLOAD);
-		pci_write_config_word(dd->pcidev, epos + PCI_EXP_DEVCTL, ectl);
+		pci_pcie_cap_write_word(dd->pcidev, PCI_EXP_DEVCTL, ectl);
 	}
 
 	/*
@@ -652,13 +646,13 @@ static int qib_tune_pcie_caps(struct qib_devdata *dd)
 		rc_cur = rc_sup;
 		pctl = (pctl & ~PCI_EXP_DEVCTL_READRQ) |
 			val2fld(rc_cur, PCI_EXP_DEVCTL_READRQ);
-		pci_write_config_word(parent, ppos + PCI_EXP_DEVCTL, pctl);
+		pci_pcie_cap_write_word(parent, PCI_EXP_DEVCTL, pctl);
 	}
 	if (rc_sup > ep_cur) {
 		ep_cur = rc_sup;
 		ectl = (ectl & ~PCI_EXP_DEVCTL_READRQ) |
 			val2fld(ep_cur, PCI_EXP_DEVCTL_READRQ);
-		pci_write_config_word(dd->pcidev, epos + PCI_EXP_DEVCTL, ectl);
+		pci_pcie_cap_write_word(dd->pcidev, PCI_EXP_DEVCTL, ectl);
 	}
 bail:
 	return ret;
-- 
1.7.9.5

