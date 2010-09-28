Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab0I1KgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 06:36:11 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:53426 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391Ab0I1KgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 06:36:07 -0400
X-Greylist: delayed 2765 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Sep 2010 06:36:05 EDT
From: Arun Murthy <arun.murthy@stericsson.com>
To: <lars@metafoo.de>, <akpm@linux-foundation.org>, <kernel@pengutronix.de>,
        <philipp.zabel@gmail.com>, <robert.jarzmik@free.fr>,
        <marek.vasut@gmail.com>, <eric.y.miao@gmail.com>, <rpurdie@rpsys.net>,
        <sameo@linux.intel.com>, <kgene.kim@samsung.com>,
        <linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>, <arun.murthy@stericsson.com>,
        <STEricsson_nomadik_linux@list.st.com>
Subject: [PATCH 4/7] pwm: Align existing pwm drivers with pwm-core driver
Date: Tue, 28 Sep 2010 16:05:31 +0530
Message-ID: <1285670134-18063-5-git-send-email-arun.murthy@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1285670134-18063-1-git-send-email-arun.murthy@stericsson.com>
References: <1285670134-18063-1-git-send-email-arun.murthy@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pwm-core: make the driver visible for ARM only

	Align ab8500 pwm with the pwm core driver
	Align twl6030 pwm driver with pwm core driver
	Align Freescale mxc pwm driver with pwm core driver
	Align pxa pwm driver with pwm core driver
	Align samsung(s3c) pwm driver with pwm core driver

mips-jz4740: pwm: Align with new pwm core driver

PWM core driver has been added and has been enabled only for ARM
platform. The same can be utilised for mips also.
Please align with the pwm core driver(drivers/pwm-core.c).

Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/plat-mxc/pwm.c     |  166 +++++++++++++-----------------
 arch/arm/plat-pxa/pwm.c     |  210 ++++++++++++++++++--------------------
 arch/arm/plat-samsung/pwm.c |  235 +++++++++++++++++++------------------------
 arch/mips/jz4740/pwm.c      |    2 +-
 drivers/mfd/twl-core.c      |   13 +++
 drivers/mfd/twl6030-pwm.c   |  111 +++++++++++++-------
 drivers/misc/ab8500-pwm.c   |   87 +++++++---------
 drivers/pwm/Kconfig         |    1 +
 drivers/pwm/pwm-core.c      |    9 +--
 include/linux/pwm.h         |   21 ++++-
 10 files changed, 418 insertions(+), 437 deletions(-)

diff --git a/arch/arm/plat-mxc/pwm.c b/arch/arm/plat-mxc/pwm.c
index c36f263..b259ba9 100644
--- a/arch/arm/plat-mxc/pwm.c
+++ b/arch/arm/plat-mxc/pwm.c
@@ -38,22 +38,16 @@
 
 
 
-struct pwm_device {
-	struct list_head	node;
-	struct platform_device *pdev;
-
-	const char	*label;
+struct mxc_pwm_device {
 	struct clk	*clk;
-
 	int		clk_enabled;
 	void __iomem	*mmio_base;
-
-	unsigned int	use_count;
-	unsigned int	pwm_id;
 };
 
-int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
+static int mxc_pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 {
+	struct mxc_pwm_device *mxc_pwm = pwm->data;
+
 	if (pwm == NULL || period_ns == 0 || duty_ns > period_ns)
 		return -EINVAL;
 
@@ -62,7 +56,7 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 		unsigned long period_cycles, duty_cycles, prescale;
 		u32 cr;
 
-		c = clk_get_rate(pwm->clk);
+		c = clk_get_rate(mxc_pwm->clk);
 		c = c * period_ns;
 		do_div(c, 1000000000);
 		period_cycles = c;
@@ -74,8 +68,8 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 		do_div(c, period_ns);
 		duty_cycles = c;
 
-		writel(duty_cycles, pwm->mmio_base + MX3_PWMSAR);
-		writel(period_cycles, pwm->mmio_base + MX3_PWMPR);
+		writel(duty_cycles, mxc_pwm->mmio_base + MX3_PWMSAR);
+		writel(period_cycles, mxc_pwm->mmio_base + MX3_PWMPR);
 
 		cr = MX3_PWMCR_PRESCALER(prescale) | MX3_PWMCR_EN;
 
@@ -84,7 +78,7 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 		else
 			cr |= MX3_PWMCR_CLKSRC_IPG_HIGH;
 
-		writel(cr, pwm->mmio_base + MX3_PWMCR);
+		writel(cr, mxc_pwm->mmio_base + MX3_PWMCR);
 	} else if (cpu_is_mx1() || cpu_is_mx21()) {
 		/* The PWM subsystem allows for exact frequencies. However,
 		 * I cannot connect a scope on my device to the PWM line and
@@ -102,110 +96,76 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 		 * both the prescaler (/1 .. /128) and then by CLKSEL
 		 * (/2 .. /16).
 		 */
-		u32 max = readl(pwm->mmio_base + MX1_PWMP);
+		u32 max = readl(mxc_pwm->mmio_base + MX1_PWMP);
 		u32 p = max * duty_ns / period_ns;
-		writel(max - p, pwm->mmio_base + MX1_PWMS);
+		writel(max - p, mxc_pwm->mmio_base + MX1_PWMS);
 	} else {
 		BUG();
 	}
 
 	return 0;
 }
-EXPORT_SYMBOL(pwm_config);
 
