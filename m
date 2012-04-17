Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab2DQGYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 02:24:01 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:42664
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752854Ab2DQGYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 02:24:00 -0400
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 17 Apr 2012 14:34:38 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/3] pinctrl: display pin name instead of raw pin id
Message-ID: <20120417063437.GE17173@shlinux2.ap.freescale.net>
References: <1334585244-10249-1-git-send-email-b29396@freescale.com>
 <4F8C60EE.30008@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F8C60EE.30008@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 02:11:58AM +0800, Stephen Warren wrote:
> On 04/16/2012 08:07 AM, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > Pin name is more useful to users.
> 
> > diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> 
> > @@ -964,10 +984,14 @@ static int pinctrl_groups_show(struct seq_file *s, void *what)
> >  			seq_printf(s, "%s [ERROR GETTING PINS]\n",
> >  				   gname);
> >  		else {
> > +			seq_printf(s, "group: %s\n", gname);
> > +			for (i = 0; i < num_pins; i++) {
> > +				pname = pin_get_name(pctldev, pins[i]);
> > +				if (!pname)
> > +					return -EINVAL;
> 
> I'd rather see this say pname = "(unknown)" instead of return, to get as
> much of the information into debugfs possible even in the face of errors.
> 
pinctrl_register_one_pin will guarantee the pname should never be NULL.
So this condition is a never happen case.
That's why i simply returned an error with no debug information.

> But perhaps that condition should even be a BUG(); it would imply that
> pinctrl_register_on_pin() had failed pretty badly.
> 
>From the comments of BUG() in bug.h, it looks using BUG() here is a little
too seriously.
=====
 * Don't use BUG() or BUG_ON() unless there's really no way out;

Maybe WARN_ON is more suitable here, right?
I will send a patch for your review.

> > diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
> > index c494c37..fa0357b 100644
> > --- a/drivers/pinctrl/pinmux.c
> > +++ b/drivers/pinctrl/pinmux.c
> > @@ -88,8 +88,6 @@ static int pin_request(struct pinctrl_dev *pctldev,
> >  	const struct pinmux_ops *ops = pctldev->desc->pmxops;
> >  	int status = -EINVAL;
> >  
> > -	dev_dbg(pctldev->dev, "request pin %d for %s\n", pin, owner);
> > -
> >  	desc = pin_desc_get(pctldev, pin);
> >  	if (desc == NULL) {
> >  		dev_err(pctldev->dev,
> > @@ -97,6 +95,9 @@ static int pin_request(struct pinctrl_dev *pctldev,
> >  		goto out;
> >  	}
> >  
> > +	dev_dbg(pctldev->dev, "request pin %d (%s) for %s\n",
> > +		pin, desc->name, owner);
> > +
> >  	if (gpio_range) {
> >  		/* There's no need to support multiple GPIO requests */
> >  		if (desc->gpio_owner) {
> 
> That seems like it should be a separate patch?
> 
Ok to me, will make a separate one.

Regards
Dong Aisheng

