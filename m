Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731Ab1IKBf4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 21:35:56 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51667 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036Ab1IKBfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 21:35:55 -0400
Date: Sun, 11 Sep 2011 10:35:49 +0900
From: Tejun Heo <tj@kernel.org>
To: Thomas Tuttle <ttuttle@chromium.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] workqueue: lock cwq access in drain_workqueue
Message-ID: <20110911013549.GI29319@htj.dyndns.org>
References: <20110909152222.GA14705@google.com>
 <20110909230053.GA28394@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110909230053.GA28394@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 09, 2011 at 07:00:53PM -0400, Thomas Tuttle wrote:
> Take cwq->gcwq->lock to avoid racing between drain_workqueue checking
> to make sure the workqueues are empty and cwq_dec_nr_in_flight
> decrementing and then incrementing nr_active when it activates a
> delayed work.

Nice catch.  Just few minor nits below.

> We discovered this when a corner case in one of our drivers resulted in
> us trying to destroy a workqueue in which the remaining work would
> always requeue itself again in the same workqueue.  We would hit this
> race condition and trip the BUG_ON on workqueue.c:3080.
> 
> Signed-off-by: Thomas Tuttle <ttuttle@chromium.org>
> ---
> Updated to use bool instead of int (d'oh), and CCed maintainer.
> 
>  kernel/workqueue.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 25fb1b0..0c2e585 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2412,8 +2412,14 @@ reflush:
>  
>  	for_each_cwq_cpu(cpu, wq) {
>  		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
> +		bool cwq_flushed;

Maybe "drained" would be better?

> -		if (!cwq->nr_active && list_empty(&cwq->delayed_works))
> +		spin_lock_irq(&cwq->gcwq->lock);
> +		cwq_flushed = !cwq->nr_active
> +			      && list_empty(&cwq->delayed_works);

and then this should fit inside 80 column, right?

Thanks.

-- 
tejun
