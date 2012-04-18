Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab2DRSGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:06:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49101 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2DRSGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:06:34 -0400
Message-ID: <4F8F02A6.6030106@wwwdotorg.org>
Date: Wed, 18 Apr 2012 12:06:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dong Aisheng <aisheng.dong@freescale.com>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH 1/3] pinctrl: pinctrl-imx: add imx pinctrl core driver
References: <1334333915-1174-1-git-send-email-b29396@freescale.com> <4F8DD986.9080702@wwwdotorg.org> <20120418071920.GC18021@shlinux2.ap.freescale.net>
In-Reply-To: <20120418071920.GC18021@shlinux2.ap.freescale.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 01:19 AM, Dong Aisheng wrote:
> On Wed, Apr 18, 2012 at 04:58:46AM +0800, Stephen Warren wrote:
>> On 04/13/2012 10:18 AM, Dong Aisheng wrote:
>>> From: Dong Aisheng <dong.aisheng@linaro.org>
>>>
>>> The driver has mux and config support while the gpio is still
>>> not supported.
>>> For select input setting, the driver will handle it internally
>>> and do not need user to take care of it.
>>>
>>> The pinctrl-imx core driver will parse the dts file and dynamically
>>> create the pinmux functions and groups.
>>>
>>> Each IMX SoC pinctrl driver should register pins with a pin register map
>>> including mux register and config register and select input map to core
>>> for proper operations.

>>> +static int __devinit imx_pmx_parse_functions(struct device_node *np,
>>> +			struct imx_pinctrl_info *info, u32 index)
>>
>> Oh, I see.
>>
>> You're defining the set of functions exported from the driver based on
>> the content of the pin configuration nodes in device tree. I must admit,
>> I don't like that much, and I didn't get that impression at all from
>> reading the binding document.
>
> I will rich the document but i'm not sure i should talk too much about the
> driver specific things in binding doc.
> It seems the binding doc should represents more hw things, right?

Yes, the binding documentation should be basically a hardware
description, although I think it's reasonable for the documentation to
describe how a driver should use the data in the binding; that's more to
do with the binding that driver implementation details.

I think that once you've enhanced the documentation to describe what the
func-a/group-a nodes are, that will probably be enough to resolve this
issue for me.

>> I know that there's some disagreement over whether the groups that a pin
>> controller driver exposes should be limited to groups that actually
>> exist in HW registers or not, but surely at least the functions that the
>> driver exposes should actually correspond directly to the function in
>> the HW registers?
>
> I have slightly different opinions, they're related.
> As GROUP, FUNCTION is also an abstract idea.
> (some SoCs may not have hw pin GROUP like IMX)
> People use GROUP since we can group a set of pins for one device/FUNCTION to use.
> If we exposes functions per pin based on hw registers, then the GROUP idea may not
> suitable for pin based SoC.
> (Thinking current pinctrl subsystem only enables functions per GROUP)
> The only way is as you did for tegra3, one pin is a group.
> This is option and it works. But i think, in the future, we may be better
> make the pinctrl subsystem also supports mux per pin since the idea of one
> pin GROUP is a little not very suitable for the GROUP idea from literal meaning.
> 
> For IMX, we may not choose one pin based group since it's not easy to use
> and will make the driver much bigger.
> 
> As we already agree that we do not limit people to define GROUP which
> should only exist in HW register(hw GROUP), IOW we allow to use 'virtual' group,
> then we should not force people to define FUNCTION per hw GROUP too, right?
> 
> So IMX defines FUNCTION per device or 'virtual' group(a set of pins for that device)
> since IMX does not have hw pin GROUP.

Yes, I see your point. I still dislike virtual groups (I think it makes
more sense to represent the same thing as multiple mapping table
entries), but I guess if we allow virtual groups, then maybe allowing
virtual functions is roughly the same thing.

It would be nice to enhance pinctrl to allow muxing directly on pins
too, instead of only groups. That would be a nice cleanup, and a better
fit for many SoCs. It'd probably reduce the size of pinctrl-tegra30.c a
bit too.
