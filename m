Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab0JKKIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 06:08:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61268 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab0JKKIa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 06:08:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l7UTQkPz4IYKJL//qQm0ErmfNY2lxOPwb+PvIXE5/XvkoR3E1GVL8KLyHXHm9DxAyZ
         gaDh4bMhYbZfetNZg7Op3OWDYyUEp58vIl20JUgSwdGYT/98tPzez1fJZkINpuOXCitw
         Sh2jYeBR0lEwNjht9kDAWytSiDQ/Vmho9hSaM=
MIME-Version: 1.0
In-Reply-To: <20101011092424.GX29673@pengutronix.de>
References: <20101008175308.GA10975@n2100.arm.linux.org.uk>
	<AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com>
	<20101008230451.GB10975@n2100.arm.linux.org.uk>
	<20101008232539.GA28697@kroah.com>
	<20101008234448.GD10975@n2100.arm.linux.org.uk>
	<AANLkTinhwORqdWU43yr1AXJGZm2zPKGG+Q9twruNs2aH@mail.gmail.com>
	<20101009092127.GB20975@n2100.arm.linux.org.uk>
	<AANLkTimQJLmDZPHtVJLCv9ZQgx_Yjh9=MOwOxMSAz4QX@mail.gmail.com>
	<20101011083508.GW29673@pengutronix.de>
	<20101011090212.GA27153@n2100.arm.linux.org.uk>
	<20101011092424.GX29673@pengutronix.de>
Date: Mon, 11 Oct 2010 13:08:29 +0300
Message-ID: <AANLkTikYRfK-KHYxPL5y4z7kbb0YVn2y0CiYiMvWDsB-@mail.gmail.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Felipe Contreras <felipe.contreras@gmail.com>
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <greg@kroah.com>, linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        Hemant Pedanekar <hemantp@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/11 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> On Mon, Oct 11, 2010 at 10:02:12AM +0100, Russell King - ARM Linux wrote:
>> On Mon, Oct 11, 2010 at 10:35:08AM +0200, Uwe Kleine-König wrote:
>> > Alternatively when calling fixup only after parse_tags in setup_arch()
>> > it worked.  But I guess this change is not for discussion.
>> > OTOH I wonder why fixup gets passed meminfo.  It's not very useful if
>> > it's not yet filled.
>>
>> Because, rather than pass in ATAGs or set the memory on the command line,
>> they instead wanted to hard-code it in C - something which still happens
>> today:
>>
>> arch/arm/mach-msm/board-halibut.c
>> arch/arm/mach-msm/board-mahimahi.c
>> arch/arm/mach-msm/board-sapphire.c
>> arch/arm/mach-msm/board-trout.c
>> arch/arm/mach-pxa/eseries.c
>> arch/arm/mach-pxa/spitz.c
>> arch/arm/mach-s3c2412/mach-smdk2413.c
>> arch/arm/mach-s3c2412/mach-vstms.c
>> arch/arm/mach-tegra/board-harmony.c
>>
>> This is part of the on-going pain of poor quality boot loaders.
> Yep, so (at least regarding the memory layout) the name "fixup" is
> wrong, it's more "initializ"ish.
>
> So what now?  Do the memory reservation in mdesc->reserve as Felipe
> suggested?

I read some fixups(), some boards seem to fill meminfo, so I thought
moving after parsing the tags would cause problems.

My proposal is also not correct because as Russell said, reserve()
callbacks expect memblock to already have memory configured.

My original patch had a reserve_mem() instead, that was passed with
'meminfo'. That would not conflict with any existing behavior.

A bit independently to this is the fact that I couldn't
memblock_reserve() the areas I kicked out of meminfo (couldn't see why
due to my environment), which I think is not ideal.


So, coming back to the arguments. I think Russell should have tried
this and provided an example of what to do, and how. I think it should
be clear by now that there's not much known affected drivers can do
right now.

And yet, I feel there would be more affected drivers we don't know
about, and doing WARN_ON on .36 and prohibit only afterwards can only
help.

-- 
Felipe Contreras
