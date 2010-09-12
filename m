Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab0ILIvK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 04:51:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65235 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab0ILIvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 04:51:06 -0400
Message-ID: <4C8C9175.5030404@oracle.com>
Date: Sun, 12 Sep 2010 16:38:13 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/41] block/loop: queue ordered mode should be DRAIN_FLUSH
References: <1283509796-1510-1-git-send-email-tj@kernel.org> <1283509796-1510-3-git-send-email-tj@kernel.org>
In-Reply-To: <1283509796-1510-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,
	Just a small qs about this patch.

On 09/03/2010 06:29 PM, Tejun Heo wrote:
> loop implements FLUSH using fsync but was incorrectly setting its
> ordered mode to DRAIN.  Change it to DRAIN_FLUSH.  In practice, this
> doesn't change anything as loop doesn't make use of the block layer
> ordered implementation.
According to Documentation/block/barrier.txt,
QUEUE_ORDERED_DRAIN
         Requests are ordered by draining the request queue and cache
         flushing isn't needed.

         Sequence: drain => barrier

QUEUE_ORDERED_DRAIN_FLUSH
         Requests are ordered by draining the request queue and both
         pre-barrier and post-barrier cache flushings are needed.

         Sequence: drain => preflush => barrier => postflush

And for loop device, it call fsync in barrier request. See 
do_bio_filebacked in drivers/block/loop.c
bool barrier = !!(bio->bi_rw & REQ_HARDBARRIER);
                 struct file *file = lo->lo_backing_file;

                 if (barrier) {
                         if (unlikely(!file->f_op->fsync)) {
                                 ret = -EOPNOTSUPP;
                                 goto out;
                         }

                         ret = vfs_fsync(file, 0);
                         if (unlikely(ret)) {
                                 ret = -EIO;
                                 goto out;
                         }
                 }

So actually the sync is done in barrier and no extra flush is needed?
Or Do I misread the rules in barrier.txt?

Regards,
Tao

>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> ---
>   drivers/block/loop.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index f3c636d..c3a4a2e 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -832,7 +832,7 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
>   	lo->lo_queue->unplug_fn = loop_unplug;
>
>   	if (!(lo_flags&  LO_FLAGS_READ_ONLY)&&  file->f_op->fsync)
> -		blk_queue_ordered(lo->lo_queue, QUEUE_ORDERED_DRAIN);
> +		blk_queue_ordered(lo->lo_queue, QUEUE_ORDERED_DRAIN_FLUSH);
>
>   	set_capacity(lo->lo_disk, size);
>   	bd_set_size(bdev, size<<  9);
