Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804Ab2FANVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 09:21:18 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:60857 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759777Ab2FANVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 09:21:16 -0400
Message-ID: <4FC8C1C7.1060702@gmail.com>
Date: Fri, 01 Jun 2012 08:21:11 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, Shawn Guo <shawn.guo@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "arm@kernel.org" <arm@kernel.org>, Shawn Guo <shawn.guo@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] DT clk binding support
References: <4FB80F32.5090309@gmail.com>    <20120520030653.GB5810@S2100-06.ap.freescale.net>    <4FB9A5E7.2070000@gmail.com>    <20120521064901.GE8140@S2101-09.ap.freescale.net>    <4FBA89E3.7010106@gmail.com>    <20120521232616.GF8140@S2101-09.ap.freescale.net>    <4FBAD545.7060803@gmail.com>    <20120522021535.GG8140@S2101-09.ap.freescale.net>    <4FBB134D.6050409@codeaurora.org> <4FBB9A08.2050803@gmail.com> <49cd509b59c8172c880b0c8a50c0f02c.squirrel@www.codeaurora.org> <4FBCED4D.1040908@gmail.com> <4FBEA540.1010409@codeaurora.org> <4FBEAE01.7030905@gmail.com> <4FBEFD7B.1010709@codeaurora.org>
In-Reply-To: <4FBEFD7B.1010709@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 10:33 PM, Saravana Kannan wrote:
> On 05/24/2012 02:54 PM, Rob Herring wrote:
>> On 05/24/2012 04:16 PM, Saravana Kannan wrote:
>>> On 05/23/2012 06:59 AM, Rob Herring wrote:
>>>> On 05/22/2012 08:38 PM, Saravana Kannan wrote:
>>
>> snip
>>
>>>>> If only the leaf nodes are defined in DT, then how is the clock
>>>>> platform
>>>>> driver implementer supposed to instantiate the rest of the tree and
>>>>> connect it up with the partial list of clocks in DT? So, they have to
>>>>> switch back and forth between DT and the .c file which defines the
>>>>> rest
>>>>> and make sure the parent<->child names match?
>>>>>
>>>>> To me it looks that it might better to decouple the description of the
>>>>> clock HW from the mapping of a clock leaf to a consumer device. If we
>>>>> just
>>>>> use a string to identify the clock that's consumed by a device, we can
>>>>> achieve this decoupling at a clean boundary -- clock consumers devices
>>>>> (UART) vs clock producer devices (clock controller in the SoC, in a
>>>>> PMIC,
>>>>> audio codec, etc).
>>>>>
>>>>> With the decoupling, we don't have the inconsistency of having some
>>>>> of the
>>>>> clocks of a clock producer device incompletely defined in DT and the
>>>>> rest
>>>>> of the clocks of the same clock producer device hard coded in the
>>>>> kernel.
>>>>> So, you either put your entire clock tree in the SoC in the DT or put
>>>>> all
>>>>> of it in the kernel but you aren't forced to put just some of them in
>>>>> the
>>>>> DT just to get DT working. I see no benefit in defining only some
>>>>> of the
>>>>> clocks in DT -- it just adds more confusion in the clock tree
>>>>> definition.
>>>>> What am I missing?
>>>>
>>>> I fail to see what would need changing in the binding itself. The
>>>> binding just describes connections. Whether that is a connection to a
>>>> clock controller node to a device or a clock gate/mux/divider node to a
>>>> device is really beyond the clock binding. This is really just policy.
>>>> You are free to put no clocks in DT, all clocks, or a nexus of clocks.
>>>
>>> With the current approach you are taking can you please give an example
>>> of how a random device described in DT would hook itself up with a leaf
>>> clock if that leaf clock is not described in DT? So that it can do a
>>> call a DT version of clk_get() to get the clock it cares for.
>>
>> No, because that's impossible with any binding.
> 
> So, this is really forcing everyone moving rest of their devices to DT
> to put part/all of the clocks in DT. Either that or deal with the "aux
> data" that's supposed to be temporary.
> 

No. You can still use clkdev lookups if clock lookup is the only thing
you need to hook up. In other words, I would only use aux_data if you
need to set platform_data. If you only need clk lookups, then you can
use clkdev. This is what most of the DT conversions I've reviewed have done.

>> The only way that would
>> work is provide a string with a clock name and matching to the struct
>> clk name string. That means putting linux clock names into the h/w
>> description.
> 
> No, the name of the clocks stored in clk->name should be the name of the
> clock in HW.
> 

True, but it had been debated whether a name was needed for anything but
debug. We're trying to get data like this out of the kernel with DT. For
example, say you have a new derivative SOC that adds 1 additional PLL.
Adding support for that PLL could be as simple as adding it to DT and
the kernel will instantiate it. If you are matching with strings, then
you have to add the new PLL name string to the kernel.

>> That is the wrong direction and not how bindings work.
>> Defining bindings should not get tangled up with how the OS
>> implementation is done.
> 
> So, I'm not asking to bind to the name of a clock as defined by the OS
> implementation. I'm just asking to bind to the name of the clock in HW
> instead of the name binding to an actual DT clock node. And I'm only
> asking this because we seem to want to give an option to NOT have the
> clocks in DT.
> 
> A developer might choose to abbreviate the clock name in DT and in
> clk->name field in the kernel, but there's nothing wrong with it. Nor
> can DT do anything about it for ANY (not just clock) DT device
> descriptions.
> 
>>> And no, there is a huge difference between binding a clock controller
>>> node (by which I mean the block that provides many clocks) to a device
>>> vs. binding a clock leaf to a device. The former is useless wrt to
>>> clk_get() and similar functions. The latter is very useful to handle
>>> that.
>>
>> The binding and clkdev changes support clk_get fully. Drivers don't have
>> to change at all. There is not a DT version of clk_get that all drivers
>> have to adopt. It's all handled within clk_get and should be transparent
>> to drivers. The only thing that has to change is callers of clk_get_sys
>> to use of_clk_get, but that's a small fraction of clocks.
> 
> I understand there are changes to have clk_get() work on clocks added
> through DT. But, you said earlier that it doesn't matter if a general DT
> device binds to a clock controller DT device or to an actual clock node
> (say, a leaf in the clock tree) defined in DT. I'm just pointing out
> that it's not true. If a general DT device binds to a clock controller
> DT device, there is no way to figure out what clock node/leaf from the
> clock controller is actually consumed by this general device.

of_clk_get_parent_name (or some variation that gives you parent phandle
too) doesn't do what you want?

The fact that a driver needs to know details about possible parents is a
problem independent of DT. We do need a better way to abstract that.

Rob

> 
> -Saravana
> 

