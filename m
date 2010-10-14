Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab0JNS4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 14:56:10 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64954 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab0JNS4I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 14:56:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=hfx3KbMd4OYMgUeDmkNGerxihWj84u36WH6ypSdxVCcgHhd2dDNK6gx7D9CefmXT2X
         csAFMFe8VsSmusEe32nCMWTRgYCfY8WFzAkyjgVIT5PX0q3qIAgH6MZ7IObWH+IN2++o
         Ho57dub3J12UK8R8J2VTZs6KZrTPkDMPRWseE=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <4CB518CE.6040106@cn.fujitsu.com>
References: <4cac3d2e.21edd80a.7008.1831@mx.google.com>
	<4CAD206A.1090708@cn.fujitsu.com>
	<AANLkTikcc_egoo==_R6usUdCm07Cuog7gD4DEjX8rfaP@mail.gmail.com>
	<AANLkTi=x-WH5eF9rdr4c8QfdzRdLcEJn0PV2svuGqCT-@mail.gmail.com>
	<4CAE69E5.5080007@cn.fujitsu.com>
	<AANLkTikPnNjVbyqx-0cOd1AD_hDSp5y12oxreGKRReJU@mail.gmail.com>
	<4CB518CE.6040106@cn.fujitsu.com>
Date: Thu, 14 Oct 2010 20:56:07 +0200
Message-ID: <AANLkTin1sfk+tWgeTbWfGWbVwese_2MvfY2Cj+uPC6SE@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v4)
From: stephane eranian <eranian@googlemail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        robert.richter@amd.com, acme@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 4:26 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> (Sorry for the late reply. I've been keeping busy..)
>
> Stephane Eranian wrote:
>> On Fri, Oct 8, 2010 at 2:46 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>>>>>> +#ifdef CONFIG_CGROUPS
>>>>>>> +struct perf_cgroup_time {
>>>>>>> +     u64 time;
>>>>>>> +     u64 timestamp;
>>>>>>> +};
>>>>>>> +
>>>>>>> +struct perf_cgroup {
>>>>>>> +     struct cgroup_subsys_state css;
>>>>>>> +     struct perf_cgroup_time *time;
>>>>>>> +};
>>>>>> Can we avoid adding this perf cgroup subsystem? It has 2 disavantages:
>>>>>>
>>>>> Well, I need to maintain some timing information for each cgroup. This has
>>>>> to be stored somewhere.
>>>>>
>>> Seems you can simply store it in struct perf_event?
>>>
>> No, timing has to be shared by events monitoring the same cgroup at
>> the same time.
>> Works like a timestamp. It needs to be centralized for all events
>> attached to the same cgroup.
>>
>
> I no little about internel perf code, so I don't know if we can store
> this somewhere in perf. The last resort could be store it in struct cgroup.
>
>>>>>> - If one mounted cgroup fs without perf cgroup subsys, he can't monitor it.
>>>>> That's unfortunately true ;-)
>>>>>
>>>>>> - If there are several different cgroup mount points, only one can be
>>>>>>  monitored.
>>>>>>
>>>>>> To choose which cgroup hierarchy to monitor, hierarchy id can be passed
>>>>>> from userspace, which is the 2nd column below:
>>>>>>
>>>>> Ok, I will investigate this. As long as the hierarchy id is unique AND it can be
>>>>> searched, then we can use it. Using /proc is fine with me.
>>>>>
>>>>>> $ cat /proc/cgroups
>>>>>> #subsys_name    hierarchy       num_cgroups     enabled
>>>>>> debug   0       1       1
>>>>>> net_cls 0       1       1
>>>>>>
>>>> If I mount all subsystems:
>>>> mount -t cgroup none /dev/cgroup
>>>> Then, I get:
>>>> #subsys_name  hierarchy       num_cgroups     enabled
>>>> cpuset        1       1       1
>>>> cpu           1       1       1
>>>> perf_event    1       1       1
>>>>
>>>> In other words, the hierarchy id is not unique.
>>>> If the perf_event is not mounted, then hierarchy id = 0.
>>>>
>>> Yes, it's unique. ;)
>>>
>>> You mounted them together, and that's a cgroup hierarchy, so
>>> they have the same hierarchy id.
>>>
>>> If you mount them seperately:
>>>
>>> # mount -t cgroup -o debug xxx /cgroup1
>>> # mount -t cgroup -o net_cls xxx /cgroup2/
>>> # cat /proc/cgroups
>>> #subsys_name    hierarchy       num_cgroups     enabled
>>> debug   1       1       1
>>> net_cls 2       1       1
>>>
>> Ok, but if you mount perf_event twice, you get the
>> same hierarchy id for it:
>>
>> # mount -t cgroup -operf_event none /cgroup
>> # cat /proc/cgroups
>> #subsys_name  hierarchy       num_cgroups     enabled
>> cpuset        0       1       1
>> cpu           0       1       1
>> perf_event    1       1       1
>>
>> # mount -t cgroup -operf_event none /cgroup2
>> # cat /proc/cgroups
>> #subsys_name  hierarchy       num_cgroups     enabled
>> cpuset        0       1       1
>> cpu           0       1       1
>> perf_event    1       1       1
>>
>> It does not seem like I can mount the same subsystem
>> twice with difference hierarchies:
>>
>> # umount /cgroup2
>> # mount -t cgroup -operf_event,cpuset none /cgroup2
>> mount: none already mounted or /cgroup2 busy
>> # mount -t cgroup  none /cgroup2
>> mount: none already mounted or /cgroup2 busy
>>
>>> They now have different hierarchy id, because they belong
>>> to different cgroup hierarchy.
>>>
>>> So pid + hierarchy_id locates the cgroup.
>>>
>>
>> I cannot do task's pid + cgroup hierarchy_id. It's one or the
>> other.
>>
>
> I've looked into the patch again, and I see you pass the fd from
> userspace, so you don't need hierarchy_id.
>
True.

> And to get rid of perf_cgroup subsys, seems you just need to find
> another place to store the time info, somewhere inside perf code
> or in struct cgroup.
>
Something I may have missed since the beginning of our conversation
is why do you think definition perf_cgroup subsys is wrong or useless.
What kind of problem does it introduce. I think it is fine to reject cgroup
mode if the perf cgroup is not mounted.

The other key point is that from a task (on context switch), I need to identify
the perf_cgroup subsys that it corresponds to. How would I have such link
if I don't leverage the existing cgroup infrastructure?
