Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab2E3H4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:56:35 -0400
Received: from mx2.parallels.com ([64.131.90.16]:57980 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757063Ab2E3H4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:56:33 -0400
Message-ID: <4FC5D228.2070100@parallels.com>
Date: Wed, 30 May 2012 11:54:16 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Christoph Lameter <cl@linux.com>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Li Zefan <lizefan@huawei.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <devel@openvz.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 13/28] slub: create duplicate cache
References: <alpine.DEB.2.00.1205291101580.6723@router.home> <4FC501E9.60607@parallels.com> <alpine.DEB.2.00.1205291222360.8495@router.home> <4FC506E6.8030108@parallels.com> <alpine.DEB.2.00.1205291424130.8495@router.home> <4FC52612.5060006@parallels.com> <alpine.DEB.2.00.1205291454030.2504@router.home> <4FC52CC6.7020109@parallels.com> <alpine.DEB.2.00.1205291514090.2504@router.home> <4FC530C0.30509@parallels.com> <20120530012955.GA4854@google.com>
In-Reply-To: <20120530012955.GA4854@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.255.67.70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 05:29 AM, Tejun Heo wrote:
> The two goals for cgroup controllers that I think are important are
> proper (no, not crazy perfect but good enough) isolation and an
> implementation which doesn't impact !cg path in an intrusive manner -
> if someone who doesn't care about cgroup but knows and wants to work
> on the subsystem should be able to mostly ignore cgroup support.  If
> that means overhead for cgroup users, so be it.

Well, my code in the slab is totally wrapped in static branches. They 
only come active when the first group is *limited* (not even created: 
you can have a thousand memcg, if none of them are kmem limited, nothing 
will happen).

After that, the cost paid is to find out at which cgroup the process is 
at. I believe that if we had a faster way for this (like for instance: 
if we had a single hierarchy, the scheduler could put this in a percpu 
variable after context switch - or any other method), then the cost of 
it could be really low, even when this is enabled.

> Without looking at the actual code, my rainbow-farting unicorn here
> would be having a common slXb interface layer which handles
> interfacing with memory allocator users and cgroup and let slXb
> implement the same backend interface which doesn't care / know about
> cgroup at all (other than using the correct allocation context, that
> is).  Glauber, would something like that be possible?

It is a matter of degree. There *is* a lot of stuff in common code, and 
I tried to do it as much as I could. Christoph gave me a nice idea about 
hinting to the page allocator that this page is a slab page before the 
allocation, and then we could account from the page allocator directly - 
without touching the cache code at all. This could be done, but some 
stuff would still be there, basically because of differences in how the 
allocator behaves. I think long term Christoph's effort to produce 
common code among them will help a lot, if they stabilize their behavior 
in certain areas.

I will rework this series to try work more towards this goal, but at 
least for now I'll keep duplicating the caches. I still don't believe 
that a loose accounting to the extent Christoph proposed will achieve 
what we need this to achieve.

