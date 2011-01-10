Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab1AJVOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:14:48 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5507 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab1AJVOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:14:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Mon, 10 Jan 2011 13:14:21 -0800
From: Rakesh Iyer <riyer@nvidia.com>
To: "'Trilok Soni'" <tsoni@codeaurora.org>
CC: "jj@chaosbits.net" <jj@chaosbits.net>,
        "shubhrajyoti@ti.com" <shubhrajyoti@ti.com>,
        "ccross@android.com" <ccross@android.com>,
        "konkers@android.com" <konkers@android.com>,
        "olof@lixom.net" <olof@lixom.net>, Andrew Chew <AChew@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Date: Mon, 10 Jan 2011 13:11:13 -0800
Subject: RE: [PATCH v3] input: tegra-kbc - Add tegra keyboard driver
Thread-Topic: [PATCH v3] input: tegra-kbc - Add tegra keyboard driver
Thread-Index: AcuxCHm5E8pgqJfZQH2gjtcwmCWq4QAAi3uQ
Message-ID: <1FC56210173BB445BD77F608D6FB8D03165A00805E@HQMAIL03.nvidia.com>
References: <1294422307-19107-1-git-send-email-riyer@nvidia.com>
 <4D2B71CB.1060004@codeaurora.org>
In-Reply-To: <4D2B71CB.1060004@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review.

A quick response regarding the following comment.

> 
> > +
> > +#include <linux/module.h>
> > +#include <linux/input.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/delay.h>
> > +#include <linux/io.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/clk.h>
> > +#include <linux/slab.h>
> > +#include <mach/clk.h>
> 
> You may not need this.
>

The mach/clk.h file contains declarations for tegra_periph_reset_assert and tegra_periph_reset_deassert which are needed.

Regards
Rakesh

