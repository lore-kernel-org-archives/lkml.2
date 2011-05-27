Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab1E0FsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 01:48:01 -0400
Received: from smtp-out.google.com ([74.125.121.67]:52855 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab1E0Fr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 01:47:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EhH+V3wVJKb3ckgLlko//dnj4PSz1BooED5Mw6IPsKBxBYwnpDxyeh8k3b51Y162UN
         QONLqg89gB3hLosVcDBg==
MIME-Version: 1.0
In-Reply-To: <20110526141529.53b70097.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110526141047.dc828124.kamezawa.hiroyu@jp.fujitsu.com>
	<20110526141529.53b70097.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 26 May 2011 22:47:55 -0700
Message-ID: <BANLkTimq7Bd_OQDOPmkM3n38g1pUbT9uYw@mail.gmail.com>
Subject: Re: [RFC][PATCH v3 1/10] check reclaimable in hierarchy walk
From: Ying Han <yinghan@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 10:15 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> I may post this patch as stand alone, later.
> ==
> Check memcg has reclaimable pages at select_victim().
>
> Now, with help of bitmap as memcg->scan_node, we can check whether memcg has
> reclaimable pages with easy test of node_empty(&mem->scan_nodes).
>
> mem->scan_nodes is a bitmap to show whether memcg contains reclaimable
> memory or not, which is updated periodically.
>
> This patch makes use of scan_nodes and modify hierarchy walk at memory
> shrinking in following way.
>
>  - check scan_nodes in mem_cgroup_select_victim()
>  - mem_cgroup_select_victim() returns NULL if no memcg is reclaimable.
>  - force update of scan_nodes.
>  - rename mem_cgroup_select_victim() to be mem_cgroup_select_get_victim()
>    to show refcnt is +1.
>
> This will make hierarchy walk better.
>
> And this allows to remove mem_cgroup_local_pages() check which was used for
> the same purpose. But this function was wrong because it cannot handle
> information of unevictable pages and tmpfs v.s. swapless information.
>
> Changelog:
>  - added since v3.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/memcontrol.c |  165 +++++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 110 insertions(+), 55 deletions(-)
>
> Index: memcg_async/mm/memcontrol.c
> ===================================================================
> --- memcg_async.orig/mm/memcontrol.c
> +++ memcg_async/mm/memcontrol.c
> @@ -584,15 +584,6 @@ static long mem_cgroup_read_stat(struct
>        return val;
>  }
>
> -static long mem_cgroup_local_usage(struct mem_cgroup *mem)
> -{
> -       long ret;
> -
> -       ret = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_RSS);
> -       ret += mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_CACHE);
> -       return ret;
> -}
> -
>  static void mem_cgroup_swap_statistics(struct mem_cgroup *mem,
>                                         bool charge)
>  {
> @@ -1555,43 +1546,6 @@ u64 mem_cgroup_get_limit(struct mem_cgro
>        return min(limit, memsw);
>  }
>
> -/*
> - * Visit the first child (need not be the first child as per the ordering
> - * of the cgroup list, since we track last_scanned_child) of @mem and use
> - * that to reclaim free pages from.
> - */
> -static struct mem_cgroup *
> -mem_cgroup_select_victim(struct mem_cgroup *root_mem)
> -{
> -       struct mem_cgroup *ret = NULL;
> -       struct cgroup_subsys_state *css;
> -       int nextid, found;
> -
> -       if (!root_mem->use_hierarchy) {
> -               css_get(&root_mem->css);
> -               ret = root_mem;
> -       }
> -
> -       while (!ret) {
> -               rcu_read_lock();
> -               nextid = root_mem->last_scanned_child + 1;
> -               css = css_get_next(&mem_cgroup_subsys, nextid, &root_mem->css,
> -                                  &found);
> -               if (css && css_tryget(css))
> -                       ret = container_of(css, struct mem_cgroup, css);
> -
> -               rcu_read_unlock();
> -               /* Updates scanning parameter */
> -               if (!css) {
> -                       /* this means start scan from ID:1 */
> -                       root_mem->last_scanned_child = 0;
> -               } else
> -                       root_mem->last_scanned_child = found;
> -       }
> -
> -       return ret;
> -}
> -
>  #if MAX_NUMNODES > 1
>
>  /*
> @@ -1600,11 +1554,11 @@ mem_cgroup_select_victim(struct mem_cgro
>  * nodes based on the zonelist. So update the list loosely once per 10 secs.
>  *
>  */
> -static void mem_cgroup_may_update_nodemask(struct mem_cgroup *mem)
> +static void mem_cgroup_may_update_nodemask(struct mem_cgroup *mem, bool force)
>  {
>        int nid;
>
> -       if (time_after(mem->next_scan_node_update, jiffies))
> +       if (!force && time_after(mem->next_scan_node_update, jiffies))
>                return;
>
>        mem->next_scan_node_update = jiffies + 10*HZ;
> @@ -1641,7 +1595,7 @@ int mem_cgroup_select_victim_node(struct
>  {
>        int node;
>
> -       mem_cgroup_may_update_nodemask(mem);
> +       mem_cgroup_may_update_nodemask(mem, false);
>        node = mem->last_scanned_node;
>
>        node = next_node(node, mem->scan_nodes);
> @@ -1660,13 +1614,117 @@ int mem_cgroup_select_victim_node(struct
>        return node;
>  }
>
> +/**
> + * mem_cgroup_has_reclaimable
> + * @mem_cgroup : the mem_cgroup
> + *
> + * The caller can test whether the memcg has reclaimable pages.
> + *
> + * This function checks memcg has reclaimable pages or not with bitmap of
> + * memcg->scan_nodes. This bitmap is updated periodically and indicates
> + * which node has reclaimable memcg memory or not.
> + * Although this is a rough test and result is not very precise but we don't
> + * have to scan all nodes and don't have to use locks.
> + *
> + * For non-NUMA, this cheks reclaimable pages on zones because we don't
> + * update scan_nodes.(see below)
> + */
> +static bool mem_cgroup_has_reclaimable(struct mem_cgroup *memcg)
> +{
> +       return !nodes_empty(memcg->scan_nodes);
> +}
> +
>  #else
> +
> +static void mem_cgroup_may_update_nodemask(struct mem_cgroup *mem, bool force)
> +{
> +}
> +
>  int mem_cgroup_select_victim_node(struct mem_cgroup *mem)
>  {
>        return 0;
>  }
> +
> +static bool mem_cgroup_has_reclaimable(struct mem_cgroup *memcg)
> +{
> +       unsigned long nr;
> +       int zid;
> +
> +       for (zid = NODE_DATA(0)->nr_zones - 1; zid >= 0; zid--)
> +               if (mem_cgroup_zone_reclaimable_pages(memcg, 0, zid))
> +                       break;
> +       if (zid < 0)
> +               return false;
> +       return true;
> +}
>  #endif

unused variable "nr".

--Ying
>
> +/**
> + * mem_cgroup_select_get_victim
> + * @root_mem: the root memcg of hierarchy which should be shrinked.
> + *
> + * Visit children of root_mem ony by one. If the routine finds a memcg
> + * which contains reclaimable pages, returns it with refcnt +1. The
> + * scan is done in round-robin and 'the next start point' is saved into
> + * mem->last_scanned_child. If no reclaimable memcg are found, returns NULL.
> + */
> +static struct mem_cgroup *
> +mem_cgroup_select_get_victim(struct mem_cgroup *root_mem)
> +{
> +       struct mem_cgroup *ret = NULL;
> +       struct cgroup_subsys_state *css;
> +       int nextid, found;
> +       bool second_visit = false;
> +
> +       if (!root_mem->use_hierarchy)
> +               goto return_root;
> +
> +       while (!ret) {
> +               rcu_read_lock();
> +               nextid = root_mem->last_scanned_child + 1;
> +               css = css_get_next(&mem_cgroup_subsys, nextid, &root_mem->css,
> +                                  &found);
> +               if (css && css_tryget(css))
> +                       ret = container_of(css, struct mem_cgroup, css);
> +
> +               rcu_read_unlock();
> +               /* Updates scanning parameter */
> +               if (!css) { /* Indicates we scanned the last node of tree */
> +                       /*
> +                        * If all memcg has no reclaimable pages, we may enter
> +                        * an infinite loop. Exit here if we reached the end
> +                        * of hierarchy tree twice.
> +                        */
> +                       if (second_visit)
> +                               return NULL;
> +                       /* this means start scan from ID:1 */
> +                       root_mem->last_scanned_child = 0;
> +                       second_visit = true;
> +               } else
> +                       root_mem->last_scanned_child = found;
> +               if (css && ret) {
> +                       /*
> +                        * check memcg has reclaimable memory or not. Update
> +                        * information carefully if we might fail with cached
> +                        * bitmask information.
> +                        */
> +                       if (second_visit)
> +                               mem_cgroup_may_update_nodemask(ret, true);
> +
> +                       if (!mem_cgroup_has_reclaimable(ret)) {
> +                               css_put(css);
> +                               ret = NULL;
> +                       }
> +               }
> +       }
> +
> +       return ret;
> +return_root:
> +       css_get(&root_mem->css);
> +       return root_mem;
> +}
> +
> +
>  /*
>  * Scan the hierarchy if needed to reclaim memory. We remember the last child
>  * we reclaimed from, so that we don't end up penalizing one child extensively
> @@ -1705,7 +1763,9 @@ static int mem_cgroup_hierarchical_recla
>                is_kswapd = true;
>
>        while (1) {
> -               victim = mem_cgroup_select_victim(root_mem);
> +               victim = mem_cgroup_select_get_victim(root_mem);
> +               if (!victim)
> +                       return total;
>                if (victim == root_mem) {
>                        loop++;
>                        if (loop >= 1)
> @@ -1733,11 +1793,6 @@ static int mem_cgroup_hierarchical_recla
>                                }
>                        }
>                }
> -               if (!mem_cgroup_local_usage(victim)) {
> -                       /* this cgroup's local usage == 0 */
> -                       css_put(&victim->css);
> -                       continue;
> -               }
>                /* we use swappiness of local cgroup */
>                if (check_soft) {
>                        ret = mem_cgroup_shrink_node_zone(victim, gfp_mask,
>
>
