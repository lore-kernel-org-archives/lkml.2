Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab2FKA6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 20:58:32 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:40525 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab2FKA63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 20:58:29 -0400
From: Davide Ciminaghi <dciminaghi@mail.gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, rubini@gnudd.com,
        Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 01/14] sta2x11 mfd : also deal with PCI_DEVICE_ID_STMICRO_VIC.
Date: Mon, 11 Jun 2012 02:57:46 +0200
Message-Id: <1339376279-16753-2-git-send-email-dciminaghi@mail.gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
References: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

Such device includes the apb-soc registers (bar #1), access to
which will be needed by the common clk framework implementation.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 drivers/mfd/sta2x11-mfd.c |  120 ++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 102 insertions(+), 18 deletions(-)

diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index d31fed0..5c950e8 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -281,12 +281,14 @@ static int __init sta2x11_apbreg_init(void)
 }
 
 /*
- * What follows is the PCI device that hosts the above two pdevs.
+ * What follows are the PCI devices that host the above pdevs.
  * Each logic block is 4kB and they are all consecutive: we use this info.
  */
 
-/* Bar 0 */
-enum bar0_cells {
+/* Mfd 0 device */
+
+/* Mfd 0, Bar 0 */
+enum mfd0_bar0_cells {
 	STA2X11_GPIO_0 = 0,
 	STA2X11_GPIO_1,
 	STA2X11_GPIO_2,
@@ -295,8 +297,8 @@ enum bar0_cells {
 	STA2X11_SCR,
 	STA2X11_TIME,
 };
-/* Bar 1 */
-enum bar1_cells {
+/* Mfd 0 , Bar 1 */
+enum mfd0_bar1_cells {
 	STA2X11_APBREG = 0,
 };
 #define CELL_4K(_name, _cell) { \
@@ -330,17 +332,46 @@ static const __devinitconst struct resource apbreg_resources[] = {
 #define DEV(_name, _r) \
 	{ .name = _name, .num_resources = ARRAY_SIZE(_r), .resources = _r, }
 
-static __devinitdata struct mfd_cell sta2x11_mfd_bar0[] = {
+static __devinitdata struct mfd_cell sta2x11_mfd0_bar0[] = {
 	DEV("sta2x11-gpio", gpio_resources), /* offset 0: we add pdata later */
 	DEV("sta2x11-sctl", sctl_resources),
 	DEV("sta2x11-scr", scr_resources),
 	DEV("sta2x11-time", time_resources),
 };
 
-static __devinitdata struct mfd_cell sta2x11_mfd_bar1[] = {
+static __devinitdata struct mfd_cell sta2x11_mfd0_bar1[] = {
 	DEV("sta2x11-apbreg", apbreg_resources),
 };
 
+/* Mfd 1 devices */
+
+/* Mfd 1, Bar 0 */
+enum mfd1_bar0_cells {
+	STA2X11_VIC = 0,
+};
+
+/* Mfd 1, Bar 1 */
+enum mfd1_bar1_cells {
+	STA2X11_APB_SOC_REGS = 0,
+};
+
+static const __devinitconst struct resource vic_resources[] = {
+	CELL_4K("sta2x11-vic", STA2X11_VIC),
+};
+
+static const __devinitconst struct resource apb_soc_regs_resources[] = {
+	CELL_4K("sta2x11-apb-soc-regs", STA2X11_APB_SOC_REGS),
+};
+
+static __devinitdata struct mfd_cell sta2x11_mfd1_bar0[] = {
+	DEV("sta2x11-vic", vic_resources),
+};
+
+static __devinitdata struct mfd_cell sta2x11_mfd1_bar1[] = {
+	DEV("sta2x11-apb-soc-regs", apb_soc_regs_resources),
+};
+
+
 static int sta2x11_mfd_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	pci_save_state(pdev);
@@ -363,10 +394,63 @@ static int sta2x11_mfd_resume(struct pci_dev *pdev)
 	return 0;
 }
 
+struct sta2x11_mfd_bar_setup_data {
+	struct mfd_cell *cells;
+	int ncells;
+};
+
+struct sta2x11_mfd_setup_data {
+	struct sta2x11_mfd_bar_setup_data bars[2];
+};
+
+#define STA2X11_MFD0 0
+#define STA2X11_MFD1 1
+
+static struct sta2x11_mfd_setup_data mfd_setup_data[] = {
+	/* Mfd 0: gpio, sctl, scr, timers / apbregs */
+	[STA2X11_MFD0] = {
+		.bars = {
+			[0] = {
+				.cells = sta2x11_mfd0_bar0,
+				.ncells = ARRAY_SIZE(sta2x11_mfd0_bar0),
+			},
+			[1] = {
+				.cells = sta2x11_mfd0_bar1,
+				.ncells = ARRAY_SIZE(sta2x11_mfd0_bar1),
+			},
+		},
+	},
+	/* Mfd 1: vic / apb-soc-regs */
+	[STA2X11_MFD1] = {
+		.bars = {
+			[0] = {
+				.cells = sta2x11_mfd1_bar0,
+				.ncells = ARRAY_SIZE(sta2x11_mfd1_bar0),
+			},
+			[1] = {
+				.cells = sta2x11_mfd1_bar1,
+				.ncells = ARRAY_SIZE(sta2x11_mfd1_bar1),
+			},
+		},
+	},
+};
+
+static void __devinit sta2x11_mfd_setup(struct pci_dev *pdev,
+					struct sta2x11_mfd_setup_data *sd)
+{
+	int i, j;
+	for (i = 0; i < ARRAY_SIZE(sd->bars); i++)
+		for (j = 0; j < sd->bars[i].ncells; j++) {
+			sd->bars[i].cells[j].pdata_size = sizeof(pdev);
+			sd->bars[i].cells[j].platform_data = &pdev;
+		}
+}
+
 static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
 				       const struct pci_device_id *pci_id)
 {
-	int err, i;
+	int err;
+	struct sta2x11_mfd_setup_data *setup_data;
 	struct sta2x11_gpio_pdata *gpio_data;
 
 	dev_info(&pdev->dev, "%s\n", __func__);
@@ -381,6 +465,10 @@ static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
 	if (err)
 		dev_info(&pdev->dev, "Enable msi failed\n");
 
+	setup_data = pci_id->device == PCI_DEVICE_ID_STMICRO_GPIO ?
+		&mfd_setup_data[STA2X11_MFD0] :
+		&mfd_setup_data[STA2X11_MFD1];
+
 	/* Read gpio config data as pci device's platform data */
 	gpio_data = dev_get_platdata(&pdev->dev);
 	if (!gpio_data)
@@ -392,20 +480,15 @@ static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
 		pdev, &pdev);
 
 	/* platform data is the pci device for all of them */
-	for (i = 0; i < ARRAY_SIZE(sta2x11_mfd_bar0); i++) {
-		sta2x11_mfd_bar0[i].pdata_size = sizeof(pdev);
-		sta2x11_mfd_bar0[i].platform_data = &pdev;
-	}
-	sta2x11_mfd_bar1[0].pdata_size = sizeof(pdev);
-	sta2x11_mfd_bar1[0].platform_data = &pdev;
+	sta2x11_mfd_setup(pdev, setup_data);
 
 	/* Record this pdev before mfd_add_devices: their probe looks for it */
 	sta2x11_mfd_add(pdev, GFP_ATOMIC);
 
 
 	err = mfd_add_devices(&pdev->dev, -1,
-			      sta2x11_mfd_bar0,
-			      ARRAY_SIZE(sta2x11_mfd_bar0),
+			      setup_data->bars[0].cells,
+			      setup_data->bars[0].ncells,
 			      &pdev->resource[0],
 			      0);
 	if (err) {
@@ -414,8 +497,8 @@ static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
 	}
 
 	err = mfd_add_devices(&pdev->dev, -1,
-			      sta2x11_mfd_bar1,
-			      ARRAY_SIZE(sta2x11_mfd_bar1),
+			      setup_data->bars[1].cells,
+			      setup_data->bars[1].ncells,
 			      &pdev->resource[1],
 			      0);
 	if (err) {
@@ -434,6 +517,7 @@ err_disable:
 
 static DEFINE_PCI_DEVICE_TABLE(sta2x11_mfd_tbl) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_STMICRO, PCI_DEVICE_ID_STMICRO_GPIO)},
+	{PCI_DEVICE(PCI_VENDOR_ID_STMICRO, PCI_DEVICE_ID_STMICRO_VIC)},
 	{0,},
 };
 
-- 
1.7.9.1

