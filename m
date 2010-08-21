Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab0HUHK1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 03:10:27 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46828 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab0HUHK0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 03:10:26 -0400
MIME-Version: 1.0
In-Reply-To: <87y6c03jxj.fsf@deeprootsystems.com>
References: <1281484174-32174-1-git-send-email-ppannuto@codeaurora.org>
 <1281484174-32174-3-git-send-email-ppannuto@codeaurora.org>
 <3F978429-F916-42E5-8B36-6AC02DAC8CA2@boeing.com> <AANLkTi=Pm8BL+Ksq1o7MYpV7mMH10bEPu1=Am9EgT-Kk@mail.gmail.com>
 <87hbiql89d.fsf@deeprootsystems.com> <AANLkTinaddiPAcokH3fRVYAFf3N-Gz--U5Jd1iyNsi+m@mail.gmail.com>
 <87hbip9kxx.fsf@deeprootsystems.com> <AANLkTine=VLLm4+ReKeMKBdbV1JsunNagwKxGMDhEe8e@mail.gmail.com>
 <87y6c03jxj.fsf@deeprootsystems.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 21 Aug 2010 01:10:05 -0600
X-Google-Sender-Auth: 31jIEXiKhKP4BVewQ5-a0-d54Zo
Message-ID: <AANLkTi=WKcb59jJQuLVfqJG07Et+cU75GOC5Lrr_dXR4@mail.gmail.com>
Subject: Re: [PATCH 2/2] platform: Facilitate the creation of pseudo-platform buses
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>,
        Patrick Pannuto <ppannuto@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "magnus.damm@gmail.com" <magnus.damm@gmail.com>,
        "gregkh@suse.de" <gregkh@suse.de>, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <damm@opensource.se>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Eric Miao <eric.y.miao@gmail.com>, Dmitry Torokhov <dtor@mail.ru>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kyle D Moffett <kyle@moffetthome.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 6:10 PM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
> Grant Likely <grant.likely@secretlab.ca> writes:
>
> [...]
>
>>>>
>>>> My fears on this point may very well be unfounded.  This isn't the
>>>> hill I'm going to die on either.  Show me an implementation of driver
>>>> sharing that is clean and prove me wrong!  :-)
>>>
>>> IMHO, simply overriding the few dev_pm_ops methods was the cleanest and
>>> simplest.
>>>
>>> Since we seem to be in agreement now that the a new bus may not the
>>> right abstraction for this (since we want it to be completely
>>> transparent to the drivers), I'll go back to the original design.  No new
>>> bus types, keep the platform_bus as is, but simply override the few
>>> dev_pm_ops methods I care about.  This is what is done on SH,
>>> SH-Mobile[1] and my original version for OMAP that started this
>>> conversation.
>>>
>>> Yes, the weak-symbol method of overriding is not scalable, but that's a
>>> separate issue from whether or not to create a new bus.  I have a
>>> proposed fix for the weak which I'll post shortly.
>>
>> Okay.
>>
>> One constraint remains though:  If you can override the dev_pm_ops on
>> a per-device or per-device-parent basis, then you've got my support.
>
> hmm, a new requirement?, and one that would require some significant
> changes to the driver model.

Nope!  Not a new requirement; this is the issue that this entire
thread has been about.  Hijacking the entire platform_bus_type
behaviour for a particular bus is the wrong thing to do because there
are other users in the same system.

> Currently, dev_pm_ops for a bus applies globally to *all* devices on
> that bus (or class or type) and changing that would require changing the
> platform_bus code to start having per-device (or per-parent-device)
> checks.

I'm not opposed to modifying the platform_bus_type to support the use-case.

>> If the override (even when fixed to work at runtime) applies to every
>> device on the platform_bus_type, then I'll nack it.
>
> /me can't help but wonder why the OMAP implementation is getting all the
> negative attention while the other identical implementations are already
> upstream.

OMAP is not getting singled out.  This applies to all the implementations.

>> My concern here is that the SoC or platform support code doesn't get
>> to "own" the platform_bus_type.
>
> Well, I'm not proposing that here.  This "feature" already exists in
> mainline (albeit using the less-than-optimal weak symbol approach.)  All
> I'm proposing is fixing it to make it multi-arch friendly.

Oops, I didn't phrase that very well.  What I meant was that SoC or
platform support code must not be allowed to "own" or hijack the
platform_bus_type for it's own purposes.  What I wrote sounds like I
was suggesting that as a good thing.

> If you think this behavior should be changed to non global, that should
> be done a separate series since it is not directly related to runtime PM
> support for a given platform, IMO.
>
>> Other drivers/code can register their own set of
>> platform_devices, which may also need to perform their own dev_pm_ops
>> override.
>
> IMHO, we should deal with such hypothetical, future problems *if* they
> arise down the road.
>
>> If the override is global to the platform_bus_type, then the model
>> will not scale.
>
> It will not scale any more (or less) than the current functionality of
> the driver model which handles this globally.  Again, if scalabilty
> becomes a problem down the road, lets fix it then.

Alright, I can agree to that.  I do agree that the runtime override is
far and away better than the weak symbol approach.  However, there
needs to be some very clear rules in place for users of the override,
namely that users must understand that they are stewards of the
platform_bus_type, and must take care to preserve the default
behaviour for "uninteresting" devices.

Also, the expectation should be that it is a temporary measure until a
better abstraction is implemented.  It might be that a separate
bus_type is the way to go (if the multiple driver registration problem
can be solved) or it might be a way to differentiate pm_ops either
per-device or per-parent.  I'm not sure, but I'm starting on an OMAP
project soon, so I may very well end up working on this.

Cheers,
g.
