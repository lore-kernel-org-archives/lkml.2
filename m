Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab1BKS6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 13:58:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013Ab1BKS6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 13:58:31 -0500
Date: Fri, 11 Feb 2011 13:58:25 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Justin TerAvest <teravest@google.com>
Cc: jaxboe@fusionio.com, ctalbott@google.com, mrubin@google.com,
        jmoyer@redhat.com, guijanfeng@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Don't update group weights when on service tree.
Message-ID: <20110211185825.GJ8773@redhat.com>
References: <1297372086-16138-1-git-send-email-teravest@google.com>
 <1297372086-16138-2-git-send-email-teravest@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297372086-16138-2-git-send-email-teravest@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 01:08:06PM -0800, Justin TerAvest wrote:

[..]
> +static void
> +cfq_update_group_weight(struct cfq_group *cfqg)
> +{
> +	BUG_ON(!RB_EMPTY_NODE(&cfqg->rb_node));
> +	if (cfqg->needs_update) {
> +		cfqg->weight = cfqg->new_weight;
> +		cfqg->needs_update = false;
> +	}
> +}
> +
>  static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
>  {
>  	unsigned int slice_used;
> @@ -952,9 +977,11 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
>  		charge = cfqq->allocated_slice;
>  
>  	/* Can't update vdisktime while group is on service tree */
> -	cfq_rb_erase(&cfqg->rb_node, st);
> +	cfq_group_service_tree_del(st, cfqg);
>  	cfqg->vdisktime += cfq_scale_slice(charge, cfqg);
> -	__cfq_group_service_tree_add(st, cfqg);
> +	/* If a new weight was requested, update now, off tree */
> +	cfq_update_group_weight(cfqg);
> +	cfq_group_service_tree_add(st, cfqg);

Justin,

Can we move cfq_update_group_weight() inside cfq_group_service_tree_add()? 
That way any time a group is added fresh to service tree, we check for
weight updates.

Currently a weight update will not take effect until and unless a group
has gone through addition/deletion cycle.

If a group remains backlogged for long time, then also weight update will
not take effect. Sadly we can't take queue lock in weight update path
so we need to do this with some kind of worker thread. I guess we will
deal with that later. For the time being cheking for group updates more
frequently will make sure weight update will be processed even when
a new group gets backlogged for the first time.

Thanks
Vivek
