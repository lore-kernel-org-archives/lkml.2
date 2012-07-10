Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab2GJUzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 16:55:16 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49031 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab2GJUzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 16:55:14 -0400
Date: Tue, 10 Jul 2012 13:55:07 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: axel.lin@gmail.com, riyer@nvidia.com, michael.hennerich@analog.com,
        grant.likely@secretlab.ca, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        aletes.xgr@gmail.com
Subject: Re: [PATCH v9] input: keyboard: Add keys driver for the LPC32xx SoC
Message-ID: <20120710205507.GA377@core.coreip.homeip.net>
References: <1341948910-6530-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341948910-6530-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

On Tue, Jul 10, 2012 at 09:35:10PM +0200, Roland Stigge wrote:
> This patch adds a driver for the key scan interface of the LPC32xx SoC
> 

Could of more things that I had in my patch but forgot to specifically
call out:

> +
> +	/* Configure the key scanner */
> +	clk_prepare_enable(kscandat->clk);

This may fail so we should handle errors.

> +	writel(kscandat->deb_clks, LPC32XX_KS_DEB(kscandat->kscan_base));
> +	writel(kscandat->scan_delay, LPC32XX_KS_SCAN_CTL(kscandat->kscan_base));
> +	writel(LPC32XX_KSCAN_FTST_USE32K_CLK,
> +	       LPC32XX_KS_FAST_TST(kscandat->kscan_base));
> +	writel(kscandat->matrix_sz,
> +	       LPC32XX_KS_MATRIX_DIM(kscandat->kscan_base));
> +	writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
> +	clk_disable_unprepare(kscandat->clk);
> +
> +	error = request_irq(irq, lpc32xx_kscan_irq, 0, pdev->name, kscandat);

...

> +
> +	free_irq(platform_get_irq(pdev, 0), pdev);

You are requesting IRQ with kscandat as an argument but freeing it with
'pdev' which will fail.

> +
> +	if (kscandat->input->users) {
> +		/* Enable clock and clear IRQ */
> +		clk_prepare_enable(kscandat->clk);

Need to handle errors here as well.

Since I am partial to my rearrangement (basically I started preferring
err_<action> style of error labels as they more explanatory than out2 or
fail3 style of labels), could you try this version of my patch (on top
of your v9 one). Third time is a charm maybe? :)

-- 
Dmitry

Input: lpc32-xx- misc changes

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/lpc32xx-keys.c |  217 +++++++++++++++++----------------
 1 file changed, 115 insertions(+), 102 deletions(-)


diff --git a/drivers/input/keyboard/lpc32xx-keys.c b/drivers/input/keyboard/lpc32xx-keys.c
index 91b0587..dd786c8 100644
--- a/drivers/input/keyboard/lpc32xx-keys.c
+++ b/drivers/input/keyboard/lpc32xx-keys.c
@@ -66,22 +66,25 @@
 struct lpc32xx_kscan_drv {
 	struct input_dev *input;
 	struct clk *clk;
+	struct resource *iores;
 	void __iomem *kscan_base;
-	u8 lastkeystates[8];
-	u32 io_p_start;
-	u32 io_p_size;
+	unsigned int irq;
+
 	u32 matrix_sz;		/* Size of matrix in XxY, ie. 3 = 3x3 */
-	unsigned short *keymap;	/* Pointer to key map for the scan matrix */
 	u32 deb_clks;		/* Debounce clocks (based on 32KHz clock) */
 	u32 scan_delay;		/* Scan delay (based on 32KHz clock) */
-	int row_shift;
+
+	unsigned short *keymap;	/* Pointer to key map for the scan matrix */
+	unsigned int row_shift;
+
+	u8 lastkeystates[8];
 };
 
 static void lpc32xx_mod_states(struct lpc32xx_kscan_drv *kscandat, int col)
 {
+	struct input_dev *input = kscandat->input;
+	unsigned row, changed, scancode, keycode;
 	u8 key;
-	int row;
-	unsigned changed, scancode, keycode;
 
 	key = readl(LPC32XX_KS_DATA(kscandat->kscan_base, col));
 	changed = key ^ kscandat->lastkeystates[col];
@@ -93,18 +96,16 @@ static void lpc32xx_mod_states(struct lpc32xx_kscan_drv *kscandat, int col)
 			scancode = MATRIX_SCAN_CODE(row, col,
 						    kscandat->row_shift);
 			keycode = kscandat->keymap[scancode];
-			input_event(kscandat->input, EV_MSC, MSC_SCAN,
-				    scancode);
-			input_report_key(kscandat->input, keycode,
-					 key & (1 << row));
+			input_event(input, EV_MSC, MSC_SCAN, scancode);
+			input_report_key(input, keycode, key & (1 << row));
 		}
 	}
 }
 
 static irqreturn_t lpc32xx_kscan_irq(int irq, void *dev_id)
 {
-	int i;
 	struct lpc32xx_kscan_drv *kscandat = dev_id;
+	int i;
 
 	for (i = 0; i < kscandat->matrix_sz; i++)
 		lpc32xx_mod_states(kscandat, i);
@@ -124,7 +125,9 @@ static int lpc32xx_kscan_open(struct input_dev *dev)
 	error = clk_prepare_enable(kscandat->clk);
 	if (error)
 		return error;
+
 	writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
+
 	return 0;
 }
 
