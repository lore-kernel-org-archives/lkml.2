Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab2INCyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 22:54:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab2INCyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 22:54:21 -0400
Date: Thu, 13 Sep 2012 22:53:17 -0400
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
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, rni@google.com,
        ctalbott@google.com
Subject: Re: Block IO controller hierarchy suppport (Was: Re: [PATCH RFC
 cgroup/for-3.7] cgroup: mark subsystems with broken hierarchy support and
 whine if cgroups are nested for them)
Message-ID: <20120914025317.GB4333@redhat.com>
References: <20120910223125.GC7677@google.com>
 <20120911145106.GG12039@redhat.com>
 <20120911171601.GN7677@google.com>
 <20120911173524.GJ12039@redhat.com>
 <20120911175515.GP7677@google.com>
 <50505C39.1050600@parallels.com>
 <20120912170933.GO7677@google.com>
 <20120913145340.GI4396@redhat.com>
 <20120913220613.GP7677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913220613.GP7677@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 03:06:13PM -0700, Tejun Heo wrote:
> Hey, Vivek.
> 
> (cc'ing Rakesh and Chad who work on iosched in google).
> 
> On Thu, Sep 13, 2012 at 10:53:41AM -0400, Vivek Goyal wrote:
> > Biggest problem with blkcg CFQ implementation is idling on cgroup. If
> > we don't idle on cgroup, then we don't get the service differentiaton
> > for most of the workloads and if we do idle then performance starts
> > to suck very soon (The moment few cgroups are created). And hierarchy
> > will just exacertbate this problem because then one will try to idle
> > at each group in hierarchy.
> > 
> > This problem is something similar to CFQ's idling on sequential queues
> > and iopriority. Because we never idled on random IO queue, ioprios never
> > worked on random IO queues. And same is true for buffered write queues.
> > Similary, if you don't idle on groups, then for most of the workloads,
> > service differentiation is not visible. Only the one which are highly
> > sequential on nature, one can see service differentiation.
> > 
> > That's one fundamental problem for which we need to have a good answer
> > before we try to do more work on blkcg. Because we can write as much
> > code but at the end of the day it might still not be useful because
> > of the above mentioned issue I faced.
> 
> I talked with Rakesh about this as the modified cfq-iosched used in
> google supports proper hierarchy and the feature is heavily depended
> upon.  I was told that nesting doesn't really change anything.  The
> only thing which matters is the number of active cgroups and whether
> they're nested or how deep doesn't matter - IIUC there's no need to
> idle for internal nodes if they don't have IOs pending.
> 
> He draw me some diagrams which made sense for me and the code
> apparently actually works, so there doesn't seem to be any fundamental
> issue in implementing hierarchy support in cfq.

Hmm...., They probably are right. Idling only on leaf groups can make
sure that none of the groups loses its fair share of quota. Thinking
loud...


				root
                                /  \
                               T1  G1
                                  /  \
                                 T2   G2
                                       \
                                        T3 

So if task T3 finishes and there is no active IO from T3, we will idle
on group G2 (in the hope that soon some IO will show up from T3 or from
some other task in G2). And that alone should make sure all the group
nodes in the path to root (G1) get their fair share at their respective
level and no additional idling should be needed.

So sounds like hierarhcy will not cause additional idling. Idling will
solely depend on leaf active groups. 

So how bad group/no-idle service tree idling is proving to be. In my
experience if we use it on anything other than single spindle sata disk,
performance hit will start showing up immediately.

Thanks
Vivek
