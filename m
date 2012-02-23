Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab2BWGZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 01:25:48 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:42011 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab2BWGZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 01:25:46 -0500
Message-ID: <4F45DBDB.4010308@linux.vnet.ibm.com>
Date: Thu, 23 Feb 2012 11:55:31 +0530
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
References: <201202070200.55505.rjw@sisk.pl> <1329886179.2229.2.camel@js-netbook> <4F44AB09.9000606@linux.vnet.ibm.com> <201202222310.21627.rjw@sisk.pl>
In-Reply-To: <201202222310.21627.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12022306-5816-0000-0000-00000169BC63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2012 03:40 AM, Rafael J. Wysocki wrote:

> On Wednesday, February 22, 2012, Srivatsa S. Bhat wrote:
>> On 02/22/2012 10:19 AM, John Stultz wrote:
>>
>>> On Wed, 2012-02-22 at 00:31 +0100, Rafael J. Wysocki wrote:
>>>> Hi all,
>>>>
>>>> After the feedback so far I've decided to follow up with a refreshed patchset.
>>>> The first two patches from the previous one went to linux-pm/linux-next
>>>> and I included the recent evdev patch from Arve (with some modifications)
>>>> to this patchset for completness.
>>>
>>> Hey Rafael, 
>>> 	Thanks again for posting this! I've started playing around with it in a
>>> kvm environment, and got the following warning after echoing off >
>>> autosleep:
>>> ...
>>> PM: resume of devices complete after 185.615 msecs
>>> PM: Finishing wakeup.
>>> Restarting tasks ... done.
>>> PM: Syncing filesystems ... done.
>>> PM: Preparing system for mem sleep
>>> Freezing user space processes ... 
>>> Freezing of tasks failed after 20.01 seconds (1 tasks refusing to freeze, wq_busy=0):
>>> bash            D ffff880015714010 
>>
>>
>> Ah.. I think I know what is the problem here..
>>
>> The kernel was freezing userspace processes and meanwhile, you wrote "off"
>> to autosleep. So, as a result, this userspace process (bash) just now
>> entered kernel mode. Unfortunately, the autosleep_lock is held for too long,
>> that is, something like:
>>
>> acquire autosleep_lock
>> modify autosleep_state
>>                                <============== "A"
>>  pm_suspend or hibernate()
>>
>> release autosleep_lock
>>
>> At point marked "A", we should have released the autosleep lock and only then
>> entered pm_suspend or hibernate(). Since the current code holds the lock and
>> enters suspend/hibernate, the userspace process that wrote "off" to autosleep
>> (or even userspace process that writes to /sys/power/state will end up waiting
>> on autosleep_lock, thus failing the freezing operation.)
>>
>> So the solution is to always release the autosleep lock before entering
>> suspend/hibernation.
> 
> Well, the autosleep lock is intentionally held around suspend/hibernation in
> try_to_suspend(), because otherwise it would be possible to trigger automatic
> suspend right after user space has disabled it.
>


Hmm.. I was just wondering if we could avoid holding yet another lock in the
suspend/hibernate path, if possible.. 

 
> I think the solution is to make pm_autosleep_lock() do a _trylock() and
> return error code if already locked.
>

... and also do a trylock() in pm_autosleep_set_state() right?.... that is
where John hit the problem..

By the way, I am just curious.. how difficult will this make it for userspace
to disable autosleep? I mean, would a trylock mean that the user has to keep
fighting until he finally gets a chance to disable autosleep?

Regards,
Srivatsa S. Bhat

