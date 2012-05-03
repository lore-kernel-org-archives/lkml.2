Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab2ECTHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 15:07:19 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46896 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab2ECTHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 15:07:17 -0400
MIME-Version: 1.0
In-Reply-To: <4FA2CE5C.8000100@zytor.com>
References: <1335788867.29087.19.camel@localhost> <20120501110024.GC6649@dhcp-172-17-9-228.mtv.corp.google.com>
 <1335875321.26671.15.camel@localhost> <CAPa8GCANv=-c7HsYvDqM+8JqJq6Gr9muxAivU2Ni16x9Ru5EXw@mail.gmail.com>
 <CA+55aFwPgWqCPA=ao6XmZy56PaJZ4WC+hOZ_CHGWpo_zO425VA@mail.gmail.com>
 <20120503064722.GN6871@ZenIV.linux.org.uk> <CA+55aFx0EUgXCE9CfUGz6zde-6iYgUKZRxB1=-VOEG0kSX2qEA@mail.gmail.com>
 <CA+55aFxeBHSB6iBpP55kV2bLQGg8ZC9Ve5mvCmZN0ARH9dVwKg@mail.gmail.com>
 <4FA2CAD9.6010808@zytor.com> <CA+55aFxrBghonjRvS=KK=5Oqw_Wj9PDh2wkDtVh7U9jw8=uTsA@mail.gmail.com>
 <4FA2CE5C.8000100@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 May 2012 12:06:56 -0700
X-Google-Sender-Auth: SzmKcH71yQxN4wC1fjnDwR41xBE
Message-ID: <CA+55aFy2fH8Sf8tMoZ+y7gAdXpn66MjonVh0cuR+mXa+PPupUw@mail.gmail.com>
Subject: Re: Oops with DCACHE_WORD_ACCESS and ocfs2, autofs4
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@gmail.com>,
        Jana Saout <jana@saout.de>, Joel Becker <jlbec@evilplan.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 11:28 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> +               "lea" __WORDSUFFIX " %2,%1\n\t"
> +               "and" __WORDSUFFIX " %4,%1\n\t"
> +               "shl" __WORDSUFFIX " $3,%1\n\t"
> +               "shr" __WORDSUFFIX " %b1,%0\n\t"
>
> Also, for this sequence of instructions using %ecx unconditionally is
> actually better (avoids REX prefixes on 64 bits.)

Ok, agreed, except for the last shr, which does need to be done in the
full word width. But yes, we could do the calculations of "how many
bits do we need to shift" in just 32 bits.

And yes, it does look like we can just rely on the register names, so
we can avoid all the WORDSUFFIX games, and make it be


static inline unsigned long load_unaligned_zeropad(const void *addr)
{
        unsigned long ret, dummy;

        asm(
                "1:\tmov %2,%0\n"
                "2:\n"
                ".section .fixup,\"ax\"\n"
                "3:\t"
                "lea %2,%1\n\t"
                "and %3,%1\n\t"
                "mov (%1),%0\n\t"
                "leal %2,%%ecx\n\t"
                "andl %4,%%ecx\n\t"
                "shll $3,%%ecx\n\t"
                "shr %%cl,%0\n\t"
                "jmp 2b\n"
                ".previous\n"
                _ASM_EXTABLE(1b, 3b)
                :"=&r" (ret),"=&c" (dummy)
                :"m" (*(unsigned long *)addr),
                 "i" (-sizeof(unsigned long)),
                 "i" (sizeof(unsigned long)-1));
        return ret;
}

instead.

And I'm running that with DEBUG_PAGEALLOC, and haven't seen anything
odd yet. Not that it's easy to trigger the page crosser, but I've
tried to do things like look up 4095-byte pathnames with the final
components being just one character each, so I've *tried*.

                    Linus
