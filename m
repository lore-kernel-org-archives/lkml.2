Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061Ab2KNSND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:13:03 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39669 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab2KNSNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:13:01 -0500
Message-ID: <50A3DF29.1070806@wwwdotorg.org>
Date: Wed, 14 Nov 2012 11:12:57 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: tegra: Add Tegra20 host1x support
References: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de> <1352467202-27903-2-git-send-email-thierry.reding@avionic-design.de> <50A357D3.9080002@nvidia.com> <20121114084931.GA31837@avionic-0098.mockup.avionic-design.de> <50A3712E.7000104@nvidia.com> <20121114105406.GA31455@avionic-0098.mockup.avionic-design.de> <50A3C485.7080704@wwwdotorg.org> <50A3CAA3.2060908@nvidia.com>
In-Reply-To: <50A3CAA3.2060908@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 09:45 AM, Terje Bergström wrote:
> On 14.11.2012 18:19, Stephen Warren wrote:
>> I'd rather initialize it explicitly. If setting it to 216MHz works
>> fine as Terje indicated, we may as well just do that.
> 
> I'd prefer explicit setting, too.
> 
>> I suspect the issue with the original code:
>>
>>> { "host1x",     "pll_c",        144000000,      false },
>>
>> ... is that perhaps the requested 144MHz can't be generated from
>> pll_c's 600MHz rate, since there's a simple U7.1 divider there (you
>> could get 120, 133.333, 150), so the clock ends up being programmed to
>> some incorrect value. In the pll_p/216MHz case, pll_p is programmed to
>> generate 216MHz anyway, so requesting the same rate for host1x yields
>> a divider of 1 exactly which works fine.
> 
> I could try the values you proposed tomorrow when I get back to office.
> I believe we've always kept host1x under non-fractional dividers, so I'd
> like to try 150MHz on Ventana and 150MHz and 300MHz on Cardhu.
> 
> 600MHz sounds pretty high for PLLC on Tegra20. For Tegra30 it would be
> understandable. In internal kernel I believe we have lower rate for
> Tegra20 PLLC. Do we have anything running from PLLC in Tegra20 upstream
> kernel?

Yes, sclk/... appear to derive from it:

> 	{ "pll_c",	"clk_m",	600000000,	true },
> 	{ "pll_c_out1",	"pll_c",	120000000,	true },
> 	{ "sclk",	"pll_c_out1",	120000000,	true },
> 	{ "hclk",	"sclk",		120000000,	true },
> 	{ "pclk",	"hclk",		60000000,	true },

Git archaeology shows that the following commits are relevant, the first
and last one in particular:

> commit 9abafa021e223f04d6589ee2b977bbaf2e1f1367
> Author: Stephen Warren <swarren@nvidia.com>
> Date:   Thu Apr 12 14:13:05 2012 -0600
> 
>     ARM: tegra: change pll_p_out4's rate to 24MHz
>     
>     pll_p_out4 is used on all/most Tegra boards to drive the cdev2 output pin
>     to provide a reference clock to a ULPI USB PHY. This reference clock must
>     run at 24MHz, and the cdev2 output has no additional dividers.
>     
>     Remove board-paz00.c's now-duplicate initialization of this clock.
>     
>     Reported-by: Marc Dietrich <marvin24@gmx.de>
>     Signed-off-by: Stephen Warren <swarren@nvidia.com>
> 
> commit 7ff4db0967bd7d617c77dc5a66c0d95166277817
> Author: Stephen Warren <swarren@nvidia.com>
> Date:   Fri Apr 20 16:58:18 2012 -0600
> 
>     ARM: tegra: fix pclk rate
>     
>     Commit 40f9cf0 "ARM: tegra: reparent sclk to pll_c_out1" changed the
>     rate of hclk. Since pclk is derived from that, and only has integer
>     dividers, the pclk rate needs to change in the same fashion, from 54MHz
>     to 60MHz.
>     
>     Signed-off-by: Stephen Warren <swarren@nvidia.com>
> 
> commit 60f975b98cf41476ba0e156f7523b197b046cf2b
> Author: Stephen Warren <swarren@nvidia.com>
> Date:   Thu Apr 12 14:09:39 2012 -0600
> 
>     ARM: tegra: reparent sclk to pll_c_out1
>     
>     pll_p_out4 needs to be used for other purposes. Reparent sclk so that
>     it runs from pll_c. Change sclk's rate to 120MHz from 108MHz since this
>     is the lowest precise rate that can be achieved by dividing the pll_c
>     rate without reducing the sclk rate. (600/5=120, 600/5.5=109.0909...,
>     600/6=100).
>     
>     Signed-off-by: Stephen Warren <swarren@nvidia.com>
> 
> commit c8b62ab41f76218efca5e4baa5c22ef52a9fe3a5
> Author: Allen Martin <amartin@nvidia.com>
> Date:   Fri Sep 10 09:17:33 2010 -0500
> 
>     ARM: tegra: Add pllc clock init table
>     
>     pll_c will be used as a clock source. Fill in tegra_pll_c_freq_table[]
>     so that it's possible to explicitly initialize the PLL.
>     
>     NVIDIA's downstream nv-3.1 kernel and the ChromeOS kernel have different
>     pll_c tables. nv-3.1 contains entries for 522MHz and 598MHz output,
>     whereas the ChromeOS kernel contains entries for 600MHz output. I chose
>     to upstream the ChromeOS values for now, since the 600MHz rate appears
>     to match the default rate of this PLL when the HW boots, and it's not
>     clear to me why 522 or 598MHz are more useful.
>     
>     Signed-off-by: Allen Martin <amartin@nvidia.com>
>     Signed-off-by: Olof Johansson <olofj@chromium.org>
>     Signed-off-by: Stephen Warren <swarren@nvidia.com>
>     [swarren: wrote commit description]


