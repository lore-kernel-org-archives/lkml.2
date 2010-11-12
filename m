Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab0KLXHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 18:07:05 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:21843 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313Ab0KLXHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 18:07:02 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIJV3Ux5LcEI/2dsb2JhbACiUHK+cIVKBA
Date: Sat, 13 Nov 2010 10:06:50 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patches] seqlock: add barrier-less special cases for seqcounts
Message-ID: <20101112230650.GA3317@amd>
References: <20101111080012.GB10210@amd>
 <AANLkTinAY=jbtEEFa0XgYiHs8Lj21Q58FhPpU+TOtWnf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinAY=jbtEEFa0XgYiHs8Lj21Q58FhPpU+TOtWnf@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 08:39:17AM -0800, Linus Torvalds wrote:
> On Thu, Nov 11, 2010 at 12:00 AM, Nick Piggin <npiggin@kernel.dk> wrote:
> > Add branch annotations for seqlock read fastpath, and introduce
> > __read_seqcount_begin and __read_seqcount_end functions, that can avoid
> > the smp_rmb() if it is provided with some other barrier. Read barriers
> > have non trivial cost on many architectures.
> >
> > These will be used by store-free path walking algorithm, where
> > performance is critical and seqlocks are widely used.
> 
> A couple of questions:
> 
>  - what are the barriers in question? IOW, describe some normal use.

OK, anything that provides smp_rmb() or stronger. I really prefer not
to have a "normal" usage for these things, only *really* carefully
controlled and critical parts. I came up with these after doing some
testing on a POWER7 to really shave off cycles.

In the case of rcu-walk, we basically have a chain of dentries to walk
down, and so we need to take seqlocks as we go. So the pattern goes:

dentry = cwd;
seq = read_seqlock(&dentry->d_seq);
/* do path walk */
child = d_lookup(dentry, name);
seq2 = read_seqlock(&child->d_seq);
if (read_seqretry(&dentry->d_seq, seq))
  /* bail out */

So we have to have these inter-linked chain of seqlocks covering the
walk. As such, the smp_rmb tends to get repeated in each one, wheras
we don't actually have to have the smp_rmb for the child issued until
after we verify the parent's sequence (because we don't load anything
from the child until after that).

I really don't anticipate many other users, but perhaps similar case
like walking down nodes of a tree or something.


>  - do we really want the "repeat until seqlock is even" code in the
> __read_seqcount_begin() code for those kinds of internal cases?
> 
> That second one is very much a question for the use-case like the
> pathname walk where you have a fall-back that uses "real" locking
> rather than the optimistic sequence locks. I have a suspicion that if
> seq_locks are used as an "optimistic lockless path with a locking
> fallback", then if we see an odd value at the beginning we should
> consider it a hint that the sequence lock is contended and the
> optimistic path should be aborted early.
> 
> In other words, I kind of suspect that anybody that wants to use some
> internal sequence lock function like __read_seqcount_begin() would
> also want to do its own decision about what happens when the seqlock
> is already in the middle of having an active writer.
> 
> So the interface seems a bit broken: if we really want to expose these
> kinds of internal helper functions, then I suspect not only the
> smp_rmb(), but also the whole "loop until even" should be in the
> normal "read_seqcount_begin()" function, and __read_seqcount_begin()
> would _literally_ just do the single sequence counter access.
> 
> I dunno. Just a gut feel. Added Al, Ingo and Thomas to the Cc - the
> whole "loop in begin" was added by Ingo and Thomas a few years ago to
> avoid a live-lock, but that live-lock issue really isn't an issue if
> you end up falling back on a locking algorithm and have a "early
> failure" case for the __read_seqcount_begin() the same way we have the
> final failure case for [__]read_seqcount_retry().

Possibly, you're right. Now the fallback case is obviously suboptimal
and heavyweight, so we do want to avoid it if we can. Also not having
an error to handle in seqcount_begin is just one less thing to worry
about.

I mean, we can just fall out immediately if we want to, but is there
much advantage in doing so? The write side critical sections on these
things are very small -- pretty much only when the ->d_inode goes
away or ->d_name changes.

