Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab2FGQZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 12:25:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56156 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab2FGQZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 12:25:39 -0400
Message-ID: <4FD0D5FF.2000104@wwwdotorg.org>
Date: Thu, 07 Jun 2012 10:25:35 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: add a pinctrl_mux_group_selected() function
References: <Pine.LNX.4.64.1205230020210.11851@axis700.grange> <4FBCF9F0.1010901@wwwdotorg.org> <Pine.LNX.4.64.1205231659310.21980@axis700.grange> <4FBD01A6.4080807@wwwdotorg.org> <Pine.LNX.4.64.1206070332100.9501@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1206070332100.9501@axis700.grange>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2012 08:05 PM, Guennadi Liakhovetski wrote:
> Hi Stephen
> 
> Thanks for your comments and sorry for a delay.
> 
> On Wed, 23 May 2012, Stephen Warren wrote:
> 
>> On 05/23/2012 09:03 AM, Guennadi Liakhovetski wrote:
>>> On Wed, 23 May 2012, Stephen Warren wrote:
>>>
>>>> On 05/22/2012 04:23 PM, Guennadi Liakhovetski wrote:
>>>>> This patch adds a new function to allow clients to verify, whether a
>>>>> certain group is selected in the currently active setting or not.
>>>>>
>>>>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>>>>> ---
>>>>>
>>>>> Maybe there is already a way to do this without adding a new function, I 
>>>>> haven't found one, hence this patch.
>>>>
>>>> This function doesn't currently exist because it breaks the pinctrl
>>>> conceptual model, which is that devices ask pinctrl for certain settings
>>>> whenever they need them, rather than information flowing the other way.
>>>
>>> Well, yes, we could tra to ask for each thinkable configuration and see 
>>> which one(s) succeed, but that doesn't seem very optimal either, even if 
>>> we only have 3 possibilities for now.
>>>
>>>> What's the use case for this new functionality?
>>>
>>> It's MMC. MMC interfaces can use 1, 4, or 8 data lines, depending on the 
>>> board configuration. The board knows, that it has, say, only 4 data lines 
>>> routed to the interface, so, it specifies the respective pinctrl 
>>> configuration as default. Now in the driver we have to know how many 
>>> data-lines are connected.
>>
>> If using device tree, the bus-width property should be used. If not
>> using device tree, presumably you'd add an equivalent field to the
>> platform data.
> 
> Wouldn't adding a bus-width field to the platform data be redundant, 
> considering it's already available in the pinctrl configuration?

That's not necessarily true in general. On Tegra at least, where pins
are muxed in groups rather than individually, I believe it's possible to
mux some SD controller's signals onto pin groups that support 8-bit data
width (since the pin group is 8 bits wide) but still only actually use 4
bits of data, since the board only hooked up that many signals. This
might be a waste of pins (but perhaps you can use the reset as random
GPIOs), but if the alternative pinmux locations for the SD signals have
to be used for something else, then you may have no choice.

>> An alternative (only when not using DT, since there's already a property
>> for DT) is that the driver doesn't select pinctrl state "default", but
>> instead first looks for e.g. "8bit" and if found uses it, then falls
>> back to "4bit", then falls back to "1bit". Whichever state name is
>> defined indicates which bus width is available.
> 
> Sorry for not mentioning this in my previous reply, but there's more to 
> it, not just data lines can optionally be present. Each of the 3 possible 
> data-bus widths can also have Card Detection and Write Protect lines 
> present, which brings the number of possible configurations to 4 * 3 = 
> 12... We don't want to try all of them, right? Whereas just querying the 
> pinctrl framework about which pins have been selected and configured seems 
> to be quite straight forward to me. Or should we request several 
> configurations from the driver? One of the 3 bus widthes, and additionally 
> a card-detection and a write-protect configurations?

I would personally recommend not deriving any information from the
selected pinctrl configuration at all. That way, you /can/ just use a
"default" state, and never have to search through multiple pinctrl
states. The board file will define that one state as setting up pinctrl
however it needs to be for that board - 1/4/8 bit, with/without
CD/WP/... signals/GPIOs etc.

If the CD and WP signals are truly GPIOs, there are already a common (if
not standardized) cd-gpios and wp-gpios DT properties to communicate the
GPIOs that are used to the driver.

If you're using built-in CD/WP logic on the SD host controller and don't
have the ability to make those pins plain GPIOs, I think it's entirely
reasonable to require DT to contain properties to enable/disable those
features, e.g. I see fsl-imx-esdhc.txt already has fsl,cd-internal and
fsl,wp-internal properties for this purpose.

Representing the configuration explicitly this way means that the SD
driver need have zero knowledge of the pinctrl settings for the SoC that
contains it, which keeps things nice and orthogonal. That'll help if the
SD controller HW module shows up in a different SoC or SoC version that
changes the pinctrl HW; the SD driver won't have to change at all this way.
