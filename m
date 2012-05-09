Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab2EIFZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:25:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59597 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab2EIFZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:25:47 -0400
Date: Tue, 8 May 2012 22:25:40 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-input@vger.kernel.org, Viresh Kumar <viresh.kumar@st.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Rakesh Iyer <riyer@nvidia.com>
Subject: Re: [PATCH 2/2] Input: matrix_keymap - wire up device tree support
Message-ID: <20120509052540.GC10514@core.coreip.homeip.net>
References: <20120426081909.GA2726@core.coreip.homeip.net>
 <4F99642E.1010305@wwwdotorg.org>
 <20120430041955.GC1055@core.coreip.homeip.net>
 <4F9EB72A.10403@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9EB72A.10403@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 10:00:42AM -0600, Stephen Warren wrote:
> On 04/29/2012 10:19 PM, Dmitry Torokhov wrote:
> > On Thu, Apr 26, 2012 at 09:05:18AM -0600, Stephen Warren wrote:
> >> On 04/26/2012 02:19 AM, Dmitry Torokhov wrote:
> >>> When platform keymap is not supplied to matrix_keypad_build_keymap()
> >>> and device tree support is enabled, try locating specified property
> >>> and load keymap from it. If property name is not defined, try using
> >>> "linux,keymap".
> >>>
> >>> Based on earlier patch by Viresh Kumar <viresh.kumar@st.com>
> >>
> >> I think this series looks mostly OK. A few comments below.
> >>
> >> We don't actually have the KBC driver hooked up on any boards yet, so I
> >> can't actually test this yet.
> >>
> >> How will the linux,fn-keymap handling work? It looks like this code is
> >> allocating a keymap data structure with one additional row to represent
> >> fn-not-pressed vs. fn-pressed.
> > 
> > No, it loads 2x rows (therefore giving you twice original keymap size).
> 
> Yes, I mean an extra row signal, so therefore twice as many rows.
> 
> >> I assume this will work without issue
> >> even though the second half is not filled in. Won't this allow the
> >> linux,keymap property entries to pass validation "if (row >= rows)" for
> >> one more row than it should?
> > 
> > Maybe... I think we should revisit this when you actually have
> > linux,fn-keymap. Probably will need to export matrix_keypad_parse_
> 
> Would it be better to just drop the support for the linux,fn-keymap
> property, until the full support is there? That wouldn't lose any
> functionality, but would avoid this potential error-checking issue.

Fair enough, how about the version below?

-- 
Dmitry


Input: matrix_keymap - wire up device tree support

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

When platform keymap is not supplied to matrix_keypad_build_keymap()
and device tree support is enabled, try locating specified property
and load keymap from it. If property name is not defined, try using
"linux,keymap".

Based on earlier patch by Viresh Kumar <viresh.kumar@st.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/tegra-kbc.c  |   56 ++++++-----
 drivers/input/matrix-keymap.c       |  175 ++++++++++++++++++++---------------
 include/linux/input/matrix_keypad.h |   18 ----
 3 files changed, 130 insertions(+), 119 deletions(-)


diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index 6722d37..4ffe64d 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -619,8 +619,8 @@ tegra_kbc_check_pin_cfg(const struct tegra_kbc_platform_data *pdata,
 }
 
 #ifdef CONFIG_OF
-static struct tegra_kbc_platform_data * __devinit
-tegra_kbc_dt_parse_pdata(struct platform_device *pdev)
+static struct tegra_kbc_platform_data * __devinit tegra_kbc_dt_parse_pdata(
+	struct platform_device *pdev)
 {
 	struct tegra_kbc_platform_data *pdata;
 	struct device_node *np = pdev->dev.of_node;
@@ -660,10 +660,6 @@ tegra_kbc_dt_parse_pdata(struct platform_device *pdev)
 		pdata->pin_cfg[KBC_MAX_ROW + i].type = PIN_CFG_COL;
 	}
 
-	pdata->keymap_data = matrix_keyboard_of_fill_keymap(np, "linux,keymap");
-
-	/* FIXME: Add handling of linux,fn-keymap here */
-
 	return pdata;
 }
 #else
