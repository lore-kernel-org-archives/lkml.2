Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab2HHNCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:02:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33115 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758143Ab2HHNCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:02:20 -0400
Date: Wed, 8 Aug 2012 10:02:13 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Vivek Goyal <vgoyal@redhat.com>,
        Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [ 02/70] floppy: Cleanup disk->queue before caling put_disk() if
 add_disk() was never called
Message-ID: <20120808130213.GA3011@herton-Z68MA-D2H-B3>
References: <20120807032755.803571133@decadent.org.uk>
 <20120807032756.478538531@decadent.org.uk>
 <20120807224935.GA1008@herton-Z68MA-D2H-B3>
 <1344386425.13142.174.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344386425.13142.174.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 01:40:25AM +0100, Ben Hutchings wrote:
> On Tue, 2012-08-07 at 19:49 -0300, Herton Ronaldo Krzesinski wrote:
> > On Tue, Aug 07, 2012 at 04:27:57AM +0100, Ben Hutchings wrote:
> > > 3.2-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Vivek Goyal <vgoyal@redhat.com>
> > > 
> > > commit 3f9a5aabd0a9fe0e0cd308506f48963d79169aa7 upstream.
> > > 
> > > add_disk() takes gendisk reference on request queue. If driver failed during
> > > initialization and never called add_disk() then that extra reference is not
> > > taken. That reference is put in put_disk(). floppy driver allocates the
> > > disk, allocates queue, sets disk->queue and then relizes that floppy
> > > controller is not present. It tries to tear down everything and tries to
> > > put a reference down in put_disk() which was never taken.
> > > 
> > > In such error cases cleanup disk->queue before calling put_disk() so that
> > > we never try to put down a reference which was never taken in first place.
> > > 
> > > Reported-and-tested-by: Suresh Jayaraman <sjayaraman@suse.com>
> > > Tested-by: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > Acked-by: Tejun Heo <tj@kernel.org>
> > > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > > ---
> > >  drivers/block/floppy.c |    8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> > > index 510fb10..401ba78 100644
> > > --- a/drivers/block/floppy.c
> > > +++ b/drivers/block/floppy.c
> > > @@ -4368,8 +4368,14 @@ out_unreg_blkdev:
> > >  out_put_disk:
> > >  	while (dr--) {
> > >  		del_timer_sync(&motor_off_timer[dr]);
> > > -		if (disks[dr]->queue)
> > > +		if (disks[dr]->queue) {
> > >  			blk_cleanup_queue(disks[dr]->queue);
> > > +			/*
> > > +			 * put_disk() is not paired with add_disk() and
> > > +			 * will put queue reference one extra time. fix it.
> > > +			 */
> > > +			disks[dr]->queue = NULL;
> > > +		}
> > >  		put_disk(disks[dr]);
> > >  	}
> > >  	return err;
> > 
> > I was taking a look at this, and noticed some issues with the error
> > handling:
> > * missing cleanup (put_disk) if blk_init_queue fails, dr is decremented
> >   first in the error handling loop
> > * if something fails in the add_disk loop, there is no cleanup of
> >   previous iterations in the error handling.
> > * if (disks[dr]->queue) check is bogus, when reaching there for each dr
> >   should exist an queue allocated, and it doesn't take into account
> >   iterations where add_disk wasn't done, if failure happens in add_disk
> >   loop.
> > * floppy_module_exit doesn't reset queue pointer if add_disk wasn't
> >   done.
> 
> I agree with this analysis.
> 
> > I think the more complete diff below (not build tested) is needed, comments?
> [...]
> 
> There are several off-by-one errors, and 'drive_cnt' is not a
> particularly clear variable name (alongside 'dr' and 'drive'), but I
> think this is on the right track.

Yes, not best naming on variables, but I didn't had much ideas either on a
better name, I'll see if I can come with something better. I think I fixed
all possible off-by-one errors, if you spot something else let me know.

> 
> Anyway, do you agree that the patch under review does fix *a* bug and
> doesn't introduce a regression?

Yes, it's incomplete, but does fix one case and is no regression, I
don't see an issue keeping it. I'll wrap up and send the patch fixing
the other issues, Cc'ing to stable as well.

> 
> Ben.
> 
> -- 
> Ben Hutchings
> Theory and practice are closer in theory than in practice.
>                                 - John Levine, moderator of comp.compilers

-- 
[]'s
Herton
