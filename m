Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056Ab0LTToA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 14:44:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601Ab0LTTn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 14:43:59 -0500
Date: Mon, 20 Dec 2010 14:43:47 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] cfq-iosched: Add flat mode and switch between two
 modes by "use_hierarchy"
Message-ID: <20101220194347.GE31012@redhat.com>
References: <4CDF7BC5.9080803@cn.fujitsu.com>
 <4CDF9CC6.2040106@cn.fujitsu.com>
 <20101115165319.GI30792@redhat.com>
 <4CE2718C.6010406@kernel.dk>
 <4D01C6AB.9040807@cn.fujitsu.com>
 <4D057AAA.6020800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D057AAA.6020800@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 09:45:14AM +0800, Gui Jianfeng wrote:
[..]
>  
> +	/* Service tree for cfq group flat scheduling mode. */
> +	struct cfq_rb_root flat_service_tree;
> +
>  	/*
>  	 * The priority currently being served
>  	 */
> @@ -647,12 +650,16 @@ cfq_group_slice(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  	struct cfq_entity *cfqe = &cfqg->cfqe;
>  	struct cfq_rb_root *st = cfqe->service_tree;
>  
> -	if (st)
> -		return cfq_target_latency * cfqe->weight
> -			/ st->total_weight;
> -	else
> -		/* If this is the root group, give it a full slice. */
> -		return cfq_target_latency;
> +	if (cfqd->use_hierarchy) {
> +		if (st)
> +			return cfq_target_latency * cfqe->weight
> +				/ st->total_weight;
> +		else
> +			/* If this is the root group, give it a full slice. */
> +			return cfq_target_latency;
> +	} else {
> +		return cfq_target_latency * cfqe->weight / st->total_weight;
> +	}
>  }

Once you have moved the notion of entity and weight of the entity, I think
you can simplify things a bit and come up with a notion of entity slice
in a hieararhy and we can avoid using separate mechanisms for queues and
groups.

There can be multiple ways of doing this and you shall have to see what
is a simple way which works. For queues was keeping a track of average
number of queues and that way estimating the slice length. You can
try keeping track of average number of entities in a group or something
like that. But do think everything now in terms of entities and simplify
the logic a bit.

Thanks
Vivek
