Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab2EGQrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:47:05 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:38644 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757259Ab2EGQrD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:47:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120506233117.GU5091@dastard>
References: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
 <1336054995-22988-2-git-send-email-svenkatr@ti.com> <20120506233117.GU5091@dastard>
From: "S, Venkatraman" <svenkatr@ti.com>
Date: Mon, 7 May 2012 22:16:30 +0530
Message-ID: <CANfBPZ_2JeWUu7ti97CVc=ODeEi65ke9EKV6Uje0JHcCM8gYqQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/16] FS: Added demand paging markers to filesystem
To: Dave Chinner <david@fromorbit.com>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org,
        alex.lemberg@sandisk.com, ilan.smith@sandisk.com, lporzio@micron.com,
        rmk+kernel@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mon, May 7, 2012 at 5:01 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, May 03, 2012 at 07:53:00PM +0530, Venkatraman S wrote:
>> From: Ilan Smith <ilan.smith@sandisk.com>
>>
>> Add attribute to identify demand paging requests.
>> Mark readpages with demand paging attribute.
>>
>> Signed-off-by: Ilan Smith <ilan.smith@sandisk.com>
>> Signed-off-by: Alex Lemberg <alex.lemberg@sandisk.com>
>> Signed-off-by: Venkatraman S <svenkatr@ti.com>
>> ---
>>  fs/mpage.c                |    2 ++
>>  include/linux/bio.h       |    7 +++++++
>>  include/linux/blk_types.h |    2 ++
>>  3 files changed, 11 insertions(+)
>>
>> diff --git a/fs/mpage.c b/fs/mpage.c
>> index 0face1c..8b144f5 100644
>> --- a/fs/mpage.c
>> +++ b/fs/mpage.c
>> @@ -386,6 +386,8 @@ mpage_readpages(struct address_space *mapping, struct list_head *pages,
>>                                       &last_block_in_bio, &map_bh,
>>                                       &first_logical_block,
>>                                       get_block);
>> +                     if (bio)
>> +                             bio->bi_rw |= REQ_RW_DMPG;
>
> Have you thought about the potential for DOSing a machine
> with this? That is, user data reads can now preempt writes of any
> kind, effectively stalling writeback and memory reclaim which will
> lead to OOM situations. Or, alternatively, journal flushing will get
> stalled and no new modifications can take place until the read
> stream stops.

This feature doesn't fiddle with the I/O scheduler's ability to balance
read vs write requests or handling requests from various process queues (CFQ).

Also, for block devices which don't implement the ability to preempt (and even
for older versions of MMC devices which don't implement this feature),
the behaviour
falls back to waiting for write requests to complete before issuing the read.

In low end flash devices, some requests might take too long than normal
due to background device maintenance (i.e flash erase / reclaim procedure)
kicking in in the context of an ongoing write, stalling them by several
orders of magnitude.

This implementation (See 14/16) does have several
checks and timers to see that it's not triggered very often.
In my tests, where I usually have a generous preemption time window, the abort
happens < 0.1% of the time.


>
> This really seems like functionality that belongs in an IO
> scheduler so that write starvation can be avoided, not in high-level
> data read paths where we have no clue about anything else going on
> in the IO subsystem....

Indeed, the feature is built mostly in the low level device driver and
minor changes in the elevator. Changes above the block layer are only
about setting
attributes and transparent to their operation.

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
