Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab2HPThG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:37:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56398 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab2HPThC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:37:02 -0400
Date: Thu, 16 Aug 2012 12:36:58 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCHSET] timer: clean up initializers and implement irqsafe
 timers
Message-ID: <20120816193658.GD24861@google.com>
References: <20120813233520.GG25632@google.com>
 <alpine.LFD.2.02.1208142055260.32033@ionos>
 <20120814192203.GY25632@google.com>
 <alpine.LFD.2.02.1208142243500.32033@ionos>
 <20120814215632.GE25632@google.com>
 <alpine.LFD.2.02.1208150005090.32033@ionos>
 <20120814230100.GF25632@google.com>
 <alpine.LFD.2.02.1208150116570.32033@ionos>
 <20120815001805.GH25632@google.com>
 <1345028307.31459.80.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345028307.31459.80.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Wed, Aug 15, 2012 at 12:58:27PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-08-14 at 17:18 -0700, Tejun Heo wrote:
> > Let's see if we can agree on the latter point first.  Do you agree
> > that it wouldn't be a good idea to implement relatively complex timer
> > subsystem inside workqueue? 
> 
> RB-trees are fairly trivial to use,

I'll get back to this later.

> but can we please get back to why
> people want to do del/mod delayed work from IRQ context?
> 
> I can get the queueing part, but why do they need to cancel and or
> modify stuff?

It isn't different from being able to use del_timer() or mod_timer()
from IRQ handlers.

For example, block layer uses delayed_work to restart queue processing
after a short delay for whatever reason.  Depending on the driver,
request issuing can happen from its IRQ handler chained from
completion.  If the command processing detects a condition which
indicates that the queue can't process any more requests until another
event happens, it shoots down the delayed_work.

Another example is drivers using polling and irq together.  If IRQ
happens, they shoot down the pending delayed_work and schedules it
immediately.  Another similar use is timeout handler.  Schedule
timeout handler when initiating an operation and cancel it on
completion IRQ.

Apart from having process context when executing the callback,
delayed_work's use case isn't different from timer.  It might as well
be named sleepable_timer and implemented as part of timer with
cooperation from workqueue.

As such, it's natural to expect interface and behavior similar to
those of timer and that's another reason why implementing workqueue's
own timerlist isn't a good idea.  e.g. What about deferrable
delayed_work?  We definitely better have that and I'm sure it can also
be implemented separately in workqueue too, but it seems quite silly
to me.  Let's say we implement it by having two timer_lists, one
deferrable and one not.  What if someone wants to adjust timer slack -
ie. what about users which can use much larger slack than allowed by
the default deferrable?

Yet another thing is that not being able to use
cancel/mod_delayed_work() from IRQ handlers is inherently bad API.
The restriction isn't inherent in what it does.  It rises purely from
implementation details.  For an API which is as widely used as
workqueue, especially by drivers, that just doesn't seem like a good
idea.

The downside being one additional if() in timer execution path, to me,
the tradeoff seems clear.  If exposing IRQSAFE to other users or
allowing del_timer_sync() from IRQ context is bothersome, those can be
dropped too.  The *only* thing which is necessary is for timer to not
enable IRQ between delayed_work timer being dequeued and its
execution.

Thanks.

-- 
tejun
