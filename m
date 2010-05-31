Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab0EaXAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 19:00:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:33611 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab0EaXAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 19:00:37 -0400
Date: Tue, 1 Jun 2010 09:00:23 +1000
From: Neil Brown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100601090023.788cabf4@notabene.brown>
In-Reply-To: <201006010005.19554.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1005271303190.3239-100000@iolanthe.rowland.org>
	<alpine.LFD.2.00.1005272334040.3478@localhost.localdomain>
	<20100531143339.249ae1f4@notabene.brown>
	<201006010005.19554.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010 00:05:19 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday 31 May 2010, Neil Brown wrote:
> > On Thu, 27 May 2010 23:40:29 +0200 (CEST)
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > On Thu, 27 May 2010, Rafael J. Wysocki wrote:
> > > 
> > > > On Thursday 27 May 2010, Thomas Gleixner wrote:
> > > > > On Thu, 27 May 2010, Alan Stern wrote:
> > > > > 
> > > > > > On Thu, 27 May 2010, Felipe Balbi wrote:
> > > > > > 
> > > > > > > On Thu, May 27, 2010 at 05:06:23PM +0200, ext Alan Stern wrote:
> > > > > > > >If people don't mind, here is a greatly simplified summary of the
> > > > > > > >comments and objections I have seen so far on this thread:
> > > > > > > >
> > > > > > > >	The in-kernel suspend blocker implementation is okay, even
> > > > > > > >	beneficial.
> > > > > > > 
> > > > > > > I disagree here. I believe expressing that as QoS is much better. Let 
> > > > > > > the kernel decide which power state is better as long as I can say I 
> > > > > > > need 100us IRQ latency or 100ms wakeup latency.
> > > > > > 
> > > > > > Does this mean you believe "echo mem >/sys/power/state" is bad and
> > > > > > should be removed?  Or "echo disk >/sys/power/state"?  They pay no
> > > > > 
> > > > > mem should be replaced by an idle suspend to ram mechanism
> > > > 
> > > > Well, what about when I want the machine to suspend _regardless_ of whether
> > > > or not it's idle at the moment?  That actually happens quite often to me. :-)
> > > 
> > > Fair enough. Let's agree on a non ambigous terminology then:
> > > 
> > >      forced:
> > > 
> > > 	     suspend which you enforce via user interaction, which
> > >      	     also implies that you risk losing wakeups depending on
> > >      	     the hardware properties
> > 
> > Reasonable definition I think.  However the current implementation doesn't
> > exactly match it.
> > With the current implementation you risk losing wakeups *independent* of the
> > hardware properties.
> 
> Define "losing", please.

I did.  See next line in my original.
 "... by which I mean that they will not be seen until some other event
 effects a wake-up".  By "seen" I mean "a user-space process has had a chance
 to react to the event, including having the opportunity to abort the suspend
 (or ensure an immediate wake-up)".
Another way of saying it might be that the event - as an abstract concept -
does not reach it's final destination promptly.  This "final destination" may
be well outside the kernel.

> 
> Currently, we simply don't regard hardware signals occuring _during_ the
> suspend operation itself as wakeups (unless they are wakeup interrupts to be
> precise, because these _are_ taken into account by our current code).
> 
> The reason is that the meaning of given event may be _different_ at run time
> and after the system has been suspended.  For example, consider a power button
> on a PC box.  If it's pressed at run time, it usually means "power off the
> system" to the kernel.  After the system has been suspended, however, it means
> "wake up".  So, you have to switch from one interpretation of the event to the
> other and that's not an atomic operaition (to put it lightly).

Yes, a suspend-toggle switch is inherently racy.  It is only wake-up sources
that are not inherently racy that are interesting.  e.g. a serial line from a
GSM device which reports "You have an SMS message".
I want to be able to turn my freerunner upside-down by which I tell it (via
the accelerometers) that I am done and want it to turn off.  If a TXT message
comes in just then, I don't want it to suspend, I want it to make an alert
noise.
I can put code in to ignore the accelerometer if a txt has just recently come
in, but if the TXT arrives just as the write to /sys/power/state starts, the
UART interrupt handler could have completed before it has the PRE_SUSPEND
method called.  So the suspend will complete and the wakeup from the UART
will have been "lost" in that the event didn't get all the way to its
destination: my ear.
My freerunner has a single core so without CONFIG_PREEMPT it may be that
there is no actual race-window - maybe the PRE_SUSPENDs will all run before a
soft_irq thread has a chance to finish handling of the interrupt (my
knowledge of these details is limits).  But on a muilti-core device I think
there would definitely be a race-window.

Thanks,
NeilBrown

> 
> > Even with ideal hardware events can be lost - by which I mean that they will
> > not be seen until some other event effects a wake-up.
> > e.g. the interrupt which signals the event happens immediately before the
> > suspend is requested (or maybe at the same time as), but the process which
> > needs to handle the event doesn't get a chance to see it before the suspend
> > procedure freezes that process, and even if it did it would have no way to
> > abort the suspend.
> > 
> > So I submit that the current implementation doesn't match your description of
> > "forced", is therefore buggy, and that if it were fixed, that would be
> > sufficient to meet the immediate needs of android.
> 
> I don't really think it may be fixed with respect to every possible kind of
> hardware.  On platforms where I/O interrupts are wakeup events it should
> work right now.  On other platforms it may be impossible to overcome hardware
> limitations.
> 
> Thanks,
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

