Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab1GTXRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 19:17:51 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:3460 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531Ab1GTXRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 19:17:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArADAIJeJ055LCkBgWdsb2JhbABTp2MVAQEWJiXGBg6GLwSjXQ
Date: Thu, 21 Jul 2011 09:17:46 +1000
From: Dave Chinner <david@fromorbit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the final tree (maybe
 vfs tree related)
Message-ID: <20110720231746.GK9359@dastard>
References: <20110720173232.3c7e46d310e2224e459b0ac1@canb.auug.org.au>
 <20110720135524.GW11013@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720135524.GW11013@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 02:55:24PM +0100, Al Viro wrote:
> On Wed, Jul 20, 2011 at 05:32:32PM +1000, Stephen Rothwell wrote:
> > Hi all,
> > 
> > After merging the final tree, today's linux-next build (sparc defconfig)
> > failed like this:
> 
> > And many more similar.  Again, I assume some include files changed.
> > Maybe commit 347727d3f51d ("superblock: introduce per-sb cache shrinker
> > infrastructure") which included linux/mm.h in linux/fs.h ...
> > 
> > I have left this again.
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 1ce9086..e0569e4 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -395,7 +395,7 @@ struct inodes_stat_t {
>  #include <linux/semaphore.h>
>  #include <linux/fiemap.h>
>  #include <linux/rculist_bl.h>
> -#include <linux/mm.h>
> +#include <linux/shrinker.h>
>  #include <linux/atomic.h>
>  
>  #include <asm/byteorder.h>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 9b9777a..e3a1a9e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -15,6 +15,7 @@
>  #include <linux/range.h>
>  #include <linux/pfn.h>
>  #include <linux/bit_spinlock.h>
> +#include <linux/shrinker.h>
>  
>  struct mempolicy;
>  struct anon_vma;
> @@ -1121,45 +1122,6 @@ static inline void sync_mm_rss(struct task_struct *task, struct mm_struct *mm)
>  }
>  #endif
>  
> -/*
> - * This struct is used to pass information from page reclaim to the shrinkers.
> - * We consolidate the values for easier extention later.
> - */
> -struct shrink_control {
> -	gfp_t gfp_mask;
> -
> -	/* How many slab objects shrinker() should scan and try to reclaim */
> -	unsigned long nr_to_scan;
> -};
> -
> -/*
> - * A callback you can register to apply pressure to ageable caches.
> - *
> - * 'sc' is passed shrink_control which includes a count 'nr_to_scan'
> - * and a 'gfpmask'.  It should look through the least-recently-used
> - * 'nr_to_scan' entries and attempt to free them up.  It should return
> - * the number of objects which remain in the cache.  If it returns -1, it means
> - * it cannot do any scanning at this time (eg. there is a risk of deadlock).
> - *
> - * The 'gfpmask' refers to the allocation we are currently trying to
> - * fulfil.
> - *
> - * Note that 'shrink' will be passed nr_to_scan == 0 when the VM is
> - * querying the cache size, so a fastpath for that case is appropriate.
> - */
> -struct shrinker {
> -	int (*shrink)(struct shrinker *, struct shrink_control *sc);
> -	int seeks;	/* seeks to recreate an obj */
> -	long batch;	/* reclaim batch size, 0 = default */
> -
> -	/* These are for internal use */
> -	struct list_head list;
> -	long nr;	/* objs pending delete */
> -};
> -#define DEFAULT_SEEKS 2 /* A good number if you don't know better. */
> -extern void register_shrinker(struct shrinker *);
> -extern void unregister_shrinker(struct shrinker *);
> -
>  int vma_wants_writenotify(struct vm_area_struct *vma);
>  
>  extern pte_t *__get_locked_pte(struct mm_struct *mm, unsigned long addr,
> diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
> new file mode 100644
> index 0000000..790651b
> --- /dev/null
> +++ b/include/linux/shrinker.h
> @@ -0,0 +1,42 @@
> +#ifndef _LINUX_SHRINKER_H
> +#define _LINUX_SHRINKER_H
> +
> +/*
> + * This struct is used to pass information from page reclaim to the shrinkers.
> + * We consolidate the values for easier extention later.
> + */
> +struct shrink_control {
> +	gfp_t gfp_mask;
> +
> +	/* How many slab objects shrinker() should scan and try to reclaim */
> +	unsigned long nr_to_scan;
> +};
> +
> +/*
> + * A callback you can register to apply pressure to ageable caches.
> + *
> + * 'sc' is passed shrink_control which includes a count 'nr_to_scan'
> + * and a 'gfpmask'.  It should look through the least-recently-used
> + * 'nr_to_scan' entries and attempt to free them up.  It should return
> + * the number of objects which remain in the cache.  If it returns -1, it means
> + * it cannot do any scanning at this time (eg. there is a risk of deadlock).
> + *
> + * The 'gfpmask' refers to the allocation we are currently trying to
> + * fulfil.
> + *
> + * Note that 'shrink' will be passed nr_to_scan == 0 when the VM is
> + * querying the cache size, so a fastpath for that case is appropriate.
> + */
> +struct shrinker {
> +	int (*shrink)(struct shrinker *, struct shrink_control *sc);
> +	int seeks;	/* seeks to recreate an obj */
> +	long batch;	/* reclaim batch size, 0 = default */
> +
> +	/* These are for internal use */
> +	struct list_head list;
> +	long nr;	/* objs pending delete */
> +};
> +#define DEFAULT_SEEKS 2 /* A good number if you don't know better. */
> +extern void register_shrinker(struct shrinker *);
> +extern void unregister_shrinker(struct shrinker *);
> +#endif

Yup, that was what I was considering doing to fix it. Thanks, Al.

Acked-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
