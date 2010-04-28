Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab0D1Gpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 02:45:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:34972 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab0D1Gp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 02:45:28 -0400
Message-ID: <4BD7D948.4080406@kernel.org>
Date: Wed, 28 Apr 2010 08:44:24 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
CC: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>, Oleg Nesterov <oleg@redhat.com>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 6/8] PM: Add suspend blocking work.
References: <1272429119-12103-1-git-send-email-arve@android.com> <1272429119-12103-2-git-send-email-arve@android.com> <1272429119-12103-3-git-send-email-arve@android.com> <1272429119-12103-4-git-send-email-arve@android.com> <1272429119-12103-5-git-send-email-arve@android.com> <1272429119-12103-6-git-send-email-arve@android.com> <1272429119-12103-7-git-send-email-arve@android.com>
In-Reply-To: <1272429119-12103-7-git-send-email-arve@android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 28 Apr 2010 06:44:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> +static void suspend_blocking_work_complete(struct suspend_blocking_work *work)
> +{
> +	unsigned long flags;
> +
> +	WARN_ON(!work->active);
> +	spin_lock_irqsave(&work->lock, flags);
> +	if (!--work->active)
> +		suspend_unblock(&work->suspend_blocker);
> +	spin_unlock_irqrestore(&work->lock, flags);
> +}

Maybe work->active can be an atomic_t and the lock can be removed?

> +/**
> + * suspend_blocking_work_destroy - Destroy suspend_blocking_work
> + * @work: The work item in question
> + *
> + * If the work was ever queued on more then one workqueue all but the last
> + * workqueue must be flushed before calling suspend_blocking_work_destroy.

As it's calling cancel_work_sync(), the above is not true.  As long as
no one is trying to queue it again, suspend_blocking_work_destroy() is
safe to call regardless of how the work has been used.

> +void suspend_blocking_work_destroy(struct suspend_blocking_work *work)
> +{
> +	cancel_suspend_blocking_work_sync(work);
> +	WARN_ON(work->active);
> +	suspend_blocker_destroy(&work->suspend_blocker);
> +}
> +EXPORT_SYMBOL(suspend_blocking_work_destroy);

Other than the above, it looks good to me.

Thanks.

-- 
tejun
