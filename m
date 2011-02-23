Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab1BWNSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 08:18:20 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:48844 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab1BWNSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 08:18:18 -0500
Message-ID: <4D650917.8000201@wytron.com.tw>
Date: Wed, 23 Feb 2011 21:18:15 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ben Dooks <ben-i2c@fluff.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Ben Dooks <ben-linux@fluff.org>,
        linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org,
        Albert Herranz <albert_herranz@yahoo.es>
Subject: Re: [PATCH v5] i2c-gpio: add devicetree support
References: <1297304967-3759-1-git-send-email-thomas@wytron.com.tw> <1297650610-12400-1-git-send-email-thomas@wytron.com.tw> <20110223011232.GC15795@trinity.fluff.org>
In-Reply-To: <20110223011232.GC15795@trinity.fluff.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.250
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On 02/23/2011 09:12 AM, Ben Dooks wrote:
> On Mon, Feb 14, 2011 at 10:30:10AM +0800, Thomas Chou wrote:
>> From: Albert Herranz<albert_herranz@yahoo.es>
>>
>> This patch adds devicetree support to i2c-gpio driver. The allocation
>> of local data is integrated to a private structure, and use devm_*
>> helper for easy cleanup.
>>
>> It is base on an earlier patch for gc-linux from
>> Albert Herranz<albert_herranz@yahoo.es>.
>>
>> Signed-off-by: Thomas Chou<thomas@wytron.com.tw>
>> CC: Albert Herranz<albert_herranz@yahoo.es>
>> Acked-by: Haavard Skinnemoen<hskinnemoen@gmail.com>
>> ---
>> for v2.6.39
>> v2 move of nodes probing to a hook, which will be optimized out
>>       when devicetree is not used.
>>     use linux/gpio.h.
>>     move binding doc to i2c/i2c-gpio.txt.
>> v3 use speed-hz instead of udelay in dts binding.
>>     condition the devicetree probe.
>> v4 simplify private allocation.
>> v5 condition module device table export for of.
>>

>> +/* Check if devicetree nodes exist and build platform data */
>> +static int i2c_gpio_of_probe(struct platform_device *pdev,
>> +			     struct i2c_gpio_platform_data *pdata)
>> +{
>> +	struct device_node *np = pdev->dev.of_node;
>> +	const __be32 *prop;
>> +	int sda_pin, scl_pin;
>> +	int len;
>> +
>> +	if (!np || of_gpio_count(np)<  2)
>> +		return -ENXIO;
>
> Would prefer to see different return code, most bus probe functions
> tend to drop these without signalling to the user as they assume the
> device was either never there or totally faulty.
>
>> +	sda_pin = of_get_gpio_flags(np, 0, NULL);
>> +	scl_pin = of_get_gpio_flags(np, 1, NULL);
>> +	if (sda_pin<  0 || scl_pin<  0) {
>> +		pr_err("%s: invalid GPIO pins, sda=%d/scl=%d\n",
>> +		       np->full_name, sda_pin, scl_pin);
>> +		return -ENXIO;
>> +	}
>
> see same as above.
>
>> +	pdata->sda_pin = sda_pin;
>> +	pdata->scl_pin = scl_pin;
>> +	prop = of_get_property(np, "sda-is-open-drain", NULL);
>> +	if (prop)
>> +		pdata->sda_is_open_drain = 1;
>> +	prop = of_get_property(np, "scl-is-open-drain", NULL);
>> +	if (prop)
>> +		pdata->scl_is_open_drain = 1;
>> +	prop = of_get_property(np, "scl-is-output-only", NULL);
>> +	if (prop)
>> +		pdata->scl_is_output_only = 1;
>> +	prop = of_get_property(np, "speed-hz",&len);
>> +	if (prop&&  len>= sizeof(__be32))
>> +		pdata->udelay = DIV_ROUND_UP(1000000, be32_to_cpup(prop) * 2);
>> +	prop = of_get_property(np, "timeout",&len);
>> +	if (prop&&  len>= sizeof(__be32))
>> +		pdata->timeout = msecs_to_jiffies(be32_to_cpup(prop));
>> +
>> +	return 0;
>> +}
>> +#else
>> +static int i2c_gpio_of_probe(struct platform_device *pdev,
>> +			     struct i2c_gpio_platform_data *pdata)
>> +{
>> +	return -ENXIO;
>> +}
>
> might be valid here, however can we make this NULL if no support?
>

Thanks. How about return NULL if no support, and return pdata if support?

- Thomas
