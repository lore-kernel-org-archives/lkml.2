Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab0IBAyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 20:54:12 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:46398 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752535Ab0IBAyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 20:54:08 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 255qyswVM1nyLN14NaaT6x0BxRaAXoma0RERZVVR6XXgjWE
 XXze.Zw6tvIrHRxzcjO5sCjx0BBf_bt_0exuN4gYrahL5dvvxpeKU9uLbhg0
 0RCOrbpgjXEnX34MzW4sE2_9IA6rlLuHTAVXwIghasUhXmBdFMhGEAl9YN6g
 JHtcSs4bAofOTHwn6iLlu7osZ.UR0yR8TR7tP5_.7_cRmOuNu7vwhw.5Hq47
 QcWLWNiMP6OeYWuLDyUvyBc3BZsLk0PiQPVKDF5PP114PJFsmFkqnBnmBetk
 7uQ--
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 1 Sep 2010 19:54:04 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] mm: page allocator: Calculate a better estimate of
 NR_FREE_PAGES when memory is low and kswapd is awake
In-Reply-To: <alpine.DEB.2.00.1009011935040.20518@router.home>
Message-ID: <alpine.DEB.2.00.1009011953280.21401@router.home>
References: <20100901203422.GA19519@csn.ul.ie> <alpine.DEB.2.00.1009011919110.20518@router.home> <20100902092628.D065.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1009011935040.20518@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Sep 2010, Christoph Lameter wrote:

> The effect needs to be the same as retrieving a global or
> zone ZVC counter. Which is currently implemented in the following way:
>
> static inline unsigned long zone_page_state(struct zone *zone,
>                                         enum zone_stat_item item)
> {
>         long x = atomic_long_read(&zone->vm_stat[item]);
> #ifdef CONFIG_SMP
>         if (x < 0)
>                 x = 0;
> #endif
>         return x;
> }
>

Here is a patch that defined a snapshot function that works in the same
way:

Subject: Add a snapshot function for vm statistics

Add a snapshot function that can more accurately determine
the current value of a zone counter.

Signed-off-by: Christoph Lameter <cl@linux.com>


Index: linux-2.6/include/linux/vmstat.h
===================================================================
--- linux-2.6.orig/include/linux/vmstat.h	2010-09-01 19:45:23.506071189 -0500
+++ linux-2.6/include/linux/vmstat.h	2010-09-01 19:53:02.978979081 -0500
@@ -170,6 +170,28 @@
 	return x;
 }

+/*
+ * More accurate version that also considers the currently pending
+ * deltas. For that we need to loop over all cpus to find the current
+ * deltas. There is no synchronization so the result cannot be
+ * exactly accurate either.
+ */
+static inline unsigned long zone_page_state_snapshot(struct zone *zone,
+					enum zone_stat_item item)
+{
+	int cpu;
+	long x = atomic_long_read(&zone->vm_stat[item]);
+
+#ifdef CONFIG_SMP
+	for_each_online_cpu(cpu)
+		x += per_cpu_ptr(zone->pageset, cpu)->vm_stat_diff[item];
+
+	if (x < 0)
+		x = 0;
+#endif
+	return x;
+}
+
 extern unsigned long global_reclaimable_pages(void);
 extern unsigned long zone_reclaimable_pages(struct zone *zone);

