Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab1EMGz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 02:55:27 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:59690 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756590Ab1EMGzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 02:55:25 -0400
Date: Fri, 13 May 2011 08:54:59 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [rfc patch 3/6] mm: memcg-aware global reclaim
Message-ID: <20110513065459.GA18610@cmpxchg.org>
References: <1305212038-15445-1-git-send-email-hannes@cmpxchg.org>
 <1305212038-15445-4-git-send-email-hannes@cmpxchg.org>
 <20110513094050.6a01dad8.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513094050.6a01dad8.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 09:40:50AM +0900, KAMEZAWA Hiroyuki wrote:
> > @@ -1954,6 +1952,19 @@ restart:
> >  		goto restart;
> >  
> >  	throttle_vm_writeout(sc->gfp_mask);
> > +}
> > +
> > +static void shrink_zone(int priority, struct zone *zone,
> > +			struct scan_control *sc)
> > +{
> > +	struct mem_cgroup *root = sc->memcg;
> > +	struct mem_cgroup *mem = NULL;
> > +
> > +	do {
> > +		mem_cgroup_hierarchy_walk(root, &mem);
> > +		sc->current_memcg = mem;
> > +		do_shrink_zone(priority, zone, sc);
> 
> If I don't miss something, css_put() against mem->css will be required somewhere.

That's a bit of a hack.  mem_cgroup_hierarchy_walk() always does
css_put() on *mem before advancing to the next child.

At the last iteration, it returns mem == root.  Since the caller must
have a reference on root to begin with, it does not css_get() root.

So when mem == root, there are no outstanding references from the walk
anymore.

This only works since it always does the full hierarchy walk, so it's
going away anyway when the hierarchy walk becomes intermittent.
