Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067Ab1BNSNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:13:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab1BNSN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:13:29 -0500
Date: Mon, 14 Feb 2011 13:13:22 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shaohua.li@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH 3/6 v4] cfq-iosched: Introduce vdisktime and io weight
 for CFQ queue
Message-ID: <20110214181322.GJ13097@redhat.com>
References: <4D51ED26.8050809@cn.fujitsu.com>
 <4D539804.9090308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D539804.9090308@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 03:47:16PM +0800, Gui Jianfeng wrote:

[..]
> +/*
> + * The time when a CFQ queue is put onto a service tree is recoreded in
> + * cfqq->reposition_time. Currently, we check the first priority CFQ queues
> + * on each service tree, and select the workload type that contains the lowest
> + * reposition_time CFQ queue among them.
> + */
>  static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
>  				struct cfq_group *cfqg, enum wl_prio_t prio)
>  {
>  	struct cfq_entity *cfqe;
> +	struct cfq_queue *cfqq;
> +	unsigned long lowest_start_time;
>  	int i;
> -	bool key_valid = false;
> -	unsigned long lowest_key = 0;
> +	bool time_valid = false;
>  	enum wl_type_t cur_best = SYNC_NOIDLE_WORKLOAD;
>  
> +	/*
> +	 * TODO: We may take io priority and io class into account when
> +	 * choosing a workload type. But for the time being just make use of
> +	 * reposition_time only.
> +	 */
>  	for (i = 0; i <= SYNC_WORKLOAD; ++i) {
> -		/* select the one with lowest rb_key */
>  		cfqe = cfq_rb_first(service_tree_for(cfqg, prio, i));
> -		if (cfqe &&
> -		    (!key_valid || time_before(cfqe->rb_key, lowest_key))) {
> -			lowest_key = cfqe->rb_key;
> +		cfqq = cfqq_of_entity(cfqe);
> +		if (cfqe && (!time_valid ||
> +			     time_before(cfqq->reposition_time,
> +					 lowest_start_time))) {
> +			lowest_start_time = cfqq->reposition_time;

Gui,

Have you had a chance to run some mixed workloads in a group (some sync,
some async and some sync-idle queues), and see how latency and throughput
of sync-idle workload changes due to this "resposition_time" logic. I 
just want to make sure that latency of sync-noidle workload does not
go up as that's the workload that people care and gets noticed first.

Thanks
Vivek
