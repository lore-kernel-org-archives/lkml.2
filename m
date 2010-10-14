Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab0JNRt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 13:49:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38126 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab0JNRtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 13:49:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AbcGifqu7bdSamKUcHYZFWqUlMZdb/i0OUe+F6QVCfIYRe2qWh5GBdkIWDW2eDcvv0
         dhZAFbk9TVZzTSrhky7YquIGqc+Aiqm+x42kf3+tq+SBDEMW9k2AV+ArXmQ8KiUNCl3I
         Dp5tEovGj/dwBrx2VMJa76kXVXWsld2gkL19Y=
MIME-Version: 1.0
In-Reply-To: <1287076707.8749.12.camel@e102109-lin.cambridge.arm.com>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	<20101007192245.GC26435@n2100.arm.linux.org.uk>
	<AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
	<20101008175308.GA10975@n2100.arm.linux.org.uk>
	<AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com>
	<20101008230451.GB10975@n2100.arm.linux.org.uk>
	<20101008232539.GA28697@kroah.com>
	<20101008234448.GD10975@n2100.arm.linux.org.uk>
	<20101009000046.GA30616@kroah.com>
	<20101009002546.GB14675@n2100.arm.linux.org.uk>
	<alpine.LFD.2.00.1010082210150.3107@xanadu.home>
	<1286791544.19739.31.camel@e102109-lin.cambridge.arm.com>
	<AANLkTinMuKDpbL9ka61QhUFJfze_HWWHxjUbAqbz2_vi@mail.gmail.com>
	<1286796187.19739.52.camel@e102109-lin.cambridge.arm.com>
	<AANLkTinHZ-w6=0RvVp39MnvpRC7RW1CYNSbzi2f1OvaQ@mail.gmail.com>
	<1286800232.19739.96.camel@e102109-lin.cambridge.arm.com>
	<AANLkTinsQVvoxeNGO6ToyKnFTdA=GfjdoY2yEQ3adHVA@mail.gmail.com>
	<1287076707.8749.12.camel@e102109-lin.cambridge.arm.com>
Date: Thu, 14 Oct 2010 20:44:20 +0300
Message-ID: <AANLkTi=Nz1PxT_9GWhnRHij7S8rOHouER41Zg2ycyyok@mail.gmail.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Hannemann <arnd@arndnet.de>, Hemant Pedanekar <hemantp@ti.com>,
        Greg KH <greg@kroah.com>, linux-main <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 8:18 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Thu, 2010-10-14 at 16:02 +0100, Felipe Contreras wrote:
>> On Mon, Oct 11, 2010 at 3:30 PM, Catalin Marinas
>> <catalin.marinas@arm.com> wrote:
>> > Well, even if you allow Device memory via ioremap in Linux and the
>> > hardware behaviour is not "unpredictable", it is not guaranteed to act
>> > as a Device memory. You get speculative accesses via the Normal alias
>> > and you may also get dirty cache lines evicted at random from the Normal
>> > mapping (unless you invalidated the cache before). The dirty eviction is
>> > valid even for pre-ARMv6 processors.
>>
>> I'm not familiar with device memory, but anyway, IIUC you are saying
>> the normal mapping (original) might not work as expected... That's ok,
>> because the only alias that uses after the ioremap() is the second
>> one.
>
> No, I say that the Device memory that you are using may not work as
> expected (i.e. Device memory). The other Normal mapping may be fine but
> you don't care about it anyway.

Yes, the device memory mapping might not work as expected, it might
work as normal memory, by _may_ you are also implying it might work as
device memory on some cases. A driver might need only that, and your
change would make it _never_ work as device memory. That might or
might not be desirable, but it's a _change_, which was my point.

>> > It may be just theoretical but architecture licensees implement the
>> > hardware according to the ARM ARM. If it says "unpredictable", they
>> > don't need to care much about this scenario as it is not allowed in
>> > software and the hardware can be further optimised (well, I think
>> > "unpredictable" doesn't allow hardware deadlocking or security
>> > implications, so the memory corruption cannot be that random, possibly
>> > just restricted to that memory range). It is probably ok on current
>> > hardware but I cannot guarantee, you would have to check on a
>> > case-by-case basis (CPU implementation).
>>
>> Exactly, so it's not the end of the world if this is still allowed one
>> more release.
>
> Would there be any incentive for driver maintainers to fix the drivers
> after one more release? AFAICT, this is a violation of the ioremap API
> already.

I explained this already:

I think everyone agrees that the amount of people that try final
releases is way bigger than the ones that try release candidates, and
that's the intention. And driver maintainers (if they have actually
seen the warning) are not the only ones that can fix issues. So the
more exposure the warning has, the more chances of some contributor
fixing it.

I am not a driver maintainer, yet, for some strange reason I decided
to try 2.6.36-rc6 where I saw the warning for the first time, and I
felt compelled to fix it, and I did, thanks to Russell, but it's to
late for .36 to get this driver fixed. Who says there aren't other
people like that out there? Well, you would never know if you don't
put the warning there in the first place.

-- 
Felipe Contreras
