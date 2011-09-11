Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250Ab1IKOvd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 10:51:33 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44233
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754499Ab1IKOva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 10:51:30 -0400
Date: Sun, 11 Sep 2011 10:51:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] block: remove support for bio remapping from
 ->make_request
Message-ID: <20110911145129.GA29504@infradead.org>
References: <20110911145053.GA28996@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110911145053.GA28996@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is very little benefit in allowing to let a ->make_request instance update
the bios device and sector and loop around it in __generic_make_request when
we can archive the same through calling generic_make_request from the driver
and letting the loop in generic_make_request handle it.

Note that various drivers got the return value from ->make_request and returned
non-zero values for errors.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/m68k/emu/nfblock.c
===================================================================
--- linux-2.6.orig/arch/m68k/emu/nfblock.c	2011-09-08 12:01:53.000000000 +0200
+++ linux-2.6/arch/m68k/emu/nfblock.c	2011-09-08 13:46:07.993865436 +0200
@@ -59,7 +59,7 @@ struct nfhd_device {
 	struct gendisk *disk;
 };
 
-static int nfhd_make_request(struct request_queue *queue, struct bio *bio)
+static void nfhd_make_request(struct request_queue *queue, struct bio *bio)
 {
 	struct nfhd_device *dev = queue->queuedata;
 	struct bio_vec *bvec;
@@ -76,7 +76,6 @@ static int nfhd_make_request(struct requ
 		sec += len;
 	}
 	bio_endio(bio, 0);
-	return 0;
 }
 
 static int nfhd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
Index: linux-2.6/arch/powerpc/sysdev/axonram.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/axonram.c	2011-09-08 12:01:53.000000000 +0200
+++ linux-2.6/arch/powerpc/sysdev/axonram.c	2011-09-08 13:46:07.985864438 +0200
@@ -104,7 +104,7 @@ axon_ram_irq_handler(int irq, void *dev)
  * axon_ram_make_request - make_request() method for block device
  * @queue, @bio: see blk_queue_make_request()
  */
