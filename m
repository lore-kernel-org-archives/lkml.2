Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab2JVGvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 02:51:51 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:64060 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab2JVGvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 02:51:49 -0400
Message-ID: <1350888712.3592.11.camel@gitbox>
Subject: Re: [PATCH 2/3] PWM: vt8500: Update vt8500 PWM driver support
From: Tony Prisk <linux@prisktech.co.nz>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Date: Mon, 22 Oct 2012 19:51:52 +1300
In-Reply-To: <20121022063423.GA17181@avionic-0098.mockup.avionic-design.de>
References: <1350643135-13197-1-git-send-email-linux@prisktech.co.nz>
	 <1350643135-13197-2-git-send-email-linux@prisktech.co.nz>
	 <20121022063423.GA17181@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replies to your comments inline:

On Mon, 2012-10-22 at 08:34 +0200, Thierry Reding wrote:
...
> > -static int __devinit pwm_probe(struct platform_device *pdev)
> > +static const struct of_device_id vt8500_pwm_dt_ids[] = {
> > +	{ .compatible = "via,vt8500-pwm", },
> > +	{ /* Sentinel */ }
> > +};
> > +
> > +static int __devinit vt8500_pwm_probe(struct platform_device *pdev)
> 
> Since you're changing this line anyway, maybe you should drop __devinit
> (and __devexit for the .remove() callback). HOTPLUG is always enabled
> nowadays and will go away eventually, in which case these will need to
> be removed anyway.

Will do. I must say the inconstancy among comments is rather
frustrating. In another patch I sent out a few days ago (completely
unrelated to this), I told to add __devexit to a remove() function :\

> >  {
> >  	struct vt8500_chip *chip;
> > -	struct resource *r;
> > +	struct device_node *np = pdev->dev.of_node;
> >  	int ret;
> >  
> > +	if (!np) {
> > +		dev_err(&pdev->dev, "invalid devicetree node\n");
> > +		return -EINVAL;
> > +	}
> > +
> 
> This effectively makes DT support mandatory. Shouldn't you be adding a
> "depends on OF" into the Kconfig section in that case?
This driver depends on ARCH_VT8500, which only supports DT so a
dependency on OF seemed redundant. If you think its still necessary, let
me know and I'll add it anyway.
> 
> >  	chip = devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
> >  	if (chip == NULL) {
> >  		dev_err(&pdev->dev, "failed to allocate memory\n");
> > @@ -123,26 +144,32 @@ static int __devinit pwm_probe(struct platform_device *pdev)
> >  	chip->chip.ops = &vt8500_pwm_ops;
> >  	chip->chip.base = -1;
> >  	chip->chip.npwm = VT8500_NR_PWMS;
> > +	chip->clk = of_clk_get(np, 0);
> 
> I thought this was supposed to work transparently across OF and !OF
> configurations by using just clk_get() or devm_clk_get()? I guess that
> if the driver depends on OF, then this would be moot, but we should
> probably stick to the standard usage anyway.
> 
> Furthermore, of_clk_get() doesn't seem to be managed, so you'd need to
> add explicit clk_put() in the error cleanup paths. One more argument in
> favour of using devm_clk_get() instead.

Hmm good point. I stuck with of_ functions because its an OF only driver
and it seemed 'backward' to mix old code with new. It does pose the
question of 'why have of_clk_get() if existing functions work better'.
> 
> > -	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > -	if (r == NULL) {
> > -		dev_err(&pdev->dev, "no memory resource defined\n");
> > -		return -ENODEV;
> > +	if (!chip->clk) {
> > +		dev_err(&pdev->dev, "clock source not specified\n");
> > +		return -EINVAL;
> >  	}
> >  
> > -	chip->base = devm_request_and_ioremap(&pdev->dev, r);
> > -	if (chip->base == NULL)
> > +	chip->base = of_iomap(np, 0);
> 
> No need to change this. It should work with the standard calls as well.
Again, this was a conversion of use of_ functions rather than the 'old'
style.

> 
> > +	if (!chip->base) {
> > +		dev_err(&pdev->dev, "memory resource not available\n");
> >  		return -EADDRNOTAVAIL;
> > +	}
> > +
> > +	clk_prepare_enable(chip->clk);
> 
> Why does the clock need to be enabled here? Shouldn't it be postponed to
> the last possible moment to save power?
I didn't consider that - but the use case for everyone at present is
that they only need the PWM driver to control the backlight, and it's
going to be enabled at boot anyway - so one PWM will always be active.

Futureproofing is always good so I'll fix this.

...

> >  
> > -MODULE_LICENSE("GPL");
> > +MODULE_DESCRIPTION("VT8500 PWM Driver");
> > +MODULE_AUTHOR("Tony Prisk <linux@prisktech.co.nz>");
> > +MODULE_LICENSE("GPL v2");
> 
> IANAL, but I think you need the approval of all authors of this code
> before changing the license. But I see that the file header actually
> says that this code is GPL v2, so maybe this change could be considered
> a bugfix. =)

This is something I've already discussed with Alexey in regards to all
the existing drivers he has in mainline. Since I have taken over as
maintainer on this platform I have corrected the licenses as patch's
have gone through. As you pointed out, it was already GPLv2 in the
header, this is just a 'bugfix'.
> 
> > +MODULE_DEVICE_TABLE(of, vt8500_pwm_dt_ids);
> 
> I think it is customary to put this right after the device table
> definition.
Didn't know that - will fix.
> 
> > -- 
> > 1.7.9.5
> > 
> > 
> > 



