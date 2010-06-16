Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab0FPSWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 14:22:30 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39344 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab0FPSW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 14:22:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6015"; a="44494237"
Subject: Re: Overview of concurrency managed workqueue
From: Daniel Walker <dwalker@codeaurora.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
In-Reply-To: <4C1901E9.2080907@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	 <4C17C598.7070303@kernel.org>
	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>
	 <4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>
	 <4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster>
	 <4C18DC69.10704@kernel.org> <1276698880.9309.44.camel@m0nster>
	 <4C18E4B7.5040702@kernel.org> <1276701074.9309.60.camel@m0nster>
	 <4C18F2B8.9060805@kernel.org> <1276705838.9309.94.camel@m0nster>
	 <4C1901E9.2080907@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jun 2010 11:22:27 -0700
Message-ID: <1276712547.9309.172.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 18:55 +0200, Tejun Heo wrote:
> Hello,
> 
> On 06/16/2010 06:30 PM, Daniel Walker wrote:
> >> I don't know.  I suppose a high priority thread is trying to flush a
> >> work item or workqueue thus causing priority inversion, right?  Maybe
> >> we can add high priority emergency worker which gets triggered through
> >> priority inversion detection or maybe the code shouldn't be flushing
> >> in the critical path anyway.
> > 
> > It's not a flushing situation .. The high priority thread is a userspace
> > thread so it , AFAIK, can't flush any workqueues.
> 
> So, how is it stalling?  How would I be able to tell anything about
> the situation when all you're saying is doing this and that voodoo
> thing made it go away for me?

There's so many different ways that threads can interact .. Can you
imagine a thread waiting in userspace for something to complete in the
kernel, that does actually happen pretty often ;) .

I was just now randomly trolling through drivers and found this one,
drivers/spi/amba-pl022.c ..

It processes some data in the interrupt, but sometimes it offloads the
processing to a workqueue from the interrupt (or tasklet) .. If for
example I'm a userspace thread waiting for that data then I would have
to wait for that workqueue to complete (and it's priority plays a major
roll in when it completes).

I'm sure there's plenty other examples of userspace threads waiting for
workqueues to complete. I would hope that with your patchset you've
investigated some.

> >>>> Peter brought up the work priority issue previously and Linus was
> >>>> pretty clear on the issue.  They're in the discussiosn for the first
> >>>> or second take.
> >>>
> >>> Send us a link to this discussion.
> >>
> >>   http://thread.gmane.org/gmane.linux.kernel/929641
> > 
> > I didn't see anything in there related to this discussion.
> 
> It was about using wq for cpu intensive / RT stuff.  Linus said,
> 
>   So stop arguing about irrelevancies. Nobody uses workqueues for RT
>   or for CPU-intensive crap. It's not what they were designed for, or
>   used for.

Which is not relevant to this discussion .. We're talking about
re-prioritizing the workqueue threads. We're _not_ talking about
workqueues designed specifically for real time purposes.

> >> Maybe it's me not understanding something but I don't really think
> >> exposing workqueue priorities to userland is a good solution at all.
> > 
> > Why not? They currently are to no known ill effects (none that I know
> > of).
> 
> Because...
> 
> * fragile as hell

Changing the thread priorities shouldn't be fragile , if it is right now
then the threads are broken .. Can you exaplin in which cases you've
seen it being fragile?

> * depends heavily on unrelated implementation details

I have no idea what this means.

> * has extremely limited test coverage

Simple, just write tests.

> * doesn't help progressing mainline at all

progressing where?

> >>> You have no idea how many people are doing this, or in what
> >>> circumstances .. Please don't make mass speculation over things you
> >>> clearly are not aware of.
> >>
> >> Well, then please stop insisting it to be a feature to keep.  It's not
> >> a feature.
> > 
> > It may not have been a feature in the past, but it's used as a feature
> > now.. So it is a feature even tho you don't want it to be.
> 
> That's exactly like grepping /proc/kallsyms to determine some feature
> and claiming it's a feature whether the kernel intends it or not.
> Sure, use it all you want.  Just don't expect it to be there on the
> next release.

