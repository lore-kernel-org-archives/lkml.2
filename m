Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab1EZFwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 01:52:11 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:40689 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab1EZFwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 01:52:10 -0400
X-ASG-Debug-ID: 1306389127-01de28096b6bcd0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DDDEA83.5040306@fusionio.com>
Date: Thu, 26 May 2011 07:52:03 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Tao Ma <boyu.mt@taobao.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Core block bits for 2.6.40
References: <4DDCFE21.80003@fusionio.com> <1306388153.2664.4.camel@edumazet-laptop>
X-ASG-Orig-Subj: Re: [GIT PULL] Core block bits for 2.6.40
In-Reply-To: <1306388153.2664.4.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306389127
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64693
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-26 07:35, Eric Dumazet wrote:
> Le mercredi 25 mai 2011 à 15:03 +0200, Jens Axboe a écrit :
>> Hi Linus,
>>
>> A real pull request this time. These are the core bits for the next
>> kernel. Nothing exciting in here in this round, with the churn in
>> the last release, this release will be mellow.
>>
>> - Optimizations for queue flushing on SATA devices, where we
>>   can't queue a FLUSH command. This fixes up a performance regression
>>   caused by a bug fix to prevent potential live lock on adding
>>   FLUSH commands at the head of the queue.
>>
>> - Make stats lockless for blk-cgroup.
>>
>> - Various bug fixes for blk-cgroup.
>>
>> - Various little fixes and improvements to CFQ.
>>
>> - Last round of media event changes.
>>
>> - Fixes for discard topology reporting and sysfs documentation update
>>   for the same.
>>
>> - Add support for batched discards. This greatly speeds up discarding
>>   an entire device.
>>
>> - Fix for bad return value in the discard ioctl.
>>
>> - Remove request plug state debug checks. Haven't triggered even during
>>   the 2.6.39-rc devel cycle, so get rid of them.
>>
>>
>> Please pull!
>>
>>
>>   git://git.kernel.dk/linux-2.6-block.git for-2.6.40/core
>>
> 
>> Tao Ma (2):
>>       block: Remove 'plug/unplug' comment in blk_execute_rq_nowait
>>       block: Remove extra discard_alignment from hd_struct.
> 
> At boot, I have a crash in part_discard_alignment_show+0x1b/0x50
> 
> CR2 : 000006ac
> 
> fault in : mov    0x2c(%rcx),%edx
> 
> I suspect commit 23ceb5b7719e9276d4 (block: Remove extra
> discard_alignment from hd_struct) being in fault

Hmm, that must be disk->queue == NULL. Do you have a trace of the crash,
with the surrounding boot messages? I wonder what is special about your
setup to trigger something like this.

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 8ed4d34..f82e762 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -256,10 +256,12 @@ ssize_t part_discard_alignment_show(struct device *dev,
 {
 	struct hd_struct *p = dev_to_part(dev);
 	struct gendisk *disk = dev_to_disk(dev);
+	unsigned int alignment = 0;
 
-	return sprintf(buf, "%u\n",
-			queue_limit_discard_alignment(&disk->queue->limits,
-							p->start_sect));
+	if (disk->queue)
+		alignment = queue_limit_discard_alignment(&disk->queue->limits,
+								p->start_sect);
+	return sprintf(buf, "%u\n", alignment);
 }
 
 ssize_t part_stat_show(struct device *dev,


-- 
Jens Axboe

