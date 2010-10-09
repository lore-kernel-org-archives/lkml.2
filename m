Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760320Ab0JIRii (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 13:38:38 -0400
Received: from relais.videotron.ca ([24.201.245.36]:44919 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab0JIRih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 13:38:37 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_k+7L/PAjSoMoNI8BkkaQeA)"
Date: Sat, 09 Oct 2010 13:38:33 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Greg KH <greg@kroah.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
In-reply-to: <AANLkTi=BvXROFEnzYykoUQNbU05Q=mWoV3t7qKDk7+vL@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1010091125190.20826@xanadu.home>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
 <20101007192245.GC26435@n2100.arm.linux.org.uk>
 <AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
 <20101008175308.GA10975@n2100.arm.linux.org.uk>
 <20101008231926.GA28235@kroah.com>
 <alpine.LFD.2.00.1010082242390.3107@xanadu.home>
 <AANLkTi=BvXROFEnzYykoUQNbU05Q=mWoV3t7qKDk7+vL@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Content-id: <alpine.LFD.2.00.1010091317180.21129@xanadu.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_k+7L/PAjSoMoNI8BkkaQeA)
Content-id: <alpine.LFD.2.00.1010091317181.21129@xanadu.home>
Content-type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-transfer-encoding: 8BIT

On Sat, 9 Oct 2010, Felipe Contreras wrote:

> On Sat, Oct 9, 2010 at 6:36 AM, Nicolas Pitre <nico@fluxnic.net> wrote:
> > On Fri, 8 Oct 2010, Greg KH wrote:
> >> Wait, let me get this straight:
> >>   - drivers used to work on 2.6.35
> >
> > Possibly on pre ARMv6 only.  On ARMv6 and above, the discussed behavior
> > _never_ worked.  It is fundamental to the CPU design.
> 
> That's not true, drivers on ARMv6 and above do work.

So you want to fool yourself?  Fine.  This is your problem.

> I still wonder how exactly to trigger the issue, and how often does 
> this happen, because I've never seen it.

It's not because you don't see it right away that this is not happening.

> I trust the experts that it is an issue, but I don't agree that
> drivers that are currently working on ARMv6+ should be broken on
> purpose right away.

They are not working *reliably*.  Get that notion out of your mind.

> >>   - some ARM core code changed in .36-rc to fix this iomem problem that
> >>     you found
> >
> > Nothing was fixed.  There is nothing to fix.  Simply that a wrong driver
> > assumption about the hardware capability was prohibited by the API.
> 
> Not exactly. There is supposedly a problem on ARMv6+, there must be a
> mechanism to avoid this problem, all drivers should migrate to that,
> or a different on, so that we have a sane API.

Exact.  So please put the necessary effort to 1) understand the issue 
which was clearly explained in details by RMK already, or simply read 
the ARM Architecture Reference Manual for yourself, so that you 
understand the issue and stop asking for unreasonable things, and 2) do 
invest some time to fix your code that never worked properly in the 
first place.

> > There is no API change.  Simply an API misuse.  Granted, on pre ARMv6
> > this usage used to work, but on ARMv6 and above this never was supported
> > at all by the hardware.  The fact that the software has let it through
> > was a gross mistake, period.
> 
> No. It worked just fine, now it's doesn't, that's a change in API
> behavior, which is also part of the API. It might not be ideal, or
> proper, but it does work.

Look, if you can't be brought to reason and common sense this will be my 
last reply to you.

What would you say if someone suggested to turn the spinlocks into 
no-ops in a SMP kernel with full preemption configured in?  Let's say 
that person has done that because the lock validator was complaining and 
removing the locks made the warnings as well as the deadlock go away?  
And that person is claiming that the driver now works just fine (or 
appears to work) and no issue what so ever has been observed?  Because 
that's exactly what you're asking for right now.  Except that in this 
case you are willing to ignore a hardware race instead of a software 
one.

> >>   - drivers break when run as the api stops returning valid addresses
> >
> > Such drivers on ARMv6 should *never* have worked in the first place.
> > When they did "work", they corrupted memory.
> 
> They corrupted their own memory, right? And on _very_ rare occasions I
> presume, since I've never seen it.

Not their own memory, but *ANY* random memory.  You could corrupt your 
filesystem, have bugs in totally unrelated drivers, and so in ways that 
are totally unpredictable and unreproducible.  Is that the kind of 
system you want to debug?  If you have customers, is that the kind of 
products you want to sell them?

> If so, there's no damage in letting
> them work at least one more release (2.6.36).

On what basis can you dare make such a foolish claim?  Only on your 
limited testing and own observations?  Do you have some insider 
knowledge of the ARM architecture that would give us confidence in 
ignoring written documentation about this very issue?  What about those 
people besides you who did experience problems before?

If you want that, then do it in your own tree, oh and let me remember to 
ignore any future request for help from you.  But the mainline tree has 
to be proper regardless of the inconvenience that may cause you, 
_especially_ when data integrity is at stake.

> >>   - no known way is around to fix the broken drivers
> >
> > That's B/s.  As Russell said, there are known solutions that were
> > proposed at least six months ago.
> 
> You seriously think most people out there know how to "set aside some
> RAM at boot time"?

Indeed I do.  That is not rocket science.  You can easily figure it 
yourself too.

> I don't, otherwise the drivers would be fixed by now.

And that's why you want me to accept your argument for restoring a 
broken behavior?

Go do your homework and fix your code.


Nicolas

--Boundary_(ID_k+7L/PAjSoMoNI8BkkaQeA)--
