Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931Ab2EWN7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 09:59:46 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:48759 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab2EWN7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 09:59:45 -0400
Message-ID: <4FBCED4D.1040908@gmail.com>
Date: Wed, 23 May 2012 08:59:41 -0500
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
References: <4FB80F32.5090309@gmail.com>    <20120520030653.GB5810@S2100-06.ap.freescale.net>    <4FB9A5E7.2070000@gmail.com>    <20120521064901.GE8140@S2101-09.ap.freescale.net>    <4FBA89E3.7010106@gmail.com>    <20120521232616.GF8140@S2101-09.ap.freescale.net>    <4FBAD545.7060803@gmail.com>    <20120522021535.GG8140@S2101-09.ap.freescale.net>    <4FBB134D.6050409@codeaurora.org> <4FBB9A08.2050803@gmail.com> <49cd509b59c8172c880b0c8a50c0f02c.squirrel@www.codeaurora.org>
In-Reply-To: <49cd509b59c8172c880b0c8a50c0f02c.squirrel@www.codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 08:38 PM, Saravana Kannan wrote:
> 
> On Tue, May 22, 2012 6:52 am, Rob Herring wrote:
>> On 05/21/2012 11:17 PM, Stephen Boyd wrote:
>>> On 05/21/12 19:15, Shawn Guo wrote:
>>>> On Mon, May 21, 2012 at 06:52:37PM -0500, Rob Herring wrote:
>>>>> As Grant states: "This proposed binding is only about one thing:
>>>>> attaching clock providers to clock consumers." This means you have to
>>>>> have at least a single provider and a single consumer defined in the
>>>>> DT.
>>>>>
>>>> I just read through Grant's comments over again.  I agree with the
>>>> statement which implicitly requires the clk provider defined in DT.
>>>> However, for some case, this provider in DT is just a skeleton which
>>>> is backed by clock driver where the provider is actually defined.
>>>>
>>>> Looking at Grant's comment below, the second option is also to match
>>>> the clock in driver just using name.  The only difference to my
>>>> proposal is the name here is given by the argument of phandle pointing
>>>> to that skeleton provider node.
>>>>
>>>> I'm fine with that.  So go ahead with your bindings.
>>>>
>>>
>>> Can we do what the regulator framework has done and have a common
>>> binding of <connection_name>-clk = <&phandle>? Something like:
>>>
>>>     core-clk = <&uart3_clk>
>>>
>>> and then have clk_get() use the of node of the device passed in to find
>>> a property named %s-clk and find the clock with the matching phandle.
>>
>> Sigh... That is what we had in previous versions from over a year ago
>> and we moved away from that approach. The current binding has been
>> reviewed multiple times in the last 6 months...
>>
>> The current approach is aligned with how interrupts are handled (with
>> the addition of a phandle). I think not having per clock property names
>> is easier to parse and easier to document.
>>
>>> This looks like it's trying to cover both the end consumers (uart uses
>>> uart3_clk) and the internal clock tree consumers (a crystal oscillator
>>> connects to a PLL or a mux has multiple parents). We can certainly use
>>> these bindings for muxes and internal parent-child relationships but I
>>> would prefer we use different bindings for consumer bindings that match
>>> what regulators do today.
>>
>> The binding supports either defining every last internal clock or just
>> the leaf clocks. I took the former route on highbank since I don't have
>> a lot of clocks. If I was doing imx or omap for example, I'd probably
>> just define all the clock controller outputs.
>>
> 
> If only the leaf nodes are defined in DT, then how is the clock platform
> driver implementer supposed to instantiate the rest of the tree and
> connect it up with the partial list of clocks in DT? So, they have to
> switch back and forth between DT and the .c file which defines the rest
> and make sure the parent<->child names match?
> 
> To me it looks that it might better to decouple the description of the
> clock HW from the mapping of a clock leaf to a consumer device. If we just
> use a string to identify the clock that's consumed by a device, we can
> achieve this decoupling at a clean boundary -- clock consumers devices
> (UART) vs clock producer devices (clock controller in the SoC, in a PMIC,
> audio codec, etc).
> 
> With the decoupling, we don't have the inconsistency of having some of the
> clocks of a clock producer device incompletely defined in DT and the rest
> of the clocks of the same clock producer device hard coded in the kernel.
> So, you either put your entire clock tree in the SoC in the DT or put all
> of it in the kernel but you aren't forced to put just some of them in the
> DT just to get DT working. I see no benefit in defining only some of the
> clocks in DT -- it just adds more confusion in the clock tree definition.
> What am I missing?

I fail to see what would need changing in the binding itself. The
binding just describes connections. Whether that is a connection to a
clock controller node to a device or a clock gate/mux/divider node to a
device is really beyond the clock binding. This is really just policy.
You are free to put no clocks in DT, all clocks, or a nexus of clocks.

Rob
