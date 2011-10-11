Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab1JKHGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 03:06:18 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61255 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab1JKHGO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 03:06:14 -0400
MIME-Version: 1.0
In-Reply-To: <201110102340.57242.rjw@sisk.pl>
References: <1318131626-9373-1-git-send-email-tom.leiming@gmail.com>
	<1318131626-9373-2-git-send-email-tom.leiming@gmail.com>
	<201110102340.57242.rjw@sisk.pl>
Date: Tue, 11 Oct 2011 15:06:13 +0800
Message-ID: <CACVXFVNSq2cLin4VQjFHWz+oH96Zwfq_jJ7vR2PurU+3vb6RpQ@mail.gmail.com>
Subject: Re: [RESEND PATCH 2/2] PM/runtime: handle ->runtime_suspend failure correctly
From: Ming Lei <tom.leiming@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

2011/10/11 Rafael J. Wysocki <rjw@sisk.pl>:
> On Sunday, October 09, 2011, tom.leiming@gmail.com wrote:
>> From: Ming Lei <ming.lei@canonical.com>
>>
>> If ->runtime_suspend returns -EAGAIN or -EBUSY, the device should
>> still be in ACTIVE state, so it is not needed to send idle notification
>> to its parent; if ->runtime_suspend returns other fatal failure, it
>> doesn't make sense to send idle notification to its parent.
>>
>> So skip these when failure is returned from ->runtime_suspend, also add
>> comments for this handling in rpm_suspend.
>>
>> This patch also updates comments for rpm_suspend:
>>
>> - 'Cancel a pending idle notification' should be put before, also
>> should be changed as 'Cancel a pending idle notification or
>> autosuspend/suspend'
>
> That should be a different patch I think?

OK, I will split it into two.

>
>> - idle notification for suspend failure has been removed, so update
>> comments for it
>>
>> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>> ---
>> v1: some minor change on Alan's suggestion
>> ---
>>  drivers/base/power/runtime.c |   34 +++++++++++++++++++---------------
>>  1 files changed, 19 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
>> index 441b5a3..e3c6a8f 100644
>> --- a/drivers/base/power/runtime.c
>> +++ b/drivers/base/power/runtime.c
>> @@ -284,14 +284,17 @@ static int rpm_callback(int (*cb)(struct device *), struct device *dev)
>>   * @dev: Device to suspend.
>>   * @rpmflags: Flag bits.
>>   *
>> - * Check if the device's runtime PM status allows it to be suspended.  If
>> - * another suspend has been started earlier, either return immediately or wait
>> - * for it to finish, depending on the RPM_NOWAIT and RPM_ASYNC flags.  Cancel a
>> - * pending idle notification.  If the RPM_ASYNC flag is set then queue a
>> - * suspend request; otherwise run the ->runtime_suspend() callback directly.
>> - * If a deferred resume was requested while the callback was running then carry
>> - * it out; otherwise send an idle notification for the device (if the suspend
>> - * failed) or for its parent (if the suspend succeeded).
>> + * Check if the device's runtime PM status allows it to be suspended. Cancel
>> + * a pending idle notification or autosuspend/suspend. If another suspend has
>> + * been started earlier, either return immediately or wait for it to finish,
>> + * depending on the RPM_NOWAIT and RPM_ASYNC flags. If the RPM_ASYNC flag is
>> + * set then queue a suspend request; otherwise run the ->runtime_suspend()
>> + * callback directly. If ->runtime_suspend returns failure, just cancel
>> + * pending request and wake up waited tasks, then return immediatelly.
>> + * After ->runtime_suspend succeeded, if a deferred resume was requested
>> + * while the callback was running then carry it out; otherwise send an idle
>> + * notification for its parent (if both ignore_children and irq_safe
>> + * are not set).
>>   *
>>   * This function must be called under dev->power.lock with interrupts disabled.
>>   */
>> @@ -410,15 +413,16 @@ static int rpm_suspend(struct device *dev, int rpmflags)
>>                       dev->power.runtime_error = 0;
>>               else
>>                       pm_runtime_cancel_pending(dev);
>> -     } else {
>> +             wake_up_all(&dev->power.wait_queue);
>> +             goto out;
>> +     }
>>   no_callback:
>
> I don't think the change above is correct.  The code below
> no_callback only should be executed if retval is zero.

The 'goto out' above no_callback will bypass this, won't it?

> To achieve the goal (i.e. avoid notifying the parent if -EAGAIN or
> -EBUSY is returned by the callbacks) it would be sufficient to

For all non zero value return from callbacks, the idle notification to
its parent should be avoided too.

> do parent = NULL along with resetting power.runtime_error.
>
>> -             __update_runtime_status(dev, RPM_SUSPENDED);
>> -             pm_runtime_deactivate_timer(dev);
>> +     __update_runtime_status(dev, RPM_SUSPENDED);
>> +     pm_runtime_deactivate_timer(dev);
>>
>> -             if (dev->parent) {
>> -                     parent = dev->parent;
>> -                     atomic_add_unless(&parent->power.child_count, -1, 0);
>> -             }
>> +     if (dev->parent) {
>> +             parent = dev->parent;
>> +             atomic_add_unless(&parent->power.child_count, -1, 0);
>>       }
>>       wake_up_all(&dev->power.wait_queue);
>
> Thanks,
> Rafael
>

thanks,
-- 
Ming Lei