@@ -136,11 +139,11 @@ static void lpc32xx_kscan_close(struct input_dev *dev)
 	clk_disable_unprepare(kscandat->clk);
 }
 
-static int lpc32xx_parse_dt(struct lpc32xx_kscan_drv *kscandat)
+static int __devinit lpc32xx_parse_dt(struct device *dev,
+				      struct lpc32xx_kscan_drv *kscandat)
 {
-	struct device *dev = &kscandat->input->dev;
-	struct device_node *np = dev->parent->of_node;
-	u32 rows, columns;
+	struct device_node *np = dev->of_node;
+	u32 rows = 0, columns = 0;
 
 	of_property_read_u32(np, "keypad,num-rows", &rows);
 	of_property_read_u32(np, "keypad,num-columns", &columns);
@@ -166,44 +169,89 @@ static int lpc32xx_parse_dt(struct lpc32xx_kscan_drv *kscandat)
 static int __devinit lpc32xx_kscan_probe(struct platform_device *pdev)
 {
 	struct lpc32xx_kscan_drv *kscandat;
+	struct input_dev *input;
 	struct resource *res;
+	size_t keymap_size;
 	int error;
 	int irq;
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "failed to get platform I/O memory\n");
+		return -EINVAL;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0 || irq >= NR_IRQS) {
+		dev_err(&pdev->dev, "failed to get platform irq\n");
+		return -EINVAL;
+	}
+
 	kscandat = kzalloc(sizeof(struct lpc32xx_kscan_drv), GFP_KERNEL);
 	if (!kscandat) {
 		dev_err(&pdev->dev, "failed to allocate memory\n");
 		return -ENOMEM;
 	}
 
