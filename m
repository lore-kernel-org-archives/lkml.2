Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab2K1VHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:07:31 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:61274 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab2K1VH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:07:29 -0500
Date: Wed, 28 Nov 2012 13:07:19 -0800
From: Tejun Heo <tj@kernel.org>
To: Greg Thelen <gthelen@google.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Durbin <adurbin@google.com>
Subject: Re: [PATCH] cgroup: fix lockdep warning for event_control
Message-ID: <20121128210719.GB24683@htj.dyndns.org>
References: <1354133742-22175-1-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354133742-22175-1-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

On Wed, Nov 28, 2012 at 12:15:42PM -0800, Greg Thelen wrote:
> @@ -4276,6 +4276,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
>  	DEFINE_WAIT(wait);
>  	struct cgroup_event *event, *tmp;
>  	struct cgroup_subsys *ss;
> +	struct list_head tmp_list;

LIST_HEAD(tmp_list);

>  
>  	lockdep_assert_held(&d->d_inode->i_mutex);
>  	lockdep_assert_held(&cgroup_mutex);
> @@ -4330,16 +4331,20 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
>  	/*
>  	 * Unregister events and notify userspace.
>  	 * Notify userspace about cgroup removing only after rmdir of cgroup
> -	 * directory to avoid race between userspace and kernelspace
> +	 * directory to avoid race between userspace and kernelspace. Use
> +	 * a temporary list to avoid a deadlock with cgroup_event_wake(). Since
> +	 * cgroup_event_wake() is called with the wait queue head locked,
> +	 * remove_wait_queue() cannot be called while holding event_list_lock.
>  	 */
>  	spin_lock(&cgrp->event_list_lock);
> -	list_for_each_entry_safe(event, tmp, &cgrp->event_list, list) {
> +	list_replace_init(&cgrp->event_list, &tmp_list);

list_splice_init();

would be more conventional, I think.

> +	spin_unlock(&cgrp->event_list_lock);
> +	list_for_each_entry_safe(event, tmp, &tmp_list, list) {
>  		list_del(&event->list);

Maybe convert this to list_del_init() while at it?

>  		remove_wait_queue(event->wqh, &event->wait);
>  		eventfd_signal(event->eventfd, 1);
>  		schedule_work(&event->remove);
>  	}
> -	spin_unlock(&cgrp->event_list_lock);

Thanks.

-- 
tejun
