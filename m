Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666Ab0KLQjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:39:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932107Ab0KLQjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:39:44 -0500
MIME-Version: 1.0
In-Reply-To: <20101111080012.GB10210@amd>
References: <20101111080012.GB10210@amd>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 12 Nov 2010 08:39:17 -0800
Message-ID: <AANLkTinAY=jbtEEFa0XgYiHs8Lj21Q58FhPpU+TOtWnf@mail.gmail.com>
Subject: Re: [patches] seqlock: add barrier-less special cases for seqcounts
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 12:00 AM, Nick Piggin <npiggin@kernel.dk> wrote:
> Add branch annotations for seqlock read fastpath, and introduce
> __read_seqcount_begin and __read_seqcount_end functions, that can avoid
> the smp_rmb() if it is provided with some other barrier. Read barriers
> have non trivial cost on many architectures.
>
> These will be used by store-free path walking algorithm, where
> performance is critical and seqlocks are widely used.

A couple of questions:

 - what are the barriers in question? IOW, describe some normal use.

 - do we really want the "repeat until seqlock is even" code in the
__read_seqcount_begin() code for those kinds of internal cases?

That second one is very much a question for the use-case like the
pathname walk where you have a fall-back that uses "real" locking
rather than the optimistic sequence locks. I have a suspicion that if
seq_locks are used as an "optimistic lockless path with a locking
fallback", then if we see an odd value at the beginning we should
consider it a hint that the sequence lock is contended and the
optimistic path should be aborted early.

In other words, I kind of suspect that anybody that wants to use some
internal sequence lock function like __read_seqcount_begin() would
also want to do its own decision about what happens when the seqlock
is already in the middle of having an active writer.

So the interface seems a bit broken: if we really want to expose these
kinds of internal helper functions, then I suspect not only the
smp_rmb(), but also the whole "loop until even" should be in the
normal "read_seqcount_begin()" function, and __read_seqcount_begin()
would _literally_ just do the single sequence counter access.

I dunno. Just a gut feel. Added Al, Ingo and Thomas to the Cc - the
whole "loop in begin" was added by Ingo and Thomas a few years ago to
avoid a live-lock, but that live-lock issue really isn't an issue if
you end up falling back on a locking algorithm and have a "early
failure" case for the __read_seqcount_begin() the same way we have the
final failure case for [__]read_seqcount_retry().

             Linus
