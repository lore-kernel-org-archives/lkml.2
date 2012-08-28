Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750990Ab2H1ENZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 00:13:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53059 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab2H1ENX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 00:13:23 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: RE: [PATCH 2/2] pwm: pwm-tiehrpwm: Add support for configuring
 polarity of PWM
Thread-Topic: [PATCH 2/2] pwm: pwm-tiehrpwm: Add support for configuring
 polarity of PWM
Thread-Index: AQHNgP9TdI1B+DtQnUSVh5O38sweKJdo07QAgARBS+A=
Date: Tue, 28 Aug 2012 04:12:16 +0000
Deferred-Delivery: Tue, 28 Aug 2012 04:12:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E99506A@DBDE01.ent.ti.com>
References: <1345705251-10942-1-git-send-email-avinashphilip@ti.com>
 <1345705251-10942-3-git-send-email-avinashphilip@ti.com>
 <20120824165314.GA21435@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120824165314.GA21435@avionic-0098.mockup.avionic-design.de>
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

On Fri, Aug 24, 2012 at 22:23:14, Thierry Reding wrote:
> On Thu, Aug 23, 2012 at 12:30:51PM +0530, Philip, Avinash wrote:
> [...]
> > diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
> [...]
> > @@ -100,10 +109,17 @@
> >  
> >  #define NUM_PWM_CHANNEL		2	/* EHRPWM channels */
> >  
> > +enum config {
> > +	config_dutycycle,
> > +	config_polarity,
> > +};
> > +
> 
> I don't think this makes sense, see below.
> 
> > @@ -165,38 +181,50 @@ static int set_prescale_div(unsigned long rqst_prescaler,
> >  }
> >  
> >  static void configure_chans(struct ehrpwm_pwm_chip *pc, int chan,
> > -		unsigned long duty_cycles)
> > +		enum config config)
> >  {
> > -	int cmp_reg, aqctl_reg;
> > -	unsigned short aqctl_val, aqctl_mask;
> > +	if (config == config_dutycycle) {
> > +		int cmp_reg;
> > +
> > +		if (chan == 1)
> > +			/* Channel 1 configured with compare B register */
> > +			cmp_reg = CMPB;
> > +		else
> > +			/* Channel 0 configured with compare A register */
> > +			cmp_reg = CMPA;
> > +
> > +		ehrpwm_write(pc->mmio_base, cmp_reg, pc->duty_cycles);
> > +	} else if (config == config_polarity) {
> > +		int aqctl_reg;
> > +		unsigned short aqctl_val, aqctl_mask;
> > +
> > +		/*
> > +		 * Configure PWM output to HIGH/LOW level on counter
> > +		 * reaches compare register value and LOW/HIGH level
> > +		 * on counter value reaches period register value and
> > +		 * zero value on counter
> > +		 */
> > +		if (chan == 1) {
> > +			aqctl_reg = AQCTLB;
> > +			aqctl_mask = AQCTL_CBU_MASK;
> > +
> > +			if (pc->polarity == PWM_POLARITY_INVERSED)
> > +				aqctl_val = AQCTL_CHANB_POLINVERSED;
> > +			else
> > +				aqctl_val = AQCTL_CHANB_POLNORMAL;
> > +		} else {
> > +			aqctl_reg = AQCTLA;
> > +			aqctl_mask = AQCTL_CAU_MASK;
> > +
> > +			if (pc->polarity == PWM_POLARITY_INVERSED)
> > +				aqctl_val = AQCTL_CHANA_POLINVERSED;
> > +			else
> > +				aqctl_val = AQCTL_CHANA_POLNORMAL;
> > +		}
> >  
> > -	/*
> > -	 * Channels can be configured from action qualifier module.
> > -	 * Channel 0 configured with compare A register and for
> > -	 * up-counter mode.
> > -	 * Channel 1 configured with compare B register and for
> > -	 * up-counter mode.
> > -	 */
> > -	if (chan == 1) {
> > -		aqctl_reg = AQCTLB;
> > -		cmp_reg = CMPB;
> > -		/* Configure PWM Low from compare B value */
> > -		aqctl_val = AQCTL_CBU_FRCLOW;
> > -		aqctl_mask = AQCTL_CBU_MASK;
> > -	} else {
> > -		cmp_reg = CMPA;
> > -		aqctl_reg = AQCTLA;
> > -		/* Configure PWM Low from compare A value*/
> > -		aqctl_val = AQCTL_CAU_FRCLOW;
> > -		aqctl_mask = AQCTL_CAU_MASK;
> > +		aqctl_mask |= AQCTL_PRD_MASK | AQCTL_ZRO_MASK;
> > +		ehrpwm_modify(pc->mmio_base, aqctl_reg, aqctl_mask, aqctl_val);
> >  	}
> > -
> > -	/* Configure PWM High from period value and zero value */
> > -	aqctl_val |= AQCTL_PRD_FRCHIGH | AQCTL_ZRO_FRCHIGH;
> > -	aqctl_mask |= AQCTL_PRD_MASK | AQCTL_ZRO_MASK;
> > -	ehrpwm_modify(pc->mmio_base,  aqctl_reg, aqctl_mask, aqctl_val);
> > -
> > -	ehrpwm_write(pc->mmio_base,  cmp_reg, duty_cycles);
> >  }
> 
> I think it might be better to split this into two separate functions.
> Both branches have absolutely no code in common, so splitting them off
> would decrease the indentation level and make this much more readable
> and wouldn't require the configuration enumeration from above.

EHRPWM supports two channels & can be configured for duty cycle
and polarity independently. That's why I wanted to use channel
configuration API.
I will correct it.

> 
> >  
> >  /*
> > @@ -254,12 +282,24 @@ static int ehrpwm_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
> >  	ehrpwm_modify(pc->mmio_base, TBCTL, TBCTL_CTRMODE_MASK,
> >  			TBCTL_CTRMODE_UP);
> >  
> > +	pc->duty_cycles = duty_cycles;
> >  	/* Configure the channel for duty cycle */
> > -	configure_chans(pc, pwm->hwpwm, duty_cycles);
> > +	configure_chans(pc, pwm->hwpwm, config_dutycycle);
> > +
> >  	pm_runtime_put_sync(chip->dev);
> >  	return 0;
> >  }
> >  
> > +static int ehrpwm_pwm_set_polarity(struct pwm_chip *chip,
> > +		struct pwm_device *pwm,	enum pwm_polarity polarity)
> > +{
> > +	struct ehrpwm_pwm_chip *pc = to_ehrpwm_pwm_chip(chip);
> > +
> > +	/* Configuration of polarity in hardware delayed done at enable */
> > +	pc->polarity = polarity;
> > +	return 0;
> > +}
> > +
> 
> The problem here, which is true for both of the .set_polarity() and
> .config() implementations is that both channels share a single duty
> cycle and polarity. What if the two channels are configured with
> conflicting settings? Shouldn't that at least give a warning or even
> return an error?

I missed this. I will correct it.

> 
> >  static int ehrpwm_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
> >  {
> >  	struct ehrpwm_pwm_chip *pc = to_ehrpwm_pwm_chip(chip);
> > @@ -283,6 +323,9 @@ static int ehrpwm_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
> >  
> >  	ehrpwm_modify(pc->mmio_base, AQCSFRC, aqcsfrc_mask, aqcsfrc_val);
> >  
> > +	/* Channels Polarity can be configured from action qualifier module */
> > +	configure_chans(pc, pwm->hwpwm, config_polarity);
> > +
> 
> What's this "action qualifier module"?

It is one of the sub modules in EHRPWM used for configuring channel PWM features 
(Polarity, Duty cycle, PWM output state etc.)

Thanks
Avinash

> 
> Thierry
> 

