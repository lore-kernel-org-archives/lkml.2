Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab1EDJJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 05:09:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56367 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab1EDJJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 05:09:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tSApLJpnugcES177sQgAarxlG3/SOjse/i2qPEekJLwMi8yUucaP1ds6Qz6RpO9PM1
         or4EtOu1Ph4Kw1AtyFlmsbitUew1jH+yz45GOsEdVJj+wdWheHiKjAboEqyaeUvt4Hbk
         k/eu7AP6oRFDu/xIQ4k2llVrATg6yEy947M4o=
Date: Wed, 4 May 2011 11:09:45 +0200
From: Tejun Heo <htejun@gmail.com>
To: shaohua.li@intel.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        jaxboe@fusionio.com, jgarzik@pobox.com, hch@infradead.org,
        djwong@us.ibm.com
Subject: Re: [patch v2 2/3] block: hold queue if flush is running for
 non-queueable flush drive
Message-ID: <20110504090945.GD8007@htj.dyndns.org>
References: <20110504081725.946950281@sli10-conroe.sh.intel.com>
 <20110504082115.270298766@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504082115.270298766@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 04, 2011 at 04:17:27PM +0800, shaohua.li@intel.com wrote:
> In some drives, flush requests are non-queueable. When flush request is running,
> normal read/write requests can't run. If block layer dispatches such request,
> driver can't handle it and requeue it.
> Tejun suggested we can hold the queue when flush is running. This can avoid
> unnecessary requeue.
> Also this can improve performance. Say we have requests f1, w1, f2 (f is flush
> request, and w is write request). When f1 is running, queue will be hold, so w1
> will not be added to queue list. Just after f1 is finished, f2 will be
> dispatched. Since f1 already flushs cache out, f2 can be finished very quickly.
> In my test, the queue holding completely solves a regression introduced by
> commit 53d63e6b0dfb9588, which is about 20% regression running a sysbench fileio
> workload.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

It looks good to me now, but some nitpicks.

> Index: linux/block/blk-flush.c
> ===================================================================
> --- linux.orig/block/blk-flush.c	2011-05-04 14:20:33.000000000 +0800
> +++ linux/block/blk-flush.c	2011-05-04 15:23:50.000000000 +0800
> @@ -199,6 +199,9 @@ static void flush_end_io(struct request
>  
>  	BUG_ON(q->flush_pending_idx == q->flush_running_idx);
>  
> +	queued |= q->flush_queue_delayed;
> +	q->flush_queue_delayed = 0;
> +
>  	/* account completion of the flush request */
>  	q->flush_running_idx ^= 1;
>  	elv_completed_request(q, flush_rq);

Can you please do if (queued || q->flush_queue_delayed) instead of
setting queued?  And please also update the comment above the if
statement so that it explains the flush_queue_delayed case too.

> Index: linux/block/blk.h
> ===================================================================
> --- linux.orig/block/blk.h	2011-05-04 14:20:33.000000000 +0800
> +++ linux/block/blk.h	2011-05-04 16:09:42.000000000 +0800
> @@ -61,7 +61,17 @@ static inline struct request *__elv_next
>  			rq = list_entry_rq(q->queue_head.next);
>  			return rq;
>  		}
> -
> +		/*
> +		 *  Flush request is running and flush request isn't queeueable
> +		 *  in the drive, we can hold the queue till flush request is
> +		 *  finished. Even we don't do this, driver can't dispatch next
> +		 *  requests and will requeue them.
> +		 */

Please explain the f1, w1, f2 case here as that's the biggest reason
this optimization is implemented and also explain the use of
flush_queue_delayed (just explain briefly and refer to
flush_end_io()).

Thank you.

-- 
tejun
