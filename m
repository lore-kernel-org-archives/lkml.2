Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934699Ab0HEXQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 19:16:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38580 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934505Ab0HEXQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 19:16:31 -0400
MIME-Version: 1.0
In-Reply-To: <87fwytxdba.fsf@deeprootsystems.com>
References: <4C59E654.1090403@codeaurora.org> <877hk56hiy.fsf@deeprootsystems.com> 
	<4C5A0C68.9080500@codeaurora.org> <87fwytxdba.fsf@deeprootsystems.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 5 Aug 2010 17:16:10 -0600
X-Google-Sender-Auth: fQsjr4Mfpu_dvUOGSObcgeVkEdc
Message-ID: <AANLkTimCS4RV+8E_ZzX97=r5rmQR3nmizp0JYK+syLRa@mail.gmail.com>
Subject: Re: [PATCH] platform: Facilitate the creation of pseduo-platform 
	busses
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Patrick Pannuto <ppannuto@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "damm@opensource.se" <damm@opensource.se>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "eric.y.miao@gmail.com" <eric.y.miao@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, alan@lxorguk.ukuu.org.uk,
        zt.tmzt@gmail.com, magnus.damm@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 9:57 AM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
> Patrick Pannuto <ppannuto@codeaurora.org> writes:
>
>> On 08/04/2010 05:16 PM, Kevin Hilman wrote:
>>> Patrick Pannuto <ppannuto@codeaurora.org> writes:
>>>
>>>> Inspiration for this comes from:
>>>> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg31161.html
>>>
>>> Also, later in that thread I also wrote[1] what seems to be the core of
>>> what you've done here: namely, allow platform_devices and
>>> platform_drivers to to be used on custom busses.  Patch is at the end of
>>> this mail with a more focused changelog.  As Greg suggested in his reply
>>> to your first version, this part could be merged today, and the
>>> platform_bus_init stuff could be added later, after some more review.
>>> Some comments below...
>>>
>>
>> I can split this into 2 patches.
>
> Yes, I think that would be better.
>
>> Was your patch sent to linux-kernel or just linux-omap? I'm not on linux-omap...
>
> That thread was on linux-arm-kernel and linux-omap
>
>>
>>>> [snip]
>>>>
>>>> Which will allow the same driver to easily to used on either
>>>> the platform bus or the newly defined bus type.
>>>
>>> Except it requires a re-compile.
>>>
>>> Rather than doing this at compile time, it would be better to support
>>> legacy devices at runtime.  You could handle this by simply registering
>>> the driver on the custom bus and the platform_bus and let the bus
>>> matching code handle it.  Then, the same binary would work on both
>>> legacy and updated SoCs.
>>>
>>
>> Can you safely register a driver on more than one bus? I didn't think
>> that was safe -- normally it's impossible since you're calling
>>
>> struct BUS_TYPE_driver mydriver;
>> BUS_TYPE_driver_register(&mydriver)
>>
>> but now we have multiple "bus types" that are all actually platform type; still,
>> at a minimum you would need:
>>       struct platform_driver mydrvier1 = {
>>               .driver.bus = &sub_bus1,
>>       };
>>       struct platform_driver mydrvier2 = {
>>               .driver.bus = &sub_bus2,
>>       };
>> which would all point to the same driver functions, yet the respective devices
>> attached for the "same" driver would be on different buses. I fear this might
>> confuse some drivers. I don't think dynamic bus assignment is this easy
>>
>> In short: I do not believe the same driver can be registered on multiple
>> different buses -- if this is wrong, please correct me.
>
> It is possible, and currently done in powerpc land where some
> drivers handle devices on the platform_bus and the custom OF bus.

As of now, the of_platform_bus_type has been removed.  It was a bad
idea because it tried to encode non-bus-specific information into
something that was just a clone of the platform_bus.  Drivers that
worked on both had to be bound to both busses.  I do actually have
code that automatically registers a driver on more than one bus, but
it is rather a hack and was only a temporary measure.

The relevant question before going down this path is, "Is the
omap/sh/other-soc behaviour something fundamentally different from the
platform bus?  Or is it something complementary that would be better
handled with a notifier or some orthogonal method of adding new
behaviour?"

I don't have a problem with multiple platform_bus instances using the
same code (I did suggest it after all), but I do worry about muddying
the Linux device model or making it overly complex.  Binding single
drivers to multiple device types could be messy.

Cheers,
g.
