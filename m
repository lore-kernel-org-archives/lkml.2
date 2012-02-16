Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab2BPNBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:01:45 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52376 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab2BPNBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:01:44 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1202021726410.31915@eggly.anvils>
References: <CAJd=RBANeF+TTTtn=F_Yx3N5KkVb5vFPY6FNYEjVntB1pPSLBA@mail.gmail.com>
	<CAJd=RBAH4+nFQ35JcHju6eSPfDcQpbkJjMX6GBaZFECVaL2swA@mail.gmail.com>
	<20120116092745.7721ff31.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LSU.2.00.1202021726410.31915@eggly.anvils>
Date: Thu, 16 Feb 2012 21:01:43 +0800
Message-ID: <CAJd=RBCpE9TUDwr17sGc2mg_xfyCCktAyxSt1v3Tzj6dCNL0eA@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: handle isolated pages with lru lock released
From: Hillf Danton <dhillf@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 9:40 AM, Hugh Dickins <hughd@google.com> wrote:
> From: Hillf Danton <dhillf@gmail.com>
>
> When shrinking inactive lru list, isolated pages are queued on locally private
> list, so the lock-hold time could be reduced if pages are counted without lock
> protection.
>
> To achieve that, firstly updating reclaim stat is delayed until the
> putback stage, after reacquiring the lru lock.
>
> Secondly, operations related to vm and zone stats are now proteced with
> preemption disabled as they are per-cpu operations.
>
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> Acked-by: Hugh Dickins <hughd@google.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
> KAMEZAWA-san and I both admired this patch from Hillf; Rik and David
> liked its precursor: I think we'd all be glad to see it in linux-next.
>
>  mm/vmscan.c |   21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
>
> --- a/mm/vmscan.c       Sat Jan 14 14:02:20 2012
> +++ b/mm/vmscan.c       Sat Jan 14 20:00:46 2012
> @@ -1414,7 +1414,6 @@ update_isolated_counts(struct mem_cgroup
>                       unsigned long *nr_anon,
>                       unsigned long *nr_file)
>  {
> -       struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
>        struct zone *zone = mz->zone;
>        unsigned int count[NR_LRU_LISTS] = { 0, };
>        unsigned long nr_active = 0;
> @@ -1435,6 +1434,7 @@ update_isolated_counts(struct mem_cgroup
>                count[lru] += numpages;
>        }
>
> +       preempt_disable();
>        __count_vm_events(PGDEACTIVATE, nr_active);
>
>        __mod_zone_page_state(zone, NR_ACTIVE_FILE,
> @@ -1449,8 +1449,9 @@ update_isolated_counts(struct mem_cgroup
>        *nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
>        *nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
>
> -       reclaim_stat->recent_scanned[0] += *nr_anon;
> -       reclaim_stat->recent_scanned[1] += *nr_file;
> +       __mod_zone_page_state(zone, NR_ISOLATED_ANON, *nr_anon);
> +       __mod_zone_page_state(zone, NR_ISOLATED_FILE, *nr_file);
> +       preempt_enable();
>  }
>
>  /*
> @@ -1512,6 +1513,7 @@ shrink_inactive_list(unsigned long nr_to
>        unsigned long nr_writeback = 0;
>        isolate_mode_t reclaim_mode = ISOLATE_INACTIVE;
>        struct zone *zone = mz->zone;
> +       struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
>
>        while (unlikely(too_many_isolated(zone, file, sc))) {
>                congestion_wait(BLK_RW_ASYNC, HZ/10);
> @@ -1546,19 +1548,13 @@ shrink_inactive_list(unsigned long nr_to
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
>        update_isolated_counts(mz, &page_list, &nr_anon, &nr_file);
>
> -       __mod_zone_page_state(zone, NR_ISOLATED_ANON, nr_anon);
> -       __mod_zone_page_state(zone, NR_ISOLATED_FILE, nr_file);
> -
> -       spin_unlock_irq(&zone->lru_lock);
> -
>        nr_reclaimed = shrink_page_list(&page_list, mz, sc, priority,
>                                                &nr_dirty, &nr_writeback);
>
> @@ -1570,6 +1566,9 @@ shrink_inactive_list(unsigned long nr_to
>        }
>
>        spin_lock_irq(&zone->lru_lock);
> +
> +       reclaim_stat->recent_scanned[0] += nr_anon;
> +       reclaim_stat->recent_scanned[1] += nr_file;
>
>        if (current_is_kswapd())
>                __count_vm_events(KSWAPD_STEAL, nr_reclaimed);

Hi Andrew

Please consider adding this patch to -mm tree.

Thanks
Hillf
