Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab2EOGQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 02:16:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49218 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500Ab2EOGQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 02:16:03 -0400
Date: Tue, 15 May 2012 08:15:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: NeilBrown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] floppy: remove floppy-specific O_EXCL handling
In-Reply-To: <20120515092201.4d00b4f5@notabene.brown>
Message-ID: <alpine.LNX.2.00.1205150814040.15448@pobox.suse.cz>
References: <alpine.LNX.2.00.1205131059410.15448@pobox.suse.cz> <20120514162521.GA2366@google.com> <alpine.LNX.2.00.1205142237590.15448@pobox.suse.cz> <20120514211913.GL2366@google.com> <alpine.LNX.2.00.1205142326010.15448@pobox.suse.cz>
 <20120515092201.4d00b4f5@notabene.brown>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012, NeilBrown wrote:

> > From: Jiri Kosina <jkosina@suse.cz>
> > Subject: [PATCH] floppy: remove floppy-specific O_EXCL handling
> > 
> > Block layer now handles O_EXCL in a generic way for block devices.
> > 
> > The semantics is however different for floppy and all other block devices,
> > as floppy driver contains its own O_EXCL handling.
> > 
> > The semantics for all-but-floppy bdevs is "there can be at most one O_EXCL 
> > open of this file", while for floppy bdev the semantics is "if someone has 
> > the bdev open with O_EXCL, noone else can open it".
> > 
> > There is actual userspace-observable change in behavior because of this 
> > since commit e525fd89d380c ("block: make blkdev_get/put() handle exclusive 
> > access") -- on kernels containing this commit, mount of /dev/fd0 causes 
> > the fd0 block device be claimed with _EXCL, preventing subsequent 
> > open(/dev/fd0).
> > 
> > Bring things back into shape, i.e. make it possible, analogically to other 
> > block devices, to mount the floppy and open() it afterwards -- remove the 
> > floppy-specific handling and let the generic bdev code O_EXCL handling 
> > take over.
> > 
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > Acked-by: Tejun Heo <tj@kernel.org>
> > ---
> >  drivers/block/floppy.c |    8 +-------
> >  1 files changed, 1 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> > index b0b00d7..fe694f8 100644
> > --- a/drivers/block/floppy.c
> > +++ b/drivers/block/floppy.c
> > @@ -3650,13 +3650,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
> >  		set_bit(FD_VERIFY_BIT, &UDRS->flags);
> >  	}
> >  
> > -	if (UDRS->fd_ref == -1 || (UDRS->fd_ref && (mode & FMODE_EXCL)))
> > -		goto out2;
> > -
> > -	if (mode & FMODE_EXCL)
> > -		UDRS->fd_ref = -1;
> > -	else
> > -		UDRS->fd_ref++;
> > +	UDRS->fd_ref++;
> >  
> >  	opened_bdev[drive] = bdev;
> >  
> 
> 
> As we not longer set fd_ref to -1, you should also remove:
> 
> 	if (UDRS->fd_ref < 0)
> 		UDRS->fd_ref = 0;
> 	else 
> 
> from floppy_release(), and the 'out:' section of floppy_open().
> 
> With those changes:
>    Acked-by: NeilBrown <neilb@suse.de>

Good point, thanks.

Andrew, could you please replace 
floppy-remove-floppy-specific-o_excl-handling.patch in your tree with the 
updated version below?

Thanks.



From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] floppy: remove floppy-specific O_EXCL handling

Block layer now handles O_EXCL in a generic way for block devices.

The semantics is however different for floppy and all other block devices,
as floppy driver contains its own O_EXCL handling.

The semantics for all-but-floppy bdevs is "there can be at most one O_EXCL
open of this file", while for floppy bdev the semantics is "if someone has
the bdev open with O_EXCL, noone else can open it".

There is actual userspace-observable change in behavior because of this
since commit e525fd89d380c ("block: make blkdev_get/put() handle exclusive
access") -- on kernels containing this commit, mount of /dev/fd0 causes
the fd0 block device be claimed with _EXCL, preventing subsequent
open(/dev/fd0).

Bring things back into shape, i.e.  make it possible, analogically to
other block devices, to mount the floppy and open() it afterwards --
remove the floppy-specific handling and let the generic bdev code O_EXCL
handling take over.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: NeilBrown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/block/floppy.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index b0b00d7..87c3a6e 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3612,9 +3612,7 @@ static int floppy_release(struct gendisk *disk, fmode_t mode)
 
 	mutex_lock(&floppy_mutex);
 	mutex_lock(&open_lock);
-	if (UDRS->fd_ref < 0)
-		UDRS->fd_ref = 0;
-	else if (!UDRS->fd_ref--) {
+	if (!UDRS->fd_ref--) {
 		DPRINT("floppy_release with fd_ref == 0");
 		UDRS->fd_ref = 0;
 	}
@@ -3650,13 +3648,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 		set_bit(FD_VERIFY_BIT, &UDRS->flags);
 	}
 
-	if (UDRS->fd_ref == -1 || (UDRS->fd_ref && (mode & FMODE_EXCL)))
-		goto out2;
-
-	if (mode & FMODE_EXCL)
-		UDRS->fd_ref = -1;
-	else
-		UDRS->fd_ref++;
+	UDRS->fd_ref++;
 
 	opened_bdev[drive] = bdev;
 
@@ -3719,10 +3711,8 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	mutex_unlock(&floppy_mutex);
 	return 0;
 out:
-	if (UDRS->fd_ref < 0)
-		UDRS->fd_ref = 0;
-	else
-		UDRS->fd_ref--;
+	UDRS->fd_ref--;
+
 	if (!UDRS->fd_ref)
 		opened_bdev[drive] = NULL;
 out2:


-- 
Jiri Kosina
SUSE Labs
