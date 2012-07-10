Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab2GJGNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 02:13:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45182 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2GJGNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 02:13:32 -0400
Date: Mon, 9 Jul 2012 23:13:26 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [RESEND/PATCHv5 1/2] drivers: input: keypad: Add device tree
 support
Message-ID: <20120710061326.GA29257@core.coreip.homeip.net>
References: <1339152780-25301-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339152780-25301-1-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sourav,

On Fri, Jun 08, 2012 at 04:22:59PM +0530, Sourav Poddar wrote:
> Update the Documentation with omap4 keypad device tree
> binding information.
> Add device tree support for omap4 keypad driver.
> 
> Tested on omap4430 sdp.
>

Sorry for the delay, I have a few comments:

>  
>  	/* platform data */
>  	pdata = pdev->dev.platform_data;
> -	if (!pdata) {
> +	if (np) {
> +		of_property_read_u32(np, "keypad,num-rows", &num_rows);
> +		of_property_read_u32(np, "keypad,num-columns", &num_cols);
> +		if (!num_rows || !num_cols) {
> +			dev_err(&pdev->dev, "number of keypad rows/columns not specified\n");
> +			return -EINVAL;
> +		}
> +	} else if (pdata) {
> +		num_rows = pdata->rows;
> +		num_cols = pdata->cols;
> +	} else {
>  		dev_err(&pdev->dev, "no platform data defined\n");
>  		return -EINVAL;
>  	}
>  

I believe drivers should use platform data if it is supplied and use DT
data if platform data is omitted. This way one can override firmware
data if needed.

Does the patch below (if applied on top of your) work for you?

Thanks.

-- 
Dmitry

Input: omap4-keypad - misc fixes

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

 drivers/input/keyboard/omap4-keypad.c |  152 ++++++++++++++++-----------------
 1 file changed, 74 insertions(+), 78 deletions(-)


diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index d5a2d1a..033168e 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -76,7 +76,6 @@ enum {
 
 struct omap4_keypad {
 	struct input_dev *input;
-	struct matrix_keymap_data *keymap_data;
 
 	void __iomem *base;
 	unsigned int irq;
@@ -88,7 +87,7 @@ struct omap4_keypad {
 	unsigned int row_shift;
 	bool no_autorepeat;
 	unsigned char key_state[8];
-	unsigned short keymap[];
+	unsigned short *keymap;
 };
 
 static int kbd_readl(struct omap4_keypad *keypad_data, u32 offset)
@@ -211,74 +210,52 @@ static void omap4_keypad_close(struct input_dev *input)
 	pm_runtime_put_sync(input->dev.parent);
 }
 
-static struct omap4_keypad *omap_keypad_parse_dt(struct device *dev,
-				uint32_t rows, uint32_t cols,
-				struct input_dev *input_dev)
+#ifdef CONFIG_OF
+static int __devinit omap4_keypad_parse_dt(struct device *dev,
+					   struct omap4_keypad *keypad_data)
 {
 	struct device_node *np = dev->of_node;
-	struct platform_device *pdev = to_platform_device(dev);
-	struct omap4_keypad *keypad_data = platform_get_drvdata(pdev);
 	int error;
 
-	error = matrix_keypad_build_keymap(NULL, "linux,keymap",
-				rows, cols, keypad_data->keymap, input_dev);
-	if (error) {
-		dev_err(&pdev->dev, "failed to build keymap\n");
-		input_free_device(input_dev);
+	if (!np) {
+		dev_err(dev, "missing DT data");
+		return -EINVAL;
+	}
+
+	of_property_read_u32(np, "keypad,num-rows", &keypad_data->rows);
+	of_property_read_u32(np, "keypad,num-columns", &keypad_data->cols);
+	if (!keypad_data->rows || !keypad_data->cols) {
+		dev_err(dev, "number of keypad rows/columns not specified\n");
+		return -EINVAL;
 	}
 
 	if (of_get_property(np, "linux,input-no-autorepeat", NULL))
 		keypad_data->no_autorepeat = true;
 
-	return keypad_data;
+	return 0;
+}
+#else
+static inline int omap4_keypad_parse_dt(struct device *dev,
+					struct omap4_keypad *keypad_data)
+{
+	return -ENOSYS;
 }
+#endif
 
 static int __devinit omap4_keypad_probe(struct platform_device *pdev)
 {
-	struct device *dev = &pdev->dev;
-	struct device_node *np = dev->of_node;
-	const struct omap4_keypad_platform_data *pdata;
+	const struct omap4_keypad_platform_data *pdata =
+				dev_get_platdata(&pdev->dev);
+	const struct matrix_keymap_data *keymap_data =
+				pdata ? pdata->keymap_data : NULL;
 	struct omap4_keypad *keypad_data;
 	struct input_dev *input_dev;
 	struct resource *res;
-	resource_size_t size;
-	unsigned int row_shift = 0, max_keys = 0;
-	uint32_t num_rows = 0, num_cols = 0;
+	unsigned int max_keys;
 	int rev;
 	int irq;
 	int error;
 
-	/* platform data */
-	pdata = pdev->dev.platform_data;
-	if (np) {
-		of_property_read_u32(np, "keypad,num-rows", &num_rows);
-		of_property_read_u32(np, "keypad,num-columns", &num_cols);
-		if (!num_rows || !num_cols) {
-			dev_err(&pdev->dev, "number of keypad rows/columns not specified\n");
-			return -EINVAL;
-		}
-	} else if (pdata) {
-		num_rows = pdata->rows;
-		num_cols = pdata->cols;
-	} else {
-		dev_err(&pdev->dev, "no platform data defined\n");
-		return -EINVAL;
-	}
-
-	row_shift = get_count_order(num_cols);
-	max_keys = num_rows << row_shift;
-
-	keypad_data = devm_kzalloc(dev, sizeof(struct omap4_keypad) +
-			max_keys * sizeof(keypad_data->keymap[0]),
-				GFP_KERNEL);
-
-	if (!keypad_data) {
-		dev_err(&pdev->dev, "keypad_data memory allocation failed\n");
-		return -ENOMEM;
-	}
-
-	platform_set_drvdata(pdev, keypad_data);
-
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "no base address specified\n");
@@ -291,9 +268,24 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	size = resource_size(res);
+	keypad_data = kzalloc(sizeof(struct omap4_keypad), GFP_KERNEL);
+	if (!keypad_data) {
+		dev_err(&pdev->dev, "keypad_data memory allocation failed\n");
+		return -ENOMEM;
+	}
+
+	keypad_data->irq = irq;
+
+	if (pdata) {
+		keypad_data->rows = pdata->rows;
+		keypad_data->cols = pdata->cols;
+	} else {
+		error = omap4_keypad_parse_dt(&pdev->dev, keypad_data);
+		if (error)
+			return error;
+	}
 
-	res = request_mem_region(res->start, size, pdev->name);
+	res = request_mem_region(res->start, resource_size(res), pdev->name);
 	if (!res) {
 		dev_err(&pdev->dev, "can't request mem region\n");
 		error = -EBUSY;
@@ -307,15 +299,11 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
 		goto err_release_mem;
 	}
 
-	keypad_data->rows = num_rows;
-	keypad_data->cols = num_cols;
-	keypad_data->irq = irq;
-	keypad_data->row_shift = row_shift;
 
 	/*
-	* Enable clocks for the keypad module so that we can read
-	* revision register.
-	*/
+	 * Enable clocks for the keypad module so that we can read
+	 * revision register.
+	 */
 	pm_runtime_enable(&pdev->dev);
 	error = pm_runtime_get_sync(&pdev->dev);
 	if (error) {
@@ -358,29 +346,30 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
 	input_dev->open = omap4_keypad_open;
 	input_dev->close = omap4_keypad_close;
 
-	if (np) {
-		keypad_data = omap_keypad_parse_dt(&pdev->dev,
-				keypad_data->rows, keypad_data->cols,
-				input_dev);
-	} else {
-		keypad_data->keymap_data =
-			(struct matrix_keymap_data *)pdata->keymap_data;
-		error = matrix_keypad_build_keymap(keypad_data->keymap_data,
-				NULL, keypad_data->rows, keypad_data->cols,
-				keypad_data->keymap, input_dev);
-		if (error) {
-			dev_err(&pdev->dev, "failed to build keymap\n");
-			goto err_free_input;
-		}
-	}
-
+	input_set_capability(input_dev, EV_MSC, MSC_SCAN);
 	if (!keypad_data->no_autorepeat)
 		__set_bit(EV_REP, input_dev->evbit);
 
-	input_set_capability(input_dev, EV_MSC, MSC_SCAN);
-
 	input_set_drvdata(input_dev, keypad_data);
 
+	keypad_data->row_shift = get_count_order(keypad_data->cols);
+	max_keys = keypad_data->rows << keypad_data->row_shift;
+	keypad_data->keymap = kzalloc(max_keys * sizeof(keypad_data->keymap[0]),
+				      GFP_KERNEL);
+	if (!keypad_data->keymap) {
+		dev_err(&pdev->dev, "Not enough memory for keymap\n");
+		error = -ENOMEM;
+		goto err_free_input;
+	}
+
+	error = matrix_keypad_build_keymap(keymap_data, NULL,
+					   keypad_data->rows, keypad_data->cols,
+					   keypad_data->keymap, input_dev);
+	if (error) {
+		dev_err(&pdev->dev, "failed to build keymap\n");
+		goto err_free_keymap;
+	}
+
 	error = request_irq(keypad_data->irq, omap4_keypad_interrupt,
 			     IRQF_TRIGGER_RISING,
 			     "omap4-keypad", keypad_data);
@@ -397,11 +386,14 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
 		goto err_pm_disable;
 	}
 
+	platform_set_drvdata(pdev, keypad_data);
 	return 0;
 
 err_pm_disable:
 	pm_runtime_disable(&pdev->dev);
 	free_irq(keypad_data->irq, keypad_data);
+err_free_keymap:
+	kfree(keypad_data->keymap);
 err_free_input:
 	input_free_device(input_dev);
 err_pm_put_sync:
@@ -409,7 +401,7 @@ err_pm_put_sync:
 err_unmap:
 	iounmap(keypad_data->base);
 err_release_mem:
-	release_mem_region(res->start, size);
+	release_mem_region(res->start, resource_size(res));
 err_free_keypad:
 	kfree(keypad_data);
 	return error;
@@ -431,17 +423,21 @@ static int __devexit omap4_keypad_remove(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(res->start, resource_size(res));
 
+	kfree(keypad_data->keymap);
 	kfree(keypad_data);
+
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
 
+#ifdef CONFIG_OF
 static const struct of_device_id omap_keypad_dt_match[] = {
 	{ .compatible = "ti,omap4-keypad" },
 	{},
 };
 MODULE_DEVICE_TABLE(of, omap_keypad_dt_match);
+#endif
 
 static struct platform_driver omap4_keypad_driver = {
 	.probe		= omap4_keypad_probe,
