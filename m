Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760912Ab2EKSph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:45:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48477 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759087Ab2EKSpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:45:35 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 5/6 v3] mfd: tps65910-irq: Add devicetree init support
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rhyland Klein <rklein@nvidia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Rob Herring <rob.herring@calxeda.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
In-Reply-To: <20120508154820.GA15893@opensource.wolfsonmicro.com>
References: <1336502563-31789-1-git-send-email-rklein@nvidia.com> <1336502563-31789-6-git-send-email-rklein@nvidia.com> <20120508154820.GA15893@opensource.wolfsonmicro.com>
Date: Fri, 11 May 2012 12:45:32 -0600
Message-Id: <20120511184532.C74D73E0791@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2012 16:48:21 +0100, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, May 08, 2012 at 11:42:42AM -0700, Rhyland Klein wrote:
> 
> > +	if (pdata->irq_base <= 0)
> > +		pdata->irq_base = irq_alloc_descs(-1, 0, tps65910->irq_num, -1);
> > +
> > +	if (pdata->irq_base <= 0) {
> > +		dev_err(tps65910->dev, "Failed to allocate irq descs: %d\n",
> > +			pdata->irq_base);
> > +		return pdata->irq_base;
> > +	}
> 
> I'd expect the driver to always call irq_alloc_descs() but to use the
> value specified in platform data if there is any.  This is the normal
> way of doing things, anyway.

More importantly, the driver should be converted to use an irq_domain
and remove the custom irq_to_tps65910_irq function.
irq_find_mapping() handles the hwirq --> irq lookup and
irq_data->hwirq will always give you the controller's irq number.

When irq_base is -1, then use irq_domain_add_linear() which will also
manage irq_desc allocations for you.  If the driver requires a
specific irq_base then the descs still need to be manually allocated
and use an irq_domain_add_legacy() to set it up. (this is sub-optimal
though; I hope to have a better solution for legacy that also manages
desc allocations just like the other mappings; maybe in the 3.6
timeframe).

g.

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
