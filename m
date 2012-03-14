Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab2CNGwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 02:52:21 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46452 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab2CNGwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 02:52:18 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
Date: Wed, 14 Mar 2012 08:52:17 +0200
Message-ID: <CAOtvUMdVrjUHLx2jZ2xbpBoDBMCX8sdCASEkmXCtBrU-gQ3EhQ@mail.gmail.com>
Subject: [PATCH] mm: fix vmstat_update to keep scheduling itself on all cores
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Christoph Lameter <cl@linux.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We set up per-cpu work structures for vmstat and schedule them on
each cpu when they go online only to re-schedule them on the general
work queue when they first run.

This doesn't seem right - how do we ever guarantee that vmstat_update runs
on all cpus? Either I've missed something or our vm stats are off and per-cpu
pages are not drained as frequently as we think they are.

Fix it by re-scheduling the work item on the same cpu it first ran on.

Tested on x86 on 8 way SMP VM.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Christoph Lameter <cl@linux.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andi Kleen <ak@linux.intel.com>
CC: linux-mm@kvack.org
---

diff --git a/mm/vmstat.c b/mm/vmstat.c
index f600557..b396044 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1144,8 +1144,10 @@ int sysctl_stat_interval __read_mostly = HZ;

 static void vmstat_update(struct work_struct *w)
 {
-	refresh_cpu_vm_stats(smp_processor_id());
-	schedule_delayed_work(&__get_cpu_var(vmstat_work),
+	int cpu = smp_processor_id();
+
+	refresh_cpu_vm_stats(cpu);
+	schedule_delayed_work_on(cpu, &__get_cpu_var(vmstat_work),
 		round_jiffies_relative(sysctl_stat_interval));
 }



--
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
