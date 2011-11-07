Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1KGXHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 18:07:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:22489 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab1KGXHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 18:07:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,472,1315206000"; 
   d="scan'208";a="82168147"
Date: Mon, 7 Nov 2011 15:07:31 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tim Vlaar <Tvlaar@ptgrey.com>, Greg KH <greg@kroah.com>,
        Markus Rechberger <mrechberger@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-aio@vger.kernel.org
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
Message-ID: <20111107230731.GB13764@xanatos>
References: <20111107201812.GA12822@xanatos>
 <Pine.LNX.4.44L0.1111071537170.2004-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1111071537170.2004-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Question about usbfs and aio limits at the bottom.)

On Mon, Nov 07, 2011 at 03:53:59PM -0500, Alan Stern wrote:
> On Mon, 7 Nov 2011, Sarah Sharp wrote:
> 
> > > > Alan, won't this global limit on the usbfs URB buffer size effect
> > > > userspace drivers that are currently allocating large amounts of
> > > > buffers, but still respecting individual buffer limit of 16KB?  It seems
> > > > like the patch has the potential to break userspace drivers.
> > > 
> > > It might indeed.  A further enhancement would replace that 16-MB global
> > > constant with a sysfs attribute (a writable module parameter for
> > > usbcore).  Do you have any better suggestions?
> > 
> > No, I don't have any better suggestions, except take out the limit. ;)
> > 
> > I do understand why we don't want userspace to DoS the system by using
> > up too much DMA'able memory.  However, as I understand it, the usbfs
> > files are created by udev with root access only by default, and distros
> > may choose to install rules that have more permissive privileges.  A
> > device vendor may not be ensured that a udev rule with permissive access
> > will be present for their device, so I think they're likely to write
> > programs that require root access.  Or require root privileges to
> > install said udev rule.
> > 
> > At that point, the same userspace program that has root privileges in
> > order to access usbfs or create the udev rule can just load and unload
> > the usbcore module with an arbitrarily large global limit, and the
> > global limit doesn't really add any security.  So why add the extra
> > barrier?
> 
> This is a question of kernel policy, and I don't know what is the
> generally accepted approach to this sort of thing.  Maybe Greg or Alan
> Cox can comment.

Ok, after thinking about it, Greg is right that we do need to do
something for the case where any userspace program can write to a usbfs
file.

> > > > I think that Point Grey's USB 3.0 webcam will be attempting to queue a
> > > > series of bulk URBs that will be bigger than your 16MB global limit.
> > > 
> > > For SuperSpeed, 16 MB is rather on the low side.  For high speed it
> > > amounts to about 1/3-second worth of data, which arguably is also a bit
> > > low.  Increasing the default is easy enough, but the best choice isn't
> > > obvious.
> > 
> > Yeah, the choice is not obvious and we're probably going to get it
> > wrong, but as Tim said, he does need ~600MB in flight at once, so I knew
> > 16MB was too small.  I guess the question really should be not "What is
> > the smallest limit we need?" but "When will the system start breaking
> > down due to memory pressure?" and set the limit somewhere pretty close
> > to there.
> 
> It might not be so easy to identify that value.  I wouldn't know how to
> do it.

I wouldn't know how to test it either, and I suspect it would be
system-specific.  Are you at least OK with setting the limit to 600MB so
that Tim's userspace driver will work by default?  I think we still need
the modparam for the usb core to set the limit as well.

> > Do other subsystems have these issues as well?  Does the layer SCSI ever
> > limit the number of outstanding READ requests (aside from hardware
> > limitations)?
> 
> Not as far as I know.  Perhaps the block layer tries to slow things 
> down if too many I/O operations are pending (or maybe not -- I'm not 
> at all familiar with the details), but that's different from returning 
> an error.
> 
> >  Or does the networking layer have a limit to the buffers
> > it keeps pending transfers for userspace to read?
> 
> Again, I don't know.  Those subsystems are a lot more complicated than
> usbfs, and they probably have arrangements to allocate intermediate
> buffers a piece at a time.  We could do something like that, but the
> end result would be the same as our current limit on URB sizes -- the
> only difference being that transfers would be split into multiple URBs
> by the usbfs driver instead of by the user program.

Or splitting the transfer into multiple scatter-gather list entries,
right?  There's no need to submit multiple URBs if you can just use
sglists instead.  If the host can't handle sglists, the core can just
split it up into multiple URBs.  I'd like to push the biggest data
chucks we can as far down in the stack as possible to avoid performance
hits from completing many URBs.  But that's a separate issue...

> In fact, it's not all that easy for a program to generate many I/O 
> requests concurrently.  The old async I/O mechanism is one way, and you 
> spent a lot of time working on it.  Do you remember if it had any 
> limits?

I haven't looked at that in about four years, so if it did I don't
remember it.  Maybe someone from the aio list knows?

Sarah Sharp
