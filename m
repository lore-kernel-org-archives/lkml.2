Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab0JHIgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:36:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6816 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab0JHIgP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:36:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qFNheNyKm6uX/9mTbNSzChAC8zmnV6YZTyA5CvjNSaUepRpKCLQ/cbr7TmQJfROVzE
         FaOdprshKZSG87xdzXxA==
MIME-Version: 1.0
In-Reply-To: <4CAE69E5.5080007@cn.fujitsu.com>
References: <4cac3d2e.21edd80a.7008.1831@mx.google.com>
	<4CAD206A.1090708@cn.fujitsu.com>
	<AANLkTikcc_egoo==_R6usUdCm07Cuog7gD4DEjX8rfaP@mail.gmail.com>
	<AANLkTi=x-WH5eF9rdr4c8QfdzRdLcEJn0PV2svuGqCT-@mail.gmail.com>
	<4CAE69E5.5080007@cn.fujitsu.com>
Date: Fri, 8 Oct 2010 10:36:12 +0200
Message-ID: <AANLkTikPnNjVbyqx-0cOd1AD_hDSp5y12oxreGKRReJU@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v4)
From: Stephane Eranian <eranian@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org, peterz@infradead.org,
        mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        robert.richter@amd.com, acme@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 8, 2010 at 2:46 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>>>> +#ifdef CONFIG_CGROUPS
>>>>> +struct perf_cgroup_time {
>>>>> +     u64 time;
>>>>> +     u64 timestamp;
>>>>> +};
>>>>> +
>>>>> +struct perf_cgroup {
>>>>> +     struct cgroup_subsys_state css;
>>>>> +     struct perf_cgroup_time *time;
>>>>> +};
>>>> Can we avoid adding this perf cgroup subsystem? It has 2 disavantages:
>>>>
>>> Well, I need to maintain some timing information for each cgroup. This has
>>> to be stored somewhere.
>>>
>
> Seems you can simply store it in struct perf_event?
>
No, timing has to be shared by events monitoring the same cgroup at
the same time.
Works like a timestamp. It needs to be centralized for all events
attached to the same
cgroup.

>>>> - If one mounted cgroup fs without perf cgroup subsys, he can't monitor it.
>>> That's unfortunately true ;-)
>>>
>>>> - If there are several different cgroup mount points, only one can be
>>>>  monitored.
>>>>
>>>> To choose which cgroup hierarchy to monitor, hierarchy id can be passed
>>>> from userspace, which is the 2nd column below:
>>>>
>>> Ok, I will investigate this. As long as the hierarchy id is unique AND it can be
>>> searched, then we can use it. Using /proc is fine with me.
>>>
>>>> $ cat /proc/cgroups
>>>> #subsys_name    hierarchy       num_cgroups     enabled
>>>> debug   0       1       1
>>>> net_cls 0       1       1
>>>>
>>
>> If I mount all subsystems:
>> mount -t cgroup none /dev/cgroup
>> Then, I get:
>> #subsys_name  hierarchy       num_cgroups     enabled
>> cpuset        1       1       1
>> cpu           1       1       1
>> perf_event    1       1       1
>>
>> In other words, the hierarchy id is not unique.
>> If the perf_event is not mounted, then hierarchy id = 0.
>>
>
> Yes, it's unique. ;)
>
> You mounted them together, and that's a cgroup hierarchy, so
> they have the same hierarchy id.
>
> If you mount them seperately:
>
> # mount -t cgroup -o debug xxx /cgroup1
> # mount -t cgroup -o net_cls xxx /cgroup2/
> # cat /proc/cgroups
> #subsys_name    hierarchy       num_cgroups     enabled
> debug   1       1       1
> net_cls 2       1       1
>
Ok, but if you mount perf_event twice, you get the
same hierarchy id for it:

# mount -t cgroup -operf_event none /cgroup
# cat /proc/cgroups
#subsys_name	hierarchy	num_cgroups	enabled
cpuset	0	1	1
cpu	        0	1	1
perf_event	1	1	1

# mount -t cgroup -operf_event none /cgroup2
# cat /proc/cgroups
#subsys_name	hierarchy	num_cgroups	enabled
cpuset	0	1	1
cpu	        0	1	1
perf_event	1	1	1

It does not seem like I can mount the same subsystem
twice with difference hierarchies:

# umount /cgroup2
# mount -t cgroup -operf_event,cpuset none /cgroup2
mount: none already mounted or /cgroup2 busy
# mount -t cgroup  none /cgroup2
mount: none already mounted or /cgroup2 busy

> They now have different hierarchy id, because they belong
> to different cgroup hierarchy.
>
> So pid + hierarchy_id locates the cgroup.
>

I cannot do task's pid + cgroup hierarchy_id. It's one or the
other.

>> I have tried mounting cgroupfs in multiple places at the same
>> time. Whatever directory I used, I got to the right css.
>>
>> Am I missing your point here?
>>
>
> I should use the words "cgroup hierarchies" instead of mount points..
>
Can you mount the same subsystem multiple times with DIFFERENT
hierarchies?