-static int
+static void
 axon_ram_make_request(struct request_queue *queue, struct bio *bio)
 {
 	struct axon_ram_bank *bank = bio->bi_bdev->bd_disk->private_data;
@@ -113,7 +113,6 @@ axon_ram_make_request(struct request_que
 	struct bio_vec *vec;
 	unsigned int transfered;
 	unsigned short idx;
-	int rc = 0;
 
 	phys_mem = bank->io_addr + (bio->bi_sector << AXON_RAM_SECTOR_SHIFT);
 	phys_end = bank->io_addr + bank->size;
@@ -121,8 +120,7 @@ axon_ram_make_request(struct request_que
 	bio_for_each_segment(vec, bio, idx) {
 		if (unlikely(phys_mem + vec->bv_len > phys_end)) {
 			bio_io_error(bio);
-			rc = -ERANGE;
-			break;
+			return;
 		}
 
 		user_mem = page_address(vec->bv_page) + vec->bv_offset;
@@ -135,8 +133,6 @@ axon_ram_make_request(struct request_que
 		transfered += vec->bv_len;
 	}
 	bio_endio(bio, 0);
-
-	return rc;
 }
 
 /**
Index: linux-2.6/drivers/block/aoe/aoeblk.c
===================================================================
--- linux-2.6.orig/drivers/block/aoe/aoeblk.c	2011-09-08 12:01:53.000000000 +0200
+++ linux-2.6/drivers/block/aoe/aoeblk.c	2011-09-08 13:46:08.009865290 +0200
@@ -159,7 +159,7 @@ aoeblk_release(struct gendisk *disk, fmo
 	return 0;
 }
 
-static int
+static void
 aoeblk_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct sk_buff_head queue;
@@ -172,25 +172,25 @@ aoeblk_make_request(struct request_queue
 	if (bio == NULL) {
 		printk(KERN_ERR "aoe: bio is NULL\n");
 		BUG();
-		return 0;
+		return;
 	}
 	d = bio->bi_bdev->bd_disk->private_data;
 	if (d == NULL) {
 		printk(KERN_ERR "aoe: bd_disk->private_data is NULL\n");
 		BUG();
 		bio_endio(bio, -ENXIO);
-		return 0;
+		return;
 	} else if (bio->bi_io_vec == NULL) {
 		printk(KERN_ERR "aoe: bi_io_vec is NULL\n");
 		BUG();
 		bio_endio(bio, -ENXIO);
-		return 0;
+		return;
 	}
 	buf = mempool_alloc(d->bufpool, GFP_NOIO);
 	if (buf == NULL) {
 		printk(KERN_INFO "aoe: buf allocation failure\n");
 		bio_endio(bio, -ENOMEM);
-		return 0;
+		return;
 	}
 	memset(buf, 0, sizeof(*buf));
 	INIT_LIST_HEAD(&buf->bufs);
@@ -211,7 +211,7 @@ aoeblk_make_request(struct request_queue
 		spin_unlock_irqrestore(&d->lock, flags);
 		mempool_free(buf, d->bufpool);
 		bio_endio(bio, -ENXIO);
-		return 0;
+		return;
 	}
 
 	list_add_tail(&buf->bufs, &d->bufq);
@@ -222,8 +222,6 @@ aoeblk_make_request(struct request_queue
 
 	spin_unlock_irqrestore(&d->lock, flags);
 	aoenet_xmit(&queue);
-
-	return 0;
 }
 
 static int
Index: linux-2.6/drivers/block/brd.c
===================================================================
--- linux-2.6.orig/drivers/block/brd.c	2011-09-08 12:01:53.000000000 +0200
+++ linux-2.6/drivers/block/brd.c	2011-09-08 13:46:08.017865926 +0200
@@ -323,7 +323,7 @@ out:
 	return err;
 }
 
-static int brd_make_request(struct request_queue *q, struct bio *bio)
+static void brd_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct block_device *bdev = bio->bi_bdev;
 	struct brd_device *brd = bdev->bd_disk->private_data;
@@ -359,8 +359,6 @@ static int brd_make_request(struct reque
 
 out:
 	bio_endio(bio, err);
-
-	return 0;
 }
 
 #ifdef CONFIG_BLK_DEV_XIP
Index: linux-2.6/drivers/block/drbd/drbd_int.h
===================================================================
--- linux-2.6.orig/drivers/block/drbd/drbd_int.h	2011-09-08 12:01:53.000000000 +0200
+++ linux-2.6/drivers/block/drbd/drbd_int.h	2011-09-08 12:05:58.560289507 +0200
@@ -1507,7 +1507,7 @@ extern void drbd_free_mdev(struct drbd_c
 extern int proc_details;
 
 /* drbd_req */
-extern int drbd_make_request(struct request_queue *q, struct bio *bio);
+extern void drbd_make_request(struct request_queue *q, struct bio *bio);
 extern int drbd_read_remote(struct drbd_conf *mdev, struct drbd_request *req);
 extern int drbd_merge_bvec(struct request_queue *q, struct bvec_merge_data *bvm, struct bio_vec *bvec);
 extern int is_valid_ar_handle(struct drbd_request *, sector_t);
Index: linux-2.6/drivers/block/drbd/drbd_req.c
===================================================================
--- linux-2.6.orig/drivers/block/drbd/drbd_req.c	2011-09-08 12:01:53.000000000 +0200
+++ linux-2.6/drivers/block/drbd/drbd_req.c	2011-09-08 12:05:58.564273023 +0200
@@ -1073,7 +1077,7 @@ static int drbd_fail_request_early(struc
 	return 0;
 }
 
-int drbd_make_request(struct request_queue *q, struct bio *bio)
+void drbd_make_request(struct request_queue *q, struct bio *bio)
 {
 	unsigned int s_enr, e_enr;
 	struct drbd_conf *mdev = (struct drbd_conf *) q->queuedata;
@@ -1081,7 +1085,7 @@ int drbd_make_request(struct request_que
 
 	if (drbd_fail_request_early(mdev, bio_data_dir(bio) & WRITE)) {
 		bio_endio(bio, -EPERM);
-		return 0;
+		return;
 	}
 
 	start_time = jiffies;
@@ -1100,7 +1104,8 @@ int drbd_make_request(struct request_que
 
 	if (likely(s_enr == e_enr)) {
 		inc_ap_bio(mdev, 1);
-		return drbd_make_request_common(mdev, bio, start_time);
+		drbd_make_request_common(mdev, bio, start_time);
+		return;
 	}
 
 	/* can this bio be split generically?
@@ -1148,7 +1153,6 @@ int drbd_make_request(struct request_que
 
 		bio_pair_release(bp);
 	}
-	return 0;
 }
 
 /* This is called by bio_add_page().  With this function we reduce
Index: linux-2.6/drivers/block/loop.c
===================================================================
--- linux-2.6.orig/drivers/block/loop.c	2011-09-08 12:01:53.000000000 +0200
+++ linux-2.6/drivers/block/loop.c	2011-09-08 13:46:08.037866440 +0200
@@ -514,7 +514,7 @@ static struct bio *loop_get_bio(struct l
 	return bio_list_pop(&lo->lo_bio_list);
 }
 
-static int loop_make_request(struct request_queue *q, struct bio *old_bio)
+static void loop_make_request(struct request_queue *q, struct bio *old_bio)
 {
 	struct loop_device *lo = q->queuedata;
 	int rw = bio_rw(old_bio);
@@ -532,12 +532,11 @@ static int loop_make_request(struct requ
 	loop_add_bio(lo, old_bio);
 	wake_up(&lo->lo_event);
 	spin_unlock_irq(&lo->lo_lock);
-	return 0;
+	return;
 
 out:
 	spin_unlock_irq(&lo->lo_lock);
 	bio_io_error(old_bio);
-	return 0;
 }
 
 struct switch_request {
Index: linux-2.6/drivers/block/pktcdvd.c
===================================================================
--- linux-2.6.orig/drivers/block/pktcdvd.c	2011-09-08 12:01:53.000000000 +0200
+++ linux-2.6/drivers/block/pktcdvd.c	2011-09-08 13:46:08.041865904 +0200
@@ -2444,7 +2444,7 @@ static void pkt_end_io_read_cloned(struc
 	pkt_bio_finished(pd);
 }
 
-static int pkt_make_request(struct request_queue *q, struct bio *bio)
+static void pkt_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct pktcdvd_device *pd;
 	char b[BDEVNAME_SIZE];
@@ -2473,7 +2473,7 @@ static int pkt_make_request(struct reque
 		cloned_bio->bi_end_io = pkt_end_io_read_cloned;
 		pd->stats.secs_r += bio->bi_size >> 9;
 		pkt_queue_bio(pd, cloned_bio);
-		return 0;
+		return;
 	}
 
 	if (!test_bit(PACKET_WRITABLE, &pd->flags)) {
@@ -2509,7 +2509,7 @@ static int pkt_make_request(struct reque
 			pkt_make_request(q, &bp->bio1);
 			pkt_make_request(q, &bp->bio2);
 			bio_pair_release(bp);
-			return 0;
+			return;
 		}
 	}
 
@@ -2533,7 +2533,7 @@ static int pkt_make_request(struct reque
 				}
 				spin_unlock(&pkt->lock);
 				spin_unlock(&pd->cdrw.active_list_lock);
-				return 0;
+				return;
 			} else {
 				blocked_bio = 1;
 			}
@@ -2584,10 +2584,9 @@ static int pkt_make_request(struct reque
 		 */
 		wake_up(&pd->wqueue);
 	}
-	return 0;
+	return;
 end_io:
 	bio_io_error(bio);
-	return 0;
 }
 
 
Index: linux-2.6/drivers/block/ps3vram.c
===================================================================
--- linux-2.6.orig/drivers/block/ps3vram.c	2011-09-08 12:01:53.000000000 +0200
+++ linux-2.6/drivers/block/ps3vram.c	2011-09-08 13:46:08.049864488 +0200
@@ -596,7 +596,7 @@ out:
 	return next;
 }
 
-static int ps3vram_make_request(struct request_queue *q, struct bio *bio)
+static void ps3vram_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct ps3_system_bus_device *dev = q->queuedata;
 	struct ps3vram_priv *priv = ps3_system_bus_get_drvdata(dev);
@@ -610,13 +610,11 @@ static int ps3vram_make_request(struct r
 	spin_unlock_irq(&priv->lock);
 
 	if (busy)
-		return 0;
+		return;
 
 	do {
 		bio = ps3vram_do_bio(dev, bio);
 	} while (bio);
-
-	return 0;
 }
 
 static int __devinit ps3vram_probe(struct ps3_system_bus_device *dev)
Index: linux-2.6/drivers/block/umem.c
===================================================================
--- linux-2.6.orig/drivers/block/umem.c	2011-09-08 12:01:53.000000000 +0200
+++ linux-2.6/drivers/block/umem.c	2011-09-08 13:46:08.065865586 +0200
@@ -513,7 +513,7 @@ static void process_page(unsigned long d
 	}
 }
 
-static int mm_make_request(struct request_queue *q, struct bio *bio)
+static void mm_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct cardinfo *card = q->queuedata;
 	pr_debug("mm_make_request %llu %u\n",
@@ -525,7 +525,7 @@ static int mm_make_request(struct reques
 	card->biotail = &bio->bi_next;
 	spin_unlock_irq(&card->lock);
 
-	return 0;
+	return;
 }
 
 static irqreturn_t mm_interrupt(int irq, void *__card)
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2011-09-08 12:05:02.000000000 +0200
+++ linux-2.6/drivers/md/dm.c	2011-09-08 13:46:08.101867184 +0200
@@ -1388,7 +1388,7 @@ out:
  * The request function that just remaps the bio built up by
  * dm_merge_bvec.
  */
-static int _dm_request(struct request_queue *q, struct bio *bio)
+static void _dm_request(struct request_queue *q, struct bio *bio)
 {
 	int rw = bio_data_dir(bio);
 	struct mapped_device *md = q->queuedata;
@@ -1409,12 +1409,12 @@ static int _dm_request(struct request_qu
 			queue_io(md, bio);
 		else
 			bio_io_error(bio);
-		return 0;
+		return;
 	}
 
 	__split_and_process_bio(md, bio);
 	up_read(&md->io_lock);
-	return 0;
+	return;
 }
 
 static int dm_request_based(struct mapped_device *md)
@@ -1422,14 +1422,14 @@ static int dm_request_based(struct mappe
 	return blk_queue_stackable(md->queue);
 }
 
-static int dm_request(struct request_queue *q, struct bio *bio)
+static void dm_request(struct request_queue *q, struct bio *bio)
 {
 	struct mapped_device *md = q->queuedata;
 
 	if (dm_request_based(md))
-		return __make_request(q, bio);
-
-	return _dm_request(q, bio);
+		__make_request(q, bio);
+	else
+		_dm_request(q, bio);
 }
 
 void dm_dispatch_request(struct request *rq)
Index: linux-2.6/drivers/s390/block/dcssblk.c
===================================================================
--- linux-2.6.orig/drivers/s390/block/dcssblk.c	2011-09-08 12:01:53.000000000 +0200
+++ linux-2.6/drivers/s390/block/dcssblk.c	2011-09-08 13:46:08.073864338 +0200
@@ -27,7 +27,7 @@
 
 static int dcssblk_open(struct block_device *bdev, fmode_t mode);
 static int dcssblk_release(struct gendisk *disk, fmode_t mode);
-static int dcssblk_make_request(struct request_queue *q, struct bio *bio);
+static void dcssblk_make_request(struct request_queue *q, struct bio *bio);
 static int dcssblk_direct_access(struct block_device *bdev, sector_t secnum,
 				 void **kaddr, unsigned long *pfn);
 
@@ -814,7 +814,7 @@ out:
 	return rc;
 }
 
-static int
+static void
 dcssblk_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct dcssblk_dev_info *dev_info;
@@ -871,10 +871,9 @@ dcssblk_make_request(struct request_queu
 		bytes_done += bvec->bv_len;
 	}
 	bio_endio(bio, 0);
-	return 0;
+	return;
 fail:
 	bio_io_error(bio);
-	return 0;
 }
 
 static int
Index: linux-2.6/drivers/s390/block/xpram.c
===================================================================
--- linux-2.6.orig/drivers/s390/block/xpram.c	2011-09-08 12:01:53.000000000 +0200
+++ linux-2.6/drivers/s390/block/xpram.c	2011-09-08 13:46:08.081866518 +0200
@@ -181,7 +181,7 @@ static unsigned long xpram_highest_page_
 /*
  * Block device make request function.
  */
-static int xpram_make_request(struct request_queue *q, struct bio *bio)
+static void xpram_make_request(struct request_queue *q, struct bio *bio)
 {
 	xpram_device_t *xdev = bio->bi_bdev->bd_disk->private_data;
 	struct bio_vec *bvec;
@@ -221,10 +221,9 @@ static int xpram_make_request(struct req
 	}
 	set_bit(BIO_UPTODATE, &bio->bi_flags);
 	bio_endio(bio, 0);
-	return 0;
+	return;
 fail:
 	bio_io_error(bio);
-	return 0;
 }
 
 static int xpram_getgeo(struct block_device *bdev, struct hd_geometry *geo)
Index: linux-2.6/drivers/staging/zram/zram_drv.c
===================================================================
--- linux-2.6.orig/drivers/staging/zram/zram_drv.c	2011-09-08 12:01:53.000000000 +0200
+++ linux-2.6/drivers/staging/zram/zram_drv.c	2011-09-08 13:46:08.109866400 +0200
@@ -556,24 +556,22 @@ static inline int valid_io_request(struc
 /*
  * Handler function for all zram I/O requests.
  */
-static int zram_make_request(struct request_queue *queue, struct bio *bio)
+static void zram_make_request(struct request_queue *queue, struct bio *bio)
 {
 	struct zram *zram = queue->queuedata;
 
 	if (!valid_io_request(zram, bio)) {
 		zram_stat64_inc(zram, &zram->stats.invalid_io);
 		bio_io_error(bio);
-		return 0;
+		return;
 	}
 
 	if (unlikely(!zram->init_done) && zram_init_device(zram)) {
 		bio_io_error(bio);
-		return 0;
+		return;
 	}
 
 	__zram_make_request(zram, bio, bio_data_dir(bio));
-
-	return 0;
 }
 
 void zram_reset_device(struct zram *zram)
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2011-09-08 12:02:33.000000000 +0200
+++ linux-2.6/include/linux/blkdev.h	2011-09-08 13:46:08.117866175 +0200
@@ -195,7 +195,7 @@ struct request_pm_state
 #include <linux/elevator.h>
 
 typedef void (request_fn_proc) (struct request_queue *q);
-typedef int (make_request_fn) (struct request_queue *q, struct bio *bio);
+typedef void (make_request_fn) (struct request_queue *q, struct bio *bio);
 typedef int (prep_rq_fn) (struct request_queue *, struct request *);
 typedef void (unprep_rq_fn) (struct request_queue *, struct request *);
 
@@ -680,7 +680,7 @@ extern int scsi_cmd_ioctl(struct request
 extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 			 struct scsi_ioctl_command __user *);
 
-extern int __make_request(struct request_queue *q, struct bio *bio);
+extern void __make_request(struct request_queue *q, struct bio *bio);
 
 /*
  * A queue has just exitted congestion.  Note this in the global counter of
Index: linux-2.6/drivers/md/faulty.c
===================================================================
--- linux-2.6.orig/drivers/md/faulty.c	2011-09-08 12:01:53.000000000 +0200
+++ linux-2.6/drivers/md/faulty.c	2011-09-08 12:05:58.602773802 +0200
@@ -169,7 +169,7 @@ static void add_sector(conf_t *conf, sec
 		conf->nfaults = n+1;
 }
 
-static int make_request(mddev_t *mddev, struct bio *bio)
+static void make_request(mddev_t *mddev, struct bio *bio)
 {
 	conf_t *conf = mddev->private;
 	int failit = 0;
@@ -181,7 +181,7 @@ static int make_request(mddev_t *mddev,
 			 * just fail immediately
 			 */
 			bio_endio(bio, -EIO);
-			return 0;
+			return;
 		}
 
 		if (check_sector(conf, bio->bi_sector, bio->bi_sector+(bio->bi_size>>9),
@@ -214,12 +214,11 @@ static int make_request(mddev_t *mddev,
 		b->bi_bdev = conf->rdev->bdev;
 		b->bi_private = bio;
 		b->bi_end_io = faulty_fail;
-		generic_make_request(b);
-		return 0;
 	} else {
 		bio->bi_bdev = conf->rdev->bdev;
-		return 1;
 	}
+
+	generic_make_request(b);
 }
 
 static void status(struct seq_file *seq, mddev_t *mddev)
Index: linux-2.6/drivers/md/linear.c
===================================================================
--- linux-2.6.orig/drivers/md/linear.c	2011-09-08 12:01:53.000000000 +0200
+++ linux-2.6/drivers/md/linear.c	2011-09-08 12:05:58.602773802 +0200
@@ -264,14 +264,14 @@ static int linear_stop (mddev_t *mddev)
 	return 0;
 }
 
-static int linear_make_request (mddev_t *mddev, struct bio *bio)
+static void linear_make_request (mddev_t *mddev, struct bio *bio)
 {
 	dev_info_t *tmp_dev;
 	sector_t start_sector;
 
 	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
 		md_flush_request(mddev, bio);
-		return 0;
+		return;
 	}
 
 	rcu_read_lock();
@@ -293,7 +293,7 @@ static int linear_make_request (mddev_t
 		       (unsigned long long)start_sector);
 		rcu_read_unlock();
 		bio_io_error(bio);
-		return 0;
+		return;
 	}
 	if (unlikely(bio->bi_sector + (bio->bi_size >> 9) >
 		     tmp_dev->end_sector)) {
@@ -307,20 +307,17 @@ static int linear_make_request (mddev_t
 
 		bp = bio_split(bio, end_sector - bio->bi_sector);
 
-		if (linear_make_request(mddev, &bp->bio1))
-			generic_make_request(&bp->bio1);
-		if (linear_make_request(mddev, &bp->bio2))
-			generic_make_request(&bp->bio2);
+		linear_make_request(mddev, &bp->bio1);
+		linear_make_request(mddev, &bp->bio2);
 		bio_pair_release(bp);
-		return 0;
+		return;
 	}
 		    
 	bio->bi_bdev = tmp_dev->rdev->bdev;
 	bio->bi_sector = bio->bi_sector - start_sector
 		+ tmp_dev->rdev->data_offset;
 	rcu_read_unlock();
-
-	return 1;
+	generic_make_request(bio);
 }
 
 static void linear_status (struct seq_file *seq, mddev_t *mddev)
