Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab2AKMpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 07:45:12 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34759 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab2AKMpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 07:45:08 -0500
MIME-Version: 1.0
Date: Wed, 11 Jan 2012 20:45:07 +0800
Message-ID: <CAJd=RBAiAfyXBcn+9WO6AERthyx+C=cNP-romp9YJO3Hn7-U-g@mail.gmail.com>
Subject: [PATCH] mm: vmscan: deactivate isolated pages with lru lock released
From: Hillf Danton <dhillf@gmail.com>
To: linux-mm@kvack.org
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spinners on other CPUs, if any, could take the lru lock and do their jobs while
isolated pages are deactivated on the current CPU if the lock is released
actively. And no risk of race raised as pages are already queued on locally
private list.


Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/vmscan.c	Thu Dec 29 20:20:16 2011
+++ b/mm/vmscan.c	Wed Jan 11 20:40:40 2012
@@ -1464,6 +1464,7 @@ update_isolated_counts(struct mem_cgroup
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);

 	nr_active = clear_active_flags(isolated_list, count);
+	spin_lock_irq(&zone->lru_lock);
 	__count_vm_events(PGDEACTIVATE, nr_active);

 	__mod_zone_page_state(zone, NR_ACTIVE_FILE,
@@ -1482,6 +1483,7 @@ update_isolated_counts(struct mem_cgroup

 	reclaim_stat->recent_scanned[0] += *nr_anon;
 	reclaim_stat->recent_scanned[1] += *nr_file;
+	spin_unlock_irq(&zone->lru_lock);
 }

 /*
@@ -1577,15 +1579,13 @@ shrink_inactive_list(unsigned long nr_to
 			__count_zone_vm_events(PGSCAN_DIRECT, zone,
 					       nr_scanned);
 	}
+	spin_unlock_irq(&zone->lru_lock);

-	if (nr_taken == 0) {
-		spin_unlock_irq(&zone->lru_lock);
+	if (nr_taken == 0)
 		return 0;
-	}

 	update_isolated_counts(mz, sc, &nr_anon, &nr_file, &page_list);

-	spin_unlock_irq(&zone->lru_lock);

 	nr_reclaimed = shrink_page_list(&page_list, mz, sc, priority,
 						&nr_dirty, &nr_writeback);
