Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2KILBC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:01:02 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41860 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab2KILA6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:00:58 -0500
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
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: RE: [PATCH] pwm: Device tree support for PWM polarity.
Thread-Topic: [PATCH] pwm: Device tree support for PWM polarity.
Thread-Index: AQHNtf6x99cG3WGylk6s/gCHj0SM4pfg4MEAgACCsLA=
Date: Fri, 9 Nov 2012 10:59:31 +0000
Deferred-Delivery: Fri, 9 Nov 2012 10:56:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9E4506@DBDE01.ent.ti.com>
References: <1351532427-19881-1-git-send-email-avinashphilip@ti.com>
 <20121109083028.GD26007@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121109083028.GD26007@avionic-0098.mockup.avionic-design.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.24]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 14:00:28, Thierry Reding wrote:
> On Mon, Oct 29, 2012 at 11:10:27PM +0530, Philip, Avinash wrote:
> > From: "Philip, Avinash" <avinashphilip@ti.com>
> > 
> > Adds support for 3rd cell in pwm-specifier. PWM polarity is encoded in
> > device tree support in bit encoded form. Platforms require polarity of
> > PWM device initialized during PWM device initialization has to encode
> > polarity in 3rd cell of pwm-specifier.
> > 
> > Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> > ---
> > :100644 100644 73ec962... e522c59... M	Documentation/devicetree/bindings/pwm/pwm.txt
> > :100644 100644 f5acdaa... 1c6d50b... M	drivers/pwm/core.c
> > :100644 100644 112b314... d77c5b3... M	include/linux/pwm.h
> >  Documentation/devicetree/bindings/pwm/pwm.txt |   22 +++++++++++++++++++---
> >  drivers/pwm/core.c                            |   13 ++++++++++++-
> >  include/linux/pwm.h                           |    7 +++++++
> >  3 files changed, 38 insertions(+), 4 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/pwm/pwm.txt b/Documentation/devicetree/bindings/pwm/pwm.txt
> > index 73ec962..e522c59 100644
> > --- a/Documentation/devicetree/bindings/pwm/pwm.txt
> > +++ b/Documentation/devicetree/bindings/pwm/pwm.txt
> > @@ -37,10 +37,26 @@ device:
> >  		pwm-names = "backlight";
> >  	};
> >  
> > +Note that in the example above, specifying the "pwm-names" is redundant
> > +because the name "backlight" would be used as fallback anyway.
> > +
> >  pwm-specifier typically encodes the chip-relative PWM number and the PWM
> > -period in nanoseconds. Note that in the example above, specifying the
> > -"pwm-names" is redundant because the name "backlight" would be used as
> > -fallback anyway.
> > +period in nanoseconds.
> 
> Can you separate this by a blank line, please?

Ok

> 
> > +Optional pwm-specifier can be encoded in 3rd cell in bit encoded form.
> > + -------------------------------------------------------------
> > +|     Property   |  BIT position | Encoding                   |
> > +|-------------------------------------------------------------|
> > +| Polarity       |   0           | Set   -> Polarity inversed |
> > +|                |               | Clear -> Polarity Normal   |
> > + -------------------------------------------------------------
> > +
> 
> Using this kind of table isn't very common in device tree documentation
> and the description above the table is a little vague. Maybe something
> like this would be more explicit:
> 
> ---[snip]---
> 
> Optionally, the pwm-specifier can encode a number of flags in a third
> cell:
>   - bit 0: PWM signal polarity (0: normal polarity, 1: inverse polarity)
> 
> ---[snip]---
> 
> > +Exapmple with optional PWM specifier for inversed polarity
> 
> "Example"

Ok I will correct it.

> 
> > +
> > +	bl: backlight {
> > +		pwms = <&pwm 0 5000000 1>;
> > +		pwm-names = "backlight";
> > +	};
> > +
> >  
> >  2) PWM controller nodes
> >  -----------------------
> > diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
> > index f5acdaa..1c6d50b 100644
> > --- a/drivers/pwm/core.c
> > +++ b/drivers/pwm/core.c
> > @@ -146,6 +146,15 @@ of_pwm_simple_xlate(struct pwm_chip *pc, const struct of_phandle_args *args)
> >  
> >  	pwm_set_period(pwm, args->args[1]);
> >  
> > +	if (pc->of_pwm_n_cells > 2) {
> > +		enum pwm_polarity polarity;
> > +
> > +		/* Initialize polarity of PWM device */
> > +		polarity = args->args[2] & POLARITY_BIT ?
> > +			PWM_POLARITY_INVERSED : PWM_POLARITY_NORMAL;
> 
> Can we rewrite this as:
> 
> 	if (args->args[2] & POLARITY_BIT)
> 		pwm_set_polarity(pwm, PWM_POLARITY_INVERSED);
> 	else
> 		pwm_set_polarity(pwm, PWM_POLARITY_NORMAL);
> 
> ?

Ok

> 
> > +		pwm_set_polarity(pwm, polarity);
> > +	}
> > +
> >  	return pwm;
> >  }
> >  
> > @@ -156,7 +165,9 @@ static void of_pwmchip_add(struct pwm_chip *chip)
> >  
> >  	if (!chip->of_xlate) {
> >  		chip->of_xlate = of_pwm_simple_xlate;
> > -		chip->of_pwm_n_cells = 2;
> > +
> > +		if (chip->of_pwm_n_cells != 3)
> > +			chip->of_pwm_n_cells = 2;
> >  	}
> 
> I don't like the implicitness in this code. I think we should make this
> more explicit for driver writers, so that if .of_xlate is set to NULL,
> the default of_pwm_simple_xlate() is used. For all other cases we should
> export of_pwm_xlate_with_flags(), so that the driver can explicitly set
> the .of_xlate field to that function.
> 
> That will of course imply that the extra code that you added to
> of_pwm_simple_xlate() is moved into a separate function.

Ok I will go for export of_pwm_xlate_with_flags().

> 
> >  
> >  	of_node_get(chip->dev->of_node);
> > diff --git a/include/linux/pwm.h b/include/linux/pwm.h
> > index 112b314..d77c5b3 100644
> > --- a/include/linux/pwm.h
> > +++ b/include/linux/pwm.h
> > @@ -78,6 +78,13 @@ enum {
> >  	PWMF_ENABLED = 1 << 1,
> >  };
> >  
> > +/*
> > + * DT Platform property support.
> > + * POLARITY - set bit 0 in DT platform property
> > + */
> > +
> > +#define POLARITY_BIT	BIT(0)
> > +
> 
> This doesn't belong in a public header. It should be defined in the
> core.c source file. Maybe rename it to something like PWM_SPEC_POLARITY
> to make it more obvious that it defines a bit in the PWM specifier. You
> can reduce the comment to a single line, because the second doesn't add
> any additional information. Something like this:
> 
> /* flags in the third cell of the DT PWM specifier */
> #define PWM_SPEC_POLARITY (1 << 0)

Ok

Thanks
Avinash
> 
> Thierry
> 

