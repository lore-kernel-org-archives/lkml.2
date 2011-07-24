Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab1GXUpi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 16:45:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60647 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab1GXUpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 16:45:36 -0400
Date: Sun, 24 Jul 2011 22:44:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110724204450.GB18546@elte.hu>
References: <1311340547-7861-1-git-send-email-bp@amd64.org>
 <CA+55aFwL9Fwd9ouX3UMOayoBsZyZzTdDSySa6nZJxbpyLifbaQ@mail.gmail.com>
 <20110724172222.GB12621@aftab>
 <CA+55aFze=w7tjmyGa2w=D8b6roDuL5O0gmDKkSzLKBLLYZ_a+A@mail.gmail.com>
 <20110724182323.GA13247@aftab>
 <20110724183045.GB29660@elte.hu>
 <20110724190752.GA13647@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110724190752.GA13647@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> On Sun, Jul 24, 2011 at 02:30:46PM -0400, Ingo Molnar wrote:
> > > > So I really think that you might be *much* better off just changing
> > > > mmap_rnd(), and nothing else. Just make *that* mask off the three low
> > > > bits of the random address, ie something like
> > > > 
> > > >   diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
> > > >   index 1dab5194fd9d..6b62ab5a5ae1 100644
> > > >   --- a/arch/x86/mm/mmap.c
> > > >   +++ b/arch/x86/mm/mmap.c
> > > >   @@ -90,6 +90,9 @@ static unsigned long mmap_rnd(void)
> > > >                           rnd = (long)get_random_int() % (1<<8);
> > > >                   else
> > > >                           rnd = (long)(get_random_int() % (1<<28));
> > > >   +
> > > >   +               if (avoid_aliasing_in_bits_14_12)
> > > >   +                       rnd &= ~7;
> > > >           }
> > > >           return rnd << PAGE_SHIFT;
> > > >    }
> > > > 
> > > > would be fundamentally very safe - it would already take all our
> > > > current anti-randomization code into account.
> > > > 
> > > > No?
> > > 
> > > Hehe, we had that idea initially. However, the special 1% case I was
> > > hinting at is this:
> > > 
> > > process P0, mapping libraries A, B, C
> > > 
> > > and
> > > 
> > > process P1, mapping libraries A, C
> > > 
> > > Library C ends up possibly with aliasing VAs and there's the 
> > > problem again. [...]
> > 
> > Well, since all library positions are randomized, and the quirk masks 
> > out bits 12,13,14, all libraries that are not explicitly fix-mapped 
> > will end up on a 32K granular VA address.
> 
> Right, but IIUC, mmap_rnd() is used to determine mm->mmap_base so 
> the mmap starting address will have [14:12] cleared but the initial 
> address of library C's mapping in the example above will possibly 
> differ in those bits due to different linking order, right?

Indeed, because only the mmap base is randomized, not the individual 
vmas.

I'd still suggest to ignore this link order case first, and get the 
99% fix in place ... that one is also obviously backportable - the 
big patch not so much.

Then send in a patch on top of that that solves the remaining 1% also 
with numbers attached, so that we can see the speed/complexity 
tradeoff ...

> > Also, in practice on most distros most libraries will be 
> > prelinked to the same address in all processes.
> 
> I think at least on RHEL there's a daemon doing prelinking every 
> two weeks or so...

I'd suggest to run a script that extracts the actual mapped offsets 
from/proc/*/maps files and measures how much of an issue this all is 
in practice.

Thanks,

	Ingo
