Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030Ab0FVSAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 14:00:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab0FVSAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 14:00:45 -0400
Date: Tue, 22 Jun 2010 14:00:29 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, dm-devel@redhat.com, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH, RFC] block: don't allocate a payload for discard request
Message-ID: <20100622180029.GA15950@redhat.com>
References: <20100618145942.GA1148@lst.de>
 <20100619042534.GA16217@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100619042534.GA16217@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19 2010 at 12:25am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, Jun 18 2010 at 10:59am -0400,
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > 
> > Allocating a fixed payload for discard requests always was a horrible hack,
> > and it's not coming to byte us when adding support for discard in DM/MD.
> > 
> > So change the code to leave the allocation of a payload to the lowlevel
> > driver.  Unfortunately that means we'll need another hack, which allows
> > us to update the various block layer length fields indicating that we
> > have a payload.  Instead of hiding this in sd.c, which we already partially
> > do for UNMAP support add a documented helper in the core block layer for it.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Acked-by: Mike Snitzer <snitzer@redhat.com>
> 
> I've built on your patch to successfully implement discard support for
> DM (this includes splitting discards that span targets; only the linear
> and striped DM targets are supported so far).

I must retract my Acked-by because further testing has shown that this
change results in OOM (on 2.6.34 with postmark benchmarking against ext4
w/ -o discard).

The patch is _very_ desirable (simplifies DM's discard support, etc) but
there is more work needed to get it stable.  I'll continue tracking this
OOM down.

Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  91
CPU    1: hi:  186, btch:  31 usd:  92
active_anon:52 inactive_anon:65 isolated_anon:0
 active_file:525 inactive_file:1275 isolated_file:0
 unevictable:0 dirty:802 writeback:0 unstable:0
 free:3411 slab_reclaimable:5386 slab_unreclaimable:7672
 mapped:86 shmem:0 pagetables:576 bounce:0
Node 0 DMA free:8040kB min:40kB low:48kB high:60kB active_anon:0kB
inactive_anon:0kB active_file:12kB inactive_file:0kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:15768kB mlocked:0kB
dirty:0kB writeback:0kB mapped:8kB shmem:0kB slab_reclaimable:28kB
slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB unstable:0kB
bounce:0kB writeback_tmp:0kB pages_scanned:22 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
Node 0 DMA32 free:5604kB min:5704kB low:7128kB high:8556kB
active_anon:208kB inactive_anon:260kB active_file:2088kB
inactive_file:4976kB unevictable:0kB isolated(anon):0kB
isolated(file):128kB present:2052068kB mlocked:0kB dirty:3208kB
writeback:0kB mapped:336kB shmem:0kB slab_reclaimable:21516kB
slab_unreclaimable:30672kB kernel_stack:816kB pagetables:2304kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:608
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 1*16kB 2*32kB 2*64kB 3*128kB 3*256kB 3*512kB
3*1024kB 1*2048kB 0*4096kB = 8056kB
Node 0 DMA32: 422*4kB 0*8kB 0*16kB 3*32kB 1*64kB 1*128kB 0*256kB 1*512kB
1*1024kB 1*2048kB 0*4096kB = 5560kB
1914 total pagecache pages
106 pages in swap cache
Swap cache stats: add 499740, delete 499634, find 61395/208276
Free swap  = 4177680kB
Total swap = 4194300kB
524224 pages RAM
79718 pages reserved
1622 pages shared
438890 pages non-shared
Out of memory: kill process 2672 (sshd) score 2515 or a child
Killed process 3013 (sshd) vsz:97340kB, anon-rss:0kB, file-rss:4kB
postmark used greatest stack depth: 2560 bytes left

I identified one potential leak, on an error path, through code
inspection but I still hit OOM even with the following patch:

---
 block/blk-core.c       |   24 ++++++++++++++++++++++++
 drivers/scsi/sd.c      |    9 ++++++++-
 include/linux/blkdev.h |    1 +
 3 files changed, 33 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/scsi/sd.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sd.c
+++ linux-2.6/drivers/scsi/sd.c
@@ -424,6 +424,7 @@ static int scsi_setup_discard_cmnd(struc
 	sector_t sector = bio->bi_sector;
 	unsigned int nr_sectors = bio_sectors(bio);
 	unsigned int len;
+	int ret;
 	struct page *page;
 
 	if (sdkp->device->sector_size == 4096) {
@@ -464,7 +465,13 @@ static int scsi_setup_discard_cmnd(struc
 	}
 
 	blk_add_request_payload(rq, page, len);
-	return scsi_setup_blk_pc_cmnd(sdp, rq);
+	ret = scsi_setup_blk_pc_cmnd(sdp, rq);
+	if (ret != BLKPREP_OK) {
+		blk_clear_request_payload(rq);
+		__free_page(page);
+	}
+
+	return ret;
 }
 
 /**
Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c
+++ linux-2.6/block/blk-core.c
@@ -1139,6 +1139,30 @@ void blk_add_request_payload(struct requ
 }
 EXPORT_SYMBOL_GPL(blk_add_request_payload);
 
+/**
+ * blk_add_request_payload - add a payload to a request
+ * @rq: request to update
+ *
+ * This clears a request's payload.  The driver needs to take care of
+ * freeing the payload itself.
+ */
+void blk_clear_request_payload(struct request *rq)
+{
+	struct bio *bio = rq->bio;
+
+	rq->__data_len = rq->resid_len = 0;
+	rq->nr_phys_segments = 0;
+	rq->buffer = NULL;
+
+	bio->bi_size = 0;
+	bio->bi_vcnt = 0;
+	bio->bi_phys_segments = 0;
+
+	bio->bi_io_vec->bv_page = NULL;
+	bio->bi_io_vec->bv_len = 0;
+}
+EXPORT_SYMBOL_GPL(blk_clear_request_payload);
+
 void init_request_from_bio(struct request *req, struct bio *bio)
 {
 	req->cpu = bio->bi_comp_cpu;
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h
+++ linux-2.6/include/linux/blkdev.h
@@ -779,6 +779,7 @@ extern void blk_insert_request(struct re
 extern void blk_requeue_request(struct request_queue *, struct request *);
 extern void blk_add_request_payload(struct request *rq, struct page *page,
 		unsigned int len);
+extern void blk_clear_request_payload(struct request *rq);
 extern int blk_rq_check_limits(struct request_queue *q, struct request *rq);
 extern int blk_lld_busy(struct request_queue *q);
 extern int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
