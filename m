Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab2BYTUz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 14:20:55 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:44052 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757556Ab2BYTUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 14:20:53 -0500
Message-ID: <4F493486.9020202@linux.vnet.ibm.com>
Date: Sun, 26 Feb 2012 00:50:38 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: John Stultz <john.stultz@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RFC][PATCH 0/7] PM: Implement autosleep and "wake locks", take2
References: <201202070200.55505.rjw@sisk.pl> <201202232232.59114.rjw@sisk.pl> <4F4715A7.2030401@linux.vnet.ibm.com> <201202250021.36738.rjw@sisk.pl>
In-Reply-To: <201202250021.36738.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12022519-4790-0000-0000-0000017E0F80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2012 04:51 AM, Rafael J. Wysocki wrote:

> On Friday, February 24, 2012, Srivatsa S. Bhat wrote:
>> On 02/24/2012 03:02 AM, Rafael J. Wysocki wrote:
>>
>>> On Thursday, February 23, 2012, Rafael J. Wysocki wrote:
>>>> On Thursday, February 23, 2012, Srivatsa S. Bhat wrote:
>>>>> On 02/23/2012 03:40 AM, Rafael J. Wysocki wrote:
> [...]
>>>>>
>>>>> By the way, I am just curious.. how difficult will this make it for userspace
>>>>> to disable autosleep? I mean, would a trylock mean that the user has to keep
>>>>> fighting until he finally gets a chance to disable autosleep?
>>>>
>>>> That's a good point, so I think it may be a good idea to do
>>>> mutex_lock_interruptible() in pm_autosleep_set_state() instead.
>>>
>>> Now that I think of it, perhaps it's a good idea to just make
>>> pm_autosleep_lock() do mutex_lock_interruptible() _and_ make
>>> pm_autosleep_set_state() use pm_autosleep_lock().
>>>
>>> What do you think?
>>>
>>
>>
>> Well, I don't think mutex_lock_interruptible() would help us much..
>> Consider what would happen, if we use it:
>>
>> * pm-suspend got initiated as part of autosleep. Acquired autosleep lock.
>> * Userspace is about to get frozen.
>> * Now, the user tries to write "off" to autosleep. And hence, he is waiting
>>   for autosleep lock, interruptibly.
>> * The freezer sent a fake signal to all userspace processes and hence
>>   this process also got interrupted.. it is no longer waiting on autosleep
>>   lock - it got the signal and returned, and got frozen.
>>   (And when the userspace gets thawed later, this process won't have the
>>    autosleep lock - which is a different (but yet another) problem).
>>
>> So ultimately the only thing we achieved is to ensure that freezing of
>> userspace goes smoothly. But the user process could not succeed in
>> disabling autosleep. Of course we can work around that by having the
>> mutex_lock_interruptible() in a loop and so on, but that gets very
>> ugly pretty soon.
>>
>> So, I would suggest the following solution:
>>
>> We want to achieve 2 things here:
>>  a. A user process trying to write to /sys/power/state or
>>     /sys/power/autosleep should not cause freezing failures.
>>  b. When a user process writes "off" to autosleep, the suspend/hibernate
>>     attempt that is on-going, if any, must be immediately aborted, to give
>>     the user the feeling that his preference has been noticed and respected.
>>
>> And to achieve this, we note that a user process can write "off" to autosleep
>> only until the userspace gets frozen. No chance after that.
>>
>> So, let's do this:
>> 1. Drop the autosleep lock before entering pm-suspend/hibernate.
>> 2. This means, a user process can get hold of this lock and successfully
>>    disable autosleep a moment after we initiated suspend, but before userspace
>>    got frozen fully.
>> 3. So, to respect the user's wish, we add a check immediately after the
>>    freezing of userspace is complete - we check if the user disabled autosleep
>>    and bail out, if he did. Otherwise, we continue and suspend the machine.
>>
>> IOW, this is like hitting 2 birds with one stone ;-)
>> We don't hold autosleep lock throughout suspend/hibernate, but still react
>> instantly when the user disables autosleep. And of course, freezing of tasks
>> won't fail, ever! :-)
> 
> Well, you essentially are postulating to restore the "interface" wakeup source
> that was present in the previous version of this patch and that I dropped in
> order to simplify the code.
> 


Oh is it? I guess I haven't followed this thread very closely...

> I guess I can do that ...
> 


Oh by the way, this scheme doesn't solve all problems. It might be effective
in reacting "instantly" to a request by the user to *switch off* autosleep.
But say, when the user wants to switch to suspend instead of hibernate as the
autosleep preference, for example, I don't think it would be as quick in
responding... (I mean, it might do the old operation one more time before
switching to the new one..)

But I guess at this point it might be wiser to say "sigh.. we can do only so
much..." instead of complicating the code too much in an attempt to meet
everybody's expectations :-)

Regards,
Srivatsa S. Bhat

