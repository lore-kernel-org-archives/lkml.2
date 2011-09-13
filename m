Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab1IMLcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 07:32:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab1IMLc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 07:32:29 -0400
Date: Tue, 13 Sep 2011 13:03:01 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Ying Han <yinghan@google.com>,
        Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 04/11] mm: memcg: per-priority per-zone hierarchy scan
 generations
Message-ID: <20110913110301.GB18886@redhat.com>
References: <1315825048-3437-1-git-send-email-jweiner@redhat.com>
 <1315825048-3437-5-git-send-email-jweiner@redhat.com>
 <20110913192759.ff0da031.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110913192759.ff0da031.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 07:27:59PM +0900, KAMEZAWA Hiroyuki wrote:
> On Mon, 12 Sep 2011 12:57:21 +0200
> Johannes Weiner <jweiner@redhat.com> wrote:
> 
> > Memory cgroup limit reclaim currently picks one memory cgroup out of
> > the target hierarchy, remembers it as the last scanned child, and
> > reclaims all zones in it with decreasing priority levels.
> > 
> > The new hierarchy reclaim code will pick memory cgroups from the same
> > hierarchy concurrently from different zones and priority levels, it
> > becomes necessary that hierarchy roots not only remember the last
> > scanned child, but do so for each zone and priority level.
> > 
> > Furthermore, detecting full hierarchy round-trips reliably will become
> > crucial, so instead of counting on one iterator site seeing a certain
> > memory cgroup twice, use a generation counter that is increased every
> > time the child with the highest ID has been visited.
> > 
> > Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> 
> I cannot image how this works. could you illustrate more with easy example ?

Previously, we did

	mem = mem_cgroup_iter(root)
	  for each priority level:
	    for each zone in zonelist:

and this would reclaim memcg-1-zone-1, memcg-1-zone-2, memcg-1-zone-3
etc.

The new code does

	for each priority level
	  for each zone in zonelist
            mem = mem_cgroup_iter(root)

but with a single last_scanned_child per memcg, this would scan
memcg-1-zone-1, memcg-2-zone-2, memcg-3-zone-3 etc, which does not
make much sense.

Now imagine two reclaimers.  With the old code, the first reclaimer
would pick memcg-1 and scan all its zones, the second reclaimer would
pick memcg-2 and reclaim all its zones.  Without this patch, the first
reclaimer would pick memcg-1 and scan zone-1, the second reclaimer
would pick memcg-2 and scan zone-1, then the first reclaimer would
pick memcg-3 and scan zone-2.  If the reclaimers are concurrently
scanning at different priority levels, things are even worse because
one reclaimer may put much more force on the memcgs it gets from
mem_cgroup_iter() than the other reclaimer.  They must not share the
same iterator.

The generations are needed because the old algorithm did not rely too
much on detecting full round-trips.  After every reclaim cycle, it
checked the limit and broke out of the loop if enough was reclaimed,
no matter how many children were reclaimed from.  The new algorithm is
used for global reclaim, where the only exit condition of the
hierarchy reclaim is the full roundtrip, because equal pressure needs
to be applied to all zones.
