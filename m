Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0JUXiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 19:38:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023Ab0JUXh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 19:37:59 -0400
Date: Thu, 21 Oct 2010 16:37:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: achew@nvidia.com
Cc: jmayo@nvidia.com, a.zummo@towertech.it, olof@lixom.net, greg@kroah.com,
        mcuos.com@gmail.com, konkers@google.com, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, rtc-linux@googlegroups.com
Subject: Re: [PATCH 1/1 V4] rtc: Add real-time clock driver for Tegra.
Message-Id: <20101021163713.a857fdd0.akpm@linux-foundation.org>
In-Reply-To: <1287444796-27008-1-git-send-email-achew@nvidia.com>
References: <1287444796-27008-1-git-send-email-achew@nvidia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 16:33:16 -0700
achew@nvidia.com wrote:

> From: Andrew Chew <achew@nvidia.com>
> 
> This is a platform driver that supports the built-in real-time clock on
> Tegra SOCs.
> 
>
> ...
>
> +static int tegra_rtc_wait_while_busy(struct device *dev)
> +{
> +	struct tegra_rtc_info *info = dev_get_drvdata(dev);
> +
> +	int retries = 500; /* ~490 us is the worst case, ~250 us is best. */
> +
> +	/* first wait for the RTC to become busy. this is when it
> +	 * posts its updated seconds+msec registers to AHB side. */
> +	while (tegra_rtc_check_busy(info)) {
> +		if (!retries--)
> +			goto retry_failed;
> +		udelay(1);
> +	}
> +
> +	/* now we have about 250 us to manipulate registers */
> +	return 0;
> +
> +retry_failed:
> +	dev_err(dev, "write failed:retry count exceeded.\n");
> +	return -ETIMEDOUT;

Grumble.  Pet peeve.

ETIMEDOUT is a networking error.  "Connection attempt timed out".  If
this errno gets sent back to userspace from an operation against the
RTC hardware then the user would be fully entitied to ask WTF?  and
wonder what we had been smoking.

Also, most callers of tegra_rtc_wait_while_busy() simply ignore this
error and proceed pretending that it didn't happen.

> +}
> +
>
> ...
>
> +static int tegra_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
> +{
> +	struct tegra_rtc_info *info = dev_get_drvdata(dev);
> +	unsigned status;
> +	unsigned long sl_irq_flags;

Plain old "flags" is idiomatic, and sufficient.

> +	tegra_rtc_wait_while_busy(dev);
> +	spin_lock_irqsave(&info->tegra_rtc_lock, sl_irq_flags);
> +
> +	/* read the original value, and OR in the flag. */
> +	status = readl(info->rtc_base + TEGRA_RTC_REG_INTR_MASK);
> +	if (enabled)
> +		status |= TEGRA_RTC_INTR_MASK_SEC_ALARM0; /* set it */
> +	else
> +		status &= ~TEGRA_RTC_INTR_MASK_SEC_ALARM0; /* clear it */
> +
> +	writel(status, info->rtc_base + TEGRA_RTC_REG_INTR_MASK);
> +
> +	spin_unlock_irqrestore(&info->tegra_rtc_lock, sl_irq_flags);
> +
> +	return 0;
> +}
> +
>
> ...
>
> +static int tegra_rtc_proc(struct device *dev, struct seq_file *seq)
> +{
> +	if (!dev || !dev->driver)
> +		return 0;
> +
> +	return seq_printf(seq, "name\t\t: %s\n", dev_name(dev));
> +}

hm, what does the rtc_class_ops.proc() handler do?  There seems to be
no consistency between different drivers which somewhat defeats the
purpose of having a standardised RTC framework.

