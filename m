Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab1DLBAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 21:00:03 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42890 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab1DLBAB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 21:00:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH resend^2] mm: increase RECLAIM_DISTANCE to 30
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110411141950.46d3d6da.akpm@linux-foundation.org>
References: <20110411172004.0361.A69D9226@jp.fujitsu.com> <20110411141950.46d3d6da.akpm@linux-foundation.org>
Message-Id: <20110412095958.43F0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 12 Apr 2011 09:59:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 11 Apr 2011 17:19:31 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > Recently, Robert Mueller reported zone_reclaim_mode doesn't work
> 
> It's time for some nagging.  
> 
> I'm trying to work out what the user-visible effect of this problem
> was, but it isn't described in the changelog and there is no link to
> any report and not even a Reported-by: or a Cc: and a search for Robert
> in linux-mm and linux-kernel turned up blank.

Here.
	http://lkml.org/lkml/2010/9/12/236


> 
> > properly on his new NUMA server (Dual Xeon E5520 + Intel S5520UR MB).
> > He is using Cyrus IMAPd and it's built on a very traditional
> > single-process model.
> > 
> >   * a master process which reads config files and manages the other
> >     process
> >   * multiple imapd processes, one per connection
> >   * multiple pop3d processes, one per connection
> >   * multiple lmtpd processes, one per connection
> >   * periodical "cleanup" processes.
> > 
> > Then, there are thousands of independent processes. The problem is,
> > recent Intel motherboard turn on zone_reclaim_mode by default and
> > traditional prefork model software don't work fine on it.
> > Unfortunatelly, Such model is still typical one even though 21th
> > century. We can't ignore them.
> > 
> > This patch raise zone_reclaim_mode threshold to 30. 30 don't have
> > specific meaning. but 20 mean one-hop QPI/Hypertransport and such
> > relatively cheap 2-4 socket machine are often used for tradiotional
> > server as above. The intention is, their machine don't use
> > zone_reclaim_mode.
> > 
> > Note: ia64 and Power have arch specific RECLAIM_DISTANCE definition.
> > then this patch doesn't change such high-end NUMA machine behavior.
> > 
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Acked-by: Christoph Lameter <cl@linux.com>
> > Acked-by: David Rientjes <rientjes@google.com>
> > Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  include/linux/topology.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/topology.h b/include/linux/topology.h
> > index b91a40e..fc839bf 100644
> > --- a/include/linux/topology.h
> > +++ b/include/linux/topology.h
> > @@ -60,7 +60,7 @@ int arch_update_cpu_topology(void);
> >   * (in whatever arch specific measurement units returned by node_distance())
> >   * then switch on zone reclaim on boot.
> >   */
> > -#define RECLAIM_DISTANCE 20
> > +#define RECLAIM_DISTANCE 30
> 
> Any time we tweak a magic number to improve one platform, we risk
> causing deterioration on another.  Do we know that this risk is low
> with this patch?

In last thread, Robert Mueller who bug reporter explained he is only using
mere commodity whitebox hardware and very common workload.
Therefore, we agreed benefit is bigger than negative. IOW, mere whitebox
are used lots than special purpose one.



> Also, what are we doing setting
> 
> 	zone_relaim_mode = 1;
> 
> when we have nice enumerated constants for this?  It should be
> 
> 	zone_relaim_mode = RECLAIM_ZONE;
> 
> or, pedantically but clearer:
> 
> 	zone_relaim_mode = RECLAIM_ZONE & !RECLAIM_WRITE & !RECLAIM_SWAP;

Indeed.



>From 0298eb3256bd17eb88584a90917be749bd8d2c98 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Tue, 12 Apr 2011 09:40:38 +0900
Subject: [PATCH 2/2] mm: Don't use hardcoded constant for zone_reclaim_mode

Initially, zone_reclaim_mode was introduced by commit 9eeff2395e3
(Zone reclaim: Reclaim logic). At that time, it was 0/1 boolean
variable.

Next, commit 1b2ffb7896 (Zone reclaim: Allow modification of zone reclaim
behavior) changed it to bitmask. But, page_alloc.c still use it as
boolean. It is slightly harder to read.

Let's convert it.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/swap.h |    5 +++++
 mm/page_alloc.c      |    2 +-
 mm/vmscan.c          |    5 -----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 384eb5f..078ba25 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -266,6 +266,11 @@ extern int remove_mapping(struct address_space *mapping, struct page *page);
 extern long vm_total_pages;
 
 #ifdef CONFIG_NUMA
+#define RECLAIM_OFF 0
+#define RECLAIM_ZONE (1<<0)	/* Run shrink_inactive_list on the zone */
+#define RECLAIM_WRITE (1<<1)	/* Writeout pages during reclaim */
+#define RECLAIM_SWAP (1<<2)	/* Swap pages out during reclaim */
+
 extern int zone_reclaim_mode;
 extern int sysctl_min_unmapped_ratio;
 extern int sysctl_min_slab_ratio;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e400779..be8607e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2982,7 +2982,7 @@ static void build_zonelists(pg_data_t *pgdat)
 		 * to reclaim pages in a zone before going off node.
 		 */
 		if (distance > RECLAIM_DISTANCE)
-			zone_reclaim_mode = 1;
+			zone_reclaim_mode = RECLAIM_ZONE;
 
 		/*
 		 * We don't want to pressure a particular node.
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0c5a3d6..019e00c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2893,11 +2893,6 @@ module_init(kswapd_init)
  */
 int zone_reclaim_mode __read_mostly;
 
-#define RECLAIM_OFF 0
-#define RECLAIM_ZONE (1<<0)	/* Run shrink_inactive_list on the zone */
-#define RECLAIM_WRITE (1<<1)	/* Writeout pages during reclaim */
-#define RECLAIM_SWAP (1<<2)	/* Swap pages out during reclaim */
-
 /*
  * Priority for ZONE_RECLAIM. This determines the fraction of pages
  * of a node considered for each zone_reclaim. 4 scans 1/16th of
-- 
1.7.3.1



