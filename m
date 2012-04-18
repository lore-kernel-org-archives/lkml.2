Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab2DRMBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 08:01:51 -0400
Received: from mx2.parallels.com ([64.131.90.16]:40395 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab2DRMBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 08:01:49 -0400
Message-ID: <4F8EACC0.50204@parallels.com>
Date: Wed, 18 Apr 2012 09:00:00 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFD] Merge task counter into memcg
References: <20120411185715.GA4317@somewhere.redhat.com> <20120412010745.GE1787@cmpxchg.org> <20120412145507.GC11455@somewhere.redhat.com> <4F87042A.2000902@parallels.com> <20120412165922.GA12484@somewhere.redhat.com> <20120417151753.GB32402@google.com> <20120418065430.GB25568@somewhere> <CAFTL4hxXT+hXWEnKop84JQ8ieHX4e=otpHnXYxdxaPgsiZYCiw@mail.gmail.com>
In-Reply-To: <CAFTL4hxXT+hXWEnKop84JQ8ieHX4e=otpHnXYxdxaPgsiZYCiw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.34.46.150]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 05:10 AM, Frederic Weisbecker wrote:
> 2012/4/18 Frederic Weisbecker<fweisbec@gmail.com>:
>> On Tue, Apr 17, 2012 at 08:17:53AM -0700, Tejun Heo wrote:
>>> Hello, Frederic.
>>>
>>> On Thu, Apr 12, 2012 at 06:59:27PM +0200, Frederic Weisbecker wrote:
>>>> I want:
>>>>
>>>> a) to prevent the forkbomb from going far enough to DDOS the machine
>>>> b) to be able to kill that forkbomb once detected, in one go without race
>>>> against concurrent forks.
>>>>
>>>> I think a) can work just fine with kernel stack limiting. I also need
>>>> to be notified about the fact we reached the limit. And b) should
>>>> be feasible with the help of the cgroup freezer.
>>>
>>> kmem allocation fail after reaching the limit which in turn should
>>> fail task creation.  Isn't that the same effect as the task_counter as
>>> implemented?
>>
>> That's it.
>>
>>>
>>>>> Is there anything for which you need to know exactly the number of
>>>>> processes?
>>>>
>>>> No that's really about prevent/kill forkbomb as far as I'm concerned.
>>>
>>> Hmm... so, accounting overhead aside, if the only purpose is
>>> preventing the whole machine being brought down by a fork bomb, kmem
>>> limiting is enough, right?
>>
>> I think so yeah.
>
> But this needs to be a well defined kind of kmem I think. Relying on
> kernel memory
> alone is too general to just protect against forkbombs. Kernel stack,
> OTOH, should be
> a good criteria.

The problem is not it being too general. The problem is it is 
slab-based, and it takes a lot of allocations to fill a slab page. It
is a small object, but you still have one per task. If you set the limit 
too high, it won't help you. If you set it too low, it will harm
other object users.

> But now I'm worrying, do you think this kmem.kernel_stack limitation
> is going to be useful
> for other kind of usecase?

Yes. Ultimately, we want to track as many kinds of kernel memory to 
avoid having one container harming the others. Page tables and stack 
were already briefly discussed, so I think we would get to that 
eventually anyway.
