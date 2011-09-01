Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab1IAJN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 05:13:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62389 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab1IAJN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 05:13:56 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdaWbgiaJvvjDgBWFTpC6P=XcG6fm+L8rnjv9rxDxgs_YQ@mail.gmail.com>
References: <1314609001-28052-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B3279BD7@HQMAIL01.nvidia.com>
	<CACRpkdaWbgiaJvvjDgBWFTpC6P=XcG6fm+L8rnjv9rxDxgs_YQ@mail.gmail.com>
Date: Thu, 1 Sep 2011 11:13:03 +0200
Message-ID: <CACRpkda4PRd_WUPrnEBVADbHnmSOgVB=WCXvVR4dFMektyQ2tQ@mail.gmail.com>
Subject: Re: [PATCH 1/4 v5] drivers: create a pin control subsystem v5
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>, Barry Song <21cnbao@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damn gmail punished me when writing the reply, sent by mistake :-(

And I intended to post v6 first.

These parts were being typed as I screwed up:

On Thu, Sep 1, 2011 at 10:59 AM, Linus Walleij <linus.walleij@linaro.org> wrote:

> function and group names shall match what is
> presented from the pin controller driver.
>
> You can thing of this as SQL:
>
> SELECT ctrl_dev_name,
> TOP 1
>  FROM MAPS
>  WHERE dev_name = device_name
>  AND ctrl_dev_name = ctrl_dev_name
>  AND function = function
>  AND group = group

I don't know the exact SQL syntax anymore, thing
is that it selects one matching row only.

>> mmc0    8-bit A         mmc0
>> mmc0    8-bit B         mmc0
>> mmc0    8-bit C         mmc0
>
> I assume you mean that semantically this shall
> be a 1..* relation, so that if I say:
>
> pmx = pinmux_get(&dev, "8-bit");
>
> Then all pins in the union {A, B, C} shall be
> allocated and enabled/disabled simultaneously.
>
> so it'd be like the database equivalent:

What I wanted to illustrate here is that the database
return multiple matching rows.

Anyway, I'm onto that.

I will need Arnds or similars advice on it so we don't
grow a lib/mysql into the kernel with this kind of
schemes and get slammed for overcomplicating
things when trying to merge the beast.

So I'm still a bit reluctant about this part  :-/

> Then the pinmux_map maps usually one but sometimes
> more of these {function, position} tuples to the device.

{ function, group } it is.

> And, you also request the currently not implemented
> extenstion that a mux can match multiple map entries.
>
> I'll fix.

Or rather, I'll try.

>> 2) "Positions" are defined per "function", rather than as a global concept.
>>
>> This leads to positions having meaningless integer names. As such,
>> constructing the mapping table will be error-prone; who could remember
>> that position 0 is a 2-bit bus using a certain set of pins, yet position
>> 1 is an 8-bit bus using a different set of pins? I suppose textual names
>> might help here. However, by replacing the concept of positions with
>> multiple explicit entries in the mapping table (as in my example above),
>> that problem is solved; we name the pins (or pingroups) to which we apply
>> the driver-level function in each entry, thus it's more self-documenting.
>
> Again I can replace position integers with strings if that is what
> you want?

Forget this, part of earlier reply.

positions are replaced with groups, which have names.

>> Driver-supplied data 4)
>>
>> Table of legal functions per pin/pingroup; each entry containing:
>> * Name of pin or pingroup
>
> OK I have this now, e.g. inspect the file
> <debugfs>/pinctrl.0/groups

Should be pingroups, and output was correct in the first letter.

>> Board-supplied data 1)
>>
>> Mapping table, each entry containing:
>> * Driver name/pointer
>> * Name of function seen by driver
>> * Pin/pingroup name to configure
>> * Name of driver function to apply to pin/pingroup

This I think is what we have now.

>> Note that I assume there may be multiple rows for any combination of the
>> first two fields in this table, and that all will be operated on by a
>> single pinmux_get()/pinmux_enable() call.

We don't have these multiple rows yet. But I'll try
to implement that.

>> Some enhancements in the above list of tables over previous times that I've
>> talked about this:
>>
>> * Created a separate optional table for a list of pingroups, thus not
>> burdening SoCs other than Tegra with the pingroup concept.

Nah I made it compulsory for pinmux drivers to define their
affected group of pins using an associated abstract pin group.
Makes more sense to me and makes for code reuse if the
groups are used for other things.

>> * Allow either a pin or pingroup name in the driver's "table of legal
>> functions per pin" and the "mapping table"; core can simply look through
>> the pingroup table if present, then fall back to looking in pin table,
>> when determining what a pin/pingroup name means.

Simplified by mandating to use groups. I hope.
A pin table would be equivalent to a group anyway,
just not having its own data structure.

>> * I assume that entries in the "table of pins" or "table of pingroups"
>> might have no corresponding entries in " Table of legal functions per
>> pin"; in this case, those pin/pingroup names would only be useful for
>> pinmux_config() to operate on.

I made it compulsory to associate at least one group of
pins to each function, easier to grasp.

>> P.S. I'll be on vacation 9/2-9/17. I'm not sure if I'll have any form of
>> network access during this time or not. You may not see many more pinmux
>> comments from me during that time.

No problem, I have all life to sort this out.

Thanks,
Linus Walleij
