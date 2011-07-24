Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab1GXRk1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 13:40:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751624Ab1GXRkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 13:40:21 -0400
MIME-Version: 1.0
In-Reply-To: <20110724172222.GB12621@aftab>
References: <1311340547-7861-1-git-send-email-bp@amd64.org>
 <CA+55aFwL9Fwd9ouX3UMOayoBsZyZzTdDSySa6nZJxbpyLifbaQ@mail.gmail.com> <20110724172222.GB12621@aftab>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 24 Jul 2011 10:39:25 -0700
Message-ID: <CA+55aFze=w7tjmyGa2w=D8b6roDuL5O0gmDKkSzLKBLLYZ_a+A@mail.gmail.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 10:22 AM, Borislav Petkov <bp@amd64.org> wrote:
>
>> So at a MINIMUM, I would say that this is acceptable only when the
>> process doing the allocation hasn't got ASLR disabled.
>
> I guess I could look at randomize_va_space before enabling it.

That's not what I meant - I meant the per-process PF_RANDOMIZE and
ADDR_NO_RANDOMIZE personality flags (although the global
"randomize_va_space" thing obviously is one input to that too)

In fact, if 99% of your problem is ASLR-induced, might I suggest just
making the whole thing a tweak to ASLR instead, and not use ASLR for
bits 14:12? That should be fundamentally much safer: it doesn't change
any semantics at all, it just makes for slightly less random bits to
be used.

So I really think that you might be *much* better off just changing
mmap_rnd(), and nothing else. Just make *that* mask off the three low
bits of the random address, ie something like

  diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
  index 1dab5194fd9d..6b62ab5a5ae1 100644
  --- a/arch/x86/mm/mmap.c
  +++ b/arch/x86/mm/mmap.c
  @@ -90,6 +90,9 @@ static unsigned long mmap_rnd(void)
                          rnd = (long)get_random_int() % (1<<8);
                  else
                          rnd = (long)(get_random_int() % (1<<28));
  +
  +               if (avoid_aliasing_in_bits_14_12)
  +                       rnd &= ~7;
          }
          return rnd << PAGE_SHIFT;
   }

would be fundamentally very safe - it would already take all our
current anti-randomization code into account.

No?

> But this won't address the case where one of the processes was created
> with ASLR off and the other with ASLR on and they map the same library
> at VAs differing at bits [14:12].

I wouldn't worry about some corner-case like that _nearly_ as much as
worrying about the non-ASLR process working at all.

> Yeah, I like the BITS() thing - will change. I actually have a similar
> macro GENMASK(o, hi) in <drivers/edac/amd64_edac.h> - I should move it
> to <linux/bitops.h> and rename it to BITS().

So it may be that BITS() is much too generic a name, and will cause
problems. A quick "git grep -w BITS" certainly finds a fair number of
hits. So I don't think it's usable as-is, it was meant more as
pseudo-code.

>> Changing address space layout is not a small decision.
>
> I suspected as much - thus the boot option to disable it.

I understand that the boot option is worth it, but since we _already_
have a way to mark binaries as not wanting address space layout
changes, I really think it should use that as the primary method. When
that bit is set, I think it's a big hint that the process is "fragile"
wrt address space changes.

A boot option might be left as a last ditch thing, but I don't think
it should be the primary model.

                              Linus
