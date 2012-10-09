Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab2JICAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 22:00:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:43509 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab2JICAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 22:00:03 -0400
Message-ID: <5073851B.6080002@kernel.dk>
Date: Mon, 08 Oct 2012 19:59:55 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch]block: add plug for blkdev_issue_discard
References: <20121009011106.GA17038@kernel.org> <CAMM=eLcw8-r7iYSYG4uhJd_Q1rRYifye8T-Wv4PR9hQjF8j9gQ@mail.gmail.com>
In-Reply-To: <CAMM=eLcw8-r7iYSYG4uhJd_Q1rRYifye8T-Wv4PR9hQjF8j9gQ@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-08 19:56, Mike Snitzer wrote:
> On Mon, Oct 8, 2012 at 9:11 PM, Shaohua Li <shli@kernel.org> wrote:
>> Now discard merge works, add plug for blkdev_issue_discard. This will help
>> discard request merge especially for raid0 case. In raid0, a big discard
>> request is split to small requests, and if correct plug is added, such small
>> requests can be merged in low layer.
>>
>> Signed-off-by: Shaohua Li <shli@fusionio.com>
>> ---
>>  block/blk-lib.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> Index: linux/block/blk-lib.c
>> ===================================================================
>> --- linux.orig/block/blk-lib.c  2012-09-28 15:09:38.655327319 +0800
>> +++ linux/block/blk-lib.c       2012-10-09 08:45:04.358598888 +0800
>> @@ -48,6 +48,7 @@ int blkdev_issue_discard(struct block_de
>>         struct bio_batch bb;
>>         struct bio *bio;
>>         int ret = 0;
>> +       struct blk_plug plug;
>>
>>         if (!q)
>>                 return -ENXIO;
>> @@ -81,6 +82,7 @@ int blkdev_issue_discard(struct block_de
>>         bb.flags = 1 << BIO_UPTODATE;
>>         bb.wait = &wait;
>>
>> +       blk_start_plug(&plug);
>>         while (nr_sects) {
>>                 unsigned int req_sects;
>>                 sector_t end_sect;
>> @@ -117,6 +119,7 @@ int blkdev_issue_discard(struct block_de
>>                 atomic_inc(&bb.done);
>>                 submit_bio(type, bio);
>>         }
>> +       blk_finish_plug(&plug);
>>
>>         /* Wait for bios in-flight */
>>         if (!atomic_dec_and_test(&bb.done))
> 
> That plug looks rather coarse-grained.  Any adverse affects when mkfs
> discards an entire (large) raid0 device?  (I suspect not but figured
> I'd ask)

Block core auto-unplugs after a certain depth is reached. So it's better
to make it coarse than try to second guess when to unplug.

-- 
Jens Axboe

