Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab0KWTBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 14:01:06 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33602 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab0KWTBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 14:01:03 -0500
Date: Tue, 23 Nov 2010 11:01:03 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] md: Call blk_queue_flush() to establish flush/fua
	support
Message-ID: <20101123190103.GW14383@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20101122232208.GU14383@tux1.beaverton.ibm.com> <20101123105000.331b40f8@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101123105000.331b40f8@notabene.brown>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a shorter version that sets up flush/fua unconditionally.
---
Before 2.6.37, the md layer had a mechanism for catching I/Os with the barrier
flag set, and translating the barrier into barriers for all the underlying
devices.  With 2.6.37, I/O barriers have become plain old flushes, and the md
code was updated to reflect this.  However, one piece was left out -- the md
layer does not tell the block layer that it supports flushes or FUA access at
all, which results in md silently dropping flush requests.

Since the support already seems there, just add this one piece of bookkeeping.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/md/md.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 324a366..43243a4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4338,6 +4338,8 @@ static int md_alloc(dev_t dev, char *name)
 	if (mddev->kobj.sd &&
 	    sysfs_create_group(&mddev->kobj, &md_bitmap_group))
 		printk(KERN_DEBUG "pointless warning\n");
+
+	blk_queue_flush(mddev->queue, REQ_FLUSH | REQ_FUA);
  abort:
 	mutex_unlock(&disks_mutex);
 	if (!error && mddev->kobj.sd) {
