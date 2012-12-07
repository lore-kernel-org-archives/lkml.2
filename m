Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030645Ab2LGPvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 10:51:20 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:50588 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030409Ab2LGPvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 10:51:19 -0500
Message-ID: <50C21056.5090905@linux.vnet.ibm.com>
Date: Fri, 07 Dec 2012 09:50:46 -0600
From: Michael Wolf <mjw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        riel@redhat.com, kvm@vger.kernel.org, peterz@infradead.org,
        mingo@redhat.com, anthony@codemonkey.ws
Subject: Re: [PATCH 0/5] Alter steal time reporting in KVM
References: <20121126203603.28840.38736.stgit@lambeau> <20121127232442.GA8295@amt.cnet> <50B65B4A.50508@linux.vnet.ibm.com> <50B67A4B.8060800@parallels.com> <50B79EC9.4000708@linux.vnet.ibm.com> <50BF4225.9030709@parallels.com>
In-Reply-To: <50BF4225.9030709@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120715-1618-0000-0000-000002FCE013
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2012 06:46 AM, Glauber Costa wrote:
> I am deeply sorry.
>
> I was busy first time I read this, so I postponed answering and ended up
> forgetting.
>
> Sorry
>>> include/linux/sched.h:
>>> unsigned long long run_delay; /* time spent waiting on a runqueue */
>>>
>>> So if you are out of the runqueue, you won't get steal time accounted,
>>> and then I truly fail to understand what you are doing.
>> So I looked at something like this in the past.  To make sure things
>> haven't changed
>> I set up a cgroup on my test server running a kernel built from the
>> latest tip tree.
>>
>> [root]# cat cpu.cfs_quota_us
>> 50000
>> [root]# cat cpu.cfs_period_us
>> 100000
>> [root]# cat cpuset.cpus
>> 1
>> [root]# cat cpuset.mems
>> 0
>>
>> Next I put the PID from the cpu thread into tasks.  When I start a
>> script that will hog the cpu I see the
>> following in top on the guest
>> Cpu(s):  1.9%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa, 48.3%hi, 0.0%si,
>> 49.8%st
>>
>> So the steal time here is in line with the bandwidth control settings.
> Ok. So I was wrong in my hunch that it would be outside the runqueue,
> therefore work automatically. Still, the host kernel has all the
> information in cgroups.
>
>> So then the steal time did not show on the guest.  You have no value
>> that needs to be passed
>> around.  What I did not like about this approach was
>> * only works for cfs bandwidth control.  If another type of hard limit
>> was added to the kernel
>>     the code would potentially need to change.
> This is true for almost everything we have in the kernel!
> It is *very* unlikely for other bandwidth control mechanism to ever
> appear. If it ever does, it's *their* burden to make sure it works for
> steal time (provided it is merged). Code in tree gets precedence.

Ok,  I will work on a patch that uses the cgroup information for 
bandwidth control
to separate out the time.

>
>> * This approach doesn't help if the limits are set by overcommitting the
>> cpus.  It is my understanding
>>     that this is a common approach.
>>
> I can't say anything about commonality, but common or not, it is a
> *crazy* approach.
>
> When you simply overcommit, you have no way to differentiate between
> intended steal time and non-intended steal time. Moreover, when you
> overcommit, your cpu usage will vary over time. If two guests use the
> cpu to their full power, you will have 50 % each. But if one of them
> slows down, the other gets more. What is your entitlement value? How do
> you define this?
>
> And then after you define it, you end up using more than this, what is
> your cpu usage? 130 %?

yes exactly you would ideally show a boosted amount of cpu.  However to 
do that
you would need to either create a new tool or modify the current 
accounting tools
such as top.

My understanding is that you are not capping in this case as much as you 
are
guaranteeing a minimum level of performance.

>
>
> The only sane way to do it, is to communicate this value to the kernel
> somehow. The bandwidth controller is the interface we have for that. So
> everybody that wants to *intentionally* overcommit needs to communicate
> this to the controller. IOW: Any sane configuration should be explicit
> about your capping.
>
>>>>>>          Add an ioctl to communicate the consign limit to the host.
>>> This definitely should go away.
>>>
>>> More specifically, *whatever* way we use to cap the processor, the host
>>> system will have all the information at all times.
>> I'm not understanding that comment.  If you are capping by simply
>> controlling the amount of
>> overcommit on the host then wouldn't you still need some value to
>> indicate the desired amount.
> No, that is just crazy, and I don't like it a single bit.
>
> So in the light of it: Whatever capping mechanism we have, we need to be
> explicit about the expected entitlement. At this point, the kernel
> already knows what it is, and needs no extra ioctls or anything like that.
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

