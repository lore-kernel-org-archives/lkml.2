Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157Ab0JGH55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 03:57:57 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47129 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab0JGH54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 03:57:56 -0400
Message-ID: <4CAD7D98.7080808@fusionio.com>
Date: Thu, 07 Oct 2010 09:58:16 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Chris Frey <cdfrey@foursquare.net>
CC: Tejun Heo <htejun@gmail.com>, Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jdike@addtoit.com" <jdike@addtoit.com>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        "user-mode-linux-user@lists.sourceforge.net" 
	<user-mode-linux-user@lists.sourceforge.net>,
        "janjaap@bos.nl" <janjaap@bos.nl>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>,
        "syzop@vulnscan.org" <syzop@vulnscan.org>
Subject: Re: [PATCH 1/1] um: ubd: Fix data corruption
References: <20100928150000.f007f43e.akpm@linux-foundation.org> <201009290013.11332.richard@nod.at> <20100928225202.GA30352@foursquare.net> <4CA275CE.6060401@fusionio.com> <20100929012945.GA3324@foursquare.net> <4CA2CCC3.8010307@fusionio.com> <20100929063452.GA13290@foursquare.net> <4CAA02D0.7040901@gmail.com> <20101004195152.GA31583@foursquare.net> <4CAAE077.9010500@gmail.com> <20101005203137.GA594@foursquare.net>
In-Reply-To: <20101005203137.GA594@foursquare.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-05 22:31, Chris Frey wrote:
> On Tue, Oct 05, 2010 at 10:23:19AM +0200, Tejun Heo wrote:
>> Hmmmm, can you please give a shot at the following one?  Thank you.
> 
> I applied this patch on top of stock 2.6.35.5 as usual (no other patches)
> and tested on my maverick image as before.  I ran a fsck.ext3 on the
> filesystem image from the host before my test, just to make sure, and
> there were no errors.
> 
> Unfortunately, this patch does not fix the issue either.  I get errors
> in the guest like the following:

So how about this? Note that I haven't even compiled this. The request
handling logic really should be fixed in there, it's horribly
inefficient.

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 1bcd208..c272cf6 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -163,6 +163,7 @@ struct ubd {
 	struct scatterlist sg[MAX_SG];
 	struct request *request;
 	int start_sg, end_sg;
+	unsigned int rq_offset;
 };
 
 #define DEFAULT_COW { \
@@ -187,6 +188,7 @@ struct ubd {
 	.request =		NULL, \
 	.start_sg =		0, \
 	.end_sg =		0, \
+	.rq_offset		0, \
 }
 
 /* Protected by ubd_lock */
@@ -466,6 +468,8 @@ static void ubd_handler(void)
 	int n;
 
 	while(1){
+		struct ubd *dev;
+
 		n = os_read_file(thread_fd, &req,
 				 sizeof(struct io_thread_req *));
 		if(n != sizeof(req)){
@@ -476,6 +480,11 @@ static void ubd_handler(void)
 			return;
 		}
 
+		/*
+		 * Clear internal offset, block core will update request state
+		 */
+		dev = req->req->q->queuedata;
+		dev->rq_offset = 0;
 		blk_end_request(req->req, 0, req->length);
 		kfree(req);
 	}
@@ -1241,10 +1250,11 @@ static void do_ubd_request(struct request_queue *q)
 			dev->request = req;
 			dev->start_sg = 0;
 			dev->end_sg = blk_rq_map_sg(q, req, dev->sg);
+			dev->rq_offset = 0;
 		}
 
 		req = dev->request;
-		sector = blk_rq_pos(req);
+		sector = blk_rq_pos(req) + dev->rq_offset;
 		while(dev->start_sg < dev->end_sg){
 			struct scatterlist *sg = &dev->sg[dev->start_sg];
 
@@ -1272,6 +1282,7 @@ static void do_ubd_request(struct request_queue *q)
 				return;
 			}
 
+			dev->rq_offset += sg->length >> 9;
 			dev->start_sg++;
 		}
 		dev->end_sg = 0;

-- 
Jens Axboe

