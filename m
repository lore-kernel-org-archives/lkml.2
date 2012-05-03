Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab2ECHSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 03:18:30 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53990 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab2ECHS3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 03:18:29 -0400
MIME-Version: 1.0
In-Reply-To: <1334499755-4399-1-git-send-email-andi@firstfloor.org>
References: <1334499755-4399-1-git-send-email-andi@firstfloor.org>
Date: Thu, 3 May 2012 10:18:28 +0300
X-Google-Sender-Auth: IZUKoiuIdvkXroW5mJ4dFhUeWYU
Message-ID: <CAOJsxLE36GNJBmdrJqFfoyEve8swVsaBSq_oVgkgXSMEC3oBfA@mail.gmail.com>
Subject: Re: [PATCH] slab/mempolicy: always use local policy from interrupt
 context v2
From: Pekka Enberg <penberg@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding some CC's.)

On Sun, Apr 15, 2012 at 5:22 PM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> slab_node() could access current->mempolicy from interrupt context.
> However there's a race condition during exit where the mempolicy
> is first freed and then the pointer zeroed.
>
> Using this from interrupts seems bogus anyways. The interrupt
> will interrupt a random process and therefore get a random
> mempolicy. Many times, this will be idle's, which noone can change.
>
> Just disable this here and always use local for slab
> from interrupts. I also cleaned up the callers of slab_node a bit
> which always passed the same argument.
>
> I believe the original mempolicy code did that in fact,
> so it's likely a regression.
>
> v2: send version with correct logic
> Reported-by: Arun Sharma <asharma@fb.com>
> Cc: penberg@kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  include/linux/mempolicy.h |    2 +-
>  mm/mempolicy.c            |    3 ++-
>  mm/slab.c                 |    4 ++--
>  mm/slub.c                 |    2 +-
>  4 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
> index 7c727a9..7106786 100644
> --- a/include/linux/mempolicy.h
> +++ b/include/linux/mempolicy.h
> @@ -215,7 +215,7 @@ extern struct zonelist *huge_zonelist(struct vm_area_struct *vma,
>  extern bool init_nodemask_of_mempolicy(nodemask_t *mask);
>  extern bool mempolicy_nodemask_intersects(struct task_struct *tsk,
>                                const nodemask_t *mask);
> -extern unsigned slab_node(struct mempolicy *policy);
> +extern unsigned slab_node(void);
>
>  extern enum zone_type policy_zone;
>
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index cfb6c86..da79bbf 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1586,8 +1586,9 @@ static unsigned interleave_nodes(struct mempolicy *policy)
>  * task can change it's policy.  The system default policy requires no
>  * such protection.
>  */
> -unsigned slab_node(struct mempolicy *policy)
> +unsigned slab_node(void)
>  {
> +       struct mempolicy *policy = !in_interrupt() ? current->policy : NULL;
>        if (!policy || policy->flags & MPOL_F_LOCAL)
>                return numa_node_id();
>
> diff --git a/mm/slab.c b/mm/slab.c
> index e901a36..af3b405 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3336,7 +3336,7 @@ static void *alternate_node_alloc(struct kmem_cache *cachep, gfp_t flags)
>        if (cpuset_do_slab_mem_spread() && (cachep->flags & SLAB_MEM_SPREAD))
>                nid_alloc = cpuset_slab_spread_node();
>        else if (current->mempolicy)
> -               nid_alloc = slab_node(current->mempolicy);
> +               nid_alloc = slab_node();
>        if (nid_alloc != nid_here)
>                return ____cache_alloc_node(cachep, flags, nid_alloc);
>        return NULL;
> @@ -3368,7 +3368,7 @@ static void *fallback_alloc(struct kmem_cache *cache, gfp_t flags)
>
>  retry_cpuset:
>        cpuset_mems_cookie = get_mems_allowed();
> -       zonelist = node_zonelist(slab_node(current->mempolicy), flags);
> +       zonelist = node_zonelist(slab_node(), flags);
>
>  retry:
>        /*
> diff --git a/mm/slub.c b/mm/slub.c
> index ffe13fd..ef936f3 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1614,7 +1614,7 @@ static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags,
>
>        do {
>                cpuset_mems_cookie = get_mems_allowed();
> -               zonelist = node_zonelist(slab_node(current->mempolicy), flags);
> +               zonelist = node_zonelist(slab_node(), flags);
>                for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
>                        struct kmem_cache_node *n;
>
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
