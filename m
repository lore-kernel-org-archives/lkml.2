Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab1JUPkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 11:40:14 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:51896 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab1JUPkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 11:40:11 -0400
Message-ID: <4EA1924A.9060403@linux.vnet.ibm.com>
Date: Fri, 21 Oct 2011 21:09:54 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: a.p.zijlstra@chello.nl, rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com,
        mingo@elte.hu, akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi, linux-pm@vger.kernel.org,
        rusty@rustcorp.com.au, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        rdunlap@xenotime.net
Subject: Re: [PATCH v3 0/3] CPU hotplug, Freezer: Fix bugs in CPU hotplug
 call path
References: <Pine.LNX.4.44L0.1110211038050.2131-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1110211038050.2131-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11102115-2000-0000-0000-0000009E0047
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On 10/21/2011 08:12 PM, Alan Stern wrote:
> On Fri, 21 Oct 2011, Srivatsa S. Bhat wrote:
> 
>> When using the CPU hotplug infrastructure to offline/online CPUs, the cpu_up()
>> and cpu_down() functions are used, which internally call _cpu_up() and
>> _cpu_down() with the second argument *always* set to 0. The second argument
>> is "tasks_frozen", which should be correctly set to 1 when tasks have been
>> frozen, even when the freezing of tasks may be due to an event unrelated
>> to CPU hotplug, such as a suspend operation in progress, in which case the
>> freezer subsystem freezes all the freezable tasks.
>>
>> Not giving the correct value for the 'tasks_frozen' argument can potentially
>> lead to a lot of issues since this will send wrong notifications via the
>> notifier mechanism leading to the execution of inappropriate code by the
>> callbacks registered for the notifiers. That is, instead of CPU_ONLINE_FROZEN
>> and CPU_DEAD_FROZEN notifications, it results in CPU_ONLINE and CPU_DEAD
>> notifications to be sent all the time, irrespective of the actual state of
>> the system (i.e., whether tasks are frozen or not).
>>
>> This patch introduces a flag to indicate whether the tasks are frozen are not
>> (by any event) and modifies cpu_up() and cpu_down() functions to check the
>> value of this flag and accordingly call _cpu_up() and _cpu_down() respectively
>> by supplying the correct value as the second argument based on the state of
>> the system. This in turn means that the correct notifications are sent, thus
>> ensuring that all the registered callbacks do the right thing.
> 
> That doesn't make any sense.  If tasks were frozen then the task 
> calling _cpu_up() or _cpu_down() would be frozen too, and therefore 
> wouldn't be able to make the call.
>

I can't believe I missed such an obvious thing!
I must have been carried away while thinking about the race between freezer
and CPU hotplug. Thanks for pointing this out.
 
>> Additionally, to ensure that the tasks are not frozen or thawed by the freezer
>> subsystem while the registered callbacks are running, this patch adds a few
>> notifications in the freezer which is then hooked onto by the CPU hotplug
>> code, to avoid this race.
> 
> That's more sensible.  Freezing or thawing tasks isn't instantaneous.  
> It's possible that _cpu_up() or _cpu_down() could be called while some 
> tasks were frozen and others were still running.
> 
> If you're careful to prevent this from happening then there's no reason 
> to change the tasks_frozen argument.  It should never be anything but 
> 0 in this situation.
> 

Agreed. So patch 1 becomes unnecessary. Patch 2 implements the needed
synchronization.
I'll fix the code (also incorporating your point that PM_POST_FREEZE and
PM_THAW_PREPARE are unnecessary) and repost.

Thank you for the review.

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab

