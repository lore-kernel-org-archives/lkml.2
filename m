Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab0D2DrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 23:47:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48751 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993Ab0D2DrP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 23:47:15 -0400
MIME-Version: 1.0
In-Reply-To: <201004290019.26381.rjw@sisk.pl>
References: <1272429119-12103-1-git-send-email-arve@android.com>
	 <201004282309.42188.rjw@sisk.pl>
	 <x2id6200be21004281509j84c29664m60068e7bfc86f64f@mail.gmail.com>
	 <201004290019.26381.rjw@sisk.pl>
Date: Wed, 28 Apr 2010 20:47:14 -0700
Message-ID: <s2rd6200be21004282047qc1b88ac5h1759f22f3c16ce85@mail.gmail.com>
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
> On Thursday 29 April 2010, Arve Hjønnevåg wrote:
>> 2010/4/28 Rafael J. Wysocki <rjw@sisk.pl>:
>> > On Wednesday 28 April 2010, Oleg Nesterov wrote:
>> >> On 04/27, Arve Hjønnevåg wrote:
>> >> >
>> >> > Allow work to be queued that will block suspend while it is pending
>> >> > or executing. To get the same functionality in the calling code often
>> >> > requires a separate suspend_blocker for pending and executing work, or
>> >> > additional state and locking. This implementation does add additional
>> >> > state and locking, but this can be removed later if we add support for
>> >> > suspend blocking work to the core workqueue code.
>> >>
>> >> I think this patch is fine.
>> >>
>> >> Just one silly question,
>> >>
>> >> > +int queue_suspend_blocking_work(struct workqueue_struct *wq,
>> >> > +                           struct suspend_blocking_work *work)
>> >> > +{
>> >> > +   int ret;
>> >> > +   unsigned long flags;
>> >> > +
>> >> > +   spin_lock_irqsave(&work->lock, flags);
>> >> > +   suspend_block(&work->suspend_blocker);
>> >> > +   ret = queue_work(wq, &work->work);
>> >> > +   if (ret)
>> >> > +           work->active++;
>> >>
>> >> why not
>> >>
>> >>       ret = queue_work(wq, &work->work);
>> >>       if (ret) {
>> >>               suspend_block(&work->suspend_blocker);
>> >>               work->active++;
>> >>       }
>> >>
>> >> ?
>> >>
>> >> Afaics, we can't race with work->func() doing unblock, we hold work-lock.
>> >> And this way the code looks more clear.
>> >
>> > Agreed.  Arve, any objections to doing that?
>> >
>>
>> I need to fix the race, but I can easily fix it in
>> cancel_suspend_blocking_work_sync instead. If the suspend blocker is
>> active for a long time, and DEBUG_SUSPEND_BLOCKER is enabled, we can
>> tell if the work is constantly re-queued or if the workqueue is stuck.
>
> Well, perhaps that's worth adding a comment to the code.  The debug part is not
> immediately visible from the code itself.

On second thought, this only makes a difference if both conditions are
true. If we are constantly re-queuing the work but it is not stuck,
either method will show the debug message, so I used Oleg's
suggestion.

-- 
Arve Hjønnevåg
