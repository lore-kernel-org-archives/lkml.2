Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161330Ab1FAIIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:08:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:43249 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161321Ab1FAIIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:08:39 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:02:55 2011
Message-Id: <20110601080254.540770482@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:23 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [027/146] block: Fix discard topology stacking and reporting
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Martin K. Petersen" <martin.petersen@oracle.com>

commit a934a00a69e940b126b9bdbf83e630ef5fe43523 upstream.

In some cases we would end up stacking discard_zeroes_data incorrectly.
Fix this by enabling the feature by default for stacking drivers and
clearing it for low-level drivers. Incorporating a device that does not
support dzd will then cause the feature to be disabled in the stacking
driver.

Also ensure that the maximum discard value does not overflow when
exported in sysfs and return 0 in the alignment and dzd fields for
devices that don't support discard.

Reported-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/blk-settings.c   |    3 ++-
 block/blk-sysfs.c      |    3 ++-
 include/linux/blkdev.h |    7 +++++--
 3 files changed, 9 insertions(+), 4 deletions(-)

--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -120,7 +120,7 @@ void blk_set_default_limits(struct queue
 	lim->discard_granularity = 0;
 	lim->discard_alignment = 0;
 	lim->discard_misaligned = 0;
-	lim->discard_zeroes_data = -1;
+	lim->discard_zeroes_data = 1;
 	lim->logical_block_size = lim->physical_block_size = lim->io_min = 512;
 	lim->bounce_pfn = (unsigned long)(BLK_BOUNCE_ANY >> PAGE_SHIFT);
 	lim->alignment_offset = 0;
@@ -174,6 +174,7 @@ void blk_queue_make_request(struct reque
 
 	blk_set_default_limits(&q->limits);
 	blk_queue_max_hw_sectors(q, BLK_SAFE_MAX_SECTORS);
+	q->limits.discard_zeroes_data = 0;
 
 	/*
 	 * If the caller didn't supply a lock, fall back to our embedded
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -152,7 +152,8 @@ static ssize_t queue_discard_granularity
 
 static ssize_t queue_discard_max_show(struct request_queue *q, char *page)
 {
-	return queue_var_show(q->limits.max_discard_sectors << 9, page);
+	return sprintf(page, "%llu\n",
+		       (unsigned long long)q->limits.max_discard_sectors << 9);
 }
 
 static ssize_t queue_discard_zeroes_data_show(struct request_queue *q, char *page)
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -252,7 +252,7 @@ struct queue_limits {
 	unsigned char		misaligned;
 	unsigned char		discard_misaligned;
 	unsigned char		cluster;
-	signed char		discard_zeroes_data;
+	unsigned char		discard_zeroes_data;
 };
 
 struct request_queue
@@ -1032,13 +1032,16 @@ static inline int queue_limit_discard_al
 {
 	unsigned int alignment = (sector << 9) & (lim->discard_granularity - 1);
 
+	if (!lim->max_discard_sectors)
+		return 0;
+
 	return (lim->discard_granularity + lim->discard_alignment - alignment)
 		& (lim->discard_granularity - 1);
 }
 
 static inline unsigned int queue_discard_zeroes_data(struct request_queue *q)
 {
-	if (q->limits.discard_zeroes_data == 1)
+	if (q->limits.max_discard_sectors && q->limits.discard_zeroes_data == 1)
 		return 1;
 
 	return 0;