-int pwm_enable(struct pwm_device *pwm)
+static int mxc_pwm_enable(struct pwm_device *pwm)
 {
+	struct mxc_pwm_device *mxc_pwm = pwm->data;
 	int rc = 0;
 
-	if (!pwm->clk_enabled) {
-		rc = clk_enable(pwm->clk);
+	if (!mxc_pwm->clk_enabled) {
+		rc = clk_enable(mxc_pwm->clk);
 		if (!rc)
-			pwm->clk_enabled = 1;
+			mxc_pwm->clk_enabled = 1;
 	}
 	return rc;
 }
-EXPORT_SYMBOL(pwm_enable);
-
-void pwm_disable(struct pwm_device *pwm)
-{
-	writel(0, pwm->mmio_base + MX3_PWMCR);
-
-	if (pwm->clk_enabled) {
-		clk_disable(pwm->clk);
-		pwm->clk_enabled = 0;
-	}
-}
-EXPORT_SYMBOL(pwm_disable);
-
-static DEFINE_MUTEX(pwm_lock);
-static LIST_HEAD(pwm_list);
 
-struct pwm_device *pwm_request(int pwm_id, const char *label)
+static int mxc_pwm_disable(struct pwm_device *pwm)
 {
-	struct pwm_device *pwm;
-	int found = 0;
+	struct mxc_pwm_device *mxc_pwm = pwm->data;
 
-	mutex_lock(&pwm_lock);
+	writel(0, mxc_pwm->mmio_base + MX3_PWMCR);
 
-	list_for_each_entry(pwm, &pwm_list, node) {
-		if (pwm->pwm_id == pwm_id) {
-			found = 1;
-			break;
-		}
+	if (mxc_pwm->clk_enabled) {
+		clk_disable(mxc_pwm->clk);
+		mxc_pwm->clk_enabled = 0;
 	}
-
-	if (found) {
-		if (pwm->use_count == 0) {
-			pwm->use_count++;
-			pwm->label = label;
-		} else
-			pwm = ERR_PTR(-EBUSY);
-	} else
-		pwm = ERR_PTR(-ENOENT);
-
-	mutex_unlock(&pwm_lock);
-	return pwm;
-}
-EXPORT_SYMBOL(pwm_request);
-
-void pwm_free(struct pwm_device *pwm)
-{
-	mutex_lock(&pwm_lock);
-
-	if (pwm->use_count) {
-		pwm->use_count--;
-		pwm->label = NULL;
-	} else
-		pr_warning("PWM device already freed\n");
-
-	mutex_unlock(&pwm_lock);
+	return 0;
 }
-EXPORT_SYMBOL(pwm_free);
 
 static int __devinit mxc_pwm_probe(struct platform_device *pdev)
 {
+	struct mxc_pwm_device *mxc_pwm;
 	struct pwm_device *pwm;
+	struct pwm_ops *pops;
 	struct resource *r;
 	int ret = 0;
 
+	mxc_pwm = kzalloc(sizeof(struct mxc_pwm_device), GFP_KERNEL);
+	if (mxc_pwm == NULL) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
 	pwm = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
 	if (pwm == NULL) {
 		dev_err(&pdev->dev, "failed to allocate memory\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_free1;
+	}
+	pops = kzalloc(sizeof(struct pwm_ops), GFP_KERNEL);
+	if (pops == NULL) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		ret = -ENOMEM;
+		goto err_free2;
 	}
 
-	pwm->clk = clk_get(&pdev->dev, "pwm");
+	mxc_pwm->clk = clk_get(&pdev->dev, "pwm");
 
-	if (IS_ERR(pwm->clk)) {
-		ret = PTR_ERR(pwm->clk);
-		goto err_free;
+	if (IS_ERR(mxc_pwm->clk)) {
+		ret = PTR_ERR(mxc_pwm->clk);
+		goto err_free3;
 	}
 
-	pwm->clk_enabled = 0;
-
-	pwm->use_count = 0;
-	pwm->pwm_id = pdev->id;
-	pwm->pdev = pdev;
+	mxc_pwm->clk_enabled = 0;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (r == NULL) {
@@ -221,16 +181,27 @@ static int __devinit mxc_pwm_probe(struct platform_device *pdev)
 		goto err_free_clk;
 	}
 
-	pwm->mmio_base = ioremap(r->start, r->end - r->start + 1);
-	if (pwm->mmio_base == NULL) {
+	mxc_pwm->mmio_base = ioremap(r->start, r->end - r->start + 1);
+	if (mxc_pwm->mmio_base == NULL) {
 		dev_err(&pdev->dev, "failed to ioremap() registers\n");
 		ret = -ENODEV;
 		goto err_free_mem;
 	}
 
-	mutex_lock(&pwm_lock);
-	list_add_tail(&pwm->node, &pwm_list);
-	mutex_unlock(&pwm_lock);
+	pops->pwm_config = mxc_pwm_config;
+	pops->pwm_enable = mxc_pwm_enable;
+	pops->pwm_disable = mxc_pwm_disable;
+	pops->name = pdev->name;
+
+	pwm->pwm_id = pdev->id;
+	pwm->dev = &pdev->dev;
+	pwm->pops = pops;
+	pwm->data = mxc_pwm;
+	ret = pwm_device_register(pwm);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to register pwm device\n");
+		goto err_free_mem;
+	}
 
 	platform_set_drvdata(pdev, pwm);
 	return 0;
@@ -238,33 +209,38 @@ static int __devinit mxc_pwm_probe(struct platform_device *pdev)
 err_free_mem:
 	release_mem_region(r->start, r->end - r->start + 1);
 err_free_clk:
-	clk_put(pwm->clk);
-err_free:
+	clk_put(mxc_pwm->clk);
+err_free3:
+	kfree(pops);
+err_free2:
 	kfree(pwm);
+err_free1:
+	kfree(mxc_pwm);
 	return ret;
 }
 
 static int __devexit mxc_pwm_remove(struct platform_device *pdev)
 {
 	struct pwm_device *pwm;
+	struct mxc_pwm_device *mxc_pwm;
 	struct resource *r;
 
 	pwm = platform_get_drvdata(pdev);
 	if (pwm == NULL)
 		return -ENODEV;
+	mxc_pwm = pwm->data;
 
-	mutex_lock(&pwm_lock);
-	list_del(&pwm->node);
-	mutex_unlock(&pwm_lock);
-
-	iounmap(pwm->mmio_base);
+	pwm_device_unregister(pwm);
+	iounmap(mxc_pwm->mmio_base);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(r->start, r->end - r->start + 1);
 
-	clk_put(pwm->clk);
+	clk_put(mxc_pwm->clk);
 
+	kfree(pwm->pops);
 	kfree(pwm);
+	kfree(mxc_pwm);
 	return 0;
 }
 
diff --git a/arch/arm/plat-pxa/pwm.c b/arch/arm/plat-pxa/pwm.c
index ef32686..1de902a 100644
--- a/arch/arm/plat-pxa/pwm.c
+++ b/arch/arm/plat-pxa/pwm.c
@@ -43,33 +43,27 @@ MODULE_DEVICE_TABLE(platform, pwm_id_table);
 #define PWMCR_SD	(1 << 6)
 #define PWMDCR_FD	(1 << 10)
 
-struct pwm_device {
-	struct list_head	node;
-	struct pwm_device	*secondary;
-	struct platform_device	*pdev;
-
-	const char	*label;
+struct pxa_pwm_device {
+	struct pxa_pwm_device *sec;
 	struct clk	*clk;
 	int		clk_enabled;
 	void __iomem	*mmio_base;
-
-	unsigned int	use_count;
-	unsigned int	pwm_id;
 };
 
 /*
  * period_ns = 10^9 * (PRESCALE + 1) * (PV + 1) / PWM_CLK_RATE
  * duty_ns   = 10^9 * (PRESCALE + 1) * DC / PWM_CLK_RATE
  */
-int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
+int pxa_pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 {
 	unsigned long long c;
 	unsigned long period_cycles, prescale, pv, dc;
+	struct pxa_pwm_device *pxa_pwm = pwm->data;
 
 	if (pwm == NULL || period_ns == 0 || duty_ns > period_ns)
 		return -EINVAL;
 
-	c = clk_get_rate(pwm->clk);
+	c = clk_get_rate(pxa_pwm->clk);
 	c = c * period_ns;
 	do_div(c, 1000000000);
 	period_cycles = c;
@@ -90,94 +84,45 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 	/* NOTE: the clock to PWM has to be enabled first
 	 * before writing to the registers
 	 */
-	clk_enable(pwm->clk);
-	__raw_writel(prescale, pwm->mmio_base + PWMCR);
-	__raw_writel(dc, pwm->mmio_base + PWMDCR);
-	__raw_writel(pv, pwm->mmio_base + PWMPCR);
-	clk_disable(pwm->clk);
+	clk_enable(pxa_pwm->clk);
+	__raw_writel(prescale, pxa_pwm->mmio_base + PWMCR);
+	__raw_writel(dc, pxa_pwm->mmio_base + PWMDCR);
+	__raw_writel(pv, pxa_pwm->mmio_base + PWMPCR);
+	clk_disable(pxa_pwm->clk);
 
 	return 0;
 }
-EXPORT_SYMBOL(pwm_config);
 
-int pwm_enable(struct pwm_device *pwm)
+int pxa_pwm_enable(struct pwm_device *pwm)
 {
+	struct pxa_pwm_device *pxa_pwm = pwm->data;
 	int rc = 0;
 
-	if (!pwm->clk_enabled) {
-		rc = clk_enable(pwm->clk);
+	if (!pxa_pwm->clk_enabled) {
+		rc = clk_enable(pxa_pwm->clk);
 		if (!rc)
-			pwm->clk_enabled = 1;
+			pxa_pwm->clk_enabled = 1;
 	}
 	return rc;
 }
-EXPORT_SYMBOL(pwm_enable);
 
-void pwm_disable(struct pwm_device *pwm)
+int pxa_pwm_disable(struct pwm_device *pwm)
 {
-	if (pwm->clk_enabled) {
-		clk_disable(pwm->clk);
-		pwm->clk_enabled = 0;
-	}
-}
-EXPORT_SYMBOL(pwm_disable);
-
-static DEFINE_MUTEX(pwm_lock);
-static LIST_HEAD(pwm_list);
+	struct pxa_pwm_device *pxa_pwm = pwm->data;
 
-struct pwm_device *pwm_request(int pwm_id, const char *label)
-{
-	struct pwm_device *pwm;
-	int found = 0;
-
-	mutex_lock(&pwm_lock);
-
-	list_for_each_entry(pwm, &pwm_list, node) {
-		if (pwm->pwm_id == pwm_id) {
-			found = 1;
-			break;
-		}
+	if (pxa_pwm->clk_enabled) {
+		clk_disable(pxa_pwm->clk);
+		pxa_pwm->clk_enabled = 0;
 	}
-
-	if (found) {
-		if (pwm->use_count == 0) {
-			pwm->use_count++;
-			pwm->label = label;
-		} else
-			pwm = ERR_PTR(-EBUSY);
-	} else
-		pwm = ERR_PTR(-ENOENT);
-
-	mutex_unlock(&pwm_lock);
-	return pwm;
-}
-EXPORT_SYMBOL(pwm_request);
-
-void pwm_free(struct pwm_device *pwm)
-{
-	mutex_lock(&pwm_lock);
-
-	if (pwm->use_count) {
-		pwm->use_count--;
-		pwm->label = NULL;
-	} else
-		pr_warning("PWM device already freed\n");
-
-	mutex_unlock(&pwm_lock);
-}
-EXPORT_SYMBOL(pwm_free);
-
-static inline void __add_pwm(struct pwm_device *pwm)
-{
-	mutex_lock(&pwm_lock);
-	list_add_tail(&pwm->node, &pwm_list);
-	mutex_unlock(&pwm_lock);
+	return 0;
 }
 
 static int __devinit pwm_probe(struct platform_device *pdev)
 {
 	const struct platform_device_id *id = platform_get_device_id(pdev);
+	struct pxa_pwm_device *pxa_pwm, *pxa_pwm_sec;
 	struct pwm_device *pwm, *secondary = NULL;
+	struct pwm_ops *pops;
 	struct resource *r;
 	int ret = 0;
 
@@ -186,17 +131,26 @@ static int __devinit pwm_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "failed to allocate memory\n");
 		return -ENOMEM;
 	}
+	pops = kzalloc(sizeof(struct pwm_ops), GFP_KERNEL);
+	if (pops == NULL) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		kfree(pwm);
+		return -ENOMEM;
+	}
+	pxa_pwm = kzalloc(sizeof(struct pxa_pwm_device), GFP_KERNEL);
+	if (pxa_pwm == NULL) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		kfree(pops);
+		kfree(pwm);
+		return -ENOMEM;
+	}
 
-	pwm->clk = clk_get(&pdev->dev, NULL);
-	if (IS_ERR(pwm->clk)) {
-		ret = PTR_ERR(pwm->clk);
+	pxa_pwm->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(pxa_pwm->clk)) {
+		ret = PTR_ERR(pxa_pwm->clk);
 		goto err_free;
 	}
-	pwm->clk_enabled = 0;
-
-	pwm->use_count = 0;
-	pwm->pwm_id = PWM_ID_BASE(id->driver_data) + pdev->id;
-	pwm->pdev = pdev;
+	pxa_pwm->clk_enabled = 0;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (r == NULL) {
@@ -212,69 +166,105 @@ static int __devinit pwm_probe(struct platform_device *pdev)
 		goto err_free_clk;
 	}
 
-	pwm->mmio_base = ioremap(r->start, resource_size(r));
-	if (pwm->mmio_base == NULL) {
+	pxa_pwm->mmio_base = ioremap(r->start, resource_size(r));
+	if (pxa_pwm->mmio_base == NULL) {
 		dev_err(&pdev->dev, "failed to ioremap() registers\n");
 		ret = -ENODEV;
 		goto err_free_mem;
 	}
 
+	pops->pwm_config = pxa_pwm_config;
+	pops->pwm_enable = pxa_pwm_enable;
+	pops->pwm_disable = pxa_pwm_disable;
+	pops->name = pdev->name;
+
+	pwm->pwm_id = PWM_ID_BASE(id->driver_data) + pdev->id;
+	pwm->dev = &pdev->dev;
+	pwm->pops = pops;
+	pwm->data = pxa_pwm;
+
+	ret = pwm_device_register(pwm);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to register pwm device\n");
+		goto err_free_mem;
+	}
+
 	if (id->driver_data & HAS_SECONDARY_PWM) {
 		secondary = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
 		if (secondary == NULL) {
 			ret = -ENOMEM;
-			goto err_free_mem;
+			goto err_pwm;
+		}
+		pxa_pwm_sec = kzalloc(sizeof(struct pxa_pwm_device),
+								GFP_KERNEL);
+		if (pxa_pwm_sec == NULL) {
+			ret = -ENOMEM;
+			goto err_free_mem2;
 		}
 
 		*secondary = *pwm;
-		pwm->secondary = secondary;
+		*pxa_pwm_sec = *pxa_pwm;
+		pxa_pwm->sec = pxa_pwm_sec;
 
 		/* registers for the second PWM has offset of 0x10 */
-		secondary->mmio_base = pwm->mmio_base + 0x10;
+		pxa_pwm_sec->mmio_base = pxa_pwm->mmio_base + 0x10;
 		secondary->pwm_id = pdev->id + 2;
-	}
+		secondary->data = pxa_pwm_sec;
 
-	__add_pwm(pwm);
-	if (secondary)
-		__add_pwm(secondary);
+		ret = pwm_device_register(secondary);
+		if (ret < 0) {
+			dev_err(&pdev->dev, "failed to register pwm device\n");
+			goto err_free_mem3;
+		}
+	}
 
 	platform_set_drvdata(pdev, pwm);
 	return 0;
-
+err_free_mem3:
+	kfree(pxa_pwm_sec);
+err_free_mem2:
+	kfree(secondary);
+err_pwm:
+	pwm_device_unregister(pwm);
 err_free_mem:
 	release_mem_region(r->start, resource_size(r));
 err_free_clk:
-	clk_put(pwm->clk);
+	clk_put(pxa_pwm->clk);
 err_free:
+	kfree(pxa_pwm);
+	kfree(pops);
 	kfree(pwm);
 	return ret;
 }
 
 static int __devexit pwm_remove(struct platform_device *pdev)
 {
-	struct pwm_device *pwm;
+	struct pwm_device *pwm, *secondary;
+	struct pxa_pwm_device *pxa_pwm, *pxa_pwm_sec;
 	struct resource *r;
 
 	pwm = platform_get_drvdata(pdev);
 	if (pwm == NULL)
 		return -ENODEV;
-
-	mutex_lock(&pwm_lock);
-
-	if (pwm->secondary) {
-		list_del(&pwm->secondary->node);
-		kfree(pwm->secondary);
+	pxa_pwm = pwm->data;
+	secondary = pwm_request((pdev->id + 2), pdev->name);
+	pxa_pwm_sec = secondary->data;
+
+	pwm_device_unregister(pwm);
+	iounmap(pxa_pwm->mmio_base);
+	if (secondary) {
+		pwm_device_unregister(secondary);
+		iounmap(pxa_pwm->mmio_base);
+		kfree(pxa_pwm_sec);
+		kfree(secondary);
 	}
 
-	list_del(&pwm->node);
-	mutex_unlock(&pwm_lock);
-
-	iounmap(pwm->mmio_base);
-
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(r->start, resource_size(r));
 
-	clk_put(pwm->clk);
+	clk_put(pxa_pwm->clk);
+	kfree(pxa_pwm);
+	kfree(pwm->pops);
 	kfree(pwm);
 	return 0;
 }
diff --git a/arch/arm/plat-samsung/pwm.c b/arch/arm/plat-samsung/pwm.c
index 2eeb49f..63fba01 100644
--- a/arch/arm/plat-samsung/pwm.c
+++ b/arch/arm/plat-samsung/pwm.c
@@ -26,25 +26,19 @@
 #include <plat/devs.h>
 #include <plat/regs-timer.h>
 
-struct pwm_device {
-	struct list_head	 list;
+struct s3c_pwm_device {
 	struct platform_device	*pdev;
 
 	struct clk		*clk_div;
 	struct clk		*clk;
-	const char		*label;
 
 	unsigned int		 period_ns;
 	unsigned int		 duty_ns;
 
 	unsigned char		 tcon_base;
 	unsigned char		 running;
-	unsigned char		 use_count;
-	unsigned char		 pwm_id;
 };
 
-#define pwm_dbg(_pwm, msg...) dev_dbg(&(_pwm)->pdev->dev, msg)
-
 static struct clk *clk_scaler[2];
 
 /* Standard setup for a timer block. */
@@ -78,108 +72,61 @@ struct platform_device s3c_device_timer[] = {
 	[4] = { DEFINE_S3C_TIMER(4, IRQ_TIMER4) },
 };
 
-static inline int pwm_is_tdiv(struct pwm_device *pwm)
+static inline int pwm_is_tdiv(struct s3c_pwm_device *s3c_pwm)
 {
-	return clk_get_parent(pwm->clk) == pwm->clk_div;
+	return clk_get_parent(s3c_pwm->clk) == s3c_pwm->clk_div;
 }
 
-static DEFINE_MUTEX(pwm_lock);
-static LIST_HEAD(pwm_list);
+#define pwm_tcon_start(s3c_pwm) (1 << (s3c_pwm->tcon_base + 0))
+#define pwm_tcon_invert(s3c_pwm) (1 << (s3c_pwm->tcon_base + 2))
+#define pwm_tcon_autoreload(s3c_pwm) (1 << (s3c_pwm->tcon_base + 3))
+#define pwm_tcon_manulupdate(s3c_pwm) (1 << (s3c_pwm->tcon_base + 1))
 
-struct pwm_device *pwm_request(int pwm_id, const char *label)
-{
-	struct pwm_device *pwm;
-	int found = 0;
-
-	mutex_lock(&pwm_lock);
-
-	list_for_each_entry(pwm, &pwm_list, list) {
-		if (pwm->pwm_id == pwm_id) {
-			found = 1;
-			break;
-		}
-	}
-
-	if (found) {
-		if (pwm->use_count == 0) {
-			pwm->use_count = 1;
-			pwm->label = label;
-		} else
-			pwm = ERR_PTR(-EBUSY);
-	} else
-		pwm = ERR_PTR(-ENOENT);
-
-	mutex_unlock(&pwm_lock);
-	return pwm;
-}
-
-EXPORT_SYMBOL(pwm_request);
-
-
-void pwm_free(struct pwm_device *pwm)
-{
-	mutex_lock(&pwm_lock);
-
-	if (pwm->use_count) {
-		pwm->use_count--;
-		pwm->label = NULL;
-	} else
-		printk(KERN_ERR "PWM%d device already freed\n", pwm->pwm_id);
-
-	mutex_unlock(&pwm_lock);
-}
-
-EXPORT_SYMBOL(pwm_free);
-
-#define pwm_tcon_start(pwm) (1 << (pwm->tcon_base + 0))
-#define pwm_tcon_invert(pwm) (1 << (pwm->tcon_base + 2))
-#define pwm_tcon_autoreload(pwm) (1 << (pwm->tcon_base + 3))
-#define pwm_tcon_manulupdate(pwm) (1 << (pwm->tcon_base + 1))
-
-int pwm_enable(struct pwm_device *pwm)
+int s3c_pwm_enable(struct pwm_device *pwm)
 {
 	unsigned long flags;
 	unsigned long tcon;
+	struct s3c_pwm_device *s3c_pwm = pwm->data;
 
 	local_irq_save(flags);
 
 	tcon = __raw_readl(S3C2410_TCON);
-	tcon |= pwm_tcon_start(pwm);
+	tcon |= pwm_tcon_start(s3c_pwm);
 	__raw_writel(tcon, S3C2410_TCON);
 
 	local_irq_restore(flags);
 
-	pwm->running = 1;
+	s3c_pwm->running = 1;
 	return 0;
 }
 
-EXPORT_SYMBOL(pwm_enable);
-
-void pwm_disable(struct pwm_device *pwm)
+int s3c_pwm_disable(struct pwm_device *pwm)
 {
 	unsigned long flags;
 	unsigned long tcon;
+	struct s3c_pwm_device *s3c_pwm = pwm->data;
 
 	local_irq_save(flags);
 
 	tcon = __raw_readl(S3C2410_TCON);
-	tcon &= ~pwm_tcon_start(pwm);
+	tcon &= ~pwm_tcon_start(s3c_pwm);
 	__raw_writel(tcon, S3C2410_TCON);
 
 	local_irq_restore(flags);
 
-	pwm->running = 0;
+	s3c_pwm->running = 0;
+	return 0;
 }
 
-EXPORT_SYMBOL(pwm_disable);
-
-static unsigned long pwm_calc_tin(struct pwm_device *pwm, unsigned long freq)
+static unsigned long pwm_calc_tin(struct pwm_device *pwm,
+		unsigned long freq)
 {
 	unsigned long tin_parent_rate;
 	unsigned int div;
+	struct s3c_pwm_device *s3c_pwm = pwm->data;
 
-	tin_parent_rate = clk_get_rate(clk_get_parent(pwm->clk_div));
-	pwm_dbg(pwm, "tin parent at %lu\n", tin_parent_rate);
+	tin_parent_rate = clk_get_rate(clk_get_parent(s3c_pwm->clk_div));
+	dev_dbg(pwm->dev, "tin parent at %lu\n", tin_parent_rate);
 
 	for (div = 2; div <= 16; div *= 2) {
 		if ((tin_parent_rate / (div << 16)) < freq)
@@ -191,7 +138,7 @@ static unsigned long pwm_calc_tin(struct pwm_device *pwm, unsigned long freq)
 
 #define NS_IN_HZ (1000000000UL)
 
-int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
+int s3c_pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 {
 	unsigned long tin_rate;
 	unsigned long tin_ns;
@@ -200,6 +147,7 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 	unsigned long tcon;
 	unsigned long tcnt;
 	long tcmp;
+	struct s3c_pwm_device *s3c_pwm = pwm->data;
 
 	/* We currently avoid using 64bit arithmetic by using the
 	 * fact that anything faster than 1Hz is easily representable
@@ -211,8 +159,8 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 	if (duty_ns > period_ns)
 		return -EINVAL;
 
-	if (period_ns == pwm->period_ns &&
-	    duty_ns == pwm->duty_ns)
+	if (period_ns == s3c_pwm->period_ns &&
+	    duty_ns == s3c_pwm->duty_ns)
 		return 0;
 
 	/* The TCMP and TCNT can be read without a lock, they're not
@@ -223,26 +171,26 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 
 	period = NS_IN_HZ / period_ns;
 
-	pwm_dbg(pwm, "duty_ns=%d, period_ns=%d (%lu)\n",
+	dev_dbg(pwm->dev, "duty_ns=%d, period_ns=%d (%lu)\n",
 		duty_ns, period_ns, period);
 
 	/* Check to see if we are changing the clock rate of the PWM */
 
-	if (pwm->period_ns != period_ns) {
-		if (pwm_is_tdiv(pwm)) {
+	if (s3c_pwm->period_ns != period_ns) {
+		if (pwm_is_tdiv(s3c_pwm)) {
 			tin_rate = pwm_calc_tin(pwm, period);
-			clk_set_rate(pwm->clk_div, tin_rate);
+			clk_set_rate(s3c_pwm->clk_div, tin_rate);
 		} else
-			tin_rate = clk_get_rate(pwm->clk);
+			tin_rate = clk_get_rate(s3c_pwm->clk);
 
-		pwm->period_ns = period_ns;
+		s3c_pwm->period_ns = period_ns;
 
-		pwm_dbg(pwm, "tin_rate=%lu\n", tin_rate);
+		dev_dbg(pwm->dev, "tin_rate=%lu\n", tin_rate);
 
 		tin_ns = NS_IN_HZ / tin_rate;
 		tcnt = period_ns / tin_ns;
 	} else
-		tin_ns = NS_IN_HZ / clk_get_rate(pwm->clk);
+		tin_ns = NS_IN_HZ / clk_get_rate(s3c_pwm->clk);
 
 	/* Note, counters count down */
 
@@ -253,7 +201,7 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 	if (tcmp == tcnt)
 		tcmp--;
 
-	pwm_dbg(pwm, "tin_ns=%lu, tcmp=%ld/%lu\n", tin_ns, tcmp, tcnt);
+	dev_dbg(pwm->dev, "tin_ns=%lu, tcmp=%ld/%lu\n", tin_ns, tcmp, tcnt);
 
 	if (tcmp < 0)
 		tcmp = 0;
@@ -266,11 +214,11 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 	__raw_writel(tcnt, S3C2410_TCNTB(pwm->pwm_id));
 
 	tcon = __raw_readl(S3C2410_TCON);
-	tcon |= pwm_tcon_manulupdate(pwm);
-	tcon |= pwm_tcon_autoreload(pwm);
+	tcon |= pwm_tcon_manulupdate(s3c_pwm);
+	tcon |= pwm_tcon_autoreload(s3c_pwm);
 	__raw_writel(tcon, S3C2410_TCON);
 
-	tcon &= ~pwm_tcon_manulupdate(pwm);
+	tcon &= ~pwm_tcon_manulupdate(s3c_pwm);
 	__raw_writel(tcon, S3C2410_TCON);
 
 	local_irq_restore(flags);
@@ -278,103 +226,122 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 	return 0;
 }
 
-EXPORT_SYMBOL(pwm_config);
-
-static int pwm_register(struct pwm_device *pwm)
-{
-	pwm->duty_ns = -1;
-	pwm->period_ns = -1;
-
-	mutex_lock(&pwm_lock);
-	list_add_tail(&pwm->list, &pwm_list);
-	mutex_unlock(&pwm_lock);
-
-	return 0;
-}
-
 static int s3c_pwm_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
+	struct s3c_pwm_device *s3c_pwm;
 	struct pwm_device *pwm;
+	struct pwm_ops *pops;
 	unsigned long flags;
 	unsigned long tcon;
 	unsigned int id = pdev->id;
-	int ret;
+	int ret = 0;
 
 	if (id == 4) {
 		dev_err(dev, "TIMER4 is currently not supported\n");
 		return -ENXIO;
 	}
 
+	s3c_pwm = kzalloc(sizeof(struct s3c_pwm_device), GFP_KERNEL);
+	if (s3c_pwm == NULL) {
+		dev_err(dev, "failed to allocate pwm_device\n");
+		return -ENOMEM;
+	}
+	s3c_pwm->pdev = pdev;
 	pwm = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
 	if (pwm == NULL) {
 		dev_err(dev, "failed to allocate pwm_device\n");
-		return -ENOMEM;
+		goto err_alloc;
+		ret = -ENOMEM;
+	}
+	pops = kzalloc(sizeof(struct pwm_ops), GFP_KERNEL);
+	if (pops == NULL) {
+		dev_err(dev, "failed to allocate memory\n");
+		goto err_alloc1;
+		ret = -ENOMEM;
 	}
-
-	pwm->pdev = pdev;
-	pwm->pwm_id = id;
 
 	/* calculate base of control bits in TCON */
-	pwm->tcon_base = id == 0 ? 0 : (id * 4) + 4;
+	s3c_pwm->tcon_base = id == 0 ? 0 : (id * 4) + 4;
 
-	pwm->clk = clk_get(dev, "pwm-tin");
-	if (IS_ERR(pwm->clk)) {
+	s3c_pwm->clk = clk_get(dev, "pwm-tin");
+	if (IS_ERR(s3c_pwm->clk)) {
 		dev_err(dev, "failed to get pwm tin clk\n");
-		ret = PTR_ERR(pwm->clk);
-		goto err_alloc;
+		ret = PTR_ERR(s3c_pwm->clk);
+		goto err_alloc2;
 	}
 
-	pwm->clk_div = clk_get(dev, "pwm-tdiv");
-	if (IS_ERR(pwm->clk_div)) {
+	s3c_pwm->clk_div = clk_get(dev, "pwm-tdiv");
+	if (IS_ERR(s3c_pwm->clk_div)) {
 		dev_err(dev, "failed to get pwm tdiv clk\n");
-		ret = PTR_ERR(pwm->clk_div);
+		ret = PTR_ERR(s3c_pwm->clk_div);
 		goto err_clk_tin;
 	}
 
 	local_irq_save(flags);
 
 	tcon = __raw_readl(S3C2410_TCON);
-	tcon |= pwm_tcon_invert(pwm);
+	tcon |= pwm_tcon_invert(s3c_pwm);
 	__raw_writel(tcon, S3C2410_TCON);
 
 	local_irq_restore(flags);
 
+	pops->pwm_config = s3c_pwm_config;
+	pops->pwm_enable = s3c_pwm_enable;
+	pops->pwm_disable = s3c_pwm_disable;
+	pops->name = pdev->name;
+
+	pwm->dev = dev;
+	pwm->pwm_id = id;
+	pwm->pops = pops;
+	pwm->data = s3c_pwm;
 
-	ret = pwm_register(pwm);
+	s3c_pwm->duty_ns = -1;
+	s3c_pwm->period_ns = -1;
+	ret = pwm_device_register(pwm);
 	if (ret) {
 		dev_err(dev, "failed to register pwm\n");
 		goto err_clk_tdiv;
 	}
 
-	pwm_dbg(pwm, "config bits %02x\n",
-		(__raw_readl(S3C2410_TCON) >> pwm->tcon_base) & 0x0f);
+	dev_dbg(dev, "config bits %02x\n",
+		(__raw_readl(S3C2410_TCON) >> s3c_pwm->tcon_base) & 0x0f);
 
 	dev_info(dev, "tin at %lu, tdiv at %lu, tin=%sclk, base %d\n",
-		 clk_get_rate(pwm->clk),
-		 clk_get_rate(pwm->clk_div),
-		 pwm_is_tdiv(pwm) ? "div" : "ext", pwm->tcon_base);
+		 clk_get_rate(s3c_pwm->clk),
+		 clk_get_rate(s3c_pwm->clk_div),
+		 pwm_is_tdiv(s3c_pwm) ? "div" : "ext", s3c_pwm->tcon_base);
 
 	platform_set_drvdata(pdev, pwm);
 	return 0;
 
- err_clk_tdiv:
-	clk_put(pwm->clk_div);
+err_clk_tdiv:
+	clk_put(s3c_pwm->clk_div);
 
- err_clk_tin:
-	clk_put(pwm->clk);
+err_clk_tin:
+	clk_put(s3c_pwm->clk);
 
- err_alloc:
+err_alloc2:
+	kfree(pops);
+
+err_alloc1:
 	kfree(pwm);
+
+err_alloc:
+	kfree(s3c_pwm);
 	return ret;
 }
 
 static int __devexit s3c_pwm_remove(struct platform_device *pdev)
 {
 	struct pwm_device *pwm = platform_get_drvdata(pdev);
+	struct s3c_pwm_device *s3c_pwm = pwm->data;
 
-	clk_put(pwm->clk_div);
-	clk_put(pwm->clk);
+	pwm_device_unregister(pwm);
+	clk_put(s3c_pwm->clk_div);
+	clk_put(s3c_pwm->clk);
+	kfree(s3c_pwm);
+	kfree(pwm->pops);
 	kfree(pwm);
 
 	return 0;
@@ -384,13 +351,14 @@ static int __devexit s3c_pwm_remove(struct platform_device *pdev)
 static int s3c_pwm_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct pwm_device *pwm = platform_get_drvdata(pdev);
+	struct s3c_pwm_device *s3c_pwm = pwm->data;
 
 	/* No one preserve these values during suspend so reset them
 	 * Otherwise driver leaves PWM unconfigured if same values
 	 * passed to pwm_config
 	 */
-	pwm->period_ns = 0;
-	pwm->duty_ns = 0;
+	s3c_pwm->period_ns = 0;
+	s3c_pwm->duty_ns = 0;
 
 	return 0;
 }
@@ -398,11 +366,12 @@ static int s3c_pwm_suspend(struct platform_device *pdev, pm_message_t state)
 static int s3c_pwm_resume(struct platform_device *pdev)
 {
 	struct pwm_device *pwm = platform_get_drvdata(pdev);
+	struct s3c_pwm_device *s3c_pwm = pwm->data;
 	unsigned long tcon;
 
 	/* Restore invertion */
 	tcon = __raw_readl(S3C2410_TCON);
-	tcon |= pwm_tcon_invert(pwm);
+	tcon |= pwm_tcon_invert(s3c_pwm);
 	__raw_writel(tcon, S3C2410_TCON);
 
 	return 0;
diff --git a/arch/mips/jz4740/pwm.c b/arch/mips/jz4740/pwm.c
index a26a6fa..9f46767 100644
--- a/arch/mips/jz4740/pwm.c
+++ b/arch/mips/jz4740/pwm.c
@@ -152,7 +152,7 @@ int pwm_enable(struct pwm_device *pwm)
 	return 0;
 }
 
-void pwm_disable(struct pwm_device *pwm)
+int pwm_disable(struct pwm_device *pwm)
 {
 	uint32_t ctrl = jz4740_timer_get_ctrl(pwm->id);
 
diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index b0f2c00..6a6ea41 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -129,6 +129,12 @@
 #define twl_has_pwrbutton()	false
 #endif
 
+#if defined CONFIG_TWL6030_PWM
+#define twl_has_pwm()	true
+#else
+#define twl_has_pwm()	false
+#endif
+
 #define SUB_CHIP_ID0 0
 #define SUB_CHIP_ID1 1
 #define SUB_CHIP_ID2 2
@@ -825,6 +831,13 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 	}
+	if (twl_has_pwm()) {
+		child = add_child(SUB_CHIP_ID2, "twl6030_pwm",
+				NULL, 0,
+				false, 0, 0);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+	}
 
 	return 0;
 }
diff --git a/drivers/mfd/twl6030-pwm.c b/drivers/mfd/twl6030-pwm.c
index 5d25bdc..b78324b 100644
--- a/drivers/mfd/twl6030-pwm.c
+++ b/drivers/mfd/twl6030-pwm.c
@@ -20,8 +20,10 @@
 
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/i2c/twl.h>
 #include <linux/slab.h>
+#include <linux/pwm.h>
+#include <linux/err.h>
+#include <linux/i2c/twl.h>
 
 #define LED_PWM_CTRL1	0xF4
 #define LED_PWM_CTRL2	0xF5
@@ -45,15 +47,10 @@
 
 #define PWM_CTRL2_MODE_MASK	0x3
 
-struct pwm_device {
-	const char *label;
-	unsigned int pwm_id;
-};
-
-int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
+int twl6030_pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 {
 	u8 duty_cycle;
-	int ret;
+	int ret = 0;
 
 	if (pwm == NULL || period_ns == 0 || duty_ns > period_ns)
 		return -EINVAL;
@@ -69,12 +66,11 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 	}
 	return 0;
 }
-EXPORT_SYMBOL(pwm_config);
 
-int pwm_enable(struct pwm_device *pwm)
+int twl6030_pwm_enable(struct pwm_device *pwm)
 {
 	u8 val;
-	int ret;
+	int ret = 0;
 
 	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
 	if (ret < 0) {
@@ -95,18 +91,17 @@ int pwm_enable(struct pwm_device *pwm)
 	twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
 	return 0;
 }
-EXPORT_SYMBOL(pwm_enable);
 
-void pwm_disable(struct pwm_device *pwm)
+int twl6030_pwm_disable(struct pwm_device *pwm)
 {
 	u8 val;
-	int ret;
+	int ret = 0;
 
 	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
 	if (ret < 0) {
 		pr_err("%s: Failed to disable PWM, Error %d\n",
 			pwm->label, ret);
-		return;
+		return ret;
 	}
 
 	val &= ~PWM_CTRL2_MODE_MASK;
@@ -116,48 +111,86 @@ void pwm_disable(struct pwm_device *pwm)
 	if (ret < 0) {
 		pr_err("%s: Failed to disable PWM, Error %d\n",
 			pwm->label, ret);
-		return;
 	}
-	return;
+	return ret;
 }
-EXPORT_SYMBOL(pwm_disable);
 
-struct pwm_device *pwm_request(int pwm_id, const char *label)
+static int __devinit twl6030_pwm_probe(struct platform_device *pdev)
 {
-	u8 val;
-	int ret;
 	struct pwm_device *pwm;
+	struct pwm_ops *pops;
+	int ret;
+	u8 val;
 
 	pwm = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
 	if (pwm == NULL) {
-		pr_err("%s: failed to allocate memory\n", label);
-		return NULL;
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+	pops = kzalloc(sizeof(struct pwm_ops), GFP_KERNEL);
+	if (pops == NULL) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		kfree(pwm);
+		return -ENOMEM;
 	}
 
-	pwm->label = label;
-	pwm->pwm_id = pwm_id;
-
+	pops->pwm_config = twl6030_pwm_config;
+	pops->pwm_enable = twl6030_pwm_enable;
+	pops->pwm_disable = twl6030_pwm_disable;
+	pops->name = &pdev->name;
+	pwm->dev = &pdev->dev;
+	pwm->pwm_id = pdev->id;
+	pwm->pops = pops;
+	ret = pwm_device_register(pwm);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to register pwm device\n");
+		kfree(pwm);
+		kfree(pops);
+		return ret;
+	}
+	platform_set_drvdata(pdev, pwm);
 	/* Configure PWM */
 	val = PWM_CTRL2_DIS_PD | PWM_CTRL2_CURR_02 | PWM_CTRL2_SRC_VAC |
-		PWM_CTRL2_MODE_HW;
+							PWM_CTRL2_MODE_HW;
 
 	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
-
 	if (ret < 0) {
-		pr_err("%s: Failed to configure PWM, Error %d\n",
-			 pwm->label, ret);
-
-		kfree(pwm);
-		return NULL;
+		dev_err(&pdev->dev, "Failed to configure PWM, Error %d\n", ret);
+		return ret;
 	}
-
-	return pwm;
+	dev_dbg(&pdev->dev, "pwm probe successful\n");
+	return ret;
 }
-EXPORT_SYMBOL(pwm_request);
 
-void pwm_free(struct pwm_device *pwm)
+static int __devexit twl6030_pwm_remove(struct platform_device *pdev)
 {
-	pwm_disable(pwm);
+	struct pwm_device *pwm = platform_get_drvdata(pdev);
+
+	pwm_device_unregister(pwm);
+	kfree(pwm->pops);
 	kfree(pwm);
+	dev_dbg(&pdev->dev, "pwm driver removed\n");
+	return 0;
 }
-EXPORT_SYMBOL(pwm_free);
+
+static struct platform_driver twl6030_pwm_driver = {
+	.driver = {
+		.name = "twl6030_pwm",
+		.owner = THIS_MODULE,
+	},
+	.probe = twl6030_pwm_probe,
+	.remove = __devexit_p(twl6030_pwm_remove),
+};
+
+static int __init twl6030_pwm_init(void)
+{
+	return platform_driver_register(&twl6030_pwm_driver);
+}
+
+static void __exit twl6030_pwm_deinit(void)
+{
+	platform_driver_unregister(&twl6030_pwm_driver);
+}
+
+subsys_initcall(twl6030_pwm_init);
+module_exit(twl6030_pwm_deinit);
diff --git a/drivers/misc/ab8500-pwm.c b/drivers/misc/ab8500-pwm.c
index 54e3d05..d2b23b6 100644
--- a/drivers/misc/ab8500-pwm.c
+++ b/drivers/misc/ab8500-pwm.c
@@ -23,16 +23,9 @@
 #define ENABLE_PWM			1
 #define DISABLE_PWM			0
 
-struct pwm_device {
-	struct device *dev;
-	struct list_head node;
-	const char *label;
-	unsigned int pwm_id;
-};
-
 static LIST_HEAD(pwm_list);
 
-int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
+int ab8500_pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 {
 	int ret = 0;
 	unsigned int higher_val, lower_val;
@@ -60,23 +53,21 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 
 	return ret;
 }
-EXPORT_SYMBOL(pwm_config);
 
-int pwm_enable(struct pwm_device *pwm)
+int ab8500_pwm_enable(struct pwm_device *pwm)
 {
 	int ret;
 
 	ret = abx500_mask_and_set_register_interruptible(pwm->dev,
 				AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
-				1 << (pwm->pwm_id-1), ENABLE_PWM);
+				1 << (pwm->pwm_id-1), 1 << (pwm->pwm_id-1));
 	if (ret < 0)
 		dev_err(pwm->dev, "%s: Failed to disable PWM, Error %d\n",
 							pwm->label, ret);
 	return ret;
 }
-EXPORT_SYMBOL(pwm_enable);
 
-void pwm_disable(struct pwm_device *pwm)
+int ab8500_pwm_disable(struct pwm_device *pwm)
 {
 	int ret;
 
@@ -86,58 +77,56 @@ void pwm_disable(struct pwm_device *pwm)
 	if (ret < 0)
 		dev_err(pwm->dev, "%s: Failed to disable PWM, Error %d\n",
 							pwm->label, ret);
-	return;
-}
-EXPORT_SYMBOL(pwm_disable);
-
-struct pwm_device *pwm_request(int pwm_id, const char *label)
-{
-	struct pwm_device *pwm;
-
-	list_for_each_entry(pwm, &pwm_list, node) {
-		if (pwm->pwm_id == pwm_id) {
-			pwm->label = label;
-			pwm->pwm_id = pwm_id;
-			return pwm;
-		}
-	}
-
-	return ERR_PTR(-ENOENT);
-}
-EXPORT_SYMBOL(pwm_request);
-
-void pwm_free(struct pwm_device *pwm)
-{
-	pwm_disable(pwm);
+	return ret;
 }
-EXPORT_SYMBOL(pwm_free);
 
 static int __devinit ab8500_pwm_probe(struct platform_device *pdev)
 {
-	struct pwm_device *pwm;
+	int ret = 0;
+	struct pwm_ops *pops;
+	struct pwm_device *pwm_dev;
 	/*
 	 * Nothing to be done in probe, this is required to get the
 	 * device which is required for ab8500 read and write
 	 */
-	pwm = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
-	if (pwm == NULL) {
+	pops = kzalloc(sizeof(struct pwm_ops), GFP_KERNEL);
+	if (pops == NULL) {
 		dev_err(&pdev->dev, "failed to allocate memory\n");
 		return -ENOMEM;
 	}
-	pwm->dev = &pdev->dev;
-	pwm->pwm_id = pdev->id;
-	list_add_tail(&pwm->node, &pwm_list);
-	platform_set_drvdata(pdev, pwm);
-	dev_dbg(pwm->dev, "pwm probe successful\n");
-	return 0;
+	pwm_dev = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
+	if (pwm_dev == NULL) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		kfree(pops);
+		return -ENOMEM;
+	}
+	pops->pwm_config = ab8500_pwm_config;
+	pops->pwm_enable = ab8500_pwm_enable;
+	pops->pwm_disable = ab8500_pwm_disable;
+	pops->name = "ab8500";
+	pwm_dev->dev = &pdev->dev;
+	pwm_dev->pwm_id = pdev->id;
+	pwm_dev->pops = pops;
+	ret = pwm_device_register(pwm_dev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to register pwm device\n");
+		kfree(pwm_dev);
+		kfree(pops);
+		return ret;
+	}
+	platform_set_drvdata(pdev, pwm_dev);
+	dev_dbg(&pdev->dev, "pwm probe successful\n");
+	return ret;
 }
 
 static int __devexit ab8500_pwm_remove(struct platform_device *pdev)
 {
-	struct pwm_device *pwm = platform_get_drvdata(pdev);
-	list_del(&pwm->node);
+	struct pwm_device *pwm_dev = platform_get_drvdata(pdev);
+
+	pwm_device_unregister(pwm_dev);
 	dev_dbg(&pdev->dev, "pwm driver removed\n");
-	kfree(pwm);
+	kfree(pwm_dev->pops);
+	kfree(pwm_dev);
 	return 0;
 }
 
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 5d10106..a88640c 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -4,6 +4,7 @@
 
 menuconfig PWM_DEVICES
 	bool "PWM devices"
+	depends on ARM
 	default y
 	---help---
 	  Say Y here to get to see options for device drivers from various
diff --git a/drivers/pwm/pwm-core.c b/drivers/pwm/pwm-core.c
index b84027a..3a0d426 100644
--- a/drivers/pwm/pwm-core.c
+++ b/drivers/pwm/pwm-core.c
@@ -11,11 +11,6 @@
 #include <linux/err.h>
 #include <linux/pwm.h>
 
-struct pwm_device {
-	struct pwm_ops *pops;
-	int pwm_id;
-};
-
 struct pwm_dev_info {
 	struct pwm_device *pwm_dev;
 	struct list_head list;
@@ -40,9 +35,9 @@ int pwm_enable(struct pwm_device *pwm)
 }
 EXPORT_SYMBOL(pwm_enable);
 
-void pwm_disable(struct pwm_device *pwm)
+int pwm_disable(struct pwm_device *pwm)
 {
-	pwm->pops->pwm_disable(pwm);
+	return pwm->pops->pwm_disable(pwm);
 }
 EXPORT_SYMBOL(pwm_disable);
 
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 6e7da1f..4344c0b 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -1,14 +1,29 @@
 #ifndef __LINUX_PWM_H
 #define __LINUX_PWM_H
 
-struct pwm_device;
+/*
+ * TODO: #if defined CONFIG_PWM_CORE has to be removed after mips jz4740
+ * pwm driver aligning with pwm-core.c driver.
+ */
+#if defined CONFIG_PWM_CORE
+struct pwm_device {
+	struct pwm_ops *pops;
+	struct device *dev;
+	struct list_head node;
+	const char *label;
+	unsigned int pwm_id;
+	void *data;
+};
 
 struct pwm_ops {
 	int (*pwm_config)(struct pwm_device *pwm, int duty_ns, int period_ns);
 	int (*pwm_enable)(struct pwm_device *pwm);
 	int (*pwm_disable)(struct pwm_device *pwm);
-	char *name;
+	const char *name;
 };
+#else
+struct pwm_device;
+#endif
 
 /*
  * pwm_request - request a PWM device
@@ -33,7 +48,7 @@ int pwm_enable(struct pwm_device *pwm);
 /*
  * pwm_disable - stop a PWM output toggling
  */
-void pwm_disable(struct pwm_device *pwm);
+int pwm_disable(struct pwm_device *pwm);
 
 int pwm_device_register(struct pwm_device *pwm_dev);
 int pwm_device_unregister(struct pwm_device *pwm_dev);
-- 
1.7.2.dirty

