Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529Ab0HDXkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 19:40:51 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36249 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab0HDXks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 19:40:48 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1008041620010.6545@asgard.lang.hm>
References: <20100801054816.GI2470@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008041124580.6545@asgard.lang.hm>
	<20100804185520.GA2417@srcf.ucam.org>
	<201008042251.08266.rjw@sisk.pl>
	<20100804205654.GA4986@srcf.ucam.org>
	<alpine.DEB.2.00.1008041529530.6545@asgard.lang.hm>
	<AANLkTimRZc2B1=ic-0jrGBX7ahCu=NCoQadCOePGDmh9@mail.gmail.com>
	<alpine.DEB.2.00.1008041554580.6545@asgard.lang.hm>
	<AANLkTingom2AKfMu0EbfdfLiMnHo+buy1e4=PBENf3Vi@mail.gmail.com>
	<alpine.DEB.2.00.1008041620010.6545@asgard.lang.hm>
Date: Wed, 4 Aug 2010 16:40:47 -0700
Message-ID: <AANLkTiknyohok23S7dob=Tb1+PZp1QqZgwckcVDWMSe9@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: david@lang.hm
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/4  <david@lang.hm>:
> On Wed, 4 Aug 2010, Arve Hj?nnev?g wrote:
>
>> 2010/8/4  <david@lang.hm>:
>>>
>>> On Wed, 4 Aug 2010, Arve Hj?nnev?g wrote:
>>>
>>>> On Wed, Aug 4, 2010 at 3:31 PM,  <david@lang.hm> wrote:
>>>>>
>>>>> On Wed, 4 Aug 2010, Matthew Garrett wrote:
>>>>>
>>>>>> On Wed, Aug 04, 2010 at 10:51:07PM +0200, Rafael J. Wysocki wrote:
>>>>>>>
>>>>>>> On Wednesday, August 04, 2010, Matthew Garrett wrote:
>>>>>>>>
>>>>>>>> No! And that's precisely the issue. Android's existing behaviour
>>>>>>>> could
>>>>>>>> be entirely implemented in the form of binary that manually triggers
>>>>>>>> suspend when (a) the screen is off and (b) no userspace applications
>>>>>>>> have indicated that the system shouldn't sleep, except for the
>>>>>>>> wakeup
>>>>>>>> event race. Imagine the following:
>>>>>>>>
>>>>>>>> 1) The policy timeout is about to expire. No applications are
>>>>>>>> holding
>>>>>>>> wakelocks. The system will suspend providing nothing takes a
>>>>>>>> wakelock.
>>>>>>>> 2) A network packet arrives indicating an incoming SIP call
>>>>>>>> 3) The VOIP application takes a wakelock and prevents the phone from
>>>>>>>> suspending while the call is in progress
>>>>>>>>
>>>>>>>> What stops the system going to sleep between (2) and (3)? cgroups
>>>>>>>> don't,
>>>>>>>> because the voip app is an otherwise untrusted application that
>>>>>>>> you've
>>>>>>>> just told the scheduler to ignore.
>>>>>>>
>>>>>>> I _think_ you can use the just-merged /sys/power/wakeup_count
>>>>>>> mechanism
>>>>>>> to
>>>>>>> avoid the race (if pm_wakeup_event() is called at 2)).
>>>>>>
>>>>>> Yes, I think that solves the problem. The only question then is
>>>>>> whether
>>>>>> it's preferable to use cgroups or suspend fully, which is pretty much
>>>>>> up
>>>>>> to the implementation. In other words, is there a reason we're still
>>>>>> having this conversation? :) It'd be good to have some feedback from
>>>>>> Google as to whether this satisfies their functional requirements.
>>>>>
>>>>> the proposal that I nade was not to use cgroups to freeze some
>>>>> processes
>>>>> and
>>>>> not others, but to use cgroups to decide to ignore some processes when
>>>>> deciding if the system is idle, stop everything or nothing. cgroups are
>>>>> just
>>>>> a way of easily grouping processes (and their children) into different
>>>>> groups.
>>>>>
>>>>
>>>> That does not avoid the dependency problem. A process may be waiting
>>>> on a resource that a process you ignore owns. I you ignore the process
>>>> that owns the resource and enter idle when it is ready to run (or
>>>> waiting on a timer), you are still effectively blocking the other
>>>> process.
>>>
>>> and if you don't have a wakelock the same thing will happen. If you
>>> expect
>>
>> Not the same thing. If you don't hold a wakelock the entire system
>> will suspend and when it wakes up it continues where it left off.
>> Timeout still have time left before they expire.
>
> in what I'm proposing, if the 'privilaged/trusted" processes are idle long
> enough the entire system will suspend, and when it wakes up everything will
> continue to process normally
>

If you are triggering a system suspend from idle (I assume all cpus
idle), you also have to consider when to resume. You cannot abort
suspend just because a cpu is not idle anymore, since suspend itself
will wake up threads.

>>> the process to take a while you can set a timeout to wake up every 30
>>> seconds or so and wait again, this would be enough to prevent you from
>>> going
>>
>> I don't think polling is an acceptable solution to this problem. You
>> user space code know needs to know what "idle" timeout you have
>> selected so it can choose a faster poll rate. When is it safe to stop
>> polling?
>
> I think the timeouts are of such an order of magnatude that the polling can
> be infrequent enough to not be a significant amount of load, but be faster
> than any timeout
>

How do you ever enter suspend in this system? Currently timers in the
kernel and trusted user space code causes a significant power draw and
you want insignificant timers to prevent suspend.

>>> to sleep (or am I misunderstanding how long before you go into suspend
>>> without a wakelock set, see my other e-mail for the full question)
>>>
>>
>> We suspend as soon as no wakelocks are held. There is no delay.
>
> So, if I have a bookreader app that is not allowed to get the wakelock, and
> nothing else is running, the system will suspend immediatly after I click a
> button to go to the next page? it will not stay awake to give me a chance to
> read the page at all?
>
> how can any application run without wakelock privilages?

A wakelock is active when the screen is on.

-- 
Arve Hjønnevåg
