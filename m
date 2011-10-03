Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab1JCN4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:56:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:52129 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab1JCN4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:56:32 -0400
Date: Mon, 3 Oct 2011 15:56:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <htejun@gmail.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Matt Fleming <matt@console-pimps.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
In-Reply-To: <20111003013855.GG31799@mtj.dyndns.org>
Message-ID: <alpine.LFD.2.02.1110031544340.1489@ionos>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org> <20110930165206.GA22048@redhat.com> <1317412823.3375.34.camel@mfleming-mobl1.ger.corp.intel.com> <20110930235625.GD2658@mtj.dyndns.org> <1317464192.3375.57.camel@mfleming-mobl1.ger.corp.intel.com>
 <1317474209.12973.15.camel@twins> <20111003013855.GG31799@mtj.dyndns.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Oct 2011, Tejun Heo wrote:
> On Sat, Oct 01, 2011 at 03:03:29PM +0200, Peter Zijlstra wrote:
> > On Sat, 2011-10-01 at 11:16 +0100, Matt Fleming wrote:
> > > I also think Thomas/Peter mentioned something about latency in
> > > delivering timer signals because of contention on the per-process
> > > siglock. They might have some more details on that. 
> > 
> > Right, so signal delivery is O(nr_threads), which precludes being able
> > to deliver signals from hardirq context, leading to lots of ugly in -rt.
> 
> Signal delivery is O(#threads)?  Delivery of fatal signal is of course
> but where do we walk all threads during non-fatal signal deliveries?
> What am I missing?

Delivery of any process wide signal can result in an O(thread) walk to
find a valid target. That's true for user space originated and kernel
space originated (e.g. posix timers) signals.
 
> > Breaking up the multitude of uses of siglock certainly seems worthwhile
> > esp. if it also allows for a cleanup of the horrid mess called
> > signal_struct (which really should be called process_struct or so).
> > 
> > And yes, aside from that the siglock can be quite contended because its
> > pretty much the one lock serializing all of the process wide state.
> 
> Hmmm... can you please be a bit more specific?  I personally has never
> seen a case where siglock becomes a problem and IIUC Matt also doesn't

Signal heavy applications suffer massivly from sighand->siglock
contention. sighand->siglock protects the world and some more and Matt
has explained it quite proper. And we have rather large code pathes
covered by it (posix-cpu-timers are the worst of all).

> have actual use case at hand.  Given the fragile nature of this part
> of kernel, it would be nice to know what the return is.

The return is finer grained locking and in the end a faster signal
delivery path which benefits everyone as we do not burden a random
interrupted task with the convoluted signal delivery because we want
to burden the task using signals with it.

Thanks,

	tglx
