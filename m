Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab0LWPSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 10:18:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab0LWPSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 10:18:47 -0500
Date: Thu, 23 Dec 2010 10:18:44 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        jmoyer@redhat.com
Subject: Re: [PATCH 2/2]block cfq: don't use atomic_t for cfq_group
Message-ID: <20101223151844.GD9502@redhat.com>
References: <1293072335.10593.22.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293072335.10593.22.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 10:45:35AM +0800, Shaohua Li wrote:
> cfq_group->ref is used with queue_lock hold, the only exception is
> cfq_set_request, which looks like a bug to me, so ref doesn't need
> to be an atomic and atomic operation is slower.
> 

[..]
>  
> @@ -3683,12 +3685,13 @@ new_queue:
>  
>  	cfqq->allocated[rw]++;
>  	cfqq->ref++;
> +	cfqg = cfq_ref_get_cfqg(cfqq->cfqg);
>  
>  	spin_unlock_irqrestore(q->queue_lock, flags);
>  
>  	rq->elevator_private = cic;
>  	rq->elevator_private2 = cfqq;
> -	rq->elevator_private3 = cfq_ref_get_cfqg(cfqq->cfqg);
> +	rq->elevator_private3 = cfqg;

I think you can move every thing under spinlock. IOW, first set the
rq->elevator_private* fields and delay the release of spinlock. Few
days back I was also looking at wondering that why are we releasing
the spinlock early.

Thanks
Vivek
