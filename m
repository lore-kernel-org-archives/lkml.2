Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215Ab2EKTNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:13:08 -0400
Received: from mx2.parallels.com ([64.131.90.16]:41274 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215Ab2EKTNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:13:06 -0400
Message-ID: <4FAD6449.2060201@parallels.com>
Date: Fri, 11 May 2012 16:11:05 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <devel@openvz.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 04/29] slub: always get the cache from its page in
 kfree
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-5-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205111251420.31049@router.home> <4FAD531D.6030007@parallels.com> <alpine.DEB.2.00.1205111305570.386@router.home> <4FAD566C.3000804@parallels.com> <alpine.DEB.2.00.1205111316540.386@router.home> <4FAD585A.4070007@parallels.com> <alpine.DEB.2.00.1205111331010.386@router.home> <4FAD5DA2.70803@parallels.com> <alpine.DEB.2.00.1205111354540.386@router.home> <4FAD6169.8090409@parallels.com> <alpine.DEB.2.00.1205111407280.386@router.home>
In-Reply-To: <alpine.DEB.2.00.1205111407280.386@router.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.105.248.83]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 04:09 PM, Christoph Lameter wrote:
> On Fri, 11 May 2012, Glauber Costa wrote:
>
>> On 05/11/2012 03:56 PM, Christoph Lameter wrote:
>>> On Fri, 11 May 2012, Glauber Costa wrote:
>>>
>>>> So we don't mix pages from multiple memcgs in the same cache - we believe
>>>> that
>>>> would be too confusing.
>>>
>>> Well subsystem create caches and other things that are shared between
>>> multiple processes. How can you track that?
>>
>> Each process that belongs to a memcg triggers the creation of a new child kmem
>> cache.
>
> I see that. But there are other subsystems from slab allocators that do
> the same. There are also objects that may be used by multiple processes.

This is also true for normal user pages. And then, we do what memcg 
does: first one to touch, gets accounted. I don't think deviating from 
the memcg behavior for user pages makes much sense here.

A cache won't go away while it still have objects, even after the memcg 
is removed (it is marked as dead)

> F.e what about shm?
>
>>>> /proc/slabinfo reflects this information, by listing the memcg-specific
>>>> slabs.
>>>
>>> What about /sys/kernel/slab/*?
>>
>>  From the PoV of the global system, what you'll see is something like:
>> dentry , dentry(2:memcg1), dentry(2:memcg2), etc.
>
> Hmmm.. Would be better to have a hierachy there. /proc/slabinfo is more
> legacy.

I can take a look at that then. Assuming you agree with all the rest, is 
looking into that a pre-requisite for merging, or is something that can 
be deferred for a phase2 ? (We still don't do shrinkers, for instance, 
so this is sure to have a phase2)
