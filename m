Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761789Ab0GTUp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:45:56 -0400
Received: from claw.goop.org ([74.207.240.146]:50941 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761598Ab0GTUmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:42:50 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Xen-devel <xen-devel@lists.xensource.com>,
        Daniel Stodden <daniel.stodden@citrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 08/16] blkfront: Fix backtrace in del_gendisk
Date: Tue, 20 Jul 2010 13:42:16 -0700
Message-Id: <b244c1b3d8e0febf375946e2acf7a893528f4255.1279658433.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
References: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Stodden <daniel.stodden@citrix.com>

The call to del_gendisk follows an non-refcounted gd->queue
pointer. We release the last ref in blk_cleanup_queue. Fixed by
reordering releases accordingly.

Signed-off-by: Daniel Stodden <daniel.stodden@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/block/xen-blkfront.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 50b2952..62eba76 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1021,14 +1021,14 @@ static void blkfront_closing(struct blkfront_info *info)
 	/* Flush gnttab callback work. Must be done with no locks held. */
 	flush_scheduled_work();
 
-	blk_cleanup_queue(info->rq);
-	info->rq = NULL;
-
 	minor = info->gd->first_minor;
 	nr_minors = info->gd->minors;
 	del_gendisk(info->gd);
 	xlbd_release_minors(minor, nr_minors);
 
+	blk_cleanup_queue(info->rq);
+	info->rq = NULL;
+
  out:
 	if (info->xbdev)
 		xenbus_frontend_closed(info->xbdev);
-- 
1.7.1.1

