Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985Ab2ASUce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 15:32:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932705Ab2ASUcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 15:32:33 -0500
Date: Thu, 19 Jan 2012 15:32:25 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] blkcg: kill blkio_policy_node
Message-ID: <20120119203225.GA4421@redhat.com>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
 <1326935490-11827-12-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326935490-11827-12-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 05:11:29PM -0800, Tejun Heo wrote:

[..]
> @@ -1413,14 +1110,10 @@ static int blkio_weight_write(struct blkio_cgroup *blkcg, u64 val)
>  	spin_lock_irq(&blkcg->lock);
>  	blkcg->weight = (unsigned int)val;
>  
> -	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
> -		pn = blkio_policy_search_node(blkcg, blkg->dev,
> -				BLKIO_POLICY_PROP, BLKIO_PROP_weight_device);
> -		if (pn)
> -			continue;
> +	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node)
> +		if (blkg->plid == plid && !blkg->conf.weight)
> +			blkio_update_group_weight(blkg, blkcg->weight);

Tejun,

Why do we check for blkg->conf.weight=0 here. Even if a group already has
weight and if user has changed the cgroup weight later, that update should
be propogated to all the groups on all the queues.

Where do we assign default cgroup weight to a blkg upon creation? May be at
group create time, we just need to copy blkcg->weight to blkg.conf.weight.

Thanks
Vivek
