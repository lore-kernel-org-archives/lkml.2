Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041Ab1JDRSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 13:18:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932204Ab1JDRSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 13:18:36 -0400
Date: Tue, 4 Oct 2011 19:14:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Matt Fleming <matt@console-pimps.org>, Tejun Heo <htejun@gmail.com>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
Message-ID: <20111004171437.GA3489@redhat.com>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org> <20110930165206.GA22048@redhat.com> <1317412823.3375.34.camel@mfleming-mobl1.ger.corp.intel.com> <20110930235625.GD2658@mtj.dyndns.org> <1317464192.3375.57.camel@mfleming-mobl1.ger.corp.intel.com> <1317474209.12973.15.camel@twins> <20111003130701.GB25952@redhat.com> <1317655320.20367.25.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317655320.20367.25.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03, Peter Zijlstra wrote:
>
> On Mon, 2011-10-03 at 15:07 +0200, Oleg Nesterov wrote:
> > On 10/01, Peter Zijlstra wrote:
>
> > But this series can't help afaics. At least in its current state. It
> > only adds more locking to the sending paths.
>
> Right, so I was hoping Matt had a plan (TM)... :-)

Whatever we do with the locking, this can't remove O(nr_threads),
although read_lock() could help to reduce the contention.

> > I think, the best solution would be: never send the signal from irq
> > context, and ->siglock shouldn't disable irqs.
>
> Bit hard that, posix timers need to deliver signals which pretty much
> mandates we do something from irq context

Of course. We should notify a thread even if it blocks the signal.

> (and the round-trip through
> softirq context really isn't pretty nor good for performance).

No, no. I meant, it would be nice to offload the sending to the target.
The process itself should take care.

> > Probably this is possible too. I was thinking anout this when
> > set_current_blocked() was added. Unfortunately this needs a lot of
> > complications.
>
> Right, so the thing Thomas and I have been promoting for a while now is
> to update a signal target vector on every signal mask update. Mask
> updates should be the slow path. This would leave us with a ready target
> in O(1).

Yes. This is the "obvious" solution ;) Now that we have
set_current_blocked() this is simple. Except, of course, this blows
signal_struct and set_current_blocked() can't rely on TIF_SIGPENDING.
But we can probably add TIF_YOU_ARE_LISTED_IN_CURR_TARGET_ARRAY.

And in fact this was _one_ of the reasons for set_current_blocked().

> > Agreed. But I am not sure how much we should split the locking when
> > it comes to sending/dequeueing/etc signals. 5 locks seems too much.
>
> It doesn't need all 5 locks to send a signal, does it?

Depending on group/private 3 or 4. Plus ->ctrl_lock if the signal
is fatal but I don't really understand this part... Fortunately I
think this is not needed ;)

And mostly (afaics) this tries to help to dequeue the signal, not
to send. At least currently.

Oleg.

