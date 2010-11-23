Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab0KWKCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 05:02:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab0KWKCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 05:02:02 -0500
Message-ID: <4CEB90F0.4000903@redhat.com>
Date: Tue, 23 Nov 2010 11:01:20 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [GIT PULL] Revert of the IO stat fix
References: <4CC49274.3030803@fusionio.com> <AANLkTik4qAzZPLO8HHBCM34_NLEEdPj04RyXPfeR-wSv@mail.gmail.com> <4CC49A4B.8010300@fusionio.com> <4CC49AAB.5090809@fusionio.com>
In-Reply-To: <4CC49AAB.5090809@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2010 10:44 PM, Jens Axboe wrote:
> On 2010-10-24 22:42, Jens Axboe wrote:
>> On 2010-10-24 22:35, Linus Torvalds wrote:
>>> On Sun, Oct 24, 2010 at 1:09 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>>>
>>>> The fix for cross-partition merges screwing up disk stats turns out
>>>> to be problematic on various levels. Lets revert this one so we have
>>>> time to come up with a proper solution for this.
>>>
>>> Hmm.. I think the reverted patch looks like it really is the right
>>> thing to do, so I hate reverting it this early. What were the problems
>>> with it?
>>>
>>> Btw, one thing that seems to be missing in the original commit (which
>>> is not necessarily the reason for the trouble, of course), is that
>>> elv_rq_merge_ok() seems to not check the partition. As far as I can
>>> tell, we should have a
>>>
>>>     if (req->part != bio->bi_bdev->bd_part)
>>>        return 0;
>>>
>>> there, no? And you should _not_ set rq->part in "drive_stat_acct()",
>>> you should set it from bio->bi_bdev->bd_part when you create the
>>> request.
>>>
>>> (And if it is NULL, just don't do partition accounting at all)
>>>
>>> Hmm? What am I missing? What were the bugs?
>>
>> The patch itself is sound, the problems are around the area of it not
>> really liking non-elevator devices with the elv_quiesce_start/end()
>> parts. I had the below patch for that, but then I could not decide
>> whether we were fully safe on queue free after talking to Vivek about
>> it.

Hi Jens,

What's the status of this ? Has there been any progress on the issue ?

Thanks,
Jerome

> 
> Forgot to include it, here it is. I'll be offline from now and 1-2 days
> forward.
> 
> 
> From 96059cec039b666c26d300c2132e24bfd6edacdc Mon Sep 17 00:00:00 2001
> From: Jens Axboe <jaxboe@fusionio.com>
> Date: Sun, 24 Oct 2010 08:46:41 +0200
> Subject: [PATCH] block: fix partition reload bug with non-elevator devices
> 
> The partition reload code was changed to quiesce the block
> queue so that partition IO stats could safely hold a reference
> to the partition table. elv_quiesce_{start,end} do not
> properly work on non-elevator devices. Improve the helper
> functions so that they don't care, this way we can use
> the generic interface on partition reload without having
> to check for queue structures or types.
> 
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
> ---
>  block/elevator.c         |   31 +++++++++++++++++++++++--------
>  block/genhd.c            |   10 +---------
>  fs/partitions/check.c    |    5 -----
>  include/linux/elevator.h |    2 ++
>  4 files changed, 26 insertions(+), 22 deletions(-)
> 
> diff --git a/block/elevator.c b/block/elevator.c
> index 282e830..5461075 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -590,11 +590,8 @@ void elv_drain_elevator(struct request_queue *q)
>  /*
>   * Call with queue lock held, interrupts disabled
>   */
> -void elv_quiesce_start(struct request_queue *q)
> +void __elv_quiesce_start(struct request_queue *q)
>  {
> -	if (!q->elevator)
> -		return;
> -
>  	queue_flag_set(QUEUE_FLAG_ELVSWITCH, q);
>  
>  	/*
> @@ -610,11 +607,31 @@ void elv_quiesce_start(struct request_queue *q)
>  	}
>  }
>  
> -void elv_quiesce_end(struct request_queue *q)
> +void elv_quiesce_start(struct request_queue *q)
> +{
> +	if (q->elevator) {
> +		spin_lock_irq(q->queue_lock);
> +		__elv_quiesce_start(q);
> +		spin_unlock_irq(q->queue_lock);
> +	}
> +}
> +
> +void __elv_quiesce_end(struct request_queue *q)
>  {
>  	queue_flag_clear(QUEUE_FLAG_ELVSWITCH, q);
>  }
>  
> +void elv_quiesce_end(struct request_queue *q)
> +{
> +	if (q->elevator) {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(q->queue_lock, flags);
> +		__elv_quiesce_end(q);
> +		spin_unlock_irqrestore(q->queue_lock, flags);
> +	}
> +}
> +
>  void elv_insert(struct request_queue *q, struct request *rq, int where)
>  {
>  	int unplug_it = 1;
> @@ -969,7 +986,7 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
>  	 * Turn on BYPASS and drain all requests w/ elevator private data
>  	 */
>  	spin_lock_irq(q->queue_lock);
> -	elv_quiesce_start(q);
> +	__elv_quiesce_start(q);
>  
>  	/*
>  	 * Remember old elevator.
> @@ -995,9 +1012,7 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
>  	 * finally exit old elevator and turn off BYPASS.
>  	 */
>  	elevator_exit(old_elevator);
> -	spin_lock_irq(q->queue_lock);
>  	elv_quiesce_end(q);
> -	spin_unlock_irq(q->queue_lock);
>  
>  	blk_add_trace_msg(q, "elv switch: %s", e->elevator_type->elevator_name);
>  
> diff --git a/block/genhd.c b/block/genhd.c
> index a8adf96..7d4d860 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -930,14 +930,9 @@ static void disk_free_ptbl_rcu_cb(struct rcu_head *head)
>  	struct disk_part_tbl *ptbl =
>  		container_of(head, struct disk_part_tbl, rcu_head);
>  	struct gendisk *disk = ptbl->disk;
> -	struct request_queue *q = disk->queue;
> -	unsigned long flags;
>  
>  	kfree(ptbl);
> -
> -	spin_lock_irqsave(q->queue_lock, flags);
> -	elv_quiesce_end(q);
> -	spin_unlock_irqrestore(q->queue_lock, flags);
> +	elv_quiesce_end(disk->queue);
>  }
>  
>  /**
> @@ -962,10 +957,7 @@ static void disk_replace_part_tbl(struct gendisk *disk,
>  	if (old_ptbl) {
>  		rcu_assign_pointer(old_ptbl->last_lookup, NULL);
>  
> -		spin_lock_irq(q->queue_lock);
>  		elv_quiesce_start(q);
> -		spin_unlock_irq(q->queue_lock);
> -
>  		call_rcu(&old_ptbl->rcu_head, disk_free_ptbl_rcu_cb);
>  	}
>  }
> diff --git a/fs/partitions/check.c b/fs/partitions/check.c
> index b81bfc0..cf4d1ee 100644
> --- a/fs/partitions/check.c
> +++ b/fs/partitions/check.c
> @@ -367,16 +367,13 @@ static void delete_partition_rcu_cb(struct rcu_head *head)
>  	struct hd_struct *part = container_of(head, struct hd_struct, rcu_head);
>  	struct gendisk *disk = part_to_disk(part);
>  	struct request_queue *q = disk->queue;
> -	unsigned long flags;
>  
>  	part->start_sect = 0;
>  	part->nr_sects = 0;
>  	part_stat_set_all(part, 0);
>  	put_device(part_to_dev(part));
>  
> -	spin_lock_irqsave(q->queue_lock, flags);
>  	elv_quiesce_end(q);
> -	spin_unlock_irqrestore(q->queue_lock, flags);
>  }
>  
>  void delete_partition(struct gendisk *disk, int partno)
> @@ -398,9 +395,7 @@ void delete_partition(struct gendisk *disk, int partno)
>  	kobject_put(part->holder_dir);
>  	device_del(part_to_dev(part));
>  
> -	spin_lock_irq(q->queue_lock);
>  	elv_quiesce_start(q);
> -	spin_unlock_irq(q->queue_lock);
>  
>  	call_rcu(&part->rcu_head, delete_partition_rcu_cb);
>  }
> diff --git a/include/linux/elevator.h b/include/linux/elevator.h
> index 80a0ece..2d30300 100644
> --- a/include/linux/elevator.h
> +++ b/include/linux/elevator.h
> @@ -122,7 +122,9 @@ extern void elv_completed_request(struct request_queue *, struct request *);
>  extern int elv_set_request(struct request_queue *, struct request *, gfp_t);
>  extern void elv_put_request(struct request_queue *, struct request *);
>  extern void elv_drain_elevator(struct request_queue *);
> +extern void __elv_quiesce_start(struct request_queue *);
>  extern void elv_quiesce_start(struct request_queue *);
> +extern void __elv_quiesce_end(struct request_queue *);
>  extern void elv_quiesce_end(struct request_queue *);
>  
>  /*

