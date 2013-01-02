Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab3ABQY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 11:24:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab3ABQYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 11:24:25 -0500
Date: Wed, 2 Jan 2013 11:24:15 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 23/24] cfq-iosched: collect stats from dead cfqgs
Message-ID: <20130102162415.GA4306@redhat.com>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-24-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356726946-26037-24-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 12:35:45PM -0800, Tejun Heo wrote:
> To support hierarchical stats, it's necessary to remember stats from
> dead children.  Add cfqg->dead_stats and make a dying cfqg transfer
> its stats to the parent's dead-stats.

Hi Tejun,

Why not directly transfer stats to cfqg->stats. IOW, what's the advantage
of maintaining dead_stats separately.

[..]
> + * Transfer @cfqg's stats to its parent's dead_stats so that the ancestors'
> + * recursive stats can still account for the amount used by this cfqg after
> + * it's gone.
> + */
> +static void cfqg_stats_xfer_dead(struct cfq_group *cfqg)
> +{
> +	struct cfq_group *parent = cfqg_parent(cfqg);
> +
> +	lockdep_assert_held(cfqg_to_blkg(cfqg)->q->queue_lock);
> +
> +	if (unlikely(!parent))
> +		return;
> +
> +	cfqg_stats_merge(&parent->dead_stats, &cfqg->stats);
> +	cfqg_stats_merge(&parent->dead_stats, &cfqg->dead_stats);
> +	cfqg_stats_reset(&cfqg->stats);
> +	cfqg_stats_reset(&cfqg->dead_stats);

Anyway group will be marked offline and later freed. So resetting stats
might not be required.

In fact if we have a realiable way of resetting status then online/offline
infrastructure might not be required? I think per cpu stats will be a
problem though and that's why we probably require logic to online/offline
the group?

Thanks
Vivek
