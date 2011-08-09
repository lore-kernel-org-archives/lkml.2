Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab1HIJiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 05:38:23 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55489 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab1HIJiV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 05:38:21 -0400
MIME-Version: 1.0
In-Reply-To: <1312860783.2531.31.camel@edumazet-laptop>
References: <1312709438-7608-1-git-send-email-akinobu.mita@gmail.com>
	<1312859440.2531.20.camel@edumazet-laptop>
	<1312860783.2531.31.camel@edumazet-laptop>
Date: Tue, 9 Aug 2011 18:38:21 +0900
Message-ID: <CAC5umyhLuhNK55WDXTii2SFsqPNau1B9F1z+E0r0CaLNkGZfDg@mail.gmail.com>
Subject: Re: [PATCH] slub: fix check_bytes() for slub debugging
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/9 Eric Dumazet <eric.dumazet@gmail.com>:

>> > diff --git a/mm/slub.c b/mm/slub.c
>> > index eb5a8f9..5695f92 100644
>> > --- a/mm/slub.c
>> > +++ b/mm/slub.c
>> > @@ -701,7 +701,7 @@ static u8 *check_bytes(u8 *start, u8 value, unsigned int bytes)
>> >             return check_bytes8(start, value, bytes);
>> >
>> >     value64 = value | value << 8 | value << 16 | value << 24;
>> > -   value64 = value64 | value64 << 32;
>> > +   value64 = (value64 & 0xffffffff) | value64 << 32;
>> >     prefix = 8 - ((unsigned long)start) % 8;
>> >
>> >     if (prefix) {
>>
>> Still buggy I am afraid. Could we use the following ?
>>
>>
>>       value64 = value;
>>       value64 |= value64 << 8;
>>       value64 |= value64 << 16;
>>       value64 |= value64 << 32;
>>
>>
>
> Well, 'buggy' was not well chosen.
>
> Another possibility would be to use a multiply if arch has a fast
> multiplier...
>
>
>        value64 = value;
> #if defined(ARCH_HAS_FAST_MULTIPLIER) && BITS_PER_LONG == 64
>        value64 *= 0x0101010101010101;
> #elif defined(ARCH_HAS_FAST_MULTIPLIER)
>        value64 *= 0x01010101;
>        value64 |= value64 << 32;
> #else
>        value64 |= value64 << 8;
>        value64 |= value64 << 16;
>        value64 |= value64 << 32;
> #endif

I don't really care about which one should be used.  So tell me if I need
to resend it with this improvement.
