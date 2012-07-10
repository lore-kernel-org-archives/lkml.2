Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2GJGhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 02:37:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51602 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab2GJGhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 02:37:05 -0400
Date: Mon, 9 Jul 2012 23:36:57 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: axel.lin@gmail.com, riyer@nvidia.com, michael.hennerich@analog.com,
        grant.likely@secretlab.ca, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        aletes.xgr@gmail.com
Subject: Re: [PATCH v8] input: keyboard: Add keys driver for the LPC32xx SoC
Message-ID: <20120710063657.GC29257@core.coreip.homeip.net>
References: <1340834596-15642-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340834596-15642-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

On Thu, Jun 28, 2012 at 12:03:16AM +0200, Roland Stigge wrote:
> +
> +struct lpc32xx_kscan_drv {
> +	struct input_dev *input;
> +	struct clk *clk;
> +	void __iomem *kscan_base;
> +	u8 lastkeystates[8];
> +	u32 io_p_start;
> +	u32 io_p_size;
> +	u32 matrix_sz;		/* Size of matrix in XxY, ie. 3 = 3x3 */
> +	unsigned short *keymap;	/* Pointer to key map for the scan matrix */
> +	u32 deb_clks;		/* Debounce clocks (based on 32KHz clock) */
> +	u32 scan_delay;		/* Scan delay (based on 32KHz clock) */
> +	int row_shift;
> +};
> +
> +static void lpc32xx_mod_states(struct lpc32xx_kscan_drv *kscandat, int col)
> +{
> +	u8 key;
> +	int row;
> +	unsigned changed, scancode, keycode;
> +
> +	key = readl(LPC32XX_KS_DATA(kscandat->kscan_base, col));
> +	changed = key ^ kscandat->lastkeystates[col];
> +	if (changed) {
> +		for (row = 0; row < kscandat->matrix_sz; row++) {
> +			if (changed & (1 << row)) {

I think it could be optimized a bit of you do not scan entire "changed"
but shift it until it reaches 0 instead.

> +	of_property_read_u32(np, "nxp,debounce-delay-ms", &kscandat->deb_clks);
> +	of_property_read_u32(np, "nxp,scan-delay-ms", &kscandat->scan_delay);
> +	if (!kscandat->deb_clks || !kscandat->scan_delay) {
> +		dev_err(dev, "debounce or scan delay not specified\n");
> +		return -ENXIO;

EINVAL suits better.

> +
> +static int __devexit lpc32xx_kscan_remove(struct platform_device *pdev)
> +{
> +	struct lpc32xx_kscan_drv *kscandat = platform_get_drvdata(pdev);
> +
> +	kfree(kscandat->keymap);

This seems dangerous in case we manage IRQ fire here.

> +	free_irq(platform_get_irq(pdev, 0), pdev);
> +	clk_put(kscandat->clk);
> +	iounmap(kscandat->kscan_base);
> +	release_mem_region(kscandat->io_p_start, kscandat->io_p_size);
> +	input_unregister_device(kscandat->input);
> +	kfree(kscandat);
> +
> +	return 0;
> +}
> +

Does the following patch (on top of your) still work with your device?

Thanks.

-- 
Dmitry


Input: lpc32-xx- misc changes

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/lpc32xx-keys.c |  241 +++++++++++++++++----------------
 1 file changed, 126 insertions(+), 115 deletions(-)


diff --git a/drivers/input/keyboard/lpc32xx-keys.c b/drivers/input/keyboard/lpc32xx-keys.c
index d51a4c5..e8f2112 100644
--- a/drivers/input/keyboard/lpc32xx-keys.c
+++ b/drivers/input/keyboard/lpc32xx-keys.c
@@ -66,47 +66,46 @@
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
-	if (changed) {
-		for (row = 0; row < kscandat->matrix_sz; row++) {
-			if (changed & (1 << row)) {
-				/* Key state changed, signal an event */
-				scancode = MATRIX_SCAN_CODE(
-					row, col, kscandat->row_shift);
-				keycode = kscandat->keymap[scancode];
-				input_event(kscandat->input, EV_MSC, MSC_SCAN,
-					    scancode);
-				input_report_key(kscandat->input, keycode,
-						 key & (1 << row));
-			}
+	kscandat->lastkeystates[col] = key;
+
+	for (row = 0; changed; row++, changed >>= 1) {
+		if (changed & 1) {
+			/* Key state changed, signal an event */
+			scancode = MATRIX_SCAN_CODE(row, col,
+						    kscandat->row_shift);
+			keycode = kscandat->keymap[scancode];
+			input_event(input, EV_MSC, MSC_SCAN, scancode);
+			input_report_key(input, keycode, key & (1 << row));
 		}
-
-		kscandat->lastkeystates[col] = key;
 	}
 }
 
 static irqreturn_t lpc32xx_kscan_irq(int irq, void *dev_id)
 {
-	int i;
 	struct lpc32xx_kscan_drv *kscandat = dev_id;
+	int i;
 
 	for (i = 0; i < kscandat->matrix_sz; i++)
 		lpc32xx_mod_states(kscandat, i);
@@ -126,7 +125,9 @@ static int lpc32xx_kscan_open(struct input_dev *dev)
 	error = clk_prepare_enable(kscandat->clk);
 	if (error)
 		return error;
+
 	writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
+
 	return 0;
 }
 
@@ -142,7 +143,7 @@ static int lpc32xx_parse_dt(struct lpc32xx_kscan_drv *kscandat)
 {
 	struct device *dev = &kscandat->input->dev;
 	struct device_node *np = dev->parent->of_node;
-	u32 rows, columns;
+	u32 rows = 0, columns = 0;
 
 	of_property_read_u32(np, "keypad,num-rows", &rows);
 	of_property_read_u32(np, "keypad,num-columns", &columns);
@@ -159,7 +160,7 @@ static int lpc32xx_parse_dt(struct lpc32xx_kscan_drv *kscandat)
 	of_property_read_u32(np, "nxp,scan-delay-ms", &kscandat->scan_delay);
 	if (!kscandat->deb_clks || !kscandat->scan_delay) {
 		dev_err(dev, "debounce or scan delay not specified\n");
-		return -ENXIO;
+		return -EINVAL;
 	}
 
 	return 0;
@@ -168,107 +169,104 @@ static int lpc32xx_parse_dt(struct lpc32xx_kscan_drv *kscandat)
 static int __devinit lpc32xx_kscan_probe(struct platform_device *pdev)
 {
 	struct lpc32xx_kscan_drv *kscandat;
+	struct input_dev *input;
 	struct resource *res;
+	size_t keymap_size;
 	int error;
 	int irq;
 
-	kscandat = kzalloc(sizeof(struct lpc32xx_kscan_drv), GFP_KERNEL);
-	if (!kscandat) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
-		return -ENOMEM;
-	}
-
-	kscandat->input = input_allocate_device();
-	if (kscandat->input == NULL) {
-		dev_err(&pdev->dev, "failed to allocate device\n");
-		error = -ENOMEM;
-		goto out1;
-	}
-
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "failed to get platform I/O memory\n");
-		error = -EBUSY;
-		goto out2;
-	}
-
-	res = request_mem_region(res->start, resource_size(res), pdev->name);
-	if (!res) {
-		dev_err(&pdev->dev, "failed to request I/O memory\n");
-		error = -EBUSY;
-		goto out2;
-	}
-	kscandat->io_p_start = res->start;
-	kscandat->io_p_size = resource_size(res);
-
-	kscandat->kscan_base = ioremap(res->start, resource_size(res));
-	if (!kscandat->kscan_base) {
-		dev_err(&pdev->dev, "failed to remap I/O memory\n");
-		error = -EBUSY;
-		goto out3;
-	}
-
-	/* Get the key scanner clock */
-	kscandat->clk = clk_get(&pdev->dev, NULL);
-	if (IS_ERR(kscandat->clk)) {
-		dev_err(&pdev->dev, "failed to get clock\n");
-		error = PTR_ERR(kscandat->clk);
-		goto out4;
+		return -EINVAL;
 	}
 
 	irq = platform_get_irq(pdev, 0);
-	if ((irq < 0) || (irq >= NR_IRQS)) {
+	if (irq < 0 || irq >= NR_IRQS) {
 		dev_err(&pdev->dev, "failed to get platform irq\n");
-		error = -EINVAL;
-		goto out5;
-	}
-	error = request_irq(irq, lpc32xx_kscan_irq, 0, pdev->name, kscandat);
-	if (error) {
-		dev_err(&pdev->dev, "failed to request irq\n");
-		goto out5;
+		return -EINVAL;
 	}
 
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
+	kscandat = kzalloc(sizeof(struct lpc32xx_kscan_drv), GFP_KERNEL);
+	if (!kscandat) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
 
 	error = lpc32xx_parse_dt(kscandat);
 	if (error) {
 		dev_err(&pdev->dev, "failed to parse device tree\n");
-		goto out6;
+		goto err_free_mem;
 	}
 
-	kscandat->keymap = kzalloc(sizeof(kscandat->keymap[0]) *
-				   (kscandat->matrix_sz << kscandat->row_shift),
-				   GFP_KERNEL);
+	keymap_size = sizeof(kscandat->keymap[0]) *
+				(kscandat->matrix_sz << kscandat->row_shift);
+	kscandat->keymap = kzalloc(keymap_size, GFP_KERNEL);
 	if (!kscandat->keymap) {
 		dev_err(&pdev->dev, "could not allocate memory for keymap\n");
 		error = -ENOMEM;
-		goto out6;
+		goto err_free_mem;
+	}
+
+	kscandat->input = input = input_allocate_device();
+	if (!input) {
+		dev_err(&pdev->dev, "failed to allocate input device\n");
+		error = -ENOMEM;
+		goto err_free_keymap;
 	}
 
-	error = matrix_keypad_build_keymap(NULL, NULL, kscandat->matrix_sz,
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
+	input_set_capability(kscandat->input, EV_MSC, MSC_SCAN);
+
+	error = matrix_keypad_build_keymap(NULL, NULL,
+					   kscandat->matrix_sz,
 					   kscandat->matrix_sz,
 					   kscandat->keymap, kscandat->input);
 	if (error) {
 		dev_err(&pdev->dev, "failed to build keymap\n");
-		goto out7;
+		goto err_free_input;
 	}
 
 	input_set_drvdata(kscandat->input, kscandat);
-	input_set_capability(kscandat->input, EV_MSC, MSC_SCAN);
+
+	kscandat->iores = request_mem_region(res->start, resource_size(res),
+					     pdev->name);
+	if (!kscandat->iores) {
+		dev_err(&pdev->dev, "failed to request I/O memory\n");
+		error = -EBUSY;
+		goto err_free_input;
+	}
+
+	kscandat->kscan_base = ioremap(kscandat->iores->start,
+				       resource_size(kscandat->iores));
+	if (!kscandat->kscan_base) {
+		dev_err(&pdev->dev, "failed to remap I/O memory\n");
+		error = -EBUSY;
+		goto err_release_memregion;
+	}
+
+	/* Get the key scanner clock */
+	kscandat->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(kscandat->clk)) {
+		dev_err(&pdev->dev, "failed to get clock\n");
+		error = PTR_ERR(kscandat->clk);
+		goto err_unmap;
+	}
 
 	/* Configure the key scanner */
-	clk_prepare_enable(kscandat->clk);
+	error = clk_prepare_enable(kscandat->clk);
+	if (error)
+		goto err_clk_put;
+
 	writel(kscandat->deb_clks, LPC32XX_KS_DEB(kscandat->kscan_base));
 	writel(kscandat->scan_delay, LPC32XX_KS_SCAN_CTL(kscandat->kscan_base));
 	writel(LPC32XX_KSCAN_FTST_USE32K_CLK,
@@ -278,27 +276,35 @@ static int __devinit lpc32xx_kscan_probe(struct platform_device *pdev)
 	writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
 	clk_disable_unprepare(kscandat->clk);
 
+	error = request_irq(irq, lpc32xx_kscan_irq, 0, pdev->name, kscandat);
+	if (error) {
+		dev_err(&pdev->dev, "failed to request irq\n");
+		goto err_clk_put;
+	}
+
 	error = input_register_device(kscandat->input);
 	if (error) {
 		dev_err(&pdev->dev, "failed to register input device\n");
-		goto out7;
+		goto err_free_irq;
 	}
 
+	platform_set_drvdata(pdev, kscandat);
 	return 0;
 
-out7:
-	kfree(kscandat->keymap);
-out6:
-	free_irq(irq, pdev);
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
@@ -308,12 +314,13 @@ static int __devexit lpc32xx_kscan_remove(struct platform_device *pdev)
 {
 	struct lpc32xx_kscan_drv *kscandat = platform_get_drvdata(pdev);
 
-	kfree(kscandat->keymap);
-	free_irq(platform_get_irq(pdev, 0), pdev);
+	free_irq(platform_get_irq(pdev, 0), kscandat);
 	clk_put(kscandat->clk);
 	iounmap(kscandat->kscan_base);
-	release_mem_region(kscandat->io_p_start, kscandat->io_p_size);
+	release_mem_region(kscandat->iores->start,
+			   resource_size(kscandat->iores));
 	input_unregister_device(kscandat->input);
+	kfree(kscandat->keymap);
 	kfree(kscandat);
 
 	return 0;
@@ -324,16 +331,17 @@ static int lpc32xx_kscan_suspend(struct device *dev)
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
 
@@ -341,17 +349,20 @@ static int lpc32xx_kscan_resume(struct device *dev)
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
 
