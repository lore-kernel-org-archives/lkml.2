Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab2GIHga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 03:36:30 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53714 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454Ab2GIHg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 03:36:28 -0400
Date: Mon, 9 Jul 2012 09:36:14 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 04/11] mm: memcg: push down PageSwapCache check into
 uncharge entry functions
Message-ID: <20120709073614.GB1779@cmpxchg.org>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
 <1341449103-1986-5-git-send-email-hannes@cmpxchg.org>
 <4FFA4504.4040408@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFA4504.4040408@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 11:42:12AM +0900, Kamezawa Hiroyuki wrote:
> (2012/07/05 9:44), Johannes Weiner wrote:
> > @@ -3278,10 +3283,11 @@ void mem_cgroup_end_migration(struct mem_cgroup *memcg,
> >   		unused = oldpage;
> >   	}
> >   	anon = PageAnon(used);
> > -	__mem_cgroup_uncharge_common(unused,
> > -		anon ? MEM_CGROUP_CHARGE_TYPE_ANON
> > -		     : MEM_CGROUP_CHARGE_TYPE_CACHE,
> > -		true);
> > +	if (!PageSwapCache(page))
> > +		__mem_cgroup_uncharge_common(unused,
> > +					     anon ? MEM_CGROUP_CHARGE_TYPE_ANON
> > +					     : MEM_CGROUP_CHARGE_TYPE_CACHE,
> > +					     true);
> 
> !PageSwapCache(unused) ?

Argh, right.

> But I think unused page's PG_swapcache is always dropped. So, the check is
> not necessary.

Oh, this is intentional: the check was in __mem_cgroup_uncharge_common
before, which means it applied to this entry point as well.  This is
supposed to be a mechanical change that does not change any logic.
The check is then removed in the next patch.

---
Subject: mm: memcg: push down PageSwapCache check into uncharge entry functions fix

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a3bf414..f4ff18a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3283,7 +3283,7 @@ void mem_cgroup_end_migration(struct mem_cgroup *memcg,
 		unused = oldpage;
 	}
 	anon = PageAnon(used);
-	if (!PageSwapCache(page))
+	if (!PageSwapCache(unused))
 		__mem_cgroup_uncharge_common(unused,
 					     anon ? MEM_CGROUP_CHARGE_TYPE_ANON
 					     : MEM_CGROUP_CHARGE_TYPE_CACHE,

