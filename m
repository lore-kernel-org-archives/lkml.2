Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab2EDBMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 21:12:32 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12765 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600Ab2EDBMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 21:12:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6700"; a="185201001"
Message-ID: <4FA32CDC.3070005@codeaurora.org>
Date: Thu, 03 May 2012 18:11:56 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Paul Walmsley <paul@pwsan.com>, Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH] clk: Use a separate struct for holding init data.
References: <1335419936-10881-1-git-send-email-skannan@codeaurora.org> <20120503230308.GA13016@glitch>
In-Reply-To: <20120503230308.GA13016@glitch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 04:03 PM, Domenico Andreoli wrote:
> On Wed, Apr 25, 2012 at 10:58:56PM -0700, Saravana Kannan wrote:
>>
>> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
>> index 90627e4..8ea11b4 100644
>> --- a/drivers/clk/clk-divider.c
>> +++ b/drivers/clk/clk-divider.c
>> @@ -167,6 +167,7 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
>>   {
>>   	struct clk_divider *div;
>>   	struct clk *clk;
>> +	struct clk_init_data init;
>>
>>   	/* allocate the divider */
>>   	div = kzalloc(sizeof(struct clk_divider), GFP_KERNEL);
>> @@ -175,19 +176,22 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
>>   		return ERR_PTR(-ENOMEM);
>>   	}
>>
>> +	init.name = name;
>> +	init.ops =&clk_divider_ops;
>> +	init.flags = flags;
>> +	init.parent_names = (parent_name ?&parent_name: NULL);
>> +	init.num_parents = (parent_name ? 1 : 0);
>> +
>>   	/* struct clk_divider assignments */
>>   	div->reg = reg;
>>   	div->shift = shift;
>>   	div->width = width;
>>   	div->flags = clk_divider_flags;
>>   	div->lock = lock;
>> +	div->hw.init =&init;
>>
>>   	/* register the clock */
>> -	clk = clk_register(dev, name,
>> -			&clk_divider_ops,&div->hw,
>> -			(parent_name ?&parent_name: NULL),
>> -			(parent_name ? 1 : 0),
>> -			flags);
>> +	clk = clk_register(dev,&div->hw);
>>
>>   	if (IS_ERR(clk))
>>   		kfree(div);
>
> I would prefer to rip the parent _settings_ configuration out of
> clk_register(). It's optional right? And passing a single parent is a
> common case.
>
> Three cases:
>
>    1) one parent:
>       __clk_register_parent(clk, parent_name);
>       clk_register(dev, name,&ops, flags);
>
>    2) many parents:
>       __clk_register_parents(clk, parent_names, num_parents);
>       clk_register(dev, name,&ops, flags);
>
>    3) no parents:
>       clk_register(dev, name,&ops, flags);
>
> You may also want to move the whole parent initialization into
> __clk_register_parents() and call it after clk_register(), it would
> simplify some error paths.
>
> This pattern could be used also with other common clocks registration
> functions (fixed rate, divider, mux, etc) that may have complex
> initializations and/or optional parameters that cannot go all on the
> same function call.

Please no. If anything, make those other register functions go in the 
direction of clk_register(). Have a long list of params to a function 
and then having it fill up a structure just makes the code less 
readable. Why would that be any better than having the whole structure 
statically declared or the whole structure dynamically populated (by 
device tree) and then calling clk_register()?

Take about 50 clocks with 3 parents each and try to register them in the 
way you suggested and in a way how clk_register() in this patch will 
need you to declare them statically. Compare the two and see which would 
be more readable.

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
