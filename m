Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab1GXSXl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 14:23:41 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:52546 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab1GXSXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 14:23:37 -0400
Date: Sun, 24 Jul 2011 20:23:23 +0200
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110724182323.GA13247@aftab>
References: <1311340547-7861-1-git-send-email-bp@amd64.org>
 <CA+55aFwL9Fwd9ouX3UMOayoBsZyZzTdDSySa6nZJxbpyLifbaQ@mail.gmail.com>
 <20110724172222.GB12621@aftab>
 <CA+55aFze=w7tjmyGa2w=D8b6roDuL5O0gmDKkSzLKBLLYZ_a+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFze=w7tjmyGa2w=D8b6roDuL5O0gmDKkSzLKBLLYZ_a+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 01:39:25PM -0400, Linus Torvalds wrote:
> On Sun, Jul 24, 2011 at 10:22 AM, Borislav Petkov <bp@amd64.org> wrote:
> >
> >> So at a MINIMUM, I would say that this is acceptable only when the
> >> process doing the allocation hasn't got ASLR disabled.
> >
> > I guess I could look at randomize_va_space before enabling it.
> 
> That's not what I meant - I meant the per-process PF_RANDOMIZE and
> ADDR_NO_RANDOMIZE personality flags (although the global
> "randomize_va_space" thing obviously is one input to that too)
> 
> In fact, if 99% of your problem is ASLR-induced, might I suggest just
> making the whole thing a tweak to ASLR instead, and not use ASLR for
> bits 14:12? That should be fundamentally much safer: it doesn't change
> any semantics at all, it just makes for slightly less random bits to
> be used.
> 
> So I really think that you might be *much* better off just changing
> mmap_rnd(), and nothing else. Just make *that* mask off the three low
> bits of the random address, ie something like
> 
>   diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
>   index 1dab5194fd9d..6b62ab5a5ae1 100644
>   --- a/arch/x86/mm/mmap.c
>   +++ b/arch/x86/mm/mmap.c
>   @@ -90,6 +90,9 @@ static unsigned long mmap_rnd(void)
>                           rnd = (long)get_random_int() % (1<<8);
>                   else
>                           rnd = (long)(get_random_int() % (1<<28));
>   +
>   +               if (avoid_aliasing_in_bits_14_12)
>   +                       rnd &= ~7;
>           }
>           return rnd << PAGE_SHIFT;
>    }
> 
> would be fundamentally very safe - it would already take all our
> current anti-randomization code into account.
> 
> No?

Hehe, we had that idea initially. However, the special 1% case I was
hinting at is this:

process P0, mapping libraries A, B, C

and

process P1, mapping libraries A, C

Library C ends up possibly with aliasing VAs and there's the problem
again. Also, can we guarantee that the link order is always the same?
IOW, can other two processes P2 and P3, both mapping libraries A,B,C end
up with the following mapping order:

P2: A,B,C
P3: A,C,B

If yes, then no joy.

I'll obviously have to leave in the unaliasing of the vDSO randomization
but yeah, this solution would've be great.

> > But this won't address the case where one of the processes was created
> > with ASLR off and the other with ASLR on and they map the same library
> > at VAs differing at bits [14:12].
> 
> I wouldn't worry about some corner-case like that _nearly_ as much as
> worrying about the non-ASLR process working at all.

Ok, I'll make the 32k aligning contingent on the PF_RANDOMIZE setting.

> > Yeah, I like the BITS() thing - will change. I actually have a similar
> > macro GENMASK(o, hi) in <drivers/edac/amd64_edac.h> - I should move it
> > to <linux/bitops.h> and rename it to BITS().
> 
> So it may be that BITS() is much too generic a name, and will cause
> problems. A quick "git grep -w BITS" certainly finds a fair number of
> hits. So I don't think it's usable as-is, it was meant more as
> pseudo-code.

Ok.

> >> Changing address space layout is not a small decision.
> >
> > I suspected as much - thus the boot option to disable it.
> 
> I understand that the boot option is worth it, but since we _already_
> have a way to mark binaries as not wanting address space layout
> changes, I really think it should use that as the primary method. When
> that bit is set, I think it's a big hint that the process is "fragile"
> wrt address space changes.
> 
> A boot option might be left as a last ditch thing, but I don't think
> it should be the primary model.

Ok, understood. Will change accordingly.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
