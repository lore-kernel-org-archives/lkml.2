Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab2GIO5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:57:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755120Ab2GIO5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:57:22 -0400
Date: Mon, 9 Jul 2012 10:57:12 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "Moger, Babu" <Babu.Moger@netapp.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Stankey, Robert" <Robert.Stankey@netapp.com>, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] block: do not artificially constrain max_sectors for
 stacking drivers
Message-ID: <20120709145711.GB30886@redhat.com>
References: <F200AD42A082BC4088B232D13A916A8907E5DD64@SACEXCMBX02-PRD.hq.netapp.com>
 <20120709130052.GC30048@redhat.com>
 <20120709131611.GD30048@redhat.com>
 <20120709134041.GA30633@redhat.com>
 <20120709141416.GB30633@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120709141416.GB30633@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_set_stacking_limits() is intended to allow stacking drivers to build
up the limits of the stacked device based on the underlying devices'
limits.  But in the case of 'max_sectors' the default of
BLK_DEF_MAX_SECTORS (1024) doesn't allow the stacking driver to inherit
a max_sectors larger than 1024.

It is now clear that this artificial limit is getting in the way so
change blk_set_stacking_limits's max_sectors to UINT_MAX (which allows
stacking drivers like dm-multipath to inherit 'max_sectors' from the
underlying paths).

blk_limits_max_hw_sectors() must allow stacking drivers to not have
max_sectors set to BLK_DEF_MAX_SECTORS as a side-effect.  Move that
historic constraint to blk_queue_max_hw_sectors().

Reported-by: Vijay Chauhan <vijay.chauhan@netapp.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-settings.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

v2: tweak blk_limits_max_hw_sectors and blk_queue_max_hw_sectors

diff --git a/block/blk-settings.c b/block/blk-settings.c
index d3234fc..b808dfd 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -143,8 +143,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->discard_zeroes_data = 1;
 	lim->max_segments = USHRT_MAX;
 	lim->max_hw_sectors = UINT_MAX;
-
-	lim->max_sectors = BLK_DEF_MAX_SECTORS;
+	lim->max_sectors = UINT_MAX;
 }
 EXPORT_SYMBOL(blk_set_stacking_limits);
 
@@ -255,8 +254,7 @@ void blk_limits_max_hw_sectors(struct queue_limits *limits, unsigned int max_hw_
 	}
 
 	limits->max_hw_sectors = max_hw_sectors;
-	limits->max_sectors = min_t(unsigned int, max_hw_sectors,
-				    BLK_DEF_MAX_SECTORS);
+	limits->max_sectors = min_not_zero(limits->max_sectors, max_hw_sectors);
 }
 EXPORT_SYMBOL(blk_limits_max_hw_sectors);
 
@@ -271,6 +269,8 @@ EXPORT_SYMBOL(blk_limits_max_hw_sectors);
 void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_sectors)
 {
 	blk_limits_max_hw_sectors(&q->limits, max_hw_sectors);
+	q->limits.max_sectors = min_t(unsigned int, max_hw_sectors,
+				      BLK_DEF_MAX_SECTORS);
 }
 EXPORT_SYMBOL(blk_queue_max_hw_sectors);
 
