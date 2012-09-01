Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab2IABFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 21:05:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52664 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab2IABFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 21:05:39 -0400
Date: Fri, 31 Aug 2012 18:05:40 -0700
From: Tejun Heo <tj@kernel.org>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V2] block/throttle: Add IO throttled information in
 blkio.throttle.
Message-ID: <20120901010540.GA19535@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346390109-3169-1-git-send-email-tm@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346390109-3169-1-git-send-email-tm@tao.ma>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 01:15:09PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> Currently, if the IO is throttled by io-throttle, the SA has no idea of

What's SA?

> the situation and can't report it to the real application user about
> that he/she has to do something. So this patch adds a new interface

Why does the application user "has to" do something?  There's nothing
the upper layer "must" do.  I'm not necessarily objecting to adding
the stat but the description seems a bit misleading.

> named blkio.throttle.io_queued which indicates how many IOs are
> currently throttled.

Also, the suggested stat is rather lacking for such purposes.  There's
no way other than keeping polling to find out the condition, which is
rather sad.  What's the actual use case here?

> Also another function blkg_rwstat_dec is added since the number of throttled
> IOs can be either added or decreased.

Maybe just make blkg_rwstat_add() to take int64_t instead of uint64_t?

> +static void throtl_update_queued_stats(struct throtl_grp *tg, int rw, int add)
> +{
> +	struct tg_stats_cpu *stats_cpu;
> +	unsigned long flags;
> +
> +	/* If per cpu stats are not allocated yet, don't do any accounting. */
> +	if (tg->stats_cpu == NULL)
> +		return;
> +
> +	/*
> +	 * Disabling interrupts to provide mutual exclusion between two
> +	 * writes on same cpu. It probably is not needed for 64bit. Not
> +	 * optimizing that case yet.
> +	 */
> +	local_irq_save(flags);
> +
> +	stats_cpu = this_cpu_ptr(tg->stats_cpu);
> +	if (add)
> +		blkg_rwstat_add(&stats_cpu->io_queued, rw, 1);
> +	else
> +		blkg_rwstat_dec(&stats_cpu->io_queued, rw, 1);
> +
> +	local_irq_restore(flags);

Adding throttle.io_queued could be a bit more consistent?

Thanks.

-- 
tejun
