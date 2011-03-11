Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab1CKWaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 17:30:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:58635 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab1CKWaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 17:30:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,305,1297065600"; 
   d="scan'208";a="666432999"
From: Andi Kleen <andi@firstfloor.org>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REVIEW] NVM Express driver
References: <20110303204749.GY3663@linux.intel.com>
Date: Fri, 11 Mar 2011 14:29:19 -0800
In-Reply-To: <20110303204749.GY3663@linux.intel.com> (Matthew Wilcox's message
	of "Thu, 3 Mar 2011 15:47:49 -0500")
Message-ID: <m24o79cmv4.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox <willy@linux.intel.com> writes:
> +
> +static struct nvme_queue *get_nvmeq(struct nvme_ns *ns)
> +{
> +	int qid, cpu = get_cpu();
> +	if (cpu < ns->dev->queue_count)
> +		qid = cpu + 1;
> +	else
> +		qid = (cpu % rounddown_pow_of_two(ns->dev->queue_count))
> + 1;

This will be likely a full divide, better use a mask.

> +	nprps = DIV_ROUND_UP(length, PAGE_SIZE);
> +	npages = DIV_ROUND_UP(8 * nprps, PAGE_SIZE);
> +	prps = kmalloc(sizeof(*prps) + sizeof(__le64 *) * npages, GFP_ATOMIC);
> +	prp_page = 0;
> +	if (nprps <= (256 / 8)) {
> +		pool = dev->prp_small_pool;
> +		prps->npages = 0;


Unchecked GFP_ATOMIC allocation? That will oops soon.
Besides GFP_ATOMIC a very risky thing to do on a low memory situation,
which can trigger writeouts.


> +	} else {
> +		pool = dev->prp_page_pool;
> +		prps->npages = npages;
> +	}
> +
> +	prp_list = dma_pool_alloc(pool, GFP_ATOMIC, &prp_dma);
> +	prps->list[prp_page++] = prp_list;

And another one.


Didn't read all of it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
