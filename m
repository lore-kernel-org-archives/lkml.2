Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab1DGQ0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 12:26:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755413Ab1DGQ0w convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 12:26:52 -0400
MIME-Version: 1.0
In-Reply-To: <80b43d57d15f7b141799a7634274ee3bfe5a5855.1302137785.git.luto@mit.edu>
References: <cover.1302137785.git.luto@mit.edu> <80b43d57d15f7b141799a7634274ee3bfe5a5855.1302137785.git.luto@mit.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 7 Apr 2011 09:18:01 -0700
Message-ID: <BANLkTi=RkeFMpcb36RrJ=+eYm-xk4B2zYw@mail.gmail.com>
Subject: Re: [RFT/PATCH v2 2/6] x86-64: Optimize vread_tsc's barriers
To: Andy Lutomirski <luto@mit.edu>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 6, 2011 at 7:03 PM, Andy Lutomirski <luto@mit.edu> wrote:
>
> We want a stronger guarantee, though: we want the tsc to be read
> before any memory access that occurs after the call to
> vclock_gettime (or vgettimeofday).  We currently guarantee that with
> a second lfence or mfence.  This sequence is not really supported by
> the manual (AFAICT) and it's also slow.
>
> This patch changes the rdtsc to use implicit memory ordering instead
> of the second fence.

Ok, I have to admit to a horrid fascination with this patch. The
"saves 5ns on Sandybridge" sounds like a quite noticeable win, and I
always hated the stupid barriers (and argued strongly for avoiding
them when we don't care enough - which is why the rdtsc_barrier() is a
separate thing, rather than being inside rdtsc.

And your approach to serialize things is *so* disgusting that it's funny.

That said, I think your commentary is wrong, and I think the
serialization for that reason is at least slightly debatable.

>  All x86-64 chips guarantee that no
> memory access after a load moves before that load.

This is not true.

The x86-64 memory ordering semantics are that YOU CANNOT TELL that a
memory access happened before the load, but that's not the same thing
at all as saying that you can have no memory accesses. It just means
that the memory re-ordering logic will have to keep the cachelines
around until loads have completed in-order, and will have to retry if
it turns out that a cacheline was evicted in the wrong order (and thus
the values might have been changed by another CPU or DMA in ways that
make the out-of-order loads visible).

So that's problem #1 with your explanation.

Now, the _reason_ I don't think this is much of a problem is that I
seriously don't think we care. The whole "no moving memory ops around"
thing isn't about some correctness thing, it's really about trying to
keep the rdtsc "sufficiently bounded". And I do think that making the
rdtsc result impact the address calculation for the last_cycle thing
is perfectly fine in that respect.

So I don't think that the "all x86-64 chips guarantee.." argument is
correct at all, but I do think that in practice it's a good approach.
I fundamentally think that "barriers" are crap, and have always
thought that the x86 model of implicit memory barriers and "smart
re-ordering" is much much superior to the crazy model of memory
barriers. I think the same is true of lfence and rdtsc.

Which may be one reason why I like your patch - I think getting rid of
an lfence is simply a fundamental improvement.

> The trick is that the answer should not actually change as a result
> of the sneaky memory access.  I accomplish this by shifting rdx left
> by 32 bits, twice, to generate the number zero.  (I can't imagine
> that any CPU can break that dependency.)  Then I use "zero" as an
> offset to a memory access that we had to do anyway.

So this is my other nit-pick: I can _easily_ imagine a CPU breaking
that dependency. In fact, I can pretty much guarantee that the CPU
design I was myself involved with at Transmeta would have broken it if
it had just been 64-bit (because it would first notice that eflags are
dead, then combine the two shifts into one, and then make the
shift-by-64 be a zero).

Now, I agree that it's less likely with a traditional CPU core, but
there are actually other ways to break the dependency too, namely by
doing things like address or data speculation on the load, and simply
do the load much earlier - and then just verify the address/data
afterwards.

Likely? No. But the point I'm trying to make is that there are at
least two quite reasonable ways to avoid the dependency.

Which again I actually think is probably perfectly ok. It's ok exactly because

 (a) the dependency avoidance is pretty unlikely in any forseeable future

 (b) we don't even _care_ too much even if it's avoided (ie the
annoying lfence wasn't that important to begin with - the time warps
of the clock aren't disastrous enough to be a major issue, and I bet
this approach - even if not totally water-tight - is still limiting
enough for scheduling that it cuts down the warps a lot)

So again, I mainly object to the _description_, not the approach itself.

The "lfence" was never some kind of absolute barrier. We really don't
care about any one particular instruction, we care about the rdtsc
just not moving around _too_ much. So I'm certainly ok with using
other approaches to limit CPU instruction scheduling.

I dunno. I would suggest:

 - marking "cycle_last" as being "volatile"

 - not doing the second shift by 32, but instead by 29, leaving the
three high bits "random".

 - doing "last = (&__vsyscall_gtod_data.clock.cycle_last)[edx]"
instead, which should generate something like

   movq __vsyscall_gtod_data+40(,%rdx,8),%rax

which does the last three bits, and makes it slightly harder for the
CPU to notice that there are no actual bits of real data left (again -
"slightly harder" is not at all "impossible" - if the CPU internally
does the address generation as a shift+add, it could notice that all
the shifts add up to 64).

But before that, I would check that the second lfence is needed AT
ALL. I don't know whether we ever tried the "only barrier before"
version, because quite frankly, if you call this thing in a loop, then
a single barrier will still mean that there are barriers in between
iterations. So...

There may well be a reason why Intel says just "lfence ; rdtsc" -
maybe the rdtsc is never really moved down anyway, and it's only the
"move up" barrier that anybody ever really needs.

Hmm?

So before trying to be clever, let's try to be simple. Ok?

                          Linus
