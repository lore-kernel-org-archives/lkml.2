Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab2JIOPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 10:15:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:52921 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab2JIOPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 10:15:16 -0400
Message-ID: <1349792104.7880.41.camel@twins>
Subject: Re: [REPOST] RFC: sched: Prevent wakeup to enter critical section
 needlessly
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ivo Sieben <meltedpianoman@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, linux-serial@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@linuxfoundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Date: Tue, 09 Oct 2012 16:15:04 +0200
In-Reply-To: <m2r4p7u5pk.fsf@firstfloor.org>
References: <1348491997-30898-1-git-send-email-meltedpianoman@gmail.com>
	 <1349782235-8896-1-git-send-email-meltedpianoman@gmail.com>
	 <m2r4p7u5pk.fsf@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 06:37 -0700, Andi Kleen wrote:
> Ivo Sieben <meltedpianoman@gmail.com> writes:
> 
> > Check the waitqueue task list to be non empty before entering the critical
> > section. This prevents locking the spin lock needlessly in case the queue
> > was empty, and therefor also prevent scheduling overhead on a PREEMPT_RT
> > system.
> >
> > Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>
> > ---
> >
> >  REPOST:
> >  Request for comments:
> >  - Does this make any sense?
> 
> Looks good to me. Avoiding any spinlock is good.  I don't even think you
> need "careful", if you miss an update it was just as it happened a
> little later.

Yeah, so I've started looking at this several times, but never had the
time to actually think it through. I think I'll agree with you that
using the careful list empty check isn't needed.

In general there's already the race of doing a wakeup before the wait
and if the code using the waitqueue doesn't deal with that its already
broken, so in that respect you should be good, since you're simply
shifting the timing a little.

One thing you might need to consider is the memory ordering, will the
list_empty -- either careful or not -- observe the right list pointer,
or could it -- when racing with wait_event()/prepare_to_wait() --
observe a stale value. Or.. is that all already covered in on the use
site.

I started auditing a few users to see what they all assume, if they're
already broken and or if they would now be broken.. but like said, I
didn't get anywhere.


I'd like to see this patch/Changelog amended to at least cover these
points so that I feel all warm and fuzzy when I read it and not have to
think too hard ;-)
