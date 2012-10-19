Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322Ab2JSUeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 16:34:09 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62710 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab2JSUeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 16:34:07 -0400
Date: Fri, 19 Oct 2012 13:34:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        devel@openvz.org, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v5 06/14] memcg: kmem controller infrastructure
In-Reply-To: <5081269B.5000603@parallels.com>
Message-ID: <alpine.DEB.2.00.1210191331400.17804@chino.kir.corp.google.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-7-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1210171515290.20712@chino.kir.corp.google.com> <507FCA90.8060307@parallels.com>
 <alpine.DEB.2.00.1210181454100.30894@chino.kir.corp.google.com> <5081269B.5000603@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012, Glauber Costa wrote:

> >>> What about gfp & __GFP_FS?
> >>>
> >>
> >> Do you intend to prevent or allow OOM under that flag? I personally
> >> think that anything that accepts to be OOM-killed should have GFP_WAIT
> >> set, so that ought to be enough.
> >>
> > 
> > The oom killer in the page allocator cannot trigger without __GFP_FS 
> > because direct reclaim has little chance of being very successful and 
> > thus we end up needlessly killing processes, and that tends to happen 
> > quite a bit if we dont check for it.  Seems like this would also happen 
> > with memcg if mem_cgroup_reclaim() has a large probability of failing?
> > 
> 
> I can indeed see tests for GFP_FS in some key locations in mm/ before
> calling the OOM Killer.
> 
> Should I test for GFP_IO as well?

It's not really necessary, if __GFP_IO isn't set then it wouldn't make 
sense for __GFP_FS to be set.

> If the idea is preventing OOM to
> trigger for allocations that can write their pages back, how would you
> feel about the following test:
> 
> may_oom = (gfp & GFP_KERNEL) && !(gfp & __GFP_NORETRY) ?
> 

I would simply copy the logic from the page allocator and only trigger oom 
for __GFP_FS and !__GFP_NORETRY.
