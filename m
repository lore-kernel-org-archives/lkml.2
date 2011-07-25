Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab1GYUAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:00:31 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53973 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab1GYUA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:00:29 -0400
Date: Mon, 25 Jul 2011 22:00:14 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110725200014.GA23986@aftab>
References: <1311340547-7861-1-git-send-email-bp@amd64.org>
 <CA+55aFwL9Fwd9ouX3UMOayoBsZyZzTdDSySa6nZJxbpyLifbaQ@mail.gmail.com>
 <20110724172222.GB12621@aftab>
 <CA+55aFze=w7tjmyGa2w=D8b6roDuL5O0gmDKkSzLKBLLYZ_a+A@mail.gmail.com>
 <20110724182323.GA13247@aftab>
 <20110724183045.GB29660@elte.hu>
 <20110724190752.GA13647@aftab>
 <20110724204450.GB18546@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110724204450.GB18546@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 04:44:50PM -0400, Ingo Molnar wrote:
> 
> * Borislav Petkov <bp@amd64.org> wrote:
> 
> > On Sun, Jul 24, 2011 at 02:30:46PM -0400, Ingo Molnar wrote:
> > > > > So I really think that you might be *much* better off just changing
> > > > > mmap_rnd(), and nothing else. Just make *that* mask off the three low
> > > > > bits of the random address, ie something like
> > > > > 
> > > > >   diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
> > > > >   index 1dab5194fd9d..6b62ab5a5ae1 100644
> > > > >   --- a/arch/x86/mm/mmap.c
> > > > >   +++ b/arch/x86/mm/mmap.c
> > > > >   @@ -90,6 +90,9 @@ static unsigned long mmap_rnd(void)
> > > > >                           rnd = (long)get_random_int() % (1<<8);
> > > > >                   else
> > > > >                           rnd = (long)(get_random_int() % (1<<28));
> > > > >   +
> > > > >   +               if (avoid_aliasing_in_bits_14_12)
> > > > >   +                       rnd &= ~7;
> > > > >           }
> > > > >           return rnd << PAGE_SHIFT;
> > > > >    }
> > > > > 
> > > > > would be fundamentally very safe - it would already take all our
> > > > > current anti-randomization code into account.
> > > > > 
> > > > > No?
> > > > 
> > > > Hehe, we had that idea initially. However, the special 1% case I was
> > > > hinting at is this:
> > > > 
> > > > process P0, mapping libraries A, B, C
> > > > 
> > > > and
> > > > 
> > > > process P1, mapping libraries A, C
> > > > 
> > > > Library C ends up possibly with aliasing VAs and there's the 
> > > > problem again. [...]
> > > 
> > > Well, since all library positions are randomized, and the quirk masks 
> > > out bits 12,13,14, all libraries that are not explicitly fix-mapped 
> > > will end up on a 32K granular VA address.
> > 
> > Right, but IIUC, mmap_rnd() is used to determine mm->mmap_base so 
> > the mmap starting address will have [14:12] cleared but the initial 
> > address of library C's mapping in the example above will possibly 
> > differ in those bits due to different linking order, right?
> 
> Indeed, because only the mmap base is randomized, not the individual 
> vmas.
> 
> I'd still suggest to ignore this link order case first, and get the 
> 99% fix in place ... that one is also obviously backportable - the 
> big patch not so much.

Hmm, I've done some experiments with Linus' suggestion and I don't think
that flies. Here's why:

With the attached patch, the kernel generates VA spaces for processes
with mmap_base's bits [14:12] cleared. Here's what it looks like:

