Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab2JBVZC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:25:02 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53577 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2JBVY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:24:59 -0400
Date: Tue, 2 Oct 2012 17:25:23 -0400
From: Matt Porter <mporter@ti.com>
To: Omar Ramirez Luna <omar.luna@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Russell King <linux@arm.linux.org.uk>, Rajendra Nayak <rnayak@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 8/9] ARM: OMAP: iommu: add device tree support
Message-ID: <20121002212523.GA11180@beef>
References: <1347479152-588-1-git-send-email-omar.luna@linaro.org>
 <1347479152-588-9-git-send-email-omar.luna@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347479152-588-9-git-send-email-omar.luna@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 02:45:51PM -0500, Omar Ramirez Luna wrote:
> Adapt driver to use DT if provided.

Hi Omar,

I'm interested in making use of the assert/deassert APIs you exposed in
this series on AM335x for the pruss hwmod which has one hardreset
line. I have the same situation where I need to get it deasserted before
I do any runtime PM. See my comments below...

> +static int __devinit
> +iommu_add_platform_data_from_dt(struct platform_device *pdev)
> +{
> +	struct iommu_platform_data *pdata;
> +	struct device_node *node = pdev->dev.of_node;
> +	struct omap_hwmod *oh;
> +	struct omap_mmu_dev_attr *a;
> +	int ret = 0;
> +
> +	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		return -ENOMEM;
> +
> +	of_property_read_string(node, "ti,hwmods", &pdata->name);
> +	oh = omap_hwmod_lookup(pdata->name);
> +	if (!oh) {
> +		dev_err(&pdev->dev, "Cannot lookup hwmod '%s'\n", pdata->name);
> +		ret = -ENODEV;
> +		goto out;
> +	}
> +
> +	a = (struct omap_mmu_dev_attr *)oh->dev_attr;
> +	pdata->nr_tlb_entries = a->nr_tlb_entries;
> +	pdata->da_start = a->da_start;
> +	pdata->da_end = a->da_end;
> +
> +	if (oh->rst_lines_cnt == 1) {
> +		pdata->reset_name = oh->rst_lines->name;
> +		pdata->assert_reset = omap_device_assert_hardreset;
> +		pdata->deassert_reset = omap_device_deassert_hardreset;
> +	}
> +
> +	ret = platform_device_add_data(pdev, pdata, sizeof(*pdata));
> +	if (ret)
> +		dev_err(&pdev->dev, "Cannot add pdata for %s\n", pdata->name);
> +
> +out:
> +	kfree(pdata);
> +
> +	return ret;
> +}

I can see why you went this path with the iommu driver as it already had
some integration code present here. I have some concerns going forward
about how this should be long-term. Take any platform booting only with
DT populated, we'd like to avoid having to use this approach where
platform private APIs are called via pdata. In fact, it's going to makes
thing ugly to carry any sort of pdata for a driver that's otherwise
driven exclusively from DT.

For AM335x, I can implement this approach, but it means adding some
pruss specific integration code just to have it create the pdata for
reset_name and assert/deassert.

>From reading all the threads on hardresets and OMAP, it seems we may not
be able to come up with a generic OMAP handler for these resets and
that's really reflected in the fact that this API exists. So given that,
it reasons that OMAP isn't the only one needing a reset API for drivers.
I'm thinking that (as trivial as it may seem), this support may need to
move to a reset subsystem such that drivers have a clean way to access
reset resources in an SoC.

I'm curious if you or others have thought about where this needs to go
next. When I first thought about a reset subsystem it seemed to trivial
to bother with but looking at the reasoning behind the power_seq
subsystem, it seems to have similar justification to get this machine
specific logic out of the platform code and under standardized control
of the driver. We have resources that are manipulated outside of the IP
block but need to be controlled at the driver level and probably should
have a common driver API that isn't OMAP specific and tied to pdata.

-Matt
