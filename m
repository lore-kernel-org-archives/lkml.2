Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab2F2Iem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 04:34:42 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3521 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab2F2Ieh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 04:34:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 29 Jun 2012 01:34:29 -0700
Message-ID: <4FED688E.9090408@nvidia.com>
Date: Fri, 29 Jun 2012 14:04:22 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@ti.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH 4/6] ARM: tegra: Add clk_tegra structure and helper functions
References: <1340879846-12900-1-git-send-email-pgaikwad@nvidia.com> <1340879846-12900-5-git-send-email-pgaikwad@nvidia.com> <20120628182759.GA28424@gmail.com>
In-Reply-To: <20120628182759.GA28424@gmail.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 June 2012 11:58 PM, Mike Turquette wrote:
> On 20120628-16:07, Prashant Gaikwad wrote:
>> Add Tegra platform specific clock structure clk_tegra and
>> some helper functions for generic clock framework.
>>
>> struct clk_tegra is the single strcture used for all types of
>> clocks. reset and cfg_ex ops moved to clk_tegra from clk_ops.
>>
>> Signed-off-by: Prashant Gaikwad<pgaikwad@nvidia.com>
> Hi Prashant,
>
> I'm happy to see Tegra getting ported over to the common clk framework.

Thanks Mike!! It will help to get in-line with recent developments.

> <snip>
>> +void tegra_clk_add(struct clk *clk)
>> +{
>> +	struct clk_tegra *c = to_clk_tegra(__clk_get_hw(clk));
>> +
>> +	mutex_lock(&clock_list_lock);
>> +	list_add(&c->node,&clocks);
>> +	mutex_unlock(&clock_list_lock);
>> +}
>> +
>> +struct clk *tegra_get_clock_by_name(const char *name)
>> +{
>> +	struct clk_tegra *c;
>> +	struct clk *ret = NULL;
>> +	mutex_lock(&clock_list_lock);
>> +	list_for_each_entry(c,&clocks, node) {
>> +		if (strcmp(__clk_get_name(c->hw.clk), name) == 0) {
>> +			ret = c->hw.clk;
>> +			break;
>> +		}
>> +	}
>> +	mutex_unlock(&clock_list_lock);
>> +	return ret;
>> +}
>> +
> Are you planning to continue using an internal list of struct clk_tegra?
> OMAP had a similar list for the legacy clock framework but that was
> since removed and now lookups are done solely through clkdev.

No, will move to clkdev later.

> <snip>
>> +void tegra_periph_reset_deassert(struct clk *c)
>> +{
>> +	struct clk_tegra *clk = to_clk_tegra(__clk_get_hw(c));
>> +	BUG_ON(!clk->reset);
>> +	clk->reset(__clk_get_hw(c), false);
>> +}
>> +EXPORT_SYMBOL(tegra_periph_reset_deassert);
>> +
>> +void tegra_periph_reset_assert(struct clk *c)
>> +{
>> +	struct clk_tegra *clk = to_clk_tegra(__clk_get_hw(c));
>> +	BUG_ON(!clk->reset);
>> +	clk->reset(__clk_get_hw(c), true);
>> +}
>> +EXPORT_SYMBOL(tegra_periph_reset_assert);
>> +
>> +/* Several extended clock configuration bits (e.g., clock routing, clock
>> + * phase control) are included in PLL and peripheral clock source
>> + * registers. */
>> +int tegra_clk_cfg_ex(struct clk *c, enum tegra_clk_ex_param p, u32 setting)
>> +{
>> +	int ret = 0;
>> +	struct clk_tegra *clk = to_clk_tegra(__clk_get_hw(c));
>> +
>> +	if (!clk->clk_cfg_ex) {
>> +		ret = -ENOSYS;
>> +		goto out;
>> +	}
>> +	ret = clk->clk_cfg_ex(__clk_get_hw(c), p, setting);
>> +
>> +out:
>> +	return ret;
>> +}
> We had some discussions in the past on your clock reset and external
> line request operations which you've had to put into struct clk_tegra.
>
> Do you need to expose those ops to code in drivers/*?  I consider that a
> reasonable litmus test to start considering if something should be moved
> into the generic clk.h api.

Yes, we need these ops in drivers. Peter has sent a patch proposing to 
move these ops to generic clk.

In addition, we also need mechanism/ops to change rate and parent from 
clk_ops implementation. There was some discussion but I do not know the 
latest status.

> <snip>
>> +enum clk_state {
>> +	UNINITIALIZED = 0,
>> +	ON,
>> +	OFF,
>> +};
> How is clk_state used?  Might it be helpful to you if that was in the
> generic code in drivers/clk/clk.c?

clk_state is used to store the clock state. I am planning to remove this 
since is_enabled ops should work.

> <snip>
>> +struct clk_tegra {
>> +	/* node for master clocks list */
>> +	struct list_head	node;	/* node for list of all clocks */
>> +	struct clk_lookup	lookup;
>> +	struct clk_hw		hw;
>> +
>> +	bool			set;
>> +	unsigned long		fixed_rate;
>> +	unsigned long		max_rate;
>> +	unsigned long		min_rate;
>> +	u32			flags;
>> +	const char		*name;
>> +
>> +	enum clk_state		state;
>> +	u32			div;
>> +	u32			mul;
>> +
>> +	u32				reg;
>> +	u32				reg_shift;
>> +
>> +	struct list_head		shared_bus_list;
>> +
>> +	union {
>> +		struct {
>> +			unsigned int			clk_num;
>> +		} periph;
>> +		struct {
>> +			unsigned long			input_min;
>> +			unsigned long			input_max;
>> +			unsigned long			cf_min;
>> +			unsigned long			cf_max;
>> +			unsigned long			vco_min;
>> +			unsigned long			vco_max;
>> +			const struct clk_pll_freq_table	*freq_table;
>> +			int				lock_delay;
>> +			unsigned long			fixed_rate;
>> +		} pll;
>> +		struct {
>> +			u32				sel;
>> +			u32				reg_mask;
>> +		} mux;
>> +		struct {
>> +			struct clk			*main;
>> +			struct clk			*backup;
>> +		} cpu;
>> +		struct {
>> +			struct list_head		node;
>> +			bool				enabled;
>> +			unsigned long			rate;
>> +		} shared_bus_user;
>> +	} u;
>> +
>> +	void (*reset)(struct clk_hw *, bool);
>> +	int (*clk_cfg_ex)(struct clk_hw *, enum tegra_clk_ex_param, u32);
>> +};
> I know this is an initial effort but I hope in time that struct
> clk_tegra can be broken up into separate clk types.  It would be even
> better if some of the Tegra clocks code be converted over to the common
> clk types in drivers/clk/clk-*.c

Yes, that is next in my action list. One approach I am working on is to 
model the clock as Mux -> Divider -> Gate by which we can use some of 
common clock types.
But this will take time.

> Regards,
> Mike

