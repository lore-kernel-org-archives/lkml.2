Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab2KFGqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 01:46:35 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35580 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab2KFGqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 01:46:30 -0500
From: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
To: "Philip, Avinash" <avinashphilip@ti.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "paul@pwsan.com" <paul@pwsan.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>
CC: Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 5/8] pwm: pwm-tiehrpwm: Add device-tree binding support
 for EHRPWM driver
Thread-Topic: [PATCH 5/8] pwm: pwm-tiehrpwm: Add device-tree binding support
 for EHRPWM driver
Thread-Index: AQHNuzj8FE6ZMT+Ux0KSn6d6mSp8P5fcXCTA
Date: Tue, 6 Nov 2012 06:46:13 +0000
Message-ID: <B5906170F1614E41A8A28DE3B8D121433EC0447E@DBDE01.ent.ti.com>
References: <1352106749-9437-1-git-send-email-avinashphilip@ti.com>
 <1352106749-9437-6-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1352106749-9437-6-git-send-email-avinashphilip@ti.com>
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

On Mon, Nov 05, 2012 at 14:42:26, Philip, Avinash wrote:
[...]

> +#include <linux/of_device.h>
> +#include <linux/pinctrl/consumer.h>

Pinctrl changes should be separate patch. Morevoer, you don't mention
that you making this change.

> +
> +#include "tipwmss.h"
>  
>  /* EHRPWM registers and bits definitions */
>  
> @@ -107,6 +111,10 @@
>  #define AQCSFRC_CSFA_FRCHIGH	BIT(1)
>  #define AQCSFRC_CSFA_DISSWFRC	(BIT(1) | BIT(0))
>  
> +#define EPWMCLK_EN_SHIFT	8
> +
> +#define PWM_CELL_SIZE		3
> +
>  #define NUM_PWM_CHANNEL		2	/* EHRPWM channels */
>  
>  struct ehrpwm_pwm_chip {
> @@ -392,12 +400,27 @@ static const struct pwm_ops ehrpwm_pwm_ops = {
>  	.owner		= THIS_MODULE,
>  };
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id ehrpwm_of_match[] = {
> +	{
> +		.compatible	= "ti,am33xx-ehrpwm",
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, ehrpwm_of_match);
> +#endif
> +
>  static int __devinit ehrpwm_pwm_probe(struct platform_device *pdev)
>  {
>  	int ret;
>  	struct resource *r;
>  	struct clk *clk;
>  	struct ehrpwm_pwm_chip *pc;
> +	struct pinctrl *pinctrl;
> +
> +	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);

I didn't see a patch adding the pinctrl entries.

> +	if (IS_ERR(pinctrl))
> +		dev_warn(&pdev->dev, "failed to configure pins from driver\n");
>  
>  	pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
>  	if (!pc) {
> @@ -419,6 +442,7 @@ static int __devinit ehrpwm_pwm_probe(struct platform_device *pdev)
>  
>  	pc->chip.dev = &pdev->dev;
>  	pc->chip.ops = &ehrpwm_pwm_ops;
> +	pc->chip.of_pwm_n_cells = PWM_CELL_SIZE;
>  	pc->chip.base = -1;
>  	pc->chip.npwm = NUM_PWM_CHANNEL;
>  
> @@ -437,8 +461,11 @@ static int __devinit ehrpwm_pwm_probe(struct platform_device *pdev)
>  		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
>  		return ret;
>  	}
> -
>  	pm_runtime_enable(&pdev->dev);
> +	pm_runtime_get_sync(&pdev->dev);
> +	pwmss_submodule_state_change(pdev->dev.parent, EPWMCLK_EN_SHIFT, true);

I think you should modify this API to return the status for drivers to check.

Another related question, why should this clock be enabled in probe and not only when it
is required? Shouldn't it be disabled in suspend?

Regards,
Vaibhav
