Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab2K2SeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 13:34:18 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60011 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab2K2SeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 13:34:17 -0500
Message-ID: <50B7AAA6.70702@wwwdotorg.org>
Date: Thu, 29 Nov 2012 11:34:14 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com> <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de> <50B73710.2040102@nvidia.com>
In-Reply-To: <50B73710.2040102@nvidia.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 03:21 AM, Terje Bergström wrote:
> On 28.11.2012 23:23, Thierry Reding wrote:
...
>>> +     regs = platform_get_resource(dev, IORESOURCE_MEM, 0);
>>> +     intr0 = platform_get_resource(dev, IORESOURCE_IRQ, 0);
>>> +     intr1 = platform_get_resource(dev, IORESOURCE_IRQ, 1);
>>> +
>>> +     if (!regs || !intr0 || !intr1) {
>>
>> I prefer to have these checked for explicitly, one by one for
>> readability and potentially more useful diagnostics.
> 
> Can do.
> 
>> Also you should be using platform_get_irq() for interrupts. Furthermore
>> the host1x DT node (and the TRM) name the interrupts "syncpt" and
>> "general", so maybe those would be more useful variable names than
>> "intr0" and "intr1".
>>
>> But since you don't use them anyway they shouldn't be part of this
>> patch.
> 
> True. I might also as well delete the general interrupt altogether, as
> we don't use it for any real purpose.

Do make sure the interrupts still are part of the DT binding though, so
that the binding fully describes the HW, and the interrupt is available
to retrieve if we ever do use it in the future.

>>> +     for (i = 0; i < pdata->num_clks; i++)
>>> +             clk_prepare_enable(pdata->clk[i]);
>>> +     nvhost_syncpt_reset(&host->syncpt);
>>> +     for (i = 0; i < pdata->num_clks; i++)
>>> +             clk_disable_unprepare(pdata->clk[i]);
>>
>> Stephen already hinted at this when discussing the AUXDATA. You should
>> explicitly request the clocks.
> 
> I'm not too happy about that idea. The clock management code is generic
> for all modules, and that's why it's driven by a data structure. Now
> Stephen and you ask me to unroll the loops and make copies of the code
> to facilitate different modules and different SoCs.

You can still create tables of clocks inside the driver and loop over
them. So, loop unrolling isn't related to my comments at least. It's
just that clk_get() shouldn't take its parameters from platform data.

But if these are clocks for (arbitrary) child modules (that may or may
not exist dynamically), why aren't the drivers for the child modules
managing them?
