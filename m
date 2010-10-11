Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab0JKMEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 08:04:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54107 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab0JKMD7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 08:03:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X8LgP3iIsbbBSVIPm/LPeMLQg2EffiVpB3wZhWhprbofwTPgGZ48BdKSatvJLg9Z6U
         zpWXoqOJ8AEhXh3f1I1n11GWu/ITLSVae4Vvb6xVd1NAhC/2cnx0UsMtNsgUZ+WuPn3L
         KPkoTdjjhFFBeXfo9jZd3nQ4XSRWWdFmHAO88=
MIME-Version: 1.0
In-Reply-To: <1286796187.19739.52.camel@e102109-lin.cambridge.arm.com>
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
Date: Mon, 11 Oct 2010 15:03:58 +0300
Message-ID: <AANLkTinHZ-w6=0RvVp39MnvpRC7RW1CYNSbzi2f1OvaQ@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 2:23 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Mon, 2010-10-11 at 11:39 +0100, Felipe Contreras wrote:
>> On Mon, Oct 11, 2010 at 1:05 PM, Catalin Marinas
>> <catalin.marinas@arm.com> wrote:
>> > We could be a bit more flexible as a temporary solution. But that's a
>> > hack and doesn't guarantee the attributes that the driver requested. If
>> > the driver would use writel/readl, that's not too bad since we pushed
>> > explicit barriers in these macros.
>> >
>> > It would need to be improved to invalidate the corresponding cache lines
>> > (using the DMA API?) but it would look even worse.
>> >
>> >
>> > diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
>> > index 6bdf42c..082bbd0 100644
>> > --- a/arch/arm/mm/ioremap.c
>> > +++ b/arch/arm/mm/ioremap.c
>> > @@ -204,10 +204,13 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
>> >  #endif
>> >
>> >        /*
>> > -        * Don't allow RAM to be mapped - this causes problems with ARMv6+
>> > +        * Don't allow RAM to be mapped as Device memory - this causes
>> > +        * problems with ARMv6+
>> >         */
>> >        if (WARN_ON(pfn_valid(pfn)))
>> > -               return NULL;
>> > +               if (__LINUX_ARM_ARCH__ >= 6 &&
>> > +                   (mtype != MT_DEVICE_CACHED || mtype != MT_DEVICE_WC))
>> > +                       mtype = MT_DEVICE_WC;
>> >
>> >        type = get_mem_type(mtype);
>> >        if (!type)
>>
>> I will try that, but from what I can see this might still break some
>> drivers, right?
>
> Probably, it depends on how drivers use the memory returned by ioremap
> and the assumptions they make about the memory type (strict ordering,
> write buffers, speculation). I think such memory should be used via the
> I/O accessors and not directly, so you get the benefit of explicit
> memory barriers. If not, you have to cope with the loss of attributes
> because of the WC mapping.
>
> But as it has been said (and it's my opinion as well), the drivers are
> broken and are misusing the ioremap API.

Indeed, that is understood by everyone.

But what I think should happen on .36 is that the warning is on, and
the behavior doesn't change compared to .35. Your patch is changing
the behavior as you say in hacky way, which might have unintended
consequences in the affected drivers, I don't think that's ideal,
although it's better than breaking them completely.

>> Anyway, I'm reading the TRM and I can't find any mention of this.
>> Catalin, can you point out where is this mentioned, and also, can you
>> confirm if this would affect only the memory that has the double
>> mapping, or it can corrupt other memory as well?
>
> That's in the ARM ARM (Architecture Reference Manual), not a TRM.
>
> You never know what "unpredictable" means and this is specific to the
> processor implementation, not the ARM ARM. You should not mix different
> memory types for the same page.

Certainly, but saying corruption _will_ happen elsewhere is not
correct, there is no empirical evidence for that, although
theoretically it might happen.

Considering that, and the fact that .35 is not considered to be
horribly broken (or any of the previous releases), then having one
more releases with this broken behavior as a grace period wouldn't
hurt anybody.

> Back in 2006 there was a discussion for a set of palliative measures in
> hardware (initially until the OSes are fixed) and these allow the same
> memory type but with different cacheability attributes (e.g. Normal
> Non-cacheable vs Normal Cacheable) given that care is taken in software
> wrt stale cache lines and speculation (but at least you don't get random
> corruption somewhere else). They would need to have the same
> shareability attributes though.
>
> With the hack above, MT_DEVICE_WC is actually Normal Non-cacheable
> memory. It needs cache flushing but it's not worse than the original
> ioremap allowing this. The driver may not work as expected though.

I see, but are you saying that if the shareability is not the same,
then corruption elsewhere might actually happen? Or it would happen
most likely on the affected region? If it's the former, then I agree
that your patch should be used instead.

-- 
Felipe Contreras
