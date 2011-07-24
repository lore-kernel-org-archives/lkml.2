Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab1GXQE5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 12:04:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231Ab1GXQEw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 12:04:52 -0400
MIME-Version: 1.0
In-Reply-To: <1311340547-7861-1-git-send-email-bp@amd64.org>
References: <1311340547-7861-1-git-send-email-bp@amd64.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 24 Jul 2011 09:04:27 -0700
Message-ID: <CA+55aFwL9Fwd9ouX3UMOayoBsZyZzTdDSySa6nZJxbpyLifbaQ@mail.gmail.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Andre Przywara <andre.przywara@amd.com>,
        Martin Pohlack <martin.pohlack@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argh. This is a small disaster, you know that, right? Suddenly we have
user-visible allocation changes depending on which CPU you are running
on. I just hope that the address-space randomization has caught all
the code that depended on specific layouts.

And even with ASLR, I wouldn't be surprised if there are binaries out
there that "know" that they get dense virtual memory when they do
back-to-back allocations, even when they don't pass in the address
explicitly.

How much testing has AMD done with this change and various legacy
Linux distros? The 32-bit case in particular makes me nervous, that's
where I'd expect a higher likelihood of binaries that depend on the
layout.

You guys do realize that we had to disable ASLR on many machines?

So at a MINIMUM, I would say that this is acceptable only when the
process doing the allocation hasn't got ASLR disabled.

On Fri, Jul 22, 2011 at 6:15 AM, Borislav Petkov <bp@amd64.org> wrote:
> +static inline unsigned long unalias_addr(unsigned long addr, bool incr)
> +{
> +       /* handle both 32- and 64-bit with a single conditional */
> +       if (!(unalias_va_addr & (2 - mmap_is_ia32())))
> +               return addr;

Ugh. I guess it works, but the actual values you used did not have a
comment about those particular values being magical. You should do
that, otherwise somebody will start adding bits and moving things
around, and breaking this "bits 2/1" logic.

> +       /* check if [14:12] are already cleared */
> +       if (!(addr & (0x7 << PAGE_SHIFT)))
> +               return addr;
> +
> +       addr = addr & ~(0x7 << PAGE_SHIFT);
> +       if (incr)
> +               addr += (0x8 << PAGE_SHIFT);

This is just really hard to look at. First you talk about "bits
14:12", and then you use odd values like "8 << PAGE_SHIFT".

Yes, yes, I can do the math in my head, and say "8 is 1<<3, and
PAGE_SHIFT is 12, so he's adding things up to the next bit 15".

But is that really sensible?

If we don't already have helpers for this, it would still be prettier
with something like

  #define BIT(a) (1ul << (a))
  #define BITS(a,b) (BIT((a)+1) - BIT(b))

and then that "0x7 << PAGE_SHIFT" ends up being BITS(14,12) like in
the comment (you should really double-check that I got it right
though).

Or alternatively, make the comment match the code, and explain the
14:12 with something like "the three bits above the page mask",
although that just sounds odd.

Anyway, I seriously think that this patch is completely unacceptable
in this form, and is quite possibly going to break real applications.
Maybe most of the applications that had problems with ASLR only had
trouble with anonymous memory, and the fact that you only do this for
file mappings might mean that it's ok. But I'd be really worried.
Changing address space layout is not a small decision.

                         Linus
