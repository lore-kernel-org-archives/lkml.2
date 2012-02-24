Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab2BXEoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 23:44:38 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:51400 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab2BXEoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 23:44:37 -0500
Message-ID: <4F4715A7.2030401@linux.vnet.ibm.com>
Date: Fri, 24 Feb 2012 10:14:23 +0530
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
References: <201202070200.55505.rjw@sisk.pl> <4F45DBDB.4010308@linux.vnet.ibm.com> <201202232226.43104.rjw@sisk.pl> <201202232232.59114.rjw@sisk.pl>
In-Reply-To: <201202232232.59114.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12022404-9574-0000-0000-000001819A5D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2012 03:02 AM, Rafael J. Wysocki wrote:

> On Thursday, February 23, 2012, Rafael J. Wysocki wrote:
>> On Thursday, February 23, 2012, Srivatsa S. Bhat wrote:
>>> On 02/23/2012 03:40 AM, Rafael J. Wysocki wrote:
>>>
>>>> On Wednesday, February 22, 2012, Srivatsa S. Bhat wrote:
>>>>> On 02/22/2012 10:19 AM, John Stultz wrote:
>>>>>
>>>>>> On Wed, 2012-02-22 at 00:31 +0100, Rafael J. Wysocki wrote:
>>>>>>> Hi all,
>>>>>>>
>>>>>>> After the feedback so far I've decided to follow up with a refreshed patchset.
>>>>>>> The first two patches from the previous one went to linux-pm/linux-next
>>>>>>> and I included the recent evdev patch from Arve (with some modifications)
>>>>>>> to this patchset for completness.
>>>>>>
>>>>>> Hey Rafael, 
>>>>>> 	Thanks again for posting this! I've started playing around with it in a
>>>>>> kvm environment, and got the following warning after echoing off >
>>>>>> autosleep:
>>>>>> ...
>>>>>> PM: resume of devices complete after 185.615 msecs
>>>>>> PM: Finishing wakeup.
>>>>>> Restarting tasks ... done.
>>>>>> PM: Syncing filesystems ... done.
>>>>>> PM: Preparing system for mem sleep
>>>>>> Freezing user space processes ... 
>>>>>> Freezing of tasks failed after 20.01 seconds (1 tasks refusing to freeze, wq_busy=0):
>>>>>> bash            D ffff880015714010 
>>>>>
>>>>>
>>>>> Ah.. I think I know what is the problem here..
>>>>>
>>>>> The kernel was freezing userspace processes and meanwhile, you wrote "off"
>>>>> to autosleep. So, as a result, this userspace process (bash) just now
>>>>> entered kernel mode. Unfortunately, the autosleep_lock is held for too long,
>>>>> that is, something like:
>>>>>
>>>>> acquire autosleep_lock
>>>>> modify autosleep_state
>>>>>                                <============== "A"
>>>>>  pm_suspend or hibernate()
>>>>>
>>>>> release autosleep_lock
>>>>>
>>>>> At point marked "A", we should have released the autosleep lock and only then
>>>>> entered pm_suspend or hibernate(). Since the current code holds the lock and
>>>>> enters suspend/hibernate, the userspace process that wrote "off" to autosleep
>>>>> (or even userspace process that writes to /sys/power/state will end up waiting
>>>>> on autosleep_lock, thus failing the freezing operation.)
>>>>>
>>>>> So the solution is to always release the autosleep lock before entering
>>>>> suspend/hibernation.
>>>>
>>>> Well, the autosleep lock is intentionally held around suspend/hibernation in
>>>> try_to_suspend(), because otherwise it would be possible to trigger automatic
>>>> suspend right after user space has disabled it.
>>>>
>>>
>>>
>>> Hmm.. I was just wondering if we could avoid holding yet another lock in the
>>> suspend/hibernate path, if possible.. 
>>>
>>>  
>>>> I think the solution is to make pm_autosleep_lock() do a _trylock() and
>>>> return error code if already locked.
>>>>
>>>
>>> ... and also do a trylock() in pm_autosleep_set_state() right?.... that is
>>> where John hit the problem..
>>>
>>> By the way, I am just curious.. how difficult will this make it for userspace
>>> to disable autosleep? I mean, would a trylock mean that the user has to keep
>>> fighting until he finally gets a chance to disable autosleep?
>>
>> That's a good point, so I think it may be a good idea to do
>> mutex_lock_interruptible() in pm_autosleep_set_state() instead.
> 
> Now that I think of it, perhaps it's a good idea to just make
> pm_autosleep_lock() do mutex_lock_interruptible() _and_ make
> pm_autosleep_set_state() use pm_autosleep_lock().
> 
> What do you think?
> 


Well, I don't think mutex_lock_interruptible() would help us much..
Consider what would happen, if we use it:

* pm-suspend got initiated as part of autosleep. Acquired autosleep lock.
* Userspace is about to get frozen.
* Now, the user tries to write "off" to autosleep. And hence, he is waiting
  for autosleep lock, interruptibly.
* The freezer sent a fake signal to all userspace processes and hence
  this process also got interrupted.. it is no longer waiting on autosleep
  lock - it got the signal and returned, and got frozen.
  (And when the userspace gets thawed later, this process won't have the
   autosleep lock - which is a different (but yet another) problem).

So ultimately the only thing we achieved is to ensure that freezing of
userspace goes smoothly. But the user process could not succeed in
disabling autosleep. Of course we can work around that by having the
mutex_lock_interruptible() in a loop and so on, but that gets very
ugly pretty soon.

So, I would suggest the following solution:

We want to achieve 2 things here:
 a. A user process trying to write to /sys/power/state or
    /sys/power/autosleep should not cause freezing failures.
 b. When a user process writes "off" to autosleep, the suspend/hibernate
    attempt that is on-going, if any, must be immediately aborted, to give
    the user the feeling that his preference has been noticed and respected.

And to achieve this, we note that a user process can write "off" to autosleep
only until the userspace gets frozen. No chance after that.

So, let's do this:
1. Drop the autosleep lock before entering pm-suspend/hibernate.
2. This means, a user process can get hold of this lock and successfully
   disable autosleep a moment after we initiated suspend, but before userspace
   got frozen fully.
3. So, to respect the user's wish, we add a check immediately after the
   freezing of userspace is complete - we check if the user disabled autosleep
   and bail out, if he did. Otherwise, we continue and suspend the machine.

IOW, this is like hitting 2 birds with one stone ;-)
We don't hold autosleep lock throughout suspend/hibernate, but still react
instantly when the user disables autosleep. And of course, freezing of tasks
won't fail, ever! :-)

 
Regards,
Srivatsa S. Bhat

