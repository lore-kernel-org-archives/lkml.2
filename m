Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab1DANSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 09:18:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41251 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab1DANSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 09:18:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 0/3] Unmapped page cache control (v5)
Cc: kosaki.motohiro@jp.fujitsu.com, Balbir Singh <balbir@linux.vnet.ibm.com>,
        linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>
In-Reply-To: <alpine.DEB.2.00.1103311451530.28364@router.home>
References: <20110331144145.0ECA.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1103311451530.28364@router.home>
Message-Id: <20110401221921.A890.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Fri,  1 Apr 2011 22:17:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

Thanks, long explanation.


> On Thu, 31 Mar 2011, KOSAKI Motohiro wrote:
> 
> > 1) zone reclaim doesn't work if the system has multiple node and the
> >    workload is file cache oriented (eg file server, web server, mail server, et al).
> >    because zone recliam make some much free pages than zone->pages_min and
> >    then new page cache request consume nearest node memory and then it
> >    bring next zone reclaim. Then, memory utilization is reduced and
> >    unnecessary LRU discard is increased dramatically.
> 
> That is only true if the webserver only allocates from a single node. If
> the allocation load is balanced then it will be fine. It is useful to
> reclaim pages from the node where we allocate memory since that keeps the
> dataset node local.

Why?
Scheduler load balancing only consider cpu load. Then, usually memory
pressure is no complete symmetric. That's the reason why we got the
bug report periodically.


> >    SGI folks added CPUSET specific solution in past. (cpuset.memory_spread_page)
> >    But global recliam still have its issue. zone recliam is HPC workload specific
> >    feature and HPC folks has no motivation to don't use CPUSET.
> 
> The spreading can also be done via memory policies. But that is only
> required if the application has an unbalanced allocation behavior.

??
I didin't talking about memory isolation. CPUSETS has a backdoor of memory
isolation for file cache. But global allocation/reclaim doesn't.

memory policy is for application specific behavior customization. If all
of application required the same memory policy customization, it's bad and
unpractical. Application developer know application behavior but don't know
machine configuration and system administrator is opposite. then, for application
tuning feature can't alternative system's one.


> > 2) Before 2.6.27, VM has only one LRU and calc_reclaim_mapped() is used to
> >    decide to filter out mapped pages. It made a lot of problems for DB servers
> >    and large application servers. Because, if the system has a lot of mapped
> >    pages, 1) LRU was churned and then reclaim algorithm become lotree one. 2)
> >    reclaim latency become terribly slow and hangup detectors misdetect its
> >    state and start to force reboot. That was big problem of RHEL5 based banking
> >    system.
> >    So, sc->may_unmap should be killed in future. Don't increase uses.
> 
> Because a bank could not configure its system properly we need to get rid
> of may_unmap? Maybe raise min_unmapped_ratio instead and take care that
> either the allocation load is balanced or a round robin scheme is
> used by the app?

Hmm..
I and you seems to talk different topic. I didn't talk about zone reclaim here. 
I did explain why filter based selective page reclaim may cause disaster. And
you seems to talk about zone_reclaim() customization tips.

Firstly, If we don't think this patch and if we are using zone_reclaim,
raising min_unmapped_ratio is a option. I agree. search is alywas problematic 
beucase it's no scale. But we have some workarounds and we used them so.

Secondly, If we think this patch, "by the app" is no option. We can't
hold any specific assumption of workloads on VM guest in general.


> > And, this patch introduce new allocator fast path overhead. I haven't seen
> > any justification for it.
> 
> We could do the triggering differently.

ok.
and, I'd like to put supplimental explanation. If the feature is widely used one,
I don't put objection fastpath thing. It should be compared cost vs benefit fairly.
but If the feature is for only a few person, I strongly hope to avoid fastpath
overhead. number of people is one of most big considerable componet of a benefit.



> > In other words, you have to kill following three for getting ack 1) zone
> > reclaim oriented reclaim 2) filter based LRU scanning (eg sc->may_unmap)
> > 3) fastpath overhead. In other words, If you want a feature for vm guest,
> > Any hardcoded machine configration assumption and/or workload assumption
> > are wrong.
> 
> It would be good if you could come up with a new reclaim scheme that
> avoids the need for zone reclaim and still allows one to take advantage of
> memory distances. I agree that the current scheme sometimes requires
> tuning too many esoteric knobs to get useful behavior.

To be honest, I hope to sort out balbir and virtulization people requirements
at first. I feel his [patch 0/3] explanation and the implementaion are not
exactly match. I'm worry about it.

btw, when we are talking about memory distance aware reclaim, we have to
recognize traditional numa (ie external node interconnect) and on-chip
numa have different performance characteristics. on-chip remote node access
is not so slow, then elaborated nearest node allocation effort doesn't have
so much worth. especially, a workload use a lot of short lived object.
Current zone-reclaim don't have so much issue when using traditiona numa
because it's fit your original design and assumption and administrators of
such systems have good skill and don't hesitate to learn esoteric knobs.
But recent on-chip and cheap numa are used for much different people against
past. therefore new issues and claims were raised. 



> > But, I agree that now we have to concern slightly large VM change parhaps
> > (or parhaps not). Ok, it's good opportunity to fill out some thing.
> > Historically, Linux MM has "free memory are waste memory" policy, and It
> > worked completely fine. But now we have a few exceptions.
> >
> > 1) RT, embedded and finance systems. They really hope to avoid reclaim
> >    latency (ie avoid foreground reclaim completely) and they can accept
> >    to make slightly much free pages before memory shortage.
> 
> In general we need a mechanism to ensure we can avoid reclaim during
> critical sections of application. So some way to give some hints to the
> machine to free up lots of memory (/proc/sys/vm/dropcaches is far too
> drastic) may be useful.

Exactly.
I've heard multiple times this request from finance people. And I've also 
heared the same request from bullet train control software people recently.



