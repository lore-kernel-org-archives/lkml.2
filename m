Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab1CYPWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:22:34 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:46255 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab1CYPWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:22:33 -0400
Date: Fri, 25 Mar 2011 16:22:28 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [OOPS] elevator private data for REQ_FLUSH
Message-ID: <20110325152228.GA1707@gentoo.trippels.de>
References: <20110325151530.GA4414@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110325151530.GA4414@swordfish.minsk.epam.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.03.25 at 17:15 +0200, Sergey Senozhatsky wrote:
> Hello,
> 
> Commit
>     9d5a4e946ce5352f19400b6370f4cd8e72806278
>     block: skip elevator data initialization for flush requests
>     
>     Skip elevator initialization for flush requests by passing priv=0 to
>     blk_alloc_request() in get_request().  As such elv_set_request() is
>     never called for flush requests.
> 
> introduced priv flag, to skip elevator_private data init for FLUSH requests.
> This, I guess, lead to NULL pointer deref on my machine in cfq_insert_request,
> which requires elevator_private to be set:
> 
>   1 [   78.982169] Call Trace:                                                                                                                                                                                                     
>   2 [   78.982178]  [<ffffffff8122d1fe>] cfq_insert_request+0x4e/0x47d
>   3 [   78.982184]  [<ffffffff8123e139>] ? do_raw_spin_lock+0x6b/0x122

> Should we in that case use ELEVATOR_INSERT_FLUSH for REQ_FLUSH | REQ_FUA requests
> (like below)?
> 
> ---
> 
>  block/elevator.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/block/elevator.c b/block/elevator.c
> index c387d31..b17e577 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -734,6 +734,8 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
>  			q->end_sector = rq_end_sector(rq);
>  			q->boundary_rq = rq;
>  		}
> +	} else if (rq->cmd_flags & (REQ_FLUSH | REQ_FUA)) {
> +		where = ELEVATOR_INSERT_FLUSH;
>  	} else if (!(rq->cmd_flags & REQ_ELVPRIV) &&
>  		    where == ELEVATOR_INSERT_SORT)
>  		where = ELEVATOR_INSERT_BACK;

Thanks. That solves all (corruption-) problems that I reported earlier in an other
thread. 
-- 
Markus