$ cat /proc/self/maps
00400000-0040c000 r-xp 00000000 08:02 1474641                            /bin/cat
0060b000-0060c000 r--p 0000b000 08:02 1474641                            /bin/cat
0060c000-0060d000 rw-p 0000c000 08:02 1474641                            /bin/cat
0118f000-011b0000 rw-p 00000000 00:00 0                                  [heap]
7f184c7a2000-7f184c9cd000 r--p 00000000 08:02 622671                     /usr/lib64/locale/locale-archive
7f184c9cd000-7f184cb26000 r-xp 00000000 08:02 2113794                    /lib64/libc-2.12.2.so
7f184cb26000-7f184cd26000 ---p 00159000 08:02 2113794                    /lib64/libc-2.12.2.so
7f184cd26000-7f184cd2a000 r--p 00159000 08:02 2113794                    /lib64/libc-2.12.2.so
7f184cd2a000-7f184cd2b000 rw-p 0015d000 08:02 2113794                    /lib64/libc-2.12.2.so
7f184cd2b000-7f184cd30000 rw-p 00000000 00:00 0
7f184cd30000-7f184cd4e000 r-xp 00000000 08:02 2113792                    /lib64/ld-2.12.2.so
7f184cf30000-7f184cf33000 rw-p 00000000 00:00 0
7f184cf4c000-7f184cf4d000 rw-p 00000000 00:00 0
7f184cf4d000-7f184cf4e000 r--p 0001d000 08:02 2113792                    /lib64/ld-2.12.2.so
7f184cf4e000-7f184cf4f000 rw-p 0001e000 08:02 2113792                    /lib64/ld-2.12.2.so
7f184cf4f000-7f184cf50000 rw-p 00000000 00:00 0 							<---- A
7fffcfb8c000-7fffcfbad000 rw-p 00000000 00:00 0                          [stack]
7fffcfbff000-7fffcfc00000 r-xp 00000000 00:00 0                          [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]

The end region address at marker A is that changed address
0x7f184cf50000. We decrement from there because we do topdown
allocation. Take a look at glibc's executable mapping:

7f184c9cd000-7f184cb26000 r-xp 00000000 08:02 2113794                    /lib64/libc-2.12.2.so

slice [14:12] = 101b

Now let's take a look at bash's maps (below). The changed mmap_base is
at marker B below. glibc exec mapping is:

7f63dc061000-7f63dc1ba000 r-xp 00000000 08:02 2113794                    /lib64/libc-2.12.2.so

whereas slice [14:12] = 001b

Not good, aliasing.

This is actually a good example for the case where process P0 (bash)
maps libraries A,B,...C and P1 maps libraries A, C.

So yeah, the simpler fix works for processes mapping libraries in the
same order but not for processes mapping a subset of libraries in a
different order.

