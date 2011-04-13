Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab1DMUMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:12:40 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:40700 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab1DMUMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 16:12:39 -0400
X-ASG-Debug-ID: 1302725557-01de284cf81414a0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DA603AF.9090202@fusionio.com>
Date: Wed, 13 Apr 2011 22:12:31 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Steven Whitehouse <swhiteho@redhat.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Strange block/scsi/workqueue issue
References: <1302621261.2604.18.camel@mulgrave.site>	 <1302624266.2661.21.camel@dolmen> <1302625621.2604.24.camel@mulgrave.site>	 <1302627097.2661.25.camel@dolmen> <1302630090.2604.30.camel@mulgrave.site>	 <1302633208.2661.29.camel@dolmen> <1302638216.2604.35.camel@mulgrave.site>	 <1302640226.2661.34.camel@dolmen> <1302641036.2604.40.camel@mulgrave.site>	 <20110413051846.GD24161@mtj.dyndns.org>	 <20110413060651.GA27823@mtj.dyndns.org>  <1302686454.2613.4.camel@dolmen>	 <1302703208.2613.18.camel@dolmen> <1302714080.2597.29.camel@mulgrave.site>
X-ASG-Orig-Subj: Re: Strange block/scsi/workqueue issue
In-Reply-To: <1302714080.2597.29.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1302725557
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.50
X-Barracuda-Spam-Status: No, SCORE=0.50 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_RULE7568M
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.60765
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.50 BSF_RULE7568M          Custom Rule 7568M
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-13 19:01, James Bottomley wrote:
> While you still have the problematic system, can you try this patch?  It
> avoids changing anything in block (other than to add a missing state
> guard for the elv_next_request).  If it works, we can defer the sync vs
> async discussion and use it for a -stable fix.
> 
> Thanks,
> 
> James
> 
> ---
> 
> diff --git a/block/blk.h b/block/blk.h
> index c8db371..11d0d25 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -62,7 +62,8 @@ static inline struct request *__elv_next_request(struct request_queue *q)
>  			return rq;
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
> @@ -322,14 +322,9 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
>  		kfree(evt);
>  	}
>  
> -	if (sdev->request_queue) {
> -		sdev->request_queue->queuedata = NULL;
> -		/* user context needed to free queue */
> -		scsi_free_queue(sdev->request_queue);
> -		/* temporary expedient, try to catch use of queue lock
> -		 * after free of sdev */
> -		sdev->request_queue = NULL;
> -	}
> +	/* temporary expedient, try to catch use of queue lock after
> +	 * free of sdev */
> +	sdev->request_queue = NULL;
>  
>  	scsi_target_reap(scsi_target(sdev));
>  
> @@ -937,6 +932,11 @@ void __scsi_remove_device(struct scsi_device *sdev)
>  	if (sdev->host->hostt->slave_destroy)
>  		sdev->host->hostt->slave_destroy(sdev);
>  	transport_destroy_device(dev);
> +	/* Setting this to NULL causes the request function to reject
> +	 * any I/O requests */
> +	sdev->request_queue->queuedata = NULL;
> +	/* Freeing the queue signals to block that we're done */
> +	scsi_free_queue(sdev->request_queue);
>  	put_device(dev);
>  }

This patch looks pretty clean. Shouldn't you serialize that ->queuedata
= NULL assignment with the queue lock, though?

-- 
Jens Axboe

