Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab2IQIyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:54:18 -0400
Received: from mx2.parallels.com ([64.131.90.16]:47931 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782Ab2IQIyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:54:16 -0400
Message-ID: <5056E467.2090108@parallels.com>
Date: Mon, 17 Sep 2012 12:50:47 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>,
        Michal Hocko <mhocko@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Graf <tgraf@suug.ch>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: [RFC] cgroup TODOs
References: <20120913205827.GO7677@google.com> <5052E7DF.7040000@parallels.com> <20120914174329.GD17747@google.com>
In-Reply-To: <20120914174329.GD17747@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 09:43 PM, Tejun Heo wrote:
> Hello, Glauber.
> 
> On Fri, Sep 14, 2012 at 12:16:31PM +0400, Glauber Costa wrote:
>> Can we please keep some key userspace guys CCd?
> 
> Yeap, thanks for adding the ccs.
> 
>>> 1. cpu and cpuacct
> ...
>>>   Me, working on it.
>> I can work on it as well if you want. I dealt with it many times in
>> the past, and tried some different approaches, so I am familiar. But
>> if you're already doing it, be my guest...
> 
> I'm trying something minimal which can serve as basis for the actual
> work.  I think I figured it out mostly and will probably post it later
> today.  Will squeak if I get stuck.
> 
>>>   I'll do the cgroup_freezer.  I'm hoping PeterZ or someone who's
>>>   familiar with the code base takes care of cpuset.  Michal, can you
>>>   please take care of memcg?
>>
>> I think this is a pressing problem, yes, but not the only problem with
>> cgroup lock. Even if we restrict its usage to cgroup core, we still can
>> call cgroup functions, which will lock. And then we gain nothing.
> 
> Can you be a bit more specific?
> 
What I mean is that if some operation needs to operate locked, they will
have to lock. Whether or not the locking is called from cgroup core or
not. If the lock is not available outside, people will end up calling a
core function that locks.


>> And the problem is that people need to lock. cgroup_lock is needed
>> because the data you are accessing is protected by it. The way I see it,
>> it is incredible how we were able to revive the BKL in the form of
>> cgroup_lock after we finally manage to successfully get rid of it!
> 
> I wouldn't go as far as comparing it to BKL.
> 
Of course not, since it is not system-wide. But I think the comparison
still holds in spirit...

>> Do you realize this is the exact same thing I proposed in our last
>> round, and you keep screaming saying you wanted something else, right?
>>
>> The only difference is that the discussion at the time started by a
>> forced-comount patch, but that is not the core of the question. For that
>> you are proposing to make sense, the controllers need to be comounted,
>> and at some point we'll have to enforce it. Be it now or in the future.
>> But what to do when they are in fact comounted, I see no difference from
>> what you are saying, and what I said.
> 
> Maybe I misunderstood you or from still talking about forced co-mounts
> more likely you're still misunderstanding.  From what you told PeterZ,
> it seemed like you were thinking that this somehow will get rid of
> differing hierarchies depending on specific controllers and thus will
> help, for example, the optimization issues between cpu and cpuacct.
> Going back to the above example,
> 
>  Unified tree           Controller Y's view
>  controller X's view
> 
>       R                          R
>      / \                        / \
>     A   B                      A   B
>    / \
>   AA AB
> 
> If a task assigned to or resourced tagged with AA, for controller X
> it'll map to AA and for controller Y to A, so we would still need
> css_set, which actually becomes the primary resource tag and may point
> to different subsystem states depending on the specific controller.
> 
> If that is the direction we're headed, forcing co-mounts at this point
> doesn't make any sense.  We'll make things which are possible today
> impossible for quite a while and then restore part of it, which is a
> terrible transition plan.  What we need to do is nudging the current
> users away from practices which hinder implementation of the final
> form and then transition to it gradually.
> 
> If you still don't understand, I don't know what more I can do to
> help.
>

you seem to hear "comount", and think of unified vision, and that is the
reason for this discussion to still be going on. Mounting is all about
the root. And if you comount, hierarchies have the same root.

In your example, the different controllers are comounted. They have not
the same view, but the possible views are restricted to be a subset of
the underlying tree - because they are mounted in the same place, forced
or not.

In a situation like this, it makes all the sense in the world to use the
css_id as a primary identifier, because it will be guaranteed to be the
same. What makes the tree overly flexible, is that you can have multiple
roots, starting in multiple places, with arbitrary topologies downwards.

If you still don't understand, I don't know what more I can do to help.


