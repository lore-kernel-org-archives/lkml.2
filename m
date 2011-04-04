Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab1DDOt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 10:49:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59111 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab1DDOt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 10:49:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [RFC PATCH 00/21] IIO: Channel registration rework, buffer chardev combining and rewrite of triggers as 'virtual' irq_chips.
Date: Mon, 4 Apr 2011 16:49:24 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: michael.hennerich@analog.com,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk> <4D99B34B.9050309@analog.com> <4D99C4D7.1010706@cam.ac.uk>
In-Reply-To: <4D99C4D7.1010706@cam.ac.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104041649.24309.arnd@arndb.de>
X-Provags-ID: V02:K0:j4vPTXUp7AWp7fbZE2jcfatm7JLbJb6Y35stD+u9KuU
 GOczQ5hRDzoQsjHzSJIUwHVN87yANCOC6eUvFdY+wKOPH5i/XF
 Cor7I3+hGRcusn1rNiVAvOu3vhNCUji92UhE6rn/wNW3vCj2Fy
 I2artEtoiQPOzYKtX0GABWwTerXPOt9GKIA0PQRSLTxwXAjfMA
 tyogNGNRHmneU1voynmDA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 April 2011, Jonathan Cameron wrote:
> On 04/04/11 13:02, Michael Hennerich wrote:
> >> 2) Flattening together of (some) of the chardevs (buffer related ones).
> >>    As Arnd pointed out, there is really a use case for having multiple
> >>    watershed type events from ring buffers.  Much better to have a
> >>    single one (be that at a controllable point).  Firstly this removes
> >>    the need for the event escalation code.  Second, this single 'event'
> >>    can then be indicated to user space purely using polling on the
> >>    access chrdev.  This approach does need an additional attribute to
> >>    tell user space what the poll succeeding indicates (tbd).
> >>
> >>    I haven't for now merged the ring handling with the more general
> >>    event handling as Arnd suggested.  This is for two reasons
> >>    1) It's much easier to debug this done in a couple of steps
> >>    2) The approach Arnd suggested may work well, but it is rather
> >>    different to how other bits of the kernel pass event type data
> >>    to user space.  It's an interesting idea, but I'd rather any
> >>    discussion of that approach was separate from the obviously
> >>    big gains seen here.
> >>
> >>    Patches 4, 5, 6, 7, 17
> >>   
> > I appreciate the removal of the buffer event chardev. Adding support for
> > poll is also a good thing to do.
> > However support for a blocking read might also fit some use cases.
> Good point. I guess blocking on any content and poll for the watershead
> gives the best of both worlds.  The blocking read is more down to the
> individual implementations than a core feature though - so one to do
> after this patch set.

You should implement both blocking and non-blocking read in the core, IMO.
This is how pipes generally work and what the opn()/read() man pages say it
works.

> >> 3) Reworking the triggering infrastructure to use 'virtual' irq_chips
> >>    This approach was suggested by Thomas Gleixner.
> >>    Before we had explicit trigger consumer lists.  This made for a very
> >>    clunky implementation when we considered moving things over to
> >>    threaded interrupts.  Thomas pointed out we were reinventing the
> >>    wheel and suggested more or less what we have here (I hope ;)
> >>   
> > Using threaded interrupts, greatly reduces use of additional workqueues
> > and excessive interrupt enable and disables.
> There is a nasty side issue here.  What do we do if we are getting triggers
> faster than all of the consumers can work at?  Right now things tend to
> stall.  I think we just want to gracefully stop the relevant trigger
> if this happens.  I'm not quite sure how we can notify userspace that this
> has happened... Perhaps POLLERR? 

I'd say use POLLERR to signal to user space that something bad has happened,
then return the status in an ioctl().

> >>    Patches 9 and 10 are minor rearrangements of code in the one
> >>    driver I know of where the physical interrupt line for events
> >>    is the same as that for data ready signals (though not at the
> >>    same time).
> >>   
> > I wouldn't consider this being a corner case. I know quite a few devices
> > that trigger data availability,
> > and other events from the same physical interrupt line, and they may do
> > it at the same time.
> If they do it at the same time things may get a bit nasty. Things are somewhat
> simpler after some of the later patches, as the irq requests are entirely
> handled in the drivers.  Thus the driver could have one interrupt handler.
> The restriction will be that it would only be able to do nested irq calls
> limiting us to not having a top half for anything triggered from such an
> interrupt. This is because identifying whether we have a dataready or
> other event will require querying the device and hence sleeping. Note
> the sysfs trigger driver will also have this restriction (as posted yesterday).
> 
> For devices where they share the line but cannot happen at the same time I'd
> prefer to do what we have in the lis3l02dq and completely separate the two
> uses of the interrupt line.

Can't you just have callback functions in the core that get called for a
specific event, and let the device driver take care of seperating the
sources?


	Arnd

