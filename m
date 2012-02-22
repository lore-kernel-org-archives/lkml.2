Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab2BVNRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:17:40 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:52709 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752374Ab2BVNRX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:17:23 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of penberg@gmail.com designates 10.60.21.134 as permitted sender) smtp.mail=penberg@gmail.com; dkim=pass header.i=penberg@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120222115320.GA3107@x61.redhat.com>
References: <20120222115320.GA3107@x61.redhat.com>
Date: Wed, 22 Feb 2012 15:17:23 +0200
X-Google-Sender-Auth: _g_OQj8QPhvCvAnxXB27PgXSi4U
Message-ID: <CAOJsxLGz4=2tFQdnnFmGLeFVVPq8pX5=0var7V-9+ddi=TPNVA@mail.gmail.com>
Subject: Re: [PATCH] oom: add sysctl to enable slab memory dump
From: Pekka Enberg <penberg@kernel.org>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-mm@kvack.org, Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, Rik van Riel <riel@redhat.com>,
        Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 1:53 PM, Rafael Aquini <aquini@redhat.com> wrote:
> Adds a new sysctl, 'oom_dump_slabs', that enables the kernel to produce a
> dump of all eligible system slab caches when performing an OOM-killing.
> Information includes per cache active objects, total objects, object size,
> cache name and cache size.
>
> The eligibility for being reported is given by an auxiliary sysctl,
> 'oom_dump_slabs_ratio', which express (in percentage) the memory committed
> ratio between a particular cache size and the total slab size.
>
> This, alongside with all other data dumped in OOM events, is very helpful
> information in diagnosing why there was an OOM condition specially when
> kernel code is under investigation.
>
> Signed-off-by: Rafael Aquini <aquini@redhat.com>

Makes sense. Do you have an example how an out-of-memory slab cache
dump looks like?

> diff --git a/mm/slab.c b/mm/slab.c
> index f0bd785..c2b5d14 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -4629,3 +4629,75 @@ size_t ksize(const void *objp)
>        return obj_size(virt_to_cache(objp));
>  }
>  EXPORT_SYMBOL(ksize);
> +
> +/**
> + * oom_dump_slabs - dump top slab cache users
> + * @ratio: memory committed ratio between a cache size and the total slab size
> + *
> + * Dumps the current memory state of all eligible slab caches.
> + * State information includes cache's active objects, total objects,
> + * object size, cache name, and cache size.
> + */
> +void oom_dump_slabs(int ratio)
> +{
> +       struct kmem_cache *cachep;
> +       struct kmem_list3 *l3;
> +       struct slab *slabp;
> +       unsigned long active_objs, num_objs, free_objects, cache_size;
> +       unsigned long active_slabs, num_slabs, slab_total_mem;
> +       int node;

[snip]

> +       list_for_each_entry(cachep, &cache_chain, next) {
> +               num_objs = 0;
> +               num_slabs = 0;
> +               active_objs = 0;
> +               free_objects = 0;
> +               active_slabs = 0;

Minor style nit: just define the zeroed variables in this block.

> +
> +               for_each_online_node(node) {
> +                       l3 = cachep->nodelists[node];
> +                       if (!l3)
> +                               continue;
> +void oom_dump_slabs(int ratio)
> +{
> +       unsigned long cache_size, slab_total_mem;
> +       unsigned long nr_objs, nr_free, nr_inuse;
> +       struct kmem_cache *cachep;
> +       int node;
> +
> +       slab_total_mem = (global_page_state(NR_SLAB_RECLAIMABLE) +
> +                       global_page_state(NR_SLAB_UNRECLAIMABLE)) << PAGE_SHIFT;
> +
> +       if (ratio < 0)
> +               ratio = 0;
> +
> +       if (ratio > 100)
> +               ratio = 100;
> +
> +       pr_info("--- oom_dump_slabs:\n");
> +       pr_info("<active_objs>    <num_objs>     <objsize>  <cache_name>\n");
> +       down_read(&slub_lock);
> +       list_for_each_entry(cachep, &slab_caches, list) {
> +               nr_objs = 0;
> +               nr_free = 0;

ditto.

> +
> +               for_each_online_node(node) {
> +                       struct kmem_cache_node *n = get_node(cachep, node);
> +                       if (!n)
> +                               continue;
> +
