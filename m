Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab2E2O17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 10:27:59 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:43867 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753506Ab2E2O15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 10:27:57 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: z97BlZwVM1mFgVadALvOzSz0wouvqspdlfnk1oaZs6uifqo
 1_BgaFKIii8.a3_2wwy4SNn9mOtCbpR6n.FcZzm2olgNja7DAowzVAx19WZZ
 ZNdq9p3IKeoXnixIU2rf9ek4sKKC124nJv2oxyCHZ7Ndhzw..hm13AlaoeiB
 N5yYobY.M6nlvDfaUZmYcG05DQ0p0iOxMkwL3iQXUvyvK7nos.MuADk978Hp
 QcwdorNgGSDDnyo2WnsdwJJ2GwBRYPpcVDuOz0jSL185o.8atDKR4dfq2fIU
 Kd5sO2Jh.XqqPzk480ti7PA7pjoeHCpDTQ19.4zBSDXV7lG4M5aQFwvN5U5X
 0OrXVGB61ZvakFiYGqWfoYigCSrcEuQXb_Nv7VfAzVYb2gBhSpBjPM6zEFQN
 MjznjNWabYJguFqPJZhxmvMfHdE4Gt_ldvjCK
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 29 May 2012 09:27:52 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 12/28] slab: pass memcg parameter to
 kmem_cache_create
In-Reply-To: <1337951028-3427-13-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1205290922340.4666@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-13-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012, Glauber Costa wrote:

> index 06e4a3e..7c0cdd6 100644
> --- a/include/linux/slab_def.h
> +++ b/include/linux/slab_def.h
> @@ -102,6 +102,13 @@ struct kmem_cache {
>  	 */
>  };
>
> +static inline void store_orig_align(struct kmem_cache *cachep, int orig_align)
> +{
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> +	cachep->memcg_params.orig_align = orig_align;
> +#endif
> +}
> +

Why do you need to store the original alignment? Is the calculated
alignment not enough?

> +++ b/mm/slab.c
> @@ -1729,6 +1729,31 @@ void __init kmem_cache_init_late(void)
>  	 */
>  }
>
> +static int __init memcg_slab_register_all(void)
> +{
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> +	struct kmem_cache *cachep;
> +	struct cache_sizes *sizes;
> +
> +	sizes = malloc_sizes;
> +
> +	while (sizes->cs_size != ULONG_MAX) {
> +		if (sizes->cs_cachep)
> +			mem_cgroup_register_cache(NULL, sizes->cs_cachep);
> +		if (sizes->cs_dmacachep)
> +			mem_cgroup_register_cache(NULL, sizes->cs_dmacachep);
> +		sizes++;
> +	}
> +
> +	mutex_lock(&cache_chain_mutex);
> +	list_for_each_entry(cachep, &cache_chain, next)
> +		mem_cgroup_register_cache(NULL, cachep);
> +
> +	mutex_unlock(&cache_chain_mutex);
> +#endif /* CONFIG_CGROUP_MEM_RES_CTLR_KMEM */
> +	return 0;
> +}

Ok this only duplicates the kmalloc arrays. Why not the others?

> @@ -2331,7 +2350,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
>  			continue;
>  		}
>
> -		if (!strcmp(pc->name, name)) {
> +		if (!memcg && !strcmp(pc->name, name)) {
>  			printk(KERN_ERR
>  			       "kmem_cache_create: duplicate cache %s\n", name);
>  			dump_stack();

This implementation means that duplicate cache detection will no longer
work within a cgroup?

> @@ -2543,7 +2564,12 @@ kmem_cache_create (const char *name, size_t size, size_t align,
>  	cachep->ctor = ctor;
>  	cachep->name = name;
>
> +	if (g_cpucache_up >= FULL)
> +		mem_cgroup_register_cache(memcg, cachep);

What happens if a cgroup was active during creation of slab xxy but
then a process running in a different cgroup uses that slab to allocate
memory? Is it charged to the first cgroup?
