Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab2DNMgH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 08:36:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53174 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2DNMgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 08:36:05 -0400
Date: Sat, 14 Apr 2012 14:35:59 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: rtc-linux@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Anish Trivedi <anish@freescale.com>,
        Eric Miao <eric.miao@linaro.org>, Anson Huang <b20788@freescale.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v2] rtc: add support for Freescale SNVS RTC
Message-ID: <20120414123559.GU3852@pengutronix.de>
References: <1334387237-23519-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334387237-23519-1-git-send-email-paul.liu@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:03:27 up 153 days, 19:50, 16 users,  load average: 0.01, 0.02,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 03:07:17PM +0800, Ying-Chun Liu (PaulLiu) wrote:
> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
> 
> This adds an RTC driver for the Low Power (LP) section of SNVS.
> It hooks into the /dev/rtc interface and supports ioctl to complete RTC
> features. This driver supports device tree bindings.
> It only uses the RTC hw in non-secure mode.
> 
> Signed-off-by: Anish Trivedi <anish@freescale.com>
> Signed-off-by: Eric Miao <eric.miao@linaro.org>
> Signed-off-by: Anson Huang <b20788@freescale.com>
> Signed-off-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  Documentation/devicetree/bindings/rtc/snvs-rtc.txt |   18 +
>  drivers/rtc/Kconfig                                |   10 +
>  drivers/rtc/Makefile                               |    1 +
>  drivers/rtc/rtc-snvs.c                             |  644 ++++++++++++++++++++
>  4 files changed, 673 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rtc/snvs-rtc.txt
>  create mode 100644 drivers/rtc/rtc-snvs.c
> 
> +#define CNTR_TO_SECS_SH 15	/* Converts 47-bit counter to 32-bit seconds */
> +
> +struct rtc_drv_data {
> +	struct rtc_device *rtc;
> +	void __iomem *ioaddr;
> +	int irq;
> +	bool irq_enable;
> +};
> +
> +static DEFINE_SPINLOCK(rtc_lock);

Put this three lines above.

> +	writel(time >> (32 - CNTR_TO_SECS_SH), ioaddr + SNVS_LPSRTCMR);
> +
> +	/* Enable RTC again */
> +	writel(lp_cr | SNVS_LPCR_SRTC_ENV, ioaddr + SNVS_LPCR);
> +	timeout = jiffies + msecs_to_jiffies(3000);
> +	while (!(readl(ioaddr + SNVS_LPCR) & SNVS_LPCR_SRTC_ENV)) {
> +		if (time_after(jiffies, timeout)) {
> +			dev_err(dev, "timeout on enabling RTC back\n");
> +			return -EBUSY;
> +		}
> +	}
> +
> +	rtc_write_sync_lp(ioaddr);
> +
> +	new_time_47bit = (((u64) (readl(ioaddr + SNVS_LPSRTCMR) &
> +		((0x1 << CNTR_TO_SECS_SH) - 1)) << 32) |
> +		((u64) readl(ioaddr + SNVS_LPSRTCLR)));
> +
> +	time_diff = new_time_47bit - old_time_47bit;

time_diff, old_time_47bit and new_time_47bit are set and never read.
Remove.

