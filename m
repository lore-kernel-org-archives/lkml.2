Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538Ab2IFTK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 15:10:26 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:62517 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab2IFTKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 15:10:22 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+MxRZleObseYgVUcPCiwY5
Date: Thu, 6 Sep 2012 12:10:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/2] pinctrl: pinctrl-single: Add pinctrl-single,bits
 type of mux
Message-ID: <20120906191019.GZ1303@atomide.com>
References: <1346835718-21325-1-git-send-email-peter.ujfalusi@ti.com>
 <1346835718-21325-3-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346835718-21325-3-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

* Peter Ujfalusi <peter.ujfalusi@ti.com> [120905 02:02]:
> With pinctrl-single,bits it is possible to update just part of the register
> within the pinctrl-single,function-mask area.
> This is useful when one register configures mmore than one pin's mux.

You have a typo here:                         ^^^^^
 
> --- a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
> +++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
> @@ -31,6 +31,15 @@ device pinctrl register, and 0x118 contains the desired value of the
>  pinctrl register. See the device example and static board pins example
>  below for more information.
>  
> +In case when one register changes more than one pin's mux the
> +pinctrl-single,bits can be used which takes three parameters:
> +
> +	pinctrl-single,bits = <0xdc 0x18, 0xff>;
> +
> +Where 0xdc is the offset from the pinctrl register base address for the
> +device pinctrl register, 0x18 is the desired value, and 0xff is the sub mask to
> +be used when applying this change to the register.
> +

Is it now safe to assume that we always have width of three if
pinctrl-single,bits is specified? The reason I'm asking is..

> @@ -657,18 +664,29 @@ static int pcs_parse_one_pinctrl_entry(struct pcs_device *pcs,
>  {
>  	struct pcs_func_vals *vals;
>  	const __be32 *mux;
> -	int size, rows, *pins, index = 0, found = 0, res = -ENOMEM;
> +	int size, params, rows, *pins, index = 0, found = 0, res = -ENOMEM;
>  	struct pcs_function *function;
>  
> -	mux = of_get_property(np, PCS_MUX_NAME, &size);
> -	if ((!mux) || (size < sizeof(*mux) * 2)) {
> -		dev_err(pcs->dev, "bad data for mux %s\n",
> -			np->name);
> +	mux = of_get_property(np, PCS_MUX_PINS_NAME, &size);
> +	if (mux) {
> +		params = 2;
> +	} else {
> +		mux = of_get_property(np, PCS_MUX_BITS_NAME, &size);
> +		if (!mux) {
> +			dev_err(pcs->dev, "no valid property for %s\n",
> +				np->name);
> +			return -EINVAL;
> +		}
> +		params = 3;
> +	}

..because here we could assume the default value for params is 2
if pinctrl-single,pins is specified, and otherwise params is 3
if pinctrl-single,bits is specified for the controller. That would
avoid querying a potentially non-exiting property for each entry.

> @@ -686,6 +704,10 @@ static int pcs_parse_one_pinctrl_entry(struct pcs_device *pcs,
>  		val = be32_to_cpup(mux + index++);
>  		vals[found].reg = pcs->base + offset;
>  		vals[found].val = val;
> +		if (params == 3) {
> +			val = be32_to_cpup(mux + index++);
> +			vals[found].mask = val;
> +		}
>  
>  		pin = pcs_get_pin_by_offset(pcs, offset);
>  		if (pin < 0) {

Here params too would be then set during probe already.

Other than that, seems to still work for me for my test cases.

Regards,

Tony
