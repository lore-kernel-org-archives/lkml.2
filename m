Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab0D1WJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 18:09:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62864 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab0D1WJR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 18:09:17 -0400
MIME-Version: 1.0
In-Reply-To: <201004282309.42188.rjw@sisk.pl>
References: <1272429119-12103-1-git-send-email-arve@android.com>
	 <1272429119-12103-7-git-send-email-arve@android.com>
	 <20100428194028.GA16389@redhat.com> <201004282309.42188.rjw@sisk.pl>
Date: Wed, 28 Apr 2010 15:09:16 -0700
Message-ID: <x2id6200be21004281509j84c29664m60068e7bfc86f64f@mail.gmail.com>
Subject: Re: [PATCH 6/8] PM: Add suspend blocking work.
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Tejun Heo <tj@kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/28 Rafael J. Wysocki <rjw@sisk.pl>:
> On Wednesday 28 April 2010, Oleg Nesterov wrote:
>> On 04/27, Arve Hjønnevåg wrote:
>> >
>> > Allow work to be queued that will block suspend while it is pending
>> > or executing. To get the same functionality in the calling code often
>> > requires a separate suspend_blocker for pending and executing work, or
>> > additional state and locking. This implementation does add additional
>> > state and locking, but this can be removed later if we add support for
>> > suspend blocking work to the core workqueue code.
>>
>> I think this patch is fine.
>>
>> Just one silly question,
>>
>> > +int queue_suspend_blocking_work(struct workqueue_struct *wq,
>> > +                           struct suspend_blocking_work *work)
>> > +{
>> > +   int ret;
>> > +   unsigned long flags;
>> > +
>> > +   spin_lock_irqsave(&work->lock, flags);
>> > +   suspend_block(&work->suspend_blocker);
>> > +   ret = queue_work(wq, &work->work);
>> > +   if (ret)
>> > +           work->active++;
>>
>> why not
>>
>>       ret = queue_work(wq, &work->work);
>>       if (ret) {
>>               suspend_block(&work->suspend_blocker);
>>               work->active++;
>>       }
>>
>> ?
>>
>> Afaics, we can't race with work->func() doing unblock, we hold work-lock.
>> And this way the code looks more clear.
>
> Agreed.  Arve, any objections to doing that?
>

I need to fix the race, but I can easily fix it in
cancel_suspend_blocking_work_sync instead. If the suspend blocker is
active for a long time, and DEBUG_SUSPEND_BLOCKER is enabled, we can
tell if the work is constantly re-queued or if the workqueue is stuck.

>> Sorry, I had no chance to read the previous patches. After the quick look
>> at 1/8 I think it is OK to call suspend_block() twice, but still...
>
> It is.
>
>> Or I missed something? Just curious.
>>
>>
>> Hmm... actually, queue_work() can also fail if we race with cancel_ which
>> temporary sets WORK_STRUCT_PENDING. In that case suspend_block() won't
>> be paired by unblock ?
>>
>>
>> > +int schedule_suspend_blocking_work(struct suspend_blocking_work *work)
>> > +{
>> > ...
>> > +   ret = schedule_work(&work->work);
>>
>> Off-topic. We should probably export keventd_wq to avoid the duplications
>> like this.
>
> Please see my reply to Tejun. :-)
>
> Rafael
>



-- 
Arve Hjønnevåg
