Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab0KJP0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:26:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756582Ab0KJP0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:26:30 -0500
Date: Wed, 10 Nov 2010 17:26:08 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org
Subject: Re: [2.6.37-rc1, OOM] virtblk: OOM in do_virtblk_request()
Message-ID: <20101110152607.GB3891@redhat.com>
References: <20101105013003.GE13830@dastard>
 <20101110133151.GB2101@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110133151.GB2101@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 08:31:51AM -0500, Christoph Hellwig wrote:
> On Fri, Nov 05, 2010 at 12:30:03PM +1100, Dave Chinner wrote:
> > Folks,
> > 
> > Running an IO test with lots of concurrent metadata modifications
> > and IO under memory pressure, I hit this OOM report:
> > 
> > [  367.866979] xfsbufd/vdb: page allocation failure. order:0, mode:0x20
> > [  367.868030] Pid: 2145, comm: xfsbufd/vdb Not tainted 2.6.36-dgc+ #634
> > [  367.868030] Call Trace:
> > [  367.868030]  [<ffffffff811204ee>] __alloc_pages_nodemask+0x65e/0x760
> > [  367.868030]  [<ffffffff811585f2>] kmem_getpages+0x62/0x160
> > [  367.868030]  [<ffffffff8115960f>] fallback_alloc+0x18f/0x270
> > [  367.868030]  [<ffffffff8115939b>] ____cache_alloc_node+0x9b/0x180
> > [  367.868030]  [<ffffffff811592bc>] ? cache_alloc_refill+0x21c/0x260
> > [  367.868030]  [<ffffffff8115999b>] __kmalloc+0x1cb/0x240
> > [  367.868030]  [<ffffffff8172b891>] ? virtqueue_add_buf_gfp+0x221/0x410
> > [  367.868030]  [<ffffffff8172b891>] virtqueue_add_buf_gfp+0x221/0x410
> > [  367.868030]  [<ffffffff81696771>] ? blk_rq_map_sg+0x81/0x2d0
> > [  367.868030]  [<ffffffff81888333>] do_virtblk_request+0x1f3/0x400
> > [  367.868030]  [<ffffffff8168ef1a>] __generic_unplug_device+0x3a/0x50
> > [  367.868030]  [<ffffffff8168b1ee>] elv_insert+0x8e/0x1b0
> > [  367.868030]  [<ffffffff8168b35a>] __elv_add_request+0x4a/0x90
> > [  367.868030]  [<ffffffff81691cf0>] __make_request+0x120/0x500
> > [  367.868030]  [<ffffffff81159c44>] ? kmem_cache_alloc+0xb4/0x1e0
> > [  367.868030]  [<ffffffff8168fb16>] generic_make_request+0x266/0x550
> > [  367.868030]  [<ffffffff8111b985>] ? mempool_alloc_slab+0x15/0x20
> > [  367.868030]  [<ffffffff814a9989>] ? xfs_buf_delwri_split+0x1a9/0x1c0
> > [  367.868030]  [<ffffffff81063779>] ? kvm_clock_read+0x19/0x20
> > [  367.868030]  [<ffffffff8168fe65>] submit_bio+0x65/0xe0
> > [  367.868030]  [<ffffffff814a915c>] _xfs_buf_ioapply+0x18c/0x360
> > [  367.868030]  [<ffffffff814ababd>] ? xfs_bdstrat_cb+0x5d/0xb0
> > [  367.868030]  [<ffffffff814ab62f>] xfs_buf_iorequest+0x4f/0xd0
> > [  367.868030]  [<ffffffff814ababd>] xfs_bdstrat_cb+0x5d/0xb0
> > [  367.868030]  [<ffffffff814abe5f>] xfsbufd+0x10f/0x190
> > [  367.868030]  [<ffffffff814abd50>] ? xfsbufd+0x0/0x190
> > [  367.868030]  [<ffffffff810a6f16>] kthread+0xa6/0xb0
> > [  367.868030]  [<ffffffff8103ae64>] kernel_thread_helper+0x4/0x10
> > [  367.868030]  [<ffffffff81b10f90>] ? restore_args+0x0/0x30
> > [  367.868030]  [<ffffffff810a6e70>] ? kthread+0x0/0xb0
> > [  367.868030]  [<ffffffff8103ae60>] ? kernel_thread_helper+0x0/0x10
> > [  367.868030] Mem-Info:
> > [  367.868030] Node 0 DMA per-cpu:
> > [  367.868030] CPU    0: hi:    0, btch:   1 usd:   0
> > [  367.868030] CPU    1: hi:    0, btch:   1 usd:   0
> > [  367.868030] CPU    2: hi:    0, btch:   1 usd:   0
> > [  367.868030] CPU    3: hi:    0, btch:   1 usd:   0
> > [  367.868030] CPU    4: hi:    0, btch:   1 usd:   0
> > [  367.868030] CPU    5: hi:    0, btch:   1 usd:   0
> > [  367.868030] CPU    6: hi:    0, btch:   1 usd:   0
> > [  367.868030] CPU    7: hi:    0, btch:   1 usd:   0
> > [  367.868030] Node 0 DMA32 per-cpu:
> > [  367.868030] CPU    0: hi:  186, btch:  31 usd:   0
> > [  367.868030] CPU    1: hi:  186, btch:  31 usd:  23
> > [  367.868030] CPU    2: hi:  186, btch:  31 usd:   0
> > [  367.868030] CPU    3: hi:  186, btch:  31 usd:   0
> > [  367.868030] CPU    4: hi:  186, btch:  31 usd:   0
> > [  367.868030] CPU    5: hi:  186, btch:  31 usd:   0
> > [  367.868030] CPU    6: hi:  186, btch:  31 usd:   0
> > [  367.868030] CPU    7: hi:  186, btch:  31 usd:   0
> > [  367.868030] Node 0 Normal per-cpu:
> > [  367.868030] CPU    0: hi:  186, btch:  31 usd:   0
> > [  367.868030] CPU    1: hi:  186, btch:  31 usd:   0
> > [  367.868030] CPU    2: hi:  186, btch:  31 usd:   0
> > [  367.868030] CPU    3: hi:  186, btch:  31 usd:   0
> > [  367.868030] CPU    4: hi:  186, btch:  31 usd:   0
> > [  367.868030] CPU    5: hi:  186, btch:  31 usd:   0
> > [  367.868030] CPU    6: hi:  186, btch:  31 usd:   0
> > [  367.868030] CPU    7: hi:  186, btch:  31 usd:   0
> > [  367.868030] active_anon:19790 inactive_anon:4264 isolated_anon:0
> > [  367.868030]  active_file:19793 inactive_file:36538 isolated_file:32
> > [  367.868030]  unevictable:0 dirty:0 writeback:0 unstable:0
> > [  367.868030]  free:0 slab_reclaimable:795356 slab_unreclaimable:118472
> > [  367.868030]  mapped:180 shmem:22 pagetables:523 bounce:0
> > [  367.868030] Node 0 DMA free:0kB min:28kB low:32kB high:40kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:14804kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15684kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:4kB slab_unreclaimable:1024kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1828 all_unreclaimable? no
> > [  367.868030] lowmem_reserve[]: 0 3512 4017 4017
> > [  367.868030] Node 0 DMA32 free:0kB min:7076kB low:8844kB high:10612kB active_anon:77920kB inactive_anon:15648kB active_file:65824kB inactive_file:109788kB unevictable:0kB isolated(anon):0kB isolated(file):128kB present:3596500kB mlocked:0kB dirty:0kB writeback:0kB mapped:236kB shmem:0kB slab_reclaimable:2866144kB slab_unreclaimable:409596kB kernel_stack:80kB pagetables:372kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:26652 all_unreclaimable? no
> > [  367.868030] lowmem_reserve[]: 0 0 505 505
> > [  367.868030] Node 0 Normal free:0kB min:1016kB low:1268kB high:1524kB active_anon:1240kB inactive_anon:1408kB active_file:13348kB inactive_file:21560kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:517120kB mlocked:0kB dirty:0kB writeback:0kB mapped:484kB shmem:88kB slab_reclaimable:315276kB slab_unreclaimable:63268kB kernel_stack:1176kB pagetables:1720kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:5375 all_unreclaimable? no
> > [  367.868030] lowmem_reserve[]: 0 0 0 0
> > [  367.868030] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
> > [  367.868030] Node 0 DMA32: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
> > [  367.868030] Node 0 Normal: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
> > [  367.868030] 56938 total pagecache pages
> > [  367.868030] 388 pages in swap cache
> > [  367.868030] Swap cache stats: add 16495, delete 16107, find 524/722
> > [  367.868030] Free swap  = 443928kB
> > [  367.868030] Total swap = 497976kB
> > [  367.868030] 1048560 pages RAM
> > [  367.868030] 41977 pages reserved
> > [  367.868030] 51560 pages shared
> > [  367.868030] 949431 pages non-shared

Since indirect is just an optimization, I guess we could replace
GFP_ATOMIC with __GFP_NOWARN, log our own error ...
Not sure whether this is a good idea, really.

> > Basically, the system is _completely_ out of free pages, and failing
> > allocations in the XFS metadata writeback path that could free up
> > memory.
> > 
> > I note that the code path in question in the virtio driver is doing
> > GFP_ATOMIC allocations for the indirect ring structures.  However,
> > these allocations are not backed by a mempool and hence the system
> > OOMs rather than makes slow progress. Shouldn't this path be using a
> > mempool?
> > 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> ---end quoted text---


> Rusty, Michael,
> 
> any comments?  I think Dave's observation is correct, and the lack of
> a mempool for allocations in the virtio stack is a no-go for virtio_blk.
> 

I'm not so sure :) Basically for add_buf to fail it's not enough to run out
of atomic memory: we use the queue directly as a fallback.
For that to fail queue must be full, in which case with time
requests will get completed, and we'll be able to make progress.

Am I mssing something?

However, I long thought that adding a small memory cache for indirect
buffers might help performance generally. As an alternative we could
less devices supply their own memory pool.

-- 
MST