@@ -674,10 +670,36 @@ static inline struct tegra_kbc_platform_data *tegra_kbc_dt_parse_pdata(
 }
 #endif
 
+static int __devinit tegra_kbd_setup_keymap(struct tegra_kbc *kbc)
+{
+	const struct tegra_kbc_platform_data *pdata = kbc->pdata;
+	const struct matrix_keymap_data *keymap_data = pdata->keymap_data;
+	unsigned int keymap_rows = KBC_MAX_KEY;
+	int retval;
+
+	if (keymap_data && pdata->use_fn_map)
+		keymap_rows *= 2;
+
+	retval = matrix_keypad_build_keymap(keymap_data, NULL,
+					    keymap_rows, KBC_MAX_COL,
+					    kbc->keycode, kbc->idev);
+	if (retval == -ENOSYS || retval == -ENOENT) {
+		/*
+		 * If there is no OF support in kernel or keymap
+		 * property is missing, use default keymap.
+		 */
+		retval = matrix_keypad_build_keymap(
+					&tegra_kbc_default_keymap_data, NULL,
+					keymap_rows, KBC_MAX_COL,
+					kbc->keycode, kbc->idev);
+	}
+
+	return retval;
+}
+
 static int __devinit tegra_kbc_probe(struct platform_device *pdev)
 {
 	const struct tegra_kbc_platform_data *pdata = pdev->dev.platform_data;
-	const struct matrix_keymap_data *keymap_data;
 	struct tegra_kbc *kbc;
 	struct input_dev *input_dev;
 	struct resource *res;
@@ -686,7 +708,6 @@ static int __devinit tegra_kbc_probe(struct platform_device *pdev)
 	int num_rows = 0;
 	unsigned int debounce_cnt;
 	unsigned int scan_time_rows;
-	unsigned int keymap_rows;
 
 	if (!pdata)
 		pdata = tegra_kbc_dt_parse_pdata(pdev);
@@ -768,17 +789,9 @@ static int __devinit tegra_kbc_probe(struct platform_device *pdev)
 	input_dev->open = tegra_kbc_open;
 	input_dev->close = tegra_kbc_close;
 
-	keymap_rows = KBC_MAX_KEY;
-	if (pdata->use_fn_map)
-		keymap_rows *= 2;
-
-	keymap_data = pdata->keymap_data ?: &tegra_kbc_default_keymap_data;
-
-	err = matrix_keypad_build_keymap(keymap_data, NULL,
-					 keymap_rows, KBC_MAX_COL,
-					 kbc->keycode, input_dev);
+	err = tegra_kbd_setup_keymap(kbc);
 	if (err) {
-		dev_err(&pdev->dev, "failed to build keymap\n");
+		dev_err(&pdev->dev, "failed to setup keymap\n");
 		goto err_put_clk;
 	}
 
@@ -805,9 +818,6 @@ static int __devinit tegra_kbc_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, kbc);
 	device_init_wakeup(&pdev->dev, pdata->wakeup);
 
-	if (!pdev->dev.platform_data)
-		matrix_keyboard_of_free_keymap(pdata->keymap_data);
-
 	return 0;
 
 err_free_irq:
@@ -822,10 +832,8 @@ err_free_mem:
 	input_free_device(input_dev);
 	kfree(kbc);
 err_free_pdata:
-	if (!pdev->dev.platform_data) {
-		matrix_keyboard_of_free_keymap(pdata->keymap_data);
+	if (!pdev->dev.platform_data)
 		kfree(pdata);
-	}
 
 	return err;
 }
diff --git a/drivers/input/matrix-keymap.c b/drivers/input/matrix-keymap.c
index de7992d..db92c1e 100644
--- a/drivers/input/matrix-keymap.c
+++ b/drivers/input/matrix-keymap.c
@@ -17,15 +17,91 @@
  *
  */
 
+#include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/input.h>
 #include <linux/of.h>
 #include <linux/export.h>
