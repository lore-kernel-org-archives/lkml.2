Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab1GZWzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 18:55:46 -0400
Received: from smtp-out.google.com ([216.239.44.51]:16009 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab1GZWzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 18:55:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=oiuef6eGZlcCV3lO/yVQ9wJkgRn6Mj9Ye4MkhSHZRl0zoJzG+mpei3X3fUCvPzn3y
	ZuYGo63ByatCP0Y9TEiDA==
MIME-Version: 1.0
In-Reply-To: <201107270014.36910.rjw@sisk.pl>
References: <1311627344-8097-1-git-send-email-ccross@android.com>
	<201107270014.36910.rjw@sisk.pl>
Date: Tue, 26 Jul 2011 15:55:37 -0700
X-Google-Sender-Auth: tEhIJneu7cRRSkjOVMk0XTV_bQE
Message-ID: <CAMbhsRTrnPxXUt8Q-VDz5GG8=607QSpcoXJsPLQtPaAZfHKjRA@mail.gmail.com>
Subject: Re: [PATCH v2] PM: runtime: add might_sleep to PM runtime functions
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

On Tue, Jul 26, 2011 at 3:14 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, July 25, 2011, Colin Cross wrote:
>> Some of the entry points to pm runtime are not safe to
>> call in atomic context unless pm_runtime_irq_safe() has
>> been called.  Inspecting the code, it is not immediately
>> obvious that the functions sleep at all, as they run
>> inside a spin_lock_irqsave, but under some conditions
>> they can drop the lock and turn on irqs.
>>
>> If a driver incorrectly calls the pm_runtime apis, it can
>> cause sleeping and irq processing when it expects to stay
>> in atomic context.
>>
>> Add might_sleep_if to all the __pm_runtime_* entry points
>> to enforce correct usage.
>>
>> Add pm_runtime_put_sync_autosuspend to the list of
>> functions that can be called in atomic context.
>>
>> Signed-off-by: Colin Cross <ccross@android.com>
>> ---
>>  Documentation/power/runtime_pm.txt |    1 +
>>  drivers/base/power/runtime.c       |   15 ++++++++++++---
>>  2 files changed, 13 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.txt
>> index c291233..1ad507c 100644
>> --- a/Documentation/power/runtime_pm.txt
>> +++ b/Documentation/power/runtime_pm.txt
>> @@ -469,6 +469,7 @@ pm_runtime_resume()
>>  pm_runtime_get_sync()
>>  pm_runtime_put_sync()
>>  pm_runtime_put_sync_suspend()
>> +pm_runtime_put_sync_autosuspend()
>>
>>  5. Run-time PM Initialization, Device Probing and Removal
>>
>> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
>> index 2e746f8..f3d8583 100644
>> --- a/drivers/base/power/runtime.c
>> +++ b/drivers/base/power/runtime.c
>> @@ -731,13 +731,16 @@ EXPORT_SYMBOL_GPL(pm_schedule_suspend);
>>   * return immediately if it is larger than zero.  Then carry out an idle
>>   * notification, either synchronous or asynchronous.
>>   *
>> - * This routine may be called in atomic context if the RPM_ASYNC flag is set.
>> + * This routine may be called in atomic context if the RPM_ASYNC flag is set,
>> + * or if pm_runtime_irq_safe() has been called.
>>   */
>>  int __pm_runtime_idle(struct device *dev, int rpmflags)
>>  {
>>       unsigned long flags;
>>       int retval;
>>
>> +     might_sleep_if(!(rpmflags & RPM_ASYNC) && !dev->power.irq_safe);
>> +
>
> Now that I think of it, perhaps it's better to put the might_sleep()
> annotations into the actual code paths that should trigger them instead of
> checking the conditions upfront on every call?  This way we'll avoid quite
> some overhead that's only necessary for debugging.
>

You can't put the might_sleep after the spin_lock_irqsave(), because
you are always in atomic context, and you can't put it after the
spin_unlock_irq() that triggers the problem because you have already
unconditionally left atomic context.

Anyways, the sleeps happen in a farily rare case, so putting the
might_sleep in a more specific location will hide the errors when
developers perform simple tests.  For example, every kmalloc ends up
calling might_sleep_if(flags & __GFP_WAIT), so that putting
kmalloc(..., GFP_KERNEL) will print a stack trace every time, instead
of only the very rare case when kmalloc has to block in a low memory
condition.

The calls are very low overhead - the condition in the
might_sleep_if(), and then in the common case:
	if ((preempt_count_equals(preempt_offset) && !irqs_disabled()) || ...)
		return;
