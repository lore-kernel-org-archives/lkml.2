Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab2K3KA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:00:29 -0500
Received: from mx2.parallels.com ([64.131.90.16]:33395 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143Ab2K3KA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:00:27 -0500
Message-ID: <50B883B5.8020705@parallels.com>
Date: Fri, 30 Nov 2012 14:00:21 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, <lizefan@huawei.com>, <paul@paulmenage.org>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <peterz@infradead.org>, <bsingharora@gmail.com>, <hannes@cmpxchg.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET cgroup/for-3.8] cpuset: decouple cpuset locking from
 cgroup core
References: <1354138460-19286-1-git-send-email-tj@kernel.org> <50B8263C.7060908@jp.fujitsu.com> <50B875B4.2020507@parallels.com> <20121130092435.GD29317@dhcp22.suse.cz> <50B87F84.7040206@parallels.com> <20121130094959.GE29317@dhcp22.suse.cz>
In-Reply-To: <20121130094959.GE29317@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 01:49 PM, Michal Hocko wrote:
> On Fri 30-11-12 13:42:28, Glauber Costa wrote:
> [...]
>> Speaking of it: Tejun's tree still lacks the kmem bits. How hard would
>> it be for you to merge his branch into a temporary branch of your tree?
> 
> review-cpuset-locking is based on a post merge window merges so I cannot
> merge it as is. I could cherry-pick the series after it is settled. I
> have no idea how much conflicts this would bring, though.
> 
Ok.

I believe the task problem only exist for us for kmem. So I could come
up with a patchset that only deals with child cgroup creation, and
ignore attach for now. So long as we have a mechanism that will work for
it, and don't get lost and forget to patch it when the trees are merged.

Now, what I am actually seeing with cgroup creation, is that the
children will copy a lot of the values from the parent, like swappiness,
hierarchy, etc. Once the child copies it, we should no longer be able to
change those values in the parent: otherwise we'll get funny things like
parent.use_hierarchy = 1, child.use_hierarchy = 0.

One option is to take a global lock in memcg_alloc_css(), and keep it
locked until we did all the cgroup bookkeeping, and then unlock it in
css_online. But I am guessing Tejun won't like it very much.

What do you think about a children counter? If we are going to do things
similar to the attach_in_progress of cpuset, we might very well turn it
into a direct counter so we don't have to iterate at all.

The code would look like: (simplified example for use_hierarchy)

memcg_lock();
if (memcg->nr_children != 0)
    return -EINVAL;
else
    memcg->use_hierarchy = val
memcg_unlock()


