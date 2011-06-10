Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab1FJFsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 01:48:50 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:49988 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751130Ab1FJFst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 01:48:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=X2ORpAGoRGRVZxgF+D4aQfhphKwlGnov/O5Oa1S/SEpXAKYa6EciYHIzk1cIHLUkbMOuGV0W4d27EQJrojnp1hHYw1XbTRZ86nzDMsXYeSjyPQ9hI7v9ix2Ns02RYui9;
Message-ID: <4DF1B035.7080009@tao.ma>
Date: Fri, 10 Jun 2011 13:48:37 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: CFQ: async queue blocks the whole system
References: <1307616577-6101-1-git-send-email-tm@tao.ma> <20110609141451.GD29913@redhat.com> <4DF0DD0F.8090407@tao.ma> <20110609153738.GF29913@redhat.com> <4DF0EA55.10209@tao.ma> <20110609182706.GG29913@redhat.com>
In-Reply-To: <20110609182706.GG29913@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 02:27 AM, Vivek Goyal wrote:
> On Thu, Jun 09, 2011 at 11:44:21PM +0800, Tao Ma wrote:
> 
> [..]
>>> CFQ in general tries not to drive too deep a queue depth in an effort
>>> to improve latencies. CFQ is generally recommened for slow SATA drives
>>> and dispatching too many requests from a single queue can only serve to
>>> increase the latency.
>> ok, so do you mean that for a fast drive, cfq isn't recommended and
>> deadline is always prefered? ;) We have a SAS with queue_depth=128, so
>> it should be a fast drive I guess. :)
> 
> I think in general that has been true in my experience. SSDs are still
> ok with CFQ because that sets nonrotational flag and cuts down on 
> idling. But if it is a rotational media which can handle multiple
> parallel requests at a time you might have better throughput results
> with deadline.
Thank you for the advice.
> 
> [..]
>>> Its latency vs throughput tradeoff.
>> ok, so it seems that all these are designed, not a bug. Thanks for the
>> clarification.
>>
>> btw, reverting the patch doesn't work. I can still get the livelock.
> 
> Can you give following patch a try and see if it helps. On my system this
> does allow CFQ to dispatch some writes once in a while.
Sorry, this patch doesn't work in my test.

Regards,
Tao
> 
> thanks
> Vivek
> 
> ---
>  block/cfq-iosched.c |   25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/block/cfq-iosched.c
> ===================================================================
> --- linux-2.6.orig/block/cfq-iosched.c	2011-06-09 11:44:40.000000000 -0400
> +++ linux-2.6/block/cfq-iosched.c	2011-06-09 14:04:01.036983301 -0400
> @@ -303,6 +303,8 @@ struct cfq_data {
>  
>  	/* Number of groups which are on blkcg->blkg_list */
>  	unsigned int nr_blkcg_linked_grps;
> +
> +	unsigned long last_async_dispatched;
>  };
>  
>  static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
> @@ -2063,6 +2065,10 @@ static void cfq_dispatch_insert(struct r
>  
>  	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
>  	cfqq->nr_sectors += blk_rq_sectors(rq);
> +
> +	if (!cfq_cfqq_sync(cfqq))
> +		cfqd->last_async_dispatched = jiffies;
> +
>  	cfq_blkiocg_update_dispatch_stats(&cfqq->cfqg->blkg, blk_rq_bytes(rq),
>  					rq_data_dir(rq), rq_is_sync(rq));
>  }
> @@ -3315,8 +3321,25 @@ cfq_should_preempt(struct cfq_data *cfqd
>  	 * if the new request is sync, but the currently running queue is
>  	 * not, let the sync request have priority.
>  	 */
> -	if (rq_is_sync(rq) && !cfq_cfqq_sync(cfqq))
> +	if (rq_is_sync(rq) && !cfq_cfqq_sync(cfqq)) {
> +		unsigned long async_delay = 0;
> +
> +		async_delay = jiffies - cfqd->last_async_dispatched;
> +
> +		/*
> +		 * CFQ is heavily loaded in favor of sync queues and that
> + 		 * can lead to starvation of async queues. If it has been
> + 		 * too long since last async request was dispatched, don't
> + 		 * preempt async queue
> + 		 *
> + 		 * Once we have per group async queues, this will need
> + 		 * modification.
> + 		 */
> +		if (async_delay > 2 * HZ)
> +			return false;
> +
>  		return true;
> +	}
>  
>  	if (new_cfqq->cfqg != cfqq->cfqg)
>  		return false;

