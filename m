Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab1ABHm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:42:59 -0500
Received: from mail.windriver.com ([147.11.1.11]:36449 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab1ABHYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:35 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Tejun Heo <tj@kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 181/260] ubd: fix incorrect sector handling during request restart
Date: Sun,  2 Jan 2011 02:17:57 -0500
Message-Id: <1293952756-15010-182-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:28.0900 (UTC) FILETIME=[F3C26C40:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit 47526903feb52f4c26a6350370bdf74e337fcdb1 upstream.

Commit f81f2f7c (ubd: drop unnecessary rq->sector manipulation)
dropped request->sector manipulation in preparation for global request
handling cleanup; unfortunately, it incorrectly assumed that the
updated sector wasn't being used.

ubd tries to issue as many requests as possible to io_thread.  When
issuing fails due to memory pressure or other reasons, the device is
put on the restart list and issuing stops.  On IO completion, devices
on the restart list are scanned and IO issuing is restarted.

ubd issues IOs sg-by-sg and issuing can be stopped in the middle of a
request, so each device on the restart queue needs to remember where
to restart in its current request.  ubd needs to keep track of the
issue position itself because,

* blk_rq_pos(req) is now updated by the block layer to keep track of
  _completion_ position.

* Multiple io_req's for the current request may be in flight, so it's
  difficult to tell where blk_rq_pos(req) currently is.

Add ubd->rq_pos to keep track of the issue position and use it to
correctly restart io_req issue.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Richard Weinberger <richard@nod.at>
Tested-by: Richard Weinberger <richard@nod.at>
Tested-by: Chris Frey <cdfrey@foursquare.net>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/um/drivers/ubd_kern.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index da992a3..3d63b83 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -162,6 +162,7 @@ struct ubd {
 	struct scatterlist sg[MAX_SG];
 	struct request *request;
 	int start_sg, end_sg;
+	sector_t rq_pos;
 };
 
 #define DEFAULT_COW { \
@@ -186,6 +187,7 @@ struct ubd {
 	.request =		NULL, \
 	.start_sg =		0, \
 	.end_sg =		0, \
+	.rq_pos =		0, \
 }
 
 /* Protected by ubd_lock */
@@ -1223,7 +1225,6 @@ static void do_ubd_request(struct request_queue *q)
 {
 	struct io_thread_req *io_req;
 	struct request *req;
-	sector_t sector;
 	int n;
 
 	while(1){
@@ -1234,12 +1235,12 @@ static void do_ubd_request(struct request_queue *q)
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
 
@@ -1251,10 +1252,9 @@ static void do_ubd_request(struct request_queue *q)
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
@@ -1267,6 +1267,7 @@ static void do_ubd_request(struct request_queue *q)
 				return;
 			}
 
+			dev->rq_pos += sg->length >> 9;
 			dev->start_sg++;
 		}
 		dev->end_sg = 0;
-- 
1.7.3.3

