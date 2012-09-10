Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab2IJLzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 07:55:00 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:59475 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752609Ab2IJLy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 07:54:56 -0400
Message-ID: <504DD532.4040400@ti.com>
Date: Mon, 10 Sep 2012 14:55:30 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120903 Thunderbird/15.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/2] pinctrl: pinctrl-single: Add pinctrl-single,bits
 type of mux
References: <1346835718-21325-1-git-send-email-peter.ujfalusi@ti.com> <1346835718-21325-3-git-send-email-peter.ujfalusi@ti.com> <20120906191019.GZ1303@atomide.com> <504A0F21.8080305@ti.com> <20120907165553.GV1303@atomide.com>
In-Reply-To: <20120907165553.GV1303@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 07:55 PM, Tony Lindgren wrote:
> * Peter Ujfalusi <peter.ujfalusi@ti.com> [120907 08:13]:
>> On 09/06/2012 10:10 PM, Tony Lindgren wrote:
>>>
>>> Is it now safe to assume that we always have width of three if
>>> pinctrl-single,bits is specified? The reason I'm asking is..
>>>
>>>> @@ -657,18 +664,29 @@ static int pcs_parse_one_pinctrl_entry(struct pcs_device *pcs,
>>>>  {
>>>>  	struct pcs_func_vals *vals;
>>>>  	const __be32 *mux;
>>>> -	int size, rows, *pins, index = 0, found = 0, res = -ENOMEM;
>>>> +	int size, params, rows, *pins, index = 0, found = 0, res = -ENOMEM;
>>>>  	struct pcs_function *function;
>>>>  
>>>> -	mux = of_get_property(np, PCS_MUX_NAME, &size);
>>>> -	if ((!mux) || (size < sizeof(*mux) * 2)) {
>>>> -		dev_err(pcs->dev, "bad data for mux %s\n",
>>>> -			np->name);
>>>> +	mux = of_get_property(np, PCS_MUX_PINS_NAME, &size);
>>>> +	if (mux) {
>>>> +		params = 2;
>>>> +	} else {
>>>> +		mux = of_get_property(np, PCS_MUX_BITS_NAME, &size);
>>>> +		if (!mux) {
>>>> +			dev_err(pcs->dev, "no valid property for %s\n",
>>>> +				np->name);
>>>> +			return -EINVAL;
>>>> +		}
>>>> +		params = 3;
>>>> +	}
>>>
>>> ..because here we could assume the default value for params is 2
>>> if pinctrl-single,pins is specified, and otherwise params is 3
>>> if pinctrl-single,bits is specified for the controller. That would
>>> avoid querying a potentially non-exiting property for each entry.
>>>
>>>> @@ -686,6 +704,10 @@ static int pcs_parse_one_pinctrl_entry(struct pcs_device *pcs,
>>>>  		val = be32_to_cpup(mux + index++);
>>>>  		vals[found].reg = pcs->base + offset;
>>>>  		vals[found].val = val;
>>>> +		if (params == 3) {
>>>> +			val = be32_to_cpup(mux + index++);
>>>> +			vals[found].mask = val;
>>>> +		}
>>>>  
>>>>  		pin = pcs_get_pin_by_offset(pcs, offset);
>>>>  		if (pin < 0) {
>>>
>>> Here params too would be then set during probe already.
>>
>> I'm afraid you lost me here...
>> We only know if the user specified the mux configuration with
>> pinctrl-single,pins or  pinctrl-single,bits in this function.
> 
> Sorry right, yeah we don't know that at probe time currently.
> 
> I'd like to have something that specifies the controller type so
> we don't need to mix two types of controllers and test for
> non-existing properties when parsing the pins.
> 
> How about we require something specified for the pinctrl driver
> in the "one-bit-per-mux" case like pinctrl-single,bit-per-mux?
> 
> And then in the pinctrl-single probe we set params = 3 if
> pinctrl-single,bit-per-mux is specified. And if no
> pinctrl-single,bit-per-mux is specified then set params = 2.
> 
> That way pcs_parse_one_pinctrl_entry() can just test for params.
> 
> Sorry I don't have a better name in mind than bit-per-mux..

I'm not sure if this would make things more prone to error or make the DTS or
the code more clean in any ways.

Both pinctrl-single,pins and pinctrl-single,bits works on top of the same
pinctrl-single area.
In most cases we are going to use pinctrl-single,pins for the mux
configuration and only in few places we need to fall back to pinctrl-single,bits.

With this patch we will have maximum of two query to find out which type is
used, while if we add the 'bit-per-mux' property we will always have need to
have two of_get_property() call to figure out what is used.
IMHO in this way we could also have copy-paste errors coming at us when adding
the mux configurations for the pins and at the end we also need to do same
safety/sanity checks if the user really provided the correct type with
correlation to the 'bit-per-mux'.

This would just complicate the code.
The existence of pinctrl-single,pins or pinctrl-single,bits property alone
gives enough information for the number of parameters.

>  
>> One thing I could do to make the code a bit better to look at is:
>> int params = 2;
>>
>> mux = of_get_property(np, PCS_MUX_PINS_NAME, &size);
>> if (!mux) {
>> 	mux = of_get_property(np, PCS_MUX_BITS_NAME, &size);
>> 	if (!mux) {
>> 		dev_err(pcs->dev, "no valid property for %s\n",
>> 		np->name);
>> 		return -EINVAL;
>> 	}
>> 	params = 3;
>> }
>>
>> This might make the code a bit more compact but at the same time one might
>> need to spend few more seconds to understand it.
> 
> Yes well there's no need to do of_get_property second guessing
> if we already know params from the pinctrl-single.c probe time.
> 
> I think we're safe to assume that we don't need to mix parsing
> two different types of configuration for the same controller
> as they can always be set up as separate controllers.
> 
> Regards,
> 
> Tony
> 


-- 
Péter
