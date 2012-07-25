Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab2GYQhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 12:37:45 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:40975 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab2GYQhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 12:37:42 -0400
Message-ID: <501020C7.1050303@linux.vnet.ibm.com>
Date: Wed, 25 Jul 2012 22:07:27 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: tglx@linutronix.de, mingo@kernel.org, peterz@infradead.org,
        rusty@rustcorp.com.au, paulmck@linux.vnet.ibm.com, namhyung@kernel.org,
        tj@kernel.org, rjw@sisk.pl, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] CPU hotplug: Reverse invocation of notifiers
 during CPU hotplug
References: <Pine.LNX.4.44L0.1207251205500.2008-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1207251205500.2008-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12072516-8878-0000-0000-000003621CEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 09:40 PM, Alan Stern wrote:
> On Wed, 25 Jul 2012, Srivatsa S. Bhat wrote:
> 
>> On 07/25/2012 08:27 PM, Alan Stern wrote:
>>> On Wed, 25 Jul 2012, Srivatsa S. Bhat wrote:
>>>
>>>> Hi,
>>>>
>>>> This patchset implements the approach of invoking the CPU hotplug callbacks
>>>> (notifiers) in one order during CPU online and in the reverse order during CPU
>>>> offline. The rationale behind this is that services for a CPU are started in a
>>>> particular order (perhaps, with implicit dependencies between them) while
>>>> bringing up the CPU, and hence, it makes sense to tear down the services in
>>>> the opposite order, thereby honoring most of the dependencies automatically
>>>> (and also correctly). This is explained in more detail in Patch 6.
>>>
>>> This strongly suggests that a notifier chain may be the wrong mechanism
>>> to use here.  Notifiers provide only limited guarantees about ordering,
>>> and it's hard to say much about the services a particular chain will
>>> provide since callbacks can be added from anywhere.
>>>
>>
>> True, the ability to register any random callback from anywhere is still a
>> problem that we are fighting... The zillions of callbacks that we have today
>> makes the hotplug process quite entangled.. we can't even roll-back from a
>> failure easily!
>>
>>> Instead of adding all this complication to the notifier mechanism, how 
>>> about using something else for CPU hotplug?
>>>
>>
>> The problem is that today, many different subsystems need to know about CPUs coming
>> up or going down.. And CPU hotplug is not atomic, it happens in stages, and the
>> coordination between those subsystems is what actually drives CPU hotplug, in a way.
> 
> All this reinforces the idea that notifiers are the wrong mechanism for 
> CPU hotplug.
> 
>> At present, I think that the best we can do is to redesign the hotplug code such that
>> the number of callbacks that are needed can be reduced to a minimum amount and then
>> have good control over what those callbacks do. For example, Thomas Gleixner posted
>> the park/unpark patchset[1], which not only speeds-up CPU hotplug by avoiding destruction
>> and creation of per-cpu kthreads on every hotplug operation, but also gets rid of quite
>> a few notifiers by providing a framework to manage those per-cpu kthreads...
> 
> I think the best you can do is stop using notifiers and use something 
> else instead.  For example, a simple set of function calls (assuming 
> you know beforehand what callbacks need to be invoked).

Hmmm.. So, that way we would know exactly what we are doing, and we would have complete
control over the ordering and rollback (if needed).. Sounds like a good idea! But I'm not
sure off hand whether there are any serious hurdles to that! (other than the fact that
perhaps we'll end up having way too many function calls inside the core code)...
I'll try and see how that can be implemented. Thanks!

> 
>> One of the other ideas to improve the hotplug notifier stuff that came up during some
>> of the discussions was to implement explicit dependency tracking between the notifiers
>> and perhaps get rid of the priority numbers that are currently being used to provide
>> some sort of ordering between the callbacks. Links to some of the related discussions
>> are provided below.
> 
> This seems like misplaced over-engineering.
>

Heh ;-)

Regards,
Srivatsa S. Bhat

