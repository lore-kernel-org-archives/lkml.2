Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab0JVNw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 09:52:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32881 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab0JVNw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 09:52:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wSlH5BjrD7zxTUnsDM6DtX71B2zQrL2QSAot5dktGiOQd4NPhWsCO/xjpIlxTZUTIg
         VcVGwb69NxdmBW3K50hunzhaOrcdJMQK71gnP4T/dkneE2AOcOa+1UQi3E1HLcUYGCQK
         jvx4oX66L6uHi8SGnGGUa1eCV3LsZnl9BkM7w=
MIME-Version: 1.0
In-Reply-To: <201010221102.12329.arnd@arndb.de>
References: <1287608139-21354-1-git-send-email-alchark@gmail.com>
	<201010211401.53001.arnd@arndb.de>
	<AANLkTimkLqrbX+536TD630xFy=y-PxEdksc4sA0gz6fU@mail.gmail.com>
	<201010221102.12329.arnd@arndb.de>
Date: Fri, 22 Oct 2010 17:52:26 +0400
Message-ID: <AANLkTi=F2VA_3L9-49OQ=Bj1KaD2T58Ske2qvHFqirM9@mail.gmail.com>
Subject: Re: [PATCH 1/6] ARM: Add basic architecture support for
 VIA/WonderMedia 85xx SoC's
From: Alexey Charkov <alchark@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/22 Arnd Bergmann <arnd@arndb.de>:
> On Thursday 21 October 2010 23:08:39 Alexey Charkov wrote:
>> 2010/10/21 Arnd Bergmann <arnd@arndb.de>:
>> > On Thursday 21 October 2010, Alexey Charkov wrote:
>> > Parsing complex options in general is not ok, but something simpler
>> > probably is.
>> >
>> > Having a Kconfig selected default is probably a good idea. The most
>> > simple way to select this at boot time would be to have a list of
>> > possible resolutions and pass a table index.
>> >
>> > Would a __setup() call work for you?
>> >
>>
>> Should probably be fine. Will it be allowable to accept something like
>> "panel=800x480" and strncmp it against a list of recognized values,
>> fall back to a Kconfig default on failure and printk the
>> possibilities? Just expecting an obscure table index would not be too
>> user-friendly, imho.
>
> Sounds reasonable to me.
>
>> >> And due to the fact that the framebuffer size calculation is tied to
>> >> panel specification, it will boot in any case. The only problem that
>> >> one could encounter would be suboptimal display (for example,
>> >> offscreen pixmaps to become actually visible on screen if the panel is
>> >> taller
>> >> than expected, or some corruption in case it is wider).
>> >
>> > Another option might be to have a submenu with the possible resolutions
>> > you want to allow and size the frame buffer for the largest of those,
>> > but allow overriding the actual one at boot time.
>> >
>>
>> In this case display parameters could be parsed in the driver itself,
>> but quite some memory will be over-allocated in extreme cases without
>> any way to claim it back after boot. Having only 128MB of RAM, is it
>> really better?
>
> Well, you could still build a specialized kernel with only support for
> one resolution if you care about every byte.
>

If it is fine to accept an option like "panel=<value_from_a_list>" at
map_io stage, then I'd rather go that way, and calculate the minimum
required buffer size for the current configuration. Especially if we
decide to make a unified image for different SoC revisions, as WM8505
requires 32bpp framebuffer, while VT8500 requires it to be 4MB-aligned
native-bpp.

>> Cleaned this up in the development repo, thanks. Only left #ifdef's
>> for the sections where respective register/interrupt definitions would
>> be unavailable due to compiling for a different SoC version, and
>> adjusted the conditions accordingly.
>
> Ideally those should also be run-time decisions so you can build a
> kernel that works on both. It's all __init code, so it won't eat
> up any RAM afterwards.
>

I thought about that, and it should be quite useful. However, register
and interrupt definitions should then be converted into some indexed
data structures instead of macros (as they differ between VT8500 and
WM8505), and the correct index should be selectable at runtime.

Is there any way to determine which mach type we are currently running
at after early head.S initialization completes and before we could
need to use any registers and/or interrupts? It could probably be done
in machine-specific fixup functions, but I'm unsure whether this would
be a correct way to go.

>> >> >> +#ifndef __ASM_ARM_ARCH_IO_H
>> >> >> +#define __ASM_ARM_ARCH_IO_H
>> >> >> +
>> >> >> +#define IO_SPACE_LIMIT 0xffffffff
>> >> >> +
>> >> >> +#define __io(a)              __typesafe_io(a)
>> >> >> +#define __mem_pci(a) (a)
>> >> >> +
>> >> >> +#endif
>>
>> Ok, figuring out better values for the macros would be great!
>
> For the IO_SPACE_LIMIT, just make it 0xffff
>
> For __io, you need to find a place in your virtual address space
> and map the real IO space.
>
> According to the VIA source code, the physical I/O window is at
> 0xd8000000, they also map it to the same address in virtual space
> but you can have anywhere convienient.
>

Are you sure about that? 0xd8000000 is the MMIO base, as far as I can
tell (see register definitions in <mach/vt8500.h>). In earlier
discussions you presumed [1] that IO could be at 0xc0000000, but I'm
not sure how to verify that. If so, should it then look something like
this:

#define __io(a) ((void __iomem *)(((a) + 0xc0000000) +
SOME_OFFSET_TO_VIRT_SPACE))

?
By the way, other boards except for footbridge, integrator, ebsa110
and ixp4xx define IO_SPACE_LIMIT to be 0xffffffff. 0xffff seems more
plausbile, though...

>        Arnd
>

Thanks,
Alexey

[1] http://groups.google.com/group/vt8500-wm8505-linux-kernel/msg/97bf44bc5ea5d46a?
