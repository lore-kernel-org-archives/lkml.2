Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab2BARhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:37:37 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35483 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab2BARhe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:37:34 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1202011808240.22725@twin.jikos.cz>
References: <20120201151918.GC16714@quack.suse.cz> <1328114266.5355.44.camel@lenny>
 <CA+55aFxmdskUXX1iBaPx7rUGD95UqNJxhe1BLeVtZjqHjBpsPA@mail.gmail.com> <alpine.LRH.2.00.1202011808240.22725@twin.jikos.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Feb 2012 09:37:13 -0800
X-Google-Sender-Auth: otWpU6eqFh4IfNBwIgSXuPOmdZY
Message-ID: <CA+55aFyXH5a8QWo+RFgHnpijj3cLA=f5J+d2iyMOCpkuCyoOpw@mail.gmail.com>
Subject: Re: Memory corruption due to word sharing
To: Jiri Kosina <jkosina@suse.cz>
Cc: Colin Walters <walters@verbum.org>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
        dsterba@suse.cz, ptesarik@suse.cz, rguenther@suse.de, gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 9:11 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 1 Feb 2012, Linus Torvalds wrote:
>>
>> And I suspect it really is a generic bug that can be shown even with
>> the above trivial example.
>
> I have actually tried exactly this earlier today (because while looking at
> this, I had an idea that putting volatile in place could be a workaround,
> causing gcc to generate a saner code), but it doesn't work either:
>
> # cat x.c
> struct x {
>    long a;
>    volatile unsigned int lock;
>    unsigned int full:1;
> };
>
> void
> wrong(struct x *ptr)
> {
>        ptr->full = 1;
> }
>
> int main()
> {
>        wrong(0);
> }
> # gcc -O2 x.c
> # gdb -q ./a.out
> Reading symbols from /root/a.out...done.
> (gdb) disassemble wrong
> Dump of assembler code for function wrong:
>   0x40000000000005c0 <+0>:     [MMI]       adds r32=8,r32
>   0x40000000000005c1 <+1>:                 nop.m 0x0
>   0x40000000000005c2 <+2>:                 mov r15=1;;
>   0x40000000000005d0 <+16>:    [MMI]       ld8 r14=[r32];;
>   0x40000000000005d1 <+17>:                nop.m 0x0
>   0x40000000000005d2 <+18>:                dep r14=r15,r14,32,1;;
>   0x40000000000005e0 <+32>:    [MIB]       st8 [r32]=r14
>   0x40000000000005e1 <+33>:                nop.i 0x0
>   0x40000000000005e2 <+34>:                br.ret.sptk.many b0;;
>
> In my opinion, this is a clear bug in gcc (while the original problem,
> without explitict volatile, is not a C spec violation per se, it's just
> very inconvenient :) ).

Yup, gcc is clearly just buggy here. I do not believe there is any
question what-so-ever about the above test-case showing a bug.

And the thing is, if they fix this bug, they'll fix our problem too,
unless they are going to write explicit code to *try* to screw us over
while fixing that 'volatile' bug.

Because the right thing to do with bitfields is really to take the
base type into account. If the bitfield was in an "int", you use an
"int" access for it, not a 64-bit access. That's the simple fix for
the volatile problem, and it just happens to fix our issue too.

Trying to explicitly *look* for volatiles, and only doing the 32-bit
access when you see them is actually extra code, and extra effort, and
doesn't even *help* anything. It's not like the 64-bit access is
somehow "better".

I can see some vindictive programmer doing that, while thinking "I'll
show these people who pointed out this bug in my code, mhwhahahahaa!
I'll fix their test-case while still leaving the real problem
unaddressed", but I don't think compiler people are quite *that* evil.
 Yes, they are evil people who are trying to trip us up, but still..

                       Linus
