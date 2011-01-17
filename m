Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab1AQKXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 05:23:35 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58666 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab1AQKXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 05:23:34 -0500
Date: Mon, 17 Jan 2011 10:23:30 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCHv2] hwrng: add support for picoxcell TRNG
Message-ID: <20110117102330.GB2622@pulham.picochip.com>
References: <20110114181609.GN2822@pulham.picochip.com>
 <1295030661-16364-1-git-send-email-jamie@jamieiles.com>
 <20110115004416.GA19686@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110115004416.GA19686@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 11:44:16AM +1100, Herbert Xu wrote:
> On Fri, Jan 14, 2011 at 06:44:21PM +0000, Jamie Iles wrote:
> >
> > +	/* Wait for some data to become available. */
> > +	while (__raw_readl(csr) & CSR_OUT_EMPTY_MASK) {
> > +		if (!wait)
> > +			return 0;
> > +		cpu_relax();
> > +	}
> 
> This has the potential to loop indefinitely.  Please add a time-out
> to prevent that (see existing RNG drivers for example).

Ok, that's a fair point!  Here's an updated version with a timeout.  
I've also added in support for the fault detection which I previously 
overlooked.

Jamie

8<--------

>From f58efb08a99a5d82a86fefd97e4adf5cab3595a8 Mon Sep 17 00:00:00 2001
From: Jamie Iles <jamie@jamieiles.com>
Date: Fri, 14 Jan 2011 12:16:50 +0000
Subject: [PATCHv3] hwrng: add support for picoxcell TRNG

This driver adds support for the True Random Number Generator in
the Picochip PC3X3 and later devices.

v3: add a timeout of 20us to the read() method and add fault detection
and reset.

v2: fix indentation and cleanup read function to remove single use
variables and to take advantage of the rng buffer being aligned.

Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>

Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/char/hw_random/Kconfig         |   12 ++
 drivers/char/hw_random/Makefile        |    1 +
 drivers/char/hw_random/picoxcell-rng.c |  208 ++++++++++++++++++++++++++++++++
 3 files changed, 221 insertions(+), 0 deletions(-)
 create mode 100644 drivers/char/hw_random/picoxcell-rng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index d31483c..beecd1c 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -198,3 +198,15 @@ config HW_RANDOM_NOMADIK
 	  module will be called nomadik-rng.
 
 	  If unsure, say Y.
+
+config HW_RANDOM_PICOXCELL
+	tristate "Picochip picoXcell true random number generator support"
+	depends on HW_RANDOM && ARCH_PICOXCELL && PICOXCELL_PC3X3
+	---help---
+	  This driver provides kernel-side support for the Random Number
+	  Generator hardware found on Picochip PC3x3 and later devices.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called picoxcell-rng.
+
+	  If unsure, say Y.
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 4273308..3db4eb8 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -19,3 +19,4 @@ obj-$(CONFIG_HW_RANDOM_TX4939) += tx4939-rng.o
 obj-$(CONFIG_HW_RANDOM_MXC_RNGA) += mxc-rnga.o
 obj-$(CONFIG_HW_RANDOM_OCTEON) += octeon-rng.o
 obj-$(CONFIG_HW_RANDOM_NOMADIK) += nomadik-rng.o
