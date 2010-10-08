Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab0JHAsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:48:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49885 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab0JHAsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:48:05 -0400
Message-ID: <4CAE69E5.5080007@cn.fujitsu.com>
Date: Fri, 08 Oct 2010 08:46:29 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: eranian@gmail.com, linux-kernel@vger.kernel.org, peterz@infradead.org,
        mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        robert.richter@amd.com, acme@redhat.com
Subject: Re: [RFC PATCH 1/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v4)
References: <4cac3d2e.21edd80a.7008.1831@mx.google.com>	<4CAD206A.1090708@cn.fujitsu.com>	<AANLkTikcc_egoo==_R6usUdCm07Cuog7gD4DEjX8rfaP@mail.gmail.com> <AANLkTi=x-WH5eF9rdr4c8QfdzRdLcEJn0PV2svuGqCT-@mail.gmail.com>
In-Reply-To: <AANLkTi=x-WH5eF9rdr4c8QfdzRdLcEJn0PV2svuGqCT-@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> +#ifdef CONFIG_CGROUPS
>>>> +struct perf_cgroup_time {
>>>> +     u64 time;
>>>> +     u64 timestamp;
>>>> +};
>>>> +
>>>> +struct perf_cgroup {
>>>> +     struct cgroup_subsys_state css;
>>>> +     struct perf_cgroup_time *time;
>>>> +};
>>> Can we avoid adding this perf cgroup subsystem? It has 2 disavantages:
>>>
>> Well, I need to maintain some timing information for each cgroup. This has
>> to be stored somewhere.
>>

Seems you can simply store it in struct perf_event?

>>> - If one mounted cgroup fs without perf cgroup subsys, he can't monitor it.
>> That's unfortunately true ;-)
>>
>>> - If there are several different cgroup mount points, only one can be
>>>  monitored.
>>>
>>> To choose which cgroup hierarchy to monitor, hierarchy id can be passed
>>> from userspace, which is the 2nd column below:
>>>
>> Ok, I will investigate this. As long as the hierarchy id is unique AND it can be
>> searched, then we can use it. Using /proc is fine with me.
>>
>>> $ cat /proc/cgroups
>>> #subsys_name    hierarchy       num_cgroups     enabled
>>> debug   0       1       1
>>> net_cls 0       1       1
>>>
> 
> If I mount all subsystems:
> mount -t cgroup none /dev/cgroup
> Then, I get:
> #subsys_name	hierarchy	num_cgroups	enabled
> cpuset	1	1	1
> cpu	        1	1	1
> perf_event	1	1	1
> 
> In other words, the hierarchy id is not unique.
> If the perf_event is not mounted, then hierarchy id = 0.
> 

Yes, it's unique. ;)

You mounted them together, and that's a cgroup hierarchy, so
they have the same hierarchy id.

If you mount them seperately:

# mount -t cgroup -o debug xxx /cgroup1
# mount -t cgroup -o net_cls xxx /cgroup2/
# cat /proc/cgroups
#subsys_name    hierarchy       num_cgroups     enabled
debug   1       1       1
net_cls 2       1       1

They now have different hierarchy id, because they belong
to different cgroup hierarchy.

So pid + hierarchy_id locates the cgroup.

> When I compare with my approach, if perf_event is
> not mounted, then the file descriptor won't lead to the
> css, and therefore you will fail and that is fine because
> it means the perf_event subsystem is not instantiated
> therefore it cannot be used.
> 
> In my patch, there was a missing check for a NULL
> css. I fixed that now, and it works fine.
> 
> As for multiple mount points, it seems like the first
> mount determines the restrictions for all mounts.
> In other words, if you mount only cpuset, then no
> other mount can provide more than cpuset, and vice-versa.
> 
> I have tried mounting cgroupfs in multiple places at the same
> time. Whatever directory I used, I got to the right css.
> 
> Am I missing your point here?
> 

I should use the words "cgroup hierarchies" instead of mount points..

