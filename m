Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab1JYEu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 00:50:56 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46225 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab1JYEuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 00:50:55 -0400
Date: Mon, 24 Oct 2011 21:50:46 -0700
From: mark gross <markgross@thegnar.org>
To: NeilBrown <neilb@suse.de>
Cc: markgross@thegnar.org, Alan Stern <stern@rowland.harvard.edu>,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        amit.kucheria@linaro.org, farrowg@sg.ibm.com,
        "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com, peterz@infradead.org
Subject: Re: [markgross@thengar.org: [RFC] wake up notifications and suspend
 blocking (aka more wakelock stuff)]
Message-ID: <20111025045046.GA8383@mgross-G62>
Reply-To: markgross@thegnar.org
References: <20111016092556.07d6e415@notabene.brown>
 <Pine.LNX.4.44L0.1110152136460.19724-100000@netrider.rowland.org>
 <20111017083717.0bd5626c@notabene.brown>
 <20111024011804.GB12215@mgross-G62>
 <20111024125034.71993780@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024125034.71993780@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 12:50:34PM +1100, NeilBrown wrote:
> On Sun, 23 Oct 2011 18:18:04 -0700 mark gross <markgross@thegnar.org> wrote:
> 
> > Sorry for going AWOL on this thread.  I had some biz travel and fires to
> > fight.
> 
> :-)  Life happens.  Welcome back.
> 
> 
> > > So it is a good example and highlights the difficulty of defining exactly
> > > what a wake-up event it, and of what it means to be "visible".
> > > 
> > > I think it still fits in your rephrasing of my question which - if I rephrase
> > > it as a requirement - is roughly,
> > > 
> > >   A wakeup-event that needs to be handled by user-space must be visible to
> > >   user-space before the driver deactivates the wakeup_source.
> > > 
> > > A requirement which, in this case, means the driver needs to hold  the
> > > wakeup_source for an extended time using a timeout, just as you say.
> > 
> > Timeout?  why can't we define a proper notification handshake for such
> > things?  Timeouts are never right IMO.
> > 
> 
> I thought that before, but I have come around to the opposite way of thinking
> thanks to some instructive examples from Alan and Rafael.
> 
> Some things are simply not visible to the OS.  We can expect them to be
> happening but we cannot be sure and there is no clear signal that they aren't
> actually happening.  So we need a timeout.

um

> 
> - OS cannot detect state of user's brain, so uses a time-out to blank the
>   screen after a period of inactivity.
true, but user interaction has not been part of this discussion.  The
ability of usermode code to offer user interaction has.

> - USB cannot (I think) know which USB device triggered a wake-from-suspend,
>   and in any case cannot directly ask the device why it woke from suspend.
>   It has to wait for the device to tell it (in response to a regular
>   'interrupt' poll I assume - but it isn't guaranteed to be reported on the
>   first poll) - or timeout and give up waiting.
maybe if you are unwilling to change the user mode stack that is reading
these events.  But if you where they you shouldn't need time outs.

> - A wake-on-Lan packet may wake a suspend up, but not be further visible to
>   the OS.  And even if it was, the 'SYN' packet or maybe 'ARP' packet that
>   might be expected to follow it is invisible until it actually arrives, and
>   it may not ever come.  So we need a timeout to give up waiting after a
>   while.
A time out here is just an optimization to avoid re-waking too often.

> 
> When-ever we are dealing with external events we need timeouts - and
> wake-from-suspend is primarily about external events.

This is going too far.   I see wakes up as very analogous to interrupt
devices.  We have interrupts no one seem to care about, and we tend to
have devices that don't time out waiting for an ACK from the OS, where
the OS needs to have a timeout for the latency of IRQ handling. 


> So *somewhere* in the handling of wakeup events there must be timeouts.
> Whether that should be explicit in the wakeup-source is possibly a separate
> question.  Maybe you could argue that the low level device driver must have
> timeouts anyway, so it should use them to explicitly deactivate the source
> rather than the source having it's own timeout.
> I'm not sure that argument would work though it might.
> But saying "Timeouts are never right" cannot work - unless you mean it in a
> much more restricted sense than I think you mean it.

I think they are never right.  But, accept that they are useful for some
case.  i.e. I think having them and using them is a hack to avoid
changing legacy programs dependent on the input subsystem where USB wake
events is a boundary case like the USB or optimizations as in the wake
on lan example. 

It should be possible to implement a system (if you are willing to do
the work) that is correct without timeouts.

> (I can agree that it is *best* if timeouts never fire - if direct action
> causes the wakeup-source to deactivate long before the timeout.  I agree that
> is the best case and probably should be the common case, but I cannot see how
> it can be the only case).

well I still maintain that as a practical matter whatever time out value
chosen is wrong for someone, in some way.  I can't stress this point
enough.  I really worry about *possibility* of correctness whenever a
time out is considered as part of an API.

Time outs may be needed but, I don't think they should be part of the
core API's other than seldom used special needs API for the occasional
corner case.

--mark

