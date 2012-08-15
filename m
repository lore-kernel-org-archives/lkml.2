Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab2HOQjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:39:03 -0400
Received: from mail-ob0-f202.google.com ([209.85.214.202]:32933 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab2HOQjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:39:00 -0400
From: Greg Thelen <gthelen@google.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 06/11] memcg: kmem controller infrastructure
References: <1344517279-30646-1-git-send-email-glommer@parallels.com>
	<1344517279-30646-7-git-send-email-glommer@parallels.com>
	<50254475.4000201@jp.fujitsu.com> <5028BA9E.7000302@parallels.com>
	<xr93ipcl9u7x.fsf@gthelen.mtv.corp.google.com>
	<502B6956.5030508@parallels.com>
Date: Wed, 15 Aug 2012 09:38:57 -0700
In-Reply-To: <502B6956.5030508@parallels.com> (Glauber Costa's message of
	"Wed, 15 Aug 2012 13:18:14 +0400")
Message-ID: <xr93wr109kke.fsf@gthelen.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15 2012, Glauber Costa wrote:

> On 08/14/2012 10:58 PM, Greg Thelen wrote:
>> On Mon, Aug 13 2012, Glauber Costa wrote:
>> 
>>>>>> +	WARN_ON(mem_cgroup_is_root(memcg));
>>>>>> +	size = (1 << order) << PAGE_SHIFT;
>>>>>> +	memcg_uncharge_kmem(memcg, size);
>>>>>> +	mem_cgroup_put(memcg);
>>>> Why do we need ref-counting here ? kmem res_counter cannot work as
>>>> reference ?
>>> This is of course the pair of the mem_cgroup_get() you commented on
>>> earlier. If we need one, we need the other. If we don't need one, we
>>> don't need the other =)
>>>
>>> The guarantee we're trying to give here is that the memcg structure will
>>> stay around while there are dangling charges to kmem, that we decided
>>> not to move (remember: moving it for the stack is simple, for the slab
>>> is very complicated and ill-defined, and I believe it is better to treat
>>> all kmem equally here)
>> 
>> By keeping memcg structures hanging around until the last referring kmem
>> page is uncharged do such zombie memcg each consume a css_id and thus
>> put pressure on the 64k css_id space?  I imagine in pathological cases
>> this would prevent creation of new cgroups until these zombies are
>> dereferenced.
>
> Yes, but although this patch makes it more likely, it doesn't introduce
> that. If the tasks, for instance, grab a reference to the cgroup dentry
> in the filesystem (like their CWD, etc), they will also keep the cgroup
> around.

Fair point.  But this doesn't seems like a feature.  It's probably not
needed initially, but what do you think about creating a
memcg_kernel_context structure which is allocated when memcg is
allocated?  Kernel pages charged to a memcg would have
page_cgroup->mem_cgroup=memcg_kernel_context rather than memcg.  This
would allow the mem_cgroup and its css_id to be deleted when the cgroup
is unlinked from cgroupfs while allowing for the active kernel pages to
continue pointing to a valid memcg_kernel_context.  This would be a
reference counted structure much like you are doing with memcg.  When a
memcg is deleted the memcg_kernel_context would be linked into its
surviving parent memcg.  This would avoid needing to visit each kernel
page.

>> Is there any way to see how much kmem such zombie memcg are consuming?
>> I think we could find these with
>> for_each_mem_cgroup_tree(root_mem_cgroup).
>
> Yes, just need an interface for that. But I think it is something that
> can be addressed orthogonaly to this work, in a separate patch, not as
> some fundamental limitation.

Agreed.

>> Basically, I'm wanting to know where kernel memory has been
>> allocated.  For live memcg, an admin can cat
>> memory.kmem.usage_in_bytes.  But for zombie memcg, I'm not sure how
>> to get this info.  It looks like the root_mem_cgroup
>> memory.kmem.usage_in_bytes is not hierarchically charged.
>> 
>
> Not sure what you mean by not being hierarchically charged. It should
> be, when use_hierarchy = 1. As a matter of fact, I just tested it, and I
> do see kmem being charged all the way to the root cgroup when hierarchy
> is used. (we just can't limit it there)

You're correct, my mistake.

I think the procedure to determine out the amount of zombie kmem is:
  root_mem_cgroup.kmem_usage_in_bytes - 
    sum(all top level memcg memory.kmem_usage_in_bytes)