Index: linux-2.6/drivers/md/multipath.c
===================================================================
--- linux-2.6.orig/drivers/md/multipath.c	2011-09-08 12:01:53.000000000 +0200
+++ linux-2.6/drivers/md/multipath.c	2011-09-08 12:05:58.606775620 +0200
@@ -106,7 +106,7 @@ static void multipath_end_request(struct
 	rdev_dec_pending(rdev, conf->mddev);
 }
 
-static int multipath_make_request(mddev_t *mddev, struct bio * bio)
+static void multipath_make_request(mddev_t *mddev, struct bio * bio)
 {
 	multipath_conf_t *conf = mddev->private;
 	struct multipath_bh * mp_bh;
@@ -114,7 +114,7 @@ static int multipath_make_request(mddev_
 
 	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
 		md_flush_request(mddev, bio);
-		return 0;
+		return;
 	}
 
 	mp_bh = mempool_alloc(conf->pool, GFP_NOIO);
@@ -126,7 +126,7 @@ static int multipath_make_request(mddev_
 	if (mp_bh->path < 0) {
 		bio_endio(bio, -EIO);
 		mempool_free(mp_bh, conf->pool);
-		return 0;
+		return;
 	}
 	multipath = conf->multipaths + mp_bh->path;
 
@@ -137,7 +137,7 @@ static int multipath_make_request(mddev_
 	mp_bh->bio.bi_end_io = multipath_end_request;
 	mp_bh->bio.bi_private = mp_bh;
 	generic_make_request(&mp_bh->bio);
-	return 0;
+	return;
 }
 
 static void multipath_status (struct seq_file *seq, mddev_t *mddev)
Index: linux-2.6/drivers/md/raid0.c
===================================================================
--- linux-2.6.orig/drivers/md/raid0.c	2011-09-08 12:01:53.000000000 +0200
+++ linux-2.6/drivers/md/raid0.c	2011-09-08 12:05:58.614775973 +0200
@@ -466,7 +466,7 @@ static inline int is_io_in_chunk_boundar
 	}
 }
 
