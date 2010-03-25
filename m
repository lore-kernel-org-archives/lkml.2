Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab0CYXDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 19:03:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab0CYXDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 19:03:06 -0400
Date: Thu, 25 Mar 2010 19:02:45 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Chad Talbott <ctalbott@google.com>
Cc: jens.axboe@oracle.com, mrubin@google.com, guijianfeng@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       dpshah@google.com, Nauman Rafique <nauman@google.com>
Subject: Re: [PATCH 2/4] Adds an RCU-protected pointer to request_queue
	that makes it easy to
Message-ID: <20100325230245.GE3041@redhat.com>
References: <20100325180310.25299.64877.stgit@meat.mtv.corp.google.com> <20100325180428.25299.27250.stgit@meat.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100325180428.25299.27250.stgit@meat.mtv.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 11:04:28AM -0700, Chad Talbott wrote:
> find the gendisk that the queue manages.
> ---
>  block/blk-cgroup.c     |   10 ++++++----
>  block/blk-sysfs.c      |    4 ++++
>  include/linux/blkdev.h |    6 ++++++
>  3 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 917957d..809451f 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -179,16 +179,18 @@ static int blkiocg_##__VAR##_read(struct cgroup *cgroup,		\
>  	struct blkio_cgroup *blkcg;					\
>  	struct blkio_group *blkg;					\
>  	struct hlist_node *n;						\
> +	struct gendisk *disk;						\
>  									\
>  	if (!cgroup_lock_live_group(cgroup))				\
>  		return -ENODEV;						\
>  									\
>  	blkcg = cgroup_to_blkio_cgroup(cgroup);				\
>  	rcu_read_lock();						\
> -	hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {\
> -		if (blkg->dev)						\
> -			seq_printf(m, "%u:%u %lu\n", MAJOR(blkg->dev),	\
> -				 MINOR(blkg->dev), blkg->__VAR);	\
> +	hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) { \
> +		disk = rcu_dereference(blkg->queue->disk);		\
> +		if (disk)						\
> +			seq_printf(m, "%s %lu\n", disk->disk_name,	\
> +				   blkg->__VAR);			\
>  	}								\
>  	rcu_read_unlock();						\
>  	cgroup_unlock();						\
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 2ae2cb3..14cab6a 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -484,6 +484,8 @@ int blk_register_queue(struct gendisk *disk)
>  	if (!q->request_fn)
>  		return 0;
>  
> +	rcu_assign_pointer(q->disk, disk);
> +
>  	ret = elv_register_queue(q);
>  	if (ret) {
>  		kobject_uevent(&q->kobj, KOBJ_REMOVE);
> @@ -505,6 +507,8 @@ void blk_unregister_queue(struct gendisk *disk)
>  	if (q->request_fn)
>  		elv_unregister_queue(q);
>  
> +	rcu_assign_pointer(q->disk, NULL);
> +
>  	kobject_uevent(&q->kobj, KOBJ_REMOVE);
>  	kobject_del(&q->kobj);
>  	blk_trace_remove_sysfs(disk_to_dev(disk));
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index ebd22db..e531cf2 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -441,6 +441,12 @@ struct request_queue
>  #if defined(CONFIG_BLK_DEV_BSG)
>  	struct bsg_class_device bsg_dev;
>  #endif
> +
> +	/*
> +	 * an RCU-protected pointer that can be NULL when devices are
> +	 * removed
> +	 */
> +	struct gendisk		*disk;
>  };

Hi Chad,

Where is the code to make sure gendisk does not go away if blk-cgroup code
is referencing blkg->queue->disk under rcu lock? 

Thanks
Vivek
