Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab2HIRdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 13:33:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39897 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab2HIRdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 13:33:00 -0400
Date: Thu, 9 Aug 2012 14:32:51 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 2/2] floppy: error handling fixes on do_floppy_init
Message-ID: <20120809173250.GC3104@herton-Z68MA-D2H-B3>
References: <1344450293-5557-1-git-send-email-herton.krzesinski@canonical.com>
 <1344450293-5557-3-git-send-email-herton.krzesinski@canonical.com>
 <20120808195730.GG15623@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120808195730.GG15623@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 03:57:30PM -0400, Vivek Goyal wrote:
> On Wed, Aug 08, 2012 at 03:24:53PM -0300, Herton Ronaldo Krzesinski wrote:
> > While looking at commit 3f9a5aa ("floppy: Cleanup disk->queue before
> > caling put_disk() if add_disk() was never called") I noticed some
> > problems with the error handling and cleanup:
> > 
> > * missing cleanup (put_disk) if blk_init_queue fails, dr is decremented
> >   first in the error handling loop
> > * if something fails in the add_disk loop, there is no cleanup of
> >   previous iterations in the error handling.
> > * "if (disks[dr]->queue)" check is bogus, when reaching there for each
> >   dr should exist an queue allocated, and it doesn't take into account
> >   iterations where add_disk wasn't done, if failure happens in add_disk
> >   loop.
> > * floppy_module_exit doesn't reset queue pointer if add_disk wasn't
> >   done.
> 
> Hey, these seem to be multiple cleanups. Can you break these down into
> individual patches. Review becomes easy.

I'll resend with the fixes broken up.

> 
> [..]
> > +		blk_cleanup_queue(disks[dr]->queue);
> > +		/*
> > +		 * put_disk() may not be paired with add_disk() and
> > +		 * will put queue reference one extra time. fix it.
> > +		 */
> > +		if (dr > registered || !(allowed_drive_mask & (1 << dr)) ||
> > +		    fdc_state[FDC(dr)].version == FDC_NONE)
> >  			disks[dr]->queue = NULL;
> 
> I think checking for FDC_NONE and allowed_drive_mask() in multiple places
> is becoming unreadable now. Can we just maintain a separate array to keep
> track of disks on which we have called add_disk() and do the cleanup 
> accordingly.
> 
> static unsigned short disk_registered[N_DRIVE];
> 
> /* do add_disk */
> disk_registered[drive] = 1;
> 
> 
> out_put_disk:
> 	while(dr--) {
> 		if (disks[dr]->queue && !disk_registered[dr]) {
> 			blk_cleanup_queue()
> 			disks[dr]->queue = NULL;
> 		}
> 	}
> 
> Same disk_registered[] can be used for your other loop of remove drives.
> Also it can be used in cleaning up code in floppy_module_exit().
> 
> I think this will make code much more readable. Right now this error 
> handling loop is just getting too complicated.

Complicated as many other code in the kernel :), but yes, we can do
better here, your proposed solution looks good, I'll redo the changes
with it, thanks for the review.

> 
> Thanks
> Vivek
> 

-- 
[]'s
Herton
