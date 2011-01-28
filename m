Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab1A1IMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 03:12:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56771 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab1A1IMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 03:12:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 28 Jan 2011 17:06:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [BUGFIX][PATCH 1/4] memcg: fix limit estimation at reclaim for
 hugepage
Message-Id: <20110128170610.9ecb2ffa.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110128075215.GA2213@cmpxchg.org>
References: <20110128122229.6a4c74a2.kamezawa.hiroyu@jp.fujitsu.com>
	<20110128122449.e4bb0e5f.kamezawa.hiroyu@jp.fujitsu.com>
	<20110128075215.GA2213@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jan 2011 08:52:15 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:
 
> > @@ -1853,7 +1869,14 @@ static int __mem_cgroup_do_charge(struct
> >  	 * Check the limit again to see if the reclaim reduced the
> >  	 * current usage of the cgroup before giving up
> >  	 */
> > -	if (ret || mem_cgroup_check_under_limit(mem_over_limit))
> > +	if (mem_cgroup_check_margin(mem_over_limit) >= csize)
> > +		return CHARGE_RETRY;
> > +
> > +	/*
> > + 	 * If the charge size is a PAGE_SIZE, it's not hopeless while
> > + 	 * we can reclaim a page.
> > + 	 */
> > +	if (csize == PAGE_SIZE && ret)
> >  		return CHARGE_RETRY;
> 
> That makes sense.
> 
here.

It's okay to add your Signed-off because this one is very similar to yours.

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Current memory cgroup's code tends to assume page_size == PAGE_SIZE
and arrangement for THP is not enough yet.

This is one of fixes for supporing THP. This adds
mem_cgroup_get_margin() and checks whether there are required amount of
free resource after memory reclaim. By this, THP page allocation
can know whether it really succeeded or not and avoid infinite-loop
and hangup.

Total fixes for do_charge()/reclaim memory will follow this patch.

Changelog:
 - rename check_margin -> get_margin.
 - style fix.


Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/res_counter.h |   11 +++++++++++
 mm/memcontrol.c             |   22 +++++++++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletion(-)

Index: mmotm-0125/include/linux/res_counter.h
===================================================================
--- mmotm-0125.orig/include/linux/res_counter.h
+++ mmotm-0125/include/linux/res_counter.h
@@ -182,6 +182,17 @@ static inline bool res_counter_check_und
 	return ret;
 }
 
+static inline s64 res_counter_get_margin(struct res_counter *cnt)
+{
+	s64 ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cnt->lock, flags);
+	ret = cnt->limit - cnt->usage;
+	spin_unlock_irqrestore(&cnt->lock, flags);
+	return ret;
+}
+
 static inline bool res_counter_check_under_soft_limit(struct res_counter *cnt)
 {
 	bool ret;
Index: mmotm-0125/mm/memcontrol.c
===================================================================
--- mmotm-0125.orig/mm/memcontrol.c
+++ mmotm-0125/mm/memcontrol.c
@@ -1111,6 +1111,19 @@ static bool mem_cgroup_check_under_limit
 	return false;
 }
 
+static s64 mem_cgroup_get_margin(struct mem_cgroup *mem)
+{
+	s64 mem_margin = res_counter_get_margin(&mem->res);
+	s64 memsw_margin;
+
+	if (do_swap_account)
+		memsw_margin = res_counter_get_margin(&mem->memsw);
+	else
+		memsw_margin = RESOURCE_MAX;
+
+	return min(mem_margin, memsw_margin);
+}
+
 static unsigned int get_swappiness(struct mem_cgroup *memcg)
 {
 	struct cgroup *cgrp = memcg->css.cgroup;
@@ -1853,7 +1866,14 @@ static int __mem_cgroup_do_charge(struct
 	 * Check the limit again to see if the reclaim reduced the
 	 * current usage of the cgroup before giving up
 	 */
-	if (ret || mem_cgroup_check_under_limit(mem_over_limit))
+	if (mem_cgroup_get_margin(mem_over_limit) >= csize)
+		return CHARGE_RETRY;
+
+	/*
+	 * If the charge size is a PAGE_SIZE, it's not hopeless while
+	 * we can reclaim a page.
+	 */
+	if (csize == PAGE_SIZE && ret)
 		return CHARGE_RETRY;
 
 	/*

