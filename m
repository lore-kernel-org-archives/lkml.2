Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab2FONGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 09:06:09 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:52168 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756840Ab2FONGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 09:06:06 -0400
Date: Fri, 15 Jun 2012 18:35:46 +0530
From: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: Fwd: [PATCH 1/3] i2c: Add Device Tree support to the Nomadik
 I2C driver
Message-ID: <20120615130544.GA28537@bnru02>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
 <1339428307-3850-10-git-send-email-lee.jones@linaro.org>
 <CACRpkdaMDbH4NkiHRLAfbJZ_j4QXbwg94bvaWsdYRPH+dSfc8Q@mail.gmail.com>
 <4FD8BAD2.50703@linaro.org>
 <CACRpkdZFi34nChnMEo6yik67zk9owZLk-6zcdP7mmOXyLz8uqQ@mail.gmail.com>
 <4FDAFA17.6050502@linaro.org>
 <CAE2-_9rRYxjU9QQgtBv9ReMY5x+oRiJG1cDQahYHanjDrwVUYA@mail.gmail.com>
 <20120615115042.GA27480@bnru02>
 <4FDB2E57.4030904@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FDB2E57.4030904@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 14:45:11 +0200, Lee Jones wrote:
> On 15/06/12 12:50, Srinidhi Kasagar wrote:
> > [...]
> >>
> >>
> >> From: Lee Jones<lee.jones@linaro.org>
> >> Date: Tue, 17 Apr 2012 16:04:13 +0100
> >> Subject: [PATCH 1/1] i2c: Add Device Tree support to the Nomadik I2C driver
> >>
> >> Here we apply the bindings required for successful Device Tree
> >> probing of the i2c-nomadik driver. We also apply a fall-back
> >> configuration in case either one is not provided, or a required
> >> element is missing from the one supplied.
> >>
> >> Cc: linux-i2c@vger.kernel.org
> >> Signed-off-by: Lee Jones<lee.jones@linaro.org>
> >> ---
> >>   drivers/i2c/busses/i2c-nomadik.c |   82 +++++++++++++++++++++++++++++++++++++-
> >>   1 file changed, 80 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
> >> index a92440d..58e8114 100644
> >> --- a/drivers/i2c/busses/i2c-nomadik.c
> >> +++ b/drivers/i2c/busses/i2c-nomadik.c
> >> @@ -23,6 +23,7 @@
> >>   #include<linux/io.h>
> >>   #include<linux/regulator/consumer.h>
> >>   #include<linux/pm_runtime.h>
> >> +#include<linux/of.h>
> >>
> >>   #include<plat/i2c.h>
> >>
> >> @@ -899,15 +900,86 @@ static const struct i2c_algorithm nmk_i2c_algo = {
> >>         .functionality  = nmk_i2c_functionality
> >>   };
> >>
> >> +static struct nmk_i2c_controller u8500_i2c = {
> >> +       /*
> >> +        * Slave data setup time; 250ns, 100ns, and 10ns, which
> >> +        * is 14, 6 and 2 respectively for a 48Mhz i2c clock.
> >> +        */
> >> +       .slsu           = 0xe,
> >> +       .tft            = 1,      /* Tx FIFO threshold */
> >> +       .rft            = 8,      /* Rx FIFO threshold */
> >> +       .clk_freq       = 100000, /* std. mode operation */
> >> +       .timeout        = 200,    /* Slave response timeout(ms) */
> >> +       .sm             = I2C_FREQ_MODE_FAST,
> >
> > How is this possible? you are setting clk_freq as 100kb/s and mode
> > as fast mode which is supposed to be 400kb/s.
> 
> That's not how I read it:

But it is not readable. It confuses people.

> 
> > enum i2c_freq_mode {
> >         I2C_FREQ_MODE_STANDARD,         /* up to 100 Kb/s */
> >         I2C_FREQ_MODE_FAST,             /* up to 400 Kb/s */
> >         I2C_FREQ_MODE_HIGH_SPEED,       /* up to 3.4 Mb/s */
> >         I2C_FREQ_MODE_FAST_PLUS,        /* up to 1 Mb/s */
> > };
> 
> The operative words here are "up to".

I know, then none of these modes does not make sense.

> 
> >> +};
> >> +
> >> +static int __devinit
> >> +nmk_i2c_of_probe(struct device_node *np, struct nmk_i2c_controller *pdata)
> >> +{
> >> +       of_property_read_u32(np, "clock-frequency", (u32*)&pdata->clk_freq);
> >> +       if (!pdata->clk_freq) {
> >> +               pr_warn("%s: Clock frequency not found\n", np->full_name);
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       of_property_read_u32(np, "stericsson,slsu", (u32*)&pdata->slsu);
> >> +       if (!pdata->slsu) {
> >> +               pr_warn("%s: Data line delay not found\n", np->full_name);
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       of_property_read_u32(np, "stericsson,tft", (u32*)&pdata->tft);
> >> +       if (!pdata->tft) {
> >> +               pr_warn("%s: Tx FIFO threshold not found\n", np->full_name);
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       of_property_read_u32(np, "stericsson,rft", (u32*)&pdata->rft);
> >> +       if (!pdata->rft) {
> >> +               pr_warn("%s: Rx FIFO threshold not found\n", np->full_name);
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       of_property_read_u32(np, "stericsson,timeout", (u32*)&pdata->timeout);
> >> +       if (!pdata->timeout) {
> >> +               pr_warn("%s: Timeout not found\n", np->full_name);
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       if (of_get_property(np, "stericsson,i2c_freq_mode_fast", NULL))
> >> +               pdata->sm = I2C_FREQ_MODE_FAST;
> >> +       else
> >> +               pdata->sm = I2C_FREQ_MODE_STANDARD;
> >
> > The controller has more modes like fast mode plus and high speed mode. You can't make
> > assumptions like this.
> 
> These are currently unsupported. Read the comments in the file:

I wrote this code, I remember these comments very well :)

> 
> > 	/*
> > 	 * set the speed mode. Currently we support
> > 	 * only standard and fast mode of operation
> > 	 * TODO - support for fast mode plus (up to 1Mb/s)
> > 	 * and high speed (up to 3.4 Mb/s)
> > 	 */
> 
> I can add a similar comment here if it make you feel better?

Please.

> 
> >> +
> >> +       return 0;
> >> +}
> >> +
> >>   static int __devinit nmk_i2c_probe(struct platform_device *pdev)
> >>   {
> >>         int ret = 0;
> >>         struct resource *res;
> >> -       struct nmk_i2c_controller *pdata =
> >> -                       pdev->dev.platform_data;
> >> +       struct nmk_i2c_controller *pdata = pdev->dev.platform_data;
> >> +       struct device_node *np = pdev->dev.of_node;
> >>         struct nmk_i2c_dev      *dev;
> >>         struct i2c_adapter *adap;
> >>
> >> +       if (np) {
> >> +               if (!pdata) {
> >> +                       pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> >> +                       if (!pdata) {
> >> +                               ret = -ENOMEM;
> >> +                               goto err_no_mem;
> >> +                       }
> >> +               }
> >> +               ret = nmk_i2c_of_probe(np, pdata);
> >> +               if (ret)
> >> +                       kfree(pdata);
> >> +       }
> >> +
> >> +       if (!pdata)
> >> +               /* No i2c configuration found, using the default. */
> >> +               pdata =&u8500_i2c;
> >
> > There are redundant fallback configurations exists in the driver. You might need to remove
> > those, if you want to fallback here.
> 
> I only see a fall-back for clk_freq. Are there others?

No, I can see that it only exists in setup_i2c_controller(). Please fix.

> 
> >> +
> >>         dev = kzalloc(sizeof(struct nmk_i2c_dev), GFP_KERNEL);
> >>         if (!dev) {
> >>                 dev_err(&pdev->dev, "cannot allocate memory\n");
> >> @@ -1038,11 +1110,17 @@ static int __devexit nmk_i2c_remove(struct platform_device *pdev)
> >>         return 0;
> >>   }
> >>
> >> +static const struct of_device_id nmk_gpio_match[] = {
> >> +       { .compatible = "st,nomadik-i2c", },
> >> +       {},
> >> +};
> >> +
> >>   static struct platform_driver nmk_i2c_driver = {
> >>         .driver = {
> >>                 .owner = THIS_MODULE,
> >>                 .name = DRIVER_NAME,
> >>                 .pm =&nmk_i2c_pm,
> >> +               .of_match_table = nmk_gpio_match,
> >>         },
> >>         .probe = nmk_i2c_probe,
> >>         .remove = __devexit_p(nmk_i2c_remove),
> >> --
> >> 1.7.9.5
> >>
> 
> Kind regards,
> Lee
> 
> -- 
> Lee Jones
> Linaro ST-Ericsson Landing Team Lead
> M: +44 77 88 633 515
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
