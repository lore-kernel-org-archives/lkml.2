Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab2IUUkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 16:40:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35874 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757807Ab2IUUkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:40:40 -0400
Date: Fri, 21 Sep 2012 13:40:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 15/16] memcg/sl[au]b: shrink dead caches
Message-ID: <20120921204035.GQ7264@google.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
 <1347977530-29755-16-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347977530-29755-16-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Tue, Sep 18, 2012 at 06:12:09PM +0400, Glauber Costa wrote:
> @@ -764,10 +777,21 @@ static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
>  		goto out;
>  	}
>  
> +	/*
> +	 * Because the cache is expected to duplicate the string,
> +	 * we must make sure it has opportunity to copy its full
> +	 * name. Only now we can remove the dead part from it
> +	 */
> +	name = (char *)new_cachep->name;
> +	if (name)
> +		name[strlen(name) - 4] = '\0';

This is kinda nasty.  Do we really need to do this?  How long would a
dead cache stick around?

> diff --git a/mm/slab.c b/mm/slab.c
> index bd9928f..6cb4abf 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3785,6 +3785,8 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp,
>  	}
>  
>  	ac_put_obj(cachep, ac, objp);
> +
> +	kmem_cache_verify_dead(cachep);

Reaping dead caches doesn't exactly sound like a high priority thing
and adding a branch to hot path for that might not be the best way to
do it.  Why not schedule an extremely lazy deferrable delayed_work
which polls for emptiness, say, every miniute or whatever?

Thanks.

-- 
tejun
