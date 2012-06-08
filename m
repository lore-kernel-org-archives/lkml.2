Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762221Ab2FHRJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 13:09:56 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:63494 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762120Ab2FHRJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 13:09:53 -0400
MIME-Version: 1.0
In-Reply-To: <a781edbbecfb4a0ebd22746b3110b2f130352509.1339076448.git.rubini@gnudd.com>
References: <cover.1339076448.git.rubini@gnudd.com>
	<a781edbbecfb4a0ebd22746b3110b2f130352509.1339076448.git.rubini@gnudd.com>
Date: Fri, 8 Jun 2012 19:09:52 +0200
Message-ID: <CACRpkdaG2jMX75HRMvxX2oeV6GdU0VT__T2yY09k7uD=bz7mow@mail.gmail.com>
Subject: Re: [PATCH V2 2/3] i2c-nomadik: turn the platform driver to an amba driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        STEricsson_nomadik_linux@list.st.com,
        Linus Walleij <linus.walleij@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jean Delvare <khali@linux-fr.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 3:52 PM, Alessandro Rubini <rubini@gnudd.com> wrote:

> The i2c-nomadik gateware is really a PrimeCell APB device. By hosting
> the driver under the amba bus we can access it more easily, for
> example using the generic pci-amba driver. The patch also fixes the
> mach-ux500 users, so they register an amba device instead than a
> platform device.
>
> The cell-id I used in the amba table are the one for ux500 (only as far as
> I know from the stn-8815 manuals) and the one for STA2X11.
>
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>

OK I tested this now and it causes a fat, ugly regression on ux500 and
makes it hang at boot.

But don't worry! Because I found all the causes.

1) The devices created from dbx500_add_i2c() must have a serious name
  like "nmk-i2c.0" etc. (Caused platform to hang)

2) Each adapter needs a unique adap->nr, this patch made the driver
  into a singleton that couldn't handle multiple instances.

3) Runtime PM screams because the AMBA runtime PM semantics
  differ from the semantics of platform devices. AMBA calls probe
  with pm enabled and one get() refcound and will also disable it
  if probe fails. So just put() it at the end of probe.
  (C.f. drivers/spi/spi-pl022.c)

After fixing this it works fine on ux500. I also changed:

4) The Nomadik PrimeCell ID looks tilted 4 bits. (Haven't tested, just
  looked in the reference manual)

Suggested patch to fix the patch below, beware that gmail might
have whitespace-mangled it so you might need to edit it
manually.

diff --git a/arch/arm/mach-ux500/devices-common.h
b/arch/arm/mach-ux500/devices-common.h
index cfee556..ecdd838 100644
--- a/arch/arm/mach-ux500/devices-common.h
+++ b/arch/arm/mach-ux500/devices-common.h
@@ -60,8 +60,11 @@ static inline struct amba_device *
 dbx500_add_i2c(struct device *parent, int id, resource_size_t base, int irq,
 	       struct nmk_i2c_controller *data)
 {
-	return amba_apb_device_add(parent, "nmk-i2c", base, SZ_4K, irq, 0,
-				   data, 0);
+	/* Conjure a name similar to what the platform device used to have */
+	char name[16];
+
+	snprintf(name, sizeof(name), "nmk-i2c.%d", id);
+	return amba_apb_device_add(parent, name, base, SZ_4K, irq, 0, data, 0);
 }

 static inline struct amba_device *
diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index e9ed731..6db453f 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/amba/bus.h>
+#include <linux/atomic.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
@@ -898,6 +899,8 @@ static const struct i2c_algorithm nmk_i2c_algo = {
 	.functionality	= nmk_i2c_functionality
 };

+static atomic_t adapter_id = ATOMIC_INIT(0);
+
 static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 {
 	int ret = 0;
@@ -941,7 +944,6 @@ static int nmk_i2c_probe(struct amba_device *adev,
const struct amba_id *id)
 	}

 	pm_suspend_ignore_children(&adev->dev, true);
-	pm_runtime_enable(&adev->dev);

 	dev->clk = clk_get(&adev->dev, NULL);
 	if (IS_ERR(dev->clk)) {
@@ -957,8 +959,10 @@ static int nmk_i2c_probe(struct amba_device
*adev, const struct amba_id *id)
 	adap->algo	= &nmk_i2c_algo;
 	adap->timeout	= pdata->timeout ? msecs_to_jiffies(pdata->timeout) :
 		msecs_to_jiffies(20000);
+	adap->nr = atomic_read(&adapter_id);
 	snprintf(adap->name, sizeof(adap->name),
 		 "Nomadik I2C%d at %pR", adap->nr, &adev->res);
+	atomic_inc(&adapter_id);

 	/* fetch the controller configuration from machine */
 	dev->cfg.clk_freq = pdata->clk_freq;
@@ -979,6 +983,8 @@ static int nmk_i2c_probe(struct amba_device *adev,
const struct amba_id *id)
 		goto err_add_adap;
 	}

+	pm_runtime_put(&adev->dev);
+
 	return 0;

  err_add_adap:
@@ -986,7 +992,6 @@ static int nmk_i2c_probe(struct amba_device *adev,
const struct amba_id *id)
  err_no_clk:
 	if (dev->regulator)
 		regulator_put(dev->regulator);
-	pm_runtime_disable(&adev->dev);
 	free_irq(dev->irq, dev);
  err_irq:
 	iounmap(dev->virtbase);
@@ -1025,7 +1030,7 @@ static int nmk_i2c_remove(struct amba_device *adev)

 static struct amba_id nmk_i2c_ids[] = {
 	{
-		.id	= 0x00018024,
+		.id	= 0x00180024,
 		.mask	= 0x00ffffff,
 	},
 	{


If you apply this and respin you can add
Tested-by: Linus Walleij <linus.walleij@linaro.org>

On all three patches.

Yours,
Linus Walleij
