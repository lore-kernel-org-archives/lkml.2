Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab2CCUKc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 15:10:32 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:63315 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab2CCUKa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 15:10:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.83.42 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org>
References: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 3 Mar 2012 12:10:09 -0800
X-Google-Sender-Auth: uSnC-wh-G3moXDtBIeUm0XMVuDI
Message-ID: <CA+55aFyMn+gYh2uRPJSAS5n4UbQoY2iqe3peYjVosrP-73oQVA@mail.gmail.com>
Subject: Re: Word-at-a-time dcache name accesses (was Re: .. anybody know of
 any filesystems that depend on the exact VFS 'namehash' implementation?)
To: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 3:46 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> This *does* assume that "bsf" is a reasonably fast instruction, which is
> not necessarily the case especially on 32-bit x86. So the config option
> choice for this might want some tuning even on x86, but it would be lovely
> to get comments and have people test it out on older hardware.

Ok, so I was thinking about this. I can replace the "bsf" with a
multiply, and I just wonder which one is faster.

> +       /* Get the final path component length */
> +       len += __ffs(mask) >> 3;
> +
> +       /* The mask *below* the first high bit set */
> +       mask = (mask - 1) & ~mask;
> +       mask >>= 7;
> +       hash += a & mask;

So instead of the __ffs() on the original mask (to find the first byte
with the high bit set), I could use the "mask of bytes" and some math
to get the number of bytes set like this (so this goes at the end,
*after* we used the mask to mask off the bytes in 'a' - not where the
__ffs() is right now):

    /* Low bits set in each byte we used as a mask */
    mask &= ONEBYTES;

    /* Add up "mask + (mask<<8) + (mask<<16) +... ":
       same as a multiply */
    mask *= ONEBYTES;

    /* High byte now contains count of bits set */
    len += mask >> 8*(sizeof(unsigned long)-1);

which I find intriguing because it just continues with the whole
"bitmask tricks" thing and even happens to re-use one of the bitmasks
we already had.

On machines with slow bit scanning (and a good multiplier), that might
be faster.

Sadly, it's a multiply with a big constant. Yes, we could make the
constant smaller by not counting the highest byte: it is never set, so
we could use "ONEBYTES>>8" and shift right by 8*sizeof(unsigned
long)-2) instead, but it's still not as cheap as just doing adds and
masks.

I can't come up with anything really cheap to calculate "number of
bytes set". But the above may be cheaper than the bsf on some older
32-bit machines that have horrible bit scanning performance (eg Atom
or P4). An integer multiply tends to be around four cycles, the bsf
performance is all over the map (2-17 cycles latency).

                         Linus
