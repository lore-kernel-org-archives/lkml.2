Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab2EMJCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 05:02:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab2EMJCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 05:02:17 -0400
Date: Sun, 13 May 2012 11:02:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] floppy: remove floppy-specific O_EXCL handling
Message-ID: <alpine.LNX.2.00.1205131059410.15448@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Block layer now handles O_EXCL in a generic way for block devices.

The semantics is however different for floppy and all other block devices,
as floppy driver contains its own O_EXCL handling.

The semantics for all-but-floppy bdevs is "there can be at most one O_EXCL 
open of this file", while for floppy bdev the semantics is "if someone has 
the bdev open with O_EXCL, noone else can open it".

Remove the floppy-specific handling and let the generic bdev code O_EXCL
handling take over.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
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
