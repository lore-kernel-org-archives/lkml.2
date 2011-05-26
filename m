Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab1EZSfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:35:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932308Ab1EZSfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:35:45 -0400
Date: Thu, 26 May 2011 14:35:31 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, jrbarnette@chromium.org,
        Neil Brown <neilb@suse.de>, Jens Axboe <jaxboe@fusionio.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: [PATCH v2] dm: pass up non-rotational flag
Message-ID: <20110526183531.GB26219@redhat.com>
References: <1306356648-30730-1-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306356648-30730-1-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow QUEUE_FLAG_NONROT to propagate up the device stack if all
underlying devices are non-rotational.  Tools like ureadahead will
schedule IOs differently based on the rotational flag.

With this patch, I see boot time go from 7.75 s to 7.46 s on my device.

Suggested-by: J. Richard Barnette <jrbarnette@chromium.org>
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-table.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

v2: last minute edit was to avoid double-negative in
    dm_table_set_restrictions's dm_table_is_nonrot conditional

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index cb8380c..a173828 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1177,6 +1177,31 @@ static void dm_table_set_integrity(struct dm_table *t)
 			       blk_get_integrity(template_disk));
 }
 
+static int device_is_nonrot(struct dm_target *ti, struct dm_dev *dev,
+			    sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return q && blk_queue_nonrot(q);
+}
+
+static bool dm_table_is_nonrot(struct dm_table *t)
+{
+	struct dm_target *ti;
+	unsigned i = 0;
+
+	/* Ensure that all underlying device are non-rotational. */
+	while (i < dm_table_get_num_targets(t)) {
+		ti = dm_table_get_target(t, i++);
+
+		if (!ti->type->iterate_devices ||
+		    !ti->type->iterate_devices(ti, device_is_nonrot, NULL))
+			return 0;
+	}
+
+	return 1;
+}
+
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			       struct queue_limits *limits)
 {
@@ -1190,6 +1215,11 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	else
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
 
+	if (dm_table_is_nonrot(t))
+		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
+	else
+		queue_flag_clear_unlocked(QUEUE_FLAG_NONROT, q);
+
 	dm_table_set_integrity(t);
 
 	/*
