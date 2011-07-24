Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780Ab1GXRWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 13:22:45 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:60811 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab1GXRWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 13:22:38 -0400
Date: Sun, 24 Jul 2011 19:22:22 +0200
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110724172222.GB12621@aftab>
References: <1311340547-7861-1-git-send-email-bp@amd64.org>
 <CA+55aFwL9Fwd9ouX3UMOayoBsZyZzTdDSySa6nZJxbpyLifbaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFwL9Fwd9ouX3UMOayoBsZyZzTdDSySa6nZJxbpyLifbaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sun, Jul 24, 2011 at 12:04:27PM -0400, Linus Torvalds wrote:
> Argh. This is a small disaster, you know that, right? Suddenly we have
> user-visible allocation changes depending on which CPU you are running
> on. I just hope that the address-space randomization has caught all
> the code that depended on specific layouts.
> 
> And even with ASLR, I wouldn't be surprised if there are binaries out
> there that "know" that they get dense virtual memory when they do
> back-to-back allocations, even when they don't pass in the address
> explicitly.

That's what I'm afraid of. Thus the boot option to disable it, I'm
afraid the patch won't be of help in such situations.

> How much testing has AMD done with this change and various legacy
> Linux distros?

Currently underway. Just to make sure: this change currently addresses
only the case with 32-bit binaries running on a 64-bit kernel and not
the 32-bit kernel case.

> The 32-bit case in particular makes me nervous, that's where I'd
> expect a higher likelihood of binaries that depend on the layout.

Ok, noted.

> You guys do realize that we had to disable ASLR on many machines?

Disabling ASLR is actually ok because it also fixes the aliasing issue
in 99% of the cases by keeping the VA slice [14:12] the same across
processes.

Btw, one of the joke-fixes floating around here was to disable ASLR
completely as on Transmeta:

<arch/x86/kernel/cpu/transmeta.c:92>
#ifdef CONFIG_SYSCTL
	/*
	 * randomize_va_space slows us down enormously;
	 * it probably triggers retranslation of x86->native bytecode
	 */
	randomize_va_space = 0;
#endif

> So at a MINIMUM, I would say that this is acceptable only when the
> process doing the allocation hasn't got ASLR disabled.

I guess I could look at randomize_va_space before enabling it.

But this won't address the case where one of the processes was created
with ASLR off and the other with ASLR on and they map the same library
at VAs differing at bits [14:12].

> On Fri, Jul 22, 2011 at 6:15 AM, Borislav Petkov <bp@amd64.org> wrote:
> > +static inline unsigned long unalias_addr(unsigned long addr, bool incr)
> > +{
> > +       /* handle both 32- and 64-bit with a single conditional */
> > +       if (!(unalias_va_addr & (2 - mmap_is_ia32())))
> > +               return addr;
> 
> Ugh. I guess it works, but the actual values you used did not have a
> comment about those particular values being magical. You should do
> that, otherwise somebody will start adding bits and moving things
> around, and breaking this "bits 2/1" logic.

Good point, will do.

> > +       /* check if [14:12] are already cleared */
> > +       if (!(addr & (0x7 << PAGE_SHIFT)))
> > +               return addr;
> > +
> > +       addr = addr & ~(0x7 << PAGE_SHIFT);
> > +       if (incr)
> > +               addr += (0x8 << PAGE_SHIFT);
> 
> This is just really hard to look at. First you talk about "bits
> 14:12", and then you use odd values like "8 << PAGE_SHIFT".
> 
> Yes, yes, I can do the math in my head, and say "8 is 1<<3, and
> PAGE_SHIFT is 12, so he's adding things up to the next bit 15".
> 
> But is that really sensible?
> 
> If we don't already have helpers for this, it would still be prettier
> with something like
> 
>   #define BIT(a) (1ul << (a))
>   #define BITS(a,b) (BIT((a)+1) - BIT(b))
> 
> and then that "0x7 << PAGE_SHIFT" ends up being BITS(14,12) like in
> the comment (you should really double-check that I got it right
> though).

Yeah, I like the BITS() thing - will change. I actually have a similar
macro GENMASK(o, hi) in <drivers/edac/amd64_edac.h> - I should move it
to <linux/bitops.h> and rename it to BITS().

> Or alternatively, make the comment match the code, and explain the
> 14:12 with something like "the three bits above the page mask",
> although that just sounds odd.
> 
> Anyway, I seriously think that this patch is completely unacceptable
> in this form, and is quite possibly going to break real applications.
> Maybe most of the applications that had problems with ASLR only had
> trouble with anonymous memory, and the fact that you only do this for
> file mappings might mean that it's ok. But I'd be really worried.
> Changing address space layout is not a small decision.

I suspected as much - thus the boot option to disable it. We'll do our
extensive testing as good as we can and we'll keep our fingers crossed.

Big thanks for your review.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
