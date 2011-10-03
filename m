Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab1JCPXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:23:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:53389 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab1JCPXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:23:32 -0400
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Fleming <matt@console-pimps.org>, Tejun Heo <htejun@gmail.com>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 03 Oct 2011 17:22:00 +0200
In-Reply-To: <20111003130701.GB25952@redhat.com>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
	 <20110930165206.GA22048@redhat.com>
	 <1317412823.3375.34.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20110930235625.GD2658@mtj.dyndns.org>
	 <1317464192.3375.57.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1317474209.12973.15.camel@twins> <20111003130701.GB25952@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317655320.20367.25.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 15:07 +0200, Oleg Nesterov wrote:
> On 10/01, Peter Zijlstra wrote:

> But this series can't help afaics. At least in its current state. It
> only adds more locking to the sending paths.

Right, so I was hoping Matt had a plan (TM)... :-)

> And anyway it is wrong (afaics, and I didn't read it yet ;).

I'll leave you to be the judge of that, I haven't bent by brain around
all this signal stuff yet..

> > which precludes being able
> > to deliver signals from hardirq context, leading to lots of ugly in -rt.
> 
> I think, the best solution would be: never send the signal from irq
> context, and ->siglock shouldn't disable irqs.

Bit hard that, posix timers need to deliver signals which pretty much
mandates we do something from irq context (and the round-trip through
softirq context really isn't pretty nor good for performance).

> > The hope is that this work is a stepping stone to O(1) signal delivery.
> 
> Probably this is possible too. I was thinking anout this when
> set_current_blocked() was added. Unfortunately this needs a lot of
> complications.

Right, so the thing Thomas and I have been promoting for a while now is
to update a signal target vector on every signal mask update. Mask
updates should be the slow path. This would leave us with a ready target
in O(1).

Although given that we've promoted this idea for a while now and it
hasn't happened yet I'm sure its non-trivial :-)

> > Breaking up the multitude of uses of siglock certainly seems worthwhile
> > esp.
> 
> Agreed. But I am not sure how much we should split the locking when
> it comes to sending/dequeueing/etc signals. 5 locks seems too much.

It doesn't need all 5 locks to send a signal, does it? But then, I'm
somewhat out of my depth here, the whole signal delivery path always
looses me.

> > And yes, aside from that the siglock can be quite contended because its
> > pretty much the one lock serializing all of the process wide state.
> 
> True.
> 
> Mostly this is because we moved misc stuff from tasklist to siglock,
> previously this was a win. Today this doesn't look good.

Well a per-process lock still wins from a global lock, but yeah, it
wants to be broken up further.

