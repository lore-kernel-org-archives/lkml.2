Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250Ab0FPQal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:30:41 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53726 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab0FPQak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:30:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6015"; a="44482444"
Subject: Re: Overview of concurrency managed workqueue
From: Daniel Walker <dwalker@codeaurora.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
In-Reply-To: <4C18F2B8.9060805@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	 <4C17C598.7070303@kernel.org>
	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>
	 <4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>
	 <4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster>
	 <4C18DC69.10704@kernel.org> <1276698880.9309.44.camel@m0nster>
	 <4C18E4B7.5040702@kernel.org> <1276701074.9309.60.camel@m0nster>
	 <4C18F2B8.9060805@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jun 2010 09:30:38 -0700
Message-ID: <1276705838.9309.94.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 17:50 +0200, Tejun Heo wrote:
> Hello,
> 
> On 06/16/2010 05:11 PM, Daniel Walker wrote:
> >> If you find that some work item is causing priority inversion, you
> >> need to fix the problem instead of working around in adhoc way which
> >> won't be useful to anyone else, so, no, it doesn't sound like a useful
> >> use case.
> > 
> > How do I fix the problem then? Without doing what I've already
> > suggested.
> 
> I don't know.  I suppose a high priority thread is trying to flush a
> work item or workqueue thus causing priority inversion, right?  Maybe
> we can add high priority emergency worker which gets triggered through
> priority inversion detection or maybe the code shouldn't be flushing
> in the critical path anyway.

It's not a flushing situation .. The high priority thread is a userspace
thread so it , AFAIK, can't flush any workqueues.

> >> Peter brought up the work priority issue previously and Linus was
> >> pretty clear on the issue.  They're in the discussiosn for the first
> >> or second take.
> > 
> > Send us a link to this discussion.
> 
>   http://thread.gmane.org/gmane.linux.kernel/929641

I didn't see anything in there related to this discussion.

> >>> Your completely wrong .. Look at the example I gave above .. Bottom line
> >>> is that your removing currently useful functionality, which is bad.. You
> >>> can say it's not useful, but again you also say you don't "have much
> >>> idea" regarding the cases where this is actually important.
> >>
> >> I said that I didn't have much idea about RT work priority thing, not
> >> setting priority on wq workers for adhoc workaround for whatever.
> >> IIRC, the RT work priority thing Peter was talking about was a
> >> different thing.  Sure, more complex workqueue implementation would
> >> complicate implementing work priorities, but if necessary maybe we can
> >> grow different classes of worker pools.
> > 
> > Ok .. So what would these different classes look like then ? Is that
> > something I could prioritize from userspace perhaps ?
> 
> Maybe it's me not understanding something but I don't really think
> exposing workqueue priorities to userland is a good solution at all.

Why not? They currently are to no known ill effects (none that I know
of).

> >>> Could you please just entertain the idea that maybe someone somewhere
> >>> might want to give priorities to the work items inside your system.
> >>
> >> If that's necessary, do it properly.  Give *work* priorities or at
> >> least give explicit priorities to workqueues.  That's a completely
> >> different thing from insisting fixed workqueue to kthread mapping so
> >> that three people on the whole planet can set priority on those
> >> kthreads not even knowing what the hell they do.
> > 
> > You have no idea how many people are doing this, or in what
> > circumstances .. Please don't make mass speculation over things you
> > clearly are not aware of.
> 
> Well, then please stop insisting it to be a feature to keep.  It's not
> a feature.

It may not have been a feature in the past, but it's used as a feature
now.. So it is a feature even tho you don't want it to be.

> > I'm not insisting any fixed mapping, you need to open you mind to
> > _possibilities_ .. How can the work items be given priorities _inside
> > your system_! Can you give an interface in which people can set a
> > priority to a give type of work item, then maybe you system honors those
> > priorities in _some way_ ..
> > 
> > In fact, I'm only asking that you consider it, ponder it..
> 
> Oh yeah, if you're not insisting fixed mapping, then I don't have any
> problem with that.  As for what to do for priority inversions
> involving workqueues, I don't have any concrete idea (it was not in
> the mainline, so I didn't have to solve it) but one way would be
> reserving/creating temporary high priority workers and use them to
> process work items which the high priority thread is blocked on.

But it is in the mainline, that's why we're talking right now.

What I was thinking is that you could have a debugfs interface which
would list off what workqueues you system is processing and give the
user the ability to pull one or more of those workqueues into individual
threads for processing, just like it currently is. That way I can
prioritize the work items with out you having to give priorities through
your entire system.

The alternative is that you would give each work item a settable
priority and your whole system would have to honor that, which would be
a little like re-creating the scheduler.

> But, really, without knowing details of those inversion cases, it
> would be pretty difficult to design something which fits.  All that I
> can say is having shared worker pool isn't exclusive with solving the
> problem.

The cases are all in the mainline kernel, you just have to look at the
code in a different way to understand them .. If I have a userspace
thread at a high priority and I'm making calls into the kernel, some of
those call inevitably will put work items onto workqueues, right? I'm
sure you can think of 100's of ways in which this could happen .. At
that point my thread depends on the workqueue thread, since the
workqueue thread is doing processing for which I've , in some way,
requested from userspace.

Daniel