> +
> +	return 0;
> +}
> +
> +static int snvs_rtc_proc(struct device *dev, struct seq_file *seq)
> +{
> +	struct rtc_drv_data *pdata = dev_get_drvdata(dev);
> +	void __iomem *ioaddr = pdata->ioaddr;
> +
> +	seq_printf(seq, "alarm_IRQ\t: %s\n",
> +		   (((readl(ioaddr + SNVS_LPCR)) & SNVS_LPCR_LPTA_EN) !=
> +		    0) ? "yes" : "no");
> +
> +	return 0;
> +}
> +
> +static int snvs_rtc_alarm_irq_enable(struct device *dev, unsigned int enable)
> +{
> +	struct rtc_drv_data *pdata = dev_get_drvdata(dev);
> +	void __iomem *ioaddr = pdata->ioaddr;
> +	u32 lp_cr;
> +	unsigned long lock_flags = 0;
> +
> +	spin_lock_irqsave(&rtc_lock, lock_flags);
> +
> +	if (enable) {
> +		if (!pdata->irq_enable) {
> +			enable_irq(pdata->irq);
> +			pdata->irq_enable = true;
> +		}

Why this enable_irq/disable_irq everywhere? You seem to have irq enable
bits in your registers which should be enough.

> +/* SNVS RTC Power management control */
> +static int __devinit snvs_rtc_probe(struct platform_device *pdev)
> +{
> +	struct timespec tv;
> +	struct rtc_device *rtc;
> +	struct rtc_drv_data *pdata = NULL;

No need to initialize this. I think you should use another name for this
variable. People usually expect pdata for platform_data. Driver data is
usually called priv, or snvs_rtc in this case.


> +	void __iomem *ioaddr;
> +	u32 lp_cr;
> +	int ret = 0;

No need to initialize this.

> +
> +	ioaddr = of_iomap(pdev->dev.of_node, 0);
> +	if (!ioaddr)
> +		return -EADDRNOTAVAIL;
> +
> +	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		return -ENOMEM;
> +
> +	pdata->ioaddr = ioaddr;
> +
> +	/* Configure and enable the RTC */
> +	pdata->irq = platform_get_irq(pdev, 0);
> +	if (pdata->irq >= 0) {

Is there any hardware without an interrupt? If no, just bail out here
and get rid of the additional complexity.

> +		if (request_irq(pdata->irq, snvs_rtc_interrupt, IRQF_SHARED,
> +				pdev->name, pdev) < 0) {
> +			dev_warn(&pdev->dev, "interrupt not available.\n");
> +			pdata->irq = -1;
> +		} else {
> +			disable_irq(pdata->irq);
> +			pdata->irq_enable = false;
> +		}
> +	}
> +
> +	/* initialize glitch detect */
> +	writel(SNVS_LPPGDR_INIT, ioaddr + SNVS_LPPGDR);
> +	udelay(100);
> +
> +	/* clear lp interrupt status */
> +	writel(0xFFFFFFFF, ioaddr + SNVS_LPSR);
> +
> +	/* Enable RTC */
> +	lp_cr = readl(ioaddr + SNVS_LPCR);
> +	if ((lp_cr & SNVS_LPCR_SRTC_ENV) == 0)
> +		writel(lp_cr | SNVS_LPCR_SRTC_ENV, ioaddr + SNVS_LPCR);
> +	udelay(100);
> +
> +	writel(0xFFFFFFFF, ioaddr + SNVS_LPSR);
> +	udelay(100);
> +
> +	platform_set_drvdata(pdev, pdata);
> +
> +	rtc = rtc_device_register(pdev->name, &pdev->dev,
> +				  &snvs_rtc_ops, THIS_MODULE);
> +	if (IS_ERR(rtc)) {
> +		ret = PTR_ERR(rtc);
> +		goto err_out;
> +	}
> +
> +	pdata->rtc = rtc;
> +
> +	tv.tv_nsec = 0;
> +	tv.tv_sec = rtc_read_lp_counter(ioaddr);
> +
> +	/* By default, devices should wakeup if they can */
> +	/* So snvs is set as "should wakeup" as it can */
> +	device_init_wakeup(&pdev->dev, 1);
> +
> +	return ret;

return 0 here instead to make it clear that this is the success path.

> +
> +err_out:
> +	iounmap(ioaddr);
> +	if (pdata->irq >= 0)
> +		free_irq(pdata->irq, pdev);
> +
> +	return ret;
> +}
> +
> +static int __devexit snvs_rtc_remove(struct platform_device *pdev)
> +{
> +	struct rtc_drv_data *pdata = platform_get_drvdata(pdev);
> +	rtc_device_unregister(pdata->rtc);
> +	if (pdata->irq >= 0)
> +		free_irq(pdata->irq, pdev);
> +	iounmap(pdata->ioaddr);
> +
> +	return 0;
> +}
> +

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
