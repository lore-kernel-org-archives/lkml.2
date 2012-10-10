Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab2JJQzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 12:55:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054Ab2JJQzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 12:55:23 -0400
Date: Wed, 10 Oct 2012 10:22:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Robin Dong <robin.k.dong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Robin Dong <sanbai@taobao.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <boyu.mt@taobao.com>
Subject: Re: [PATCH V3] block/throttle: Add IO throttled information in
 blkio.throttle
Message-ID: <20121010142218.GE16136@redhat.com>
References: <1349765625-4020-1-git-send-email-robin.k.dong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349765625-4020-1-git-send-email-robin.k.dong@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 02:53:45PM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> Currently, if the IO is throttled by io-throttle, the SA has no idea of
> the situation and can't report it to the real application user about
> that he/she has to do something. So this patch adds a new interface
> named blkio.throttle.io_queued which indicates how many IOs are
> currently throttled.
> 
> The nr_queued[] of struct throtl_grp is of type "unsigned int" and updates
> to it are atomic both at 32bit and 64bit platforms, so we could just
> read tg->nr_queued only under blkcg->lock.
> 
> Changelog from v2:
> 	Use nr-queued[] of struct throtl_grp for stats instaed of adding new blkg_rwstat.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---
>  block/blk-throttle.c |   40 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 40 insertions(+), 0 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index a9664fa..e410448 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -953,6 +953,32 @@ static u64 tg_prfill_cpu_rwstat(struct seq_file *sf,
>  	return __blkg_prfill_rwstat(sf, pd, &rwstat);
>  }
>  
> +static u64 tg_prfill_io_queued(struct seq_file *sf,
> +				struct blkg_policy_data *pd, int off)
> +{
> +	static const char *rwstr[] = {
> +		[READ]	= "Read",
> +		[WRITE]	= "Write",
> +	};
> +	struct throtl_grp *tg = pd_to_tg(pd);
> +	const char *dname = NULL;
> +	unsigned int v;
> +	int i;
> +
> +	if (pd->blkg->q->backing_dev_info.dev)
> +		dname = dev_name(pd->blkg->q->backing_dev_info.dev);
> +
> +	if (!dname)
> +		return 0;
> +
> +	for (i = 0; i <= WRITE; i++)
> +		seq_printf(sf, "%s %s %u\n", dname, rwstr[i], tg->nr_queued[i]);

You are printing only READ/WRITE stats and not the SYNC/ASYNC stats. This
is not inline with rest of the stats like throttle.io_serviced and
throttle.io_service_bytes.

I guess it is better to maintain rwstat for io_queued and display it
according to io_serviced.

Thanks
Vivek
