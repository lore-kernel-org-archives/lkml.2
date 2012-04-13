Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab2DMPVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 11:21:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab2DMPVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 11:21:30 -0400
Date: Fri, 13 Apr 2012 11:21:23 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 7/8] blkcg: implement per-queue policy activation
Message-ID: <20120413152122.GC26383@redhat.com>
References: <1334273380-30233-1-git-send-email-tj@kernel.org>
 <1334273380-30233-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334273380-30233-8-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 04:29:39PM -0700, Tejun Heo wrote:

[..]
> @@ -111,12 +122,11 @@ static struct blkio_group *blkg_alloc(struct blkio_cgroup *blkcg,
>  		struct blkio_policy_type *pol = blkio_policy[i];
>  		struct blkg_policy_data *pd;
>  
> -		if (!pol)
> +		if (!blkcg_policy_enabled(q, pol))
>  			continue;
>  
>  		/* alloc per-policy data and attach it to blkg */
> -		pd = kzalloc_node(sizeof(*pd) + pol->pdata_size, GFP_ATOMIC,
> -				  q->node);
> +		pd = kzalloc_node(blkg_pd_size(pol), GFP_ATOMIC, q->node);
>  		if (!pd) {
>  			blkg_free(blkg);
>  			return NULL;
> @@ -130,7 +140,7 @@ static struct blkio_group *blkg_alloc(struct blkio_cgroup *blkcg,
>  	for (i = 0; i < BLKCG_MAX_POLS; i++) {
>  		struct blkio_policy_type *pol = blkio_policy[i];
>  
> -		if (pol)
> +		if (blkcg_policy_enabled(blkg->q, pol))
>  			pol->ops.blkio_init_group_fn(blkg);
>  	}

May be pol->ops.blkio_init_group_fn() can be called in the loop above
where you are allocating the group. So you don't end up looping through
policies twice and don't have to call blkcg_policy_enabled() twice.

Thanks
Vivek
