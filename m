Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab2JVGGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 02:06:52 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:40850 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754883Ab2JVGGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 02:06:51 -0400
Date: Mon, 22 Oct 2012 11:36:41 +0530
From: Shiraz Hashim <shiraz.hashim@st.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: <thierry.reding@avionic-design.de>, <linux-kernel@vger.kernel.org>,
        <spear-devel@list.st.com>
Subject: Re: [PATCH V3] PWM: Add SPEAr PWM chip driver support
Message-ID: <20121022060641.GB3900@localhost.localdomain>
References: <1350877903-8578-1-git-send-email-shiraz.hashim@st.com>
 <CAOh2x=mNWNtwcWB3a=mCsfwC8WqXiisW8zeg9amsXy7b2nLCkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAOh2x=mNWNtwcWB3a=mCsfwC8WqXiisW8zeg9amsXy7b2nLCkA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Mon, Oct 22, 2012 at 09:39:21AM +0530, viresh kumar wrote:
> Every time you read a code, you figure out new things about it.
> Sorry for these comments Now :(

No problem, it is important to fix now than catch them later.

> On Mon, Oct 22, 2012 at 9:21 AM, Shiraz Hashim <shiraz.hashim@st.com> wrote:
> > diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> > index acfe482..6512786 100644
> > --- a/drivers/pwm/Makefile
> > +++ b/drivers/pwm/Makefile
> > @@ -9,6 +9,7 @@ obj-$(CONFIG_PWM_PUV3)          += pwm-puv3.o
> >  obj-$(CONFIG_PWM_PXA)          += pwm-pxa.o
> >  obj-$(CONFIG_PWM_SAMSUNG)      += pwm-samsung.o
> >  obj-$(CONFIG_PWM_TEGRA)                += pwm-tegra.o
> > +obj-$(CONFIG_PWM_SPEAR)                += pwm-spear.o
> 
> I have gone through this on every version of this patch, but couldn't figure
> out that you were trying to add it in alphabetical order, but you couldn't.
> 

Would fix this.

> > diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
> 
> > +static int spear_pwm_probe(struct platform_device *pdev)
> > +{
> > +       pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
> > +       if (!pc) {
> > +               dev_err(&pdev->dev, "failed to allocate memory\n");
> > +               return -ENOMEM;
> > +       }
> > +
> > +       pc->dev = &pdev->dev;
> 
> If you are going to send another version, then please move this
> 
> > +       pc->mmio_base = devm_request_and_ioremap(&pdev->dev, r);
> > +       if (!pc->mmio_base)
> > +               return -EADDRNOTAVAIL;
> > +
> > +       platform_set_drvdata(pdev, pc);
> 
> and this
> 
> > +       pc->clk = devm_clk_get(&pdev->dev, NULL);
> > +       if (IS_ERR(pc->clk))
> > +               return PTR_ERR(pc->clk);
> 
> to this place :)
> So, that we don't do these for failure cases.
> 

Okay.

> > +       pc->chip.dev = &pdev->dev;
> > +       pc->chip.ops = &spear_pwm_ops;
> > +       pc->chip.base = -1;
> > +       pc->chip.npwm = NUM_PWM;
> > +
> 
> > +       if (np && of_device_is_compatible(np, "st,spear1340-pwm")) {
> 
> I have noticed it earlier, but don't know why didn't i gave a comment here?
> you don't need to check for np here. It can't be NULL as you depend on
> CONFIG_OF.

Okay, would remove this.

> > +               /*
> > +                * Following enables PWM chip, channels would still be
> > +                * enabled individually through their control register
> > +                */
> > +               val = readl_relaxed(pc->mmio_base + PWMMCR);
> > +               val |= PWMMCR_PWM_ENABLE;
> > +               writel_relaxed(val, pc->mmio_base + PWMMCR);
> > +
> > +       }
> > +
> > +       /* only disable the clk and leave it prepared */
> > +       clk_disable(pc->clk);
> > +
> > +       return 0;
> > +}
> > +
> > +static int spear_pwm_remove(struct platform_device *pdev)
> > +{
> > +       struct spear_pwm_chip *pc = platform_get_drvdata(pdev);
> > +       int i;
> > +
> > +       for (i = 0; i < NUM_PWM; i++) {
> > +               struct pwm_device *pwm = &pc->chip.pwms[i];
> > +
> > +               if (test_bit(PWMF_ENABLED, &pwm->flags)) {
> > +                       spear_pwm_writel(pc, i, PWMCR, 0);
> > +                       clk_disable(pc->clk);
> > +               }
> > +       }
> > +
> > +       /* clk was prepared in probe, hence unprepare it here */
> > +       clk_unprepare(pc->clk);
> 
> I believe you need to remove the chip first and then do above to
> avoid any race conditions, that might occur.
> 

I am afraid, I would loose all chips and their related information
(PWMF_ENABLED) then.

> > +       return pwmchip_remove(&pc->chip);
> > +}
> > +
> 
> After all this please add my:
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

I had already added your sob as you were the original author,
should I add a separate acked-by also ?

> Sorry Shiraz for so late comments, i can understand your
> frustration :(

No issues, review is higienic :)

--
regards
Shiraz
