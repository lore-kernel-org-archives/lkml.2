Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759863Ab1CDQk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 11:40:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759607Ab1CDQk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 11:40:58 -0500
Date: Fri, 4 Mar 2011 11:40:52 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, lkml <linux-kernel@vger.kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, Corrado Zoccolo <czoccolo@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH]cfq-iosched: give busy sync queue no dispatch limit
Message-ID: <20110304164052.GA5466@redhat.com>
References: <1299225689.2337.4.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299225689.2337.4.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 04:01:29PM +0800, Shaohua Li wrote:

[..]
> @@ -2412,15 +2418,31 @@ static bool cfq_may_dispatch(struct cfq_
>  			return false;
>  
>  		/*
> +		 * If there is only one sync queue, and its think time is
> +		 * small, we can ignore async queue here and give the sync
> +		 * queue no dispatch limit. The reason is a sync queue can
> +		 * preempt async queue, limiting the sync queue doesn't make
> +		 * sense. This is useful for aiostress test.
> +		 */
> +		if (cfq_cfqq_sync(cfqq) && cfqd->busy_sync_queues == 1) {
> +			struct cfq_io_context *cic = RQ_CIC(cfqq->next_rq);
> +
> +			if (sample_valid(cic->ttime_samples) &&
> +				cic->ttime_mean < cfqd->cfq_slice_idle)
> +				promote_sync = true;
> +		}

What's the relation of think time here? Or why should we check for think
time being small. To me it does not make a difference in this case.

We have a request in existing queue and we figure out that this is the
only sync queue in the system to we let it dispatch more than quantum.
Thinktime should not even matter.

Thanks
Vivek
