Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab1IUMTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 08:19:41 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:49625
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab1IUMTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 08:19:39 -0400
Message-ID: <4E79D65A.6070406@kernel.dk>
Date: Wed, 21 Sep 2011 14:19:38 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block fixes for 3.1-rc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Final round of patches for 3.1.

- Early in the cycle, a patch removing the CFQ special treatment of meta
  data requests was merged. This was later found to be causing slight
  performance regressions, so we reverted it. However, in the mean time
  XFS had started annotating requests as meta requests, so they didn't
  like that revert a whole lot. Two patches from Christoph in here split
  the trace annotation from the functional change. These changes are
  one-liners, but touch some file system files. Hence the diffstat.

- Fix for the rq_affinity setting going from 2 to 1.

- Fix for rq_affinity on bio's marked CPU affine.

- Cleanup of the writeback task state setting and pending bit checking
  from Jan.

- Floppy timer fix.

- Two small fixes for xen-blkback.

- Optimization and simplication of the unplug ordering.

- Small blk-cgroup fix.

Please pull.

  git://git.kernel.dk/linux-block.git for-linus

Carsten Emde (1):
      floppy: use del_timer_sync() in init cleanup

Christoph Hellwig (2):
      block: remove READ_META and WRITE_META
      block: separate priority boosting from REQ_META

Eric Seppanen (1):
      block: Fix queue_flag update when rq_affinity goes from 2 to 1

Jan Kara (2):
      mm: Cleanup clearing of BDI_pending bit in bdi_forker_thread()
      mm: Add comment explaining task state setting in bdi_forker_thread()

Jens Axboe (1):
      Merge branch 'stable/for-jens' of git://git.kernel.org/.../konrad/xen into for-linus

Joe Jin (2):
      xen-blkback: Don't disconnect backend until state switched to XenbusStateClosed.
      xen-blkback: fixed indentation and comments

Shaohua Li (2):
      block: change force plug flush call order
      block: simplify force plug flush code a little bit

Tao Ma (1):
      block: Don't check QUEUE_FLAG_SAME_COMP in __blk_complete_request

