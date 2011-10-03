Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab1JCOLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 10:11:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab1JCOKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 10:10:53 -0400
Date: Mon, 3 Oct 2011 15:07:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Matt Fleming <matt@console-pimps.org>, Tejun Heo <htejun@gmail.com>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
Message-ID: <20111003130701.GB25952@redhat.com>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org> <20110930165206.GA22048@redhat.com> <1317412823.3375.34.camel@mfleming-mobl1.ger.corp.intel.com> <20110930235625.GD2658@mtj.dyndns.org> <1317464192.3375.57.camel@mfleming-mobl1.ger.corp.intel.com> <1317474209.12973.15.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317474209.12973.15.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01, Peter Zijlstra wrote:
>
> On Sat, 2011-10-01 at 11:16 +0100, Matt Fleming wrote:
> > I also think Thomas/Peter mentioned something about latency in
> > delivering timer signals because of contention on the per-process
> > siglock. They might have some more details on that. 
>
> Right, so signal delivery is O(nr_threads),

Yes, a !SIGEV_THREAD_ID timer needs to find a thread which doesn't
block the signal.

But this series can't help afaics. At least in its current state. It
only adds more locking to the sending paths.

And anyway it is wrong (afaics, and I didn't read it yet ;).

> which precludes being able
> to deliver signals from hardirq context, leading to lots of ugly in -rt.

I think, the best solution would be: never send the signal from irq
context, and ->siglock shouldn't disable irqs.

> The hope is that this work is a stepping stone to O(1) signal delivery.

Probably this is possible too. I was thinking anout this when
set_current_blocked() was added. Unfortunately this needs a lot of
complications.

> Breaking up the multitude of uses of siglock certainly seems worthwhile
> esp.

Agreed. But I am not sure how much we should split the locking when
it comes to sending/dequeueing/etc signals. 5 locks seems too much.

> And yes, aside from that the siglock can be quite contended because its
> pretty much the one lock serializing all of the process wide state.

True.

Mostly this is because we moved misc stuff from tasklist to siglock,
previously this was a win. Today this doesn't look good.

Oleg.

