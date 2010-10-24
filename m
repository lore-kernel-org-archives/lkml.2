Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab0JXGwp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 02:52:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483Ab0JXGwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 02:52:44 -0400
Date: Sun, 24 Oct 2010 02:52:39 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] disk_free_ptbl_rcu_cb() crash
Message-ID: <20101024065239.GC7474@redhat.com>
References: <1287868201.2658.563.camel@edumazet-laptop>
 <4CC3CC6F.8090606@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC3CC6F.8090606@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 24, 2010 at 08:04:31AM +0200, Jens Axboe wrote:
> On 2010-10-23 23:10, Eric Dumazet wrote:
> > Current Linus tree makes my machine crash in disk_free_ptbl_rcu_cb(),
> > while booting...
> > 
> > commit 7681bfeeccff5ef seems the problem ?
> > 
> > Following patch solves the NULL dereference, but this is only to show
> > you where the problem is, not a real fix, of course.
> 
> Darn. Your fix is on the right path, you missed one though. I think it's
> cleaner to move this into the elevator helpers, so that the callers can
> remain clean.
> 
> Can you verify that this works too?

Hi Jens,

I am wondering if this fix is safe. Looking at the memstick backtrace in
other mail thread, it looks like request queue itself has been freed. So we
probably should be checking for request queue being valid before we try to
check q->elevator being valid.

P.S. I tried sending the same response from gmail account but it bounced.
So if you get this mail twice, please ignore.

Vivek 
> 
> diff --git a/block/elevator.c b/block/elevator.c
> index 2569512..f08ae2d 100644
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
> 
> -- 
> Jens Axboe
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
