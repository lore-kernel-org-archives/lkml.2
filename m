Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422893Ab2JaNr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:47:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:32874 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935587Ab2JaNrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:47:22 -0400
Message-ID: <50912BCE.5000401@ti.com>
Date: Wed, 31 Oct 2012 09:46:54 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-keystone@list.ti.com>
Subject: Re: [PATCH v3 01/11] clk: davinci - add main PLL clock driver
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com> <1351181518-11882-2-git-send-email-m-karicheri2@ti.com> <509119AE.6050505@ti.com>
In-Reply-To: <509119AE.6050505@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 08:29 AM, Sekhar Nori wrote:
> Hi Murali,
>
> On 10/25/2012 9:41 PM, Murali Karicheri wrote:
>> This is the driver for the main PLL clock hardware found on DM SoCs.
>> This driver borrowed code from arch/arm/mach-davinci/clock.c and
>> implemented the driver as per common clock provider API. The main PLL
>> hardware typically has a multiplier, a pre-divider and a post-divider.
>> Some of the SoCs has the divider fixed meaning they can not be
>> configured through a register. HAS_PREDIV and HAS_POSTDIV flags are used
>> to tell the driver if a hardware has these dividers present or not.
>> Driver is configured through the struct clk_pll_data that has the
>> SoC specific clock data.
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> ---
>> diff --git a/drivers/clk/davinci/clk-pll.c b/drivers/clk/davinci/clk-pll.c
>> +static unsigned long clk_pllclk_recalc(struct clk_hw *hw,
>> +					unsigned long parent_rate)
>> +{
>> +	struct clk_pll *pll = to_clk_pll(hw);
>> +	struct clk_pll_data *pll_data = pll->pll_data;
>> +	u32 mult = 1, prediv = 1, postdiv = 1;
> No need to initialize mult here. I gave this comment last time around as
> well.
Yes. I missed it. I will fix it in the next revision.
>> +	unsigned long rate = parent_rate;
>> +
>> +	mult = readl(pll_data->reg_pllm);
>> +
>> +	/*
>> +	 * if fixed_multiplier is non zero, multiply pllm value by this
>> +	 * value.
>> +	 */
>> +	if (pll_data->fixed_multiplier)
>> +		mult =  pll_data->fixed_multiplier *
>> +				(mult & pll_data->pllm_mask);
>> +	else
>> +		mult = (mult & pll_data->pllm_mask) + 1;
> Hmm, this is interpreting the 'mult' register field differently in both
> cases. In one case it is 'actual multiplier - 1' and in other case it is
> the 'actual multiplier' itself. Can we be sure that the mult register
> definition will change whenever there is a fixed multiplier in the PLL
> block? I don't think any of the existing DaVinci devices have a fixed
> multiplier. Is this on keystone?
Read section 6.4.3 (PLL Mode) in DM365 documentation (SPRUFG5a.pdf) that 
states PLL multiplies the clock by 2x the value in the PLLM. In the old 
code this is handled by a if cpu_is_* macro that we can't use in the 
driver. So this is represented by a fixed_multiplier that can be set to 
2 for DM365 and zero on other SoCs.
>> +struct clk *clk_register_davinci_pll(struct device *dev, const char *name,
>> +			const char *parent_name,
>> +			struct clk_pll_data *pll_data)
>> +{
>> +	struct clk_init_data init;
>> +	struct clk_pll *pll;
>> +	struct clk *clk;
>> +
>> +	if (!pll_data)
>> +		return ERR_PTR(-ENODEV);
> -EINVAL? Clearly you are treating NULL value as an invalid argument here.
Ok. Will fix to ERR_PTR(-EINVAL).
>
> Thanks,
> Sekhar
>

