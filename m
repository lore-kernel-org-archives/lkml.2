Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab2IGQ4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:56:01 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:28183 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab2IGQz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:55:56 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19+QV5kWjvBrRetD1HWVBW+
Date: Fri, 7 Sep 2012 09:55:53 -0700
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/2] pinctrl: pinctrl-single: Add pinctrl-single,bits
 type of mux
Message-ID: <20120907165553.GV1303@atomide.com>
References: <1346835718-21325-1-git-send-email-peter.ujfalusi@ti.com>
 <1346835718-21325-3-git-send-email-peter.ujfalusi@ti.com>
 <20120906191019.GZ1303@atomide.com>
 <504A0F21.8080305@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504A0F21.8080305@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Ujfalusi <peter.ujfalusi@ti.com> [120907 08:13]:
> On 09/06/2012 10:10 PM, Tony Lindgren wrote:
> > 
> > Is it now safe to assume that we always have width of three if
> > pinctrl-single,bits is specified? The reason I'm asking is..
> > 
> >> @@ -657,18 +664,29 @@ static int pcs_parse_one_pinctrl_entry(struct pcs_device *pcs,
> >>  {
> >>  	struct pcs_func_vals *vals;
> >>  	const __be32 *mux;
> >> -	int size, rows, *pins, index = 0, found = 0, res = -ENOMEM;
> >> +	int size, params, rows, *pins, index = 0, found = 0, res = -ENOMEM;
> >>  	struct pcs_function *function;
> >>  
> >> -	mux = of_get_property(np, PCS_MUX_NAME, &size);
> >> -	if ((!mux) || (size < sizeof(*mux) * 2)) {
> >> -		dev_err(pcs->dev, "bad data for mux %s\n",
> >> -			np->name);
> >> +	mux = of_get_property(np, PCS_MUX_PINS_NAME, &size);
> >> +	if (mux) {
> >> +		params = 2;
> >> +	} else {
> >> +		mux = of_get_property(np, PCS_MUX_BITS_NAME, &size);
> >> +		if (!mux) {
> >> +			dev_err(pcs->dev, "no valid property for %s\n",
> >> +				np->name);
> >> +			return -EINVAL;
> >> +		}
> >> +		params = 3;
> >> +	}
> > 
> > ..because here we could assume the default value for params is 2
> > if pinctrl-single,pins is specified, and otherwise params is 3
> > if pinctrl-single,bits is specified for the controller. That would
> > avoid querying a potentially non-exiting property for each entry.
> > 
> >> @@ -686,6 +704,10 @@ static int pcs_parse_one_pinctrl_entry(struct pcs_device *pcs,
> >>  		val = be32_to_cpup(mux + index++);
> >>  		vals[found].reg = pcs->base + offset;
> >>  		vals[found].val = val;
> >> +		if (params == 3) {
> >> +			val = be32_to_cpup(mux + index++);
> >> +			vals[found].mask = val;
> >> +		}
> >>  
> >>  		pin = pcs_get_pin_by_offset(pcs, offset);
> >>  		if (pin < 0) {
> > 
> > Here params too would be then set during probe already.
> 
> I'm afraid you lost me here...
> We only know if the user specified the mux configuration with
> pinctrl-single,pins or  pinctrl-single,bits in this function.

Sorry right, yeah we don't know that at probe time currently.

I'd like to have something that specifies the controller type so
we don't need to mix two types of controllers and test for
non-existing properties when parsing the pins.

How about we require something specified for the pinctrl driver
in the "one-bit-per-mux" case like pinctrl-single,bit-per-mux?

And then in the pinctrl-single probe we set params = 3 if
pinctrl-single,bit-per-mux is specified. And if no
pinctrl-single,bit-per-mux is specified then set params = 2.

That way pcs_parse_one_pinctrl_entry() can just test for params.

Sorry I don't have a better name in mind than bit-per-mux..
 
> One thing I could do to make the code a bit better to look at is:
> int params = 2;
> 
> mux = of_get_property(np, PCS_MUX_PINS_NAME, &size);
> if (!mux) {
> 	mux = of_get_property(np, PCS_MUX_BITS_NAME, &size);
> 	if (!mux) {
> 		dev_err(pcs->dev, "no valid property for %s\n",
> 		np->name);
> 		return -EINVAL;
> 	}
> 	params = 3;
> }
> 
> This might make the code a bit more compact but at the same time one might
> need to spend few more seconds to understand it.

Yes well there's no need to do of_get_property second guessing
if we already know params from the pinctrl-single.c probe time.

I think we're safe to assume that we don't need to mix parsing
two different types of configuration for the same controller
as they can always be set up as separate controllers.

Regards,

Tony
