Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab2KAJKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 05:10:53 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:36632 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab2KAJKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 05:10:50 -0400
Message-ID: <50923C84.2060703@linux.vnet.ibm.com>
Date: Thu, 01 Nov 2012 17:10:28 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>, JoonSoo Kim <js1304@gmail.com>
Subject: Re: [PATCH] slab: annotate on-slab caches nodelist locks
References: <1351507779-26847-1-git-send-email-glommer@parallels.com> <50922087.6080300@linux.vnet.ibm.com> <5092A7DD.6070304@parallels.com>
In-Reply-To: <5092A7DD.6070304@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12110109-5816-0000-0000-000005284DEF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2012 12:48 AM, Glauber Costa wrote:
> On 11/01/2012 11:11 AM, Michael Wang wrote:
>> On 10/29/2012 06:49 PM, Glauber Costa wrote:
>>> We currently provide lockdep annotation for kmalloc caches, and also
>>> caches that have SLAB_DEBUG_OBJECTS enabled. The reason for this is that
>>> we can quite frequently nest in the l3->list_lock lock, which is not
>>> something trivial to avoid.
>>>
>>> My proposal with this patch, is to extend this to caches whose slab
>>> management object lives within the slab as well ("on_slab"). The need
>>> for this arose in the context of testing kmemcg-slab patches. With such
>>> patchset, we can have per-memcg kmalloc caches. So the same path that
>>> led to nesting between kmalloc caches will could then lead to in-memcg
>>> nesting. Because they are not annotated, lockdep will trigger.
>>
>> Hi, Glauber
>>
>> I'm trying to understand what's the issue we are trying to solve, but
>> looks like I need some help...
>>
> Understandably =)
> 
> This will not trigger in an upstream kernel, so in this sense, it is not
> an existing bug. It happens when the kmemcg-slab series is applied
> (https://lkml.org/lkml/2012/10/16/186) and (http://lwn.net/Articles/519877/)
> 
> Because this is a big series, I am for a while adopting the policy of
> sending out patches that are in principle independent of the series, to
> be reviewed on their own. But in some cases like this, some context may
> end up missing.
> 
> Now, of course I won't tell you to go read it all, so here is a summary:
> * We operate in a containerized environment, with each container inside
> a cgroup
> * in this context, it is necessary to account and limit the amount of
> kernel memory that can be tracked back to processes. This is akin of
> OpenVZ's beancounters (http://wiki.openvz.org/Proc/user_beancounters)
> * To do that, we create a version of each slab that a cgroup uses.
> Processes in that cgroup will allocate from that slab.
> 
> This means that we will have cgroup-specific versions of slabs like
> kmalloc-XX, dentry, inode, etc.
> 
>> So allow me to ask few questions:
>>
>> 1. what's scene will cause the fake dead lock?
> 
> This lockdep annotation exists because when freeing from kmalloc caches,
> it is possible to nest in the l3 list_lock. The particular one I hit was
> when we reach cache_flusharray with the l3 list_lock held, which seems
> to happen quite often.
> 
>> 2. what's the conflict caches?
> kmalloc-XX and kmalloc-memcg-y-XX
> 
>> 3. how does their lock operation nested?
>>
> 
> In the same way kmalloc-XX would nest with itself.

So this is a patch to fix the possible BUG if other patch applied?
I'm not sure but sounds like not the right process...add this one to
that patch set may be better :)

Regards,
Michael Wang

> 

