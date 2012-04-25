Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab2DYOpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 10:45:20 -0400
Received: from mx2.parallels.com ([64.131.90.16]:46980 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab2DYOpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 10:45:18 -0400
Message-ID: <4F980D90.8050109@parallels.com>
Date: Wed, 25 Apr 2012 11:43:28 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 17/23] kmem controller charge/uncharge infrastructure
References: <1334959051-18203-1-git-send-email-glommer@parallels.com> <1335138820-26590-6-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1204231522320.13535@chino.kir.corp.google.com> <20120424142232.GC8626@somewhere> <4F96BB62.1030900@parallels.com> <alpine.DEB.2.00.1204241322390.753@chino.kir.corp.google.com> <4F971CC2.3090109@parallels.com> <alpine.DEB.2.00.1204241550110.2537@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1204241550110.2537@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.19.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 07:54 PM, David Rientjes wrote:
> On Tue, 24 Apr 2012, Glauber Costa wrote:
>
>>> Yes, for user memory, I see charging to p->mm->owner as allowing that
>>> process to eventually move and be charged to a different memcg and there's
>>> no way to do proper accounting if the charge is split amongst different
>>> memcgs because of thread membership to a set of memcgs.  This is
>>> consistent with charges for shared memory being moved when a thread
>>> mapping it moves to a new memcg, as well.
>>
>> But that's the problem.
>>
>> When we are dealing with kernel memory, we are allocating a whole slab page.
>> It is essentially impossible to track, given a page, which task allocated
>> which object.
>>
>
> Right, so you have to make the distinction that slab charges cannot be
> migrated by memory.move_charge_at_immigrate (and it's not even specified
> to do anything beyond user pages in Documentation/cgroups/memory.txt),

Never intended to.

> but
> it would be consistent to charge the same memcg for a process's slab
> allocations as the process's user allocations.
>
> My response was why we shouldn't be charging user pages to
> mem_cgroup_from_task(current) rather than
> mem_cgroup_from_task(current->mm->owner) which is what is currently
> implemented.

Ah, all right. Well, for user memory I agree with you. My point was 
exactly that user memory can always be pinpointed to a specific address 
space, while kernel memory can't.

>
> If that can't be changed so that we can still migrate user memory amongst
> memcgs for memory.move_charge_at_immigrate, then it seems consistent to
> have all allocations done by a task to be charged to the same memcg.
> Hence, I suggested current->mm->owner for slab charging as well.

All right. This can be done. Although I don't see this as a must for 
slab as already explained, I certainly don't oppose doing so as well.
