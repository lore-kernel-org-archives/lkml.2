Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab0FUPGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 11:06:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35449 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932343Ab0FUPGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 11:06:31 -0400
Date: Mon, 21 Jun 2010 11:06:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Florian Mickler <florian@mickler.org>, <markgross@thegnar.org>,
       mark gross <640e9920@gmail.com>, Neil Brown <neilb@suse.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Avoid losing wakeup events during
 suspend
In-Reply-To: <799617.66764.qm@web180304.mail.gq1.yahoo.com>
Message-ID: <Pine.LNX.4.44L0.1006211055090.1687-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jun 2010, David Brownell wrote:

> Can we put this more directly:  the problem is
> that the *SYSTEM ISN'T FULLY SUSPENDED* when the
> hardware wake event triggers?  (Where "*SYSTEM*
> includes userspace not just kernel.  In fact the
> overall system is built from many subsystems,
> some in the kernel and some in userspace.

Indeed, the system may not even be partially suspended when the wake 
event triggers.

> At the risk of being prematurely general:  I'd
> point out that these subsystems probably have
> sequencing requirements.  kernel-then-user is
> a degenerate case, and surely oversimplified.
> There are other examples, e.g. between kernel
> subsystems...  Like needing to suspend a PMIC
> before the bus it uses, where that bus uses
> a task to manage request/response protocols.
> (Think I2C or SPI.)
> 
> This is like the __init/__exit sequencing mess...
> 
> In terms of userspace event delivery, I'd say
> it's a bug in the event mechanism if taking the
> next step in suspension drops any event.  It
> should be queued, not lost...  As a rule the
> hardware queuing works (transparently)...

There may be a misunderstanding here...  People talk about events
getting lost, but what they (usually) mean is that the event isn't
actually _dropped_ -- rather, it fails to trigger a wakeup or to
prevent a suspend.  When something else causes the system to resume
later on, the event will be delivered normally.

This means that the problem is not one of sequencing.  The problem is 
twofold:

	To recognize when a wakeup event has occurred and therefore
	it is not now safe to allow the system to suspend;

	And to recognize when a wakeup event has been completely
	handled and therefore it is once again safe to allow the system 
	to suspend.

> > Of course, the underlying
> > > > issue here is that the kernel has no direct way
> > to know when userspace
> > > > has finished processing an event.
> 
> 
> Again said more directly:  there's no current
> mechanism to coordinate subsystems.  Userspace
> can't communicate "I'm ready" to kernel, and
> vice versa.  (a few decades ago, APM could do
> that ... we dropped such mechanisms though, and
> I'm fairly sure APM's implementation was holey.)

Yes, that's a better way of putting it.  And it's not just a matter of
"userspace communicating with the kernel", because userspace is not
monolithic.  There has to be a way for one user process to communicate
this information to another (I like Florian's idea).  Of course, the
kernel doesn't have to worry about those details.

If one accepts a scheme in which all the suspend initiations and
cancellations are carried out by a single process (a power-manager
process), then the difficulties of communication and coordination
between the kernel and userspace are minimized.

Alan Stern

