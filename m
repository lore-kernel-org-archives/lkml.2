Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab2HOMxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 08:53:54 -0400
Received: from mx2.parallels.com ([64.131.90.16]:40924 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab2HOMxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 08:53:52 -0400
Message-ID: <502B9BD4.4070003@parallels.com>
Date: Wed, 15 Aug 2012 16:53:40 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH v2 04/11] kmem accounting basic infrastructure
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-5-git-send-email-glommer@parallels.com> <20120814162144.GC6905@dhcp22.suse.cz> <502B6D03.1080804@parallels.com> <20120815123931.GF23985@dhcp22.suse.cz>
In-Reply-To: <20120815123931.GF23985@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 04:39 PM, Michal Hocko wrote:
> On Wed 15-08-12 13:33:55, Glauber Costa wrote:
> [...]
>>> This can
>>> be quite confusing.  I am still not sure whether we should mix the two
>>> things together. If somebody wants to limit the kernel memory he has to
>>> touch the other limit anyway.  Do you have a strong reason to mix the
>>> user and kernel counters?
>>
>> This is funny, because the first opposition I found to this work was
>> "Why would anyone want to limit it separately?" =p
>>
>> It seems that a quite common use case is to have a container with a
>> unified view of "memory" that it can use the way he likes, be it with
>> kernel memory, or user memory. I believe those people would be happy to
>> just silently account kernel memory to user memory, or at the most have
>> a switch to enable it.
>>
>> What gets clear from this back and forth, is that there are people
>> interested in both use cases.
> 
> I am still not 100% sure myself. It is just clear that the reclaim would
> need some work in order to do accounting like this.
> 

Note: Besides what I've already said, right *now* in this series we are
accounting just stack. So reclaimable vs not-reclaimable doesn't even
get to play. It is used while the tasks are running, it gets freed after
the tasks exited.

I do agree we need to look to the whole picture, and reclaiming will be
hard to get right.

This is actually why we're addressing them separately: because they are
a hard problem on their own, and the current status of accounting
already solve real life problems for many, though not for all.

>>> My impression was that kernel allocation should simply fail while user
>>> allocations might reclaim as well. Why should we reclaim just because of
>>> the kernel allocation (which is unreclaimable from hard limit reclaim
>>> point of view)?
>>
>> That is not what the kernel does, in general. We assume that if he wants
>> that memory and we can serve it, we should. Also, not all kernel memory
>> is unreclaimable. We can shrink the slabs, for instance. Ying Han
>> claims she has patches for that already...
> 
> Are those patches somewhere around?
> 

Ying Han ?

> [...]
>>> This doesn't check for the hierachy so kmem_accounted might not be in 
>>> sync with it's parents. mem_cgroup_create (below) needs to copy
>>> kmem_accounted down from the parent and the above needs to check if this
>>> is a similar dance like mem_cgroup_oom_control_write.
>>>
>>
>> I don't see why we have to.
>>
>> I believe in a A/B/C hierarchy, C should be perfectly able to set a
>> different limit than its parents. Note that this is not a boolean.
> 
> Ohh, I wasn't clear enough. I am not against setting the _limit_ I just
> meant that the kmem_accounted should be consistent within the hierarchy.
> 

If a parent of yours is accounted, you get accounted as well. This is
not the state in this patch, but gets added later. Isn't this enough ?

