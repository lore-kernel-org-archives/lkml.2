Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab2DRTf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 15:35:57 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15370 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab2DRTfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 15:35:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 18 Apr 2012 12:35:55 -0700
Subject: Re: [PATCH 3/4] mfd: tps65910: Add device-tree support
From: Rhyland Klein <rklein@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
In-Reply-To: <20120418090133.GC3021@opensource.wolfsonmicro.com>
References: <1334710829-22777-1-git-send-email-rklein@nvidia.com>
	 <1334710829-22777-4-git-send-email-rklein@nvidia.com>
	 <20120418090133.GC3021@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Apr 2012 12:35:58 -0700
Message-ID: <1334777758.32315.37.camel@rklein-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-18 at 02:01 -0700, Mark Brown wrote:
> * PGP Signed by an unknown key
> 
> On Tue, Apr 17, 2012 at 06:00:28PM -0700, Rhyland Klein wrote:
> > Add device tree based initialization support for TI's tps65910 pmic.
> 
> Actually, now I look at the larger patch this probably wants to be split
> up by driver and possibly split further within that.
> 
> > +	board_data = tps65910->board_data;
> > +	if (board_data->use_dt_for_init_data && tps65910->dev->of_node)
> > +		ret = tps65910_gpio_parse_dt(tps65910->dev, board_data);
> > +
> 
> This is a really odd idiom - normally the pattern for device tree
> support is to just go and try to use the device tree data if it's there
> and there's no need for any flag to say if it should be used.
> 

I agree its odd. My concern was that the idiom is that is pdata assigned
from board files should override dt data. At this point, we don't know
where the tps65910->board_data is coming from, dt or board files.
Arbitrarily using dt breaks that idiom. We could do a check like this if
you prefer:

if (!(dev_get_platdata(tps65910->dev) && tps65910->dev->of_node)

i.e. if doesn't have pdata supplied from board files, but does have dt
node. 


> > +	if (pdata->irq_base <= 0)
> > +		pdata->irq_base = irq_alloc_descs(-1, 0, tps65910->irq_num, -1);
> > +
> > +	if (pdata->irq_base <= 0) {
> > +		dev_err(tps65910->dev, "Failed to allocate irq descs: %d\n",
> > +			pdata->irq_base);
> > +		return pdata->irq_base;
> > +	}
> > +
> > +	tps65910->irq_mask = 0xFFFFFF;
> > +
> > +	mutex_init(&tps65910->irq_lock);
> > +	tps65910->chip_irq = irq;
> > +	tps65910->irq_base = pdata->irq_base;
> 
> While this is needed for DT support it can be done separately and would
> probably be better split out into a separate patch.
> 

ok.

> > +	/* Pass of data to child devices */
> > +	for (idx = 0; idx < ARRAY_SIZE(tps65910s); idx++) {
> > +		tps65910s[idx].platform_data = pmic_plat_data;
> > +		tps65910s[idx].pdata_size = sizeof(*pmic_plat_data);
> > +	}
> 
> Why is this needed - can't the DT parsing just be moved where it's used?

> 
> > +	for_each_child_of_node(regulators, child) {
> > +		struct regulator_init_data *init_data;
> > +
> > +		init_data = of_get_regulator_init_data(&pdev->dev, child);
> > +		if (!init_data) {
> > +			dev_err(&pdev->dev,
> > +				"failed to parse DT for regulator %s\n",
> > +				child->name);
> > +			return -EINVAL;
> > +		}
> > +
> > +		for (idx = 0; idx < pmic->num_regulators; idx++) {
> 
> Hrm, this iteration over a group of regulators to find the relevant
> node by name is going to be a fairly common pattern (there's already
> at least one driver doing this IIRC) - we should really factor it out
> into common code.  Please consider doing this when you resubmit.

Ok.

> 
> > +			if (!strcasecmp(info[idx].name, child->name)) {
> > +				if (all_data[idx]) {
> > +					dev_err(&pdev->dev,
> > +						"Duplicate Regulator Node %s\n",
> 
> Please fix the capitalisation in the error message.
> 
> > +		/* Check to see if we iterated without finding its name */
> > +		if (idx == pmic->num_regulators) {
> > +			dev_err(&pdev->dev,
> > +				"Unknown regulator node found [%s]\n",
> > +				child->name);
> > +			return -EINVAL;
> > +		}
> 
> It'd seem more robust to only print the warning and not return the
> error, that way we don't completely fail the device initialisation if
> there's data we don't understand.
> 
> I'm also not seeing a change here that passes the DT node to
> regulator_register() - you should be doing that, it's needed so
> consumers can bind to the regulator.

> * Unknown Key
> * 0x6E30FDDD

Thanks,

rhyland

