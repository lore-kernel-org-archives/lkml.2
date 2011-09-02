Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab1IBMdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 08:33:23 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33341 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab1IBMdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 08:33:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAFPAmTTQeHAd9o9y_SfRbQefovo6ukASHodopMtFLCZ4zL07RQ@mail.gmail.com>
References: <1314963064-22109-1-git-send-email-jack@suse.cz>
	<CAFPAmTTQeHAd9o9y_SfRbQefovo6ukASHodopMtFLCZ4zL07RQ@mail.gmail.com>
Date: Fri, 2 Sep 2011 18:03:19 +0530
Message-ID: <CAFPAmTRFMHbZO86sUM+xA=HMCSixjzNt13-bz-KXv-ChRWXpCA@mail.gmail.com>
Subject: Re: [PATCH v2] mm: Make logic in bdi_forker_thread() straight
From: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <jaxboe@fusionio.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I was wrong in this email. Please ignore.

This problem will still happen as the CPU executing the
wakeup_timer_fn can still
get the lock and do a wake_up_process which can set the task state to
TASK_RUNNING.

On Fri, Sep 2, 2011 at 5:41 PM, kautuk.c @samsung.com
<consul.kautuk@gmail.com> wrote:
> Sorry to butt in before Jens' review but i have one small comment:
>
> On Fri, Sep 2, 2011 at 5:01 PM, Jan Kara <jack@suse.cz> wrote:
>> The logic in bdi_forker_thread() is unnecessarily convoluted by setting task
>> state there and back or calling schedule_timeout() in TASK_RUNNING state. Also
>> clearing of BDI_pending bit is placed at the and of global loop and cases of a
>> switch which mustn't reach it must call 'continue' instead of 'break' which is
>> non-intuitive and thus asking for trouble. So make the logic more obvious.
>>
>> CC: Andrew Morton <akpm@linux-foundation.org>
>> CC: Wu Fengguang <fengguang.wu@intel.com>
>> CC: consul.kautuk@gmail.com
>> Signed-off-by: Jan Kara <jack@suse.cz>
>> ---
>>  mm/backing-dev.c |   37 ++++++++++++++++++++-----------------
>>  1 files changed, 20 insertions(+), 17 deletions(-)
>>
>>  This should be the right cleanup. Jens?
>>
>> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
>> index d6edf8d..bdf7d6b 100644
>> --- a/mm/backing-dev.c
>> +++ b/mm/backing-dev.c
>> @@ -359,6 +359,17 @@ static unsigned long bdi_longest_inactive(void)
>>        return max(5UL * 60 * HZ, interval);
>>  }
>>
>> +/*
>> + * Clear pending bit and wakeup anybody waiting for flusher thread startup
>> + * or teardown.
>> + */
>> +static void bdi_clear_pending(struct backing_dev_info *bdi)
>> +{
>> +       clear_bit(BDI_pending, &bdi->state);
>> +       smp_mb__after_clear_bit();
>> +       wake_up_bit(&bdi->state, BDI_pending);
>> +}
>> +
>>  static int bdi_forker_thread(void *ptr)
>>  {
>>        struct bdi_writeback *me = ptr;
>> @@ -390,8 +401,6 @@ static int bdi_forker_thread(void *ptr)
>>                }
>>
>>                spin_lock_bh(&bdi_lock);
>> -               set_current_state(TASK_INTERRUPTIBLE);
>> -
>>                list_for_each_entry(bdi, &bdi_list, bdi_list) {
>>                        bool have_dirty_io;
>>
>> @@ -441,13 +450,8 @@ static int bdi_forker_thread(void *ptr)
>>                }
>>                spin_unlock_bh(&bdi_lock);
>>
>> -               /* Keep working if default bdi still has things to do */
>> -               if (!list_empty(&me->bdi->work_list))
>> -                       __set_current_state(TASK_RUNNING);
>> -
>>                switch (action) {
>>                case FORK_THREAD:
>> -                       __set_current_state(TASK_RUNNING);
>>                        task = kthread_create(bdi_writeback_thread, &bdi->wb,
>>                                              "flush-%s", dev_name(bdi->dev));
>>                        if (IS_ERR(task)) {
>> @@ -469,14 +473,21 @@ static int bdi_forker_thread(void *ptr)
>>                                spin_unlock_bh(&bdi->wb_lock);
>>                                wake_up_process(task);
>>                        }
>> +                       bdi_clear_pending(bdi);
>>                        break;
>>
>>                case KILL_THREAD:
>> -                       __set_current_state(TASK_RUNNING);
>>                        kthread_stop(task);
>> +                       bdi_clear_pending(bdi);
>>                        break;
>>
>>                case NO_ACTION:
>> +                       /* Keep working if default bdi still has things to do */
>
> Can we acquire and release the spinlocks as below:
>                            spin_lock_bh(&me->bdi->wb_lock) ;
>
>> +                       if (!list_empty(&me->bdi->work_list)) {
>
>                            spin_unlock_bh(&me->bdi->wb_lock) ;
>
>> +                               try_to_freeze();
>> +                               break;
>> +                       }
>> +                       set_current_state(TASK_INTERRUPTIBLE);
>
>                            spin_unlock_bh(&me->bdi->wb_lock) ;
>
>>                        if (!wb_has_dirty_io(me) || !dirty_writeback_interval)
>>                                /*
>>                                 * There are no dirty data. The only thing we
>> @@ -489,16 +500,8 @@ static int bdi_forker_thread(void *ptr)
>>                        else
>>                                schedule_timeout(msecs_to_jiffies(dirty_writeback_interval * 10));
>>                        try_to_freeze();
>> -                       /* Back to the main loop */
>> -                       continue;
>> +                       break;
>>                }
>> -
>> -               /*
>> -                * Clear pending bit and wakeup anybody waiting to tear us down.
>> -                */
>> -               clear_bit(BDI_pending, &bdi->state);
>> -               smp_mb__after_clear_bit();
>> -               wake_up_bit(&bdi->state, BDI_pending);
>>        }
>>
>>        return 0;
>> --
>> 1.7.1
>>
>>
>
> That should take care of the problem I initially mentioned due to the
> wakeup_timer_fn executing
> in parallel on another CPU as the task state will now be protected by
> the wb_lock spinlock.
>
