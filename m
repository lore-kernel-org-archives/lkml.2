Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab2CBGty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 01:49:54 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51537 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab2CBGtt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 01:49:49 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of geert.uytterhoeven@gmail.com designates 10.180.103.35 as permitted sender) smtp.mail=geert.uytterhoeven@gmail.com; dkim=pass header.i=geert.uytterhoeven@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330668690.19557.91.camel@satguru>
References: <4F501C7A.30307@nod.at>
	<1330668690.19557.91.camel@satguru>
Date: Fri, 2 Mar 2012 07:49:48 +0100
X-Google-Sender-Auth: q7BkLntlQ8lj0b3CFu1RrVJJ9BA
Message-ID: <CAMuHMdVEQ-=vCawQPUbG_D6jA7fLxV4zYddYjc-5htW1baE2zg@mail.gmail.com>
Subject: Re: OpenRISC: Module loader broken
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jonas Bonn <jonas@southpole.se>
Cc: Richard Weinberger <richard@nod.at>, linux@openrisc.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 07:11, Jonas Bonn <jonas@southpole.se> wrote:
>> It explodes somewhere in apply_relocate_add().
>> This function is anyway fishy:
>>                 case R_OR32_CONST:
>>                         location = (uint16_t *)location + 1;
>>                         *((uint16_t *)location) = (uint16_t) (value);
>>                         break;
>>                 case R_OR32_CONSTH:
>>                         location = (uint16_t *)location + 1;
>>                         *((uint16_t *)location) = (uint16_t) (value >> 16);
>>                         break;
>>
>> Why the cast to (uint16_t *)?
>
> This is for loading a 32 bit const, which is done in two steps:
>
> l.movhi rX,hi(const)
> l.ori   rX,rX,lo(const)
>
> The immediate value 'const' here is encoded in the low 16 bits of those
> instructions.

So OpenRISC is big endian, which matches
arch/openrisc/include/asm/byteorder.h:#include <linux/byteorder/big_endian.h>

However, there are some remainings of little endian support:
arch/openrisc/include/asm/unaligned.h:#if defined(__LITTLE_ENDIAN)
arch/openrisc/include/asm/unaligned.h:#elif defined(__BIG_ENDIAN)
arch/openrisc/include/asm/unaligned.h:# error need to define endianess

> Since 'location' points at the 32-bit instruction in question, that cast
> is supposed to be saying:  'move 16 bit value into low 16 bits of
> instruction'.

It may be more readable and safer (w.r.t. changing endianness) to do
32-bit loads and stores and explicitly modify the 16 LSB.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
