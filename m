Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab0JOLCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 07:02:49 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40893 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab0JOLCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 07:02:48 -0400
Message-ID: <4CB834DA.2050304@fusionio.com>
Date: Fri, 15 Oct 2010 13:02:50 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: [GIT PULL] two block fixes for 2.6.36
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Two fixes queued up for 2.6.36 final:

1) Fix a regression in ubd causing corruption of data. This was
   caused by f81f2f7c which dates back to April of 2009.

2) One-liner for ps3disk, which passes in the wrong type to
    bvec_kunmap_irq().

Please pull!

  git://git.kernel.dk/linux-2.6-block.git for-linus

Dan Carpenter (1):
      ps3disk: passing wrong variable to bvec_kunmap_irq()

Tejun Heo (1):
      ubd: fix incorrect sector handling during request restart

 arch/um/drivers/ubd_kern.c |    9 +++++----
 drivers/block/ps3disk.c    |    2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 1bcd208..9734994 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -163,6 +163,7 @@ struct ubd {
 	struct scatterlist sg[MAX_SG];
 	struct request *request;
 	int start_sg, end_sg;
+	sector_t rq_pos;
 };
 
 #define DEFAULT_COW { \
@@ -187,6 +188,7 @@ struct ubd {
 	.request =		NULL, \
 	.start_sg =		0, \
 	.end_sg =		0, \
+	.rq_pos =		0, \
 }
 
 /* Protected by ubd_lock */
@@ -1228,7 +1230,6 @@ static void do_ubd_request(struct request_queue *q)
 {
 	struct io_thread_req *io_req;
 	struct request *req;
-	sector_t sector;
 	int n;
 
 	while(1){
@@ -1239,12 +1240,12 @@ static void do_ubd_request(struct request_queue *q)
 				return;
 
 			dev->request = req;
+			dev->rq_pos = blk_rq_pos(req);
 			dev->start_sg = 0;
 			dev->end_sg = blk_rq_map_sg(q, req, dev->sg);
 		}
 
 		req = dev->request;
-		sector = blk_rq_pos(req);
 		while(dev->start_sg < dev->end_sg){
 			struct scatterlist *sg = &dev->sg[dev->start_sg];
 
@@ -1256,10 +1257,9 @@ static void do_ubd_request(struct request_queue *q)
 				return;
 			}
 			prepare_request(req, io_req,
-					(unsigned long long)sector << 9,
+					(unsigned long long)dev->rq_pos << 9,
 					sg->offset, sg->length, sg_page(sg));
 
-			sector += sg->length >> 9;
 			n = os_write_file(thread_fd, &io_req,
 					  sizeof(struct io_thread_req *));
 			if(n != sizeof(struct io_thread_req *)){
@@ -1272,6 +1272,7 @@ static void do_ubd_request(struct request_queue *q)
 				return;
 			}
 
+			dev->rq_pos += sg->length >> 9;
 			dev->start_sg++;
 		}
 		dev->end_sg = 0;
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index e9da874..03688c2 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -113,7 +113,7 @@ static void ps3disk_scatter_gather(struct ps3_storage_device *dev,
 			memcpy(buf, dev->bounce_buf+offset, size);
 		offset += size;
 		flush_kernel_dcache_page(bvec->bv_page);
-		bvec_kunmap_irq(bvec, &flags);
+		bvec_kunmap_irq(buf, &flags);
 		i++;
 	}
 }

-- 
Jens Axboe

