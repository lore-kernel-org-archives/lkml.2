Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab1HIJn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 05:43:28 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39518 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab1HIJn1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 05:43:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAC5umyhLuhNK55WDXTii2SFsqPNau1B9F1z+E0r0CaLNkGZfDg@mail.gmail.com>
References: <1312709438-7608-1-git-send-email-akinobu.mita@gmail.com>
	<1312859440.2531.20.camel@edumazet-laptop>
	<1312860783.2531.31.camel@edumazet-laptop>
	<CAC5umyhLuhNK55WDXTii2SFsqPNau1B9F1z+E0r0CaLNkGZfDg@mail.gmail.com>
Date: Tue, 9 Aug 2011 12:43:26 +0300
X-Google-Sender-Auth: 5k1TZq8UZ2qAhcZegM7kGjh2TgY
Message-ID: <CAOJsxLHKJT_qCsiPVCEh=+nbZ2D7+y=mJgMM+wEob395zEN6XQ@mail.gmail.com>
Subject: Re: [PATCH] slub: fix check_bytes() for slub debugging
From: Pekka Enberg <penberg@kernel.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 12:38 PM, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> 2011/8/9 Eric Dumazet <eric.dumazet@gmail.com>:
>
>>> > diff --git a/mm/slub.c b/mm/slub.c
>>> > index eb5a8f9..5695f92 100644
>>> > --- a/mm/slub.c
>>> > +++ b/mm/slub.c
>>> > @@ -701,7 +701,7 @@ static u8 *check_bytes(u8 *start, u8 value, unsigned int bytes)
>>> >             return check_bytes8(start, value, bytes);
>>> >
>>> >     value64 = value | value << 8 | value << 16 | value << 24;
>>> > -   value64 = value64 | value64 << 32;
>>> > +   value64 = (value64 & 0xffffffff) | value64 << 32;
>>> >     prefix = 8 - ((unsigned long)start) % 8;
>>> >
>>> >     if (prefix) {
>>>
>>> Still buggy I am afraid. Could we use the following ?
>>>
>>>
>>>       value64 = value;
>>>       value64 |= value64 << 8;
>>>       value64 |= value64 << 16;
>>>       value64 |= value64 << 32;
>>>
>>>
>>
>> Well, 'buggy' was not well chosen.
>>
>> Another possibility would be to use a multiply if arch has a fast
>> multiplier...
>>
>>
>>        value64 = value;
>> #if defined(ARCH_HAS_FAST_MULTIPLIER) && BITS_PER_LONG == 64
>>        value64 *= 0x0101010101010101;
>> #elif defined(ARCH_HAS_FAST_MULTIPLIER)
>>        value64 *= 0x01010101;
>>        value64 |= value64 << 32;
>> #else
>>        value64 |= value64 << 8;
>>        value64 |= value64 << 16;
>>        value64 |= value64 << 32;
>> #endif
>
> I don't really care about which one should be used.  So tell me if I need
> to resend it with this improvement.

I'm confused. What was wrong with your original patch?

                        Pekka
