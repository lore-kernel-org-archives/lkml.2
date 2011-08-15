Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab1HOTTC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 15:19:02 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37682 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1HOTTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 15:19:00 -0400
Message-ID: <4E49711E.30907@linux.vnet.ibm.com>
Date: Mon, 15 Aug 2011 12:18:54 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 6/6] perf tool: Parse general/raw events from sysfs
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com> <1310740503-15608-7-git-send-email-ming.m.lin@intel.com> <CABPqkBRTw5mcHn29gba8OyeUfMuGU3mQcKsrADug1401n6j0kw@mail.gmail.com> <1312673888.2664.18.camel@hp6530s> <CABPqkBTp_R6RRUdkYwB5O6HN6i05V=4eV3Pb2NaS3KZUhBN7fg@mail.gmail.com> <1312765681.3938.1668.camel@minggr.sh.intel.com> <CABPqkBTNoLybq7xu5qUwD1smfM5qb3qnNDD6omnpDQNdFZu-CQ@mail.gmail.com>
In-Reply-To: <CABPqkBTNoLybq7xu5qUwD1smfM5qb3qnNDD6omnpDQNdFZu-CQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2011 03:38 PM, Stephane Eranian wrote:
> Lin,
> 
> On Sun, Aug 7, 2011 at 6:08 PM, Lin Ming <ming.m.lin@intel.com> wrote:
>> On Mon, 2011-08-08 at 07:47 +0800, Stephane Eranian wrote:
>>> On Sat, Aug 6, 2011 at 4:38 PM, Lin Ming <ming.m.lin@intel.com> wrote:
>>>> On Sun, 2011-08-07 at 04:10 +0800, Stephane Eranian wrote:
>>>>> Hi,
>>>>>
>>>>> On Fri, Jul 15, 2011 at 7:35 AM, Lin Ming <ming.m.lin@intel.com> wrote:
>>>>>> PMU can export general events to sysfs, for example,
>>>>>>
>>>>>> /sys/bus/event_source/devices/uncore/events
>>>>>> └── cycle
>>>>>>
>>>>>> Then specify the event as <pmu>:<event>,
>>>>>>
>>>>>> $ sudo perf stat -a -C 0 -e uncore:cycle
>>>>>
>>>>> I think this event syntax should be adjusted a bit.
>>>>>
>>>>> How would the tool differentiate:
>>>>>        perf stat -e uncore:cycle
>>>>> form:
>>>>>       perf stat -e cycle:u
>>>>>
>>>>> It would have to scan sysfs for a 'cycle' PMU and conclude
>>>>> there is none,  then resolve the 'cycle' event name. And if
>>>>> you're unlucky and you have a event name that matches
>>>>> the PMU name, you get into troubles.
>>>>>
>>>>> I think, one could instead do:
>>>>>
>>>>>     perf stat -e uncore::cycle:k
>>>>>
>>>>> That way, by virtue of the '::' separator, the tool would know
>>>>> that it needs to first look into sysfs for an 'uncore' PMU, then
>>>>> it needs to look for the 'cycle' event.
>>>>
>>>> Yes, I like this '::' separator too.
>>>> Will update to use it.
>>>>
>>>>>
>>>>> I also use the '::' notation in libpfm4 to separate the PMU model
>>>>> form the event+umask+modifiers.
>>>>>
>>>>> I also suspect that with this sysfs interface for PMU models, you
>>>>> would simply add a number to differentiate each instance of a PMU.
>>>>> So for GPU, you would do:
>>>>>     perf stat -e  gfx0::cycles
>>>>>
>>>>> Is that right?
>>>>
>>>> A number or other thing is OK.
>>>>
>>>> int perf_pmu_register(struct pmu *pmu, char *name, int type)
>>>> will be called to register a PMU.
>>>>
>>>> So I think any name that can differentiate each instance is OK.
>>>>
>>>> Adding a number looks like the easiest way.
>>>>
>>> Well, there is something I am still missing here.
>>>
>>> Based on the current patch, it seems that each instance
>>> of a PMU needs to register to get an ID and an entry in
>>> sysfs.
>>>
>>> Suppose you have a system with two graphics cards. Then,
>>> you would need two IDs and two entries in sysfs to correctly
>>> name each gfx card.
>>>
>>> That means that the kernel would have to iterate over each instance
>>> of a PMU and create a name for it, e.g., something like:
>>>    for_each_gfx_card(i) {
>>>        sprintf(name, "gfx%d", i);
>>>       register_pmu(&pmu, name);
>>>   }
>>>
>>> Is that what you are proposing?
>>
>> Think this more closely. My previous reply was not correct.
>>
>> We only need to register one pmu with two same graphics cards.
>> Then we can overload pid argument of sys_perf_event_open() to
>> differentiate each instance of graphic card.
>>
>> Just like perf cgroup does.
>>
> Some more thoughts on that.
> 
> Cgroup is very specific. It can only work an an extension of system-wide mode.
> Thus, we know we can safely overload the PID argument with the cgroup fd. But
> then, we also need to tell the kernel that PID is a cgroup fd and for
> that we use
> a flag.
> 
> I don't think you can do that with your PMU proposal.
> 
> You can pass the PMU class in attr.config, but if you pass the PMU instance
> in PID, it means you predict that there will never be another PMU
> where per-thread
> mode will make sense. But even if that were to be true, you'd have to
> still have to
> pass an extra flag to denote that you are using a extended PMU with an instance
> in PID. Or the alternative it to rely on PERF_TYPE_MAX to detect a dynamically
> registered PMU. It's not too pretty. This whole thing makes me wonder
> what perf_type_id
> is meant for then....

I may be way off base here, since I've been out of the loop for awhile....

Wouldn't it be better to specify the path of the PMU in sysfs as part of
the event name?

For example, if there are two GPUs, you specify the path of the GPU's
PMU that you want.

I don't know how that would look exactly in sysfs, but suppose the path
to the GPU PMU is

/sys/class/gpu/devices/gpu00/pmu

The event specifier to perf would be

gpu/gpu00::event1

(Note, the path prefix and "devices" have been compressed out to make
the PMU specifier more convenient to type)

perf would read the id of the PMU from the id "file" in the gpu00/pmu
directory and then pass that as the attr type field.

This way, you don't have to give a separate numbering system to the GPUs.

- Corey
