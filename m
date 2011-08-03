Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab1HCMzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 08:55:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54024 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604Ab1HCMzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 08:55:46 -0400
Date: Wed, 3 Aug 2011 13:55:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Viresh Kumar <viresh.kumar@st.com>, pratyush.anand@st.com,
        rajeev-dlh.kumar@st.com, armando.visconti@st.com,
        bhupesh.sharma@st.com, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com, shiraz.hashim@st.com,
        amit.virdi@st.com, vipulkumar.samar@st.com, viresh.linux@gmail.com,
        deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 07/18] dmaengine/amba-pl08x: Enable/Disable amba_pclk
	with channel requests
Message-ID: <20110803125524.GC23953@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com> <96781d46e41fa6ffc04b88527a25d73f5a59eda8.1311936524.git.viresh.kumar@st.com> <20110730120740.GA15791@n2100.arm.linux.org.uk> <20110730130537.GB15791@n2100.arm.linux.org.uk> <CAKnu2MqTYF43wW3axM--jXdtvsCyRBTLEHDc3hPoJYAmTAL5UA@mail.gmail.com> <CAKnu2MppEKxZD2Z77tfShMfG80d-Xx26yBGhZtJkJ2C6SjE=1w@mail.gmail.com> <20110731170451.GC2975@n2100.arm.linux.org.uk> <CACRpkdZTsD=7woN1qV-sFpsJTyT0LQBq+q=xTOwuewAk=ijBjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZTsD=7woN1qV-sFpsJTyT0LQBq+q=xTOwuewAk=ijBjQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 11:05:38AM +0200, Linus Walleij wrote:
> On Sun, Jul 31, 2011 at 7:04 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Sun, Jul 31, 2011 at 02:04:47AM +0200, Linus Walleij wrote:
> >>
> >> ..and while it will just cause some double refcounts on the clock,
> >> it makes sense to delete the pclk manipulation from the PL022
> >> driver code as part of the patch, like this:
> >
> > Yes, this looks fine.  Shall I wrap it up as part of my patch?
> 
> Yes please.
> Acked-by.

Can you give this a try - this adds runtime PM to the primecell core,
updates the SPI driver for those changes, and adds runtime PM to the
MMCI driver.  I've briefly tested this on Versatile PB926, though
obviously not the SPI stuff very much because Versatile has no SPI
peripherals.

I chose the PCI methodology to this - rather than having every driver
fiddle about with enabling runtime PM, that's dealt with in the core
and instead, drivers just do a put() in their probe and a balancing
get() in their remove function to activate runtime PM for the device.

Thanks.

 drivers/amba/bus.c      |   57 +++++++++++++++++++++++++++++++--
 drivers/mmc/host/mmci.c |   12 +++++++
 drivers/spi/spi-pl022.c |   80 ++++++++++++++++++++++++++++-------------------
 3 files changed, 114 insertions(+), 35 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index d74926e..84bdaac 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -365,6 +365,40 @@ static int amba_pm_restore_noirq(struct device *dev)
 
 #endif /* !CONFIG_HIBERNATE_CALLBACKS */
 
+#ifdef CONFIG_PM_RUNTIME
+/*
+ * Hooks to provide runtime PM of the pclk (bus clock).  It is safe to
+ * enable/disable the bus clock at runtime PM suspend/resume as this
+ * does not result in loss of context.  However, disabling vcore power
+ * would do, so we leave that to the driver.
+ */
+static int amba_pm_runtime_suspend(struct device *dev)
+{
+	struct amba_device *pcdev = to_amba_device(dev);
+	int ret = pm_generic_runtime_suspend(dev);
+
+	if (ret == 0 && dev->driver)
+		clk_disable(pcdev->pclk);
+
+	return ret;
+}
+
+static int amba_pm_runtime_resume(struct device *dev)
+{
+	struct amba_device *pcdev = to_amba_device(dev);
+	int ret;
+
+	if (dev->driver) {
+		ret = clk_enable(pcdev->pclk);
+		/* Failure is probably fatal to the system, but... */
+		if (ret)
+			return ret;
+	}
+
+	return pm_generic_runtime_resume(dev);
+}
+#endif
+
 #ifdef CONFIG_PM
 
 static const struct dev_pm_ops amba_pm = {
@@ -383,8 +417,8 @@ static const struct dev_pm_ops amba_pm = {
 	.poweroff_noirq	= amba_pm_poweroff_noirq,
 	.restore_noirq	= amba_pm_restore_noirq,
 	SET_RUNTIME_PM_OPS(
-		pm_generic_runtime_suspend,
-		pm_generic_runtime_resume,
+		amba_pm_runtime_suspend,
+		amba_pm_runtime_resume,
 		pm_generic_runtime_idle
 	)
 };
@@ -494,10 +528,18 @@ static int amba_probe(struct device *dev)
 		if (ret)
 			break;
 
+		pm_runtime_get_noresume(dev);
+		pm_runtime_set_active(dev);
+		pm_runtime_enable(dev);
+
 		ret = pcdrv->probe(pcdev, id);
 		if (ret == 0)
 			break;
 
+		pm_runtime_disable(dev);
+		pm_runtime_set_suspended(dev);
+		pm_runtime_put_noidle(dev);
+
 		amba_put_disable_pclk(pcdev);
 		amba_put_disable_vcore(pcdev);
 	} while (0);
