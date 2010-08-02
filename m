Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab0HBOKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 10:10:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56263 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109Ab0HBOKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 10:10:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: Attempted summary of suspend-blockers LKML thread
Date: Mon, 2 Aug 2010 16:08:57 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>, paulmck@linux.vnet.ibm.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, stern@rowland.harvard.edu, swetland@google.com,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
References: <20100731175841.GA9367@linux.vnet.ibm.com> <20100801210548.23f77ff6@infradead.org> <20100802122726.GA6247@thunk.org>
In-Reply-To: <20100802122726.GA6247@thunk.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008021608.57483.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 02, 2010, Ted Ts'o wrote:
> On Sun, Aug 01, 2010 at 09:05:48PM -0700, Arjan van de Ven wrote:
> > I'm a little worried that this whole "I need to block suspend" is
> > temporary. Yes today there is silicon from ARM and Intel where suspend
> > is a heavy operation, yet at the same time it's not all THAT heavy
> > anymore.... 
> 
> Part of the problem here may also be a naming problem.  There are
> multiple reasons why you might want to block suspend, and it goes far
> beyond what the CPU can do.
> 
> Let's give another example, from the laptop world.  If you close the
> the MacBook, it "suspends".  That is, all processes stop, and the CPU
> enters a sleep state.  Sounds just like Linux's suspend-to-ram, right?
> 
> Except for the fact that if you insert a USB cable connected to a
> iPod/iPad/iPhone, the CPU wakes up, and iTunes will do a sync, and
> then the machine goes back to sleep.  And if the Mail application is
> in the middle of manipulating the IMAP mailbox, it will be allowed to
> finish what it is doing, and then the system goes to sleep.

I _think_ you can implement that with the current kernel's interfaces and
an suitable power manager in user space.  At least you should be.

The question really boils down to where the "power manager" activity should be
located.  Should it be in the kernel or in user space?  Or is it better to have
a "collective power manager", like in the wakelocks case?  Moreover, what
should the power manager be responsible for and what the kernel's role should
be in deciding what "power" state to go into?

> So in the case of both the MacBook, where the user has closed the
> laptop, and in the case of Cell Phone, where the user has pushed the
> button saying he/she's done working with the application, the _normal_
> thing to do force all processes to go to sleep, and then let the CPU
> go to sleep.
> 
> But, you may have applications that are specially privileged so they
> can ignore the user command to suspend the machine.

I frankly don't think it's legitimate to overrule the user.  If the user tells
us "suspend" and specifies a set of devices that can be used for wakeup, we
should follow, possibly monitoring the wakeup devices for events.

However, that doesn't apply 100% to the cell phone case, because on cell phones
the software is actually owned by the device vendor and/or the network operator
and they may want to have a mechanism to overrule the person using the phone.
That is a more general issue, though.

> Maybe it's an iTunes-like situation, where in response to some hardware
> interrupt, it's allowed to wake up, do its thing, and then go back to sleep,
> allowing the hardware to go back to sleep.  Maybe it's a mail
> application that wants to wakeup every 15 minutes, suck down any new
> mail, and then go back to sleep.  The suspend blocker is a way to
> achieve this --- and this has nothing to do with chip technology, but
> with a specific use case.

Assuming that your "power manager activity" will be a collective one, along the
Android lines.  Still, in principle, you can obtain a functionally equivalent
behavior with the help of a power manager in user space.

Thanks,
Rafael
