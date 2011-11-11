Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab1KKTv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 14:51:28 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35188 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab1KKTv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 14:51:26 -0500
Message-ID: <4EBD7C92.7060707@ti.com>
Date: Fri, 11 Nov 2011 20:50:42 +0100
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Sascha Hauer <s.hauer@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        <devicetree-discuss@lists.ozlabs.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 6/8] of: add clock providers
References: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca> <1320801583-12774-7-git-send-email-grant.likely@secretlab.ca> <20111109091328.GY16886@pengutronix.de> <4EBA62AD.3000407@ti.com> <4EBA8735.902@gmail.com>
In-Reply-To: <4EBA8735.902@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On 11/9/2011 2:59 PM, Rob Herring wrote:
> On 11/09/2011 05:23 AM, Cousson, Benoit wrote:
>> On 11/9/2011 10:13 AM, Sascha Hauer wrote:
>>> On Tue, Nov 08, 2011 at 06:19:41PM -0700, Grant Likely wrote:
>>
>> [...]
>>
>>>> +Sources of clock signal can be represented by any node in the device
>>>> +tree.  Those nodes are designated as clock providers.  Clock consumer
>>>> +nodes use a phandle and clock specifier pair to connect clock provider
>>>> +outputs to clock inputs.  Similar to the gpio specifiers, a clock
>>>> +specifier is an array of one more more cells identifying the clock
>>>> +output on a device.  The length of a clock specifier is defined by the
>>>> +value of a #clock-cells property in the clock provider node.
>>>> +
>>>> +[1] http://patchwork.ozlabs.org/patch/31551/
>>>> +
>>>> +==Clock providers==
>>>> +
>>>> +Required properties:
>>>> +#clock-cells:       Number of cells in a clock specifier; typically
>>>> will be
>>>> +           set to 1
>>>> +
>>>> +Optional properties:
>>>> +clock-output-name: Recommended to be a list of strings of clock
>>>> output signal
>>>> +           names indexed by the first cell in the clock specifier.
>>>> +           However, the meaning of clock-output-names is domain
>>>> +           specific to the clock provider, and is only provided to
>>>> +           encourage using the same meaning for the majority of clock
>>>> +           providers.  This format may not work for clock providers
>>>> +           using a complex clock specifier format.  In those cases it
>>>> +           is recommended to omit this property and create a binding
>>>> +           specific names property.
>>>
>>> If the clock-output-name property is omitted, does this mean a clock
>>> provider only has a single output or does it mean that it's not known
>>> how many clock outputs a provider actually has?
>>
>> Allowing several outputs for a single clock node might lead to a lot of
>> confusion. What will be the meaning of a clock rate if you have several
>> outputs at different frequency?
>
> You typically only have a frequency property for fixed clocks.

Yes, for DT point of view, but every clock nodes has a rate. Variable or 
fixed.

> However, we should think about how to set frequency for programmable
> clocks. Perhaps this is just making clock-frequency an array of
> values in the same order as the outputs.

But, if we go that way the DT clock node will become more and more 
complex with less and less chance to use some common function like 
set_rate or clk_enable.
If the notion of clock blob is needed we should maybe consider another 
binding like clock-group and let the clock node be a single source of clock.

>> I think it will be better to define a clock node as a single source of
>> clock. If several outputs are needed, then we should define several
>> clock nodes.
>> If we let a clock node be any kind of big clock blob, we will never be
>> able to define some generic reusable clock node API. Everybody will
>> define its own custom clock blobs.
>>
>
> Whether you decide to implement a blob or every single mux, divider, and
> gate is independent from whether you use generic clock code or not. You
> could simply define a clock controller node with lots of outputs yet
> still use generic code to implement clock support in Linux. The reality
> is you will probably have a mixture of generic and SOC-specific clocks.

Yeah, maybe you're right, but the goal of the common clock fmwk was to 
avoid duplication everywhere. If everybody start implementing its own 
definition of the clock nodes here and there, I'm not sure that common 
clock fmwk will be that useful compared to what we have today.

For sure we should allow some custom clock implementation, but that 
should be the exception.

> What is our goal here? I'm skeptical we will ever get to the point that
> we can fully describe the clock tree for a new SOC without any code
> changes.

I don't think anybody is necessarily complaining about potential code 
change.

The goal, however, is a pretty good question. I'm not sure it is well 
defined or at least the same for everybody.

One of the main incentive for OMAP at least was to get rid of the huge 
static files inside arch/arm/mach-omap2 used so far to define the clock 
nodes.
The issue is that an OMAP4 clock file contains ~250 clock nodes in a ~4k 
lines file.
Moving that into a DT file will for sure reduce the size of the 
arch/arm/ that was one of the complain of Linus but at the price of 
creating an even bigger DT file.

One potential need for DT will be to get rid of the static device -> 
clock mapping table we have at the end of the clock definition file.

   CLK("usbhs-omap.0", "usbtll_ick", &usb_tll_hs_ick, CK_443X),
   CLK("usbhs-omap.0", "fck", &usb_tll_hs_fck, CK_443X),

This is even mandatory considering that the device name currently used 
will not exist anymore with DT devices.

That means, that at least every leaf clocks used by drivers have to be 
exposed in DT.

Should we then expose as well the whole clock tree?

> Perhaps our goal is simply that clock differences across all
> boards for an SOC can be described in DT.

We clearly should exposed the ones that are configurable at board level, 
like the main oscillator for example or the ones that are generated by 
an Audio codec.

But then, like Sascha was saying IIRC, having a mixed of DT and static 
data might be a total mess at the end, so we might end up defining 
everything in the DT file.

Regards,
Benoit