@@ -509,7 +551,16 @@ static int amba_remove(struct device *dev)
 {
 	struct amba_device *pcdev = to_amba_device(dev);
 	struct amba_driver *drv = to_amba_driver(dev->driver);
-	int ret = drv->remove(pcdev);
+	int ret;
+
+	pm_runtime_get_sync(dev);
+	ret = drv->remove(pcdev);
+	pm_runtime_put_noidle(dev);
+
+	/* Undo the runtime PM settings in amba_probe() */
+	pm_runtime_disable(dev);
+	pm_runtime_set_suspended(dev);
+	pm_runtime_put_noidle(dev);
 
 	amba_put_disable_pclk(pcdev);
 	amba_put_disable_vcore(pcdev);
diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 56e9a41..5e142b7 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -29,6 +29,7 @@
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
 #include <linux/amba/mmci.h>
+#include <linux/pm_runtime.h>
 
 #include <asm/div64.h>
 #include <asm/io.h>
@@ -170,6 +171,7 @@ mmci_request_end(struct mmci_host *host, struct mmc_request *mrq)
 	 * back into the driver...
 	 */
 	spin_unlock(&host->lock);
+	pm_runtime_put(mmc_dev(host->mmc));
 	mmc_request_done(host->mmc, mrq);
 	spin_lock(&host->lock);
 }
@@ -984,6 +986,8 @@ static void mmci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 		return;
 	}
 
+	pm_runtime_get_sync(mmc_dev(mmc));
+
 	spin_lock_irqsave(&host->lock, flags);
 
 	host->mrq = mrq;
@@ -1327,6 +1331,8 @@ static int __devinit mmci_probe(struct amba_device *dev,
 
 	mmci_dma_setup(host);
 
+	pm_runtime_put(&dev->dev);
+
 	mmc_add_host(mmc);
 
 	return 0;
@@ -1364,6 +1370,12 @@ static int __devexit mmci_remove(struct amba_device *dev)
 	if (mmc) {
 		struct mmci_host *host = mmc_priv(mmc);
 
+		/*
+		 * Undo pm_runtime_put() in probe.  We use the _sync
+		 * version here so that we can access the primecell.
+		 */
+		pm_runtime_get_sync(&dev->dev);
+
 		mmc_remove_host(mmc);
 
 		writel(0, host->base + MMCIMASK0);
diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index eba88c7..9f1e927 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -515,9 +515,6 @@ static void giveback(struct pl022 *pl022)
 	if (msg->complete)
 		msg->complete(msg->context);
 	/* This message is completed, so let's turn off the clocks & power */
-	clk_disable(pl022->clk);
-	amba_pclk_disable(pl022->adev);
-	amba_vcore_disable(pl022->adev);
 	pm_runtime_put(&pl022->adev->dev);
 }
 
@@ -1545,9 +1542,6 @@ static void pump_messages(struct work_struct *work)
 	 * (poll/interrupt/DMA)
 	 */
 	pm_runtime_get_sync(&pl022->adev->dev);
-	amba_vcore_enable(pl022->adev);
-	amba_pclk_enable(pl022->adev);
-	clk_enable(pl022->clk);
 	restore_state(pl022);
 	flush(pl022);
 
@@ -2186,8 +2180,6 @@ pl022_probe(struct amba_device *adev, const struct amba_id *id)
 	}
 	printk(KERN_INFO "pl022: mapped registers from 0x%08x to %p\n",
 	       adev->res.start, pl022->virtbase);
-	pm_runtime_enable(dev);
-	pm_runtime_resume(dev);
 
 	pl022->clk = clk_get(&adev->dev, NULL);
 	if (IS_ERR(pl022->clk)) {
@@ -2195,7 +2187,6 @@ pl022_probe(struct amba_device *adev, const struct amba_id *id)
 		dev_err(&adev->dev, "could not retrieve SSP/SPI bus clock\n");
 		goto err_no_clk;
 	}
-
 	/* Disable SSP */
 	writew((readw(SSP_CR1(pl022->virtbase)) & (~SSP_CR1_MASK_SSE)),
 	       SSP_CR1(pl022->virtbase));
