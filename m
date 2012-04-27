Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760263Ab2D0O1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 10:27:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683Ab2D0O1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 10:27:03 -0400
Date: Fri, 27 Apr 2012 10:26:52 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, fengguang.wu@intel.com,
        hughd@google.com, akpm@linux-foundation.org
Subject: Re: [PATCH 01/11] blkcg: fix blkg_alloc() failure path
Message-ID: <20120427142652.GH10579@redhat.com>
References: <1335477561-11131-1-git-send-email-tj@kernel.org>
 <1335477561-11131-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335477561-11131-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 02:59:11PM -0700, Tejun Heo wrote:
> When policy data allocation fails in the middle, blkg_alloc() invokes
> blkg_free() to destroy the half constructed blkg.  This ends up
> calling pd_exit_fn() on policy datas which didn't go through
> pd_init_fn().  Fix it by making blkg_alloc() call pd_init_fn()
> immediately after each policy data allocation.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/blk-cgroup.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 02cf633..4ab7420 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -125,12 +125,8 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q)
>  
>  		blkg->pd[i] = pd;
>  		pd->blkg = blkg;
> -	}
> -
> -	/* invoke per-policy init */
> -	for (i = 0; i < BLKCG_MAX_POLS; i++) {
> -		struct blkcg_policy *pol = blkcg_policy[i];
>  
> +		/* invoke per-policy init */
>  		if (blkcg_policy_enabled(blkg->q, pol))
>  			pol->pd_init_fn(blkg);

Deja Vu. In one of the mails I had said that how about moving init_fn
in upper loop and get rid of for loop below. Then retracted it saying
probably you wanted to allocate all the groups first before calling 
init functions of individual policies. Here we are back again for a
different reason though. :-)

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek
>  	}
> -- 
> 1.7.7.3
