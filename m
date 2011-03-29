Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab1C2Ay3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 20:54:29 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40017 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab1C2Ay0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 20:54:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 29 Mar 2011 09:47:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ying Han <yinghan@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [RFC 0/3] Implementation of cgroup isolation
Message-Id: <20110329094756.49af153d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <BANLkTin4J5kiysPdQD2aTC52U4-dy04C1g@mail.gmail.com>
References: <20110328093957.089007035@suse.cz>
	<AANLkTi=CPMxOg3juDiD-_hnBsXKdZ+at+i9c1YYM=vv1@mail.gmail.com>
	<20110329091254.20c7cfcb.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTin4J5kiysPdQD2aTC52U4-dy04C1g@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011 17:37:02 -0700
Ying Han <yinghan@google.com> wrote:

> On Mon, Mar 28, 2011 at 5:12 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Mon, 28 Mar 2011 11:01:18 -0700
> > Ying Han <yinghan@google.com> wrote:
> >
> >> On Mon, Mar 28, 2011 at 2:39 AM, Michal Hocko <mhocko@suse.cz> wrote:
> >> > Hi all,
> >> >
> >> > Memory cgroups can be currently used to throttle memory usage of a group of
> >> > processes. It, however, cannot be used for an isolation of processes from
> >> > the rest of the system because all the pages that belong to the group are
> >> > also placed on the global LRU lists and so they are eligible for the global
> >> > memory reclaim.
> >> >
> >> > This patchset aims at providing an opt-in memory cgroup isolation. This
> >> > means that a cgroup can be configured to be isolated from the rest of the
> >> > system by means of cgroup virtual filesystem (/dev/memctl/group/memory.isolated).
> >>
> >> Thank you Hugh pointing me to the thread. We are working on similar
> >> problem in memcg currently
> >>
> >> Here is the problem we see:
> >> 1. In memcg, a page is both on per-memcg-per-zone lru and global-lru.
> >> 2. Global memory reclaim will throw page away regardless of cgroup.
> >> 3. The zone->lru_lock is shared between per-memcg-per-zone lru and global-lru.
> >>
> >> And we know:
> >> 1. We shouldn't do global reclaim since it breaks memory isolation.
> >> 2. There is no need for a page to be on both LRU list, especially
> >> after having per-memcg background reclaim.
> >>
> >> So our approach is to take off page from global lru after it is
> >> charged to a memcg. Only pages allocated at root cgroup remains in
> >> global LRU, and each memcg reclaims pages on its isolated LRU.
> >>
> >
> > Why you don't use cpuset and virtual nodes ? It's what you want.
> 
> We've been running cpuset + fakenuma nodes configuration in google to
> provide memory isolation. The configuration of having the virtual box
> is complex which user needs to know great details of the which node to
> assign to which cgroup. That is one of the motivations for us moving
> towards to memory controller which simply do memory accounting no
> matter where pages are allocated.
> 

I think current fake-numa is not useful because it works only at boot time.

> By saying that, memcg simplified the memory accounting per-cgroup but
> the memory isolation is broken. This is one of examples where pages
> are shared between global LRU and per-memcg LRU. It is easy to get
> cgroup-A's page evicted by adding memory pressure to cgroup-B.
> 
If you overcommit....Right ?


> The approach we are thinking to make the page->lru exclusive solve the
> problem. and also we should be able to break the zone->lru_lock
> sharing.
> 
Is zone->lru_lock is a problem even with the help of pagevecs ?

If LRU management guys acks you to isolate LRUs and to make kswapd etc..
more complex, okay, we'll go that way. This will _change_ the whole
memcg design and concepts Maybe memcg should have some kind of balloon driver to
work happy with isolated lru.

But my current standing position is "never bad effects global reclaim".
So, I'm not very happy with the solution.

If we go that way, I guess we'll think we should have pseudo nodes/zones, which
was proposed in early days of resource controls.(not cgroup).

Thanks,
-Kame








