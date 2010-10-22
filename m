Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630Ab0JVTMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:12:47 -0400
Received: from kroah.org ([198.145.64.141]:34121 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759336Ab0JVS4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:25 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:31 2010
Message-Id: <20101022185231.213982936@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Subject: [043/103] ubd: fix incorrect sector handling during request restart
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/drivers/ubd_kern.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

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
@@ -1223,7 +1225,6 @@ static void do_ubd_request(struct reques
 {
 	struct io_thread_req *io_req;
 	struct request *req;
-	sector_t sector;
 	int n;
 
 	while(1){
@@ -1234,12 +1235,12 @@ static void do_ubd_request(struct reques
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
 
@@ -1251,10 +1252,9 @@ static void do_ubd_request(struct reques
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
@@ -1267,6 +1267,7 @@ static void do_ubd_request(struct reques
 				return;
 			}
 
+			dev->rq_pos += sg->length >> 9;
 			dev->start_sg++;
 		}
 		dev->end_sg = 0;