-static int raid0_make_request(mddev_t *mddev, struct bio *bio)
+static void raid0_make_request(mddev_t *mddev, struct bio *bio)
 {
 	unsigned int chunk_sects;
 	sector_t sector_offset;
@@ -475,7 +475,7 @@ static int raid0_make_request(mddev_t *m
 
 	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
 		md_flush_request(mddev, bio);
-		return 0;
+		return;
 	}
 
 	chunk_sects = mddev->chunk_sectors;
@@ -495,13 +495,10 @@ static int raid0_make_request(mddev_t *m
 		else
 			bp = bio_split(bio, chunk_sects -
 				       sector_div(sector, chunk_sects));
-		if (raid0_make_request(mddev, &bp->bio1))
-			generic_make_request(&bp->bio1);
-		if (raid0_make_request(mddev, &bp->bio2))
-			generic_make_request(&bp->bio2);
-
+		raid0_make_request(mddev, &bp->bio1);
+		raid0_make_request(mddev, &bp->bio2);
 		bio_pair_release(bp);
-		return 0;
+		return;
 	}
 
 	sector_offset = bio->bi_sector;
@@ -511,10 +508,9 @@ static int raid0_make_request(mddev_t *m
 	bio->bi_bdev = tmp_dev->bdev;
 	bio->bi_sector = sector_offset + zone->dev_start +
 		tmp_dev->data_offset;
-	/*
-	 * Let the main block layer submit the IO and resolve recursion:
-	 */
-	return 1;
+
+	generic_make_request(bio);
+	return;
 
 bad_map:
 	printk("md/raid0:%s: make_request bug: can't convert block across chunks"
@@ -523,7 +519,7 @@ bad_map:
 	       (unsigned long long)bio->bi_sector, bio->bi_size >> 10);
 
 	bio_io_error(bio);
-	return 0;
+	return;
 }
 
 static void raid0_status(struct seq_file *seq, mddev_t *mddev)
Index: linux-2.6/drivers/md/raid1.c
===================================================================
--- linux-2.6.orig/drivers/md/raid1.c	2011-09-08 12:01:53.000000000 +0200
+++ linux-2.6/drivers/md/raid1.c	2011-09-08 12:05:58.614775973 +0200
@@ -785,7 +785,7 @@ do_sync_io:
 	PRINTK("%dB behind alloc failed, doing sync I/O\n", bio->bi_size);
 }
 
