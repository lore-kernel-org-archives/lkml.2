Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab1GWX00 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 19:26:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:10435 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab1GWX0V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 19:26:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=KftIA4+0hy1OARfrSu3ZJFakP/5nvakyBR0u0hIO71NptutwMsmw5/vcqFegUdFRj
	xDcTvw8AHu+A+Rov3u17w==
MIME-Version: 1.0
In-Reply-To: <201107240057.00197.rjw@sisk.pl>
References: <1311396967-16721-1-git-send-email-ccross@android.com>
	<201107240057.00197.rjw@sisk.pl>
Date: Sat, 23 Jul 2011 16:26:15 -0700
X-Google-Sender-Auth: HO4DmH8XW6FdENZP3d6M9hDZxgQ
Message-ID: <CAMbhsRTdQLd5GRew9GMx6O287k3O17SKE18jvK2k7oyZpOrZfg@mail.gmail.com>
Subject: Re: [PATCH] PM: runtime: add might_sleep to PM runtime functions
From: Colin Cross <ccross@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Nishanth Menon <nm@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 23, 2011 at 3:57 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, July 23, 2011, Colin Cross wrote:
>> The list of functions that can be called in atomic context is
>> non-intuitive (pm_runtime_put_sync can not, but
>> pm_runtime_put_sync_suspend can, if pm_runtime_irq_safe has
>> been called?).
>
> However, this behavior is documented.
>
> Also, if you have a clean use case for calling rpm_idle() with interrupts
> off, it can be modified to work in analogy with rpm_suspend() in that respect.

Yes, Kevin posted that patch in response to a bug that would never
have existed with this patch.  Even with Kevin's change, this patch
still detects drivers that are missing pm_runtime_irq_safe().

>> The code is actively misleading - the entry
>> points all start with spin_lock_irqsave, suggesting they
>> are safe to call in atomic context, but may later
>> enable interrupts.
>
> May I say it is this way for a reason?

I'll reword that

>> Add might_sleep_if to all the __pm_runtime_* entry points
>> to enforce correct usage.
>
> I'm not sure how this makes things better.

I spent hours tracking down a bug that was caused by
pm_runtime_put_sync enabling interrupts when entering idle, which was
causing the timer interrupt to be serviced before the cpu entered
idle, and the cpu to idle forever until a non-timer interrupt
occurred.  The bug would never have been introduced with this patch.
When I ran with this patch, it immediately caught 3 other cases of
incorrect usage in atomic context, any of which could cause deadlocks:
spin_lock_irqsave(driver lock)
pm_runtime_put_sync
spin_lock_irqsave(dev lock)
spin_unlock_irq(dev_lock) - enables interrupts
driver irq
spin_lock(driver lock)

One of the bugs was put_sync instead of put_sync_suspend, which would
not be a problem after Kevin's patch, but the other two were missing
pm_runtime_irq_safe.

Not every developer who calls a pm_runtime function is going to read
the documentation, and this patch will catch the common incorrect
usage the first time it is run.

I'll update this patch on top of Kevin's.

>> Also add pm_runtime_put_sync_autosuspend to the list of
>> functions that can be called in atomic context.
>
> OK
>
> In addition to that rpm_idle() is missing the __releases __acquires
> annotations.

Do you want that added to this patch?  It seems like that fits better
into Kevin's patch, or a third patch.

>> Signed-off-by: Colin Cross <ccross@android.com>
>> ---
>>  Documentation/power/runtime_pm.txt |    1 +
>>  drivers/base/power/runtime.c       |   16 ++++++++++++++--
>>  2 files changed, 15 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.txt
>> index b24875b..22852b3 100644
>> --- a/Documentation/power/runtime_pm.txt
>> +++ b/Documentation/power/runtime_pm.txt
>> @@ -469,6 +469,7 @@ pm_runtime_autosuspend()
>>  pm_runtime_resume()
>>  pm_runtime_get_sync()
>>  pm_runtime_put_sync_suspend()
>> +pm_runtime_put_sync_autosuspend()
>>
>>  5. Run-time PM Initialization, Device Probing and Removal
>>
>> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
>> index 0d4587b..fdc4567 100644
>> --- a/drivers/base/power/runtime.c
>> +++ b/drivers/base/power/runtime.c
>> @@ -732,6 +732,8 @@ int __pm_runtime_idle(struct device *dev, int rpmflags)
>>       unsigned long flags;
>>       int retval;
>>
>> +     might_sleep_if(!(rpmflags & RPM_ASYNC));
>> +
>>       if (rpmflags & RPM_GET_PUT) {
>>               if (!atomic_dec_and_test(&dev->power.usage_count))
>>                       return 0;
>> @@ -754,13 +756,16 @@ EXPORT_SYMBOL_GPL(__pm_runtime_idle);
>>   * return immediately if it is larger than zero.  Then carry out a suspend,
>>   * either synchronous or asynchronous.
>>   *
>> - * This routine may be called in atomic context if the RPM_ASYNC flag is set.
>> + * This routine may be called in atomic context if the RPM_ASYNC flag is set,
>> + * or if pm_runtime_irq_safe() has been called.
>>   */
>>  int __pm_runtime_suspend(struct device *dev, int rpmflags)
>>  {
>>       unsigned long flags;
>>       int retval;
>>
>> +     might_sleep_if(!(rpmflags & RPM_ASYNC) && !dev->power.irq_safe);
>> +
>>       if (rpmflags & RPM_GET_PUT) {
>>               if (!atomic_dec_and_test(&dev->power.usage_count))
>>                       return 0;
>> @@ -782,13 +787,16 @@ EXPORT_SYMBOL_GPL(__pm_runtime_suspend);
>>   * If the RPM_GET_PUT flag is set, increment the device's usage count.  Then
>>   * carry out a resume, either synchronous or asynchronous.
>>   *
>> - * This routine may be called in atomic context if the RPM_ASYNC flag is set.
>> + * This routine may be called in atomic context if the RPM_ASYNC flag is set,
>> + * or if pm_runtime_irq_safe() has been called.
>>   */
>>  int __pm_runtime_resume(struct device *dev, int rpmflags)
>>  {
>>       unsigned long flags;
>>       int retval;
>>
>> +     might_sleep_if(!(rpmflags & RPM_ASYNC) && !dev->power.irq_safe);
>> +
>>       if (rpmflags & RPM_GET_PUT)
>>               atomic_inc(&dev->power.usage_count);
>>
>> @@ -978,6 +986,8 @@ EXPORT_SYMBOL_GPL(pm_runtime_barrier);
>>   */
>>  void __pm_runtime_disable(struct device *dev, bool check_resume)
>>  {
>> +     might_sleep();
>> +
>
> Well, it's not correct to call spin_lock_irq() from interrupt context anyway.
>
>>       spin_lock_irq(&dev->power.lock);
>>
>>       if (dev->power.disable_depth > 0) {
>> @@ -1184,6 +1194,8 @@ void __pm_runtime_use_autosuspend(struct device *dev, bool use)
>>  {
>>       int old_delay, old_use;
>>
>> +     might_sleep();
>> +
>>       spin_lock_irq(&dev->power.lock);
>>       old_delay = dev->power.autosuspend_delay;
>>       old_use = dev->power.use_autosuspend;
>>
>
> Thanks,
> Rafael
>
