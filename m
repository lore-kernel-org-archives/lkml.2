Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab2GXQoC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:44:02 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52366 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab2GXQn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:43:59 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v2 28/32] PCI/qla: use PCIe capabilities access functions to simplify implementation
Date: Wed, 25 Jul 2012 00:41:13 +0800
Message-Id: <1343148077-25941-5-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343148077-25941-1-git-send-email-jiang.liu@huawei.com>
References: <1343148077-25941-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify QLA SCSI drivers'
implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    4 ++--
 drivers/scsi/qla2xxx/qla_nx.c   |    8 ++------
 drivers/scsi/qla4xxx/ql4_nx.c   |    4 +---
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ca50847..a44653b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -685,7 +685,7 @@ qla24xx_pci_config(scsi_qla_host_t *vha)
 		pcix_set_mmrbc(ha->pdev, 2048);
 
 	/* PCIe -- adjust Maximum Read Request Size (2048). */
-	if (pci_find_capability(ha->pdev, PCI_CAP_ID_EXP))
+	if (pci_is_pcie(ha->pdev))
 		pcie_set_readrq(ha->pdev, 2048);
 
 	pci_disable_rom(ha->pdev);
@@ -721,7 +721,7 @@ qla25xx_pci_config(scsi_qla_host_t *vha)
 	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
 
 	/* PCIe -- adjust Maximum Read Request Size (2048). */
-	if (pci_find_capability(ha->pdev, PCI_CAP_ID_EXP))
+	if (pci_is_pcie(ha->pdev))
 		pcie_set_readrq(ha->pdev, 2048);
 
 	pci_disable_rom(ha->pdev);
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index caf627b..be516e9 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1615,13 +1615,11 @@ qla82xx_get_fw_offs(struct qla_hw_data *ha)
 char *
 qla82xx_pci_info_str(struct scsi_qla_host *vha, char *str)
 {
-	int pcie_reg;
 	struct qla_hw_data *ha = vha->hw;
 	char lwstr[6];
 	uint16_t lnk;
 
-	pcie_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
-	pci_read_config_word(ha->pdev, pcie_reg + PCI_EXP_LNKSTA, &lnk);
+	pci_pcie_capability_read_word(ha->pdev, PCI_EXP_LNKSTA, &lnk);
 	ha->link_width = (lnk >> 4) & 0x3f;
 
 	strcpy(str, "PCIe (");
@@ -2497,7 +2495,6 @@ fw_load_failed:
 int
 qla82xx_start_firmware(scsi_qla_host_t *vha)
 {
-	int           pcie_cap;
 	uint16_t      lnk;
 	struct qla_hw_data *ha = vha->hw;
 
@@ -2528,8 +2525,7 @@ qla82xx_start_firmware(scsi_qla_host_t *vha)
 	}
 
 	/* Negotiated Link width */
-	pcie_cap = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
-	pci_read_config_word(ha->pdev, pcie_cap + PCI_EXP_LNKSTA, &lnk);
+	pci_pcie_capability_read_word(ha->pdev, PCI_EXP_LNKSTA, &lnk);
 	ha->link_width = (lnk >> 4) & 0x3f;
 
 	/* Synchronize with Receive peg */
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 228b670..7e30158 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1566,7 +1566,6 @@ qla4_8xxx_set_qsnt_ready(struct scsi_qla_host *ha)
 static int
 qla4_8xxx_start_firmware(struct scsi_qla_host *ha, uint32_t image_start)
 {
-	int pcie_cap;
 	uint16_t lnk;
 
 	/* scrub dma mask expansion register */
@@ -1590,8 +1589,7 @@ qla4_8xxx_start_firmware(struct scsi_qla_host *ha, uint32_t image_start)
 	}
 
 	/* Negotiated Link width */
-	pcie_cap = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
-	pci_read_config_word(ha->pdev, pcie_cap + PCI_EXP_LNKSTA, &lnk);
+	pci_pcie_capability_read_word(ha->pdev, PCI_EXP_LNKSTA, &lnk);
 	ha->link_width = (lnk >> 4) & 0x3f;
 
 	/* Synchronize with Receive peg */
-- 
1.7.9.5

