Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab0HDGtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 02:49:45 -0400
Received: from mail.lang.hm ([64.81.33.126]:48308 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756438Ab0HDGto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 02:49:44 -0400
Date: Tue, 3 Aug 2010 23:48:06 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Florian Mickler <florian@mickler.org>
cc: Arjan van de Ven <arjan@infradead.org>, paulmck@linux.vnet.ibm.com,
        =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        "Ted Ts'o" <tytso@mit.edu>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org, pavel@ucw.cz,
        rjw@sisk.pl, stern@rowland.harvard.edu, swetland@google.com,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <20100804081209.37aa1095@schatten.dmk.lab>
Message-ID: <alpine.DEB.2.00.1008032331540.25170@asgard.lang.hm>
References: <20100801210548.23f77ff6@infradead.org> <alpine.DEB.2.00.1008012153300.25170@asgard.lang.hm> <20100802140933.GB2405@linux.vnet.ibm.com> <alpine.DEB.2.00.1008021627290.29820@asgard.lang.hm> <AANLkTi=1kBuyPS_P+eNLcnRu1mJH6BzpzQW_sENZuL1L@mail.gmail.com>
 <alpine.DEB.2.00.1008022121430.6545@asgard.lang.hm> <AANLkTikhcYzNp8CPp8cqrV7Ey5CLMWu1sJTNxUtEi2as@mail.gmail.com> <alpine.DEB.2.00.1008022203470.6545@asgard.lang.hm> <AANLkTinFT5jq4nUhUpzS5S4TVDQGj0S7RtRgxNhsz2UF@mail.gmail.com>
 <alpine.DEB.2.00.1008031611100.6545@asgard.lang.hm> <20100804001015.GJ2407@linux.vnet.ibm.com> <20100803205758.21fcf372@infradead.org> <alpine.DEB.2.00.1008032148210.25170@asgard.lang.hm> <20100804081209.37aa1095@schatten.dmk.lab>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010, Florian Mickler wrote:

> Subject: Re: Attempted summary of suspend-blockers LKML thread
> 
> On Tue, 3 Aug 2010 21:55:07 -0700 (PDT)
> david@lang.hm wrote:
>
>> On Tue, 3 Aug 2010, Arjan van de Ven wrote:
>>
>>> On Tue, 3 Aug 2010 17:10:15 -0700
>>> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
>>>>
>>>> OK, I'll bite...
>>>>
>>>>> From an Android perspective, the differences are as follows:
>>>>
>>>> 1.	Deep idle states are entered only if there are no runnable
>>>> tasks. In contrast, opportunistic suspend can happen even when there
>>>> 	are tasks that are ready, willing, and able to run.
>>>
>>> for "system suspend", this is an absolutely valid statement.
>>> for "use suspend as idle state", it's not so clearly valid.
>>> (but this is sort of a separate problem, basically the "when do we
>>> freeze the tasks that we don't like for power reasons" problem,
>>> which in first order is independent on what kind of idle power state
>>> you pick, and discussed extensively elsewhere in this thread)
>>
>> note that what I'm speculating about would never freeze some of the tasks,
>> it would run everything if anything is run, but it would not consider the
>> actions of some of the programs when deciding if it can shutdown.
>>
>> so if you have all your privilaged applications in long sleeps, but still
>> have your bouncing cows running, peggng the CPU, making noise, and
>> updating the screen, the system would decide the system is 'idle' and go
>> into the 'suspend' low power state until there is a wake activity.
>>
>> but if you have a privilaged application doing other stuff (say you are
>> talking on the phone, have a GPS mapping program running and giving you
>> directions, etc), the bouncing cows would continue to run and there would
>> never be an attempt to freeze them while leaving the other stuff active.
>>
>> David Lang
>
> I think the only difference between your proposition and the
> current android practice is that in your scheme the partition is along
> the process/task boundary (i.e. good apps vs bad apps) whereas the
> android looks at actions or events or ... let's call it "stuff" and
> blocks suspend whenever "stuff" needs to be done.

with the caviot that only privilaged applications are allowed to define 
that "stuff" needs to be done

> The main thing is that even an process that is allowed to block suspend
> doesn't do so all the time. Only when it is critical that "stuff" get's
> done right away.

effectivly, only when it's important that "stuff" gets done at all. With 
current smartphone battery capacities it's not uncommon that the phone 
could be in suspend until the battery dies, since suspend is not zero 
power.

> One way to make an application work the same way with your scheme (as
> I understand it) on android could be to split the
> application into an "blocker" part, that is not part of the
> "ignore-cgroup" (the "trusted" part) and another one that is in the
> "ignore-cgroup" (the "untrusted" part). Whenever the untrusted part
> needs to block suspend it notices the "trusted" part via ipc and the
> trusted part goes into some sort of "activity loop". This looks kind of
> stupid. But I bet it is what application developers are going to do if
> there is no provision for a flexible runtime enable/disable "suspend
> blocker".

remember that only "trusted" applications were allowed to set the 
suspend-blocker/wakelock flag in the first place.

my thinking is that since "trusted" applications are assumed to be well 
written (or they can just raise the suspend-blocker/wakelock and keep the 
phone from ever sleeping) they should be able to be trusted to sleep 
appropriately so that if they aren't actually doing anything important the 
system can go ahead and go to sleep.

Since powertop was designed to find ill-bahaved applications, you would 
still be able to point the finger at the offenders.


yes, you could trivially have a 'keep me awake' daemon that other apps can 
talk to to request the system stay awake (the same way you could with a 
suspend-blocker/wakelock). The "activity loop" for such a 
daemon can be pretty trivial, set a timer just a little shorter than the 
idle-go-to-suspend timeout, sleep that long and reset the timer.

I could be mistaken here, but my assumption is that since normal 
applications running would never get trigger the wakelock except when 
there is user input, the timeout here is on the order of 10s of seconds, 
if not a few minutes. having a privilaged application wake up once every 
several seconds is not going to be significant to anything other than 
things looking for the system being idle for X amount of time..

Even if this is done, having a userspace 'wakelock' daemon that works this 
way is significantly better in many people's eyes than having the kernel 
implement this policy. It's much easier to put application/platform 
specific logic in the userspace daemon than into the kernel (say, things 
like 'any app can request a delay for up to X amount of time, but after 
that they cannot request it again for Y amount of time, except ....)


David Lang
