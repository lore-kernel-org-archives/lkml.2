Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904Ab0FPOep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 10:34:45 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49604 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758847Ab0FPOen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 10:34:43 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6014"; a="44614054"
Subject: Re: Overview of concurrency managed workqueue
From: Daniel Walker <dwalker@codeaurora.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
In-Reply-To: <4C18DC69.10704@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	 <4C17C598.7070303@kernel.org>
	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>
	 <4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>
	 <4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster>
	 <4C18DC69.10704@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jun 2010 07:34:40 -0700
Message-ID: <1276698880.9309.44.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 16:15 +0200, Tejun Heo wrote:
> Hello,
> 
> On 06/16/2010 04:05 PM, Daniel Walker wrote:
> > On Wed, 2010-06-16 at 15:45 +0200, Tejun Heo wrote:
> >> On 06/16/2010 03:41 PM, Daniel Walker wrote:
> >>> Any workqueue that has a thread which can be prioritized from userspace.
> >>> As long as there is a thread it can usually be given a priority from
> >>> userspace, so any _current_ workqueue which uses a single thread or
> >>> multiple threads is an example of what I'm talking about.
> >>
> >> Eh... what's the use case for that?  That's just so wrong.  What do
> >> you do after a suspend/resume cycle?  Reprioritize all of them from
> >> suspend/resume hooks?
> > 
> > The use case is any situation when the user wants to give higher
> > priority to some set of work items, and there's nothing wrong with that.
> 
> Come on.  The user can't even know what's going on each workqueue
> thread.  Something you can do doesn't make it a good idea.  In this
> case, it's a very bad idea.

You just don't understand the use case. Let say I have a high priority
thread in userspace , and I discover through analysis that my thread is
being forced to wait on a workqueue thread (priority inversion) , so
then I just increase the workqueue thread priority to overcome the
inversion. That's totally valid, and you don't even need to know exactly
what the thread is doing..

Now lets say the same thing happens under your changes.. Well, then I'm
screwed cause your changes turn the workqueues into a opaque thread
cloud which can't be prioritized.

> > In fact there has been a lot of work in the RT kernel related to
> > workqueue prioritization ..
> 
> That frankly I don't have much idea about.

Exactly, but I do know about it which is why we're talking. So your
saying that use cases that you don't know about don't really matter
right?

> > suspend/resume shouldn't touch the thread priorities unless your tearing
> > down the threads and remaking them each suspend/resume cycle from inside
> > the kernel.
> 
> And here's a perfect example of why it's a very bad idea.  The kernel
> is *ALREADY* doing that on every suspend/resume cycle, so if you are
> thinking that priorities on kernel workqueue threads were being
> maintained over suspend/resume cycles, you're wrong and have been
> wrong for a very long time.

I'd have to look into that cause that seems odd to me. In terms of what
we're talking about it doesn't really matter tho. The use cases I'm
citing could easily be on systems that don't suspend (or even have that
enabled).

> Mangling workqueue thread priorities from userland is a fundamentally
> broken thing to do.  It's not a part of AP|BI and there's no guarantee
> whatsoever that something which works currently in certain way will
> keep working that way one release later.  If there's something which
> wants priority adjustment from userland, the right thing to do is
> finding out precisely why it's necesssary and implementing a published
> interface to do that.

Your completely wrong .. Look at the example I gave above .. Bottom line
is that your removing currently useful functionality, which is bad.. You
can say it's not useful, but again you also say you don't "have much
idea" regarding the cases where this is actually important.

Could you please just entertain the idea that maybe someone somewhere
might want to give priorities to the work items inside your system. I
mean consider the RT workqueue that you removed, why in the world would
we even have that if giving workqueues special priorities was a bad
thing (or not useful).

Daniel