-#include <linux/gfp.h>
-#include <linux/slab.h>
 #include <linux/input/matrix_keypad.h>
 
+static bool matrix_keypad_map_key(struct input_dev *input_dev,
+				  unsigned int rows, unsigned int cols,
+				  unsigned int row_shift, unsigned int key)
+{
+	unsigned char *keymap = input_dev->keycode;
+	unsigned int row = KEY_ROW(key);
+	unsigned int col = KEY_COL(key);
+	unsigned short code = KEY_VAL(key);
+
+	if (row >= rows || col >= cols) {
+		dev_err(input_dev->dev.parent,
+			"%s: invalid keymap entry 0x%x (row: %d, col: %d, rows: %d, cols: %d)\n",
+			__func__, key, row, col, rows, cols);
+		return false;
+	}
+
+	keymap[MATRIX_SCAN_CODE(row, col, row_shift)] = code;
+	__set_bit(code, input_dev->keybit);
+
+	return true;
+}
+
+#ifdef CONFIG_OF
+static int matrix_keypad_parse_of_keymap(const char *propname,
+					 unsigned int rows, unsigned int cols,
+					 struct input_dev *input_dev)
+{
+	struct device *dev = input_dev->dev.parent;
+	struct device_node *np = dev->of_node;
+	unsigned int row_shift = get_count_order(cols);
+	unsigned int max_keys = rows << row_shift;
+	unsigned int proplen, i, size;
+	const __be32 *prop;
+
+	if (!np)
+		return -ENOENT;
+
+	if (!propname)
+		propname = "linux,keymap";
+
+	prop = of_get_property(np, propname, &proplen);
+	if (!prop) {
+		dev_err(dev, "OF: %s property not defined in %s\n",
+			propname, np->full_name);
+		return -ENOENT;
+	}
+
+	if (proplen % sizeof(u32)) {
+		dev_err(dev, "OF: Malformed keycode property %s in %s\n",
+			propname, np->full_name);
+		return -EINVAL;
+	}
+
+	size = proplen / sizeof(u32);
+	if (size > max_keys) {
+		dev_err(dev, "OF: %s size overflow\n", propname);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < size; i++) {
+		unsigned int key = be32_to_cpup(prop + i);
+
+		if (!matrix_keypad_map_key(input_dev, rows, cols,
+					   row_shift, key))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+#else
+static int matrix_keypad_parse_of_keymap(const char *propname,
+					 unsigned int rows, unsigned int cols,
+					 struct input_dev *input_dev)
+{
+	return -ENOSYS;
+}
+#endif
 
 /**
  * matrix_keypad_build_keymap - convert platform keymap into matrix keymap
@@ -41,6 +117,13 @@
  * This function converts platform keymap (encoded with KEY() macro) into
  * an array of keycodes that is suitable for using in a standard matrix
  * keyboard driver that uses row and col as indices.
+ *
+ * If @keymap_data is not supplied and device tree support is enabled
+ * it will attempt load the keymap from property specified by @keymap_name
+ * argument (or "linux,keymap" if @keymap_name is %NULL).
+ *
+ * Callers are expected to set up input_dev->dev.parent before calling this
+ * function.
  */
 int matrix_keypad_build_keymap(const struct matrix_keymap_data *keymap_data,
 			       const char *keymap_name,
@@ -50,6 +133,7 @@ int matrix_keypad_build_keymap(const struct matrix_keymap_data *keymap_data,
 {
 	unsigned int row_shift = get_count_order(cols);
 	int i;
+	int error;
 
 	input_dev->keycode = keymap;
 	input_dev->keycodesize = sizeof(*keymap);
@@ -57,86 +141,23 @@ int matrix_keypad_build_keymap(const struct matrix_keymap_data *keymap_data,
 
 	__set_bit(EV_KEY, input_dev->evbit);
 
-	for (i = 0; i < keymap_data->keymap_size; i++) {
-		unsigned int key = keymap_data->keymap[i];
-		unsigned int row = KEY_ROW(key);
-		unsigned int col = KEY_COL(key);
-		unsigned short code = KEY_VAL(key);
+	if (keymap_data) {
+		for (i = 0; i < keymap_data->keymap_size; i++) {
+			unsigned int key = keymap_data->keymap[i];
 
-		if (row >= rows || col >= cols) {
-			dev_err(input_dev->dev.parent,
-				"%s: invalid keymap entry %d (row: %d, col: %d, rows: %d, cols: %d)\n",
-				__func__, i, row, col, rows, cols);
-			return -EINVAL;
+			if (!matrix_keypad_map_key(input_dev, rows, cols,
+						   row_shift, key))
+				return -EINVAL;
 		}
-
-		keymap[MATRIX_SCAN_CODE(row, col, row_shift)] = code;
-		__set_bit(code, input_dev->keybit);
+	} else {
+		error = matrix_keypad_parse_of_keymap(keymap_name, rows, cols,
+						      input_dev);
+		if (error)
+			return error;
 	}
+
 	__clear_bit(KEY_RESERVED, input_dev->keybit);
 
 	return 0;
 }
 EXPORT_SYMBOL(matrix_keypad_build_keymap);
-
-#ifdef CONFIG_OF
-struct matrix_keymap_data *
-matrix_keyboard_of_fill_keymap(struct device_node *np,
-			       const char *propname)
-{
-	struct matrix_keymap_data *kd;
-	u32 *keymap;
-	int proplen, i;
-	const __be32 *prop;
-
-	if (!np)
-		return NULL;
-
-	if (!propname)
-		propname = "linux,keymap";
-
-	prop = of_get_property(np, propname, &proplen);
-	if (!prop)
-		return NULL;
-
-	if (proplen % sizeof(u32)) {
-		pr_warn("Malformed keymap property %s in %s\n",
-			propname, np->full_name);
-		return NULL;
-	}
-
-	kd = kzalloc(sizeof(*kd), GFP_KERNEL);
-	if (!kd)
-		return NULL;
-
-	kd->keymap = keymap = kzalloc(proplen, GFP_KERNEL);
-	if (!kd->keymap) {
-		kfree(kd);
-		return NULL;
-	}
-
-	kd->keymap_size = proplen / sizeof(u32);
-
-	for (i = 0; i < kd->keymap_size; i++) {
-		u32 tmp = be32_to_cpup(prop + i);
-		int key_code, row, col;
-
-		row = (tmp >> 24) & 0xff;
-		col = (tmp >> 16) & 0xff;
-		key_code = tmp & 0xffff;
-		keymap[i] = KEY(row, col, key_code);
-	}
-
-	return kd;
-}
-EXPORT_SYMBOL_GPL(matrix_keyboard_of_fill_keymap);
-
-void matrix_keyboard_of_free_keymap(const struct matrix_keymap_data *kd)
-{
-	if (kd) {
-		kfree(kd->keymap);
-		kfree(kd);
-	}
-}
-EXPORT_SYMBOL_GPL(matrix_keyboard_of_free_keymap);
-#endif
diff --git a/include/linux/input/matrix_keypad.h b/include/linux/input/matrix_keypad.h
index e8fe08e..5f3aa6b 100644
--- a/include/linux/input/matrix_keypad.h
+++ b/include/linux/input/matrix_keypad.h
@@ -81,22 +81,4 @@ int matrix_keypad_build_keymap(const struct matrix_keymap_data *keymap_data,
 			       unsigned short *keymap,
 			       struct input_dev *input_dev);
 
-#ifdef CONFIG_OF
-struct matrix_keymap_data *
-matrix_keyboard_of_fill_keymap(struct device_node *np, const char *propname);
-
-void matrix_keyboard_of_free_keymap(const struct matrix_keymap_data *kd);
-#else
-static inline struct matrix_keymap_data *
-matrix_keyboard_of_fill_keymap(struct device_node *np, const char *propname)
-{
-	return NULL;
-}
-
-static inline void
-matrix_keyboard_of_free_keymap(const struct matrix_keymap_data *kd)
-{
-}
-#endif
-
 #endif /* _MATRIX_KEYPAD_H */
