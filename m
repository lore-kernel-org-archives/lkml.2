Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2AZPEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 10:04:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab2AZPEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 10:04:34 -0500
Date: Thu, 26 Jan 2012 10:04:20 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Suresh Jayaraman <sjayaraman@suse.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Subject: Re: Slab corruption in floppy driver module
Message-ID: <20120126150420.GD1891@redhat.com>
References: <4F1EAFE9.5000306@suse.com>
 <20120124223153.GG17291@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124223153.GG17291@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 05:31:53PM -0500, Vivek Goyal wrote:

[..]
> > Reverting f992ae80 makes the oops and the slab corruption messages disappear.
> > The "no floppy controllers found" message was found in the dmesg.
> 
> I am wondering if extra queue reference for gendisk should be taken by driver
> and not by add_disk(). Why? Because disk->queue association is setup by
> driver and not by add_disk(). That way even if we don't call, add_disk(),
> we should be fine.

Well, changing above assumption will require lots of drivers to be
changed. So probably an easier fix would be to clear disk->queue before
calling put_disk() if we never called add_disk().

Suresh,  does following patch help?

Thanks
Vivek

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
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/block/floppy.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/block/floppy.c
===================================================================
--- linux-2.6.orig/drivers/block/floppy.c	2012-01-15 09:49:14.000000000 -0500
+++ linux-2.6/drivers/block/floppy.c	2012-01-26 09:51:24.389205883 -0500
@@ -4368,8 +4368,21 @@ out_unreg_blkdev:
 out_put_disk:
 	while (dr--) {
 		del_timer_sync(&motor_off_timer[dr]);
-		if (disks[dr]->queue)
+		if (disks[dr]->queue) {
 			blk_cleanup_queue(disks[dr]->queue);
+			/*
+			 * The request queue reference we took at device
+			 * creation time has been put by above
+			 * blk_cleanup_queue(). We have not called add_disk()
+			 * yet and due to failure calling put_disk(). Put disk
+			 * will try to put a reference to disk->queue which is
+			 * taken in add_disk(). As we have not taken that
+			 * extra reference, putting extra reference down
+			 * will try to access already freed queue. Clear
+			 * disk->queue before calling put_disk().
+			 */
+			disks[dr]->queue = NULL;
+		}
 		put_disk(disks[dr]);
 	}
 	return err;
