Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab2INJM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 05:12:59 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:39887 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab2INJM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 05:12:56 -0400
Message-ID: <5052F4FF.6070508@huawei.com>
Date: Fri, 14 Sep 2012 17:12:31 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: Tejun Heo <tj@kernel.org>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Graf <tgraf@suug.ch>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC] cgroup TODOs
References: <20120913205827.GO7677@google.com> <5052E7DF.7040000@parallels.com>
In-Reply-To: <5052E7DF.7040000@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> 2. memcg's __DEPRECATED_clear_css_refs
>>
>>   This is a remnant of another weird design decision of requiring
>>   synchronous draining of refcnts on cgroup removal and allowing
>>   subsystems to veto cgroup removal - what's the userspace supposed to
>>   do afterwards?  Note that this also hinders co-mounting different
>>   controllers.
>>
>>   The behavior could be useful for development and debugging but it
>>   unnecessarily interlocks userland visible behavior with in-kernel
>>   implementation details.  To me, it seems outright wrong (either
>>   implement proper severing semantics in the controller or do full
>>   refcnting) and disallows, for example, lazy drain of caching refs.
>>   Also, it complicates the removal path with try / commit / revert
>>   logic which has never been fully correct since the beginning.
>>
>>   Currently, the only left user is memcg.
>>
>>   Solution:
>>
>>   * Update memcg->pre_destroy() such that it never fails.
>>
>>   * Drop __DEPRECATED_clear_css_refs and all related logic.
>>     Convert pre_destroy() to return void.
>>
>>   Who:
>>
>>   KAMEZAWA, Michal, PLEASE.  I will make __DEPRECATED_clear_css_refs
>>   trigger WARN sooner or later.  Let's please get this settled.
>>
>> 3. cgroup_mutex usage outside cgroup core
>>
>>   This is another thing which is simply broken.  Given the way cgroup
>>   is structured and used, nesting cgroup_mutex inside any other
>>   commonly used lock simply doesn't work - it's held while invoking
>>   controller callbacks which then interact and synchronize with
>>   various core subsystems.
>>
>>   There are currently three external cgroup_mutex users - cpuset,
>>   memcontrol and cgroup_freezer.
>>
>>   Solution:
>>
>>   Well, we should just stop doing it - use a separate nested lock
>>   (which seems possible for cgroup_freezer) or track and mange task
>>   in/egress some other way.
>>
>>   Who:
>>
>>   I'll do the cgroup_freezer.  I'm hoping PeterZ or someone who's
>>   familiar with the code base takes care of cpuset.  Michal, can you
>>   please take care of memcg?
>>
> 
> I think this is a pressing problem, yes, but not the only problem with
> cgroup lock. Even if we restrict its usage to cgroup core, we still can
> call cgroup functions, which will lock. And then we gain nothing.
> 

Agreed. The biggest issue in cpuset is if hotplug makes a cpuset's cpulist
empty the tasks in it will be moved to an ancestor cgroup, which requires
holding cgroup lock. We have to either change cpuset's behavior or eliminate
the global lock.

> And the problem is that people need to lock. cgroup_lock is needed
> because the data you are accessing is protected by it. The way I see it,
> it is incredible how we were able to revive the BKL in the form of
> cgroup_lock after we finally manage to successfully get rid of it!
> 
> We should just start to do a more fine grained locking of data, instead
> of "stop the world, cgroup just started!". If we do that, the problem
> you are trying to address here will even cease to exist.
> 

