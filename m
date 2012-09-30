Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389Ab2I3Ow3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 10:52:29 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:61873 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab2I3Ow2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 10:52:28 -0400
MIME-Version: 1.0
In-Reply-To: <50682402.8020402@antcom.de>
References: <1348780923-27428-1-git-send-email-stigge@antcom.de>
	<CAOY=C6GG6jqqEAAGJjmDG-BFT2eq=9+ck+F_EOcthRgDCDv8=Q@mail.gmail.com>
	<50682402.8020402@antcom.de>
Date: Sun, 30 Sep 2012 16:52:27 +0200
Message-ID: <CAOY=C6FaLckRHSfAHvw2=J9xZEVFDZPL+1oKnKeGnpOGPFVB1w@mail.gmail.com>
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
From: Stijn Devriendt <highguy@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        bgat@billgatliff.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2012 at 12:50 PM, Roland Stigge <stigge@antcom.de> wrote:
> On 30/09/12 11:35, Stijn Devriendt wrote:
>> In our kernel tree we have similar code. If you like I can request
>> permission
>> to share. I can, however, already give you an update on the basic
>> structure, perhaps
>> it's useful now.
>>
>> For the first part, the drivers need to implement a the gpio interface
>> for groups.
>> gpio_set_multi, gpio_get_multi, gpio_direction_input_multi,
>> gpio_direction_output_multi. Each of them gets a 'u32 mask'.
>>
>> Secondly, gpiolib gets some new code to handle groups:
>> groups are requested via a list of gpio ids. Mind that order is respected:
>> request( [1, 5, 2, 4] ) followed by a set(0x5) will translate to
>> gpio_set_multi( 0x18 ). An opaque gpio_group struct is used to keep track.
>> This means the gpiolib interface also has a u32 mask, but translation is
>> done for the gpio-drivers.
>>
>> There is some code to request groups via device-tree (again respecting
>> order)
>> and there are also platform driver structures.
>>
>> gpiolib was also extended to export groups into sysfs, respecting policy
>> (input, output, user-selectable) and to make softlinks to groups in other
>> driver's subdir. (One driver we use this in is a power-sequencer with 2
>> gpios selecting a margining profile, this driver then has the gpio_group
>> exported in it's sysfs dir as .../profile, allowing H/W engineers to select
>> the profile without voltage glitches)
>>
>> There's also a separate driver, that does nothing more than exporting
>> both individual pins and groups to userspace based on platform description
>> or devicetree. This is probably less interesting for mainline, since we're
>> abusing device-tree to do away with some init script that can do the same.
>>
>> The rationale behind a 32bit mask is that typical processors can at most
>> set one processor-word worth of GPIOs at once and there are probably
>> few chips with over 32GPIOs on a single gpio_chip anyway.
>> Nevertheless, in the era of 64bit, it's definitely possible to go for
>> u64 instead.
>
> Hi Stijn,
>
> thank you for your notes!
>
> Besides what I discussed with JC and Linus, I find the unsigned int
> (i.e. u32 or u64, depending on the arch) quite appealing. It is a nice
> compromise between my general bit mapped data model (variable size *u8
> array) and the bool *values list. Even maps easily onto a single sysfs
> entry for values, by abstracting a gpio list to an actual data word.
>
> What do others think? JC? Linus? I'm considering this (unsigned int
> data) a valid option.
>
> One question: How did you solve the one-value-per-file in the sysfs
> interface?
>
By exporting the group as a whole:
/sys/.../gpiogroup248/value
where value contains a decimal representing the group value.
Again, this respects the ordering of the pins:

Actual pins: 0x2D (b 0010 1101)
Selected pins: 6 3 0 1
Readout: 6 (b 0 1 1 0)

The export sysfs file does, however, accept multiple gpio IDs for groups.
Not sure if this is a 'violation' per se... If the user stores a single value
he gets a single pin, multiple (space-separated) values give him a group.

Regards,
Stijn
