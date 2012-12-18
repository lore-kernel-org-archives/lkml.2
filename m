Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab2LRLnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 06:43:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35174 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab2LRLnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 06:43:07 -0500
Message-ID: <50D056A5.3040501@kernel.dk>
Date: Tue, 18 Dec 2012 12:42:29 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [boot crash] Re: [GIT PULL[ block drivers bits for 3.8
References: <50CF89EB.2030109@kernel.dk> <20121218092554.GA3823@gmail.com>
In-Reply-To: <20121218092554.GA3823@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-18 10:25, Ingo Molnar wrote:
> 
> * Jens Axboe <axboe@kernel.dk> wrote:
> 
>> Hi Linus,
>>
>> Now that the core bits are in, here are the driver bits for 3.8. The
>> branch contains:
> 
> FYI, I'm getting a divide-by-zero boot crash (serial log capture 
> below) with the attached config.
> 
> Reproduced with 848b81415c42.
> 
> The bug might have gone upstream between 8874e81 (Linus's tree 
> from yesterday) and 848b81415c42 (Linus's tree from today). Or 
> it's from earlier and I only triggered it today.
> 
> ( Note that every log line is duplicated, haven't tracked that
>   down yet, earlyprintk=,keep might be busted. )

Bah. Does the below fix it up for you?

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index acb4f7b..067f195 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1188,12 +1188,13 @@ static inline int queue_discard_alignment(struct request_queue *q)
 
 static inline int queue_limit_discard_alignment(struct queue_limits *lim, sector_t sector)
 {
-	sector_t alignment = sector << 9;
-	alignment = sector_div(alignment, lim->discard_granularity);
+	sector_t alignment;
 
-	if (!lim->max_discard_sectors)
+	if (!lim->max_discard_sectors || !lim->discard_granularity)
 		return 0;
 
+	alignment = sector << 9;
+	alignment = sector_div(alignment, lim->discard_granularity);
 	alignment = lim->discard_granularity + lim->discard_alignment - alignment;
 	return sector_div(alignment, lim->discard_granularity);
 }

-- 
Jens Axboe

