Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab0JNPCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 11:02:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43966 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab0JNPCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 11:02:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xOfM0kgUbzwGJEZ861+X3omhPFkL9rHV2ibATUB0qD4X6azT60LhzGRd1vs0G9aY8q
         PjR10S7xIlQt0C7gi2gd2gbTcHS21lzAvfjkOopZkt18da3bcCUaNQMryNxhHIrXg3aJ
         vGSzqc/dwfQZBiFSiecO9vrRbuehxHWUFxvow=
MIME-Version: 1.0
In-Reply-To: <1286800232.19739.96.camel@e102109-lin.cambridge.arm.com>
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
Date: Thu, 14 Oct 2010 18:02:30 +0300
Message-ID: <AANLkTinsQVvoxeNGO6ToyKnFTdA=GfjdoY2yEQ3adHVA@mail.gmail.com>
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

On Mon, Oct 11, 2010 at 3:30 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Mon, 2010-10-11 at 13:03 +0100, Felipe Contreras wrote:
>> On Mon, Oct 11, 2010 at 2:23 PM, Catalin Marinas
>> <catalin.marinas@arm.com> wrote:
>> > On Mon, 2010-10-11 at 11:39 +0100, Felipe Contreras wrote:
>> >> I will try that, but from what I can see this might still break some
>> >> drivers, right?
>> >
>> > Probably, it depends on how drivers use the memory returned by ioremap
>> > and the assumptions they make about the memory type (strict ordering,
>> > write buffers, speculation). I think such memory should be used via the
>> > I/O accessors and not directly, so you get the benefit of explicit
>> > memory barriers. If not, you have to cope with the loss of attributes
>> > because of the WC mapping.
>> >
>> > But as it has been said (and it's my opinion as well), the drivers are
>> > broken and are misusing the ioremap API.
>>
>> Indeed, that is understood by everyone.
>>
>> But what I think should happen on .36 is that the warning is on, and
>> the behavior doesn't change compared to .35. Your patch is changing
>> the behavior as you say in hacky way, which might have unintended
>> consequences in the affected drivers, I don't think that's ideal,
>> although it's better than breaking them completely.
>
> Well, even if you allow Device memory via ioremap in Linux and the
> hardware behaviour is not "unpredictable", it is not guaranteed to act
> as a Device memory. You get speculative accesses via the Normal alias
> and you may also get dirty cache lines evicted at random from the Normal
> mapping (unless you invalidated the cache before). The dirty eviction is
> valid even for pre-ARMv6 processors.

I'm not familiar with device memory, but anyway, IIUC you are saying
the normal mapping (original) might not work as expected... That's ok,
because the only alias that uses after the ioremap() is the second
one.

>> >> Anyway, I'm reading the TRM and I can't find any mention of this.
>> >> Catalin, can you point out where is this mentioned, and also, can you
>> >> confirm if this would affect only the memory that has the double
>> >> mapping, or it can corrupt other memory as well?
>> >
>> > That's in the ARM ARM (Architecture Reference Manual), not a TRM.
>> >
>> > You never know what "unpredictable" means and this is specific to the
>> > processor implementation, not the ARM ARM. You should not mix different
>> > memory types for the same page.
>>
>> Certainly, but saying corruption _will_ happen elsewhere is not
>> correct, there is no empirical evidence for that, although
>> theoretically it might happen.
>
> It may be just theoretical but architecture licensees implement the
> hardware according to the ARM ARM. If it says "unpredictable", they
> don't need to care much about this scenario as it is not allowed in
> software and the hardware can be further optimised (well, I think
> "unpredictable" doesn't allow hardware deadlocking or security
> implications, so the memory corruption cannot be that random, possibly
> just restricted to that memory range). It is probably ok on current
> hardware but I cannot guarantee, you would have to check on a
> case-by-case basis (CPU implementation).

Exactly, so it's not the end of the world if this is still allowed one
more release.

>> > Back in 2006 there was a discussion for a set of palliative measures in
>> > hardware (initially until the OSes are fixed) and these allow the same
>> > memory type but with different cacheability attributes (e.g. Normal
>> > Non-cacheable vs Normal Cacheable) given that care is taken in software
>> > wrt stale cache lines and speculation (but at least you don't get random
>> > corruption somewhere else). They would need to have the same
>> > shareability attributes though.
>> >
>> > With the hack above, MT_DEVICE_WC is actually Normal Non-cacheable
>> > memory. It needs cache flushing but it's not worse than the original
>> > ioremap allowing this. The driver may not work as expected though.
>>
>> I see, but are you saying that if the shareability is not the same,
>> then corruption elsewhere might actually happen? Or it would happen
>> most likely on the affected region? If it's the former, then I agree
>> that your patch should be used instead.
>
> Pretty much same answer as above. But why do you need different
> shareability attributes?

Well, I'm not familiar with the shareability attributes, but from what
I could grep from the code, the tidspbridge driver is doing
readl/writel on this memory, so I think device memory is supposed to
be used for that. Granted, this is probably a very bad usage from the
driver, but this was allowed on 2.6.35, so I think the same should
happen on 2.6.36, but with a warning.

However, as I said, I'm concerned about other drivers that have not
yet been detected that would be broken by 309caa9 once .36 is
released, I think your patch should be enough to detect them and at
the same time do something relatively sane. If they get broken by the
shareability change, they probably were in too bad shape anyway.

So, +1 to your patch.

FWIW, your patch seems to work with tidspbridge

Cheers.

-- 
Felipe Contreras
