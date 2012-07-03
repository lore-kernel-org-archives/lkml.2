Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab2GCOWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 10:22:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab2GCOWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 10:22:02 -0400
Message-ID: <4FF2FFEE.4000401@redhat.com>
Date: Tue, 03 Jul 2012 16:21:34 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, snitzer@redhat.com,
        martin.petersen@oracle.com, david@fromorbit.com, xfs@oss.sgi.com,
        dm-devel@redhat.com, hch@lst.de
Subject: Re: [dm-devel] [PATCH v2 1/3] block: add sysfs entry for discard_alignment
References: <1341235225-27551-1-git-send-email-pbonzini@redhat.com> <1341235225-27551-2-git-send-email-pbonzini@redhat.com> <20120703023442.GB3586@redhat.com> <4FF2DCB1.2090704@redhat.com> <20120703140048.GC11272@redhat.com>
In-Reply-To: <20120703140048.GC11272@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/07/2012 16:00, Vivek Goyal ha scritto:
>> > 
>> > Ah, interesting, I missed it completely.  I guess it's because queue/
>> > directories only exist for full disks, and the correct alignment varies
>> > for each partition.  So this patch is unnecessary.
> Partition discard_alignments are available in
> /sys/block/<disk>/<partition>/discard_alignment.

Yes.  If it were in queue/, it wouldn't be available.

> That raises an interesting question for patch3. If the discard is happening to
> a partition, shouldn't you be looking at partition discard_alignment
> instead of always looking at queue discard_alignment?

Good point!  Like this?

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ba43f40..3530764 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1125,6 +1125,16 @@ static inline int queue_limit_discard_alignment(struct queue_limits *lim, sector
 		& (lim->discard_granularity - 1);
 }
 
+static inline int bdev_discard_alignment(struct block_device *bdev)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	if (bdev != bdev->bd_contains)
+		return bdev->bd_part->discard_alignment;
+
+	return q->limits.discard_alignment;
+}
+
 static inline unsigned int queue_discard_zeroes_data(struct request_queue *q)
 {
 	if (q->limits.max_discard_sectors && q->limits.discard_zeroes_data == 1)
diff --git a/block/blk-lib.c b/block/blk-lib.c
index b2bde5c..77d8869 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -58,7 +58,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	/* Zero-sector (unknown) and one-sector granularities are the same.  */
 	granularity = max(q->limits.discard_granularity >> 9, 1U);
 	mask = granularity - 1;
-	alignment = (q->limits.discard_alignment >> 9) & mask;
+	alignment = bdev_discard_alignment(bdev) >> 9;
 
 	/*
 	 * Ensure that max_discard_sectors is of the proper

Paolo
