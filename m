Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab2DLEqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 00:46:08 -0400
Received: from szxga01-in.huawei.com ([58.251.152.64]:44104 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab2DLEqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 00:46:05 -0400
Date: Thu, 12 Apr 2012 11:26:13 +0800
From: Li Zefan <lizefan@huawei.com>
Subject: Re: [RFD] Merge task counter into memcg
In-reply-to: <20120412010745.GE1787@cmpxchg.org>
X-Originating-IP: [10.166.88.147]
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Message-id: <4F864B55.10906@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120312
 Thunderbird/11.0
X-CFilter-Loop: Reflected
References: <20120411185715.GA4317@somewhere.redhat.com>
 <20120412010745.GE1787@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:

> On Wed, Apr 11, 2012 at 08:57:20PM +0200, Frederic Weisbecker wrote:
>> Hi,
>>
>> While talking with Tejun about targetting the cgroup task counter subsystem
>> for the next merge window, he suggested to check if this could be merged into
>> the memcg subsystem rather than creating a new one cgroup subsystem just
>> for task count limit purpose.
>>
>> So I'm pinging you guys to seek your insight.
> 
> I'm sorry you are given a runaround like this with that code.
> 


I don't like the idea of putting this stuff into memcg either.

>> I assume not everybody in the Cc list knows what the task counter subsystem
>> is all about. So here is a summary: this is a cgroup subsystem (latest version
>> in https://lwn.net/Articles/478631/) that keeps track of the number of tasks
>> present in a cgroup. Hooks are set in task fork/exit and cgroup migration to
>> maintain this accounting visible to a special tasks.usage file. The user can
>> set a limit on the number of tasks by writing on the tasks.limit file.
>> Further forks or cgroup migration are then rejected if the limit is exceeded.
>>
>> This feature is especially useful to protect against forkbombs in containers.
>> Or more generally to limit the resources on the number of tasks on a cgroup
>> as it involves some kernel memory allocation.
> 
> You could also twist this around and argue the same for cpu usage and
> make it part of the cpu cgroup, but it doesn't really fit in either
> subsystem, IMO.
> 
>> Now the dilemna is how to implement it?
>>
>> 1) As a standalone subsystem, as it stands currently (https://lwn.net/Articles/478631/)
> 
> What was wrong with that again?
> 
>> 2) As a feature in memcg, part of the memory.kmem.* files. This makes sense
>> because this is about kernel memory allocation limitation. We could have a
>> memory.kmem.tasks.count
>>
>> My personal opinion is that the task counter brings some overhead: a charge
>> across the whole hierarchy at every fork, and the mirrored uncharge on task exit.
>> And this overhead happens even in the off-case (when the task counter susbsystem
>> is mounted but the limit is the default: ULLONG_MAX).
> 
> 3) Make it an integral part of cgroups, because keeping track of tasks
> in them already is, so it would be a more natural approach than
> bolting it onto the memory controller.
> 

> But this has the same overhead.

This makes the most sense to me. Task counting and limiting sounds part of
cgroups in nature.

It has overhead, but what makes it worse than that in the single hierarchy
that we are aiming at?

> And even if this would end up being a

> better idea, we could still do this after merging it as a separate
> controller as long as we maintain the interface.
> 


That would add some tricky messy code, so better no.
