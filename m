Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab1IHEqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 00:46:11 -0400
Received: from mx2.parallels.com ([64.131.90.16]:40988 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab1IHEqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 00:46:09 -0400
Message-ID: <4E68484A.4000201@parallels.com>
Date: Thu, 8 Sep 2011 01:44:58 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Greg Thelen <gthelen@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <containers@lists.osdl.org>, <netdev@vger.kernel.org>,
        <xemul@parallels.com>, "David S. Miller" <davem@davemloft.net>,
        Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH] per-cgroup tcp buffer limitation
References: <1315276556-10970-1-git-send-email-glommer@parallels.com> <CAHH2K0aJxjinSu0Ek6jzsZ5dBmm5mEU-typuwYWYWEudF2F3Qg@mail.gmail.com> <4E664766.40200@parallels.com> <CAHH2K0YJA7vZZ3QNAf63TZOnWhsRUwfuZYfntBL4muZ0G_Vt2w@mail.gmail.com> <4E66A0A9.3060403@parallels.com> <CAHH2K0aq4s1_H-yY0kA3LhM00CCNNbJZyvyBoDD6rHC+qo_gNg@mail.gmail.com>
In-Reply-To: <CAHH2K0aq4s1_H-yY0kA3LhM00CCNNbJZyvyBoDD6rHC+qo_gNg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [189.121.42.206]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2011 06:35 PM, Greg Thelen wrote:
> On Tue, Sep 6, 2011 at 3:37 PM, Glauber Costa<glommer@parallels.com>  wrote:
>> I think memcg's usage is really all you need here. In the end of the day, it
>> tells you how many pages your container has available. The whole
>> point of kmem cgroup is not any kind of reservation or accounting.
>
> The memcg does not reserve memory.  It provides upper bound limits on
> memory usage.  A careful admin can configure soft_limit_in_bytes as an
> approximation of a memory reservation.  But the soft limit is really
> more like a reclaim target when there is global memory pressure.
>
>> Once a container (or cgroup) reaches a number of objects *pinned* in memory
>> (therefore, non-reclaimable), you won't be able to grab anything from it.
>>
>>> So
>>> far my use cases involve a single memory limit which includes both
>>> kernel and user memory.  So I would need a user space agent to poll
>>> {memcg,kmem}.usage_in_bytes to apply pressure to memcg if kmem grows
>>> and visa versa.
>>
>> Maybe not.
>> If userspace memory works for you today (supposing it does), why change?
>
> Good question.  Current upstream memcg user space memory limit does
> not work for me today.  I should have made that more obvious (sorry).
> See below for details.
>
>> Right now you assign X bytes of user memory to a container, and the kernel
>> memory is shared among all of them. If this works for you, kmem_cgroup won't
>> change that. It just will impose limits over which
>> your kernel objects can't grow.
>>
>> So you don't *need* a userspace agent doing this calculation, because
>> fundamentally, nothing changed: I am not unbilling memory in memcg to bill
>> it back in kmem_cg. Of course, once it is in, you will be able to do it in
>> such a fine grained fashion if you decide to do so.
>>
>>> Do you foresee instantiation of multiple kmem cgroups, so that a
>>> process could be added into kmem/K1 or kmem/K2?  If so do you plan on
>>> supporting migration between cgroups and/or migration of kmem charge
>>> between K1 to K2?
>>
>> Yes, each container should have its own cgroup, so at least in the use
>> cases I am concerned, we will have a lot of them. But the usual lifecycle,
>> is create, execute and die. Mobility between them
>> is not something I am overly concerned right now.
>>
>>
>>>>> Do you foresee the kmem cgroup growing to include reclaimable slab,
>>>>> where freeing one type of memory allows for reclaim of the other?
>>>>
>>>> Yes, absolutely.
>
> Now I see that you're using kmem to limit the amount of unreclaimable
> kernel memory.
>
> We have a work-in-progress patch series that adds kernel memory accounting to
> memcg.  These patches allow an admin to specify a single memory limit
> for a cgroup which encompasses both user memory (as upstream memcg
> does) and also includes many kernel memory allocations (especially
> slab, page-tables).  When kernel memory grows it puts pressure on user
> memory; when user memory grows it puts pressure on reclaimable kernel
> memory using registered shrinkers.  We are in the process of cleaning
> up these memcg slab accounting patches.
 >
> In my uses cases there is a single memory limit that applies to both
> kernel and user memory.  If a separate kmem cgroup is introduced to
> manage kernel memory outside of memcg with a distinct limit, then I
> would need a user space daemon which balances memory between the kmem
> and memcg subsystems.  As kmem grows, this daemon would apply pressure
> to memcg, and as memcg grows pressure would be applied to kmem.  As
> you stated kernel memory is not necessarily reclaimable.  So such
> reclaim may fail.  My resistance to this approach is that with a
> single memory cgroup admins can do a better job packing a machine.  If
> balancing daemons are employed then more memory would need to be
> reserved and more user space cpu time would be needed to apply VM
> pressure between the types of memory.
Well, it is a way to see this. The other way to see this, is that you're
proposing to move to the kernel, something that really belongs in 
userspace. That's because:

With the information you provided me, I have no reason to believe that 
the kernel has more condition to do this work. Do the kernel have access 
to any information that userspace do not, and can't be exported? If not, 
userspace is traditionally where this sort of stuff has been done.

Using userspace CPU is no different from using kernel cpu in this 
particular case. It is all overhead, regardless where it comes from. 
Moreover, you end up setting up a policy, instead of a mechanism. What 
should be this proportion?  Do we reclaim everything with the same 
frequency? Should we be more tolerant with a specific container?

Also, If you want to allow any flexibility in this scheme, like: "Should 
this network container be able to stress the network more, pinning more 
memory, but not other subsystems?", you end up having to touch all 
individual files anyway - probably with a userspace daemon.

Also, as you noticed yourself, kernel memory is fundamentally different 
from userspace memory. You can't just set reclaim limits, since you have 
no guarantees it will work. User memory is not a scarce resource.
Kernel memory is.

>
> While there are people (like me) who want a combined memory usage
> limit there are also people (like you) who want separate user and
> kernel limiting.

Combined excludes separate. Separate does not exclude combined.

> I have toyed with the idea of having a per cgroup
> flag that determines if kernel and user memory should be combined
> charged against a single limit or if they should have separate limits.

And then every other kind of mechanism one may think of involves a 
kernel patch, instead of a potentially simple userspace change.

>   I have also wondered if there was a way to wire the usage of two
> subsystems together, then it would also meet meet my needs.  But I am
> not sure how to do that.
