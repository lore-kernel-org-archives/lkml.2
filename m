Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab2KPJli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:41:38 -0500
Received: from 18.mo3.mail-out.ovh.net ([87.98.172.162]:54103 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751169Ab2KPJlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:41:36 -0500
Date: Fri, 16 Nov 2012 10:39:33 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Axel Lin <axel.lin@ingics.com>, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH RESEND 3/4] pinctrl: at91: Prevent NULL dereference if
 of_match_device returns NULL
Message-ID: <20121116093933.GE4398@game.jcrosoft.org>
References: <1352955096.6793.1.camel@phoenix>
 <1352955266.6793.4.camel@phoenix>
 <1352955480.6793.8.camel@phoenix>
 <20121115100012.GA4398@game.jcrosoft.org>
 <50A5FB17.1050208@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A5FB17.1050208@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 741968040004266860
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehgedrtdekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpehinhhfrhgruggvrggurdhorhhgnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehgedrtdekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpehinhhfrhgruggvrggurdhorhhgnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:36 Fri 16 Nov     , Nicolas Ferre wrote:
> On 11/15/2012 11:00 AM, Jean-Christophe PLAGNIOL-VILLARD :
> > On 12:58 Thu 15 Nov     , Axel Lin wrote:
> >> of_match_device() may return NULL.
> > this is not possible on at91
> > 
> > and I do a oups here as if we have a NULL pointer which means the driver is
> > wrong
> 
> Well, okay, but it does not prevent from adding a supplementary check to
> mimic every other pinctrl driver and use a common return path to the
> of_match_device() function.
> 
> So I am not completely against this patch (that I why I added my Acked-by).
here it's a silent warning a oops it clear we have a bug

Best Regards,
J.
> 
> 
> >> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> >> ---
> >> This resend CC Jean-Christophe.
> >>
> >>  drivers/pinctrl/pinctrl-at91.c |   17 +++++++++++++----
> >>  1 file changed, 13 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> >> index 8490a55..32006c8 100644
> >> --- a/drivers/pinctrl/pinctrl-at91.c
> >> +++ b/drivers/pinctrl/pinctrl-at91.c
> >> @@ -829,13 +829,18 @@ static int __devinit at91_pinctrl_probe_dt(struct platform_device *pdev,
> >>  	uint32_t *tmp;
> >>  	struct device_node *np = pdev->dev.of_node;
> >>  	struct device_node *child;
> >> +	const struct of_device_id *match;
> >>  
> >>  	if (!np)
> >>  		return -ENODEV;
> >>  
> >> +	match = of_match_device(at91_pinctrl_of_match, &pdev->dev)->data;
> >> +	if (!match)
> >> +		return -ENODEV;
> >> +
> >>  	info->dev = &pdev->dev;
> >> -	info->ops = (struct at91_pinctrl_mux_ops*)
> >> -		of_match_device(at91_pinctrl_of_match, &pdev->dev)->data;
> >> +	info->ops = (struct at91_pinctrl_mux_ops *) match->data;
> >> +
> >>  	at91_pinctrl_child_count(info, np);
> >>  
> >>  	if (info->nbanks < 1) {
> >> @@ -1359,6 +1364,7 @@ static struct of_device_id at91_gpio_of_match[] __devinitdata = {
> >>  static int __devinit at91_gpio_probe(struct platform_device *pdev)
> >>  {
> >>  	struct device_node *np = pdev->dev.of_node;
> >> +	const struct of_device_id *match;
> >>  	struct resource *res;
> >>  	struct at91_gpio_chip *at91_chip = NULL;
> >>  	struct gpio_chip *chip;
> >> @@ -1399,8 +1405,11 @@ static int __devinit at91_gpio_probe(struct platform_device *pdev)
> >>  		goto err;
> >>  	}
> >>  
> >> -	at91_chip->ops = (struct at91_pinctrl_mux_ops*)
> >> -		of_match_device(at91_gpio_of_match, &pdev->dev)->data;
> >> +	match = of_match_device(at91_gpio_of_match, &pdev->dev);
> >> +	if (!match)
> >> +		return -ENODEV;
> >> +
> >> +	at91_chip->ops = (struct at91_pinctrl_mux_ops *) match->data;
> >>  	at91_chip->pioc_virq = irq;
> >>  	at91_chip->pioc_idx = alias_idx;
> >>  
> >> -- 
> >> 1.7.9.5
> >>
> >>
> >>
> > 
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> > 
> > 
> 
> 
> -- 
> Nicolas Ferre
