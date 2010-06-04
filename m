Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab0FDVxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 17:53:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827Ab0FDVxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 17:53:19 -0400
Date: Fri, 4 Jun 2010 14:53:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Baruch Siach <baruch@tkos.co.il>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH] rtc: driver for the DryIce block found in i.MX25 chips
Message-Id: <20100604145304.b2cfca17.akpm@linux-foundation.org>
In-Reply-To: <0173f18c60cb4d1f8a0d123da6cd3cfca0224788.1275456869.git.baruch@tkos.co.il>
References: <0173f18c60cb4d1f8a0d123da6cd3cfca0224788.1275456869.git.baruch@tkos.co.il>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Jun 2010 08:37:21 +0300
Baruch Siach <baruch@tkos.co.il> wrote:

> This driver is based on code from Freescale which accompanies their i.MX25 PDK
> board, with some cleanup.

Do we know who at freescale worked on this?  Are there any signoffs or
attributions we could be adding?

>
> ...
>
> +static inline void di_int_enable(struct imxdi_dev *imxdi, u32 intr)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&imxdi->irq_lock, flags);
> +	__raw_writel(__raw_readl(imxdi->ioaddr + DIER) | intr,
> +			imxdi->ioaddr + DIER);
> +	spin_unlock_irqrestore(&imxdi->irq_lock, flags);
> +}
> +
> +/*
> + * disable a dryice interrupt
> + */
> +static inline void di_int_disable(struct imxdi_dev *imxdi, u32 intr)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&imxdi->irq_lock, flags);
> +	__raw_writel(__raw_readl(imxdi->ioaddr + DIER) & ~intr,
> +			imxdi->ioaddr + DIER);
> +	spin_unlock_irqrestore(&imxdi->irq_lock, flags);
> +}

You may find that you'll end up with a smaller and faster driver if
these are uninlined.

You may well find that gcc went and uninlined them anwyay.

> +/*
> + * This function attempts to clear the dryice write-error flag.
> + *
> + * A dryice write error is similar to a bus fault and should not occur in
> + * normal operation.  Clearing the flag requires another write, so the root
> + * cause of the problem may need to be fixed before the flag can be cleared.
> + */
> +static void clear_write_error(struct imxdi_dev *imxdi)
> +{
> +	int cnt;
> +
> +	dev_warn(&imxdi->pdev->dev, "WARNING: Register write error!\n");
> +
> +	for (;;) {
> +		/* clear the write error flag */
> +		__raw_writel(DSR_WEF, imxdi->ioaddr + DSR);
> +
> +		/* wait for it to take effect */
> +		for (cnt = 0; cnt < 100; cnt++) {
> +			if ((__raw_readl(imxdi->ioaddr + DSR) & DSR_WEF) == 0)
> +				return;
> +			udelay(10);
> +		}
> +		dev_err(&imxdi->pdev->dev,
> +			"ERROR: Cannot clear write-error flag!\n");
> +	}
> +}

The potential infinite loop is a worry.

> +/*
> + * Write a dryice register and wait until it completes.
> + *
> + * This function uses interrupts to determine when the
> + * write has completed.
> + */
> +static int di_write_wait(struct imxdi_dev *imxdi, u32 val, int reg)
> +{
> +	int ret;
> +	int rc = 0;
> +
> +	/* serialize register writes */
> +	mutex_lock(&imxdi->write_mutex);
> +
> +	/* enable the write-complete interrupt */
> +	di_int_enable(imxdi, DIER_WCIE);
> +
> +	imxdi->dsr = 0;
> +
> +	/* do the register write */
> +	__raw_writel(val, imxdi->ioaddr + reg);
> +
> +	/* wait for the write to finish */
> +	ret = wait_event_interruptible_timeout(imxdi->write_wait,
> +			imxdi->dsr & (DSR_WCF | DSR_WEF), msecs_to_jiffies(1));

This wait will terminate immediately if the calling task has
signal_pending().

> +	if (ret == 0)
> +		dev_warn(&imxdi->pdev->dev,
> +				"Write-wait timeout "
> +				"val = 0x%08x reg = 0x%08x\n", val, reg);

But the code incorrectly assumes that the hardware signalled readiness.

> +	/* check for write error */
> +	if (imxdi->dsr & DSR_WEF) {
> +		clear_write_error(imxdi);
> +		rc = -EIO;
> +	}
> +	mutex_unlock(&imxdi->write_mutex);
> +	return rc;
> +}
> +
>
> ...
>
> +static int __devexit dryice_rtc_remove(struct platform_device *pdev)
> +{
> +	struct imxdi_dev *imxdi = platform_get_drvdata(pdev);
> +
> +	flush_scheduled_work();

We only need to wait for imxdi->work to complete, so a simple
flush_work() would suffice here.

> +	/* mask all interrupts */
> +	__raw_writel(0, imxdi->ioaddr + DIER);
> +
> +	rtc_device_unregister(imxdi->rtc);
> +
> +	clk_disable(imxdi->clk);
> +	clk_put(imxdi->clk);
> +
> +	return 0;
> +}
>
> ...
>

