Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080Ab2IMOzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 10:55:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab2IMOzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 10:55:07 -0400
Date: Thu, 13 Sep 2012 10:53:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Li Zefan <lizf@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Block IO controller hierarchy suppport (Was: Re: [PATCH RFC
 cgroup/for-3.7] cgroup: mark subsystems with broken hierarchy support and
 whine if cgroups are nested for them)
Message-ID: <20120913145340.GI4396@redhat.com>
References: <20120910223125.GC7677@google.com>
 <20120911145106.GG12039@redhat.com>
 <20120911171601.GN7677@google.com>
 <20120911173524.GJ12039@redhat.com>
 <20120911175515.GP7677@google.com>
 <50505C39.1050600@parallels.com>
 <20120912170933.GO7677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912170933.GO7677@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 10:09:33AM -0700, Tejun Heo wrote:

[..]
> Yeah, it's mostly that cfq was already a hairy monster before blkcg
> was added to it and unfortunately we didn't make it any cleaner in the
> process and blkcg itself has a lot of other issues including being
> completely broken w.r.t. writeback writes.  In addition there are two
> sub-controllers - the cfq one and blk-throttle.  So, it's just that
> there are too many scary things to do and not enough man power or
> maybe interest.  I hope we could just declare cgroup isn't supported
> on block devices but that doesn't seem feasible at this point either.
> 
> I might / probably work on it and am hoping to coerce Vivek into it
> too.  If you wanna jump in, please be my guest.

Biggest problem with blkcg CFQ implementation is idling on cgroup. If
we don't idle on cgroup, then we don't get the service differentiaton
for most of the workloads and if we do idle then performance starts
to suck very soon (The moment few cgroups are created). And hierarchy
will just exacertbate this problem because then one will try to idle
at each group in hierarchy.

This problem is something similar to CFQ's idling on sequential queues
and iopriority. Because we never idled on random IO queue, ioprios never
worked on random IO queues. And same is true for buffered write queues.
Similary, if you don't idle on groups, then for most of the workloads,
service differentiation is not visible. Only the one which are highly
sequential on nature, one can see service differentiation.

That's one fundamental problem for which we need to have a good answer
before we try to do more work on blkcg. Because we can write as much
code but at the end of the day it might still not be useful because
of the above mentioned issue I faced.

And that's the reason I think blkcg is primarly useful when you create
number of cgroups very small and move offending/problem creating worklods
in that cgroup and keep all other running in root cgroup. That way you
get less idling due to less number of cgroups at the same time you have
provided more isolation from offending workloads.

So if anybody has ideas on how to address above issue, I am all ears.

Thanks
Vivek
