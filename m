Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042Ab1ERL5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 07:57:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:39869 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932964Ab1ERL5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 07:57:48 -0400
Subject: Re: [patch 04/15] sched: validate CFS quota hierarchies
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <BANLkTikDofPR0TJwV8G=sVhG_GQKru9XhQ@mail.gmail.com>
References: <20110503092846.022272244@google.com>
	 <20110503092904.806273470@google.com> <1305539020.2466.4063.camel@twins>
	 <BANLkTinba-p6FJNYAPyE+B8A==vSfK1-rg@mail.gmail.com>
	 <1305646010.2466.5889.camel@twins>
	 <BANLkTikDofPR0TJwV8G=sVhG_GQKru9XhQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 18 May 2011 13:57:22 +0200
Message-ID: <1305719842.2466.7134.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 00:16 -0700, Paul Turner wrote:

> >
> > But what about those where they want both behaviours on the same machine
> > but for different sub-trees?
> 
> I originally considered a per-tg tunable.  I made the assumption that
> users would either handle this themselves (=0) or rely on the kernel
> to do it (=1).  There are some additional complexities that lead me to
> withdraw from the per-cg approach in this pass given the known
> resistance to it.

Yeah, that's quite horrid too, you chose wisely by not going there ;-)

> One concern was the potential ambiguity in the nesting of these values.
> 
> When an inconsistent entity is nested under a consistent one:
> 
> A) Do we allow this?
> B) How do we treat it?
> 
> I think if this was the case that it would make sense to allow it and
> that each inconsistent entity should effectively be treated as
> terminal from the parent's point of view, and as the new root from the
> child's point of view.
> 
> Does this make sense?  While this is the most intuitive definition for
> me there are certainly several other interpretations that could be
> argued for.

I'm not quite sure I get it, so what you're saying is: there were the
semantics are violated we draw a border and we only look at local
consistency, thereby side-stepping the whole problem.

Doesn't fly for me, also, see below, by not having any invariants you
don't have clear semantics at all.

> Would you prefer this approach be taken to consistency vs at a global
> level?  Do the use-cases above have sufficient merit that we even make
> this an option in the first place?  Should we just always force
> hierarchies to be consistent instead?  I'm open on this.

Yeah, I think the use cases do make sense, its just that I don't like
the two different semantics and the confusion that goes with it.

> >
> > Also, without the constraints, what does the hierarchy mean?
> >
> 
> It's still an upper-bound for usage, however it may not be achievable
> in an inconsistent hierarchy.  Whereas in a consistent one it should
> always be achievable. 

See that doesn't quite make sense to me, if its not achievable its
simply not and the meaning is no more.


So lets consider these cases again:

> - I have some application that I want to limit to 3 cpus
> I have a 2 workers in that application, across a period I would like
> those workers to use a maximum of say 2.5 cpus each (suppose they
> serve some sort of co-processor request per user and we want to
> prevent a single user eating our entire limit and starving out
> everything else).
>
> The goal in this case is not preventing increasing availability within a
> given limit, while not destroying the (relatively) work-conserving aspect of
> its performance in general.

So the problem here is that 2.5+2.5 > 3, right? So maybe our constraint
isn't quite right, since clearly the whole SCHED_OTHER bandwidth crap
has the purpose of allowing overload.

What about instead of using: \Sum u_i =< U, we use max(u_i) =< U, that
would allow the above case, and mean that the bandwidth limit placed on
the parent is the maximum allowed limit in that subtree. In overload
situations things go back to proportional parts of the subtree limit.

> >> - There's also the case of managing an abusive user, use cases such
> >> as the above means that users can usefully be given write permission
> >> to their relevant sub-hierarchy.
> >>
> >> If the system size changes, or a user becomes newly abusive then being
> >> able to set non-conformant constraint avoids the adversarial problem of having
> >> to find and bring all of their set (possibly maliciously large) limits
> >> within the global limit.

Right, so this example is a little more contrived in that if you had
managed it from the get-go the problem wouldn't be that big (you'd have
had sane limits to begin with).

So one solution is to co-mount the freezer cgroup with your cpu cgroup
and simply freeze the whole subtree while you sort out the settings :-)

Another possibility would be to allow something like:

 $ echo force:50000 > cfs_quota_us

Where the "force:" thing requires CAP_SYS_ADMIN and updates the entire
sub-tree such that the above invariant is kept.
