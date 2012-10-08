Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab2JHNci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 09:32:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52993 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab2JHNcd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:32:33 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: RE: [PATCH 1/2] pwm: pwm-tiecap: Add device-tree binding support
 for APWM driver
Thread-Topic: [PATCH 1/2] pwm: pwm-tiecap: Add device-tree binding support
 for APWM driver
Thread-Index: AQHNm9yobIMSc4CNQUWf2NRAW+lIrZelMnQAgAQMDBA=
Date: Mon, 8 Oct 2012 13:31:19 +0000
Deferred-Delivery: Mon, 8 Oct 2012 13:31:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9CA1E8@DBDE01.ent.ti.com>
References: <1348658863-29428-1-git-send-email-avinashphilip@ti.com>
 <1348658863-29428-2-git-send-email-avinashphilip@ti.com>
 <20121002060014.GA4298@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121002060014.GA4298@avionic-0098.mockup.avionic-design.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 11:30:14, Thierry Reding wrote:
> On Wed, Sep 26, 2012 at 04:57:42PM +0530, Philip, Avinash wrote:
> [...]
> > +#include <linux/platform_data/ti-pwmss.h>
> [...]
> > +static struct pwmss_platform_data am33xx_data = {
> > +	.has_configspace	= true,
> > +};
> 
> This structure is defined in a public header. I don't see why it has to,
> given that it's only used to associate some data with an of_device_id
> entry below. Since AM33xx never had anything but OF support in the
> mainline kernel I don't think we should add platform data.

I will correct it. I was going through Sekhar's reply.

