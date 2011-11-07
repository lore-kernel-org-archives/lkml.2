Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab1KGUh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:37:58 -0500
Received: from mga14.intel.com ([143.182.124.37]:27506 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab1KGUh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:37:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,471,1315206000"; 
   d="scan'208";a="34183413"
From: "Brink, Peter" <peter.brink@intel.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Tim Vlaar <Tvlaar@ptgrey.com>, Greg KH <greg@kroah.com>,
        Markus Rechberger <mrechberger@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 7 Nov 2011 13:37:52 -0700
Subject: RE: [Patch] Increase USBFS Bulk Transfer size
Thread-Topic: [Patch] Increase USBFS Bulk Transfer size
Thread-Index: AcydioEgY8c61owRQ96iE3+Bf6nXgwAAeZGw
Message-ID: <86810401A1B22346A09CBA649BE561E9017190B043@azsmsx505.amr.corp.intel.com>
References: <20111107185255.GA9005@xanatos>
 <Pine.LNX.4.44L0.1111071403290.2004-100000@iolanthe.rowland.org>
 <20111107201812.GA12822@xanatos>
In-Reply-To: <20111107201812.GA12822@xanatos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Beyond hardware, I cannot tell you if there is a limitation, but both the SATA and SAS protocol layers have a command buffering system called NCQ (Native Command Queuing) for SATA or CQ (Command Queuing) for SAS.  Each of these is related specifically to the drive itself, and, from my observation, the file system tracks to the number of commands that the drive will support.

There are also queues for each set of commands that will direct to different drives, but in practice, even in high stress environments, the file system was hard pressed to keep up with the command-processing of the individual drives, depending, of course, on the size of the reads. This was true on both Windows and Linux and across RAIDed systems.

Pete

-----Original Message-----
From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of Sarah Sharp
Sent: Monday, November 07, 2011 1:18 PM
To: Alan Stern
Cc: Tim Vlaar; Greg KH; Markus Rechberger; Alan Cox; USB list; LKML
Subject: Re: [Patch] Increase USBFS Bulk Transfer size

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
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
