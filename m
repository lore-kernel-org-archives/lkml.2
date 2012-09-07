Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab2IGPNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:13:25 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:52900 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753293Ab2IGPNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:13:22 -0400
Message-ID: <504A0F21.8080305@ti.com>
Date: Fri, 07 Sep 2012 18:13:37 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120903 Thunderbird/15.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/2] pinctrl: pinctrl-single: Add pinctrl-single,bits
 type of mux
References: <1346835718-21325-1-git-send-email-peter.ujfalusi@ti.com> <1346835718-21325-3-git-send-email-peter.ujfalusi@ti.com> <20120906191019.GZ1303@atomide.com>
In-Reply-To: <20120906191019.GZ1303@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 09/06/2012 10:10 PM, Tony Lindgren wrote:
> Hi Peter,
> 
> * Peter Ujfalusi <peter.ujfalusi@ti.com> [120905 02:02]:
>> With pinctrl-single,bits it is possible to update just part of the register
>> within the pinctrl-single,function-mask area.
>> This is useful when one register configures mmore than one pin's mux.
> 
> You have a typo here:                         ^^^^^

Oh, I'll fix this up.

>> --- a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
>> +++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
>> @@ -31,6 +31,15 @@ device pinctrl register, and 0x118 contains the desired value of the
>>  pinctrl register. See the device example and static board pins example
>>  below for more information.
>>  
>> +In case when one register changes more than one pin's mux the
>> +pinctrl-single,bits can be used which takes three parameters:
>> +
>> +	pinctrl-single,bits = <0xdc 0x18, 0xff>;
>> +
>> +Where 0xdc is the offset from the pinctrl register base address for the
>> +device pinctrl register, 0x18 is the desired value, and 0xff is the sub mask to
>> +be used when applying this change to the register.
>> +
> 
> Is it now safe to assume that we always have width of three if
> pinctrl-single,bits is specified? The reason I'm asking is..
> 
>> @@ -657,18 +664,29 @@ static int pcs_parse_one_pinctrl_entry(struct pcs_device *pcs,
>>  {
>>  	struct pcs_func_vals *vals;
>>  	const __be32 *mux;
>> -	int size, rows, *pins, index = 0, found = 0, res = -ENOMEM;
>> +	int size, params, rows, *pins, index = 0, found = 0, res = -ENOMEM;
>>  	struct pcs_function *function;
>>  
>> -	mux = of_get_property(np, PCS_MUX_NAME, &size);
>> -	if ((!mux) || (size < sizeof(*mux) * 2)) {
>> -		dev_err(pcs->dev, "bad data for mux %s\n",
>> -			np->name);
>> +	mux = of_get_property(np, PCS_MUX_PINS_NAME, &size);
>> +	if (mux) {
>> +		params = 2;
>> +	} else {
>> +		mux = of_get_property(np, PCS_MUX_BITS_NAME, &size);
>> +		if (!mux) {
>> +			dev_err(pcs->dev, "no valid property for %s\n",
>> +				np->name);
>> +			return -EINVAL;
>> +		}
>> +		params = 3;
>> +	}
> 
> ..because here we could assume the default value for params is 2
> if pinctrl-single,pins is specified, and otherwise params is 3
> if pinctrl-single,bits is specified for the controller. That would
> avoid querying a potentially non-exiting property for each entry.
> 
>> @@ -686,6 +704,10 @@ static int pcs_parse_one_pinctrl_entry(struct pcs_device *pcs,
>>  		val = be32_to_cpup(mux + index++);
>>  		vals[found].reg = pcs->base + offset;
>>  		vals[found].val = val;
>> +		if (params == 3) {
>> +			val = be32_to_cpup(mux + index++);
>> +			vals[found].mask = val;
>> +		}
>>  
>>  		pin = pcs_get_pin_by_offset(pcs, offset);
>>  		if (pin < 0) {
> 
> Here params too would be then set during probe already.

I'm afraid you lost me here...
We only know if the user specified the mux configuration with
pinctrl-single,pins or  pinctrl-single,bits in this function.

One thing I could do to make the code a bit better to look at is:
int params = 2;

mux = of_get_property(np, PCS_MUX_PINS_NAME, &size);
if (!mux) {
	mux = of_get_property(np, PCS_MUX_BITS_NAME, &size);
	if (!mux) {
		dev_err(pcs->dev, "no valid property for %s\n",
		np->name);
		return -EINVAL;
	}
	params = 3;
}

This might make the code a bit more compact but at the same time one might
need to spend few more seconds to understand it.

Regards,
Péter
