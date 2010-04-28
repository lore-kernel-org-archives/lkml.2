Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab0D1HCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 03:02:39 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53002 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab0D1HCh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 03:02:37 -0400
MIME-Version: 1.0
In-Reply-To: <4BD7D948.4080406@kernel.org>
References: <1272429119-12103-1-git-send-email-arve@android.com>
	 <1272429119-12103-2-git-send-email-arve@android.com>
	 <1272429119-12103-3-git-send-email-arve@android.com>
	 <1272429119-12103-4-git-send-email-arve@android.com>
	 <1272429119-12103-5-git-send-email-arve@android.com>
	 <1272429119-12103-6-git-send-email-arve@android.com>
	 <1272429119-12103-7-git-send-email-arve@android.com>
	 <4BD7D948.4080406@kernel.org>
Date: Wed, 28 Apr 2010 00:02:36 -0700
Message-ID: <i2vd6200be21004280002tde778c02h1586b4c06de2a89a@mail.gmail.com>
Subject: Re: [PATCH 6/8] PM: Add suspend blocking work.
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>, Oleg Nesterov <oleg@redhat.com>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/27 Tejun Heo <tj@kernel.org>:
> Hello,
>
>> +static void suspend_blocking_work_complete(struct suspend_blocking_work *work)
>> +{
>> +     unsigned long flags;
>> +
>> +     WARN_ON(!work->active);
>> +     spin_lock_irqsave(&work->lock, flags);
>> +     if (!--work->active)
>> +             suspend_unblock(&work->suspend_blocker);
>> +     spin_unlock_irqrestore(&work->lock, flags);
>> +}
>
> Maybe work->active can be an atomic_t and the lock can be removed?
>

I need the spinlock to prevent the work from getting re-queued before
suspend_unblock.

>> +/**
>> + * suspend_blocking_work_destroy - Destroy suspend_blocking_work
>> + * @work: The work item in question
>> + *
>> + * If the work was ever queued on more then one workqueue all but the last
>> + * workqueue must be flushed before calling suspend_blocking_work_destroy.
>
> As it's calling cancel_work_sync(), the above is not true.  As long as
> no one is trying to queue it again, suspend_blocking_work_destroy() is
> safe to call regardless of how the work has been used.
>

I'm not sure what the best terminology is here, but cancel_work_sync()
only waits for work running on all the cpu-workqueues of the last
workqueue. So, if the caller queued the work on more than one
workqueue, suspend_blocking_work_destroy does not ensure that the
suspend_blocking_work structure is not still in use (it should trigger
the WARN_ON though).

>> +void suspend_blocking_work_destroy(struct suspend_blocking_work *work)
>> +{
>> +     cancel_suspend_blocking_work_sync(work);
>> +     WARN_ON(work->active);
>> +     suspend_blocker_destroy(&work->suspend_blocker);
>> +}
>> +EXPORT_SYMBOL(suspend_blocking_work_destroy);
>
> Other than the above, it looks good to me.
>
> Thanks.
>
> --
> tejun
>



-- 
Arve Hjønnevåg
