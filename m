Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab1CaKB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 06:01:59 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:56493 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab1CaKB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 06:01:58 -0400
Date: Thu, 31 Mar 2011 15:31:36 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/3] Implementation of cgroup isolation
Message-ID: <20110331100136.GO2879@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20110328093957.089007035@suse.cz>
 <20110328200332.17fb4b78.kamezawa.hiroyu@jp.fujitsu.com>
 <4D920066.7000609@gmail.com>
 <20110330081853.GC15394@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110330081853.GC15394@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michal Hocko <mhocko@suse.cz> [2011-03-30 10:18:53]:

> On Tue 29-03-11 21:23:10, Balbir Singh wrote:
> > On 03/28/11 16:33, KAMEZAWA Hiroyuki wrote:
> > > On Mon, 28 Mar 2011 11:39:57 +0200
> > > Michal Hocko <mhocko@suse.cz> wrote:
> [...]
> > > Isn't it the same result with the case where no cgroup is used ?
> > > What is the problem ?
> > > Why it's not a problem of configuration ?
> > > IIUC, you can put all logins to some cgroup by using cgroupd/libgcgroup.
> > > 
> > 
> > I agree with Kame, I am still at loss in terms of understand the use
> > case, I should probably see the rest of the patches
> 
> OK, it looks that I am really bad at explaining the usecase. Let's try
> it again then (hopefully in a better way).
> 
> Consider a service which serves requests based on the in-memory
> precomputed or preprocessed data. 
> Let's assume that getting data into memory is rather costly operation
> which considerably increases latency of the request processing. Memory
> access can be considered random from the system POV because we never
> know which requests will come from outside.
> This workflow will benefit from having the memory resident as long as
> and as much as possible because we have higher chances to be used more
> often and so the initial costs would pay off.
> Why is mlock not the right thing to do here? Well, if the memory would
> be locked and the working set would grow (again this depends on the
> incoming requests) then the application would have to unlock some
> portions of the memory or to risk OOM because it basically cannot
> overcommit.
> On the other hand, if the memory is not mlocked and there is a global
> memory pressure we can have some part of the costly memory swapped or
> paged out which will increase requests latencies. If the application is
> placed into an isolated cgroup, though, the global (or other cgroups)
> activity doesn't influence its cgroup thus the working set of the
> application.

I think one important aspect is what percentage of the memory needs to
be isolated/locked? If you expect really large parts, then we are in
trouble, unless we are aware of the exact requirements for memory and
know what else will run on the system.

> If we compare that to mlock we will benefit from per-group reclaim when
> we get over the limit (or soft limit). So we do not start evicting the
> memory unless somebody makes really pressure on the _application_.
> Cgroup limits would, of course, need to be selected carefully.
> 
> There might be other examples when simply kernel cannot know which
> memory is important for the process and the long unused memory is not
> the ideal choice.
>

There are other watermark based approaches that would work better,
given that memory management is already complicated by topology, zones
and we have non-reclaimable memory being used in the kernel on behalf
of applications. I am not ruling out a solution, just sharing ideas.
NOTE: In the longer run, we want to account for kernel usage and look
at potential reclaim of slab pages. 

-- 
	Three Cheers,
	Balbir
