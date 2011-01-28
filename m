Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab1A1I1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 03:27:52 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36438 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab1A1I1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 03:27:51 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 28 Jan 2011 17:21:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [BUGFIX][PATCH 3/4] mecg: fix oom flag at THP charge
Message-Id: <20110128172146.940751a5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110128080213.GC2213@cmpxchg.org>
References: <20110128122229.6a4c74a2.kamezawa.hiroyu@jp.fujitsu.com>
	<20110128122729.1f1c613e.kamezawa.hiroyu@jp.fujitsu.com>
	<20110128080213.GC2213@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jan 2011 09:02:13 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Fri, Jan 28, 2011 at 12:27:29PM +0900, KAMEZAWA Hiroyuki wrote:
> > 
> > Thanks to Johanns and Daisuke for suggestion.
> > =
> > Hugepage allocation shouldn't trigger oom.
> > Allocation failure is not fatal.
> > 
> > Orignal-patch-by: Johannes Weiner <hannes@cmpxchg.org>
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  mm/memcontrol.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > Index: mmotm-0125/mm/memcontrol.c
> > ===================================================================
> > --- mmotm-0125.orig/mm/memcontrol.c
> > +++ mmotm-0125/mm/memcontrol.c
> > @@ -2369,11 +2369,14 @@ static int mem_cgroup_charge_common(stru
> >  	struct page_cgroup *pc;
> >  	int ret;
> >  	int page_size = PAGE_SIZE;
> > +	bool oom;
> >  
> >  	if (PageTransHuge(page)) {
> >  		page_size <<= compound_order(page);
> >  		VM_BUG_ON(!PageTransHuge(page));
> > -	}
> > +		oom = false;
> > +	} else
> > +		oom = true;
> 
> That needs a comment.  You can take the one from my patch if you like.
> 

How about this ?
==
Hugepage allocation shouldn't trigger oom.
Allocation failure is not fatal.

Changelog:
 - added comments.

Orignal-patch-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: mmotm-0125/mm/memcontrol.c
===================================================================
--- mmotm-0125.orig/mm/memcontrol.c
+++ mmotm-0125/mm/memcontrol.c
@@ -2366,11 +2366,18 @@ static int mem_cgroup_charge_common(stru
 	struct page_cgroup *pc;
 	int ret;
 	int page_size = PAGE_SIZE;
+	bool oom;
 
 	if (PageTransHuge(page)) {
 		page_size <<= compound_order(page);
 		VM_BUG_ON(!PageTransHuge(page));
-	}
+		/*
+		 * Hugepage allocation will retry in small pages even if
+		 * this allocation fails.
+		 */
+		oom = false;
+	} else
+		oom = true;
 
 	pc = lookup_page_cgroup(page);
 	/* can happen at boot */
@@ -2378,7 +2385,7 @@ static int mem_cgroup_charge_common(stru
 		return 0;
 	prefetchw(pc);
 
-	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, true, page_size);
+	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, oom, page_size);
 	if (ret || !mem)
 		return ret;
 

