Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab0JDQhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 12:37:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56018 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab0JDQhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 12:37:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=MKFpN3fCmCJb7yzrxJKiVapgN8+6SQsykt0xX9B4KxcnP2TXjDGwxHKot46nO7qizv
         8fhNnoLF4gI2aDI0hncv7l/+J6f+sIFTgSPWytGiskYDyU+3v1QmNSOp3Xa+o1Mi/XfO
         UajZyoujpgHMcoh9+F5V4jzrnv3gXVXAh5wHs=
Message-ID: <4CAA02D0.7040901@gmail.com>
Date: Mon, 04 Oct 2010 18:37:36 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Chris Frey <cdfrey@foursquare.net>
CC: Jens Axboe <jaxboe@fusionio.com>, Richard Weinberger <richard@nod.at>,
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
References: <1285710456-4435-1-git-send-email-richard@nod.at> <20100928150000.f007f43e.akpm@linux-foundation.org> <201009290013.11332.richard@nod.at> <20100928225202.GA30352@foursquare.net> <4CA275CE.6060401@fusionio.com> <20100929012945.GA3324@foursquare.net> <4CA2CCC3.8010307@fusionio.com> <20100929063452.GA13290@foursquare.net>
In-Reply-To: <20100929063452.GA13290@foursquare.net>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, sorry about chiming in later.  I was off last week.

On 09/29/2010 08:34 AM, Chris Frey wrote:
> On Wed, Sep 29, 2010 at 02:21:07PM +0900, Jens Axboe wrote:
>> This seems to imply that the original commit pin pointed is not
>> the only issue we have in that code atm.
>>
>> I think we need to find the real fix here, just disabling merging
>> is not a fix (it's just a nasty work-around for the real bug).
> 
> You're probably right, and I'm quite willing to help test further patches
> to help get to the bottom of this.

I think we're on the right track.  The problem with Jens' patch was
that it didn't consider the fact that blk_end_request() now internally
updates the current position of the request, so if restart happens
after some of part of the request is complete it will end up adding
the offsets multiple times.  I think slightly modifying it to track
the current position instead of offset should do it.  Chris, can you
please try the following patch and see whether the problem goes away?

Thanks.

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 1bcd208..d8a5d8c 100644
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
@@ -1244,7 +1245,7 @@ static void do_ubd_request(struct request_queue *q)
 		}

 		req = dev->request;
-		sector = blk_rq_pos(req);
+		dev->rq_pos = blk_rq_pos(req);
 		while(dev->start_sg < dev->end_sg){
 			struct scatterlist *sg = &dev->sg[dev->start_sg];

@@ -1256,10 +1257,10 @@ static void do_ubd_request(struct request_queue *q)
 				return;
 			}
 			prepare_request(req, io_req,
-					(unsigned long long)sector << 9,
+					(unsigned long long)dev->rq_pos << 9,
 					sg->offset, sg->length, sg_page(sg));

-			sector += sg->length >> 9;
+			dev->rq_pos += sg->length >> 9;
 			n = os_write_file(thread_fd, &io_req,
 					  sizeof(struct io_thread_req *));
 			if(n != sizeof(struct io_thread_req *)){
