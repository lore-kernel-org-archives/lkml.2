Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276Ab2J2P0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:26:46 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38794 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab2J2P0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:26:44 -0400
MIME-Version: 1.0
In-Reply-To: <1350656442-1523-14-git-send-email-glommer@parallels.com>
References: <1350656442-1523-1-git-send-email-glommer@parallels.com>
	<1350656442-1523-14-git-send-email-glommer@parallels.com>
Date: Tue, 30 Oct 2012 00:26:43 +0900
Message-ID: <CAAmzW4MGdj-jL_FJ2Nkoa4Hx8KUDCeVK6HFidYQLauu_0vHhCg@mail.gmail.com>
Subject: Re: [PATCH v5 13/18] memcg/sl[au]b Track all the memcg children of a kmem_cache.
From: JoonSoo Kim <js1304@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        kamezawa.hiroyu@jp.fujitsu.com, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, devel@openvz.org,
        Suleiman Souhlal <suleiman@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/19 Glauber Costa <glommer@parallels.com>:
> +void kmem_cache_destroy_memcg_children(struct kmem_cache *s)
> +{
> +       struct kmem_cache *c;
> +       int i;
> +
> +       if (!s->memcg_params)
> +               return;
> +       if (!s->memcg_params->is_root_cache)
> +               return;
> +
> +       /*
> +        * If the cache is being destroyed, we trust that there is no one else
> +        * requesting objects from it. Even if there are, the sanity checks in
> +        * kmem_cache_destroy should caught this ill-case.
> +        *
> +        * Still, we don't want anyone else freeing memcg_caches under our
> +        * noses, which can happen if a new memcg comes to life. As usual,
> +        * we'll take the set_limit_mutex to protect ourselves against this.
> +        */
> +       mutex_lock(&set_limit_mutex);
> +       for (i = 0; i < memcg_limited_groups_array_size; i++) {
> +               c = s->memcg_params->memcg_caches[i];
> +               if (c)
> +                       kmem_cache_destroy(c);
> +       }
> +       mutex_unlock(&set_limit_mutex);
> +}

It may cause NULL deref.
Look at the following scenario.

1. some memcg slab caches has remained object.
2. start to destroy memcg.
3. schedule_delayed_work(kmem_cache_destroy_work_func, @delay 60hz)
4. all remained object is freed.
5. start to destroy root cache.
6. kmem_cache_destroy makes 's->memcg_params->memcg_caches[i]" NULL!!
7. Start delayed work function.
8. cachep in kmem_cache_destroy_work_func() may be NULL

Thanks.
