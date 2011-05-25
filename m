Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab1EYUvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:51:21 -0400
Received: from smtp-out.google.com ([74.125.121.67]:14056 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab1EYUvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:51:20 -0400
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org, jrbarnette@chromium.org
Cc: Mandeep Singh Baines <msb@chromium.org>, Neil Brown <neilb@suse.de>,
        Mike Snitzer <snitzer@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: [PATCH] dm: pass up rotational flag
Date: Wed, 25 May 2011 13:50:48 -0700
Message-Id: <1306356648-30730-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the NONROT flag to be passed through to linear mappings if all
underlying device are non-rotational. Tools like ureadahead will
schedule IOs differently based on the rotational flag.

With this patch, I see boot time go from 7.75 s to 7.46 s on my device.

Suggested-by: J. Richard Barnette <jrbarnette@chromium.org>
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-table.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index cb8380c..40c6071 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1177,6 +1177,30 @@ static void dm_table_set_integrity(struct dm_table *t)
 			       blk_get_integrity(template_disk));
 }
 
+static int device_nonrot(struct dm_target *ti, struct dm_dev *dev,
+			       sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return q && blk_queue_nonrot(q);
+}
+
+static bool dm_table_all_nonrot(struct dm_table *t)
+{
+	unsigned i = 0;
+
+	/* Ensure that all underlying device are non rotational. */
+	while (i < dm_table_get_num_targets(t)) {
+		struct dm_target *ti = dm_table_get_target(t, i++);
+
+		if (!ti->type->iterate_devices ||
+		    !ti->type->iterate_devices(ti, device_nonrot, NULL))
+			return false;
+	}
+
+	return true;
+}
+
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			       struct queue_limits *limits)
 {
@@ -1189,6 +1213,10 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, q);
 	else
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
+	if (!dm_table_all_nonrot(t))
+		queue_flag_clear_unlocked(QUEUE_FLAG_NONROT, q);
+	else
+		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
 
 	dm_table_set_integrity(t);
 
-- 
1.7.3.1