@@ -2235,12 +2226,9 @@ pl022_probe(struct amba_device *adev, const struct amba_id *id)
 		goto err_spi_register;
 	}
 	dev_dbg(dev, "probe succeeded\n");
-	/*
-	 * Disable the silicon block pclk and any voltage domain and just
-	 * power it up and clock it when it's needed
-	 */
-	amba_pclk_disable(adev);
-	amba_vcore_disable(adev);
+
+	/* let runtime pm put suspend */
+	pm_runtime_put(dev);
 	return 0;
 
  err_spi_register:
@@ -2249,7 +2237,6 @@ pl022_probe(struct amba_device *adev, const struct amba_id *id)
 	destroy_queue(pl022);
 	pl022_dma_remove(pl022);
 	free_irq(adev->irq[0], pl022);
-	pm_runtime_disable(&adev->dev);
  err_no_irq:
 	clk_put(pl022->clk);
  err_no_clk:
@@ -2271,6 +2258,12 @@ pl022_remove(struct amba_device *adev)
 	if (!pl022)
 		return 0;
 
+	/*
+	 * undo pm_runtime_put() in probe.  I assume that we're not
+	 * accessing the primecell here.
+	 */
+	pm_runtime_get_noresume(&adev->dev);
+
 	/* Remove the queue */
 	status = destroy_queue(pl022);
 	if (status != 0) {
@@ -2293,10 +2286,10 @@ pl022_remove(struct amba_device *adev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int pl022_suspend(struct amba_device *adev, pm_message_t state)
+#ifdef CONFIG_SUSPEND
+static int pl011_suspend(struct device *dev)
 {
-	struct pl022 *pl022 = amba_get_drvdata(adev);
+	struct pl022 *pl022 = dev_get_drvdata(dev);
 	int status = 0;
 
 	status = stop_queue(pl022);
@@ -2305,34 +2298,58 @@ static int pl022_suspend(struct amba_device *adev, pm_message_t state)
 		return status;
 	}
 
-	amba_vcore_enable(adev);
-	amba_pclk_enable(adev);
+	amba_vcore_enable(pl022->adev);
+	amba_pclk_enable(pl022->adev);
 	load_ssp_default_config(pl022);
-	amba_pclk_disable(adev);
-	amba_vcore_disable(adev);
+	amba_pclk_disable(pl022->adev);
+	amba_vcore_disable(pl022->adev);
 	dev_dbg(&adev->dev, "suspended\n");
 	return 0;
 }
 
-static int pl022_resume(struct amba_device *adev)
+static int pl022_resume(struct device *dev)
 {
-	struct pl022 *pl022 = amba_get_drvdata(adev);
+	struct pl022 *pl022 = dev_get_drvdata(dev);
 	int status = 0;
 
 	/* Start the queue running */
 	status = start_queue(pl022);
 	if (status)
-		dev_err(&adev->dev, "problem starting queue (%d)\n", status);
+		dev_err(dev, "problem starting queue (%d)\n", status);
 	else
-		dev_dbg(&adev->dev, "resumed\n");
+		dev_dbg(dev, "resumed\n");
 
 	return status;
 }
-#else
-#define pl022_suspend NULL
-#define pl022_resume NULL
 #endif	/* CONFIG_PM */
 
+#ifdef CONFIG_PM_RUNTIME
+static int pl022_runtime_suspend(struct device *dev)
+{
+	struct pl022 *pl022 = dev_get_drvdata(dev);
+
+	clk_disable(pl022->clk);
+	amba_vcore_disable(pl022->adev);
+
+	return 0;
+}
+
+static int pl022_runtime_resume(struct device *dev)
+{
+	struct pl022 *pl022 = dev_get_drvdata(dev);
+
+	amba_vcore_enable(pl022->adev);
+	clk_enable(pl022->clk);
+
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops pl022_dev_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(pl022_suspend, pl022_resume)
+	SET_RUNTIME_PM_OPS(pl022_runtime_suspend, pl022_runtime_resume, NULL)
+};
+
 static struct vendor_data vendor_arm = {
 	.fifodepth = 8,
 	.max_bpw = 16,
@@ -2412,12 +2429,11 @@ static struct amba_id pl022_ids[] = {
 static struct amba_driver pl022_driver = {
 	.drv = {
 		.name	= "ssp-pl022",
+		.pm	= &pl022_dev_pm_ops,
 	},
 	.id_table	= pl022_ids,
 	.probe		= pl022_probe,
 	.remove		= __devexit_p(pl022_remove),
-	.suspend        = pl022_suspend,
-	.resume         = pl022_resume,
 };
 
 
