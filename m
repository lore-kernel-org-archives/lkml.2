Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab1JNPS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:18:29 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:44228 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753786Ab1JNPS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:18:27 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: K4BfJCEVM1l2ceMIsd1dgBaFXT3UUQHUfOTWVAwo8KiiR7Q
 h_xWCzs_K50fiJSvjz8vNX1qf3RJyy0YHEOEkeZPsXCvk7ShbXoNeFul6FFE
 eEoY2yw3QTQns_pDxhWjziZU11TbDOzSzJm25lXGTpdkUflwbnivFRngd9ud
 81p4OuWaMi9FqA93U656ZIVNP6t_hQUgUb.1Bkga6dTBde7vWBCn.w3uQ3w7
 c6UBOkEvaO2lkuGeZrX5Vbi2ZdY2u6luvp2_qOXJ4fBMOywJVFedkFUpcGua
 dPWZy11SGiOP5vJlZg1ZNisEFrIvtfcGZO.nX9lzsxMmUzQn7RxvcDVQp9ZC
 Px9aY1DPN6dPL3f_jUiYxAfZB0bPvsOsMcjunXq3FePBNyhZUzci4hfOEU.A
 pBLnEoTz9H777ndC3uUO.q0Y-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 14 Oct 2011 10:18:24 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Dimitri Sivanich <sivanich@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] Reduce vm_stat cacheline contention in
 __vm_enough_memory
In-Reply-To: <alpine.DEB.2.00.1110140932530.6411@router.home>
Message-ID: <alpine.DEB.2.00.1110140958550.6411@router.home>
References: <20111012120118.e948f40a.akpm@linux-foundation.org> <alpine.DEB.2.00.1110121452220.31218@router.home> <20111013152355.GB6966@sgi.com> <alpine.DEB.2.00.1110131052300.18473@router.home> <20111013135032.7c2c54cd.akpm@linux-foundation.org>
 <alpine.DEB.2.00.1110131602020.26553@router.home> <20111013142434.4d05cbdc.akpm@linux-foundation.org> <20111014122506.GB26737@sgi.com> <20111014135055.GA28592@sgi.com> <alpine.DEB.2.00.1110140856420.6411@router.home> <20111014141921.GC28592@sgi.com>
 <alpine.DEB.2.00.1110140932530.6411@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also the whole thing could be optimized by concentrating updates to the
vm_stat array at one point in time. If any local per cpu differential
overflows then update all the counters in the same cacheline for which we have per cpu
differentials.

That will defer another acquisition of the cacheline for the next delta
overflowing. After an update all the per cpu differentials would be zero.

This could be added to zone_page_state_add....


Something like this patch? (Restriction of the updates to the same
cacheline missing. Just does everything and the zone_page_state may need
uninlining now)

---
 include/linux/vmstat.h |   19 ++++++++++++++++---
 mm/vmstat.c            |   10 ++++------
 2 files changed, 20 insertions(+), 9 deletions(-)

Index: linux-2.6/include/linux/vmstat.h
===================================================================
--- linux-2.6.orig/include/linux/vmstat.h	2011-10-14 09:58:03.000000000 -0500
+++ linux-2.6/include/linux/vmstat.h	2011-10-14 10:08:00.000000000 -0500
@@ -90,10 +90,23 @@ static inline void vm_events_fold_cpu(in
 extern atomic_long_t vm_stat[NR_VM_ZONE_STAT_ITEMS];

 static inline void zone_page_state_add(long x, struct zone *zone,
-				 enum zone_stat_item item)
+				 enum zone_stat_item item, s8 new_value)
 {
-	atomic_long_add(x, &zone->vm_stat[item]);
-	atomic_long_add(x, &vm_stat[item]);
+	enum zone_stat_item i;
+
+	for (i = 0; i < NR_VM_EVENT_ITEMS; i++) {
+		long y;
+
+		if (i == item)
+			y = this_cpu_xchg(zone->pageset->vm_stat_diff[i], new_value) + x;
+		else
+			y = this_cpu_xchg(zone->pageset->vm_stat_diff[i], 0);
+
+		if (y) {
+			atomic_long_add(y, &zone->vm_stat[item]);
+			atomic_long_add(y, &vm_stat[item]);
+		}
+	}
 }

 static inline unsigned long global_page_state(enum zone_stat_item item)
Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2011-10-14 10:04:20.000000000 -0500
+++ linux-2.6/mm/vmstat.c	2011-10-14 10:08:39.000000000 -0500
@@ -221,7 +221,7 @@ void __mod_zone_page_state(struct zone *
 	t = __this_cpu_read(pcp->stat_threshold);

 	if (unlikely(x > t || x < -t)) {
-		zone_page_state_add(x, zone, item);
+		zone_page_state_add(x, zone, item, 0);
 		x = 0;
 	}
 	__this_cpu_write(*p, x);
@@ -262,8 +262,7 @@ void __inc_zone_state(struct zone *zone,
 	if (unlikely(v > t)) {
 		s8 overstep = t >> 1;

-		zone_page_state_add(v + overstep, zone, item);
-		__this_cpu_write(*p, -overstep);
+		zone_page_state_add(v + overstep, zone, item, -overstep);
 	}
 }

@@ -284,8 +283,7 @@ void __dec_zone_state(struct zone *zone,
 	if (unlikely(v < - t)) {
 		s8 overstep = t >> 1;

-		zone_page_state_add(v - overstep, zone, item);
-		__this_cpu_write(*p, overstep);
+		zone_page_state_add(v - overstep, zone, item, overstep);
 	}
 }

@@ -343,7 +341,7 @@ static inline void mod_state(struct zone
 	} while (this_cpu_cmpxchg(*p, o, n) != o);

 	if (z)
-		zone_page_state_add(z, zone, item);
+		zone_page_state_add(z, zone, item, 0);
 }

 void mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
