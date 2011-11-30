Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab1K3WOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 17:14:11 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3092 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1K3WOJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 17:14:09 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 30 Nov 2011 14:14:05 -0800
From: Rakesh Iyer <riyer@nvidia.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
CC: "rydberg@euromail.se" <rydberg@euromail.se>,
        Stephen Warren <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Wed, 30 Nov 2011 14:14:03 -0800
Subject: RE: [PATCH v1] Input: tegra-kbc - report wakeup key for some
 platforms.
Thread-Topic: [PATCH v1] Input: tegra-kbc - report wakeup key for some
 platforms.
Thread-Index: AcyvpeoNaaJJqDsVQeKW6fjpKwLw1QABupQw
Message-ID: <1FC56210173BB445BD77F608D6FB8D034F3D1BB4BD@HQMAIL03.nvidia.com>
References: <1322685811-14060-1-git-send-email-riyer@nvidia.com>
 <20111130212022.GB3108@core.coreip.homeip.net>
In-Reply-To: <20111130212022.GB3108@core.coreip.homeip.net>
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

Thanks Dmitry.

Since there can be multiple wake causes I wanted to isolate wake key generation to the case where keyboard actually generated the wake interrupt.
If the system was woken by some other source and keypress occurs before resume is invoked we will pass on an unintended wake key.

Leaving the disable_irq as is,  can I can enable the interrupts at the end of the suspend routine?

Note with the FIFO interrupt disabled, there will be no interrupt after that point from the device unless it's a Wake interrupt.

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Wednesday, November 30, 2011 1:20 PM
> To: Rakesh Iyer
> Cc: rydberg@euromail.se; Stephen Warren; Laxman Dewangan; linux-
> kernel@vger.kernel.org; linux-input@vger.kernel.org; linux-tegra@vger.kernel.org
> Subject: Re: [PATCH v1] Input: tegra-kbc - report wakeup key for some platforms.
> 
> Hi Rakesh,
> 
> On Wed, Nov 30, 2011 at 12:43:31PM -0800, riyer@nvidia.com wrote:
> > From: Rakesh Iyer <riyer@nvidia.com>
> >
> > Tegra kbc cannot detect exact keypress causing wakeup in interrupt mode.
> > Allow wakeup keypress to be reported for certain platforms.
> >
> > Signed-off-by: Rakesh Iyer <riyer@nvidia.com>
> > ---
> >  arch/arm/mach-tegra/include/mach/kbc.h |    1 +
> >  drivers/input/keyboard/tegra-kbc.c     |   20 ++++++++++++++++----
> >  2 files changed, 17 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/arm/mach-tegra/include/mach/kbc.h b/arch/arm/mach-
> tegra/include/mach/kbc.h
> > index 4f3572a..20bb054 100644
> > --- a/arch/arm/mach-tegra/include/mach/kbc.h
> > +++ b/arch/arm/mach-tegra/include/mach/kbc.h
> > @@ -53,6 +53,7 @@ struct tegra_kbc_platform_data {
> >  	struct tegra_kbc_pin_cfg pin_cfg[KBC_MAX_GPIO];
> >  	const struct matrix_keymap_data *keymap_data;
> >
> > +	u32 wakeup_key;
> >  	bool wakeup;
> >  	bool use_fn_map;
> >  	bool use_ghost_filter;
> > diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
> > index cf3228b..ceb1185 100644
> > --- a/drivers/input/keyboard/tegra-kbc.c
> > +++ b/drivers/input/keyboard/tegra-kbc.c
> > @@ -52,6 +52,7 @@
> >  /* KBC Interrupt Register */
> >  #define KBC_INT_0	0x4
> >  #define KBC_INT_FIFO_CNT_INT_STATUS	(1 << 2)
> > +#define KBC_INT_KEYPRESS_INT_STATUS	(1 << 0)
> >
> >  #define KBC_ROW_CFG0_0	0x8
> >  #define KBC_COL_CFG0_0	0x18
> > @@ -74,10 +75,12 @@ struct tegra_kbc {
> >  	unsigned int cp_to_wkup_dly;
> >  	bool use_fn_map;
> >  	bool use_ghost_filter;
> > +	bool keypress_caused_wake;
> >  	const struct tegra_kbc_platform_data *pdata;
> >  	unsigned short keycode[KBC_MAX_KEY * 2];
> >  	unsigned short current_keys[KBC_MAX_KPENT];
> >  	unsigned int num_pressed_keys;
> > +	u32 wakeup_key;
> >  	struct timer_list timer;
> >  	struct clk *clk;
> >  };
> > @@ -409,6 +412,9 @@ static irqreturn_t tegra_kbc_isr(int irq, void *args)
> >  		 */
> >  		tegra_kbc_set_fifo_interrupt(kbc, false);
> >  		mod_timer(&kbc->timer, jiffies + kbc->cp_dly_jiffies);
> > +	} else if (val & KBC_INT_KEYPRESS_INT_STATUS) {
> > +		/* We can be here only through system resume path */
> > +		kbc->keypress_caused_wake = true;
> >  	}
> >
> >  	spin_unlock_irqrestore(&kbc->lock, flags);
> > @@ -674,9 +680,10 @@ static int __devinit tegra_kbc_probe(struct platform_device
> *pdev)
> >  	keymap_data = pdata->keymap_data ?: &tegra_kbc_default_keymap_data;
> >  	matrix_keypad_build_keymap(keymap_data, KBC_ROW_SHIFT,
> >  				   input_dev->keycode, input_dev->keybit);
> > +	kbc->wakeup_key = pdata->wakeup_key;
> >
> > -	err = request_irq(kbc->irq, tegra_kbc_isr, IRQF_TRIGGER_HIGH,
> > -			  pdev->name, kbc);
> > +	err = request_irq(kbc->irq, tegra_kbc_isr,
> > +			  IRQF_NO_SUSPEND | IRQF_TRIGGER_HIGH, pdev->name,
> kbc);
> >  	if (err) {
> >  		dev_err(&pdev->dev, "failed to request keyboard IRQ\n");
> >  		goto err_put_clk;
> > @@ -738,7 +745,6 @@ static int tegra_kbc_suspend(struct device *dev)
> >
> >  	mutex_lock(&kbc->idev->mutex);
> >  	if (device_may_wakeup(&pdev->dev)) {
> > -		disable_irq(kbc->irq);
> >  		del_timer_sync(&kbc->timer);
> >  		tegra_kbc_set_fifo_interrupt(kbc, false);
> 
> This disturbs locking rules and allows timer to run past this point.
> Instead of keeping interrupt enabled can't you simply read controller
> state in tegra_kbc_resume (before enabling interrupt) and emit the
> keycode if you detect KBC_INT_KEYPRESS_INT_STATUS condition?
> 
> Thanks.
> 
> --
> Dmitry
