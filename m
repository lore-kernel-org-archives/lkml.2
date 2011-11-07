Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab1KGUSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:18:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:51060 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab1KGUSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:18:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,471,1315206000"; 
   d="scan'208";a="82110494"
Date: Mon, 7 Nov 2011 12:18:12 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tim Vlaar <Tvlaar@ptgrey.com>, Greg KH <greg@kroah.com>,
        Markus Rechberger <mrechberger@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
Message-ID: <20111107201812.GA12822@xanatos>
References: <20111107185255.GA9005@xanatos>
 <Pine.LNX.4.44L0.1111071403290.2004-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1111071403290.2004-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 02:12:16PM -0500, Alan Stern wrote:
> On Mon, 7 Nov 2011, Sarah Sharp wrote:
> 
> > On Fri, Oct 14, 2011 at 08:33:29AM -0600, Greg KH wrote:
> > > On Fri, Oct 14, 2011 at 10:05:41AM -0400, Alan Stern wrote:
> > > > No, a much better approach is to remove all limits on individual
> > > > transfer sizes and instead have a global limit on the total amount of
> > > > all usbfs buffers in use at any time.  Maybe something like 16 MB; at 
> > > > SuperSpeed, that's about about 30 ms worth of data.
> > > 
> > > That sounds quite reasonable.
> > 
> > Alan, won't this global limit on the usbfs URB buffer size effect
> > userspace drivers that are currently allocating large amounts of
> > buffers, but still respecting individual buffer limit of 16KB?  It seems
> > like the patch has the potential to break userspace drivers.
> 
> It might indeed.  A further enhancement would replace that 16-MB global
> constant with a sysfs attribute (a writable module parameter for
> usbcore).  Do you have any better suggestions?

No, I don't have any better suggestions, except take out the limit. ;)

I do understand why we don't want userspace to DoS the system by using
up too much DMA'able memory.  However, as I understand it, the usbfs
files are created by udev with root access only by default, and distros
may choose to install rules that have more permissive privileges.  A
device vendor may not be ensured that a udev rule with permissive access
will be present for their device, so I think they're likely to write
programs that require root access.  Or require root privileges to
install said udev rule.

At that point, the same userspace program that has root privileges in
order to access usbfs or create the udev rule can just load and unload
the usbcore module with an arbitrarily large global limit, and the
global limit doesn't really add any security.  So why add the extra
barrier?

> > I think that Point Grey's USB 3.0 webcam will be attempting to queue a
> > series of bulk URBs that will be bigger than your 16MB global limit.
> 
> For SuperSpeed, 16 MB is rather on the low side.  For high speed it
> amounts to about 1/3-second worth of data, which arguably is also a bit
> low.  Increasing the default is easy enough, but the best choice isn't
> obvious.

Yeah, the choice is not obvious and we're probably going to get it
wrong, but as Tim said, he does need ~600MB in flight at once, so I knew
16MB was too small.  I guess the question really should be not "What is
the smallest limit we need?" but "When will the system start breaking
down due to memory pressure?" and set the limit somewhere pretty close
to there.

Do other subsystems have these issues as well?  Does the layer SCSI ever
limit the number of outstanding READ requests (aside from hardware
limitations)?  Or does the networking layer have a limit to the buffers
it keeps pending transfers for userspace to read?

Sarah Sharp
