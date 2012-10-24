Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934362Ab2JXDsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 23:48:47 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:56615 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934056Ab2JXDsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 23:48:46 -0400
Message-ID: <1351050535.23151.1.camel@gitbox>
Subject: Re: [PATCH v3] pwm: vt8500: Update vt8500 PWM driver support
From: Tony Prisk <linux@prisktech.co.nz>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: devicetree-discuss@lists.ozlabs.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Wed, 24 Oct 2012 16:48:55 +1300
In-Reply-To: <20121023221419.GA8501@avionic-0098.mockup.avionic-design.de>
References: <20121022084000.GB29790@avionic-0098.mockup.avionic-design.de>
	 <1350929425-17516-1-git-send-email-linux@prisktech.co.nz>
	 <20121023221419.GA8501@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-24 at 00:14 +0200, Thierry Reding wrote:
> On Tue, Oct 23, 2012 at 07:10:24AM +1300, Tony Prisk wrote:
> [...]
> > @@ -87,6 +98,11 @@ static int vt8500_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
> >  {
> >  	struct vt8500_chip *vt8500 = to_vt8500_chip(chip);
> >  
> > +	if (!clk_enable(vt8500->clk)) {
> > +		dev_err(chip->dev, "failed to enable clock\n");
> > +		return -EBUSY;
> > +	};
> > +
> 
> I don't think that works. The clock API returns 0 on success and a
> negative error code on failure. So this should rather be something like:
> 
> 	err = clk_enable(vt8500->clk);
> 	if (err < 0) {
> 		dev_err(chip->dev, "failed to enable clock: %d\n", err);
> 		return err;
> 	}
> 
> > @@ -123,6 +153,12 @@ static int __devinit pwm_probe(struct platform_device *pdev)
> >  	chip->chip.ops = &vt8500_pwm_ops;
> >  	chip->chip.base = -1;
> >  	chip->chip.npwm = VT8500_NR_PWMS;
> > +	chip->clk = devm_clk_get(&pdev->dev, NULL);
> > +
> 
> The blank line should go above the call to devm_clk_get().
> 
> > +	if (IS_ERR_OR_NULL(chip->clk)) {
> > +		dev_err(&pdev->dev, "clock source not specified\n");
> > +		return PTR_ERR(chip->clk);
> > +	}
> [...]
> > +	if (!clk_prepare(chip->clk)) {
> > +		dev_err(&pdev->dev, "failed to prepare clock\n");
> > +		return -EBUSY;
> > +	}
> > +
> 
> Same comment here. I wonder how this code can work, since if the clock
> is properly prepared, then it will return 0, and the above will return
> -EBUSY.
> 
> >  	ret = pwmchip_add(&chip->chip);
> > -	if (ret < 0)
> > +	if (ret < 0) {
> > +		dev_err(&pdev->dev, "failed to add pwmchip\n");
> 
> Error messages can be considered prose, so this should be: "failed to
> add PWM chip".
> 
> Thierry

I don't know why none of this caused a failure when boot tested. The
clock should have been disabled 'automagically' at bootup, and never
reenabled. *shrug* Fixed in new patch v3 (didn't notice there was
already a v3).

Regards
Tony P

