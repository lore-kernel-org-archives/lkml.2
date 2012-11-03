Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab2KCMEa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 08:04:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57429 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004Ab2KCME1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 08:04:27 -0400
Message-ID: <50950820.3050505@ti.com>
Date: Sat, 3 Nov 2012 17:33:44 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>
CC: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-keystone@list.ti.com>
Subject: Re: [PATCH v3 04/11] clk: davinci - add pll divider clock driver
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com> <1351181518-11882-5-git-send-email-m-karicheri2@ti.com> <5093AF8A.8000707@ti.com> <5093D070.7060900@ti.com>
In-Reply-To: <5093D070.7060900@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/2012 7:23 PM, Murali Karicheri wrote:
> On 11/02/2012 07:33 AM, Sekhar Nori wrote:
>> On 10/25/2012 9:41 PM, Murali Karicheri wrote:
>>
>>> pll dividers are present in the pll controller of DaVinci and Other
>>> SoCs that re-uses the same hardware IP. This has a enable bit for
>>> bypass the divider or enable the driver. This is a sub class of the
>>> clk-divider clock checks the enable bit to calculare the rate and
>>> invoke the recalculate() function of the clk-divider if enabled.
>>>
>>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>>> ---

>>> +/**
>>> + * clk_register_davinci_plldiv - register function for DaVinci PLL
>>> divider clk
>>> + *
>>> + * @dev: device ptr
>>> + * @name: name of the clock
>>> + * @parent_name: name of parent clock
>>> + * @plldiv_data: ptr to pll divider data
>>> + * @lock: ptr to spinlock passed to divider clock
>>> + */
>>> +struct clk *clk_register_davinci_plldiv(struct device *dev,
>> Why do you need a dev pointer here and which device does it point to? In
>> the only usage of this API in the series, you pass a NULL here. I should
>> have probably asked this question on one of the earlier patches itself.
>>
> I did a grep in the drivers/clk directory. All of the platform drivers
> are having the device ptr and all of them are called with NULL. I am not
> sure what is the intent of this arg in the API.  As per documentation of

I just took a look at the mxs example you referenced below and it does
not take a dev pointer.

struct clk *mxs_clk_div(const char *name, const char *parent_name,
                        void __iomem *reg, u8 shift, u8 width, u8 busy)
{

> the clk_register() API, the device ptr points to the device that is
> registering this clk. So if a specific device driver ever has to
> register a PLL div clk, this will be non NULL. In  the normal use case,
> clk is registered in a platform specific code and is always passed NULL.
> 
> The platform/SoC specific clock initialization code will be using
> davinci_plldiv_clk() that doesn't have a device ptr arg.
> So this can be changed in future in sync with other drivers (assuming
> this will get removed if unused), and changes
> doesn't impact the platform code that initialize the clock. So IMO, we
> should keep this arg so that it is in sync with other driver APIs.

I think you should get rid of this unused arg and introduce it when you
actually need it. That way we are clear about why we need it.

> 
> +            const char *name, const char *parent_name,
> +            struct clk_plldiv_data *plldiv_data,
> +            spinlock_t *lock)
> +{
> +    struct clk_div *div;
> +    struct clk *clk;
> +    struct clk_init_data init;
> +
> +    div = kzalloc(sizeof(*div), GFP_KERNEL);
> +    if (!div)
> +        return ERR_PTR(-ENOMEM);
> +
> +    init.name = name;
> +    init.ops = &clk_div_ops;
> +    init.flags = plldiv_data->flags;
> +    init.parent_names = (parent_name ? &parent_name : NULL);
> +    init.num_parents = (parent_name ? 1 : 0);
> +
> +    div->reg = plldiv_data->reg;
> +    div->en_id = plldiv_data->en_id;
> +
> +    div->divider.reg = plldiv_data->reg;
> +    div->divider.shift = plldiv_data->shift;
> +    div->divider.width = plldiv_data->width;
> +    div->divider.flags = plldiv_data->divider_flags;
> +    div->divider.lock = lock;
> +    div->divider.hw.init = &init;
> +    div->ops = &clk_divider_ops;
> +
> +    clk = clk_register(NULL, &div->divider.hw);
> 
>> Shouldn't you be calling clk_register_divider() here which in turn will
>> do clk_register()?
> As stated in the top of the file, this is a subclass driver of clk-div
> similar in line with mxs/clk-div.c. The
> driver registers the clock instead of calling clk_register_divider() so
> that it's ops function has a chance to do whatever it wants to do and
> call the divider ops function after that.

I see that now. I should have paid more attention.

Regards,
Sekhar