> -----Original Message-----
> From: Trilok Soni [mailto:tsoni@codeaurora.org]
> Sent: Monday, January 10, 2011 12:54 PM
> To: Rakesh Iyer
> Cc: jj@chaosbits.net; shubhrajyoti@ti.com; ccross@android.com; konkers@android.com;
> olof@lixom.net; Andrew Chew; linux-tegra@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-input@vger.kernel.org
> Subject: Re: [PATCH v3] input: tegra-kbc - Add tegra keyboard driver
> 
> Hi Rakesh,
> 
> On 1/7/2011 11:15 PM, riyer@nvidia.com wrote:
> > From: Rakesh Iyer <riyer@nvidia.com>
> >
> > This patch adds support for the internal matrix keyboard controller for
> > Nvidia Tegra platforms.
> >
> > Signed-off-by: Rakesh Iyer <riyer@nvidia.com>
> > ---
> > Removed NULL check before input_free_device as suggested by Jesper Juhl.
> 
> Sorry for the delay. Few comments.
> 
> > +
> > +#include <linux/module.h>
> > +#include <linux/input.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/delay.h>
> > +#include <linux/io.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/clk.h>
> > +#include <linux/slab.h>
> > +#include <mach/clk.h>
> 
> You may not need this.
> 
> >
> > +
> > +static void tegra_kbc_keypress_timer(unsigned long data)
> > +{
> > +	struct tegra_kbc *kbc = (struct tegra_kbc *)data;
> > +	unsigned long flags;
> > +	u32 val;
> > +	int i;
> > +
> 
> ...
> 
> > +	}
> > +	return;
> 
> No need.
> 
> > +}
> > +
> > +
> > +
> > +
> > +static int tegra_kbc_open(struct input_dev *dev)
> > +{
> > +	struct tegra_kbc *kbc = input_get_drvdata(dev);
> > +	unsigned long flags;
> > +	unsigned int debounce_cnt;
> > +	u32 val = 0;
> > +
> > +	clk_enable(kbc->clk);
> > +
> > +	/* Reset the KBC controller to clear all previous status.*/
> > +	tegra_periph_reset_assert(kbc->clk);
> > +	udelay(100);
> > +	tegra_periph_reset_deassert(kbc->clk);
> > +	udelay(100);
> > +
> > +	tegra_kbc_config_pins(kbc);
> > +	tegra_kbc_setup_wakekeys(kbc, false);
> > +
> > +	writel(kbc->pdata->repeat_cnt, kbc->mmio + KBC_RPT_DLY_0);
> > +
> > +	debounce_cnt = min_t(unsigned int, kbc->pdata->debounce_cnt, 0x3fful);
> > +	val = debounce_cnt << 4;
> > +	val |= 1<<14; /* fifo interrupt threshold = 1 entry */
> > +	val |= 1<<3;  /* interrupt on FIFO threshold reached */
> 
> As mentioned below, try to get driver out of these magic nos.
> 
> > +	val |= 1;     /* enable */
> > +	writel(val, kbc->mmio + KBC_CONTROL_0);
> > +
> > +	/* Compute the delay(ns) from interrupt mode to continuous polling mode
> > +	 * so the timer routine is scheduled appropriately. */
> > +	val = readl(kbc->mmio + KBC_INIT_DLY_0);
> > +	kbc->cp_dly_jiffies = usecs_to_jiffies((val & 0xfffff) * 32);
> > +
> > +	/* atomically clear out any remaining entries in the key FIFO
> > +	 * and enable keyboard interrupts */
> > +	spin_lock_irqsave(&kbc->lock, flags);
> > +	while (1) {
> > +		val = readl(kbc->mmio + KBC_INT_0);
> > +		val >>= 4;
> > +		if (val) {
> > +			val = readl(kbc->mmio + KBC_KP_ENT0_0);
> > +			val = readl(kbc->mmio + KBC_KP_ENT1_0);
> > +		} else {
> > +			break;
> > +		}
> > +	}
> > +	writel(0x7, kbc->mmio + KBC_INT_0);
> > +	spin_unlock_irqrestore(&kbc->lock, flags);
> > +
> > +	return 0;
> > +}
> > +
> > +
> 
> > +
> > +static irqreturn_t tegra_kbc_isr(int irq, void *args)
> > +{
> > +	struct tegra_kbc *kbc = args;
> > +	u32 val, ctl;
> > +
> > +	/* until all keys are released, defer further processing to
> > +	 * the polling loop in tegra_kbc_keypress_timer */
> > +	ctl = readl(kbc->mmio + KBC_CONTROL_0);
> > +	ctl &= ~(1<<3);
> 
> No magic nos. please. Add relevant #defines for it.
> 
> > +	writel(ctl, kbc->mmio + KBC_CONTROL_0);
> > +
> > +	/* quickly bail out & reenable interrupts if the interrupt source
> > +	 * wasn't fifo count threshold */
> 
> "wasn't equal to fifo count threshold" ?
> 
> > +	val = readl(kbc->mmio + KBC_INT_0);
> > +	writel(val, kbc->mmio + KBC_INT_0);
> > +
> > +	if (!(val & (1<<2))) {
> > +		ctl |= 1<<3;
> 
> As mentioned above, no magic nos. please.
> 
> > +		writel(ctl, kbc->mmio + KBC_CONTROL_0);
> > +		return IRQ_HANDLED;
> > +	}
> > +
> > +	/* Schedule timer to run when hardware is in continuous polling mode. */
> > +	mod_timer(&kbc->timer, jiffies + kbc->cp_dly_jiffies);
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static int __devinit tegra_kbc_probe(struct platform_device *pdev)
> > +{
> > +	struct tegra_kbc *kbc;
> > +	const struct tegra_kbc_platform_data *pdata = pdev->dev.platform_data;
> > +	struct resource *res;
> > +	int irq;
> > +	int err;
> > +	int rows[KBC_MAX_ROW];
> > +	int cols[KBC_MAX_COL];
> > +	int i, j;
> > +	int nr = 0;
> > +	unsigned int debounce_cnt;
> > +
> > +	if (!pdata)
> > +		return -EINVAL;
> > +
> > +	kbc = kzalloc(sizeof(*kbc), GFP_KERNEL);
> > +	if (!kbc)
> > +		return -ENOMEM;
> > +
> > +	kbc->pdata = pdata;
> > +	kbc->irq = -EINVAL;
> 
> You don't need such assignments for irq.
> 
> > +
> > +	memset(rows, 0, sizeof(rows));
> > +	memset(cols, 0, sizeof(cols));
> > +
> > +	kbc->idev = input_allocate_device();
> > +	if (!kbc->idev) {
> > +		err = -ENOMEM;
> > +		goto fail;
> > +	}
> > +
> > +	debounce_cnt = min_t(unsigned int, pdata->debounce_cnt, 0x3fful);
> > +	kbc->repoll_time = 5 + (16 + debounce_cnt) * nr + pdata->repeat_cnt;
> > +	kbc->repoll_time = (kbc->repoll_time + 31) / 32;
> 
> Care to add note on this equation? Lot's of magic nos. used in this, so they better
> get documented.
> 
> > +
> > +	kbc->idev->evbit[0] = BIT_MASK(EV_KEY);
> > +
> > +	/* Override the default keycodes with the board supplied ones. */
> > +	if (pdata->plain_keycode) {
> > +		kbc->plain_keycode = pdata->plain_keycode;
> > +		kbc->fn_keycode = pdata->fn_keycode;
> > +	} else {
> > +		kbc->plain_keycode = plain_kbd_keycode;
> > +		kbc->fn_keycode = fn_kbd_keycode;
> > +	}
> > +
> > +	for (i = 0; i < KBC_MAX_COL; i++) {
> > +		if (!cols[i])
> > +			continue;
> > +		for (j = 0; j < KBC_MAX_ROW; j++) {
> > +			int keycode;
> > +
> > +			if (!rows[j])
> > +				continue;
> > +
> > +			/* enable all the mapped keys. */
> > +			keycode = tegra_kbc_keycode(kbc, j, i, false);
> > +			if (keycode != -1)
> > +				set_bit(keycode, kbc->idev->keybit);
> > +
> > +			keycode = tegra_kbc_keycode(kbc, j, i, true);
> > +			if (keycode != -1)
> > +				set_bit(keycode, kbc->idev->keybit);
> > +		}
> > +	}
> > +
> > +	setup_timer(&kbc->timer, tegra_kbc_keypress_timer, (unsigned long)kbc);
> > +	/* Initialize the FIFO to invalid entries */
> > +	for (i = 0; i < ARRAY_SIZE(kbc->fifo); i++)
> > +		kbc->fifo[i] = -1;
> > +
> > +	/* keycode FIFO needs to be read atomically; leave local
> > +	 * interrupts disabled when handling KBC interrupt */
> > +	err = request_irq(irq, tegra_kbc_isr, IRQF_TRIGGER_HIGH,
> > +		pdev->name, kbc);
> > +	if (err) {
> > +		dev_err(&pdev->dev, "failed to request keypad IRQ\n");
> > +		goto fail;
> > +	}
> > +	kbc->irq = irq;
> > +
> > +	err = input_register_device(kbc->idev);
> > +	if (err) {
> > +		dev_err(&pdev->dev, "failed to register input device\n");
> > +		goto fail;
> > +	}
> > +
> > +	device_init_wakeup(&pdev->dev, pdata->wakeup);
> > +	return 0;
> > +
> > +fail:
> 
> It is better if you use multiple labels with differing names, as it will
> really improve your error patch and you don't need such if (...) checks against
> each of these resource release operations then. Please check other drivers..
> 
> > +	input_free_device(kbc->idev);
> > +	if (kbc->irq >= 0)
> > +		free_irq(kbc->irq, pdev);
> > +	if (kbc->clk)
> > +		clk_put(kbc->clk);
> > +	if (kbc->mmio)
> > +		iounmap(kbc->mmio);
> 
> 
> 
> > +	kfree(kbc);
> > +	return err;
> > +}
> > +
> > +#ifdef CONFIG_PM
> > +static int tegra_kbc_suspend(struct platform_device *pdev, pm_message_t state)
> > +{
> > +	struct tegra_kbc *kbc = platform_get_drvdata(pdev);
> > +
> > +	if (device_may_wakeup(&pdev->dev)) {
> > +		tegra_kbc_setup_wakekeys(kbc, true);
> > +		enable_irq_wake(kbc->irq);
> > +		/* Forcefully clear the interrupt status */
> > +		writel(0x7, kbc->mmio + KBC_INT_0);
> > +		msleep(30);
> > +	} else {
> > +		mutex_lock(&kbc->idev->mutex);
> > +		tegra_kbc_close(kbc->idev);
> 
> Only if there are any users. Please add that check.
> 
> > +		mutex_unlock(&kbc->idev->mutex);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int tegra_kbc_resume(struct platform_device *pdev)
> > +{
> > +	struct tegra_kbc *kbc = platform_get_drvdata(pdev);
> > +	int err = 0;
> > +
> > +	if (device_may_wakeup(&pdev->dev)) {
> > +		disable_irq_wake(kbc->irq);
> > +		tegra_kbc_setup_wakekeys(kbc, false);
> > +	} else if (kbc->idev->users) {
> > +		mutex_lock(&kbc->idev->mutex);
> > +		err = tegra_kbc_open(kbc->idev);
> 
> As mentioned above.
> 
> > +		mutex_unlock(&kbc->idev->mutex);
> > +	}
> > +
> > +	return err;
> > +}
> > +#endif
> > +
> 
> 
> --
> Sent by a consultant of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
