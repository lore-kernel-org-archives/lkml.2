Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab1EaGQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 02:16:07 -0400
Received: from vint.altlinux.org ([194.107.17.35]:54967 "EHLO
	vint.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab1EaGQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 02:16:05 -0400
X-Greylist: delayed 643 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 May 2011 02:16:05 EDT
Date: Tue, 31 May 2011 10:05:11 +0400
From: "Anton V. Boyarshinov" <boyarsh@altlinux.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: Strange block/scsi/workqueue issue
Message-ID: <20110531100511.7145c545@table.home>
In-Reply-To: <1302714080.2597.29.camel@mulgrave.site>
References: <1302621261.2604.18.camel@mulgrave.site>
	<1302624266.2661.21.camel@dolmen>
	<1302625621.2604.24.camel@mulgrave.site>
	<1302627097.2661.25.camel@dolmen>
	<1302630090.2604.30.camel@mulgrave.site>
	<1302633208.2661.29.camel@dolmen>
	<1302638216.2604.35.camel@mulgrave.site>
	<1302640226.2661.34.camel@dolmen>
	<1302641036.2604.40.camel@mulgrave.site>
	<20110413051846.GD24161@mtj.dyndns.org>
	<20110413060651.GA27823@mtj.dyndns.org>
	<1302686454.2613.4.camel@dolmen>
	<1302703208.2613.18.camel@dolmen>
	<1302714080.2597.29.camel@mulgrave.site>
Organization: ALT Linux
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.0; i586-alt-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> While you still have the problematic system, can you try this patch?
It seems that a scsi_sysfs.c half of this patch there is in 2.6.39, but
not blk.h part. Now we have frequent panics caused NULL in
q->elevator->ops in block/blk.h.

Panic is triggered by connecting USB Storage device without medium
(card reader, android phone). We saw it on different computers with
different kernel builds. Most frequent panics have seen on kernel build
with forsed preemption under relatively havy load (for example, boot).

Regards, Anton

> It avoids changing anything in block (other than to add a missing
> state guard for the elv_next_request).  If it works, we can defer the
> sync vs async discussion and use it for a -stable fix.
> 
> Thanks,
> 
> James
> 
> ---
> 
> diff --git a/block/blk.h b/
> index c8db371..11d0d25 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -62,7 +62,8 @@ static inline struct request
> *__elv_next_request(struct request_queue *q) return rq;
>  		}
>  
> -		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
> +		if (test_bit(QUEUE_FLAG_DEAD, &q->queue_flags) ||
> +		    !q->elevator->ops->elevator_dispatch_fn(q, 0))
>  			return NULL;
>  	}
>  }
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index e44ff64..5aa4246 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -322,14 +322,9 @@ static void
> scsi_device_dev_release_usercontext(struct work_struct *work)
> kfree(evt); }
>  
> -	if (sdev->request_queue) {
> -		sdev->request_queue->queuedata = NULL;
> -		/* user context needed to free queue */
> -		scsi_free_queue(sdev->request_queue);
> -		/* temporary expedient, try to catch use of queue
> lock
> -		 * after free of sdev */
> -		sdev->request_queue = NULL;
> -	}
> +	/* temporary expedient, try to catch use of queue lock after
> +	 * free of sdev */
> +	sdev->request_queue = NULL;
>  
>  	scsi_target_reap(scsi_target(sdev));
>  
> @@ -937,6 +932,11 @@ void __scsi_remove_device(struct scsi_device
> *sdev) if (sdev->host->hostt->slave_destroy)
>  		sdev->host->hostt->slave_destroy(sdev);
>  	transport_destroy_device(dev);
> +	/* Setting this to NULL causes the request function to reject
> +	 * any I/O requests */
> +	sdev->request_queue->queuedata = NULL;
> +	/* Freeing the queue signals to block that we're done */
> +	scsi_free_queue(sdev->request_queue);
>  	put_device(dev);
>  }
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

