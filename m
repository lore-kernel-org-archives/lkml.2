Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab1LENlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:41:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47176 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab1LENfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:35:08 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF174FDB01F2@HQMAIL01.nvidia.com>
References: <1322160380-27711-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF174FDAFF30@HQMAIL01.nvidia.com>
	<CACRpkdZueyZkOq20qq_jDn27cfkChM58cR+TvPKfifSwFwiQ5w@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF174FDB01F2@HQMAIL01.nvidia.com>
Date: Mon, 5 Dec 2011 14:35:07 +0100
Message-ID: <CACRpkdYJkLHtn9_Evw4m3rUCtzRoR9quinpHA3YEF2kt=cEd5g@mail.gmail.com>
Subject: Re: [PATCH 2/2 v4] pinctrl: introduce generic pin config
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 6:16 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Thursday, December 01, 2011 3:12 AM:

>> That will get messy when if I refactor this stuff, add new enums
>> and whatever.
>
> I don't understand what'd be difficult about that.
>
> New standardized enums could be added with values without the top bit
> set. No existing driver would need modification, since their switch(param)
> would not have a case for that new value, and would just return an error.

That would be mixing binary #defines and enums in an unholy
manner, that sounds bad to me.

If you want to do things like that I should replace the current

enum pin_config_param {
        PIN_CONFIG_BIAS_DISABLE,
        PIN_CONFIG_BIAS_HIGH_IMPEDANCE,
       ...
}

With

#define PIN_CONFIG_BIAS_DISABLE 0x00000001
#define PIN_CONFIG_BIAS_HIGH_IMPEDANCE 0x00000002
...

Else it seems like a bit wicked mix-up. So is this what we
should do?

I am reluctant since it mirrors the problem in the GPIO
numberspace where you have no clue what, say GPIO
164 is on a multi-platform binary. It depends on which
platform it booted on. The same will be true for such
enums/defines above the predefined range, totally
depending on the system at hand.

>> Like in the generic debugfs dump function:
>>
>>       if (!ops->is_generic)
>>               return;
>>
>> If I take this out, the generic debugfs code will be used for
>> everything.
>
> I think that'd be fine; the generic code would do all the debug prints
> for the standardized enums, then the core would call into the pinctrl
> driver to perform any additional debug prints for any driver-defined
> custom parameters.

I think Marks point earlier was that he wanted the possibility
to cut out *all* the generic stuff and have only custom config
enumerators for a certain pin controller.

>> And then the generic sematics which you didn't like in the
>> previous patch:
>>
>> if (ret == -EINVAL || ret == -ENOTSUPP)
>>
>> Need to go back in, else the generic debugfs stuff won't
>> work.
>
> That'd be fine, provided the loop only checked the standardized parameters,
> or only enabled that special error-checking case for standardized parameters.

Same comment as above. This won't cut it for all-custom
pin controllers, they will get unwanted semantics pushed at
them.

Thanks,
Linus Walleij
