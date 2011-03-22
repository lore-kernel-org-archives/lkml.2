Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1CVWhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:37:51 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60643 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab1CVWhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:37:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=ld4W6Zb3C8ggnm8qofRe4bP6Iu4M5zI1U4pOCQuoMaMgsEGyNwdOP/QKB2GrpiEJL1
         M6f8HJKzE6IJlqJdj7tB3Ia5joBd7RgnyGCFzH9fOMEJ01hw58W5kUbH08OfV432wbsa
         xtGMpeGOSrbwc/LluSrEQPOmBYoA2cCSjjTOU=
Message-ID: <4D8924B6.8040403@linaro.org>
Date: Tue, 22 Mar 2011 22:37:42 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com, grant.likely@secretlab.ca,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <4D79F068.2080009@linaro.org>	 <AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com> <1300828125.2402.300.camel@pasglop>
In-Reply-To: <1300828125.2402.300.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2011 09:08 PM, Somebody in the thread at some point said:
>> Q(b) If yes, what 'key' is most suitable for identifying the right
>> device
>>    to attach the data to ?
>
> We already pointed out that in the case of soldered-in device, the
> "path" as in the series of -physical- ports leading to the device is
> going to be stable.

Agreed.

> For anything else, there's no solution. If the device doesn't have a
> unique ID, you are toast, period.

If you mean pluggable device tagging then I also agree it's for sure not 
in scope for this kind of action.

> On the other hand, I still think platform_data suck big time. Grant made
> some good points about the lack of proper typing for example. I believe

Well, you share that opinion with Grant at least, although reasons to 
back it up were in shorter supply.  "Proper typing" as a serious issue 
with platform_data rather than just being an impressive-sounding claim 
-- or a "good point" -- doesn't resonate with me at all  -->

There is proper typing for the all the members of the platform_data 
structs on both sides; both the board definition file and the driver 
both deal with a member u8 mac[6] as a u8 mac[6], say.  The only time a 
void * is involved is so the generic struct device can point to the 
driver-specific platform_data struct.  I guess we agree about that much, 
that the scope of untyped members is just void * one per struct device, 
to the platform_data.  Otherwise the thing is typesafe either side for 
members.

If the board definition file put a pointer to the wrong platform data 
struct in a device, it's true it'd accept it at compiletime and crash 
and burn at runtime.  But it'd be a gross bug in the code that'd always 
be wrong, like attaching platform data for configuring a usb host to a 
uart device or so.  It seems the guy writing this will notice quickly 
his uart doesn't work or blows OOPSes and investigate and permanently 
fix it.  The fallout of the void * involved is limited to that situation 
alone.

Likewise if the device path mapping stuff works as it seems is now 
generally accepted it would within restrictions typical for SoC 
environment, you either wrote code to deliver the right or the wrong 
platform_data there.  If it can't be you soldered a WLAN module on mmc1, 
you attach async platform_data appropriate for the WLAN module's driver, 
but actually, a WiMAX driver got applied and now the platform_data via 
the void * is wrong; the whole situation would be wrong because the 
wrong driver came.

So while I see the point about void * and no type checking, it doesn't 
allow any more subtle error than pointing at the wrong or the right 
platform_data struct in the code.  In practice, you will notice that 
whatever it is you thought you were setting via platform_data is getting 
set to something uncontrolled if it is "not the platform_data you are 
looking for" and go fix it in the code.  For these reasons of its 
problem being in such a narrow domain, it seems to me quite a weak stick 
to wave at platform_data.

> that a device-tree based approach is much better in the long run (and
> more flexible) despite Andy odd quasi-religious aversion for it.

As Mark Brown wrote earlier about this, the Device Tree "implementation 
just isn't there in mainline".

-Andy
