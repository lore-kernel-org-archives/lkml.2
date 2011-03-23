Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab1CWKL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:11:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53195 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407Ab1CWKGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:06:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=YUH2K7ThPvmgPOi3qZknm3flUZxARWi/YVg8wByQGiC5Lsmi6OWW3g28FYFAhwUD+L
         5RAw9z0KUhCqYz8RZgX2TKsF9anh1HfLflZv0C5tn0qxxRVOTI1Kv4w1SXeuOqjigW9G
         rCxMx2fysP7a6iD9TQDbrQmrSv/9owJTxyqgg=
Message-ID: <4D89C618.1020608@linaro.org>
Date: Wed, 23 Mar 2011 10:06:16 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com, grant.likely@secretlab.ca
Subject: Re: RFC: Platform data for onboard USB assets
References: <4D79F068.2080009@linaro.org>	<AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com>	<1300828125.2402.300.camel@pasglop>	<4D8924B6.8040403@linaro.org>	<1300842219.2402.309.camel@pasglop>	<alpine.LFD.2.00.1103222138320.11889@xanadu.home>	<1300850595.2402.320.camel@pasglop>	<4D89BDE2.60907@linaro.org> <20110323094720.63e7c6b2@lxorguk.ukuu.org.uk>
In-Reply-To: <20110323094720.63e7c6b2@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2011 09:47 AM, Somebody in the thread at some point said:
>> There is no udev solution for what is being done currently by the async
>> platform_data patchset with SDIO WLAN.  The patches are out there and in
>> use already.  The only reason I don't post them here as round 2 of the
>> RFC yet is because Grant wanted a couple of days and politically it's
>> expedient for me to agree to that.
>
> Kernel policy has always been that just because some vendor has deployed
> an interface doesn't mean we care one iota about it or consider it an
> argument for the solution. In some cases in fact it bcomes the working
> demo of why it was a bad idea.

To be clear, this is not about any funny business at the interface on 
the hardware.

The SDIO patches target wl12xx that is already in mainline and already 
using literally platform_data.  Because there's no neater way on offer, 
it currently -- in mainline -- does it by having a built-in stub with 
its own Kconfig, that copies platform_data from the board definition 
file into a private malloc'd buffer, then uses it by getting a pointer 
to the copy from another private api in the driver.  All this in a 
specific driver.

Considering the driver for SDIO WLAN modules like this must be told 
critical stuff like which irq line they are wired up to, which is an 
attribute of the physical board, having the async platform_data support 
is making things cleaner and more generic in mainline directly in this 
case at least.

>> But there are a huge number of users of platform_data in mainline
>> already we can agree.  Are you talking about a mass conversion of those
>> to eliminating platform_data so they use your preferred token query model?
>
> Ultimately that will probably be worth doing once we have some kind of
> meaningful model. We've actually been slowly beating platform devices
> into making more use of the resource data it does have when possible, and
> we have various parsers between platform data and device specific
> platform data structs that are horrible glue-together jobs that it would
> be nice to stomp on.

For devices that are probed asynchronously though, resource and 
platform_data have the same issue they can't be attached until the 
device is instantiated.

>> I think the first additional effort needs to start at home on that one
>> and think through Device Tree and kernel policy on interoperation with
>> existing driver implementations using platform_data.  Just being sniffy
>> about platform_data for reasons you can't back up when challenged won't
>> cut it IMO.
>
> Much of this depends upon what the data is and what it changes. Things
> like interface names for example shouldn't be kernel mangled on the whim
> of random board vendors. They follow a unified behaviour *across*
> platforms, which is what matters most in the bigger picture.
>
> Other stuff is to all intents and purposes sometimes hard coded into
> drivers because while they are USB drivers they are checking specific
> vendor id fields and changing behaviour on them. In some cases those
> vendor id fields are actually a specific hardwired device.

It's the case for even usbnet, which is using a broken heuristic to 
decide what to call the interface not even based on vid / pid.

Anyway I am reconciled changing device names to fit the physical board 
setup isn't going to fly, it's more important to find out if async 
platform_data as a concept will fly.

Before this RFC there's no generic support for the concept, although 
that hasn't stopped it being implemented in wl12xx already at individual 
mainline driver level.  And before this RFC, I don't believe there was 
any concept of async tagging through bus path for soldered-on assets in 
Device Tree either.

-Andy
