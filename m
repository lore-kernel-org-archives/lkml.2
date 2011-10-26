Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567Ab1JZQBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 12:01:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933042Ab1JZQBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 12:01:06 -0400
Date: Wed, 26 Oct 2011 12:01:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/13] block: make ioc get/put interface more
 conventional and fix race on alloction
Message-ID: <20111026160101.GB355@redhat.com>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
 <1319593719-19132-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319593719-19132-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 06:48:30PM -0700, Tejun Heo wrote:

[..]
> @@ -1645,11 +1645,12 @@ static void blkiocg_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
>  {
>  	struct io_context *ioc;
>  
> -	task_lock(tsk);
> -	ioc = tsk->io_context;
> -	if (ioc)
> +	/* we don't lose anything even if ioc allocation fails */
> +	ioc = get_task_io_context(tsk, GFP_ATOMIC, NUMA_NO_NODE);
> +	if (ioc) {
>  		ioc->cgroup_changed = 1;
> -	task_unlock(tsk);
> +		put_io_context(ioc);
> +	}

We really don't need to create a new io context here if it is not present.
cgroup_changed is set so that reference to old sync cfqq is dropped and
a new one is assigned when new IO comes in. Given the fact that io context
is not even present for the task being attached, there is no way there
is associated cic and associated cfqq. So no need to set changed_cgroup=1.

Will it make sense to pass in additional parameter to get_task_io_context()
so that it takes a reference if ioc exists otherwise returns NULL. Or may
be another variant of get_task_io_context() function.

This is a minor issue though. Will just avoid creating iocontext memory
for task if one is not using CFQ in the system.

[..]
>  
> +extern char __blk_test_mode[2];
> +#define blk_test_mode	(__blk_test_mode[0])
> +

Looks like leftover of your testing code.

Thanks
Vivek
