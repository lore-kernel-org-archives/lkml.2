Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422942Ab2KNQTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:19:22 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:42411 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964807Ab2KNQTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:19:20 -0500
Message-ID: <50A3C485.7080704@wwwdotorg.org>
Date: Wed, 14 Nov 2012 09:19:17 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: tegra: Add Tegra20 host1x support
References: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de> <1352467202-27903-2-git-send-email-thierry.reding@avionic-design.de> <50A357D3.9080002@nvidia.com> <20121114084931.GA31837@avionic-0098.mockup.avionic-design.de> <50A3712E.7000104@nvidia.com> <20121114105406.GA31455@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121114105406.GA31455@avionic-0098.mockup.avionic-design.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 03:54 AM, Thierry Reding wrote:
> On Wed, Nov 14, 2012 at 12:23:42PM +0200, Terje Bergström wrote:
>> On 14.11.2012 10:49, Thierry Reding wrote:
>>> Can you find out how the host1x clock is setup without this
>>> change? I was told that freezes can occur when you try to
>>> access the registers without the host1x clock being enabled.
>>> However, the host1x driver should take care to properly setup
>>> the clock.
>>> 
>>> To find out if the non-running clock is the issue, can you try
>>> to patch that line and make the final element true instead of
>>> false? That should enable the clock on boot so that it should
>>> always be running.
>> 
>> I tried with fastboot and U-Boot, and whenever that line is
>> there, kernel boot will halt at nvhost init. Same happens if I
>> just change the false to true.
>> 
>> nvhost will enable the clock and disable as it need. Also, part
>> of host1x initialization did proceed, but it ended up hanging
>> after a few registers were initialized. So it's not a case of
>> host1x being off, but host1x hanging after a while.
>> 
>> If I change this line to:
>> 
>> { "host1x",     "pll_p",        216000000,      false },
>> 
>> it will also work properly. It looks like we have some problem
>> with pll_c in Tegra20, or clock configuration with your patch. In
>> Tegra30, pll_c with 144MHz seems to work fine, but on Tegra20, it
>> doesn't.
>> 
>> In internal kernel, we use pll_c for host1x, so hardware
>> shouldn't be the problem here.
> 
> I suppose that if things work properly without this line, then we
> should probably just drop it. Stephen, any objections?

I'd rather initialize it explicitly. If setting it to 216MHz works
fine as Terje indicated, we may as well just do that.

I suspect the issue with the original code:

> { "host1x",     "pll_c",        144000000,      false },

... is that perhaps the requested 144MHz can't be generated from
pll_c's 600MHz rate, since there's a simple U7.1 divider there (you
could get 120, 133.333, 150), so the clock ends up being programmed to
some incorrect value. In the pll_p/216MHz case, pll_p is programmed to
generate 216MHz anyway, so requesting the same rate for host1x yields
a divider of 1 exactly which works fine.
