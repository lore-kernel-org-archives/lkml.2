Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab2BURGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:06:23 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:41910 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148Ab2BURGU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:06:20 -0500
Subject: Re: [PATCH RFC 0/4] Scheduler idle notifiers and users
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <CAP245DXjrRtoJYbyLQ=xUvszmwt=5gus7+=s1UmwKWXcKc05AA@mail.gmail.com>
Date: Tue, 21 Feb 2012 19:06:12 +0200
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linaro-kernel@lists.linaro.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Oleg Nesterov <oleg@redhat.com>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Todd Poynor <toddpoynor@google.com>,
        Saravana Kannan <skannan@codeaurora.org>, Mike Chan <mike@android.com>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
        Arjan Van De Ven <arjan@infradead.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <3F162BCA-554B-4756-80C6-7044FB224DBC@antoniou-consulting.com>
References: <20120208013959.GA24535@panacea> <1328670355.2482.68.camel@laptop> <20120208202314.GA28290@redhat.com> <1328736834.2903.33.camel@pasglop> <20120209075106.GB18387@elte.hu> <4F35DD3E.4020406@codeaurora.org> <20120211144530.GA497@elte.hu> <4F3AEC4E.9000303@codeaurora.org> <1329313085.2293.106.camel@twins> <20120215140245.GB27825@n2100.arm.linux.org.uk> <1329318063.2293.136.camel@twins> <69B0D95C-2A80-41A9-97E1-86F5840B84CF@antoniou-consulting.com> <1329828982.2293.405.camel@twins> <84EBD7CD-1085-4B33-BF71-8CE104AE2933@antoniou-consulting.com> <CAP245DXjrRtoJYbyLQ=xUvszmwt=5gus7+=s1UmwKWXcKc05AA@mail.gmail.com>
To: Amit Kucheria <amit.kucheria@linaro.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

On Feb 21, 2012, at 4:52 PM, Amit Kucheria wrote:

> On Tue, Feb 21, 2012 at 3:31 PM, Pantelis Antoniou
> <panto@antoniou-consulting.com> wrote:
>> 
>> On Feb 21, 2012, at 2:56 PM, Peter Zijlstra wrote:
>> 
>>> On Tue, 2012-02-21 at 14:38 +0200, Pantelis Antoniou wrote:
>>>> 
>>>> If we go to all the trouble of integrating cpufreq/cpuidle/sched into scheduler
>>>> callbacks, we should place hooks into the thermal framework/PM as well.
>>>> 
>>>> It will pretty common to have per core temperature readings, on most
>>>> modern SoCs.
>>>> 
>>>> It is quite conceivable to have a case with a multi-core CPU where due
>>>> to load imbalance, one (or more) of the cores is running at full speed
>>>> while the rest are mostly idle. What you want do, for best performance
>>>> and conceivably better power consumption, is not to throttle either
>>>> frequency or lowers voltage to the overloaded CPU but to migrate the
>>>> load to one of the cooler CPUs.
>>>> 
>>>> This affects CPU capacity immediately, i.e. you shouldn't schedule more
>>>> load on a CPU that its too hot, since you'll only end up triggering thermal
>>>> shutdown. The ideal solution would be to round robin
>>>> the load from the hot CPU to the cooler ones, but not so fast that we lose
>>>> due to the migration of state from one CPU to the other.
>>>> 
>>>> In a nutshell, the processing capacity of a core is not static, i.e. it
>>>> might degrade over time due to the increase of temperature caused by the
>>>> previous load.
>>>> 
>>>> What do you think?
>>> 
>>> This is called core-hopping, and yes that's a nice goal, although I
>>> would like to do that after we get the 'simple' bits up and running. I
>>> suspect it'll end up being slightly more complex than we'd like to due
>>> to the fact that the goal conflicts with wanting to aggregate things on
>>> cpu0 due to cpu0 being special for a host of reasons.
>>> 
>>> 
>> 
>> Hi Peter,
>> 
>> Agreed. We need to get there step by step, and I think that per-task load tracking
>> is the first one. We do have other metrics besides load that can influence the
>> scheduler decisions, with the most obvious being power consumption.
>> 
>> BTW, since we're going to the trouble of calculating per-task load with
>> increased accuracy, how about having some thought of translating the load numbers
>> in an absolute format. I.e. with the CPUs now having fluctuating performance
>> (due to cpufreq etc.) one would say that each CPU would have an X bogomips
>> (or some else absolute) capacity per OPP. Perhaps having such a bogomips number
>> calculated per-task would make things easier.
>> 
>> Perhaps the same can be done with power/energy, i.e. have a per-task power
>> consumption figure that we can use for scheduling, according to the available
>> power budget per CPU.
>> 
>> Dunno, it might not be feasible ATM, but having a power-aware scheduler would
>> assume some kind of power measurement, no?
> 
> No please. We don't want to document ADC requirements, current probe
> specs and sampling rates to successfully run the Linux kernel. :)
> 

No, we certainly don't want to do that :). I only care about some kind
of absolute value metric, and not something relative to the maximum
speed of which one of the cores can run. Now if there's some way for
a user-space app to convert that value into something like a mW measurement
is somebody else's problem :)

> But from the scheduler mini-summit, there is acceptance that we need
> to pass *some* knowledge of CPU characteristics to Linux. These need
> to be distilled down to a few that guide scheduler policy e.g. power
> cost of using a core. This in turn would influence the scheduler's
> spread or gather decision (better to consolidate task onto few cores
> or spread them out at low frequencies). Manufacturing processes and
> CPU architecture obviously play a role in the differences here.
> However, I don't expect unit for these parameters to be in mW. :)
> 
> /Amit

Yes, that is what we need. 

The problem of a power-aware scheduler, the way I see it is a matter of getting 
to a point of dynamic equilibrium between acceptable performance and acceptable 
power-usage.

It seems we will have the per-task cpu load value, so we have a measure of 
the force pushing to one side, we will need something pushing to the other.

Regards

-- Pantelis
 




