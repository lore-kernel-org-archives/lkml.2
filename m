Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab3AECul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 21:50:41 -0500
Received: from [216.228.121.140] ([216.228.121.140]:16404 "EHLO
	hqemgate03.nvidia.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab3AECuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 21:50:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 04 Jan 2013 18:49:58 -0800
Message-ID: <50E794D0.7040907@nvidia.com>
Date: Sat, 5 Jan 2013 08:19:52 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] clk: Add composite clock type
References: <1357278706-28149-1-git-send-email-pgaikwad@nvidia.com> <50E75538.5010706@codeaurora.org>
In-Reply-To: <50E75538.5010706@codeaurora.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 January 2013 03:48 AM, Stephen Boyd wrote:
> On 01/03/13 21:51, Prashant Gaikwad wrote:
>> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
>> index f0b269a..baf7608 100644
>> --- a/drivers/clk/Makefile
>> +++ b/drivers/clk/Makefile
>> @@ -2,7 +2,8 @@
>>   obj-$(CONFIG_HAVE_CLK)		+= clk-devres.o
>>   obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
>>   obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-fixed-rate.o clk-gate.o \
>> -				   clk-mux.o clk-divider.o clk-fixed-factor.o
>> +				   clk-mux.o clk-divider.o clk-fixed-factor.o \
>> +				   clk-composite.o
> This list is getting a little out of hand. Should we sort it
> alphabetically and put each file on one line?

Do you want me to do it in this patch?

>
>>   # SoCs specific
>>   obj-$(CONFIG_ARCH_BCM2835)	+= clk-bcm2835.o
>>   obj-$(CONFIG_ARCH_NOMADIK)	+= clk-nomadik.o
>> diff --git a/drivers/clk/clk-composite.c b/drivers/clk/clk-composite.c
>> new file mode 100644
>> index 0000000..8634dbf
>> --- /dev/null
>> +++ b/drivers/clk/clk-composite.c
>> @@ -0,0 +1,208 @@
>> +/*
>> + * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms and conditions of the GNU General Public License,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/clk-provider.h>
>> +#include <linux/err.h>
>> +#include <linux/slab.h>
>> +
>> +#define to_clk_composite(_hw) container_of(_hw, struct clk_composite, hw)
>> +
>> +static u8 clk_composite_get_parent(struct clk_hw *hw)
>> +{
>> +	struct clk_composite *composite = to_clk_composite(hw);
>> +	const struct clk_ops *mux_ops = composite->mux_ops;
>> +	struct clk_hw *mux_hw = composite->mux_hw;
>> +
>> +	mux_hw->clk = hw->clk;
> Looks like this is already done down in the register function. Why are
> we doing it again here and in each op?

Some ops gets called during clk_init which is before clk_register returns.


>> +
>> +	return mux_ops->get_parent(mux_hw);
>> +}
> [snip]
>> +struct clk *clk_register_composite(struct device *dev, const char *name,
>> +			const char **parent_names, int num_parents,
>> +			struct clk_hw *mux_hw, const struct clk_ops *mux_ops,
>> +			struct clk_hw *div_hw, const struct clk_ops *div_ops,
>> +			struct clk_hw *gate_hw, const struct clk_ops *gate_ops,
>> +			unsigned long flags)
>> +{
>> +	struct clk *clk;
>> +	struct clk_init_data init;
>> +	struct clk_composite *composite;
>> +	struct clk_ops *clk_composite_ops;
>> +
>> +	composite = kzalloc(sizeof(struct clk_ops), GFP_KERNEL);
> sizeof(*composite) != sizeof(struct clk_ops)

Thanks.

>> +	if (!composite) {
>> +		pr_err("%s: could not allocate composite clk\n", __func__);
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>> +
>> +	init.name = name;
>> +	init.flags = flags | CLK_IS_BASIC;
>> +	init.parent_names = parent_names;
>> +	init.num_parents = num_parents;
>> +
>> +	/* allocate the clock ops */
>> +	clk_composite_ops = kzalloc(sizeof(struct clk_ops), GFP_KERNEL);
> This one looks right though. Perhaps you should change style to use
> sizeof(*clk_composite_ops) so that the above mistake doesn't happen.

Sure.

>> +	if (!clk_composite_ops) {
>> +		pr_err("%s: could not allocate clk ops\n", __func__);
>> +		kfree(composite);
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>> +
>> +	if (mux_hw && mux_ops) {
>> +		if (!mux_ops->get_parent || !mux_ops->set_parent) {
>> +			clk = ERR_PTR(-EINVAL);
>> +			goto err;
>> +		}
>> +
>> +		composite->mux_hw = mux_hw;
>> +		composite->mux_ops = mux_ops;
>> +		clk_composite_ops->get_parent = clk_composite_get_parent;
>> +		clk_composite_ops->set_parent = clk_composite_set_parent;
>> +	}
>> +
>> +	if (div_hw && div_ops) {
>> +		if (!div_ops->recalc_rate || !div_ops->round_rate ||
>> +		    !div_ops->set_rate) {
>> +			clk = ERR_PTR(-EINVAL);
>> +			goto err;
>> +		}
>> +
>> +		composite->div_hw = div_hw;
>> +		composite->div_ops = div_ops;
>> +		clk_composite_ops->recalc_rate = clk_composite_recalc_rate;
>> +		clk_composite_ops->round_rate = clk_composite_round_rate;
>> +		clk_composite_ops->set_rate = clk_composite_set_rate;
>> +	}
>> +
>> +	if (gate_hw && gate_ops) {
>> +		if (!gate_ops->is_enabled || !gate_ops->enable ||
>> +		    !gate_ops->disable) {
>> +			clk = ERR_PTR(-EINVAL);
>> +			goto err;
>> +		}
>> +
>> +		composite->gate_hw = gate_hw;
>> +		composite->gate_ops = gate_ops;
>> +		clk_composite_ops->is_enabled = clk_composite_is_enabled;
>> +		clk_composite_ops->enable = clk_composite_enable;
>> +		clk_composite_ops->disable = clk_composite_disable;
>> +	}
>> +
>> +	init.ops = clk_composite_ops;
>> +	composite->hw.init = &init;
>> +
>> +	clk = clk_register(NULL, &composite->hw);
> Please pass dev here.

Yes.

>> +	if (IS_ERR(clk))
>> +		goto err;
>> +
>> +	if (composite->mux_hw)
>> +		composite->mux_hw->clk = clk;
>> +
>> +	if (composite->div_hw)
>> +		composite->div_hw->clk = clk;
>> +
>> +	if (composite->gate_hw)
>> +		composite->gate_hw->clk = clk;
>> +
>> +	return clk;
>> +
>> +err:
>> +	kfree(clk_composite_ops);
>> +	kfree(composite);
>> +	return clk;
>> +}
>>

