Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab1KPRWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 12:22:24 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:37152 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab1KPRWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 12:22:22 -0500
Message-ID: <4EC3F146.7050801@linux.vnet.ibm.com>
Date: Wed, 16 Nov 2011 22:52:14 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: rjw@sisk.pl, pavel@ucw.cz, lenb@kernel.org, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2] PM/Memory-hotplug: Avoid task freezing failures
References: <20111116115515.25945.35368.stgit@srivatsabhat.in.ibm.com> <20111116162601.GB18919@google.com>
In-Reply-To: <20111116162601.GB18919@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11111617-3864-0000-0000-0000001BB461
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 09:56 PM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Nov 16, 2011 at 05:25:23PM +0530, Srivatsa S. Bhat wrote:
>> v2: Tejun pointed problems with using mutex_lock_interruptible() in a
>>     while loop, when signals not related to freezing are involved.
>>     So, replaced it with mutex_trylock().
>>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---
>>
>>  include/linux/suspend.h |   14 +++++++++++++-
>>  1 files changed, 13 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/suspend.h b/include/linux/suspend.h
>> index 57a6924..c2b5aab 100644
>> --- a/include/linux/suspend.h
>> +++ b/include/linux/suspend.h
>> @@ -5,6 +5,7 @@
>>  #include <linux/notifier.h>
>>  #include <linux/init.h>
>>  #include <linux/pm.h>
>> +#include <linux/freezer.h>
>>  #include <linux/mm.h>
>>  #include <asm/errno.h>
>>  
>> @@ -380,7 +381,18 @@ static inline void unlock_system_sleep(void) {}
>>  
>>  static inline void lock_system_sleep(void)
>>  {
>> -	mutex_lock(&pm_mutex);
>> +	/*
>> +	 * We should not use mutex_lock() here because, in case we fail to
>> +	 * acquire the lock, it would put us to sleep in TASK_UNINTERRUPTIBLE
>> +	 * state, which would lead to task freezing failures. As a
>> +	 * consequence, hibernation would fail (even though it had acquired
>> +	 * the 'pm_mutex' lock).
>> +	 *
>> +	 * We should use try_to_freeze() in the while loop so that we don't
>> +	 * cause freezing failures due to busy looping.
>> +	 */
>> +	while (!mutex_trylock(&pm_mutex))
>> +		try_to_freeze();
> 
> I'm kinda lost.  We now always busy-loop if the lock is held by
> someone else.  I can't see how that is an improvement.  If this isn't
> an immediate issue, wouldn't it be better to wait for proper solution?
> 

lock_system_sleep() is used by memory hotplug to mutually exclude itself
from hibernation. Which means if memory hotplug didn't get the lock, then
the "someone else" is going to be the hibernation code path. 
And in that case, how can this busy-loop for long? The try_to_freeze() in
the loop will co-operate with the freezing of tasks (which is carried out
during hibernation) and this task will get frozen pretty soon.
And thus, this prevents task freezing failures. However, if we had slept
uninterruptibly like the original code does, then it is a sure-shot
candidate for freezing failure.
In fact I tried using this API as a test, in another scenario and as very
much expected, I encountered freezing failures with the original code.
And with this patch applied, those failures vanished, again as expected.

So, honestly I didn't understand what is wrong with the approach of this
patch. And as a consequence, I don't see why we should wait to fix this
issue. 

[And by the way recently I happened to see yet another proposed patch
trying to make use of this API. So wouldn't it be better to fix this
ASAP, especially when we have a fix readily available?]

Thanks,
Srivatsa S. Bhat

