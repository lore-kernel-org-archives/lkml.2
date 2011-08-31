Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab1HaMbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 08:31:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169Ab1HaMbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 08:31:33 -0400
Date: Wed, 31 Aug 2011 14:30:51 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] memcg: skip scanning active lists based on individual
 size
Message-ID: <20110831123051.GA18081@redhat.com>
References: <20110831090850.GA27345@redhat.com>
 <CAEwNFnBSg71QoLZbOqZbXK3fGEGneituU3PmiYTAw1VM3KcwcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEwNFnBSg71QoLZbOqZbXK3fGEGneituU3PmiYTAw1VM3KcwcQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 07:13:34PM +0900, Minchan Kim wrote:
> On Wed, Aug 31, 2011 at 6:08 PM, Johannes Weiner <jweiner@redhat.com> wrote:
> > Reclaim decides to skip scanning an active list when the corresponding
> > inactive list is above a certain size in comparison to leave the
> > assumed working set alone while there are still enough reclaim
> > candidates around.
> >
> > The memcg implementation of comparing those lists instead reports
> > whether the whole memcg is low on the requested type of inactive
> > pages, considering all nodes and zones.
> >
> > This can lead to an oversized active list not being scanned because of
> > the state of the other lists in the memcg, as well as an active list
> > being scanned while its corresponding inactive list has enough pages.
> >
> > Not only is this wrong, it's also a scalability hazard, because the
> > global memory state over all nodes and zones has to be gathered for
> > each memcg and zone scanned.
> >
> > Make these calculations purely based on the size of the two LRU lists
> > that are actually affected by the outcome of the decision.
> >
> > Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> > Cc: Rik van Riel <riel@redhat.com>
> > Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> > Cc: Balbir Singh <bsingharora@gmail.com>
> 
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Thank you.

> I can't understand why memcg is designed for considering all nodes and zones.
> Is it a mistake or on purpose?
> Maybe Kame or Balbir can answer it.
> 
> Anyway, this change does make sense to me.
> 
> Nitpick: Please remove inactive_ratio in Documentation/cgroups/memory.txt.
> I think it would be better to separate it into another patch.

Good catch.

---
Subject: [patch] memcg: skip scanning active lists based on individual fix

Also ditch the documentation note for the removed stats value.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
---

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 06eb6d9..cc0ebc5 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -418,7 +418,6 @@ total_unevictable	- sum of all children's "unevictable"
 
 # The following additional stats are dependent on CONFIG_DEBUG_VM.
 
-inactive_ratio		- VM internal parameter. (see mm/page_alloc.c)
 recent_rotated_anon	- VM internal parameter. (see mm/vmscan.c)
 recent_rotated_file	- VM internal parameter. (see mm/vmscan.c)
 recent_scanned_anon	- VM internal parameter. (see mm/vmscan.c)
