Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab2FZJMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 05:12:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51585 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab2FZJMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 05:12:17 -0400
Date: Tue, 26 Jun 2012 02:12:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>
cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
        Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 06/11] memcg: kmem controller infrastructure
In-Reply-To: <1340633728-12785-7-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1206260210200.16020@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-7-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2012, Glauber Costa wrote:

> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 83e7ba9..22479eb 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -21,6 +21,7 @@
>  #define _LINUX_MEMCONTROL_H
>  #include <linux/cgroup.h>
>  #include <linux/vm_event_item.h>
> +#include <linux/hardirq.h>
>  
>  struct mem_cgroup;
>  struct page_cgroup;
> @@ -409,6 +410,12 @@ struct sock;
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
>  void sock_update_memcg(struct sock *sk);
>  void sock_release_memcg(struct sock *sk);
> +
> +#define mem_cgroup_kmem_on 1
> +bool __mem_cgroup_new_kmem_page(gfp_t gfp, void *handle, int order);
> +void __mem_cgroup_commit_kmem_page(struct page *page, void *handle, int order);
> +void __mem_cgroup_free_kmem_page(struct page *page, int order);
> +#define is_kmem_tracked_alloc (gfp & __GFP_KMEMCG)
>  #else
>  static inline void sock_update_memcg(struct sock *sk)
>  {
> @@ -416,6 +423,43 @@ static inline void sock_update_memcg(struct sock *sk)
>  static inline void sock_release_memcg(struct sock *sk)
>  {
>  }
> +
> +#define mem_cgroup_kmem_on 0
> +#define __mem_cgroup_new_kmem_page(a, b, c) false
> +#define __mem_cgroup_free_kmem_page(a,b )
> +#define __mem_cgroup_commit_kmem_page(a, b, c)
> +#define is_kmem_tracked_alloc (false)
>  #endif /* CONFIG_CGROUP_MEM_RES_CTLR_KMEM */
> +
> +static __always_inline
> +bool mem_cgroup_new_kmem_page(gfp_t gfp, void *handle, int order)
> +{
> +	if (!mem_cgroup_kmem_on)
> +		return true;
> +	if (!is_kmem_tracked_alloc)
> +		return true;
> +	if (!current->mm)
> +		return true;
> +	if (in_interrupt())
> +		return true;

You can't test for current->mm in irq context, so you need to check for 
in_interrupt() first.  Also, what prevents __mem_cgroup_new_kmem_page() 
from being called for a kthread that has called use_mm() before 
unuse_mm()?

> +	if (gfp & __GFP_NOFAIL)
> +		return true;
> +	return __mem_cgroup_new_kmem_page(gfp, handle, order);
> +}
> +
> +static __always_inline
> +void mem_cgroup_free_kmem_page(struct page *page, int order)
> +{
> +	if (mem_cgroup_kmem_on)
> +		__mem_cgroup_free_kmem_page(page, order);
> +}
> +
> +static __always_inline
> +void mem_cgroup_commit_kmem_page(struct page *page, struct mem_cgroup *handle,
> +				 int order)
> +{
> +	if (mem_cgroup_kmem_on)
> +		__mem_cgroup_commit_kmem_page(page, handle, order);
> +}
>  #endif /* _LINUX_MEMCONTROL_H */
>  
