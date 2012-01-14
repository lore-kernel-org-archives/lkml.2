Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab2ANMFP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 07:05:15 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:40819 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab2ANMFM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 07:05:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAJd=RBANeF+TTTtn=F_Yx3N5KkVb5vFPY6FNYEjVntB1pPSLBA@mail.gmail.com>
References: <CAJd=RBANeF+TTTtn=F_Yx3N5KkVb5vFPY6FNYEjVntB1pPSLBA@mail.gmail.com>
Date: Sat, 14 Jan 2012 20:05:11 +0800
Message-ID: <CAJd=RBAH4+nFQ35JcHju6eSPfDcQpbkJjMX6GBaZFECVaL2swA@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: handle isolated pages with lru lock released
From: Hillf Danton <dhillf@gmail.com>
To: linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 11:00 PM, Hillf Danton <dhillf@gmail.com> wrote:
> When shrinking inactive lru list, isolated pages are queued on locally private
> list, which opens a window for pulling update_isolated_counts() out of the lock
> protection to reduce the lock-hold time.
>
> To achive that, firstly we have to delay updating reclaim stat, which is pointed
> out by Hugh, but not over the deadline where fresh data is used for setting up
> scan budget for shrinking zone in get_scan_count(). The delay is terminated in
> the putback stage after reacquiring lru lock.
>
> Secondly operations related to vm and zone stats, namely __count_vm_events() and
> __mod_zone_page_state(), are proteced with preemption disabled as they
> are per-cpu
> operations.
>
> Thanks for comments and ideas recieved.
>
>
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>
> --- a/mm/vmscan.c       Fri Jan 13 21:30:58 2012
> +++ b/mm/vmscan.c       Fri Jan 13 22:07:14 2012
> @@ -1408,6 +1408,13 @@ putback_lru_pages(struct mem_cgroup_zone
>         * Put back any unfreeable pages.
>         */
>        spin_lock(&zone->lru_lock);
> +       /*
> +        * Here we finish updating reclaim stat that is delayed in
> +        * update_isolated_counts()
> +        */
> +       reclaim_stat->recent_scanned[0] += nr_anon;
> +       reclaim_stat->recent_scanned[1] += nr_file;
> +
>        while (!list_empty(page_list)) {
>                int lru;
>                page = lru_to_page(page_list);
> @@ -1461,9 +1468,19 @@ update_isolated_counts(struct mem_cgroup
>        unsigned long nr_active;
>        struct zone *zone = mz->zone;
>        unsigned int count[NR_LRU_LISTS] = { 0, };
> -       struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
>
>        nr_active = clear_active_flags(isolated_list, count);
> +       /*
> +        * Without lru lock held,
> +        * 1, we have to delay updating zone reclaim stat, and the deadline is
> +        *    when fresh data is used for setting up scan budget for another
> +        *    round shrinking, see get_scan_count(). It is actually updated in
> +        *    the putback stage after reacquiring the lock.
> +        *
> +        * 2, __count_vm_events() and __mod_zone_page_state() are protected
> +        *    with preempt disabled as they are per-cpu operations.
> +        */
> +       preempt_disable();
>        __count_vm_events(PGDEACTIVATE, nr_active);
>
>        __mod_zone_page_state(zone, NR_ACTIVE_FILE,
> @@ -1479,9 +1496,7 @@ update_isolated_counts(struct mem_cgroup
>        *nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
>        __mod_zone_page_state(zone, NR_ISOLATED_ANON, *nr_anon);
>        __mod_zone_page_state(zone, NR_ISOLATED_FILE, *nr_file);
> -
> -       reclaim_stat->recent_scanned[0] += *nr_anon;
> -       reclaim_stat->recent_scanned[1] += *nr_file;
> +       preempt_enable();
>  }
>
>  /*
> @@ -1577,15 +1592,12 @@ shrink_inactive_list(unsigned long nr_to
>                        __count_zone_vm_events(PGSCAN_DIRECT, zone,
>                                               nr_scanned);
>        }
> +       spin_unlock_irq(&zone->lru_lock);
>
> -       if (nr_taken == 0) {
> -               spin_unlock_irq(&zone->lru_lock);
> +       if (nr_taken == 0)
>                return 0;
> -       }
>
>        update_isolated_counts(mz, sc, &nr_anon, &nr_file, &page_list);
> -
> -       spin_unlock_irq(&zone->lru_lock);
>
>        nr_reclaimed = shrink_page_list(&page_list, mz, sc, priority,
>                                                &nr_dirty, &nr_writeback);


Hi all

It is re-prepared based on the mainline for easy review.

Thanks
Hillf


===cut here===
From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] mm: vmscan: handle isolated pages with lru lock released

When shrinking inactive lru list, isolated pages are queued on locally private
list, so the lock-hold time could be reduced if pages are counted without lock
protection. To achive that, firstly updating reclaim stat is delayed until the
putback stage, which is pointed out by Hugh, after reacquiring the lru lock.

Secondly operations related to vm and zone stats, are now proteced with
preemption disabled as they are per-cpu operation.

Thanks for comments and ideas received.


Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/vmscan.c	Sat Jan 14 14:02:20 2012
+++ b/mm/vmscan.c	Sat Jan 14 20:00:46 2012
@@ -1414,7 +1414,6 @@ update_isolated_counts(struct mem_cgroup
 		       unsigned long *nr_anon,
 		       unsigned long *nr_file)
 {
-	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
 	struct zone *zone = mz->zone;
 	unsigned int count[NR_LRU_LISTS] = { 0, };
 	unsigned long nr_active = 0;
@@ -1435,6 +1434,7 @@ update_isolated_counts(struct mem_cgroup
 		count[lru] += numpages;
 	}

+	preempt_disable();
 	__count_vm_events(PGDEACTIVATE, nr_active);

 	__mod_zone_page_state(zone, NR_ACTIVE_FILE,
@@ -1449,8 +1449,9 @@ update_isolated_counts(struct mem_cgroup
 	*nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
 	*nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];

-	reclaim_stat->recent_scanned[0] += *nr_anon;
-	reclaim_stat->recent_scanned[1] += *nr_file;
+	__mod_zone_page_state(zone, NR_ISOLATED_ANON, *nr_anon);
+	__mod_zone_page_state(zone, NR_ISOLATED_FILE, *nr_file);
+	preempt_enable();
 }

 /*
@@ -1512,6 +1513,7 @@ shrink_inactive_list(unsigned long nr_to
 	unsigned long nr_writeback = 0;
 	isolate_mode_t reclaim_mode = ISOLATE_INACTIVE;
 	struct zone *zone = mz->zone;
+	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);

 	while (unlikely(too_many_isolated(zone, file, sc))) {
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
@@ -1546,19 +1548,13 @@ shrink_inactive_list(unsigned long nr_to
 			__count_zone_vm_events(PGSCAN_DIRECT, zone,
 					       nr_scanned);
 	}
+	spin_unlock_irq(&zone->lru_lock);

-	if (nr_taken == 0) {
-		spin_unlock_irq(&zone->lru_lock);
+	if (nr_taken == 0)
 		return 0;
-	}

 	update_isolated_counts(mz, &page_list, &nr_anon, &nr_file);

-	__mod_zone_page_state(zone, NR_ISOLATED_ANON, nr_anon);
-	__mod_zone_page_state(zone, NR_ISOLATED_FILE, nr_file);
-
-	spin_unlock_irq(&zone->lru_lock);
-
 	nr_reclaimed = shrink_page_list(&page_list, mz, sc, priority,
 						&nr_dirty, &nr_writeback);

@@ -1570,6 +1566,9 @@ shrink_inactive_list(unsigned long nr_to
 	}

 	spin_lock_irq(&zone->lru_lock);
+
+	reclaim_stat->recent_scanned[0] += nr_anon;
+	reclaim_stat->recent_scanned[1] += nr_file;

 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_STEAL, nr_reclaimed);
