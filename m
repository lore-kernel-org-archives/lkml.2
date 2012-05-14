Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab2ENVig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:38:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258Ab2ENVif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:38:35 -0400
Date: Mon, 14 May 2012 23:38:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] floppy: remove floppy-specific O_EXCL handling
In-Reply-To: <20120514211913.GL2366@google.com>
Message-ID: <alpine.LNX.2.00.1205142326010.15448@pobox.suse.cz>
References: <alpine.LNX.2.00.1205131059410.15448@pobox.suse.cz> <20120514162521.GA2366@google.com> <alpine.LNX.2.00.1205142237590.15448@pobox.suse.cz> <20120514211913.GL2366@google.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012, Tejun Heo wrote:

> > Because since
> > 
> > 	commit e525fd89d380c4a94c0d63913a1dd1a593ed25e7
> > 	Author: Tejun Heo <tj@kernel.org>
> > 	Date:   Sat Nov 13 11:55:17 2010 +0100
> > 
> > 	    block: make blkdev_get/put() handle exclusive access
> > 
> > mount of /dev/fd0 actually causes the fd0 block device be claimed with 
> > _EXCL. Before this commit, you are able to mount /dev/fd0 and then open() 
> > it afterward. After this commit you can't any more, because mounting 
> > /dev/fd0 already passes O_EXCL to floppy_open(), and thus noone else can 
> > open(/dev/fd0) any more.
> > 
> > My commit brings things back into shape, i.e. you can, equally to other 
> > block devices, both mount it and open() it afterwards.
> 
> Ah, that makes sense.  Maybe it's a good idea to note why the change
> is necessary in the commit message too?

Makes sense. Please find the updated patch below. Andrew, Jens, are you 
going to pick it up, please?
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

Bring things back into shape, i.e. make it possible, analogically to other 
block devices, to mount the floppy and open() it afterwards -- remove the 
floppy-specific handling and let the generic bdev code O_EXCL handling 
take over.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/floppy.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index b0b00d7..fe694f8 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3650,13 +3650,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
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
 
-- 
Jiri Kosina
SUSE Labs
