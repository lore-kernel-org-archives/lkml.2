Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab1GWHjz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 03:39:55 -0400
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:41130 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab1GWHjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 03:39:48 -0400
Message-ID: <4E2A7806.1060601@ce.jp.nec.com>
Date: Sat, 23 Jul 2011 16:28:06 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, agk@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: request baset device mapper in Linux
References: <20110720082640.GZ7561@ics.muni.cz> <4E280964.6070000@ct.jp.nec.com> <20110721132627.GY7561@ics.muni.cz> <4E291F28.2040609@ct.jp.nec.com> <20110722081903.GB7561@ics.muni.cz>
In-Reply-To: <20110722081903.GB7561@ics.muni.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/22/11 17:19, Lukas Hejtmanek wrote:
> this is trace from sysprof but it is not in exact order: (and percetage is not
> accurate and is across whole system, ksoftirqd runs at 100% CPU according to
> top).
> 
>   [ksoftirqd/0]                        0.00%  33.45%
>     - - kernel - -                     0.00%  33.45%
>       __blk_recalc_rq_segments        16.61%  16.61%
>       _spin_unlock_irqrestore          6.17%   6.17%
>       kmem_cache_free                  2.21%   2.21%
>       blk_update_request               1.78%   1.80%
>       end_buffer_async_read            1.40%   1.40%
...
>> (How many CPUs do you have and how fast are those CPUs?
>>  I just tried, but no such phenomenon can be seen on the environment
>>  of 10 (FC) devices and 1 CPU (Xeon(R) E5205 1.86[GHz]).)
> 
> I have E5640  @ 2.67GHz with 16 cores (8 real cores with HT).
> 
> 10 devices is not enough. I cannot preproduce it with just 10 devices. At
> least 20 is necessary. 

How fast is the single disk performance?
Could you check /proc/interrupts and /proc/softirqs and
see how they are distributed among CPUs?
As for the memory usage, what happens if you add 'iflag=direct' to dd?

Also, is it possible for you to try the attached patch?
I would like to know whether it changes the phenomenon you see.
This patch should reduce the number of calls to recalc segments.
If it is the root cause, the patch should fix your case.
The patch is generated for 3.0 but should be easily applicable to
other version of request-based dm.

As Kiyoshi suggested, it is important to know whether this
problem occurs with the latest kernel.
So if you could try 3.0, it would be very helpful.

# and sorry, I will not be able to respond e-mail during next week..

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation


--- linux-3.0/drivers/md/dm.c.orig	2011-07-23 11:04:54.487100496 +0900
+++ linux-3.0/drivers/md/dm.c	2011-07-23 15:30:14.748606235 +0900
@@ -70,6 +70,7 @@ struct dm_rq_target_io {
 	struct mapped_device *md;
 	struct dm_target *ti;
 	struct request *orig, clone;
+	unsigned int done_bytes;
 	int error;
 	union map_info info;
 };
@@ -705,23 +706,8 @@ static void end_clone_bio(struct bio *cl
 
 	/*
 	 * I/O for the bio successfully completed.
-	 * Notice the data completion to the upper layer.
 	 */
-
-	/*
-	 * bios are processed from the head of the list.
-	 * So the completing bio should always be rq->bio.
-	 * If it's not, something wrong is happening.
-	 */
-	if (tio->orig->bio != bio)
-		DMERR("bio completion is going in the middle of the request");
-
-	/*
-	 * Update the original request.
-	 * Do not use blk_end_request() here, because it may complete
-	 * the original request before the clone, and break the ordering.
-	 */
-	blk_update_request(tio->orig, 0, nr_bytes);
+	tio->done_bytes += nr_bytes;
 }
 
 /*
@@ -850,6 +836,16 @@ static void dm_done(struct request *clon
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	dm_request_endio_fn rq_end_io = tio->ti->type->rq_end_io;
 
+	/*
+	 * Update the original request.
+	 * Do not use blk_end_request() here, because it may complete
+	 * the original request before the clone, and break the ordering.
+	 */
+	if (tio->done_bytes) {
+		blk_update_request(tio->orig, 0, tio->done_bytes);
+		tio->done_bytes = 0;
+	}
+
 	if (mapped && rq_end_io)
 		r = rq_end_io(tio->ti, clone, error, &tio->info);
 
@@ -1507,6 +1503,7 @@ static struct request *clone_rq(struct r
 	tio->md = md;
 	tio->ti = NULL;
 	tio->orig = rq;
+	tio->done_bytes = 0;
 	tio->error = 0;
 	memset(&tio->info, 0, sizeof(tio->info));
 
