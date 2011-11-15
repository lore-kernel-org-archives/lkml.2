Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab1KOHSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 02:18:16 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:40748 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab1KOHSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 02:18:15 -0500
Message-ID: <4EC21006.7030101@linux.vnet.ibm.com>
Date: Tue, 15 Nov 2011 12:38:54 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: rjw@sisk.pl, pavel@ucw.cz, lenb@kernel.org, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] PM/Memory-hotplug: Avoid task freezing failures
References: <20111110163825.4321.56320.stgit@srivatsabhat.in.ibm.com> <20111114200506.GE30922@google.com>
In-Reply-To: <20111114200506.GE30922@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11111507-2674-0000-0000-000001359469
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2011 01:35 AM, Tejun Heo wrote:
> Hello,
> 
> On Thu, Nov 10, 2011 at 10:12:43PM +0530, Srivatsa S. Bhat wrote:
>> The lock_system_sleep() function is used in the memory hotplug code at
>> several places in order to implement mutual exclusion with hibernation.
>> However, this function tries to acquire the 'pm_mutex' lock using
>> mutex_lock() and hence blocks in TASK_UNINTERRUPTIBLE state if it doesn't
>> get the lock. This would lead to task freezing failures and hence
>> hibernation failure as a consequence, even though the hibernation call path
>> successfully acquired the lock.
>>
>> This patch fixes this issue by modifying lock_system_sleep() to use
>> mutex_lock_interruptible() instead of mutex_lock(), so that it blocks in the
>> TASK_INTERRUPTIBLE state. This would allow the freezer to freeze the blocked
>> task. Also, since the freezer could use signals to freeze tasks, it is quite
>> likely that mutex_lock_interruptible() returns -EINTR (and fails to acquire
>> the lock). Hence we keep retrying in a loop until we acquire the lock. Also,
>> we call try_to_freeze() within the loop, so that we don't cause freezing
>> failures due to busy looping.
>>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ...
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
>> +	 * Note that mutex_lock_interruptible() returns -EINTR if we happen
>> +	 * to get a signal when we are waiting to acquire the lock (and this
>> +	 * is very likely here because the freezer could use signals to freeze
>> +	 * tasks). Hence we have to keep retrying until we get the lock. But
>> +	 * we have to use try_to_freeze() in the loop, so that we don't cause
>> +	 * freezing failures due to busy looping.
>> +	 */
>> +	while (mutex_lock_interruptible(&pm_mutex))
>> +		try_to_freeze();
> 
> Hmmm... is this a problem that we need to worry about?  If not, I'm
> not sure this is a good idea.  What if the task calling
> lock_system_sleep() is a userland one and has actual outstanding
> signal?  It would busy spin until it acquire pm_mutex.  Maybe that's
> okay too given how pm_mutex is used but it's still nasty.  If this
> isn't a real problem, maybe leave this alone for now?
> 

Hi Tejun,

Thank you very much for taking a look. I haven't encountered this problem,
but while going through the code, I felt this would be problematic for
hibernation.
The other reason I was looking into this was, to make use of this API in
another scenario (specifically, the x86 microcode update module
initialization, where I couldn't think of any other solution to block
suspend) by making this API (lock_system_sleep) a bit more generic so that
it works for suspend also. So I thought of fixing it up before doing that.

Considering the point you have raised, how about something like this?

while (!mutex_trylock(&pm_mutex))
	try_to_freeze();

This should address your concern right?
At first sight, I felt this looked quite hacky.. but after trying to
understand the meaning it conveys, it struck me that this version of the
code seems to itself convey what exactly we are trying to achieve/avoid
here :-)

By the way, to tell the truth, I don't really like this way of blocking
suspend/hibernation by grabbing the 'pm_mutex' lock directly.
Probably the design that Rafael and Alan Stern are working out would be a
cleaner solution in the long run, for subsystems to block system sleep.

Thanks,
Srivatsa S. Bhat