Your assume there's no value in changing the priorities which is wrong.
Your assuming way to much . Changing the priorities is useful.

> >> Oh yeah, if you're not insisting fixed mapping, then I don't have any
> >> problem with that.  As for what to do for priority inversions
> >> involving workqueues, I don't have any concrete idea (it was not in
> >> the mainline, so I didn't have to solve it) but one way would be
> >> reserving/creating temporary high priority workers and use them to
> >> process work items which the high priority thread is blocked on.
> > 
> > But it is in the mainline, that's why we're talking right now.
> 
> The problem is in the mainline.  Solution is not.  It's not a solved
> problem.  It's also a pretty niche problem.

We're talking about functionality your removing from the kernel, which
is useful . So your creating a problem that mainline currently doesn't
have. That's a defect in your patchset ..

> > What I was thinking is that you could have a debugfs interface which
> > would list off what workqueues you system is processing and give the
> > user the ability to pull one or more of those workqueues into individual
> > threads for processing, just like it currently is. That way I can
> > prioritize the work items with out you having to give priorities through
> > your entire system.
> 
> Why would the user want to bother with all that?  Shouldn't the kernel
> just do the right thing?  IIRC, people are working on priority
> inheriting userland mutexes.  If your problem case can't be solved by
> that, please try to fix it in proper way not through some random knobs
> that nobody really can understand.

It's funny cause your talking about priority inheritance, yet your
system makes that much more difficult to implement .. So, yes, I would
like priority inheritance for _current_ workqueues in mainline that
would solve many problems, but that doesn't exist in mainline yet. So I
use the features which _do exist_ . 

> > The alternative is that you would give each work item a settable
> > priority and your whole system would have to honor that, which would be
> > a little like re-creating the scheduler.
> >
> >> But, really, without knowing details of those inversion cases, it
> >> would be pretty difficult to design something which fits.  All that I
> >> can say is having shared worker pool isn't exclusive with solving the
> >> problem.
> > 
> > The cases are all in the mainline kernel, you just have to look at the
> > code in a different way to understand them ..
> 
> Yeah, sure, all the problems in the world which haven't been solved
> yet are there.  The _solution_ isn't there and solutions are what
> people conserve when trying to improve things.

I have no idea what your saying here.. Your adding a new problem to
mainline that's what we're addressing.

> > If I have a userspace thread at a high priority and I'm making calls
> > into the kernel, some of those call inevitably will put work items
> > onto workqueues, right? I'm sure you can think of 100's of ways in
> > which this could happen .. At that point my thread depends on the
> > workqueue thread, since the workqueue thread is doing processing for
> > which I've , in some way, requested from userspace.
> 
> You're basically saying that "I don't know how those inheritance
> inversions are happening but if I turn these magic knobs they seem to
> go away so I want those magic knobs".  Maybe the RT part of the code
> shouldn't be depending on that many random things to begin with?  And
> if there are actually things which are necessary, it's better idea to
> solve it properly through identifying problem points and properly
> inheriting priority instead of turning knobs until it somehow works?

I think your mis-interpreting me .. If I write a thread (in userspace)
which I put into RT priorities I don't have a lot of control over what
dependencies the kernel may put on my thread. Think from a users
perspective not from a kernel developers perspective.

I'm not saying changing a workqueue priority would be a final solution,
but it is a way to prioritize things immediately and has worked in prior
kernels up till your patches.

> If you wanna work on such things, be my guest.  I'll be happy to work
> with you but please stop talking about setting priorities of
> workqueues from userland.  That's just nuts.

You just don't understand it.. How can you expect your patches to go
into mainline with this attitude toward usages you just don't
understand?

Daniel

