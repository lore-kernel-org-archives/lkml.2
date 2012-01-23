Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab2AWLUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 06:20:34 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:54960 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab2AWLUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 06:20:33 -0500
Date: Mon, 23 Jan 2012 12:20:22 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: vmscan: ensure reclaiming pages on the lru lists of
 zone
Message-ID: <20120123112022.GB1707@cmpxchg.org>
References: <CAJd=RBC8dCGgqXqP+yjW2+pVoSeFXwXfjx8DLHhMuY8goOadZw@mail.gmail.com>
 <CAJd=RBBqp3bMGwFc14BJ7+=KsfO0gLnrnXwbRdLDYOJDdvbptA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBBqp3bMGwFc14BJ7+=KsfO0gLnrnXwbRdLDYOJDdvbptA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 12:47:34AM +0800, Hillf Danton wrote:
> Hi all
> 
> For easy review, it is re-prepared based on 3.3-rc1.
> 
> Thanks
> Hillf
> 
> ===cut please===
> From: Hillf Danton <dhillf@gmail.com>
> Subject: [PATCH] mm: vmscan: ensure reclaiming pages on the lru lists of zone
> 
> While iterating over memory cgroup hierarchy, pages are reclaimed from each
> mem cgroup, and reclaim terminates after a full round-trip. It is possible
> that no pages on the lru lists of given zone are reclaimed, as termination
> is checked after the reclaiming function.
> 
> Mem cgroup iteration is rearranged a bit to make sure that pages are reclaimed
> from both mem cgroups and zone.

It's not only possible, it's guaranteed: with the memory controller
enabled, the global per-zone lru lists are empty.

Pages used to be linked on the global per-zone AND the memcg per-zone
lru lists.  Nowadays, they only sit on the memcg per-zone lists, which
is why global reclaim does a hierarchy walk.

The global per-zone lists are just an artifact for when the memory
controller is not available.  The plan is to make root_mem_cgroup
available at all times, even without the memory controller.

So I'm afraid your patch only adds a round of scanning a known-to-be
empty lruvec.  NAK.