> +static irqreturn_t tegra_rtc_irq_handler(int irq, void *data)
> +{
> +	struct device *dev = data;
> +	struct tegra_rtc_info *info = dev_get_drvdata(dev);
> +	unsigned long events = 0;
> +	unsigned status;
> +	unsigned long sl_irq_flags;
> +
> +	status = readl(info->rtc_base + TEGRA_RTC_REG_INTR_STATUS);
> +	if (status) {
> +		/* clear the interrupt masks and status on any irq. */
> +		tegra_rtc_wait_while_busy(dev);
> +		spin_lock_irqsave(&info->tegra_rtc_lock, sl_irq_flags);
> +		writel(0, info->rtc_base + TEGRA_RTC_REG_INTR_MASK);
> +		writel(status, info->rtc_base + TEGRA_RTC_REG_INTR_STATUS);
> +		spin_unlock_irqrestore(&info->tegra_rtc_lock, sl_irq_flags);
> +	}
> +
> +	/* check if Alarm */
> +	if ((status & TEGRA_RTC_INTR_STATUS_SEC_ALARM0))
> +		events |= RTC_IRQF | RTC_AF;
> +
> +	/* check if Periodic */
> +	if ((status & TEGRA_RTC_INTR_STATUS_SEC_CDN_ALARM))
> +		events |= RTC_IRQF | RTC_PF;
> +
> +	rtc_update_irq(info->rtc_dev, 1, events);
> +
> +	return IRQ_HANDLED;
> +}

This will return IRQ_HANDLED even if no interrupts were pending. 
That's a bug if the IRQ is shared, and defeats the kernel's "screaming
interrupt" detection logic.  Probably it's OK in the context of this
device, but it does set a poor example for the kiddies.

>
> ...
>
> +#ifdef CONFIG_PM
> +static int tegra_rtc_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct tegra_rtc_info *info = platform_get_drvdata(pdev);
> +
> +	tegra_rtc_wait_while_busy(dev);
> +
> +	/* only use ALARM0 as a wake source. */
> +	writel(0xffffffff, info->rtc_base + TEGRA_RTC_REG_INTR_STATUS);
> +	writel(TEGRA_RTC_INTR_STATUS_SEC_ALARM0,
> +		info->rtc_base + TEGRA_RTC_REG_INTR_MASK);
> +
> +	dev_vdbg(dev, "alarm sec = %d\n",
> +		readl(info->rtc_base + TEGRA_RTC_REG_SECONDS_ALARM0));
> +
> +	dev_vdbg(dev, "Suspend (device_may_wakeup=%d) irq:%d\n",
> +		device_may_wakeup(dev), info->tegra_rtc_irq);
> +
> +	/* leave the alarms on as a wake source. */
> +	if (device_may_wakeup(dev))
> +		enable_irq_wake(info->tegra_rtc_irq);
> +
> +	return 0;
> +}
> +
> +static int tegra_rtc_resume(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct tegra_rtc_info *info = platform_get_drvdata(pdev);
> +
> +	dev_vdbg(dev, "Resume (device_may_wakeup=%d)\n",
> +		device_may_wakeup(dev));
> +	/* alarms were left on as a wake source, turn them off. */
> +	if (device_may_wakeup(dev))
> +		disable_irq_wake(info->tegra_rtc_irq);
> +
> +	return 0;
> +}
> +#endif

It's more typical to put

#else
#define tegra_rtc_suspend NULL
#define tegra_rtc_resume NULL
#endif

here

> +static void tegra_rtc_shutdown(struct platform_device *pdev)
> +{
> +	dev_vdbg(&pdev->dev, "disabling interrupts.\n");
> +	tegra_rtc_alarm_irq_enable(&pdev->dev, 0);
> +}
> +
> +MODULE_ALIAS("platform:tegra_rtc");
> +static struct platform_driver tegra_rtc_driver = {
> +	.remove		= __devexit_p(tegra_rtc_remove),
> +	.shutdown	= tegra_rtc_shutdown,
> +	.driver		= {
> +		.name	= "tegra_rtc",
> +		.owner	= THIS_MODULE,
> +	},
> +#ifdef CONFIG_PM
> +	.suspend	= tegra_rtc_suspend,
> +	.resume		= tegra_rtc_resume,
> +#endif

and to omit this ifdef.

> +};
> +
>
> ...
>

