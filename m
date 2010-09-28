Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab0I1XKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 19:10:15 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:58846 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab0I1XKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 19:10:13 -0400
X-ASG-Debug-ID: 1285715410-69592d9b0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CA275CE.6060401@fusionio.com>
Date: Wed, 29 Sep 2010 08:10:06 +0900
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Chris Frey <cdfrey@foursquare.net>
CC: Richard Weinberger <richard@nod.at>,
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
References: <1285710456-4435-1-git-send-email-richard@nod.at> <20100928150000.f007f43e.akpm@linux-foundation.org> <201009290013.11332.richard@nod.at> <20100928225202.GA30352@foursquare.net>
X-ASG-Orig-Subj: Re: [PATCH 1/1] um: ubd: Fix data corruption
In-Reply-To: <20100928225202.GA30352@foursquare.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1285715410
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=INFO_TLD
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.42178
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 INFO_TLD               URI: Contains an URL in the INFO top-level domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-29 07:52, Chris Frey wrote:
> On Wed, Sep 29, 2010 at 12:13:10AM +0200, Richard Weinberger wrote:
>> Am Mittwoch 29 September 2010, 00:00:00 schrieb Andrew Morton:
>>> This is a workaround, I think?  Do we know what the actual bug is?
>>> From the comment it appears to be a regression?
>>
>> Yes, it is a workaround.
>> For more details please have a look at this post:
>> http://lkml.org/lkml/2010/9/28/245
> 
> I'm going to run some tests to see how this works on my end, but in
> reading old threads, I found this response from Bram Matthys
> that casts some doubt on an older version of this patch.
> 
> 	http://marc.info/?l=user-mode-linux-user&m=126883932731656&w=2
> 
> I've added him to the CC.

It looks like that if we need to restart the requeue, then
we use the initial position and not the current index. Does
this help?

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 1bcd208..81ee063 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -162,7 +162,7 @@ struct ubd {
 	spinlock_t lock;
 	struct scatterlist sg[MAX_SG];
 	struct request *request;
-	int start_sg, end_sg;
+	int start_sg, end_sg, rq_off;
 };
 
 #define DEFAULT_COW { \
@@ -187,6 +187,7 @@ struct ubd {
 	.request =		NULL, \
 	.start_sg =		0, \
 	.end_sg =		0, \
+	.rq_off =		0, \
 }
 
 /* Protected by ubd_lock */
@@ -1241,10 +1242,11 @@ static void do_ubd_request(struct request_queue *q)
 			dev->request = req;
 			dev->start_sg = 0;
 			dev->end_sg = blk_rq_map_sg(q, req, dev->sg);
+			dev->rq_off = 0;
 		}
 
 		req = dev->request;
-		sector = blk_rq_pos(req);
+		sector = blk_rq_pos(req) + dev->rq_off;
 		while(dev->start_sg < dev->end_sg){
 			struct scatterlist *sg = &dev->sg[dev->start_sg];
 
@@ -1273,6 +1275,7 @@ static void do_ubd_request(struct request_queue *q)
 			}
 
 			dev->start_sg++;
+			dev->rq_off += sg->length >> 9;
 		}
 		dev->end_sg = 0;
 		dev->request = NULL;

-- 
Jens Axboe

