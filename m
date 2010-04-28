Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0D1Tnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 15:43:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab0D1Tnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 15:43:42 -0400
Date: Wed, 28 Apr 2010 21:40:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 6/8] PM: Add suspend blocking work.
Message-ID: <20100428194028.GA16389@redhat.com>
References: <1272429119-12103-1-git-send-email-arve@android.com> <1272429119-12103-2-git-send-email-arve@android.com> <1272429119-12103-3-git-send-email-arve@android.com> <1272429119-12103-4-git-send-email-arve@android.com> <1272429119-12103-5-git-send-email-arve@android.com> <1272429119-12103-6-git-send-email-arve@android.com> <1272429119-12103-7-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1272429119-12103-7-git-send-email-arve@android.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27, Arve Hjønnevåg wrote:
>
> Allow work to be queued that will block suspend while it is pending
> or executing. To get the same functionality in the calling code often
> requires a separate suspend_blocker for pending and executing work, or
> additional state and locking. This implementation does add additional
> state and locking, but this can be removed later if we add support for
> suspend blocking work to the core workqueue code.

I think this patch is fine.

Just one silly question,

> +int queue_suspend_blocking_work(struct workqueue_struct *wq,
> +				struct suspend_blocking_work *work)
> +{
> +	int ret;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&work->lock, flags);
> +	suspend_block(&work->suspend_blocker);
> +	ret = queue_work(wq, &work->work);
> +	if (ret)
> +		work->active++;

why not

	ret = queue_work(wq, &work->work);
	if (ret) {
		suspend_block(&work->suspend_blocker);
		work->active++;
	}

?

Afaics, we can't race with work->func() doing unblock, we hold work-lock.
And this way the code looks more clear.

Sorry, I had no chance to read the previous patches. After the quick look
at 1/8 I think it is OK to call suspend_block() twice, but still...

Or I missed something? Just curious.


Hmm... actually, queue_work() can also fail if we race with cancel_ which
temporary sets WORK_STRUCT_PENDING. In that case suspend_block() won't
be paired by unblock ?


> +int schedule_suspend_blocking_work(struct suspend_blocking_work *work)
> +{
> ...
> +	ret = schedule_work(&work->work);

Off-topic. We should probably export keventd_wq to avoid the duplications
like this.

Oleg.

