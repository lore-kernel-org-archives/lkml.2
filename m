Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab1KGUyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:54:07 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55290 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754849Ab1KGUyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:54:00 -0500
Date: Mon, 7 Nov 2011 15:53:59 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Tim Vlaar <Tvlaar@ptgrey.com>, Greg KH <greg@kroah.com>,
        Markus Rechberger <mrechberger@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
In-Reply-To: <20111107201812.GA12822@xanatos>
Message-ID: <Pine.LNX.4.44L0.1111071537170.2004-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Nov 2011, Sarah Sharp wrote:

> > > Alan, won't this global limit on the usbfs URB buffer size effect
> > > userspace drivers that are currently allocating large amounts of
> > > buffers, but still respecting individual buffer limit of 16KB?  It seems
> > > like the patch has the potential to break userspace drivers.
> > 
> > It might indeed.  A further enhancement would replace that 16-MB global
> > constant with a sysfs attribute (a writable module parameter for
> > usbcore).  Do you have any better suggestions?
> 
> No, I don't have any better suggestions, except take out the limit. ;)
> 
> I do understand why we don't want userspace to DoS the system by using
> up too much DMA'able memory.  However, as I understand it, the usbfs
> files are created by udev with root access only by default, and distros
> may choose to install rules that have more permissive privileges.  A
> device vendor may not be ensured that a udev rule with permissive access
> will be present for their device, so I think they're likely to write
> programs that require root access.  Or require root privileges to
> install said udev rule.
> 
> At that point, the same userspace program that has root privileges in
> order to access usbfs or create the udev rule can just load and unload
> the usbcore module with an arbitrarily large global limit, and the
> global limit doesn't really add any security.  So why add the extra
> barrier?

This is a question of kernel policy, and I don't know what is the
generally accepted approach to this sort of thing.  Maybe Greg or Alan
Cox can comment.


> > > I think that Point Grey's USB 3.0 webcam will be attempting to queue a
> > > series of bulk URBs that will be bigger than your 16MB global limit.
> > 
> > For SuperSpeed, 16 MB is rather on the low side.  For high speed it
> > amounts to about 1/3-second worth of data, which arguably is also a bit
> > low.  Increasing the default is easy enough, but the best choice isn't
> > obvious.
> 
> Yeah, the choice is not obvious and we're probably going to get it
> wrong, but as Tim said, he does need ~600MB in flight at once, so I knew
> 16MB was too small.  I guess the question really should be not "What is
> the smallest limit we need?" but "When will the system start breaking
> down due to memory pressure?" and set the limit somewhere pretty close
> to there.

It might not be so easy to identify that value.  I wouldn't know how to
do it.

> Do other subsystems have these issues as well?  Does the layer SCSI ever
> limit the number of outstanding READ requests (aside from hardware
> limitations)?

Not as far as I know.  Perhaps the block layer tries to slow things 
down if too many I/O operations are pending (or maybe not -- I'm not 
at all familiar with the details), but that's different from returning 
an error.

>  Or does the networking layer have a limit to the buffers
> it keeps pending transfers for userspace to read?

Again, I don't know.  Those subsystems are a lot more complicated than
usbfs, and they probably have arrangements to allocate intermediate
buffers a piece at a time.  We could do something like that, but the
end result would be the same as our current limit on URB sizes -- the
only difference being that transfers would be split into multiple URBs
by the usbfs driver instead of by the user program.

In fact, it's not all that easy for a program to generate many I/O 
requests concurrently.  The old async I/O mechanism is one way, and you 
spent a lot of time working on it.  Do you remember if it had any 
limits?

Alan Stern

