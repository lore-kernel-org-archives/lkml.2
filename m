Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab1CRVfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:35:17 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38058 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab1CRVfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:35:10 -0400
MIME-Version: 1.0
In-Reply-To: <4D839BCD.6030202@linaro.org>
References: <20110311165642.GA9996@kroah.com> <201103172333.01474.arnd@arndb.de>
 <4D82979B.2050003@linaro.org> <201103181600.09877.arnd@arndb.de> <4D839BCD.6030202@linaro.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 18 Mar 2011 15:28:14 -0600
X-Google-Sender-Auth: isbzZlWgdx2BORXgdAa-zPrBoYI
Message-ID: <AANLkTi=Vy4Cu9rf7SpOFL1umN37bJgXhq9jEQpUrqjgw@mail.gmail.com>
Subject: Re: RFC: Platform data for onboard USB assets
To: andy.green@linaro.org
Cc: Andy Green <andy@warmcat.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg KH <greg@kroah.com>, devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 11:52 AM, Andy Green <andy@warmcat.com> wrote:
> On 03/18/2011 03:00 PM, Somebody in the thread at some point said:
>
> Hi -
>
>>> You changed your first opinion about tagging "dynamically probed
>>> devices" with what is effectively platform_data, cool.
>>
>> I still don't like the idea of attaching platform_data to more
>> devices, when we try to move people away from that in other
>> parts of the kernel, because of the known deficiencies.
>
> Whatever way you look at it, data delivered into the driver by Device Tree
> is fundamentally the same action as delivering data into the driver by
> platform_data.  Yes, you query by named element with device context, but you
> end up with the same answer as if you dereference a platform_data member.
>  There are no "known deficiencies" to platform_data for this action either,
> at least, not known to me, I don't think lack of typechecking on the pointer
> itself is an issue given the accuracy it can be targeted to a
> soldered-on-the-board device.

Apologies if we got a little carried away on the device tree side
topic; it is something that needs to be investigated regardless and
that unfortunately ended up co-opting this thread.  You're right that
on ARM device tree is optional and a solution is required for
!CONFIG_OF.

However, at issue here is that platform_data sucks hard, and
asynchronous platform data sucks harder.  I think I can go out on a
limb and say that platform_data is viewed with distaste by more people
than just Arnd and me.  It sucks because it is an anonymous pointer
with absolutely zero chance of verifying that the driver has the right
thing when it comes out the other end at the driver.  This means the
very real possibility of dereferencing the wrong structure and the
kernel oopsing or worse.

For current {platform,i2c,spi} device users, there is at least some
level of protection in that the specific driver and the specific pdata
is specified at exactly the same time in the same place in the source
code.  If a driver changes the pdata structure it expects, then it is
easy to find all the users (at least for all in-tree users), but it
still sucks.  gcc cannot tell us when it is wrong, and the kernel
cannot validate it at runtime.  One reason the DT has been preferred
over platform_data in this discussion is because it does *not* carry
the risk of dereferencing the wrong structure.

Asynchronously attached pdata sucks harder because the selected driver
is completely dissociated from the pdata type.  Not even the i2c and
spi board info structures have this issue.  At least the board info
structures have the driver and the pdata settings co-located.

I certainly have no intention of trying to migrate
{platform,i2c,spi}_device away from platform_data, but I will actively
nack any attempt to bring it into other subsystems.  There are better
ways.  Device tree is one option, but I will accept other approaches.
Using domain specific api, such as to retrieve the correct MAC address
is one idea that's been raised.  Regardless, the ability to validate
the data passed to the driver, either at compile or runtime, is a hard
requirement in my mind.

>> Passing a MAC address in a device tree property is a
>> well-established method that is used on many drivers, and
>> is portable across operating systems and architectures.
>
> If you're talking about Device Tree, that itself is not at all "well
> established" let alone servicing drivers from it.  Like I say I don't want
> to seem like I am down on it, but it is very new indeed let's face it and
> few drivers are using it for functional configuration information compared
> to vast numbers using platform_data.
>
> =====> If Device Tree APIs is mandated to implement functionality fixes to
> drivers and platform_data is blocked for this, then we end up with
> different, rotting functionality for platform_data basis and drivers that
> remain broken on the many, many, platforms that don't have and will never
> have Device Tree.  That does NOT sound like the right approach.
>
> I guess the grand plan is to eliminate platform_data by overwhelming it with
> Device Tree refactoring.  But each driver has to be tested and each board
> definition file changed... that is a huge, huge undertaking that will not
> happen in any kind of medium and perhaps not long term either.

Nope, not the plan.

> At least we agree there's no point to target pluggable devices with either
> solution, in which case platform_data and Device Tree provide the same end
> result, plus or minus extra query API.

Right, if it is detectable it has no business being described
anywhere, whether it be platform_data, a dt node, or something else.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
