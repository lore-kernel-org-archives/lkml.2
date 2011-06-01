Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162130Ab1FAJDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:03:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43513 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162077Ab1FAIRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:17:20 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:04 2011
Message-Id: <20110601081103.462250172@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:09:55 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shaohua Li <shaohua.li@intel.com>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [025/165] block: add a non-queueable flush flag
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 2189
Lines: 66

From: "shaohua.li@intel.com" <shaohua.li@intel.com>

commit f3876930952390a31c3a7fd68dd621464a36eb80 upstream.

flush request isn't queueable in some drives. Add a flag to let driver
notify block layer about this. We can optimize flush performance with the
knowledge.

Stable: 2.6.39 only

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/blk-settings.c   |    6 ++++++
 include/linux/blkdev.h |    7 +++++++
 2 files changed, 13 insertions(+)

--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -790,6 +790,12 @@ void blk_queue_flush(struct request_queu
 }
 EXPORT_SYMBOL_GPL(blk_queue_flush);
 
+void blk_queue_flush_queueable(struct request_queue *q, bool queueable)
+{
+	q->flush_not_queueable = !queueable;
+}
+EXPORT_SYMBOL_GPL(blk_queue_flush_queueable);
+
 static int __init blk_settings_init(void)
 {
 	blk_max_low_pfn = max_low_pfn - 1;
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -364,6 +364,7 @@ struct request_queue
 	 * for flush operations
 	 */
 	unsigned int		flush_flags;
+	unsigned int		flush_not_queueable:1;
 	unsigned int		flush_pending_idx:1;
 	unsigned int		flush_running_idx:1;
 	unsigned long		flush_pending_since;
@@ -843,6 +844,7 @@ extern void blk_queue_softirq_done(struc
 extern void blk_queue_rq_timed_out(struct request_queue *, rq_timed_out_fn *);
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
 extern void blk_queue_flush(struct request_queue *q, unsigned int flush);
+extern void blk_queue_flush_queueable(struct request_queue *q, bool queueable);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
 
 extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatterlist *);
@@ -1111,6 +1113,11 @@ static inline unsigned int block_size(st
 	return bdev->bd_block_size;
 }
 
+static inline bool queue_flush_queueable(struct request_queue *q)
+{
+	return !q->flush_not_queueable;
+}
+
 typedef struct {struct page *v;} Sector;
 
 unsigned char *read_dev_sector(struct block_device *, sector_t, Sector *);


