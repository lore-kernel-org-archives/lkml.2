Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248Ab0JIDgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 23:36:13 -0400
Received: from relais.videotron.ca ([24.201.245.36]:32426 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760211Ab0JIDgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 23:36:12 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 08 Oct 2010 23:36:11 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Greg KH <greg@kroah.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
In-reply-to: <20101008231926.GA28235@kroah.com>
Message-id: <alpine.LFD.2.00.1010082242390.3107@xanadu.home>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
 <20101007192245.GC26435@n2100.arm.linux.org.uk>
 <AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
 <20101008175308.GA10975@n2100.arm.linux.org.uk>
 <20101008231926.GA28235@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Oct 2010, Greg KH wrote:

> On Fri, Oct 08, 2010 at 06:53:08PM +0100, Russell King - ARM Linux wrote:
> > On Fri, Oct 08, 2010 at 12:32:35PM +0300, Felipe Contreras wrote:
> > > I think when _you_ remove functionality from the architecture, you
> > > should provide a mechanism that drivers can migrate to. Since there's
> > > nothing like that, not even a guideline, you are breaking the drivers
> > > willingly, and expecting other people to fix a difficult problem that
> > > you yourself have no idea how to fix properly.
> > 
> > We can either wait for people to complain about silent data corruption
> > or we can be compliant with the architecture specification.  Which is
> > better - to avoid data corruption and be correct, or allow a system to
> > become flakey and corrupt people's data.
> > 
> > What I care about is system correctness and people's data - having
> > multiple mappings with different attributes is documented in very clear
> > terms as being 'unpredictable' and therefore it isn't permissible to
> > allow the practice that worked with previous processors (inherently
> > due to their cache architecture) to continue forward onto processors
> > with a different cache architecture.
> > 
> > As already discussed, it's nigh on impossible to unmap the existing
> > direct mapped region (read the previous discussions about why this is)
> > - which is precisely why there is no direct alternative solution.
> 
> Wait, let me get this straight:
>   - drivers used to work on 2.6.35

Possibly on pre ARMv6 only.  On ARMv6 and above, the discussed behavior 
_never_ worked.  It is fundamental to the CPU design.

>   - some ARM core code changed in .36-rc to fix this iomem problem that
>     you found

Nothing was fixed.  There is nothing to fix.  Simply that a wrong driver 
assumption about the hardware capability was prohibited by the API.

>   - no drivers are notified of the api change as it's a run-time change,
>     so the build doesn't break.

There is no API change.  Simply an API misuse.  Granted, on pre ARMv6 
this usage used to work, but on ARMv6 and above this never was supported 
at all by the hardware.  The fact that the software has let it through 
was a gross mistake, period.

>   - drivers break when run as the api stops returning valid addresses

Such drivers on ARMv6 should *never* have worked in the first place.  
When they did "work", they corrupted memory.

>   - no known way is around to fix the broken drivers

That's B/s.  As Russell said, there are known solutions that were 
proposed at least six months ago.

> Um, this doesn't sound like a valid thing to be doing,

Excuse me, but preventing data corruption is a damn valid thing to do.  
The real problem is that people kept on abusing the API for something 
that the hardware simply can't support, and the mere fact that things 
_appears_ to just work by accident in 98% of the cases encourage people 
to simply put their head in the sand and ignore the issue.  Sorry folks, 
but that's not how computing works.  We're not amateurs for damn sake, 
and when the ARM bible says this operation is UNSUPPORTED, it is 
UNSUPPORTED.  Seeing people trying to fsck around the issue because of 
laziness is revolting!

> how do you expect
> people to fix their code if they:
> 	- don't realize it as the api change doesn't break the build

The API should have complained the very first time they attempted the 
operation in question.  It should never have worked.  I'm sorry but the 
mere fact that the broken driver didn't receive an error before is no 
excuse to *knowingly* let memory corruption go on.

> 	- there is no way to fix their code

Wrong.  See above.

> This sounds like a huge regression that should be reverted, or am I
> missing something here?

I'm afraid you are totally missing the point.

The patch Russell introduced simply prevented an abuse of the API for 
which there are documented evidences that such abuse is a source of 
memory corruption.  This must not be allowed any longer, not even for a 
warning period.  There is no regression what so ever as those driver 
were always broken.  And I much prefer to have brokenness in the form of 
driver initialization error rather than silent and random memory 
corruptions.

So folks please get real and understand that Russell was right.

The only compromise that may be made is to allow the API abuse on pre 
ARMv6 implementations where this has no adverse effect, which is the 
patch I just posted.  Granted, on pre ARMv6, the ioremap of system RAM 
was fine and people legitimately relied on it in their drivers.  But 
this just can't be allowed anymore on ARMv6.


Nicolas