+obj-$(CONFIG_HW_RANDOM_PICOXCELL) += picoxcell-rng.o
diff --git a/drivers/char/hw_random/picoxcell-rng.c b/drivers/char/hw_random/picoxcell-rng.c
new file mode 100644
index 0000000..990d55a
--- /dev/null
+++ b/drivers/char/hw_random/picoxcell-rng.c
@@ -0,0 +1,208 @@
+/*
+ * Copyright (c) 2010-2011 Picochip Ltd., Jamie Iles
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * All enquiries to support@picochip.com
+ */
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#define DATA_REG_OFFSET		0x0200
+#define CSR_REG_OFFSET		0x0278
+#define CSR_OUT_EMPTY_MASK	(1 << 24)
+#define CSR_FAULT_MASK		(1 << 1)
+#define TRNG_BLOCK_RESET_MASK	(1 << 0)
+#define TAI_REG_OFFSET		0x0380
+
+/*
+ * The maximum amount of time in microseconds to spend waiting for data if the
+ * core wants us to wait.  The TRNG should generate 32 bits every 320ns so a
+ * timeout of 20us seems reasonable.  The TRNG does builtin tests of the data
+ * for randomness so we can't always assume there is data present.
+ */
+#define PICO_TRNG_TIMEOUT		20
+
+static void __iomem *rng_base;
+static struct clk *rng_clk;
+struct device *rng_dev;
+
+static inline u32 picoxcell_trng_read_csr(void)
+{
+	return __raw_readl(rng_base + CSR_REG_OFFSET);
+}
+
+static inline bool picoxcell_trng_is_empty(void)
+{
+	return picoxcell_trng_read_csr() & CSR_OUT_EMPTY_MASK;
+}
+
+/*
+ * Take the random number generator out of reset and make sure the interrupts
+ * are masked. We shouldn't need to get large amounts of random bytes so just
+ * poll the status register. The hardware generates 32 bits every 320ns so we
+ * shouldn't have to wait long enough to warrant waiting for an IRQ.
+ */
+static void picoxcell_trng_start(void)
+{
+	__raw_writel(0, rng_base + TAI_REG_OFFSET);
+	__raw_writel(0, rng_base + CSR_REG_OFFSET);
+}
+
+static void picoxcell_trng_reset(void)
+{
+	__raw_writel(TRNG_BLOCK_RESET_MASK, rng_base + CSR_REG_OFFSET);
+	__raw_writel(TRNG_BLOCK_RESET_MASK, rng_base + TAI_REG_OFFSET);
+	picoxcell_trng_start();
+}
+
+/*
+ * Get some random data from the random number generator. The hw_random core
+ * layer provides us with locking.
+ */
+static int picoxcell_trng_read(struct hwrng *rng, void *buf, size_t max,
+			       bool wait)
+{
+	int i;
+
+	/* Wait for some data to become available. */
+	for (i = 0; i < PICO_TRNG_TIMEOUT && picoxcell_trng_is_empty(); ++i) {
+		if (!wait)
+			return 0;
+
+		udelay(1);
+	}
+
+	if (picoxcell_trng_read_csr() & CSR_FAULT_MASK) {
+		dev_err(rng_dev, "fault detected, resetting TRNG\n");
+		picoxcell_trng_reset();
+		return -EIO;
+	}
+
+	if (i == PICO_TRNG_TIMEOUT)
+		return 0;
+
+	*(u32 *)buf = __raw_readl(rng_base + DATA_REG_OFFSET);
+	return sizeof(u32);
+}
+
+static struct hwrng picoxcell_trng = {
+	.name		= "picoxcell",
+	.read		= picoxcell_trng_read,
+};
+
+static int picoxcell_trng_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct resource *mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	if (!mem) {
+		dev_warn(&pdev->dev, "no memory resource\n");
+		return -ENOMEM;
+	}
+
+	if (!devm_request_mem_region(&pdev->dev, mem->start, resource_size(mem),
+				     "picoxcell_trng")) {
+		dev_warn(&pdev->dev, "unable to request io mem\n");
+		return -EBUSY;
+	}
+
+	rng_base = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
+	if (!rng_base) {
+		dev_warn(&pdev->dev, "unable to remap io mem\n");
+		return -ENOMEM;
+	}
+
+	rng_clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(rng_clk)) {
+		dev_warn(&pdev->dev, "no clk\n");
+		return PTR_ERR(rng_clk);
+	}
+
+	ret = clk_enable(rng_clk);
+	if (ret) {
+		dev_warn(&pdev->dev, "unable to enable clk\n");
+		goto err_enable;
+	}
+
+	picoxcell_trng_start();
+	ret = hwrng_register(&picoxcell_trng);
+	if (ret)
+		goto err_register;
+
+	rng_dev = &pdev->dev;
+	dev_info(&pdev->dev, "pixoxcell random number generator active\n");
+
+	return 0;
+
+err_register:
+	clk_disable(rng_clk);
+err_enable:
+	clk_put(rng_clk);
+
+	return ret;
+}
+
+static int __devexit picoxcell_trng_remove(struct platform_device *pdev)
+{
+	hwrng_unregister(&picoxcell_trng);
+	clk_disable(rng_clk);
+	clk_put(rng_clk);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int picoxcell_trng_suspend(struct device *dev)
+{
+	clk_disable(rng_clk);
+
+	return 0;
+}
+
+static int picoxcell_trng_resume(struct device *dev)
+{
+	return clk_enable(rng_clk);
+}
+
+static const struct dev_pm_ops picoxcell_trng_pm_ops = {
+	.suspend	= picoxcell_trng_suspend,
+	.resume		= picoxcell_trng_resume,
+};
+#endif /* CONFIG_PM */
+
+static struct platform_driver picoxcell_trng_driver = {
+	.probe		= picoxcell_trng_probe,
+	.remove		= __devexit_p(picoxcell_trng_remove),
+	.driver		= {
+		.name	= "picoxcell-trng",
+		.owner	= THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm	= &picoxcell_trng_pm_ops,
+#endif /* CONFIG_PM */
+	},
+};
+
+static int __init picoxcell_trng_init(void)
+{
+	return platform_driver_register(&picoxcell_trng_driver);
+}
+module_init(picoxcell_trng_init);
+
+static void __exit picoxcell_trng_exit(void)
+{
+	platform_driver_unregister(&picoxcell_trng_driver);
+}
+module_exit(picoxcell_trng_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jamie Iles");
+MODULE_DESCRIPTION("Picochip picoXcell TRNG driver");
-- 
1.7.3.4

