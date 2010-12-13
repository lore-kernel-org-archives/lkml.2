Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab0LMEsl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 23:48:41 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:50465 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755037Ab0LMEsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 23:48:40 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKoyBU15LdLl/2dsb2JhbACjf3nBCIVKBA
Date: Mon, 13 Dec 2010 15:48:34 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Nick Piggin <npiggin@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/46] fs: dcache scale hash
Message-ID: <20101213044834.GA8509@amd>
References: <cover.1290852958.git.npiggin@kernel.dk>
 <3eb32695435ae6c5fd1601467d78b560b5058e2b.1290852959.git.npiggin@kernel.dk>
 <20101209060911.GB8259@dastard>
 <20101209062801.GA3749@amd>
 <20101209081756.GE8259@dastard>
 <AANLkTimF457VDRTxjjhu+J9E616LBKP_86UcNS-u+P3p@mail.gmail.com>
 <20101209234258.GB9925@dastard>
 <20101210023520.GC3331@amd>
 <20101210090126.GH8259@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101210090126.GH8259@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 08:01:26PM +1100, Dave Chinner wrote:
> On Fri, Dec 10, 2010 at 01:35:20PM +1100, Nick Piggin wrote:
> > On Fri, Dec 10, 2010 at 10:42:58AM +1100, Dave Chinner wrote:
> > > On Thu, Dec 09, 2010 at 11:53:27PM +1100, Nick Piggin wrote:
> > > > Necessary changes to prevent bad ugliness resulting, or preventing
> > > > repeated steps for the particular changes, etc. of course. Killing un
> > > > related functions no.
> > > 
> > > Ok, I get the picture. You don't want a code review, you want a
> > > rubber stamp. Find someone else to get it from.
> > 
> > Of course I want code review. I am not going to just do everything
> > you say that I don't agree with, but I will explain why every time
> > (as I have done to all your points).
> 
> Which generally comes down to "I disagree with you". That's hard to
> argue against because you aren't willing to compromise.

I have been trying to explain my reasoning. For example, the suggestion
to change _d_rehash and to put by-address ordering of locking 2 dentries
in its own function I simply said that I don't want to pull in such
changes because they're not related or really touched by the patches.

I think that's reasonable, and so if I have a reasonable objection to a
minor issue, then I think we should get past it.


> So, to address your next comment, I'll restate what I was proposing.
> That is, to ensure all the d_flags accesses protected by d_lock as
> an initial patch rather than cleaning it up in an ad-hoc fashion
> later on, such as this later patch in your series:
> 
> [PATCH 14/46] fs: dcache scale d_unhashed
> 
> which has the description:
> 
> 	Protect d_unhashed(dentry) condition with d_lock.
> 
> which illustrates my point that not all accesses to d_flags are
> currently protected by d_lock as you are asserting. Hence:

It depends what you mean by accesses to d_flags.

No, not all of them are, because there are in fact some cases
where d_flags is read without any locking, when races don't matter
or aren't applicable.

But all writes to d_flags, in code where the dentry is live and
there can be concurrent writes to d_flags *are* protected by d_lock.

d_unhashed() is defined to:
 Returns true if the dentry passed is not currently hashed.

So what I have called the d_unhashed condition, I mean the combination
of DCACHE_UNHASHED and dentry membership on the hash list.

I'll improve that changelog because now you've brought it to my
attention I agree it's not very good.


> > I would prefer more in-depth review than from someone who doesn't know
> > d_lock protects d_flags,
> 
> Your implication about my competence is incorrect and entirely

Well you said that my patch adds d_flags protection in bits and
pieces in a random manner. d_flags is already protected by d_lock
upstream which I explained (nicely).


> inappropriate.  Ad hominen attacks don't improve your argument or
> encourage other people to review your code.

Well you keep escalating it too, like you swore at me when I try
several times to explain an issue.

http://marc.info/?l=linux-fsdevel&m=129193745921777&w=2


> > but any and all help is welcome. Even minor
> > nitpicking or cleanups are welcome if they are relevant to the patches.
> 
> If _you_ decide they are relevant.

There is give an take.

 
> Nick, in the past couple of months you've burnt everyone who has
> tried to review your changes in any meaningful way. Nobody wants to
> engage with you because you've aggressively disagreed with every
> significant change that has been requested. You have shown no desire
> to compromise, instead you argue that you are right until you've had
> the last word, and you have frequently resorted to condesending and
> disrespectful attacks on reviewers. You would do well to keep that
> in mind next time you wonder why nobody is stepping up to review
> your code.

This is exactly what you and Christoph did, to me, actually. And you're
wrong, nobody was reviewing my code long before that little episode. I
certainly did compromise with Al, regarding the merging of the inode
lock stuff, and although I disagreed with some parts, I said OK fine.

You can't seem to concede a single time that I am right or have a valid
point. The best you can possibly manage to to go silent (and then maybe
bring it up again a few weeks later). This is perhaps why I appear so
insolent, because when I disagree with you, I'm wrong so my reasoning
must be irrelevant. It just keeps happening (recently again with the vfs
percpu counters thread).

So as far as I can see, there never was a bridge there to begin with. I
wish we could work together because I don't in fact question your
competence or intelligence, but it seems you do mine.

