Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab0GIHnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 03:43:05 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53671 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab0GIHnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 03:43:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 9 Jul 2010 16:38:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       Vivek Goyal <vgoyal@redhat.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       taka@valinux.co.jp, Andrea Righi <righi.andrea@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 02/11] blkiocg async: The main part of iotrack
Message-Id: <20100709163820.c7cd687b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C369452.2070103@ds.jp.nec.com>
References: <4C369009.80503@ds.jp.nec.com>
	<4C369452.2070103@ds.jp.nec.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Jul 2010 23:15:30 -0400
Munehiro Ikeda <m-ikeda@ds.jp.nec.com> wrote:

> Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
> Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>
> Signed-off-by: Andrea Righi <arighi@develer.com>
> Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
> ---
>  block/Kconfig.iosched       |    8 +++
>  block/Makefile              |    1 +
>  block/blk-iotrack.c         |  129 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/blk-iotrack.h |   62 +++++++++++++++++++++
>  include/linux/page_cgroup.h |   25 ++++++++
>  init/Kconfig                |    2 +-
>  mm/page_cgroup.c            |   91 +++++++++++++++++++++++++++---
>  7 files changed, 309 insertions(+), 9 deletions(-)
>  create mode 100644 block/blk-iotrack.c
>  create mode 100644 include/linux/blk-iotrack.h
> 
> diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
> index 3199b76..3ab712d 100644
> --- a/block/Kconfig.iosched
> +++ b/block/Kconfig.iosched
> @@ -43,6 +43,14 @@ config CFQ_GROUP_IOSCHED
>  	---help---
>  	  Enable group IO scheduling in CFQ.
>  
> +config GROUP_IOSCHED_ASYNC
> +	bool "CFQ Group Scheduling for async IOs (EXPERIMENTAL)"
> +	depends on CFQ_GROUP_IOSCHED && EXPERIMENTAL
> +	select MM_OWNER
> +	default n
> +	help
> +	  Enable group IO scheduling for async IOs.
> +
>  choice
>  	prompt "Default I/O scheduler"
>  	default DEFAULT_CFQ
> diff --git a/block/Makefile b/block/Makefile
> index 0bb499a..441858d 100644
> --- a/block/Makefile
> +++ b/block/Makefile
> @@ -9,6 +9,7 @@ obj-$(CONFIG_BLOCK) := elevator.o blk-core.o blk-tag.o blk-sysfs.o \
>  
>  obj-$(CONFIG_BLK_DEV_BSG)	+= bsg.o
>  obj-$(CONFIG_BLK_CGROUP)	+= blk-cgroup.o
> +obj-$(CONFIG_GROUP_IOSCHED_ASYNC) += blk-iotrack.o
>  obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
>  obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadline-iosched.o
>  obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
> diff --git a/block/blk-iotrack.c b/block/blk-iotrack.c
> new file mode 100644
> index 0000000..d98a09a
> --- /dev/null
> +++ b/block/blk-iotrack.c
> @@ -0,0 +1,129 @@
> +/* blk-iotrack.c - Block I/O Tracking
> + *
> + * Copyright (C) VA Linux Systems Japan, 2008-2009
> + * Developed by Hirokazu Takahashi <taka@valinux.co.jp>
> + *
> + * Copyright (C) 2010 Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/sched.h>
> +#include <linux/mm.h>
> +#include <linux/memcontrol.h>
> +#include <linux/mm_inline.h>
> +#include <linux/rcupdate.h>
> +#include <linux/module.h>
> +#include <linux/blkdev.h>
> +#include <linux/blk-iotrack.h>
> +#include "blk-cgroup.h"
> +
> +/*
> + * The block I/O tracking mechanism is implemented on the cgroup memory
> + * controller framework. It helps to find the the owner of an I/O request
> + * because every I/O request has a target page and the owner of the page
> + * can be easily determined on the framework.
> + */
> +
> +/* Return the blkio_cgroup that associates with a process. */
> +static inline struct blkio_cgroup *task_to_blkio_cgroup(struct task_struct *p)
> +{
> +	return cgroup_to_blkio_cgroup(task_cgroup(p, blkio_subsys_id));
> +}
> +
> +/**
> + * blk_iotrack_set_owner() - set the owner ID of a page.
> + * @page:	the page we want to tag
> + * @mm:		the mm_struct of a page owner
> + *
> + * Make a given page have the blkio-cgroup ID of the owner of this page.
> + */
> +int blk_iotrack_set_owner(struct page *page, struct mm_struct *mm)
> +{
> +	struct blkio_cgroup *blkcg;
> +	unsigned short id = 0;	/* 0: default blkio_cgroup id */
> +
> +	if (blk_iotrack_disabled())
> +		return 0;
> +	if (!mm)
> +		goto out;
> +
> +	rcu_read_lock();
> +	blkcg = task_to_blkio_cgroup(rcu_dereference(mm->owner));
> +	if (likely(blkcg))
> +		id = css_id(&blkcg->css);
> +	rcu_read_unlock();
> +out:
> +	return page_cgroup_set_owner(page, id);
> +}
> +

I think this is bad. I/O should be charged against threads i.e. "current",
because CFQ/blockio-cgroup provides per-thread control.
mm->owner is not suitable, I think.

Thank,s
-Kame


