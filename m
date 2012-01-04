Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab2ADIal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 03:30:41 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58560 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab2ADIaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 03:30:39 -0500
X-Greylist: delayed 641 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jan 2012 03:30:38 EST
X-AuditID: 9c930179-b7c5aae0000046ea-66-4f040ba7d12b
Message-ID: <4F040BA7.9070203@lge.com>
Date: Wed, 04 Jan 2012 17:19:51 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: shaohua.li@intel.com
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, vgoyal@redhat.com,
        jmoyer@redhat.com
Subject: Re: [RFC 1/3]block: seperate CFQ io context management code
References: <20120104065337.230911609@sli10-conroe.sh.intel.com> <20120104065454.001785808@sli10-conroe.sh.intel.com>
In-Reply-To: <20120104065454.001785808@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Two of nitpicks below ..


2012-01-04 3:53 PM, Shaohua Li Wrote:
> CFQ's io context management creates a per-device io context for each task.
> It's quite generic. Separate it from CFQ, and use it for fiops I/O scheduler.
> 
> Signed-off-by: Shaohua Li<shaohua.li@intel.com>
> ---

[snip]

> +int ioc_builder_init(struct ioc_builder *builder)
> +{
> +	if (!builder->alloc_ioc || !builder->free_ioc)
> +		return -ENOMEM;
> +
> +	builder->ioc_count = alloc_percpu(unsigned long);
> +	if (!builder->ioc_count)
> +		return -ENOMEM;
> +
> +	builder->ioc_gone = NULL;
> +	spin_lock_init(&builder->ioc_gone_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ioc_builder_init);
> +
> +void io_context_builder_exit(struct ioc_builder *builder)

It'd be better using 'ioc_builder_exit' as a name for consistency, IMHO.


> +{
> +	DECLARE_COMPLETION_ONSTACK(all_gone);
> +
> +	builder->ioc_gone =&all_gone;
> +	/* ioc_gone's update must be visible before reading ioc_count */
> +	smp_wmb();
> +
> +	/*
> +	 * this also protects us from entering cfq_slab_kill() with
> +	 * pending RCU callbacks
> +	 */
> +	if (elv_ioc_count_read(*builder->ioc_count))
> +		wait_for_completion(&all_gone);
> +
> +	free_percpu(builder->ioc_count);
> +}
> +EXPORT_SYMBOL(io_context_builder_exit);

[snip]

> +static void queue_data_cic_free_rcu(struct rcu_head *head)
> +{
> +	struct dev_io_context *cic;
> +	struct ioc_builder *builder;
> +
> +	cic = container_of(head, struct dev_io_context, rcu_head);
> +	builder = cic->builder;
> +
> +	builder->free_ioc(builder, cic);
> +	elv_ioc_count_dec(*builder->ioc_count);
> +
> +	if (builder->ioc_gone) {
> +		/*
> +		 * CFQ scheduler is exiting, grab exit lock and check

s/CFQ/IO/ ?

Thanks.
Namhyung Kim
