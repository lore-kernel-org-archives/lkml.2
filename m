Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab0E0QHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:07:44 -0400
Received: from www.tglx.de ([62.245.132.106]:58431 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab0E0QHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:07:39 -0400
Date: Thu, 27 May 2010 18:06:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Peter Zijlstra <peterz@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Paul@smtp1.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <Pine.LNX.4.44L0.1005271141410.3239-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.1005271751240.3032@localhost.localdomain>
References: <Pine.LNX.4.44L0.1005271141410.3239-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Alan Stern wrote:
> On Thu, 27 May 2010, Peter Zijlstra wrote:
> 
> > On Thu, 2010-05-27 at 16:33 +0100, Alan Cox wrote:
> > > On Thu, 27 May 2010 17:09:16 +0200
> > > Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > On Thu, 2010-05-27 at 11:06 -0400, Alan Stern wrote:
> > > > > 
> > > > >         Opportunistic suspends are okay.
> > > > > 
> > > > >         The proposed userspace API is too Android-specific.
> > > > 
> > > > I would argue opportunistic suspends are not ok, and therefore the
> > > > proposed API is utterly irrelevant.
> > > 
> > > Assuming you are happy that opportunistically entering C6 and the like is
> > > ok via ACPI can you explain why you have a problem with opportunistic
> > > suspend and why it is different to a very deep sleep CPU state such as we
> > > have now (and which on many embedded platforms we deal with *is* sleeping
> > > external devices too)
> > 
> > Agreed, but I understood the opportunistic suspend line from Alan Stern
> > to mean the echo opportunistic > /sys/power/foo thing.
> 
> Yes, that's what I meant.  Why do you think it is any worse than "echo 
> mem >/sys/power/state"?  The only difference is that it will block 
> until all in-kernel suspend blockers are disabled.
> 
> Or do you also think that "echo mem >/sys/power/state" is evil and 
> should be removed from the kernel as soon as possible?
> 
> And to answer Thomas's question: The whole reason for having in-kernel 
> suspend blockers is so that userspace can tell the system to suspend 
> without losing wakeup events.
> 
> Suppose a key is pressed just as a user program writes "mem" to
> /sys/power/state.  The keyboard driver handles the keystroke and queues
> an input event.  Then the system suspends and doesn't wake up until
> some other event occurs -- even though the keypress was an important
> one and it should have prevented the system from suspending.
> 
> With in-kernel suspend blockers and opportunistic suspend, this 
> scenario is prevented.  That is their raison-d'etre.

I tend to disagree. You are still looking at suspend as some extra
esoteric mechanism. We should stop doing this and look at suspend (to
RAM) as an additional deep idle state, which is well defined in terms
of power savings and wakeup latency. That's what I think opportunistic
suspend is all about. Now if you look at our current idle states in
x86 the incoming keystroke is never lost. 

So when suspend does lose the wakeup event then we need to fix that,
but why do we need suspend blockers for this ? Let's take your
example:

> The keyboard driver handles the keystroke and queues an input
> event. Then the system goes into suspend ....

Why do we go into suspend at all? If there is an event queued then
something is woken up and got running, which is reason enough _not_ to
enter suspend. If that's broken in the current implementation then we
need to fix it, but not with a big hammer by adding another
interface. We have that information already and obviously we do not
use it, so lets figure out why before adding suspend blockers just
because they paper over the underlying problem.

Thanks,

	tglx
