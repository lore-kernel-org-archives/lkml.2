Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422832Ab2JaNVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:21:49 -0400
Received: from mx2.parallels.com ([64.131.90.16]:51018 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935543Ab2JaNVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:21:45 -0400
Message-ID: <509125D9.8070100@parallels.com>
Date: Wed, 31 Oct 2012 17:21:29 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <lizefan@huawei.com>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <bsingharora@gmail.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <cgroups@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] cgroup: kill cgroup_subsys->__DEPRECATED_clear_css_refs
References: <1351657365-25055-1-git-send-email-tj@kernel.org> <1351657365-25055-2-git-send-email-tj@kernel.org>
In-Reply-To: <1351657365-25055-2-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  	}
>  	prepare_to_wait(&cgroup_rmdir_waitq, &wait, TASK_INTERRUPTIBLE);
> -	if (!cgroup_clear_css_refs(cgrp)) {
> -		mutex_unlock(&cgroup_mutex);
> -		/*
> -		 * Because someone may call cgroup_wakeup_rmdir_waiter() before
> -		 * prepare_to_wait(), we need to check this flag.
> -		 */
> -		if (test_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags))
> -			schedule();
> -		finish_wait(&cgroup_rmdir_waitq, &wait);
> -		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
> -		if (signal_pending(current))
> -			return -EINTR;
> -		goto again;
> +
> +	local_irq_disable();
> +
> +	/* block new css_tryget() by deactivating refcnt */
> +	for_each_subsys(cgrp->root, ss) {
> +		struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
> +
> +		WARN_ON(atomic_read(&css->refcnt) < 0);
> +		atomic_add(CSS_DEACT_BIAS, &css->refcnt);
>  	}
> -	/* NO css_tryget() can success after here. */
> +
> +	/*
> +	 * Set REMOVED.  All in-progress css_tryget() will be released.
> +	 * Put all the base refs.  Each css holds an extra reference to the
> +	 * cgroup's dentry and cgroup removal proceeds regardless of css
> +	 * refs.  On the last put of each css, whenever that may be, the
> +	 * extra dentry ref is put so that dentry destruction happens only
> +	 * after all css's are released.
> +	 */
> +	for_each_subsys(cgrp->root, ss) {
> +		struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
> +
> +		set_bit(CSS_REMOVED, &css->flags);
> +		css_put(css);
> +	}
> +
> +	local_irq_enable();
> +
>  	finish_wait(&cgroup_rmdir_waitq, &wait);

It seems to me that the main reason for doing this in two passes was to
derive a global "failed" state on the first pass. Now that we can't
fail, why can't you just loop through the subsystems just once ?

