Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab1H3BUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 21:20:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52918 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1H3BUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 21:20:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 30 Aug 2011 10:12:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Brestic <abrestic@google.com>, Ying Han <yinghan@google.com>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] Revert "memcg: add memory.vmscan_stat"
Message-Id: <20110830101233.ae416284.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110829155113.GA21661@redhat.com>
References: <20110722171540.74eb9aa7.kamezawa.hiroyu@jp.fujitsu.com>
	<20110808124333.GA31739@redhat.com>
	<20110809083345.46cbc8de.kamezawa.hiroyu@jp.fujitsu.com>
	<20110829155113.GA21661@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011 17:51:13 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> On Tue, Aug 09, 2011 at 08:33:45AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Mon, 8 Aug 2011 14:43:33 +0200
> > Johannes Weiner <jweiner@redhat.com> wrote:
> > 
> > > On Fri, Jul 22, 2011 at 05:15:40PM +0900, KAMEZAWA Hiroyuki wrote:
> > > > +When under_hierarchy is added in the tail, the number indicates the
> > > > +total memcg scan of its children and itself.
> > > 
> > > In your implementation, statistics are only accounted to the memcg
> > > triggering the limit and the respectively scanned memcgs.
> > > 
> > > Consider the following setup:
> > > 
> > >         A
> > >        / \
> > >       B   C
> > >      /
> > >     D
> > > 
> > > If D tries to charge but hits the limit of A, then B's hierarchy
> > > counters do not reflect the reclaim activity resulting in D.
> > > 
> > yes, as I expected.
> 
> Andrew,
> 
> with a flawed design, the author unwilling to fix it, and two NAKs,
> can we please revert this before the release?
> 

How about this ?
==
Now, vmscan_stat's hierarchy counter just counts scan data which
is caused by the owner of limits. Then, it's not 'hierarchical'
as other parts of memcg does.

For example, Assuming following hierarchy

	A
       /
      B
     /
    C

When B,C, is scanned because of A's limit, vmscan_stat's
hierarchy accounting does
   A's hierarchy scan = A'scan + B'scan + C'scan
   B's hierarchy scan = 0
   C's hierarchy scan = 0
This first design was because the author considered C's
scan is caused by A. But considering interface compatibility,
following is natural.

  A's hierarchy scan = A'scan + B'scan + C'scan
  B's hierarchy scan = B'scan + C'scan
  C's hierarchy scan = C'scan

This patch changes counting implementation.

Suggested-by: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

Index: mmotm-Aug29/mm/memcontrol.c
===================================================================
--- mmotm-Aug29.orig/mm/memcontrol.c
+++ mmotm-Aug29/mm/memcontrol.c
@@ -229,7 +229,7 @@ enum {
 struct scanstat {
 	spinlock_t	lock;
 	unsigned long	stats[NR_SCAN_CONTEXT][NR_SCANSTATS];
-	unsigned long	rootstats[NR_SCAN_CONTEXT][NR_SCANSTATS];
+	unsigned long	hierarchy_stats[NR_SCAN_CONTEXT][NR_SCANSTATS];
 };
 
 const char *scanstat_string[NR_SCANSTATS] = {
@@ -1701,6 +1701,7 @@ static void __mem_cgroup_record_scanstat
 static void mem_cgroup_record_scanstat(struct memcg_scanrecord *rec)
 {
 	struct mem_cgroup *memcg;
+	struct cgroup *cgroup;
 	int context = rec->context;
 
 	if (context >= NR_SCAN_CONTEXT)
@@ -1710,11 +1711,18 @@ static void mem_cgroup_record_scanstat(s
 	spin_lock(&memcg->scanstat.lock);
 	__mem_cgroup_record_scanstat(memcg->scanstat.stats[context], rec);
 	spin_unlock(&memcg->scanstat.lock);
-
-	memcg = rec->root;
-	spin_lock(&memcg->scanstat.lock);
-	__mem_cgroup_record_scanstat(memcg->scanstat.rootstats[context], rec);
-	spin_unlock(&memcg->scanstat.lock);
+	cgroup = memcg->css.cgroup;
+	do {
+		spin_lock(&memcg->scanstat.lock);
+		__mem_cgroup_record_scanstat(
+			memcg->scanstat.hierarchy_stats[context], rec);
+		spin_unlock(&memcg->scanstat.lock);
+		if (!cgroup->parent)
+			break;
+		cgroup = cgroup->parent;
+		memcg = mem_cgroup_from_cont(cgroup);
+	} while (memcg->use_hierarchy && memcg != rec->root);
+	return;
 }
 
 /*
@@ -4733,14 +4741,14 @@ static int mem_cgroup_vmscan_stat_read(s
 		strcat(string, SCANSTAT_WORD_LIMIT);
 		strcat(string, SCANSTAT_WORD_HIERARCHY);
 		cb->fill(cb,
-			string, memcg->scanstat.rootstats[SCAN_BY_LIMIT][i]);
+		    string, memcg->scanstat.hierarchy_stats[SCAN_BY_LIMIT][i]);
 	}
 	for (i = 0; i < NR_SCANSTATS; i++) {
 		strcpy(string, scanstat_string[i]);
 		strcat(string, SCANSTAT_WORD_SYSTEM);
 		strcat(string, SCANSTAT_WORD_HIERARCHY);
 		cb->fill(cb,
-			string, memcg->scanstat.rootstats[SCAN_BY_SYSTEM][i]);
+		    string, memcg->scanstat.hierarchy_stats[SCAN_BY_SYSTEM][i]);
 	}
 	return 0;
 }
@@ -4752,8 +4760,8 @@ static int mem_cgroup_reset_vmscan_stat(
 
 	spin_lock(&memcg->scanstat.lock);
 	memset(&memcg->scanstat.stats, 0, sizeof(memcg->scanstat.stats));
-	memset(&memcg->scanstat.rootstats,
-		0, sizeof(memcg->scanstat.rootstats));
+	memset(&memcg->scanstat.hierarchy_stats,
+		0, sizeof(memcg->scanstat.hierarchy_stats));
 	spin_unlock(&memcg->scanstat.lock);
 	return 0;
 }