$ cat /proc/2473/maps
00400000-004d0000 r-xp 00000000 08:02 2114802                            /bin/bash
006cf000-006d0000 r--p 000cf000 08:02 2114802                            /bin/bash
006d0000-006d9000 rw-p 000d0000 08:02 2114802                            /bin/bash
006d9000-006df000 rw-p 00000000 00:00 0
02030000-02072000 rw-p 00000000 00:00 0                                  [heap]
7f63db3e3000-7f63db3e5000 r-xp 00000000 08:02 2113704                    /usr/lib64/gconv/ISO8859-1.so
7f63db3e5000-7f63db5e4000 ---p 00002000 08:02 2113704                    /usr/lib64/gconv/ISO8859-1.so
7f63db5e4000-7f63db5e5000 r--p 00001000 08:02 2113704                    /usr/lib64/gconv/ISO8859-1.so
7f63db5e5000-7f63db5e6000 rw-p 00002000 08:02 2113704                    /usr/lib64/gconv/ISO8859-1.so
7f63db5e6000-7f63db5f1000 r-xp 00000000 08:02 2113540                    /lib64/libnss_files-2.12.2.so
7f63db5f1000-7f63db7f0000 ---p 0000b000 08:02 2113540                    /lib64/libnss_files-2.12.2.so
7f63db7f0000-7f63db7f1000 r--p 0000a000 08:02 2113540                    /lib64/libnss_files-2.12.2.so
7f63db7f1000-7f63db7f2000 rw-p 0000b000 08:02 2113540                    /lib64/libnss_files-2.12.2.so
7f63db7f2000-7f63db7fc000 r-xp 00000000 08:02 2113793                    /lib64/libnss_nis-2.12.2.so
7f63db7fc000-7f63db9fb000 ---p 0000a000 08:02 2113793                    /lib64/libnss_nis-2.12.2.so
7f63db9fb000-7f63db9fc000 r--p 00009000 08:02 2113793                    /lib64/libnss_nis-2.12.2.so
7f63db9fc000-7f63db9fd000 rw-p 0000a000 08:02 2113793                    /lib64/libnss_nis-2.12.2.so
7f63db9fd000-7f63dba12000 r-xp 00000000 08:02 2113807                    /lib64/libnsl-2.12.2.so
7f63dba12000-7f63dbc11000 ---p 00015000 08:02 2113807                    /lib64/libnsl-2.12.2.so
7f63dbc11000-7f63dbc12000 r--p 00014000 08:02 2113807                    /lib64/libnsl-2.12.2.so
7f63dbc12000-7f63dbc13000 rw-p 00015000 08:02 2113807                    /lib64/libnsl-2.12.2.so
7f63dbc13000-7f63dbc15000 rw-p 00000000 00:00 0
7f63dbc15000-7f63dbc1c000 r-xp 00000000 08:02 2113801                    /lib64/libnss_compat-2.12.2.so
7f63dbc1c000-7f63dbe1b000 ---p 00007000 08:02 2113801                    /lib64/libnss_compat-2.12.2.so
7f63dbe1b000-7f63dbe1c000 r--p 00006000 08:02 2113801                    /lib64/libnss_compat-2.12.2.so
7f63dbe1c000-7f63dbe1d000 rw-p 00007000 08:02 2113801                    /lib64/libnss_compat-2.12.2.so
7f63dbe36000-7f63dc061000 r--p 00000000 08:02 622671                     /usr/lib64/locale/locale-archive
7f63dc061000-7f63dc1ba000 r-xp 00000000 08:02 2113794                    /lib64/libc-2.12.2.so
7f63dc1ba000-7f63dc3ba000 ---p 00159000 08:02 2113794                    /lib64/libc-2.12.2.so
7f63dc3ba000-7f63dc3be000 r--p 00159000 08:02 2113794                    /lib64/libc-2.12.2.so
7f63dc3be000-7f63dc3bf000 rw-p 0015d000 08:02 2113794                    /lib64/libc-2.12.2.so
7f63dc3bf000-7f63dc3c4000 rw-p 00000000 00:00 0
7f63dc3c4000-7f63dc3c6000 r-xp 00000000 08:02 2113802                    /lib64/libdl-2.12.2.so
7f63dc3c6000-7f63dc5c6000 ---p 00002000 08:02 2113802                    /lib64/libdl-2.12.2.so
7f63dc5c6000-7f63dc5c7000 r--p 00002000 08:02 2113802                    /lib64/libdl-2.12.2.so
7f63dc5c7000-7f63dc5c8000 rw-p 00003000 08:02 2113802                    /lib64/libdl-2.12.2.so
7f63dc5c8000-7f63dc613000 r-xp 00000000 08:02 2130033                    /lib64/libncurses.so.5.7
7f63dc613000-7f63dc812000 ---p 0004b000 08:02 2130033                    /lib64/libncurses.so.5.7
7f63dc812000-7f63dc816000 r--p 0004a000 08:02 2130033                    /lib64/libncurses.so.5.7
7f63dc816000-7f63dc817000 rw-p 0004e000 08:02 2130033                    /lib64/libncurses.so.5.7
7f63dc817000-7f63dc818000 rw-p 00000000 00:00 0
7f63dc818000-7f63dc836000 r-xp 00000000 08:02 2113792                    /lib64/ld-2.12.2.so
7f63dca18000-7f63dca1b000 rw-p 00000000 00:00 0
7f63dca2b000-7f63dca2d000 rw-p 00000000 00:00 0
7f63dca2d000-7f63dca34000 r--s 00000000 08:02 622670                     /usr/lib64/gconv/gconv-modules.cache
7f63dca34000-7f63dca35000 rw-p 00000000 00:00 0
7f63dca35000-7f63dca36000 r--p 0001d000 08:02 2113792                    /lib64/ld-2.12.2.so
7f63dca36000-7f63dca37000 rw-p 0001e000 08:02 2113792                    /lib64/ld-2.12.2.so
7f63dca37000-7f63dca38000 rw-p 00000000 00:00 0							<---- B
7fffba432000-7fffba453000 rw-p 00000000 00:00 0                          [stack]
7fffba458000-7fffba459000 r-xp 00000000 00:00 0                          [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
