Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab1JQBkU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 21:40:20 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60272 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab1JQBkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 21:40:18 -0400
MIME-Version: 1.0
In-Reply-To: <20111013232521.GA5654@hostway.ca>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
 <20111007070842.GA27555@hostway.ca> <20111007174848.GA11011@hostway.ca>
 <1318010515.398.8.camel@twins> <20111008005035.GC22843@hostway.ca>
 <1318060551.8395.0.camel@twins> <20111012213555.GC24461@hostway.ca> <20111013232521.GA5654@hostway.ca>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 16 Oct 2011 18:39:57 -0700
X-Google-Sender-Auth: cqwWZtXSnSNHmDcS8XMcLQDw23I
Message-ID: <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
Subject: Re: Linux 3.1-rc9
To: Simon Kirby <sim@hostway.ca>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 4:25 PM, Simon Kirby <sim@hostway.ca> wrote:
>
> Looks good. No hangs or crashes for two days on any of them running
> 3.1-rc9 plus this patch. Not sure if you want to deuglify it, but it
> seems to work...
>
> Tested-by: Simon Kirby <sim@hostway.ca>

Peter, what's the status of this one?

Quite frankly, I personally consider it to be broken - why are we
introducing this new lock for this very special thing? A spinlock to
protect a *single* word of counter seems broken.

It seems more likely that the real bug is that kernel/sched_stats.h
currently takes cputimer->lock without disabling interrupts. Everybody
else uses irq-safe locking, why would sched_stats.h not need that?

However, I don't see why that spinlock is needed at all. Why aren't
those fields just atomics (or at least just "sum_exec_runtime")? And
why does "cputime_add()" exist at all? It seems to always be just a
plain add, and nothing else would seem to ever make sense *anyway*?

In other words, none of that code makes any sense to me at all. And
the patch in question that fixes a hang for Simon seems to make it
even worse. Can somebody explain to me why it looks that crappy?

Please?

That stupid definition of cputime_add() has apparently existed as-is
since it was introduced in 2005. Why do we have code like this:

    times->utime = cputime_add(times->utime, t->utime);

instead of just

    times->utime += t->utime;

which seems not just shorter, but more readable too? The reason is not
some type safety in the cputime_add() thing, it's just a macro.

Added Martin and Ingo to the discussion - Martin because he added that
cputime_add in the first place, and Ingo because he gets the most hits
on kernel/sched_stats.h. Guys - you can see the history on lkml.

                                 Linus
