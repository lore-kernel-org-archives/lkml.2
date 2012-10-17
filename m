Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2JQCXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 22:23:37 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46337 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab2JQCXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 22:23:34 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1210161924350.20581@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1210151716310.10685@file.rdu.redhat.com> <Pine.LNX.4.64.1210161924350.20581@file.rdu.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Oct 2012 19:23:07 -0700
X-Google-Sender-Auth: Qk8pAZVZdvRyr7AXy1q1x0N5m2M
Message-ID: <CA+55aFyZ9uq_yfHn9PwpmM77X3xVd+xseEbjJmeCCqbFddtjWA@mail.gmail.com>
Subject: Re: [PATCH] percpu-rwsem: use barrier in unlock path
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Architecture people, note the potential new SMP barrier! ]

On Tue, Oct 16, 2012 at 4:30 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> +       /*
> +        * The lock is considered unlocked when p->locked is set to false.
> +        * Use barrier prevent reordering of operations around p->locked.
> +        */
> +#if defined(CONFIG_X86) && (!defined(CONFIG_X86_PPRO_FENCE) && !defined(CONFIG_X86_OOSTORE))
> +       barrier();
> +#else
> +       smp_mb();
> +#endif
>         p->locked = false;

Ugh. The #if is too ugly to live.

This is a classic case of "people who write their own serialization
primitives invariably get them wrong". And this fix is just horrible,
and code like this should not be allowed.

I suspect we could make the above x86-specific optimization be valid
by introducing a new barrier, called "smp_release_before_store()" or
something like that, which on x86 just happens to be a no-op (but
still a compiler barrier). That's because earlier reads will not pass
a later stores, and stores are viewed in program order, so all x86
stores have "release consistency" modulo the theoretical PPro bugs
(that I don't think we actually ever saw in practice).

But it is possible that that is true on other architectures too, so
your hand-crafted x86-specific #if is not just ugly, it's liable to
get worse.

The alternative is to just say that we should use "smp_mb()"
unconditionally, depending on how critical this code actually ends up
being.

Added linux-arch in case architecture-maintainers have comments on
"smp_release_before_store()" thing. It would be kind of similar to the
odd "smp_read_barrier_depends()", except it would normally be a full
memory barrier, except on architectures where a weaker barrier might
be sufficient.

I suspect there may be many architectures where a "smp_wmb()" is
sufficient for this case, for the simple reason that no sane
microarchitecture would *ever* move earlier reads down past a later
write, so release consistency really only needs the local writes to be
ordered, not the full memory ordering.

Arch people?

The more optimal solution may be to mark the store *itself* to be
"store with release consistency", which on x86 would be a regular
store (with the compiler barrier), but on other architectures may be a
special memory operation. On architectures with
release/aqcuire-consistency, there's not a separate barrier before the
store, the store instruction itself is done with special semantics. So
maybe the right thing to do is

   #define smp_release_consistency_store(val, ptr) ...

where on x86, the implementation would be a simple

   do { barrier(); *(ptr)=(val); } while (0)

but on other architectures it might be a inline asm with the required
magic store-with-release instruction.

How important is this code sequence? Is the "percpu_up_write()"
function really so critical that we can't have an extra memory
barrier? Or do people perhaps see *other* places where
release-consistency-stores might be worth doing?

But in no event do I want to see that butt-ugly #if statement.

                Linus
