Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab2INNXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:23:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab2INNXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:23:39 -0400
Date: Fri, 14 Sep 2012 09:22:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
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
Message-ID: <20120914132243.GA6221@redhat.com>
References: <20120911145106.GG12039@redhat.com>
 <20120911171601.GN7677@google.com>
 <20120911173524.GJ12039@redhat.com>
 <20120911175515.GP7677@google.com>
 <50505C39.1050600@parallels.com>
 <20120912170933.GO7677@google.com>
 <20120913145340.GI4396@redhat.com>
 <20120913220613.GP7677@google.com>
 <20120914025317.GB4333@redhat.com>
 <5052E8DA.1000106@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5052E8DA.1000106@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 12:20:42PM +0400, Glauber Costa wrote:
> On 09/14/2012 06:53 AM, Vivek Goyal wrote:
> > On Thu, Sep 13, 2012 at 03:06:13PM -0700, Tejun Heo wrote:
> >> Hey, Vivek.
> >>
> >> (cc'ing Rakesh and Chad who work on iosched in google).
> >>
> >> On Thu, Sep 13, 2012 at 10:53:41AM -0400, Vivek Goyal wrote:
> >>> Biggest problem with blkcg CFQ implementation is idling on cgroup. If
> >>> we don't idle on cgroup, then we don't get the service differentiaton
> >>> for most of the workloads and if we do idle then performance starts
> >>> to suck very soon (The moment few cgroups are created). And hierarchy
> >>> will just exacertbate this problem because then one will try to idle
> >>> at each group in hierarchy.
> >>>
> >>> This problem is something similar to CFQ's idling on sequential queues
> >>> and iopriority. Because we never idled on random IO queue, ioprios never
> >>> worked on random IO queues. And same is true for buffered write queues.
> >>> Similary, if you don't idle on groups, then for most of the workloads,
> >>> service differentiation is not visible. Only the one which are highly
> >>> sequential on nature, one can see service differentiation.
> >>>
> >>> That's one fundamental problem for which we need to have a good answer
> >>> before we try to do more work on blkcg. Because we can write as much
> >>> code but at the end of the day it might still not be useful because
> >>> of the above mentioned issue I faced.
> >>
> >> I talked with Rakesh about this as the modified cfq-iosched used in
> >> google supports proper hierarchy and the feature is heavily depended
> >> upon.  I was told that nesting doesn't really change anything.  The
> >> only thing which matters is the number of active cgroups and whether
> >> they're nested or how deep doesn't matter - IIUC there's no need to
> >> idle for internal nodes if they don't have IOs pending.
> >>
> >> He draw me some diagrams which made sense for me and the code
> >> apparently actually works, so there doesn't seem to be any fundamental
> >> issue in implementing hierarchy support in cfq.
> > 
> > Hmm...., They probably are right. Idling only on leaf groups can make
> > sure that none of the groups loses its fair share of quota. Thinking
> > loud...
> > 
> > 
> > 				root
> >                                 /  \
> >                                T1  G1
> >                                   /  \
> >                                  T2   G2
> >                                        \
> >                                         T3 
> > 
> > So if task T3 finishes and there is no active IO from T3, we will idle
> > on group G2 (in the hope that soon some IO will show up from T3 or from
> > some other task in G2). And that alone should make sure all the group
> > nodes in the path to root (G1) get their fair share at their respective
> > level and no additional idling should be needed.
> > 
> > So sounds like hierarhcy will not cause additional idling. Idling will
> > solely depend on leaf active groups. 
> > 
> 
> What if the G's also have tasks? That is a valid configuration, after all.

Are you saying what if groups have tasks?I think in above configuration I
have shown Task T2 in G1 and task T3 in G2. So groups do have tasks here.

So say at a given time, G2 is not on service tree (not doing any IO) and
T2 does IO, then we will end up doing idling on group G1. But that's the
idling we will anyway do even if we were in flat mode.


				     pivot
				    /  |  \
		      	          T1   G1  G2
				       |    |
				       T2   T3

So in above flat mode we will idle both on G1 and G2 (assuming T2 and T3)
are doing IO. When converted to hierarchy, I think total idling time
still remains same and hierarchy is not imposing addition idling. 

That's a different thing that I am not happy with amount of idling we
do even now as it kills performance.

Thanks
Vivek

