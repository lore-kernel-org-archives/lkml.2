Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab2FEQHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:07:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47785 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2FEQHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 12:07:36 -0400
Message-ID: <4FCE2EC5.2000403@wwwdotorg.org>
Date: Tue, 05 Jun 2012 10:07:33 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: add a pinctrl_mux_group_selected() function
References: <Pine.LNX.4.64.1205230020210.11851@axis700.grange> <4FBCF9F0.1010901@wwwdotorg.org> <Pine.LNX.4.64.1205231659310.21980@axis700.grange> <4FBD01A6.4080807@wwwdotorg.org> <CACRpkdbPe5jOmekPJBwryL5vkgUXsGyPijqDGqtYvK8AE6bCtw@mail.gmail.com>
In-Reply-To: <CACRpkdbPe5jOmekPJBwryL5vkgUXsGyPijqDGqtYvK8AE6bCtw@mail.gmail.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2012 06:40 AM, Linus Walleij wrote:
> On Wed, May 23, 2012 at 5:26 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
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
> 
> I discussed the same scenario the other day, and I sort of understand
> this dilemma.
> 
> It's popping up when using different default modes for the same
> device, the only one I've heard of is MMC that wants to be informed
> on how many bits of the bus it should use.

Well, you can't really have different "default" modes - "default" should
be used when there truly is a single state that the device/driver just
wants to get programmed. When the device/driver itself can support
multiple different configurations, "default" isn't the right answer if
the driver needs to derive information from the selected pinctrl state;
there should be different pinctrl states for each possible configuration.

> [Stephen]
>> If using device tree, the bus-width property should be used. If not
>> using device tree, presumably you'd add an equivalent field to the
>> platform data.
>>
>> An alternative (only when not using DT, since there's already a property
>> for DT) is that the driver doesn't select pinctrl state "default", but
>> instead first looks for e.g. "8bit" and if found uses it, then falls
>> back to "4bit", then falls back to "1bit". Whichever state name is
>> defined indicates which bus width is available.
> 
> But the DT approach seems to actually be less flexible than the old
> style platform data here, whereas the method mentioned last here
> can probe its way downward. DT just hardcodes it. But maybe this
> is usually what you want to do anyway.

I'm not sure what "probe its way downward" means. At least on Tegra, the
platform data also hard-coded the bus width (albeit in a slightly odd
way), so the bus-width DT property is semantically identical.

It's quite unlikely you'd ever want to switch between different states
at runtime, or program the HW to be anything other than what the board
supports, right?
