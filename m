Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab1BHQYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 11:24:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754422Ab1BHQYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 11:24:19 -0500
MIME-Version: 1.0
In-Reply-To: <1297168678.2190.21.camel@marvin>
References: <1297168678.2190.21.camel@marvin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 8 Feb 2011 08:23:57 -0800
Message-ID: <AANLkTim7YVg1BTEjyhYShgZNL3oKu+zFywC7+NgFvT3z@mail.gmail.com>
Subject: Re: mmap, the language go, problems with the linux kernel
To: martin capitanio <m@capitanio.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 8, 2011 at 4:37 AM, martin capitanio <m@capitanio.org> wrote:
>
> There popped up a serious problem by implementing a fast memory
> management for the language go. Maybe some experienced kernel hacker
> could join the discussion and help to find the best linux solution for
> the "mmap fiasco" problem.
>
> https://groups.google.com/forum/#!msg/golang-dev/EpUlHQXWykg/LN2o9fV6R3wJ

So, quite realistically, we can't change how "ulimit -v" works. It has
well-defined semantics, and they very much are about the mappings, not
about how many pages people use.

There's in theory a RLIMIT_RSS for tracking actual resident pages, but
in practice it doesn't _do_ anything on Linux, because it's not
something we've even bothered to count. It's much simpler and more
unambiguous to just count "how big are the mappings" than counting
individual pages. And as far as I can remember, this is literally the
first time that somebody has cared all that deeply (not to say that
people haven't asked for RSS before, but it's not been a fundamental
part of some design decision of theirs, just a wish-list).

So in theory we could change the kernel and start counting RSS, and
make RLIMIT_RSS do something useful, but in practice that would still
mean that it would take many _years_ before a project like 'go' could
rely on it, since most people don't change the kernel very often
anyway, and even if they did it's not the kernel that actually sets up
the offending RLIMIT_AS (the kernel defaults to "infinity"), but the
distribution or users random .bash_login files or whatever.

So even if the kernel _did_ change, you'd still have this problem in
'go', and you'd still need to do something else.

And quite frankly, I think your "use a big array" in go is a mistake.
You may think it's clever and simple, and that "hey, the OS won't
allocate pages we don't touch", but it's still a serious mistake. And
it's not a mistake because of RLIMIT_AS - that's just a secondary or
tertiary symptom of you being lazy and not doing the right thing.

Think about things like mlockall() (ever imaging mixing 'go' code with
C code that does security-sensitive stuff?).

Or think about things like the kernel trying to be really clever,
noticing that you have a 16GB allocation that is well-aligned, and
deciding to help you (since the system had tons of memory) by using
large pages for it to avoid excessive TLB overhead. Yes, people are
actually working on things like that. Suddenly the page allocation
granularity might be 2MB, not 4kB.

I bet there are other issues like that. On 32-bit, for example, we've
often had problems with people running out of virtual memory size,
since with shared libraries etc, there really isn't all that much free
address space. You only had a 256MB mapping on 32-bit, but quite
frankly, that's about 1/8th of the whole user address space (the 2G/2G
split tends to be normal), and you are basically requiring that there
is that much contiguous virtual address space that you can just waste.
Maybe that's true of all 'go' programs now, but I can tell you that in
the C world, people have done things like "let's link this binary
statically just so that we get maximal virtual address space size,
because we need a contiguous 1GB array for our actual _problem_).
Using some random 256MB virtual allocation just because your tracking
algorithm is lazy sounds like a _bad_ idea.

Finally, I actually think you may well often be better off keeping
your data denser (by using the indirection), and then having a smaller
virtual memory (and thus TLB) lookup footprint. Of course, it sounds
like your previous indexing scheme was very close to what the page
table lookup does anyway, but many problem sets have been better off
using fancy span-based lookup in order to _avoid_ having large arrays,
and the complexity of the scheme can be very much worth it.

In other words, the much deeper fundamental problem of the "one big
array" approach is that you're making tons of assumptions about what
is going on, and then when one of those assumptions aren't correct
("virtual memory size doesn't matter" in this case), you end up
blaming something else than your assumptions. And I think you need to
take another look at the assumption itself.

                        Linus
