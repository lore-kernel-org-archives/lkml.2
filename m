Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab1HPCNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:13:09 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:24279 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751481Ab1HPCNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:13:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhYDAJfRSU55LbABgWdsb2JhbABBqBQVAQEWJiWBQAEBBTocIwULCAMOCi4UJQMhExvBFw6GOQSbTohK
Date: Tue, 16 Aug 2011 12:11:54 +1000
From: Dave Chinner <david@fromorbit.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <jbottomley@parallels.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 3/4] limit nr_dentries per superblock
Message-ID: <20110816021154.GI26978@dastard>
References: <1313334832-1150-1-git-send-email-glommer@parallels.com>
 <1313334832-1150-4-git-send-email-glommer@parallels.com>
 <CAOJsxLFYD9DkEU5R+9fZr-uaznteP8-BUC_Ti+FnNFqtbOCHSw@mail.gmail.com>
 <20110815104656.GG26978@dastard>
 <CAOJsxLGFJmqO-W=itQbO4Mh4DxSD4wrHOC8gQ5bWL5aE1YYeQw@mail.gmail.com>
 <4E48FD8A.90401@parallels.com>
 <CAOJsxLFjZffC9i5kQsBWjGy3eWdj3VMB5awz=yPcwgeKb5BG0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLFjZffC9i5kQsBWjGy3eWdj3VMB5awz=yPcwgeKb5BG0Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 02:14:39PM +0300, Pekka Enberg wrote:
> Hi Pavel,
> 
> On Mon, Aug 15, 2011 at 2:05 PM, Pavel Emelyanov <xemul@parallels.com> wrote:
> > This will make sense, since the kernel memory management per-cgroup is one of the
> > things we'd live to have, but this particular idea will definitely not work in case
> > we keep the containers' files on one partition keeping each container in its own
> > chroot environment.
> 
> And you want a per-container dcache limit? Will the containers share
> the same superblock?

Yes, and that's one of the problems with the "arbitrary container"
approach to controlling the dentry cache size. Arbitrary containers
don't map easily to predictable and scalable LRU and reclaim
implementations. Hence right now the container scope is limited to
per-superblock.

> Couldn't you simply do per-container "struct
> kmem_accounted_cache" in struct superblock?

Probably could do it that way, but it's still not really and
integrated solution. What we'll end up with is this LRU structure:

struct lru_node {
	struct list_head		lru;
	spinlock_t			lock;
	long				nr_items;
} ____cacheline_aligned_in_smp;

struct lru {
	struct kmem_accounted_cache	*cache;
	struct lru_node			lru_node[MAX_NUMNODES];
	nodemask_t			active_nodes;
	int (*isolate_item)(struct list_head *item);
	int (*dispose)(struct list_head *list);
}

Where the only thing that the lru->cache is used for is getting the
number of items allocated to the cache. Seems relatively pointless
to make that statistic abstraction for just a single value that we
can get via a simple per-cpu counter...

Then, when you consider SLUB has this structure for every individual
slab cache:

struct kmem_cache_node {
        spinlock_t list_lock;   /* Protect partial list and nr_partial */
        unsigned long nr_partial;
        struct list_head partial;
#ifdef CONFIG_SLUB_DEBUG
        atomic_long_t nr_slabs;
        atomic_long_t total_objects;
        struct list_head full;
#endif
};

you can see why tight integration of the per-node LRU infrastructure
is appealing - there's no unnecessary duplication and the accounting
is done in the right spot. It also means there is only one shrinker
implmentation for all slabs, with a couple of simple per-slab
callbacks for isolating objects for disposal and then to dispose of
them. This would mean that most slab caches that use shrinkers would
no longer need to implement their own LRU, get LRU scalability and
node-aware reclaim for free, have built in size limits, etc.

And FWIW, integrating the LRU shrinker mechanism into the slab cache
also provides the mechanisms needed for capping the size of the
cache as well as slab defragmentation.  Much smarter things can be
done when you know both the age and the locality of objects. e.g.
there's no point preventing allocation from a slab due to maximum
object count limitations if there are partial pages in the slab
cache because the allocation can be done without increasing memory
footprint.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
