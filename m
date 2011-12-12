Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab1LLXmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:42:42 -0500
Received: from www.linutronix.de ([62.245.132.108]:55488 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab1LLXmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:42:40 -0500
Date: Tue, 13 Dec 2011 00:42:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Busy-waiting with interrupts disabled
In-Reply-To: <1323730061.1377.13.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1112130040180.3020@ionos>
References: <Pine.LNX.4.44L0.1112121617400.1864-100000@iolanthe.rowland.org> <1323730061.1377.13.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011, Steven Rostedt wrote:

> On Mon, 2011-12-12 at 17:12 -0500, Alan Stern wrote:
> > How long is it okay to busy-wait with interrupts disabled?  Are there 
> > any clear-cut guidelines?

A few usecs nothing more.

> > My feeling is that for ordinary desktop use, 1-2 ms should be about the
> > limit, but other people may feel differently.  (There's one spot in
> > ehci-hcd where the delay can last up to 250 ms, which does seem rather
> 
> "250 ms", holy freaking OUCH! Batman!
> 
> 
> > excessive.  Fortunately it never takes that long unless the hardware is
> > broken.)
> > 
> > No doubt the RT people would say the upper bound should be on the order
> > of a few microseconds or less.  I'd be happy to change ehci-hcd, which
> > has several delays in the 1-2 ms range -- but they tend to be nested
> > inside routines that are called within the scope of spinlock_irq, which
> > means a fair amount of rewriting would be needed.
> > 
> > Any thoughts or recommendations?
> 
> Note that in -rt, spinlocks are really mutexes (unless they are
> raw_spinlocks, which you shouldn't do). Thus, if your spin is with
> spinlock_irq, it wont affect -rt, as it will not have interrupts
> disabled.
> 
> But I could imagine that such a long latency could manifest itself into
> something nasty (lots of interrupts queued up and such) that normal
> desktop users might see a hiccup or two.

Audio folks would be particularly happy about such crap. Aside of that
you can even starve timekeeping that way depending on the wraparound
time of your clocksource and the interrupt/timekeeping affinities at
that point.

Simply don't do that.

Thanks,

	tglx
