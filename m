Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750953Ab2DLEA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 00:00:27 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29787 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab2DLEAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 00:00:24 -0400
Date: Thu, 12 Apr 2012 08:00:19 +0400
From: Alexander Nikiforov <a.nikiforov@samsung.com>
Subject: Re: [RFD] Merge task counter into memcg
In-reply-to: <20120411185715.GA4317@somewhere.redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Message-id: <4F865353.8080106@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329
 Thunderbird/11.0.1
References: <20120411185715.GA4317@somewhere.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 10:57 PM, Frederic Weisbecker wrote:
> Hi,
>
> While talking with Tejun about targetting the cgroup task counter subsystem
> for the next merge window, he suggested to check if this could be merged into
> the memcg subsystem rather than creating a new one cgroup subsystem just
> for task count limit purpose.
>
> So I'm pinging you guys to seek your insight.
>
> I assume not everybody in the Cc list knows what the task counter subsystem
> is all about. So here is a summary: this is a cgroup subsystem (latest version
> in https://lwn.net/Articles/478631/) that keeps track of the number of tasks
> present in a cgroup. Hooks are set in task fork/exit and cgroup migration to
> maintain this accounting visible to a special tasks.usage file. The user can
> set a limit on the number of tasks by writing on the tasks.limit file.
> Further forks or cgroup migration are then rejected if the limit is exceeded.
>
> This feature is especially useful to protect against forkbombs in containers.
> Or more generally to limit the resources on the number of tasks on a cgroup
> as it involves some kernel memory allocation.
>
> Now the dilemna is how to implement it?
>
> 1) As a standalone subsystem, as it stands currently (https://lwn.net/Articles/478631/)
>
> 2) As a feature in memcg, part of the memory.kmem.* files. This makes sense
> because this is about kernel memory allocation limitation. We could have a
> memory.kmem.tasks.count
>
> My personal opinion is that the task counter brings some overhead: a charge
> across the whole hierarchy at every fork, and the mirrored uncharge on task exit.
> And this overhead happens even in the off-case (when the task counter susbsystem
> is mounted but the limit is the default: ULLONG_MAX).
>
> So if we choose the second solution, this overhead will be added unconditionally
> to memcg.
> But I don't expect every users of memcg will need the task counter. So perhaps
> the overhead should be kept in its own separate subsystem.
>
> OTOH memory.kmem.* interface would have be a good fit.
>
> What do you think?
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hi,

I'm agree that this is memory related thing, but I prefer this as a 
separate subsystem.
Yes it has some impact on a system, but on the other hand we will have 
some very useful tool to track tasks state.
As I wrote before

http://comments.gmane.org/gmane.linux.kernel.cgroups/1448

it'll very useful to have event in the userspace about fork/exit about 
group of the processes.