-static int make_request(mddev_t *mddev, struct bio * bio)
+static void make_request(mddev_t *mddev, struct bio * bio)
 {
 	conf_t *conf = mddev->private;
 	mirror_info_t *mirror;
@@ -870,7 +870,7 @@ read_again:
 		if (rdisk < 0) {
 			/* couldn't find anywhere to read from */
 			raid_end_bio_io(r1_bio);
-			return 0;
+			return;
 		}
 		mirror = conf->mirrors + rdisk;
 
@@ -928,7 +928,7 @@ read_again:
 			goto read_again;
 		} else
 			generic_make_request(read_bio);
-		return 0;
+		return;
 	}
 
 	/*
@@ -1119,8 +1119,6 @@ read_again:
 
 	if (do_sync || !bitmap || !plugged)
 		md_wakeup_thread(mddev->thread);
-
-	return 0;
 }
 
 static void status(struct seq_file *seq, mddev_t *mddev)
Index: linux-2.6/drivers/md/raid10.c
===================================================================
--- linux-2.6.orig/drivers/md/raid10.c	2011-09-08 12:01:53.000000000 +0200
+++ linux-2.6/drivers/md/raid10.c	2011-09-08 12:05:58.618773608 +0200
@@ -825,7 +825,7 @@ static void unfreeze_array(conf_t *conf)
 	spin_unlock_irq(&conf->resync_lock);
 }
 
-static int make_request(mddev_t *mddev, struct bio * bio)
+static void make_request(mddev_t *mddev, struct bio * bio)
 {
 	conf_t *conf = mddev->private;
 	mirror_info_t *mirror;
@@ -844,7 +844,7 @@ static int make_request(mddev_t *mddev,
 
 	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
 		md_flush_request(mddev, bio);
-		return 0;
+		return;
 	}
 
 	/* If this request crosses a chunk boundary, we need to
@@ -876,10 +876,8 @@ static int make_request(mddev_t *mddev,
 		conf->nr_waiting++;
 		spin_unlock_irq(&conf->resync_lock);
 
-		if (make_request(mddev, &bp->bio1))
-			generic_make_request(&bp->bio1);
-		if (make_request(mddev, &bp->bio2))
-			generic_make_request(&bp->bio2);
+		make_request(mddev, &bp->bio1);
+		make_request(mddev, &bp->bio2);
 
 		spin_lock_irq(&conf->resync_lock);
 		conf->nr_waiting--;
@@ -887,14 +885,14 @@ static int make_request(mddev_t *mddev,
 		spin_unlock_irq(&conf->resync_lock);
 
 		bio_pair_release(bp);
-		return 0;
+		return;
 	bad_map:
 		printk("md/raid10:%s: make_request bug: can't convert block across chunks"
 		       " or bigger than %dk %llu %d\n", mdname(mddev), chunk_sects/2,
 		       (unsigned long long)bio->bi_sector, bio->bi_size >> 10);
 
 		bio_io_error(bio);
-		return 0;
+		return;
 	}
 
 	md_write_start(mddev, bio);
@@ -937,7 +935,7 @@ read_again:
 		slot = r10_bio->read_slot;
 		if (disk < 0) {
 			raid_end_bio_io(r10_bio);
-			return 0;
+			return;
 		}
 		mirror = conf->mirrors + disk;
 
@@ -985,7 +983,7 @@ read_again:
 			goto read_again;
 		} else
 			generic_make_request(read_bio);
-		return 0;
+		return;
 	}
 
 	/*
@@ -1157,7 +1155,6 @@ retry_write:
 
 	if (do_sync || !mddev->bitmap || !plugged)
 		md_wakeup_thread(mddev->thread);
-	return 0;
 }
 
 static void status(struct seq_file *seq, mddev_t *mddev)
Index: linux-2.6/drivers/md/raid5.c
===================================================================
--- linux-2.6.orig/drivers/md/raid5.c	2011-09-08 12:01:53.502775855 +0200
+++ linux-2.6/drivers/md/raid5.c	2011-09-08 12:05:58.622774752 +0200
@@ -3695,7 +3695,7 @@ static struct stripe_head *__get_priorit
 	return sh;
 }
 
-static int make_request(mddev_t *mddev, struct bio * bi)
+static void make_request(mddev_t *mddev, struct bio * bi)
 {
 	raid5_conf_t *conf = mddev->private;
 	int dd_idx;
@@ -3708,7 +3708,7 @@ static int make_request(mddev_t *mddev,
 
 	if (unlikely(bi->bi_rw & REQ_FLUSH)) {
 		md_flush_request(mddev, bi);
-		return 0;
+		return;
 	}
 
 	md_write_start(mddev, bi);
@@ -3716,7 +3716,7 @@ static int make_request(mddev_t *mddev,
 	if (rw == READ &&
 	     mddev->reshape_position == MaxSector &&
 	     chunk_aligned_read(mddev,bi))
-		return 0;
+		return;
 
 	logical_sector = bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	last_sector = bi->bi_sector + (bi->bi_size>>9);
@@ -3851,8 +3851,6 @@ static int make_request(mddev_t *mddev,
 
 		bio_endio(bi, 0);
 	}
-
-	return 0;
 }
 
 static sector_t raid5_size(mddev_t *mddev, sector_t sectors, int raid_disks);
Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c	2011-09-08 12:03:25.422774199 +0200
+++ linux-2.6/block/blk-core.c	2011-09-08 13:46:08.165866669 +0200
@@ -1211,7 +1211,7 @@ void init_request_from_bio(struct reques
 	blk_rq_bio_prep(req->q, req, bio);
 }
 
-int __make_request(struct request_queue *q, struct bio *bio)
+void __make_request(struct request_queue *q, struct bio *bio)
 {
 	const bool sync = !!(bio->bi_rw & REQ_SYNC);
 	struct blk_plug *plug;
@@ -1236,7 +1236,7 @@ int __make_request(struct request_queue
 	 * any locks.
 	 */
 	if (attempt_plug_merge(current, q, bio))
