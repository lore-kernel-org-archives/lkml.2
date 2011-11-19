Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab1KSTfh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 14:35:37 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:54693 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab1KSTff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 14:35:35 -0500
Message-ID: <4EC804FC.9000109@linux.vnet.ibm.com>
Date: Sun, 20 Nov 2011 01:05:24 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: rjw@sisk.pl, pavel@ucw.cz, lenb@kernel.org, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v3] PM/Memory-hotplug: Avoid task freezing failures
References: <20111117083042.11419.19871.stgit@srivatsabhat.in.ibm.com> <20111119183240.GA17252@google.com>
In-Reply-To: <20111119183240.GA17252@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11111909-6102-0000-0000-000000337093
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 11/20/2011 12:02 AM, Tejun Heo wrote:
> Hello, Srivatsa.
> 
> On Thu, Nov 17, 2011 at 02:00:50PM +0530, Srivatsa S. Bhat wrote:
>> @@ -380,7 +382,40 @@ static inline void unlock_system_sleep(void) {}
>>  
>>  static inline void lock_system_sleep(void)
>>  {
>> -	mutex_lock(&pm_mutex);
>> +	/*
>> +	 * "To sleep, or not to sleep, that is the question!"
>> +	 *
>> +	 * We should not use mutex_lock() here because, in case we fail to
>> +	 * acquire the lock, it would put us to sleep in TASK_UNINTERRUPTIBLE
>> +	 * state, which would lead to task freezing failures. As a
>> +	 * consequence, hibernation would fail (even though it had acquired
>> +	 * the 'pm_mutex' lock).
>> +	 * Using mutex_lock_interruptible() in a loop is not a good idea,
>> +	 * because we could end up treating non-freezing signals badly.
>> +	 * So we use mutex_trylock() in a loop instead.
>> +	 *
>> +	 * Also, we add try_to_freeze() to the loop, to co-operate with the
>> +	 * freezer, to avoid task freezing failures due to busy-looping.
>> +	 *
>> +	 * But then, since it is not guaranteed that we will get frozen
>> +	 * rightaway, we could keep spinning for some time, breaking the
>> +	 * expectation that we go to sleep when we fail to acquire the lock.
>> +	 * So we add an msleep() to the loop, to dampen the spin (but we are
>> +	 * careful enough not to sleep for too long at a stretch, lest the
>> +	 * freezer whine and give up again!).
>> +	 *
>> +	 * Now that we no longer busy-loop, try_to_freeze() becomes all the
>> +	 * more important, due to a subtle reason: if we don't cooperate with
>> +	 * the freezer at this point, we could end up in a situation very
>> +	 * similar to mutex_lock() due to the usage of msleep() (which sleeps
>> +	 * uninterruptibly).
>> +	 *
>> +	 * Phew! What a delicate balance!
>> +	 */
>> +	while (!mutex_trylock(&pm_mutex)) {
>> +		try_to_freeze();
>> +		msleep(10);
>> +	}
> 
> I tried to think about a better way to do it but couldn't, so I
> suppose this is what we should go with for now.  That said, I think
> the comment is a bit too umm.... verbose.  

Hehe, I grabbed the opportunity to add some custom-modified Shakespearean
quotes and stuff to make the long story interesting ;-)

> What we want here is
> freezable but !interruptible mutex_lock() and while I do appreciate
> the detailed comment, I think it makes it look a lot more complex than
> it actually is.  

Yes, the overall requirement we have here could be explained in those simple
words, as you said, but that is only because we already know the background
and the problems involved (due to the discussions on this thread and our
knowledge of how the freezer works).

But for someone reading it from purely a memory-hotplug point of view, IMHO,
all the constraints we are handling here might not be that intuitive..
So I felt I needed to document the workaround very well (including the
thought process used to develop it), so that nobody messes with it without
knowing what each line of that workaround does, and why it does it, since
it is already quite delicate and hacky.

So, I would rather prefer retaining that comment verbosity until we have
a real, better fix...

At the same time, I wouldn't want to make it feel so scary that nobody
even dares to contribute a real fix! ;-) So, considering all this, could
you let me know if you feel it is better to cut it short and make it look
simpler or just retain it as it is?

> Other than that,
> 
>  Acked-by: Tejun Heo <tj@kernel.org>
> 

Thanks a lot for your review and Ack!

Thanks,
Srivatsa S. Bhat

