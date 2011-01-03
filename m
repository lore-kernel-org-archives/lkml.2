Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab1ACRwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 12:52:43 -0500
Received: from cobra.newdream.net ([66.33.216.30]:34126 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab1ACRwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 12:52:42 -0500
Date: Mon, 3 Jan 2011 09:58:39 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: [PATCH 22/32] ceph: fsc->*_wq's aren't used in memory reclaim
 path
In-Reply-To: <1294062595-30097-23-git-send-email-tj@kernel.org>
Message-ID: <Pine.LNX.4.64.1101030958270.24679@cobra.newdream.net>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-23-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Jan 2011, Tejun Heo wrote:
> fsc->*_wq's aren't depended upon during memory reclaim.  Convert to
> alloc_workqueue() w/o WQ_MEM_RECLAIM.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Sage Weil <sage@newdream.net>
> Cc: ceph-devel@vger.kernel.org
> ---
> Only compile tested.  Please feel free to take it into the subsystem
> tree or simply ack - I'll route it through the wq tree.

I'll take this one through the ceph tree as well.

Thanks!
sage


> 
> Thanks.
> 
>  fs/ceph/super.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 08b460a..1f6436e 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -443,13 +443,17 @@ struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
>  		goto fail_client;
>  
>  	err = -ENOMEM;
> -	fsc->wb_wq = create_workqueue("ceph-writeback");
> +	/*
> +	 * The number of concurrent works can be high but they don't need
> +	 * to be processed in parallel, limit concurrency.
> +	 */
> +	fsc->wb_wq = alloc_workqueue("ceph-writeback", 0, 1);
>  	if (fsc->wb_wq == NULL)
>  		goto fail_bdi;
> -	fsc->pg_inv_wq = create_singlethread_workqueue("ceph-pg-invalid");
> +	fsc->pg_inv_wq = alloc_workqueue("ceph-pg-invalid", 0, 1);
>  	if (fsc->pg_inv_wq == NULL)
>  		goto fail_wb_wq;
> -	fsc->trunc_wq = create_singlethread_workqueue("ceph-trunc");
> +	fsc->trunc_wq = alloc_workqueue("ceph-trunc", 0, 1);
>  	if (fsc->trunc_wq == NULL)
>  		goto fail_pg_inv_wq;
>  
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
