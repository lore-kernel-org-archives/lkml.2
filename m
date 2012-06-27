Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab2F0ODT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:03:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57555 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751850Ab2F0ODR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:03:17 -0400
Date: Wed, 27 Jun 2012 10:03:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stephen Boyd <sboyd@codeaurora.org>
cc: jonghwa3.lee@samsung.com, <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Jamie Iles <jamie@jamieiles.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] Exynos : Add support for Exynos random number generator
In-Reply-To: <4FEA0E3E.2070804@codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1206270958500.1665-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2012, Stephen Boyd wrote:

> On 06/21/12 18:39, jonghwa3.lee@samsung.com wrote:
> > On 2012년 06월 21일 12:12, Stephen Boyd wrote:
> >
> >> On 06/20/12 19:39, jonghwa3.lee@samsung.com wrote:
> >>>>> +static int exynos_init(struct hwrng *rng)
> >>>>> +{
> >>>>> +	struct exynos_rng *exynos_rng = container_of(rng,
> >>>>> +						struct exynos_rng, rng);
> >>>>> +	int i;
> >>>>> +	int ret = 0;
> >>>>> +	u32 PRND_SEED[5];
> >>>>> +
> >>>>> +	pm_runtime_put_noidle(exynos_rng->dev);
> >>>>> +	pm_runtime_get_sync(exynos_rng->dev);
> >>>> This looks very odd. Why are you calling pm_runtime_put_noidle()?
> >>>>
> >>> When this callback function is called, the status of power state is
> >>> 'suspended' and use_count is 1.

That's strange to begin with.  If the usage counter is > 0 then the
device shouldn't be suspended.  How does this happen?

>  To perform pm_runtime_get_sync()
> >>> correctly, it requires to have 'suspended' status and use_count is 0.

That's not true.  pm_runtime_get_sync works perfectly well when the 
status is "suspended" and the usage counter is > 0.

> >>> Thus i force to decrease use_count only with using
> >>> pm_runtime_put_noidle. I know it looks odd, but i couldn't find better
> >>> way. Otherwise it can use clk_enable() directly, but i think that it
> >>> isn't good neither.
> >> Is the device suspended initially at probe? If so can you set the state
> >> of the device to suspended?
> >>
> >
> > Yes, it suspended already at the initial of probing. But i can't get
> > your point, you want to me to make device suspended?
> 
> I mean to say you should probably call pm_runtime_set_suspended() during
> probe. But I'm not sure and I would defer to people more familiar with
> runtime pm.

If the device starts out in a suspended state then the subsystem or 
driver should call pm_runtime_set_suspended before calling 
pm_runtime_enable.

Alan Stern

