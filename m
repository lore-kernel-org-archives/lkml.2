Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab2IQWP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 18:15:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab2IQWPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 18:15:53 -0400
Date: Mon, 17 Sep 2012 15:15:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v10 3/5] virtio_balloon: introduce migration primitives
 to balloon pages
Message-Id: <20120917151552.ffbb9293.akpm@linux-foundation.org>
In-Reply-To: <39738cbd4b596714210e453440833db7cca73172.1347897793.git.aquini@redhat.com>
References: <cover.1347897793.git.aquini@redhat.com>
	<39738cbd4b596714210e453440833db7cca73172.1347897793.git.aquini@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2012 13:38:18 -0300
Rafael Aquini <aquini@redhat.com> wrote:

> Memory fragmentation introduced by ballooning might reduce significantly
> the number of 2MB contiguous memory blocks that can be used within a guest,
> thus imposing performance penalties associated with the reduced number of
> transparent huge pages that could be used by the guest workload.
> 
> Besides making balloon pages movable at allocation time and introducing
> the necessary primitives to perform balloon page migration/compaction,
> this patch also introduces the following locking scheme, in order to
> enhance the syncronization methods for accessing elements of struct
> virtio_balloon, thus providing protection against concurrent access
> introduced by parallel memory compaction threads.
> 
>  - balloon_lock (mutex) : synchronizes the access demand to elements of
>                           struct virtio_balloon and its queue operations;
>  - pages_lock (spinlock): special protection to balloon's pages bookmarking
>                           elements (list and atomic counters) against the
>                           potential memory compaction concurrency;
> 
>
> ...
>
>  struct virtio_balloon
>  {
> @@ -46,11 +48,24 @@ struct virtio_balloon
>  	/* The thread servicing the balloon. */
>  	struct task_struct *thread;
>  
> +	/* balloon special page->mapping */
> +	struct address_space *mapping;
> +
> +	/* Synchronize access/update to this struct virtio_balloon elements */
> +	struct mutex balloon_lock;
> +
>  	/* Waiting for host to ack the pages we released. */
>  	wait_queue_head_t acked;
>  
> +	/* Protect pages list, and pages bookeeping counters */
> +	spinlock_t pages_lock;
> +
> +	/* Number of balloon pages isolated from 'pages' list for compaction */
> +	unsigned int num_isolated_pages;

Is it utterly inconceivable that this counter could exceed 4G, ever?

>  	/* Number of balloon pages we've told the Host we're not using. */
>  	unsigned int num_pages;
> +
>  	/*
>  	 * The pages we've told the Host we're not using.
>  	 * Each page on this list adds VIRTIO_BALLOON_PAGES_PER_PAGE
> @@ -60,7 +75,7 @@ struct virtio_balloon
>  
>  	/* The array of pfns we tell the Host about. */
>  	unsigned int num_pfns;
> -	u32 pfns[256];
> +	u32 pfns[VIRTIO_BALLOON_ARRAY_PFNS_MAX];
>  
>  	/* Memory statistics */
>  	int need_stats_update;
> @@ -122,13 +137,17 @@ static void set_page_pfns(u32 pfns[], struct page *page)
>  
>  static void fill_balloon(struct virtio_balloon *vb, size_t num)
>  {
> +	/* Get the proper GFP alloc mask from vb->mapping flags */
> +	gfp_t vb_gfp_mask = mapping_gfp_mask(vb->mapping);
> +
>  	/* We can only do one array worth at a time. */
>  	num = min(num, ARRAY_SIZE(vb->pfns));
>  
> +	mutex_lock(&vb->balloon_lock);
>  	for (vb->num_pfns = 0; vb->num_pfns < num;
>  	     vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE) {
> -		struct page *page = alloc_page(GFP_HIGHUSER | __GFP_NORETRY |
> -					__GFP_NOMEMALLOC | __GFP_NOWARN);
> +		struct page *page = alloc_page(vb_gfp_mask | __GFP_NORETRY |
> +					       __GFP_NOWARN | __GFP_NOMEMALLOC);

That looks like an allocation which could easily fail.

>  		if (!page) {
>  			if (printk_ratelimit())
>  				dev_printk(KERN_INFO, &vb->vdev->dev,

Strangely, we suppressed the core page allocator's warning and
substituted this less useful one.

Also, it would be nice if someone could get that printk_ratelimit() out
of there, for reasons described at the printk_ratelimit() definition
site.

> @@ -139,9 +158,15 @@ static void fill_balloon(struct virtio_balloon *vb, size_t num)
>  			break;
>  		}
>  		set_page_pfns(vb->pfns + vb->num_pfns, page);
> -		vb->num_pages += VIRTIO_BALLOON_PAGES_PER_PAGE;
>  		totalram_pages--;
> +
> +		BUG_ON(!trylock_page(page));
> +		spin_lock(&vb->pages_lock);
>  		list_add(&page->lru, &vb->pages);
> +		assign_balloon_mapping(page, vb->mapping);
> +		vb->num_pages += VIRTIO_BALLOON_PAGES_PER_PAGE;
> +		spin_unlock(&vb->pages_lock);
> +		unlock_page(page);
>  	}
>
> ...
>