-	kscandat->input = input_allocate_device();
-	if (kscandat->input == NULL) {
-		dev_err(&pdev->dev, "failed to allocate device\n");
+	error = lpc32xx_parse_dt(&pdev->dev, kscandat);
+	if (error) {
+		dev_err(&pdev->dev, "failed to parse device tree\n");
+		goto err_free_mem;
+	}
+
+	keymap_size = sizeof(kscandat->keymap[0]) *
+				(kscandat->matrix_sz << kscandat->row_shift);
+	kscandat->keymap = kzalloc(keymap_size, GFP_KERNEL);
+	if (!kscandat->keymap) {
+		dev_err(&pdev->dev, "could not allocate memory for keymap\n");
 		error = -ENOMEM;
-		goto out1;
+		goto err_free_mem;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "failed to get platform I/O memory\n");
-		error = -EBUSY;
-		goto out2;
+	kscandat->input = input = input_allocate_device();
+	if (!input) {
+		dev_err(&pdev->dev, "failed to allocate input device\n");
+		error = -ENOMEM;
+		goto err_free_keymap;
 	}
 
-	res = request_mem_region(res->start, resource_size(res), pdev->name);
-	if (!res) {
+	/* Setup key input */
+	input->name		= pdev->name;
+	input->phys		= "lpc32xx/input0";
+	input->id.vendor	= 0x0001;
+	input->id.product	= 0x0001;
+	input->id.version	= 0x0100;
+	input->open		= lpc32xx_kscan_open;
+	input->close		= lpc32xx_kscan_close;
+	input->dev.parent	= &pdev->dev;
+
+	input_set_capability(input, EV_MSC, MSC_SCAN);
+
+	error = matrix_keypad_build_keymap(NULL, NULL,
+					   kscandat->matrix_sz,
+					   kscandat->matrix_sz,
+					   kscandat->keymap, kscandat->input);
+	if (error) {
+		dev_err(&pdev->dev, "failed to build keymap\n");
+		goto err_free_input;
+	}
+
+	input_set_drvdata(kscandat->input, kscandat);
+
+	kscandat->iores = request_mem_region(res->start, resource_size(res),
+					     pdev->name);
+	if (!kscandat->iores) {
 		dev_err(&pdev->dev, "failed to request I/O memory\n");
 		error = -EBUSY;
-		goto out2;
+		goto err_free_input;
 	}
-	kscandat->io_p_start = res->start;
-	kscandat->io_p_size = resource_size(res);
 
-	kscandat->kscan_base = ioremap(res->start, resource_size(res));
+	kscandat->kscan_base = ioremap(kscandat->iores->start,
+				       resource_size(kscandat->iores));
 	if (!kscandat->kscan_base) {
 		dev_err(&pdev->dev, "failed to remap I/O memory\n");
 		error = -EBUSY;
-		goto out3;
+		goto err_release_memregion;
 	}
 
 	/* Get the key scanner clock */
@@ -211,56 +259,14 @@ static int __devinit lpc32xx_kscan_probe(struct platform_device *pdev)
 	if (IS_ERR(kscandat->clk)) {
 		dev_err(&pdev->dev, "failed to get clock\n");
 		error = PTR_ERR(kscandat->clk);
-		goto out4;
-	}
-
-	irq = platform_get_irq(pdev, 0);
-	if ((irq < 0) || (irq >= NR_IRQS)) {
-		dev_err(&pdev->dev, "failed to get platform irq\n");
-		error = -EINVAL;
-		goto out5;
-	}
-	platform_set_drvdata(pdev, kscandat);
-
-	/* Setup key input */
-	kscandat->input->evbit[0]	= BIT_MASK(EV_KEY);
-	kscandat->input->name		= pdev->name;
-	kscandat->input->phys		= "matrix-keys/input0";
-	kscandat->input->id.vendor	= 0x0001;
-	kscandat->input->id.product	= 0x0001;
-	kscandat->input->id.version	= 0x0100;
-	kscandat->input->open		= lpc32xx_kscan_open;
-	kscandat->input->close		= lpc32xx_kscan_close;
-	kscandat->input->dev.parent	= &pdev->dev;
-
-	error = lpc32xx_parse_dt(kscandat);
-	if (error) {
-		dev_err(&pdev->dev, "failed to parse device tree\n");
-		goto out5;
-	}
-
-	kscandat->keymap = kzalloc(sizeof(kscandat->keymap[0]) *
-				   (kscandat->matrix_sz << kscandat->row_shift),
-				   GFP_KERNEL);
-	if (!kscandat->keymap) {
-		dev_err(&pdev->dev, "could not allocate memory for keymap\n");
-		error = -ENOMEM;
-		goto out5;
-	}
-
-	error = matrix_keypad_build_keymap(NULL, NULL, kscandat->matrix_sz,
-					   kscandat->matrix_sz,
-					   kscandat->keymap, kscandat->input);
-	if (error) {
-		dev_err(&pdev->dev, "failed to build keymap\n");
-		goto out6;
+		goto err_unmap;
 	}
 
-	input_set_drvdata(kscandat->input, kscandat);
-	input_set_capability(kscandat->input, EV_MSC, MSC_SCAN);
-
 	/* Configure the key scanner */
-	clk_prepare_enable(kscandat->clk);
+	error = clk_prepare_enable(kscandat->clk);
+	if (error)
+		goto err_clk_put;
+
 	writel(kscandat->deb_clks, LPC32XX_KS_DEB(kscandat->kscan_base));
 	writel(kscandat->scan_delay, LPC32XX_KS_SCAN_CTL(kscandat->kscan_base));
 	writel(LPC32XX_KSCAN_FTST_USE32K_CLK,
@@ -273,30 +279,32 @@ static int __devinit lpc32xx_kscan_probe(struct platform_device *pdev)
 	error = request_irq(irq, lpc32xx_kscan_irq, 0, pdev->name, kscandat);
 	if (error) {
 		dev_err(&pdev->dev, "failed to request irq\n");
-		goto out6;
+		goto err_clk_put;
 	}
 
 	error = input_register_device(kscandat->input);
 	if (error) {
 		dev_err(&pdev->dev, "failed to register input device\n");
-		goto out7;
+		goto err_free_irq;
 	}
 
+	platform_set_drvdata(pdev, kscandat);
 	return 0;
 
-out7:
-	free_irq(irq, pdev);
-out6:
-	kfree(kscandat->keymap);
-out5:
+err_free_irq:
+	free_irq(irq, kscandat);
+err_clk_put:
 	clk_put(kscandat->clk);
-out4:
+err_unmap:
 	iounmap(kscandat->kscan_base);
-out3:
-	release_mem_region(kscandat->io_p_start, kscandat->io_p_size);
-out2:
+err_release_memregion:
+	release_mem_region(kscandat->iores->start,
+			   resource_size(kscandat->iores));
+err_free_input:
 	input_free_device(kscandat->input);
-out1:
+err_free_keymap:
+	kfree(kscandat->keymap);
+err_free_mem:
 	kfree(kscandat);
 
 	return error;
@@ -306,10 +314,11 @@ static int __devexit lpc32xx_kscan_remove(struct platform_device *pdev)
 {
 	struct lpc32xx_kscan_drv *kscandat = platform_get_drvdata(pdev);
 
-	free_irq(platform_get_irq(pdev, 0), pdev);
+	free_irq(platform_get_irq(pdev, 0), kscandat);
 	clk_put(kscandat->clk);
 	iounmap(kscandat->kscan_base);
-	release_mem_region(kscandat->io_p_start, kscandat->io_p_size);
+	release_mem_region(kscandat->iores->start,
+			   resource_size(kscandat->iores));
 	input_unregister_device(kscandat->input);
 	kfree(kscandat->keymap);
 	kfree(kscandat);
@@ -322,16 +331,17 @@ static int lpc32xx_kscan_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct lpc32xx_kscan_drv *kscandat = platform_get_drvdata(pdev);
+	struct input_dev *input = kscandat->input;
 
-	mutex_lock(&kscandat->input->mutex);
+	mutex_lock(&input->mutex);
 
-	if (kscandat->input->users) {
+	if (input->users) {
 		/* Clear IRQ and disable clock */
 		writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
 		clk_disable_unprepare(kscandat->clk);
 	}
 
-	mutex_unlock(&kscandat->input->mutex);
+	mutex_unlock(&input->mutex);
 	return 0;
 }
 
@@ -339,17 +349,20 @@ static int lpc32xx_kscan_resume(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct lpc32xx_kscan_drv *kscandat = platform_get_drvdata(pdev);
+	struct input_dev *input = kscandat->input;
+	int retval = 0;
 
-	mutex_lock(&kscandat->input->mutex);
+	mutex_lock(&input->mutex);
 
-	if (kscandat->input->users) {
+	if (input->users) {
 		/* Enable clock and clear IRQ */
-		clk_prepare_enable(kscandat->clk);
-		writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
+		retval = clk_prepare_enable(kscandat->clk);
+		if (retval == 0)
+			writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
 	}
 
-	mutex_unlock(&kscandat->input->mutex);
-	return 0;
+	mutex_unlock(&input->mutex);
+	return retval;
 }
 #endif
 
