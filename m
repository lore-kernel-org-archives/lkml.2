Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab0JNOwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 10:52:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63845 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab0JNOwu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 10:52:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kXVSccaySFb3D8t3n+LJJy7QZ8lpDoPqkTUvtHdpwJ/z/UmRgNYMUt0I3PO2VJ/aXZ
         lhDY1hjDdERIvgnMQ5tmgH9DYDHW93CGnBTaUxAYNR6ffrO7Qt6ZWm4rm8BorPfcG+zg
         LJfCk3VerkHbNia4JWHUNG+2PXbPVR28AQbL8=
MIME-Version: 1.0
In-Reply-To: <20101011152516.GF27153@n2100.arm.linux.org.uk>
References: <20101007192245.GC26435@n2100.arm.linux.org.uk>
	<AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
	<20101008175308.GA10975@n2100.arm.linux.org.uk>
	<AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com>
	<20101008230451.GB10975@n2100.arm.linux.org.uk>
	<20101008232539.GA28697@kroah.com>
	<20101008234448.GD10975@n2100.arm.linux.org.uk>
	<AANLkTinhwORqdWU43yr1AXJGZm2zPKGG+Q9twruNs2aH@mail.gmail.com>
	<20101009092127.GB20975@n2100.arm.linux.org.uk>
	<AANLkTimQJLmDZPHtVJLCv9ZQgx_Yjh9=MOwOxMSAz4QX@mail.gmail.com>
	<20101011152516.GF27153@n2100.arm.linux.org.uk>
Date: Thu, 14 Oct 2010 17:47:09 +0300
Message-ID: <AANLkTime=tKu_F=8fvUUWkRt2xp+S5yMY8Sv0Gs4TCQ5@mail.gmail.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>, linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 6:25 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Oct 10, 2010 at 04:52:36AM +0300, Felipe Contreras wrote:
>> At the time 'fixup' is called, 'meminfo' is empty; the tags haven't
>> been parsed. So my solution is to move the memblock_add() after
>> 'reserve', and pass 'meminfo' as an argument:
>
> Here's a different approach which will work.  This pushes ARM further
> towards using memblock for everything relating to memory init (although
> we still have the old membank stuff around.)
>
> The advantage with this is that memblock is now used as the basis for
> determining where memory is, setting up the maps, freeing memory into
> the pools, etc.
>
> What this also means is that this code in the ->reserve callback:
>
>        size = min(size, SZ_2M);
>        base = memblock_alloc(size, min(align, SZ_2M));
>        memblock_free(base, size);
>        memblock_remove(base, size);

Why align to SZ_2M both the start and end?

> will result in [base+size] being removed from the available memory,
> using highmem if available, if not from lowmem and removing it from
> the lowmem memory map - which is exactly the behaviour we want.

Makes sense to me.

>  arch/arm/mm/init.c |  160 +++++++++++++++++++++++++++++++++++-----------------
>  arch/arm/mm/mmu.c  |   43 ++++++++------
>  mm/memblock.c      |    4 +
>  3 files changed, 138 insertions(+), 69 deletions(-)

This works fine:
Tested-by: Felipe Contreras <felipe.contreras@gmail.com>

-- 
Felipe Contreras
