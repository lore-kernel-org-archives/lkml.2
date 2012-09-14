Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab2INM2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:28:00 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57848 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab2INM16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:27:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120913153615.GB32128@redhat.com>
References: <1347493124-10661-1-git-send-email-vda.linux@googlemail.com>
 <1347493124-10661-2-git-send-email-vda.linux@googlemail.com> <20120913153615.GB32128@redhat.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 14 Sep 2012 14:27:37 +0200
Message-ID: <CAK1hOcN79Gewb4x1W=WEDL6ESpcRQ0SD5mPzjRN6TY8jJvhCQw@mail.gmail.com>
Subject: Re: [PATCH 2/2] coredump: add a new elf note with siginfo fields of
 the signal
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        Roland McGrath <roland@hack.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 5:36 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 09/13, Denys Vlasenko wrote:
>>
>> This patch adds a new elf note, NT_SIGINFO, which contains
>> the remaining fields of siginfo_t.
>
> I can't really comment this patch, but...
>
>> +struct coredump_siginfo {
...
>> +};
...
>
> I can't understand the layout. struct siginfo is union, for example
> si_overrun only makes sense if si_code = SI_TIMER.
>
> Not sure this is right. I think fill_siginfo_note() should either do
> memcpy() and let userspace to decode this (raw) info, or this layout
> should be unified with copy_siginfo_to_user().

The reason I did not do that is two-fold. First, and most important one,
is layout and alignment reasons. This is *coredump file*,
not in-memory structure. While siginfo_t in memory is always on the same
machine, coredump may be looked at on a completely different
architecture. It would be not too hard if the only differences are 32/64
bitness and whether longs need to be aligned as ints or twice that,
but there are many more subtleties when we deal with insane nested
struct/union beast siginfo_t is.

Example #1:

        union {
...
                struct {
                        __kernel_pid_t _pid;    /* sender's pid */
                        __ARCH_SI_UID_T _uid;   /* sender's uid */
                } _kill;

How wide is __ARCH_SI_UID_T?
Are we sure developer working on machine with architecture A
will get it right for arches B, C, D, and obscure one XYZ
he doesn't even know exists?

Example #2: on which architectures si_trapno exists?


Basically, to resolve these problems userspace coredump
parsing code will be forced to carry *per-architecture*
struct siginfo definitions. Which probably means 20+ structs.
A small nightmare. Imagine how many "oh no, our struct
siginfo for (e.g.) Blackfin was broken for last 3 years
and we didn't notice!" bugs there will be...


With my approach, userspace developers won't be haunted
by these problems: in coredump, we use *unambiguous
format*, where all fields exist on all architectures,
all fields are separate (no nested unions) and all fields
are ints or longs (no shorts, no chars).
Basically, only two different layouts will exist:
32-bit one, and 64-bit one.

Yes, we might be wasting a few bytes, but (1) we also _save_
a few bytes by not saving signo/errno/code redundantly,
and (2) a few bytes saved in *coredump* is well in the noise.

> Note also that we do not expose the upper bits of si_code to user-space,
> probably coredump should do the same, I dunno.

Yes, we shouldn't leak data.

-- 
vda
