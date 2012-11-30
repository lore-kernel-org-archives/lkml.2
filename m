Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab2K3WPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 17:15:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab2K3WPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 17:15:45 -0500
Date: Fri, 30 Nov 2012 14:15:42 -0800
From: Zach Brown <zab@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] bdi: add a user-tunable cpu_list for the bdi flusher
 threads
Message-ID: <20121130221542.GM18574@lenny.home.zabbo.net>
References: <x49boehtipu.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49boehtipu.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	ret = cpulist_parse(buf, newmask);
> +	if (!ret) {
> +		spin_lock(&bdi->wb_lock);
> +		task = wb->task;
> +		get_task_struct(task);
> +		spin_unlock(&bdi->wb_lock);
> +		if (task)
> +			ret = set_cpus_allowed_ptr(task, newmask);
> +		put_task_struct(task);

If that test for a non-null task is needed then surely the get and put
need to be similarly protected :).

> +		bdi->flusher_cpumask = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
> +		if (!bdi->flusher_cpumask)
> +			return -ENOMEM;

The bare GFP_KERNEL raises an eyebrow.  Some bdi_init() callers like
blk_alloc_queue_node() look like they'll want to pass in a gfp_t for the
allocation.

And shouldn't this be freed in the error path of bdi_init()?

- z
