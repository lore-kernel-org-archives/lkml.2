Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab2AZThz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 14:37:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854Ab2AZThy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 14:37:54 -0500
Date: Thu, 26 Jan 2012 14:37:35 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Suresh Jayaraman <sjayaraman@suse.com>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Subject: Re: Slab corruption in floppy driver module
Message-ID: <20120126193735.GA11297@redhat.com>
References: <4F1EAFE9.5000306@suse.com>
 <20120124223153.GG17291@redhat.com>
 <20120126150420.GD1891@redhat.com>
 <20120126180532.GA4077@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120126180532.GA4077@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 10:05:32AM -0800, Tejun Heo wrote:
> Hello,
> 
> On Thu, Jan 26, 2012 at 10:04:20AM -0500, Vivek Goyal wrote:
> >  out_put_disk:
> >  	while (dr--) {
> >  		del_timer_sync(&motor_off_timer[dr]);
> > -		if (disks[dr]->queue)
> > +		if (disks[dr]->queue) {
> >  			blk_cleanup_queue(disks[dr]->queue);
> > +			/*
> > +			 * The request queue reference we took at device
> > +			 * creation time has been put by above
> > +			 * blk_cleanup_queue(). We have not called add_disk()
> > +			 * yet and due to failure calling put_disk(). Put disk
> > +			 * will try to put a reference to disk->queue which is
> > +			 * taken in add_disk(). As we have not taken that
> > +			 * extra reference, putting extra reference down
> > +			 * will try to access already freed queue. Clear
> > +			 * disk->queue before calling put_disk().
> > +			 */
> > +			disks[dr]->queue = NULL;
> 
> Yeah, this looks correct to me.  It might be better to tone down the
> comment a bit tho.  Wouldn't it be sufficient to say put_disk() isn't
> paired with add_disk() and will put one extra time?

Sure. Toned down the comment as suggested. Here is the new patch.

floppy: Cleanup disk->queue before caling put_disk() if add_disk() was never called

add_disk() takes gendisk reference on request queue. If driver failed during
initialization and never called add_disk() then that extra reference is not
taken. That reference is put in put_disk(). floppy driver allocates the
disk, allocates queue, sets disk->queue and then relizes that floppy
controller is not present. It tries to tear down everything and tries to
put a reference down in put_disk() which was never taken.

In such error cases cleanup disk->queue before calling put_disk() so that
we never try to put down a reference which was never taken in first place.

Reported-by: Suresh Jayaraman <sjayaraman@suse.com>
Tested-by: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/block/floppy.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/block/floppy.c
===================================================================
--- linux-2.6.orig/drivers/block/floppy.c	2012-01-15 09:49:14.000000000 -0500
+++ linux-2.6/drivers/block/floppy.c	2012-01-26 14:35:14.662374464 -0500
@@ -4368,8 +4368,14 @@ out_unreg_blkdev:
 out_put_disk:
 	while (dr--) {
 		del_timer_sync(&motor_off_timer[dr]);
-		if (disks[dr]->queue)
+		if (disks[dr]->queue) {
 			blk_cleanup_queue(disks[dr]->queue);
+			/*
+			 * put_disk() is not paired with add_disk() and
+			 * will put queue reference one extra time. fix it.
+			 */
+			disks[dr]->queue = NULL;
+		}
 		put_disk(disks[dr]);
 	}
 	return err;
