Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab1ELQEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 12:04:31 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:52282 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757426Ab1ELQEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 12:04:30 -0400
Date: Thu, 12 May 2011 18:03:49 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [rfc patch 2/6] vmscan: make distinction between memcg reclaim
 and LRU list selection
Message-ID: <20110512160349.GJ16531@cmpxchg.org>
References: <1305212038-15445-1-git-send-email-hannes@cmpxchg.org>
 <1305212038-15445-3-git-send-email-hannes@cmpxchg.org>
 <4DCBFDB9.10209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCBFDB9.10209@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 11:33:13AM -0400, Rik van Riel wrote:
> On 05/12/2011 10:53 AM, Johannes Weiner wrote:
> >The reclaim code has a single predicate for whether it currently
> >reclaims on behalf of a memory cgroup, as well as whether it is
> >reclaiming from the global LRU list or a memory cgroup LRU list.
> >
> >Up to now, both cases always coincide, but subsequent patches will
> >change things such that global reclaim will scan memory cgroup lists.
> >
> >This patch adds a new predicate that tells global reclaim from memory
> >cgroup reclaim, and then changes all callsites that are actually about
> >global reclaim heuristics rather than strict LRU list selection.
> >
> >Signed-off-by: Johannes Weiner<hannes@cmpxchg.org>
> >---
> >  mm/vmscan.c |   96 ++++++++++++++++++++++++++++++++++------------------------
> >  1 files changed, 56 insertions(+), 40 deletions(-)
> >
> >diff --git a/mm/vmscan.c b/mm/vmscan.c
> >index f6b435c..ceeb2a5 100644
> >--- a/mm/vmscan.c
> >+++ b/mm/vmscan.c
> >@@ -104,8 +104,12 @@ struct scan_control {
> >  	 */
> >  	reclaim_mode_t reclaim_mode;
> >
> >-	/* Which cgroup do we reclaim from */
> >-	struct mem_cgroup *mem_cgroup;
> >+	/*
> >+	 * The memory cgroup we reclaim on behalf of, and the one we
> >+	 * are currently reclaiming from.
> >+	 */
> >+	struct mem_cgroup *memcg;
> >+	struct mem_cgroup *current_memcg;
> 
> I can't say I'm fond of these names.  I had to read the
> rest of the patch to figure out that the old mem_cgroup
> got renamed to current_memcg.

To clarify: sc->memcg will be the memcg that hit the hard limit and is
the main target of this reclaim invocation.  current_memcg is the
iterator over the hierarchy below the target.

I realize this change in particular was placed a bit unfortunate in
terms of understanding in the series, I just wanted to keep out the
mem_cgroup to current_memcg renaming out of the next patch.  There is
probably a better way, I'll fix it up and improve the comment.

> Would it be better to call them my_memcg and reclaim_memcg?
> 
> Maybe somebody else has better suggestions...

Yes, suggestions welcome.  I'm not too fond of the naming, either.

> Other than the naming, no objection.

Thanks, Rik.

	Hannes
