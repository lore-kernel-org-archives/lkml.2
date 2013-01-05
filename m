Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3AELof (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 06:44:35 -0500
Received: from [216.228.121.35] ([216.228.121.35]:3863 "EHLO
	hqemgate04.nvidia.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab3AELn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 06:43:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sat, 05 Jan 2013 03:39:04 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <dmitry.torokhov@gmail.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <swarren@nvidia.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 3/4] input: keyboard: tegra: add support for rows/cols configuration from dt
Date: Sat, 5 Jan 2013 17:11:50 +0530
Message-ID: <1357386111-19971-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1357386111-19971-1-git-send-email-ldewangan@nvidia.com>
References: <1357386111-19971-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NVIDIA's Tegra KBC has maximum 24 pins to make matrix keypad.
Any pin can be configured as row or column. The maximum column pin
can be 8 and maximum row pin can be 16.

Remove the assumption that all first 16 pins will be used as row
and remaining as columns and Add the property for configuring pins
to either row or column from DT. Update the devicetree binding
document accordingly.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- renames the rows and pins property array.
- nit cleanups.
Changes from V2:
 None

 .../bindings/input/nvidia,tegra20-kbc.txt          |   22 ++++++
 drivers/input/keyboard/tegra-kbc.c                 |   74 +++++++++++++++-----
 2 files changed, 79 insertions(+), 17 deletions(-)

diff --git a/Documentation/devicetree/bindings/input/nvidia,tegra20-kbc.txt b/Documentation/devicetree/bindings/input/nvidia,tegra20-kbc.txt
index 72683be..2995fae 100644
--- a/Documentation/devicetree/bindings/input/nvidia,tegra20-kbc.txt
+++ b/Documentation/devicetree/bindings/input/nvidia,tegra20-kbc.txt
@@ -1,7 +1,18 @@
 * Tegra keyboard controller
+The key controller has maximum 24 pins to make matrix keypad. Any pin
+can be configured as row or column. The maximum column pin can be 8
+and maximum row pins can be 16 for Tegra20/Tegra30.
 
 Required properties:
 - compatible: "nvidia,tegra20-kbc"
+- reg: Register base address of KBC.
+- interrupts: Interrupt number for the KBC.
+- nvidia,kbc-row-pins: The KBC pins which are configured as row. This is an
+  array of pin numbers which is used as rows.
+- nvidia,kbc-col-pins: The KBC pins which are configured as column. This is an
+  array of pin numbers which is used as column.
+- linux,keymap: The keymap for keys as described in the binding document
+  devicetree/bindings/input/matrix-keymap.txt.
 
 Optional properties, in addition to those specified by the shared
 matrix-keyboard bindings:
@@ -19,5 +30,16 @@ Example:
 keyboard: keyboard {
 	compatible = "nvidia,tegra20-kbc";
 	reg = <0x7000e200 0x100>;
+	interrupts = <0 85 0x04>;
 	nvidia,ghost-filter;
+	nvidia,debounce-delay-ms = <640>;
+	nvidia,kbc-row-pins = <0 1 2>;    /* pin 0, 1, 2 as rows */
+	nvidia,kbc-col-pins = <11 12 13>; /* pin 11, 12, 13 as columns */
+	linux,keymap = <0x00000074
+			0x00010067
+			0x00020066
+			0x01010068
+			0x02000069
+			0x02010070
+			0x02020071>;
 };
diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index e2fdf9d..eeb9dbc 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -614,13 +614,16 @@ static struct tegra_kbc_platform_data *tegra_kbc_dt_parse_pdata(
 	struct device_node *np = pdev->dev.of_node;
 	u32 prop;
 	int i;
-
-	if (!np)
-		return NULL;
+	u32 num_rows = 0;
+	u32 num_cols = 0;
+	u32 cols_cfg[KBC_MAX_GPIO];
+	u32 rows_cfg[KBC_MAX_GPIO];
+	int proplen;
+	int ret;
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	if (!of_property_read_u32(np, "nvidia,debounce-delay-ms", &prop))
 		pdata->debounce_cnt = prop;
@@ -634,18 +637,55 @@ static struct tegra_kbc_platform_data *tegra_kbc_dt_parse_pdata(
 	if (of_find_property(np, "nvidia,wakeup-source", NULL))
 		pdata->wakeup = true;
 
-	/*
-	 * All currently known keymaps with device tree support use the same
-	 * pin_cfg, so set it up here.
-	 */
-	for (i = 0; i < KBC_MAX_ROW; i++) {
-		pdata->pin_cfg[i].num = i;
-		pdata->pin_cfg[i].type = PIN_CFG_ROW;
+	if (!of_get_property(np, "nvidia,kbc-row-pins", &proplen)) {
+		dev_err(&pdev->dev, "property nvidia,kbc-row-pins not found\n");
+		return ERR_PTR(-ENOENT);
+	}
+	num_rows = proplen / sizeof(u32);
+
+	if (!of_get_property(np, "nvidia,kbc-col-pins", &proplen)) {
+		dev_err(&pdev->dev, "property nvidia,kbc-col-pins not found\n");
+		return ERR_PTR(-ENOENT);
+	}
+	num_cols = proplen / sizeof(u32);
+
+	if (!of_get_property(np, "linux,keymap", &proplen)) {
+		dev_err(&pdev->dev, "property linux,keymap not found\n");
+		return ERR_PTR(-ENOENT);
+	}
+
+	if (!num_rows || !num_cols || ((num_rows + num_cols) > KBC_MAX_GPIO)) {
+		dev_err(&pdev->dev,
+			"keypad rows/columns not porperly specified\n");
+		return ERR_PTR(-EINVAL);
 	}
 
-	for (i = 0; i < KBC_MAX_COL; i++) {
-		pdata->pin_cfg[KBC_MAX_ROW + i].num = i;
-		pdata->pin_cfg[KBC_MAX_ROW + i].type = PIN_CFG_COL;
+	/* Set all pins as non-configured */
+	for (i = 0; i < KBC_MAX_GPIO; i++)
+		pdata->pin_cfg[i].type = PIN_CFG_IGNORE;
+
+	ret = of_property_read_u32_array(np, "nvidia,kbc-row-pins",
+				rows_cfg, num_rows);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Rows configurations are not proper\n");
+		return ERR_PTR(-ENOENT);
+	}
+
+	ret = of_property_read_u32_array(np, "nvidia,kbc-col-pins",
+				cols_cfg, num_cols);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Cols configurations are not proper\n");
+		return ERR_PTR(-ENOENT);
+	}
+
+	for (i = 0; i < num_rows; i++) {
+		pdata->pin_cfg[rows_cfg[i]].type = PIN_CFG_ROW;
+		pdata->pin_cfg[rows_cfg[i]].num = i;
+	}
+
+	for (i = 0; i < num_cols; i++) {
+		pdata->pin_cfg[cols_cfg[i]].type = PIN_CFG_COL;
+		pdata->pin_cfg[cols_cfg[i]].num = i;
 	}
 
 	return pdata;
@@ -697,12 +737,12 @@ static int tegra_kbc_probe(struct platform_device *pdev)
 	unsigned int debounce_cnt;
 	unsigned int scan_time_rows;
 
-	if (!pdata)
+	if (!pdata && pdev->dev.of_node)
 		pdata = tegra_kbc_dt_parse_pdata(pdev);
 
-	if (!pdata) {
+	if (IS_ERR_OR_NULL(pdata)) {
 		dev_err(&pdev->dev, "Platform data missing\n");
-		return -EINVAL;
+		return pdata ? PTR_ERR(pdata) : -EINVAL;
 	}
 
 	if (!tegra_kbc_check_pin_cfg(pdata, &pdev->dev, &num_rows))
-- 
1.7.1.1

