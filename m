Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab2BUNML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 08:12:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53159 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab2BUNMJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 08:12:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.42.155.5 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <CAA+hA=Rpim0FLamFwL5u3Cw3f8nkpvjOb9Ci5VXmv3ULX1sG8A@mail.gmail.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-9-git-send-email-swarren@nvidia.com>
	<CACRpkdYK1epBfxPCu+cc3Edmd_9aZf4nvNyBx8O0sns5V+gNWw@mail.gmail.com>
	<CAA+hA=Rpim0FLamFwL5u3Cw3f8nkpvjOb9Ci5VXmv3ULX1sG8A@mail.gmail.com>
Date: Tue, 21 Feb 2012 14:12:08 +0100
Message-ID: <CACRpkdZER7Voo9WkvyUaGLJFdfwBqHsxD_2iNainpnjUZCTxiA@mail.gmail.com>
Subject: Re: [PATCH 08/20] pinctrl: Assume map table entries can't have a NULL
 name field
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <dongas86@gmail.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 2:09 PM, Dong Aisheng <dongas86@gmail.com> wrote:
> On Tue, Feb 21, 2012 at 5:42 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Mon, Feb 20, 2012 at 7:45 AM, Stephen Warren <swarren@nvidia.com> wrote:
>>
>>> pinctrl_register_mappings() already requires that every mapping table
>>> entry have a non-NULL name field.
>>>
>>> Logically, this makes sense too; drivers should always request a specific
>>> named state so they know what they're getting. Relying on getting the
>>> first mentioned state in the mapping table is error-prone, and a nasty
>>> special case to implement, given that a given the mapping table may define
>>> multiple states for a device.
>>>
>>> Update a few places in the code and documentation that still allowed for
>>> NULL name fields.
>>>
>>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>>
>> This causes a regression on U300 and most certainly on the Sirf Prima II
>> as well. The U300 can be fixed up as per below:
>>
>> diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
>> index bb1034f..66555d7 100644
>> --- a/arch/arm/mach-u300/core.c
>> +++ b/arch/arm/mach-u300/core.c
>> @@ -1645,7 +1645,7 @@ static int __init u300_pinctrl_fetch(void)
>>                struct pinctrl *p;
>>                int ret;
>>
>> -               p = pinctrl_get(u300_mux_hogs[i].dev, NULL);
>> +               p = pinctrl_get(u300_mux_hogs[i].dev, u300_mux_hogs[i].name);
>>                if (IS_ERR(p)) {
>>                        pr_err("u300: could not get pinmux hog %s\n",
>>                               u300_mux_hogs[i].name);
>>
>>
>> The drivers/tty/serial/sirfsoc_uart.c asks for it's UART pinctrl like
>> this:
>>
>> sirfport->p = pinctrl_get(&pdev->dev, NULL);
>>
>> I don't know quite what to encode in there, if "deafult" is sensible
>> we might just
>>
>> #define PIN_MAP_NAME_DEFAULT "default"
>> In <linux/pinctrl/consumer.h> and <linux/pinctrl/machine.h> alike,
>> maybe in some <linux/pinctrl/mapnames.h> that both of these
>> include?
>>
> I feel a little strange to put such thing in common code.
> Personally i still like the original way you did.

I think with this patch alone it doesn't make much sense
to enforce the request to specify a certain map, it only
appears further ahead as we start to support states.

Let's look through the entire patch series so as to get
the bigger picture.

Yours,
Linus Walleij
