Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab0JOJUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:20:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:37021 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab0JOJUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:20:47 -0400
Message-ID: <4CB81C91.7070406@kernel.org>
Date: Fri, 15 Oct 2010 11:19:13 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        "jdike@addtoit.com" <jdike@addtoit.com>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        "user-mode-linux-user@lists.sourceforge.net" 
	<user-mode-linux-user@lists.sourceforge.net>,
        "janjaap@bos.nl" <janjaap@bos.nl>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "syzop@vulnscan.org" <syzop@vulnscan.org>,
        Chris Frey <cdfrey@foursquare.net>, stable <stable@kernel.org>
Subject: [PATCH v2.6.36-rc7] ubd: fix incorrect sector handling during request
 restart
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Oct 2010 09:19:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@kernel.org
---
 arch/um/drivers/ubd_kern.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

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
