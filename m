Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab0K2WGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:06:13 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34545 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab0K2WGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:06:08 -0500
Subject: [PATCH 3/4] dm: Compute average flush time from component devices
To: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
        Neil Brown <neilb@suse.de>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Alasdair G Kergon <agk@redhat.com>,
        "Darrick J. Wong" <djwong@us.ibm.com>
From: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org, Keith Mannthey <kmannth@us.ibm.com>,
        dm-devel@redhat.com, Mingming Cao <cmm@us.ibm.com>,
        Tejun Heo <tj@kernel.org>, linux-ext4@vger.kernel.org,
        Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Josef Bacik <josef@redhat.com>
Date: Mon, 29 Nov 2010 14:05:58 -0800
Message-ID: <20101129220558.12401.95229.stgit@elm3b57.beaverton.ibm.com>
In-Reply-To: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
References: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For dm devices which are composed of other block devices, a flush is mapped out
to those other block devices.  Therefore, the average flush time can be
computed as the average flush time of whichever device flushes most slowly.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 drivers/md/dm.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)


diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7cb1352..62aeeb9 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -846,12 +846,38 @@ static void start_queue(struct request_queue *q)
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
+static void measure_flushes(struct mapped_device *md)
+{
+	struct dm_table *t;
+	struct dm_dev_internal *dd;
+	struct list_head *devices;
+	u64 max = 0, samples = 0;
+
+	t = dm_get_live_table(md);
+	devices = dm_table_get_devices(t);
+	list_for_each_entry(dd, devices, list) {
+		if (dd->dm_dev.bdev->bd_disk->avg_flush_time_ns <= max)
+			continue;
+		max = dd->dm_dev.bdev->bd_disk->avg_flush_time_ns;
+		samples = dd->dm_dev.bdev->bd_disk->flush_samples;
+	}
+	dm_table_put(t);
+
+	spin_lock(&md->disk->flush_time_lock);
+	md->disk->avg_flush_time_ns = max;
+	md->disk->flush_samples = samples;
+	spin_unlock(&md->disk->flush_time_lock);
+}
+
 static void dm_done(struct request *clone, int error, bool mapped)
 {
 	int r = error;
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	dm_request_endio_fn rq_end_io = tio->ti->type->rq_end_io;
 
+	if (clone->cmd_flags & REQ_FLUSH)
+		measure_flushes(tio->md);
+
 	if (mapped && rq_end_io)
 		r = rq_end_io(tio->ti, clone, error, &tio->info);
 
@@ -2310,6 +2336,8 @@ static void dm_wq_work(struct work_struct *work)
 		if (dm_request_based(md))
 			generic_make_request(c);
 		else
+			if (c->bi_rw & REQ_FLUSH)
+				measure_flushes(md);
 			__split_and_process_bio(md, c);
 
 		down_read(&md->io_lock);