> 
> > +#ifdef CONFIG_OF
> > +static const struct of_device_id ecap_of_match[] = {
> > +	{
> > +		.compatible	= "ti,am33xx-ecap",
> > +		.data		= &am33xx_data,
> > +	},
> > +	{},
> > +};
> > +MODULE_DEVICE_TABLE(of, ecap_of_match);
> > +#endif
> > +
> 
> I don't quite see why we need to pass this platform data to the device
> at all since there is no other variant anyway. I think this should only
> be added if this turns out to be required at some point.
> 
> >  static int __devinit ecap_pwm_probe(struct platform_device *pdev)
> >  {
> >  	int ret;
> >  	struct resource *r;
> >  	struct clk *clk;
> >  	struct ecap_pwm_chip *pc;
> > +	struct pwmss_platform_data *pdata = pdev->dev.platform_data;
> > +	const struct of_device_id *match;
> > +	u16 regval;
> > +	struct pinctrl *pinctrl;
> > +
> > +	match = of_match_device(of_match_ptr(ecap_of_match), &pdev->dev);
> 
> I've never seen of_match_ptr() used this way. Maybe you should think
> about not #ifdef'ing OF specific code at all. That way ecap_of_match
> will always exist and you could use the IS_ENABLED() macro to
> conditionalize at compile time. The compiler will probably be clever
> enough to optimize the ecap_of_match away if OF is not enabled.

I will correct it.

> 
> Given my comment earlier, since AM33xx is OF only you might just as well
> add a depends on OF to this driver and things will become a lot easier.

I will check & correct it.

> 
> > +
> > +	if (match)
> > +		pdata = (struct pwmss_platform_data *)match->data;
> > +
> > +	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
> > +	if (IS_ERR(pinctrl))
> > +		dev_warn(&pdev->dev, "failed to configure pins from driver\n");
> >  
> >  	pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
> >  	if (!pc) {
> > @@ -211,6 +268,8 @@ static int __devinit ecap_pwm_probe(struct platform_device *pdev)
> >  
> >  	pc->chip.dev = &pdev->dev;
> >  	pc->chip.ops = &ecap_pwm_ops;
> > +	pc->chip.of_xlate = of_ecap_xlate;
> > +	pc->chip.of_pwm_n_cells = PWM_CELL_SIZE;
> >  	pc->chip.base = -1;
> >  	pc->chip.npwm = 1;
> >  
> > @@ -231,13 +290,56 @@ static int __devinit ecap_pwm_probe(struct platform_device *pdev)
> >  	}
> >  
> >  	pm_runtime_enable(&pdev->dev);
> > +
> > +	/*
> > +	 * Some platform has extra PWM-subsystem common config space
> > +	 * and requires special handling of clock gating.
> > +	 */
> > +	if (pdata && pdata->has_configspace) {
> > +		r = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> > +		if (!r) {
> > +			dev_err(&pdev->dev, "no memory resource defined\n");
> > +			ret = -ENODEV;
> > +			goto err_disable_clock;
> > +		}
> > +
> > +		pc->config_base = devm_ioremap(&pdev->dev, r->start,
> > +				resource_size(r));
> > +		if (!pc->config_base) {
> > +			dev_err(&pdev->dev, "failed to ioremap() registers\n");
> > +			ret = -EADDRNOTAVAIL;
> > +			goto err_disable_clock;
> > +		}
> 
> Isn't this missing a request_mem_region()? I assume you don't do that
> here because you need the same region in the EHRPWM driver, right?

request_mem_region() is avoided as this region is shared across PWM
sub modules ECAP & EHRPWM. 

> This should be indication enough that the design is not right here.
> I think we need a proper abstraction here. Can this not be done via
> PM runtime support? If not, maybe this should be represented by
> clock objects since the bit obviously enables a clock.

It is not done as part of PM runtime as this is has nothing to
do with clock tree of the SOC. The bits we were enabling here
should consider as an enable of the individual sub module as
part of IP integration. Hence we were handling these subsystem
module enable in the driver itself.

> 
> > +
> > +		/* Enable ECAP clock gating at PWM-subsystem common config */
> > +		pm_runtime_get_sync(&pdev->dev);
> > +		regval = readw(pc->config_base + PWMSS_CLKCONFIG);
> > +		regval |= PWMSS_ECAP_CLK_EN;
> > +		writew(regval, pc->config_base + PWMSS_CLKCONFIG);
> > +		pm_runtime_put_sync(&pdev->dev);
> > +	}
> > +
> >  	platform_set_drvdata(pdev, pc);
> >  	return 0;
> > +
> > +err_disable_clock:
> > +	pm_runtime_disable(&pdev->dev);
> > +	return ret;
> >  }
> >  
> >  static int __devexit ecap_pwm_remove(struct platform_device *pdev)
> >  {
> >  	struct ecap_pwm_chip *pc = platform_get_drvdata(pdev);
> > +	u16 regval;
> > +
> > +	if (pc->config_base) {
> > +		/* Disable ECAP clock gating at PWM-subsystem common config */
> > +		pm_runtime_get_sync(&pdev->dev);
> > +		regval = readw(pc->config_base + PWMSS_CLKCONFIG);
> > +		regval &= ~PWMSS_ECAP_CLK_EN;
> > +		writew(regval, pc->config_base + PWMSS_CLKCONFIG);
> > +		pm_runtime_put_sync(&pdev->dev);
> > +	}
> >  
> >  	pm_runtime_put_sync(&pdev->dev);
> >  	pm_runtime_disable(&pdev->dev);
> > @@ -247,6 +349,9 @@ static int __devexit ecap_pwm_remove(struct platform_device *pdev)
> >  static struct platform_driver ecap_pwm_driver = {
> >  	.driver = {
> >  		.name = "ecap",
> > +#ifdef CONFIG_OF
> > +		.of_match_table = of_match_ptr(ecap_of_match),
> > +#endif
> 
> If you use of_match_ptr() you don't need the additional #ifdef
> CONFIG_OF. But as I already said I don't think you need this at all
> anyway. You should really just depend on OF and be done with it.

Ok I understood & will correct it.

Thanks
Avinash

> 
> Thierry
> 

