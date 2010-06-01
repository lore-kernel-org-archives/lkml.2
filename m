Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab0FAAbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 20:31:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36076 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab0FAAbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 20:31:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Neil Brown <neilb@suse.de>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Tue, 1 Jun 2010 02:32:20 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <Pine.LNX.4.44L0.1005271303190.3239-100000@iolanthe.rowland.org> <201006010005.19554.rjw@sisk.pl> <20100601090023.788cabf4@notabene.brown>
In-Reply-To: <20100601090023.788cabf4@notabene.brown>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006010232.20263.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 June 2010, Neil Brown wrote:
> On Tue, 1 Jun 2010 00:05:19 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Monday 31 May 2010, Neil Brown wrote:
> > > On Thu, 27 May 2010 23:40:29 +0200 (CEST)
> > > Thomas Gleixner <tglx@linutronix.de> wrote:
> > > 
> > > > On Thu, 27 May 2010, Rafael J. Wysocki wrote:
> > > > 
> > > > > On Thursday 27 May 2010, Thomas Gleixner wrote:
> > > > > > On Thu, 27 May 2010, Alan Stern wrote:
> > > > > > 
> > > > > > > On Thu, 27 May 2010, Felipe Balbi wrote:
> > > > > > > 
> > > > > > > > On Thu, May 27, 2010 at 05:06:23PM +0200, ext Alan Stern wrote:
> > > > > > > > >If people don't mind, here is a greatly simplified summary of the
> > > > > > > > >comments and objections I have seen so far on this thread:
> > > > > > > > >
> > > > > > > > >	The in-kernel suspend blocker implementation is okay, even
> > > > > > > > >	beneficial.
> > > > > > > > 
> > > > > > > > I disagree here. I believe expressing that as QoS is much better. Let 
> > > > > > > > the kernel decide which power state is better as long as I can say I 
> > > > > > > > need 100us IRQ latency or 100ms wakeup latency.
> > > > > > > 
> > > > > > > Does this mean you believe "echo mem >/sys/power/state" is bad and
> > > > > > > should be removed?  Or "echo disk >/sys/power/state"?  They pay no
> > > > > > 
> > > > > > mem should be replaced by an idle suspend to ram mechanism
> > > > > 
> > > > > Well, what about when I want the machine to suspend _regardless_ of whether
> > > > > or not it's idle at the moment?  That actually happens quite often to me. :-)
> > > > 
> > > > Fair enough. Let's agree on a non ambigous terminology then:
> > > > 
> > > >      forced:
> > > > 
> > > > 	     suspend which you enforce via user interaction, which
> > > >      	     also implies that you risk losing wakeups depending on
> > > >      	     the hardware properties
> > > 
> > > Reasonable definition I think.  However the current implementation doesn't
> > > exactly match it.
> > > With the current implementation you risk losing wakeups *independent* of the
> > > hardware properties.
> > 
> > Define "losing", please.
> 
> I did.  See next line in my original.
>  "... by which I mean that they will not be seen until some other event
>  effects a wake-up".

OK, sorry.

>  By "seen" I mean "a user-space process has had a chance
>  to react to the event, including having the opportunity to abort the suspend
>  (or ensure an immediate wake-up)".
> Another way of saying it might be that the event - as an abstract concept -
> does not reach it's final destination promptly.  This "final destination" may
> be well outside the kernel.
>
> > Currently, we simply don't regard hardware signals occuring _during_ the
> > suspend operation itself as wakeups (unless they are wakeup interrupts to be
> > precise, because these _are_ taken into account by our current code).
> > 
> > The reason is that the meaning of given event may be _different_ at run time
> > and after the system has been suspended.  For example, consider a power button
> > on a PC box.  If it's pressed at run time, it usually means "power off the
> > system" to the kernel.  After the system has been suspended, however, it means
> > "wake up".  So, you have to switch from one interpretation of the event to the
> > other and that's not an atomic operaition (to put it lightly).
> 
> Yes, a suspend-toggle switch is inherently racy.

For this reason we generally have to assume that some events occuring during
suspend will only be seen by user space after resume.  Now, since we make
such an assumption anyway, there's a little point working around some races
related to it while leaving the others as they are (that wouldn't improve
things all that much).

> It is only wake-up sources that are not inherently racy that are interesting.
> e.g. a serial line from a GSM device which reports "You have an SMS message".
> I want to be able to turn my freerunner upside-down by which I tell it (via
> the accelerometers) that I am done and want it to turn off.  If a TXT message
> comes in just then, I don't want it to suspend, I want it to make an alert
> noise.
> I can put code in to ignore the accelerometer if a txt has just recently come
> in, but if the TXT arrives just as the write to /sys/power/state starts, the
> UART interrupt handler could have completed before it has the PRE_SUSPEND
> method called.  So the suspend will complete and the wakeup from the UART
> will have been "lost" in that the event didn't get all the way to its
> destination: my ear.

As I said before, we generally can't prevent such things from happening,
because even if we handle the particular race described above, it still is
possible that the event will be "lost" if it arrives just a bit later (eg.
during a suspend-toggle switch).  So the PRE_SUSPEND thing won't really
solve the entire problem while increasing complexity.

> My freerunner has a single core so without CONFIG_PREEMPT it may be that
> there is no actual race-window - maybe the PRE_SUSPENDs will all run before a
> soft_irq thread has a chance to finish handling of the interrupt (my
> knowledge of these details is limits).  But on a muilti-core device I think
> there would definitely be a race-window.

Yes, there always will be a race window.  The only thing we can do is to
narrow it, but we cannot really close it (at least not on a PC, but I'm not
really sure it can be closed at all).

If you really want _all_ events to be delivered timely, the only way to go is
to avoid using suspend (and use the idle framework for power management).

Thanks,
Rafael
