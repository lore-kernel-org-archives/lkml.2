Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab1CVVEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 17:04:06 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:43467 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932268Ab1CVVEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 17:04:04 -0400
X-ASG-Debug-ID: 1300827843-01de284cf8a7740001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D890EBD.1090103@fusionio.com>
Date: Tue, 22 Mar 2011 22:03:57 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: merging discard request in the block layer
References: <20110322194755.GA20122@infradead.org> <4D88FE5E.1010204@fusionio.com>
X-ASG-Orig-Subj: Re: merging discard request in the block layer
In-Reply-To: <4D88FE5E.1010204@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1300827843
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58672
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-22 20:54, Jens Axboe wrote:
> On 2011-03-22 20:47, Christoph Hellwig wrote:
>> It seems the current block layer wil happily try to merge discard
>> requests that were split because they are at the max that bi_size
>> can hold together again.  At least that's what the
>>
>> 	blk: request botched
> 
> That would seem to indicate a bug in the merging logic instead.

What kind of max discard size does you device have? If the max discard
size is smaller than the regular request size, this could help.

diff --git a/block/blk-merge.c b/block/blk-merge.c
index cfcc37c..76cdfb7 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -232,8 +232,12 @@ int ll_back_merge_fn(struct request_queue *q, struct request *req,
 
 	if (unlikely(req->cmd_type == REQ_TYPE_BLOCK_PC))
 		max_sectors = queue_max_hw_sectors(q);
-	else
-		max_sectors = queue_max_sectors(q);
+	else {
+		if (req->cmd_flags & REQ_DISCARD)
+			max_sectors = q->limits.max_discard_sectors;
+		else
+			max_sectors = queue_max_sectors(q);
+	}
 
 	if (blk_rq_sectors(req) + bio_sectors(bio) > max_sectors) {
 		req->cmd_flags |= REQ_NOMERGE;
@@ -256,9 +260,12 @@ int ll_front_merge_fn(struct request_queue *q, struct request *req,
 
 	if (unlikely(req->cmd_type == REQ_TYPE_BLOCK_PC))
 		max_sectors = queue_max_hw_sectors(q);
-	else
-		max_sectors = queue_max_sectors(q);
-
+	else {
+		if (req->cmd_flags & REQ_DISCARD)
+			max_sectors = q->limits.max_discard_sectors;
+		else
+			max_sectors = queue_max_sectors(q);
+	}
 
 	if (blk_rq_sectors(req) + bio_sectors(bio) > max_sectors) {
 		req->cmd_flags |= REQ_NOMERGE;


-- 
Jens Axboe