Wanlong Gao (1):
      blk-cgroup: be able to remove the record of unplugged device

 block/blk-cgroup.c                 |   37 +++++++++++++++--------------------
 block/blk-core.c                   |   15 +++++++------
 block/blk-softirq.c                |    2 +-
 block/blk-sysfs.c                  |   10 +++++---
 block/cfq-iosched.c                |   20 +++++++++---------
 drivers/block/floppy.c             |    8 +++---
 drivers/block/xen-blkback/common.h |    2 +-
 drivers/block/xen-blkback/xenbus.c |    6 ++--
 drivers/mmc/card/block.c           |    3 ++
 fs/ext3/inode.c                    |    4 +-
 fs/ext3/namei.c                    |    3 +-
 fs/ext4/inode.c                    |    4 +-
 fs/ext4/namei.c                    |    3 +-
 fs/gfs2/log.c                      |    4 +-
 fs/gfs2/meta_io.c                  |    6 ++--
 fs/gfs2/ops_fstype.c               |    2 +-
 fs/gfs2/quota.c                    |    2 +-
 include/linux/blk_types.h          |    6 +++-
 include/linux/blkdev.h             |    1 -
 include/linux/fs.h                 |    2 -
 mm/backing-dev.c                   |   30 ++++++++++++++++++++--------
 21 files changed, 92 insertions(+), 78 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index bcaf16e..b596e54 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -785,10 +785,10 @@ static int blkio_policy_parse_and_set(char *buf,
 {
 	char *s[4], *p, *major_s = NULL, *minor_s = NULL;
 	int ret;
-	unsigned long major, minor, temp;
+	unsigned long major, minor;
 	int i = 0;
 	dev_t dev;
-	u64 bps, iops;
+	u64 temp;
 
 	memset(s, 0, sizeof(s));
 
@@ -826,20 +826,23 @@ static int blkio_policy_parse_and_set(char *buf,
 
 	dev = MKDEV(major, minor);
 
-	ret = blkio_check_dev_num(dev);
+	ret = strict_strtoull(s[1], 10, &temp);
 	if (ret)
-		return ret;
+		return -EINVAL;
 
-	newpn->dev = dev;
+	/* For rule removal, do not check for device presence. */
+	if (temp) {
+		ret = blkio_check_dev_num(dev);
+		if (ret)
+			return ret;
+	}
 
-	if (s[1] == NULL)
-		return -EINVAL;
+	newpn->dev = dev;
 
 	switch (plid) {
 	case BLKIO_POLICY_PROP:
-		ret = strict_strtoul(s[1], 10, &temp);
-		if (ret || (temp < BLKIO_WEIGHT_MIN && temp > 0) ||
-			temp > BLKIO_WEIGHT_MAX)
+		if ((temp < BLKIO_WEIGHT_MIN && temp > 0) ||
+		     temp > BLKIO_WEIGHT_MAX)
 			return -EINVAL;
 
 		newpn->plid = plid;
@@ -850,26 +853,18 @@ static int blkio_policy_parse_and_set(char *buf,
 		switch(fileid) {
 		case BLKIO_THROTL_read_bps_device:
 		case BLKIO_THROTL_write_bps_device:
-			ret = strict_strtoull(s[1], 10, &bps);
-			if (ret)
-				return -EINVAL;
-
 			newpn->plid = plid;
 			newpn->fileid = fileid;
-			newpn->val.bps = bps;
+			newpn->val.bps = temp;
 			break;
 		case BLKIO_THROTL_read_iops_device:
 		case BLKIO_THROTL_write_iops_device:
-			ret = strict_strtoull(s[1], 10, &iops);
-			if (ret)
-				return -EINVAL;
-
-			if (iops > THROTL_IOPS_MAX)
+			if (temp > THROTL_IOPS_MAX)
 				return -EINVAL;
 
 			newpn->plid = plid;
 			newpn->fileid = fileid;
-			newpn->val.iops = (unsigned int)iops;
+			newpn->val.iops = (unsigned int)temp;
 			break;
 		}
 		break;
diff --git a/block/blk-core.c b/block/blk-core.c
index 90e1ffd..b2ed78a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1167,7 +1167,7 @@ static bool bio_attempt_front_merge(struct request_queue *q,
  * true if merge was successful, otherwise false.
  */
 static bool attempt_plug_merge(struct task_struct *tsk, struct request_queue *q,
-			       struct bio *bio)
+			       struct bio *bio, unsigned int *request_count)
 {
 	struct blk_plug *plug;
 	struct request *rq;
@@ -1176,10 +1176,13 @@ static bool attempt_plug_merge(struct task_struct *tsk, struct request_queue *q,
 	plug = tsk->plug;
 	if (!plug)
 		goto out;
+	*request_count = 0;
 
 	list_for_each_entry_reverse(rq, &plug->list, queuelist) {
 		int el_ret;
 
+		(*request_count)++;
+
 		if (rq->q != q)
 			continue;
 
@@ -1219,6 +1222,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 	struct blk_plug *plug;
 	int el_ret, rw_flags, where = ELEVATOR_INSERT_SORT;
 	struct request *req;
+	unsigned int request_count = 0;
 
 	/*
 	 * low level driver can indicate that it wants pages above a
@@ -1237,7 +1241,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 	 * Check if we can merge with the plugged list before grabbing
 	 * any locks.
 	 */
-	if (attempt_plug_merge(current, q, bio))
+	if (attempt_plug_merge(current, q, bio, &request_count))
 		goto out;
 
 	spin_lock_irq(q->queue_lock);
@@ -1302,11 +1306,10 @@ get_rq:
 			if (__rq->q != q)
 				plug->should_sort = 1;
 		}
+		if (request_count >= BLK_MAX_REQUEST_COUNT)
+			blk_flush_plug_list(plug, false);
 		list_add_tail(&req->queuelist, &plug->list);
-		plug->count++;
 		drive_stat_acct(req, 1);
-		if (plug->count >= BLK_MAX_REQUEST_COUNT)
-			blk_flush_plug_list(plug, false);
 	} else {
 		spin_lock_irq(q->queue_lock);
 		add_acct_request(q, req, where);
@@ -2634,7 +2637,6 @@ void blk_start_plug(struct blk_plug *plug)
 	INIT_LIST_HEAD(&plug->list);
 	INIT_LIST_HEAD(&plug->cb_list);
 	plug->should_sort = 0;
-	plug->count = 0;
 
 	/*
 	 * If this is a nested plug, don't actually assign it. It will be
@@ -2718,7 +2720,6 @@ void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 		return;
 
 	list_splice_init(&plug->list, &list);
-	plug->count = 0;
 
 	if (plug->should_sort) {
 		list_sort(NULL, &list, plug_rq_cmp);
diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 58340d0..1366a89 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -115,7 +115,7 @@ void __blk_complete_request(struct request *req)
 	/*
 	 * Select completion CPU
 	 */
-	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) && req->cpu != -1) {
+	if (req->cpu != -1) {
 		ccpu = req->cpu;
 		if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags)) {
 			ccpu = blk_cpu_to_group(ccpu);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 0ee17b5..e681805 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -258,11 +258,13 @@ queue_rq_affinity_store(struct request_queue *q, const char *page, size_t count)
 
 	ret = queue_var_store(&val, page, count);
 	spin_lock_irq(q->queue_lock);
-	if (val) {
+	if (val == 2) {
 		queue_flag_set(QUEUE_FLAG_SAME_COMP, q);
-		if (val == 2)
-			queue_flag_set(QUEUE_FLAG_SAME_FORCE, q);
-	} else {
+		queue_flag_set(QUEUE_FLAG_SAME_FORCE, q);
+	} else if (val == 1) {
+		queue_flag_set(QUEUE_FLAG_SAME_COMP, q);
+		queue_flag_clear(QUEUE_FLAG_SAME_FORCE, q);
+	} else if (val == 0) {
 		queue_flag_clear(QUEUE_FLAG_SAME_COMP, q);
 		queue_flag_clear(QUEUE_FLAG_SAME_FORCE, q);
 	}
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a33bd43..16ace89 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -130,8 +130,8 @@ struct cfq_queue {
 	unsigned long slice_end;
 	long slice_resid;
 
-	/* pending metadata requests */
-	int meta_pending;
+	/* pending priority requests */
+	int prio_pending;
 	/* number of requests that are on the dispatch list or inside driver */
 	int dispatched;
 
@@ -684,8 +684,8 @@ cfq_choose_req(struct cfq_data *cfqd, struct request *rq1, struct request *rq2,
 	if (rq_is_sync(rq1) != rq_is_sync(rq2))
 		return rq_is_sync(rq1) ? rq1 : rq2;
 
-	if ((rq1->cmd_flags ^ rq2->cmd_flags) & REQ_META)
-		return rq1->cmd_flags & REQ_META ? rq1 : rq2;
+	if ((rq1->cmd_flags ^ rq2->cmd_flags) & REQ_PRIO)
+		return rq1->cmd_flags & REQ_PRIO ? rq1 : rq2;
 
 	s1 = blk_rq_pos(rq1);
 	s2 = blk_rq_pos(rq2);
@@ -1612,9 +1612,9 @@ static void cfq_remove_request(struct request *rq)
 	cfqq->cfqd->rq_queued--;
 	cfq_blkiocg_update_io_remove_stats(&(RQ_CFQG(rq))->blkg,
 					rq_data_dir(rq), rq_is_sync(rq));
-	if (rq->cmd_flags & REQ_META) {
-		WARN_ON(!cfqq->meta_pending);
-		cfqq->meta_pending--;
+	if (rq->cmd_flags & REQ_PRIO) {
+		WARN_ON(!cfqq->prio_pending);
+		cfqq->prio_pending--;
 	}
 }
 
@@ -3372,7 +3372,7 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	 * So both queues are sync. Let the new request get disk time if
 	 * it's a metadata request and the current queue is doing regular IO.
 	 */
-	if ((rq->cmd_flags & REQ_META) && !cfqq->meta_pending)
+	if ((rq->cmd_flags & REQ_PRIO) && !cfqq->prio_pending)
 		return true;
 
 	/*
@@ -3439,8 +3439,8 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	struct cfq_io_context *cic = RQ_CIC(rq);
 
 	cfqd->rq_queued++;
-	if (rq->cmd_flags & REQ_META)
-		cfqq->meta_pending++;
+	if (rq->cmd_flags & REQ_PRIO)
+		cfqq->prio_pending++;
 
 	cfq_update_io_thinktime(cfqd, cfqq, cic);
 	cfq_update_io_seektime(cfqd, cfqq, rq);
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 98de8f4..9955a53 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4250,7 +4250,7 @@ static int __init floppy_init(void)
 	use_virtual_dma = can_use_virtual_dma & 1;
 	fdc_state[0].address = FDC1;
 	if (fdc_state[0].address == -1) {
-		del_timer(&fd_timeout);
+		del_timer_sync(&fd_timeout);
 		err = -ENODEV;
 		goto out_unreg_region;
 	}
@@ -4261,7 +4261,7 @@ static int __init floppy_init(void)
 	fdc = 0;		/* reset fdc in case of unexpected interrupt */
 	err = floppy_grab_irq_and_dma();
 	if (err) {
-		del_timer(&fd_timeout);
+		del_timer_sync(&fd_timeout);
 		err = -EBUSY;
 		goto out_unreg_region;
 	}
@@ -4318,7 +4318,7 @@ static int __init floppy_init(void)
 		user_reset_fdc(-1, FD_RESET_ALWAYS, false);
 	}
 	fdc = 0;
-	del_timer(&fd_timeout);
+	del_timer_sync(&fd_timeout);
 	current_drive = 0;
 	initialized = true;
 	if (have_no_fdc) {
@@ -4368,7 +4368,7 @@ out_unreg_blkdev:
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 out_put_disk:
 	while (dr--) {
-		del_timer(&motor_off_timer[dr]);
+		del_timer_sync(&motor_off_timer[dr]);
 		if (disks[dr]->queue)
 			blk_cleanup_queue(disks[dr]->queue);
 		put_disk(disks[dr]);
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index 9e40b28..00c57c9 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -46,7 +46,7 @@
 
 #define DRV_PFX "xen-blkback:"
 #define DPRINTK(fmt, args...)				\
-	pr_debug(DRV_PFX "(%s:%d) " fmt ".\n",	\
+	pr_debug(DRV_PFX "(%s:%d) " fmt ".\n",		\
 		 __func__, __LINE__, ##args)
 
 
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 3f129b4..5fd2010 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -590,7 +590,7 @@ static void frontend_changed(struct xenbus_device *dev,
 
 		/*
 		 * Enforce precondition before potential leak point.
-		 * blkif_disconnect() is idempotent.
+		 * xen_blkif_disconnect() is idempotent.
 		 */
 		xen_blkif_disconnect(be->blkif);
 
@@ -601,17 +601,17 @@ static void frontend_changed(struct xenbus_device *dev,
 		break;
 
 	case XenbusStateClosing:
-		xen_blkif_disconnect(be->blkif);
 		xenbus_switch_state(dev, XenbusStateClosing);
 		break;
 
 	case XenbusStateClosed:
+		xen_blkif_disconnect(be->blkif);
 		xenbus_switch_state(dev, XenbusStateClosed);
 		if (xenbus_dev_is_online(dev))
 			break;
 		/* fall through if not online */
 	case XenbusStateUnknown:
-		/* implies blkif_disconnect() via blkback_remove() */
+		/* implies xen_blkif_disconnect() via xen_blkbk_remove() */
 		device_unregister(&dev->dev);
 		break;
 
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 1ff5486..4c1a648 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -926,6 +926,9 @@ static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
 	/*
 	 * Reliable writes are used to implement Forced Unit Access and
 	 * REQ_META accesses, and are supported only on MMCs.
+	 *
+	 * XXX: this really needs a good explanation of why REQ_META
+	 * is treated special.
 	 */
 	bool do_rel_wr = ((req->cmd_flags & REQ_FUA) ||
 			  (req->cmd_flags & REQ_META)) &&
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 04da6ac..12661e1 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1134,7 +1134,7 @@ struct buffer_head *ext3_bread(handle_t *handle, struct inode *inode,
 		return bh;
 	if (buffer_uptodate(bh))
 		return bh;
-	ll_rw_block(READ_META, 1, &bh);
+	ll_rw_block(READ | REQ_META | REQ_PRIO, 1, &bh);
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
 		return bh;
@@ -2807,7 +2807,7 @@ make_io:
 		trace_ext3_load_inode(inode);
 		get_bh(bh);
 		bh->b_end_io = end_buffer_read_sync;
-		submit_bh(READ_META, bh);
+		submit_bh(READ | REQ_META | REQ_PRIO, bh);
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh)) {
 			ext3_error(inode->i_sb, "ext3_get_inode_loc",
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 5571708..0629e09 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -922,7 +922,8 @@ restart:
 				bh = ext3_getblk(NULL, dir, b++, 0, &err);
 				bh_use[ra_max] = bh;
 				if (bh)
-					ll_rw_block(READ_META, 1, &bh);
+					ll_rw_block(READ | REQ_META | REQ_PRIO,
+						    1, &bh);
 			}
 		}
 		if ((bh = bh_use[ra_ptr++]) == NULL)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c4da98a..c7cbb3d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -650,7 +650,7 @@ struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
 		return bh;
 	if (buffer_uptodate(bh))
 		return bh;
-	ll_rw_block(READ_META, 1, &bh);
+	ll_rw_block(READ | REQ_META | REQ_PRIO, 1, &bh);
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
 		return bh;
@@ -3301,7 +3301,7 @@ make_io:
 		trace_ext4_load_inode(inode);
 		get_bh(bh);
 		bh->b_end_io = end_buffer_read_sync;
-		submit_bh(READ_META, bh);
+		submit_bh(READ | REQ_META | REQ_PRIO, bh);
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh)) {
 			EXT4_ERROR_INODE_BLOCK(inode, block,
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index f8068c7..1c924fa 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -922,7 +922,8 @@ restart:
 				bh = ext4_getblk(NULL, dir, b++, 0, &err);
 				bh_use[ra_max] = bh;
 				if (bh)
-					ll_rw_block(READ_META, 1, &bh);
+					ll_rw_block(READ | REQ_META | REQ_PRIO,
+						    1, &bh);
 			}
 		}
 		if ((bh = bh_use[ra_ptr++]) == NULL)
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 85c6292..5986464 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -624,9 +624,9 @@ static void log_write_header(struct gfs2_sbd *sdp, u32 flags, int pull)
 	bh->b_end_io = end_buffer_write_sync;
 	get_bh(bh);
 	if (test_bit(SDF_NOBARRIERS, &sdp->sd_flags))
-		submit_bh(WRITE_SYNC | REQ_META, bh);
+		submit_bh(WRITE_SYNC | REQ_META | REQ_PRIO, bh);
 	else
-		submit_bh(WRITE_FLUSH_FUA | REQ_META, bh);
+		submit_bh(WRITE_FLUSH_FUA | REQ_META | REQ_PRIO, bh);
 	wait_on_buffer(bh);
 
 	if (!buffer_uptodate(bh))
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 747238c..be29858 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -37,7 +37,7 @@ static int gfs2_aspace_writepage(struct page *page, struct writeback_control *wb
 {
 	struct buffer_head *bh, *head;
 	int nr_underway = 0;
-	int write_op = REQ_META |
+	int write_op = REQ_META | REQ_PRIO |
 		(wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE);
 
 	BUG_ON(!PageLocked(page));
@@ -225,7 +225,7 @@ int gfs2_meta_read(struct gfs2_glock *gl, u64 blkno, int flags,
 	}
 	bh->b_end_io = end_buffer_read_sync;
 	get_bh(bh);
-	submit_bh(READ_SYNC | REQ_META, bh);
+	submit_bh(READ_SYNC | REQ_META | REQ_PRIO, bh);
 	if (!(flags & DIO_WAIT))
 		return 0;
 
@@ -435,7 +435,7 @@ struct buffer_head *gfs2_meta_ra(struct gfs2_glock *gl, u64 dblock, u32 extlen)
 	if (buffer_uptodate(first_bh))
 		goto out;
 	if (!buffer_locked(first_bh))
-		ll_rw_block(READ_SYNC | REQ_META, 1, &first_bh);
+		ll_rw_block(READ_SYNC | REQ_META | REQ_PRIO, 1, &first_bh);
 
 	dblock++;
 	extlen--;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 3bc073a..079587e 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -224,7 +224,7 @@ static int gfs2_read_super(struct gfs2_sbd *sdp, sector_t sector, int silent)
 
 	bio->bi_end_io = end_bio_io_page;
 	bio->bi_private = page;
-	submit_bio(READ_SYNC | REQ_META, bio);
+	submit_bio(READ_SYNC | REQ_META | REQ_PRIO, bio);
 	wait_on_page_locked(page);
 	bio_put(bio);
 	if (!PageUptodate(page)) {
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 42e8d23..0e8bb13 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -709,7 +709,7 @@ get_a_page:
 		set_buffer_uptodate(bh);
 
 	if (!buffer_uptodate(bh)) {
-		ll_rw_block(READ_META, 1, &bh);
+		ll_rw_block(READ | REQ_META | REQ_PRIO, 1, &bh);
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh))
 			goto unlock_out;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 32f0076..71fc53b 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -124,6 +124,7 @@ enum rq_flag_bits {
 
 	__REQ_SYNC,		/* request is sync (sync write or read) */
 	__REQ_META,		/* metadata io request */
+	__REQ_PRIO,		/* boost priority in cfq */
 	__REQ_DISCARD,		/* request to discard sectors */
 	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
 
@@ -161,14 +162,15 @@ enum rq_flag_bits {
 #define REQ_FAILFAST_DRIVER	(1 << __REQ_FAILFAST_DRIVER)
 #define REQ_SYNC		(1 << __REQ_SYNC)
 #define REQ_META		(1 << __REQ_META)
+#define REQ_PRIO		(1 << __REQ_PRIO)
 #define REQ_DISCARD		(1 << __REQ_DISCARD)
 #define REQ_NOIDLE		(1 << __REQ_NOIDLE)
 
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
 #define REQ_COMMON_MASK \
-	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_DISCARD | \
-	 REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE)
+	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_PRIO | \
+	 REQ_DISCARD | REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
 #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 84b15d5..7fbaa91 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -873,7 +873,6 @@ struct blk_plug {
 	struct list_head list;
 	struct list_head cb_list;
 	unsigned int should_sort;
-	unsigned int count;
 };
 #define BLK_MAX_REQUEST_COUNT 16
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 178cdb4..eae44c9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -162,10 +162,8 @@ struct inodes_stat_t {
 #define READA			RWA_MASK
 
 #define READ_SYNC		(READ | REQ_SYNC)
-#define READ_META		(READ | REQ_META)
 #define WRITE_SYNC		(WRITE | REQ_SYNC | REQ_NOIDLE)
 #define WRITE_ODIRECT		(WRITE | REQ_SYNC)
-#define WRITE_META		(WRITE | REQ_META)
 #define WRITE_FLUSH		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FLUSH)
 #define WRITE_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FUA)
 #define WRITE_FLUSH_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index d6edf8d..a87da52 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -359,6 +359,17 @@ static unsigned long bdi_longest_inactive(void)
 	return max(5UL * 60 * HZ, interval);
 }
 
+/*
+ * Clear pending bit and wakeup anybody waiting for flusher thread creation or
+ * shutdown
+ */
+static void bdi_clear_pending(struct backing_dev_info *bdi)
+{
+	clear_bit(BDI_pending, &bdi->state);
+	smp_mb__after_clear_bit();
+	wake_up_bit(&bdi->state, BDI_pending);
+}
+
 static int bdi_forker_thread(void *ptr)
 {
 	struct bdi_writeback *me = ptr;
@@ -390,6 +401,13 @@ static int bdi_forker_thread(void *ptr)
 		}
 
 		spin_lock_bh(&bdi_lock);
+		/*
+		 * In the following loop we are going to check whether we have
+		 * some work to do without any synchronization with tasks
+		 * waking us up to do work for them. So we have to set task
+		 * state already here so that we don't miss wakeups coming
+		 * after we verify some condition.
+		 */
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		list_for_each_entry(bdi, &bdi_list, bdi_list) {
@@ -469,11 +487,13 @@ static int bdi_forker_thread(void *ptr)
 				spin_unlock_bh(&bdi->wb_lock);
 				wake_up_process(task);
 			}
+			bdi_clear_pending(bdi);
 			break;
 
 		case KILL_THREAD:
 			__set_current_state(TASK_RUNNING);
 			kthread_stop(task);
+			bdi_clear_pending(bdi);
 			break;
 
 		case NO_ACTION:
@@ -489,16 +509,8 @@ static int bdi_forker_thread(void *ptr)
 			else
 				schedule_timeout(msecs_to_jiffies(dirty_writeback_interval * 10));
 			try_to_freeze();
-			/* Back to the main loop */
-			continue;
+			break;
 		}
-
-		/*
-		 * Clear pending bit and wakeup anybody waiting to tear us down.
-		 */
-		clear_bit(BDI_pending, &bdi->state);
-		smp_mb__after_clear_bit();
-		wake_up_bit(&bdi->state, BDI_pending);
 	}
 
 	return 0;

  
-- 
Jens Axboe