-		goto out;
+		return;
 
 	spin_lock_irq(q->queue_lock);
 
@@ -1312,8 +1312,6 @@ get_rq:
 out_unlock:
 		spin_unlock_irq(q->queue_lock);
 	}
-out:
-	return 0;
 }
 EXPORT_SYMBOL_GPL(__make_request);	/* for device mapper only */
 
@@ -1441,112 +1439,85 @@ static inline int bio_check_eod(struct b
 static inline void __generic_make_request(struct bio *bio)
 {
 	struct request_queue *q;
-	sector_t old_sector;
-	int ret, nr_sectors = bio_sectors(bio);
-	dev_t old_dev;
+	int nr_sectors = bio_sectors(bio);
 	int err = -EIO;
+	char b[BDEVNAME_SIZE];
+	struct hd_struct *part;
 
 	might_sleep();
 
 	if (bio_check_eod(bio, nr_sectors))
 		goto end_io;
 
-	/*
-	 * Resolve the mapping until finished. (drivers are
-	 * still free to implement/resolve their own stacking
-	 * by explicitly returning 0)
-	 *
-	 * NOTE: we don't repeat the blk_size check for each new device.
-	 * Stacking drivers are expected to know what they are doing.
-	 */
-	old_sector = -1;
-	old_dev = 0;
-	do {
-		char b[BDEVNAME_SIZE];
-		struct hd_struct *part;
-
-		q = bdev_get_queue(bio->bi_bdev);
-		if (unlikely(!q)) {
-			printk(KERN_ERR
-			       "generic_make_request: Trying to access "
-				"nonexistent block-device %s (%Lu)\n",
-				bdevname(bio->bi_bdev, b),
-				(long long) bio->bi_sector);
-			goto end_io;
-		}
-
-		if (unlikely(!(bio->bi_rw & REQ_DISCARD) &&
-			     nr_sectors > queue_max_hw_sectors(q))) {
-			printk(KERN_ERR "bio too big device %s (%u > %u)\n",
-			       bdevname(bio->bi_bdev, b),
-			       bio_sectors(bio),
-			       queue_max_hw_sectors(q));
-			goto end_io;
-		}
-
-		if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
-			goto end_io;
-
-		part = bio->bi_bdev->bd_part;
-		if (should_fail_request(part, bio->bi_size) ||
-		    should_fail_request(&part_to_disk(part)->part0,
-					bio->bi_size))
-			goto end_io;
+	q = bdev_get_queue(bio->bi_bdev);
+	if (unlikely(!q)) {
+		printk(KERN_ERR
+		       "generic_make_request: Trying to access "
+			"nonexistent block-device %s (%Lu)\n",
+			bdevname(bio->bi_bdev, b),
+			(long long) bio->bi_sector);
+		goto end_io;
+	}
 
-		/*
-		 * If this device has partitions, remap block n
-		 * of partition p to block n+start(p) of the disk.
-		 */
-		blk_partition_remap(bio);
+	if (unlikely(!(bio->bi_rw & REQ_DISCARD) &&
+		     nr_sectors > queue_max_hw_sectors(q))) {
+		printk(KERN_ERR "bio too big device %s (%u > %u)\n",
+		       bdevname(bio->bi_bdev, b),
+		       bio_sectors(bio),
+		       queue_max_hw_sectors(q));
+		goto end_io;
+	}
 
-		if (bio_integrity_enabled(bio) && bio_integrity_prep(bio))
-			goto end_io;
+	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
+		goto end_io;
 
-		if (old_sector != -1)
-			trace_block_bio_remap(q, bio, old_dev, old_sector);
+	part = bio->bi_bdev->bd_part;
+	if (should_fail_request(part, bio->bi_size) ||
+	    should_fail_request(&part_to_disk(part)->part0,
+				bio->bi_size))
+		goto end_io;
 
-		old_sector = bio->bi_sector;
-		old_dev = bio->bi_bdev->bd_dev;
+	/*
+	 * If this device has partitions, remap block n
+	 * of partition p to block n+start(p) of the disk.
+	 */
+	blk_partition_remap(bio);
 
-		if (bio_check_eod(bio, nr_sectors))
-			goto end_io;
+	if (bio_integrity_enabled(bio) && bio_integrity_prep(bio))
+		goto end_io;
 
-		/*
-		 * Filter flush bio's early so that make_request based
-		 * drivers without flush support don't have to worry
-		 * about them.
-		 */
-		if ((bio->bi_rw & (REQ_FLUSH | REQ_FUA)) && !q->flush_flags) {
-			bio->bi_rw &= ~(REQ_FLUSH | REQ_FUA);
-			if (!nr_sectors) {
-				err = 0;
-				goto end_io;
-			}
-		}
+	if (bio_check_eod(bio, nr_sectors))
+		goto end_io;
 
-		if ((bio->bi_rw & REQ_DISCARD) &&
-		    (!blk_queue_discard(q) ||
-		     ((bio->bi_rw & REQ_SECURE) &&
-		      !blk_queue_secdiscard(q)))) {
-			err = -EOPNOTSUPP;
+	/*
+	 * Filter flush bio's early so that make_request based
+	 * drivers without flush support don't have to worry
+	 * about them.
+	 */
+	if ((bio->bi_rw & (REQ_FLUSH | REQ_FUA)) && !q->flush_flags) {
+		bio->bi_rw &= ~(REQ_FLUSH | REQ_FUA);
+		if (!nr_sectors) {
+			err = 0;
 			goto end_io;
 		}
+	}
 
-		if (blk_throtl_bio(q, &bio))
-			goto end_io;
-
-		/*
-		 * If bio = NULL, bio has been throttled and will be submitted
-		 * later.
-		 */
-		if (!bio)
-			break;
-
-		trace_block_bio_queue(q, bio);
+	if ((bio->bi_rw & REQ_DISCARD) &&
+	    (!blk_queue_discard(q) ||
+	     ((bio->bi_rw & REQ_SECURE) &&
+	      !blk_queue_secdiscard(q)))) {
+		err = -EOPNOTSUPP;
+		goto end_io;
+	}
 
-		ret = q->make_request_fn(q, bio);
-	} while (ret);
+	if (blk_throtl_bio(q, &bio))
+		goto end_io;
 
+	/* if bio = NULL, bio has been throttled and will be submitted later. */
+	if (!bio)
+		return;
+	trace_block_bio_queue(q, bio);
+	q->make_request_fn(q, bio);
 	return;
 
 end_io:
Index: linux-2.6/drivers/md/md.h
===================================================================
--- linux-2.6.orig/drivers/md/md.h	2011-09-08 12:01:53.000000000 +0200
+++ linux-2.6/drivers/md/md.h	2011-09-08 12:05:58.630773689 +0200
@@ -424,7 +424,7 @@ struct mdk_personality
 	int level;
 	struct list_head list;
 	struct module *owner;
-	int (*make_request)(mddev_t *mddev, struct bio *bio);
+	void (*make_request)(mddev_t *mddev, struct bio *bio);
 	int (*run)(mddev_t *mddev);
 	int (*stop)(mddev_t *mddev);
 	void (*status)(struct seq_file *seq, mddev_t *mddev);
Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c	2011-09-08 12:01:53.000000000 +0200
+++ linux-2.6/drivers/md/md.c	2011-09-08 13:46:08.089865876 +0200
@@ -330,18 +330,17 @@ static DEFINE_SPINLOCK(all_mddevs_lock);
  * call has finished, the bio has been linked into some internal structure
  * and so is visible to ->quiesce(), so we don't need the refcount any more.
  */
-static int md_make_request(struct request_queue *q, struct bio *bio)
+static void md_make_request(struct request_queue *q, struct bio *bio)
 {
 	const int rw = bio_data_dir(bio);
 	mddev_t *mddev = q->queuedata;
-	int rv;
 	int cpu;
 	unsigned int sectors;
 
 	if (mddev == NULL || mddev->pers == NULL
 	    || !mddev->ready) {
 		bio_io_error(bio);
-		return 0;
+		return;
 	}
 	smp_rmb(); /* Ensure implications of  'active' are visible */
 	rcu_read_lock();
@@ -366,7 +365,7 @@ static int md_make_request(struct reques
 	 * go away inside make_request
 	 */
 	sectors = bio_sectors(bio);
-	rv = mddev->pers->make_request(mddev, bio);
+	mddev->pers->make_request(mddev, bio);
 
 	cpu = part_stat_lock();
 	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
@@ -375,8 +374,6 @@ static int md_make_request(struct reques
 
 	if (atomic_dec_and_test(&mddev->active_io) && mddev->suspended)
 		wake_up(&mddev->sb_wait);
-
-	return rv;
 }
 
 /* mddev_suspend makes sure no new requests are submitted
@@ -475,8 +472,7 @@ static void md_submit_flush_data(struct
 		bio_endio(bio, 0);
 	else {
 		bio->bi_rw &= ~REQ_FLUSH;
-		if (mddev->pers->make_request(mddev, bio))
-			generic_make_request(bio);
+		mddev->pers->make_request(mddev, bio);
 	}
 
 	mddev->flush_bio = NULL;
