Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965347Ab0GPMhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 08:37:32 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:52393 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965245Ab0GPMhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:37:31 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/8] zcache: page cache compression support
Date: Fri, 16 Jul 2010 18:07:42 +0530
Message-Id: <1279283870-18549-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frequently accessed filesystem data is stored in memory to reduce access to
(much) slower backing disks. Under memory pressure, these pages are freed and
when needed again, they have to be read from disks again. When combined working
set of all running application exceeds amount of physical RAM, we get extereme
slowdown as reading a page from disk can take time in order of milliseconds.

Memory compression increases effective memory size and allows more pages to
stay in RAM. Since de/compressing memory pages is several orders of magnitude
faster than disk I/O, this can provide signifant performance gains for many
workloads. Also, with multi-cores becoming common, benefits of reduced disk I/O
should easily outweigh the problem of increased CPU usage.

It is implemented as a "backend" for cleancache_ops [1] which provides
callbacks for events such as when a page is to be removed from the page cache
and when it is required again. We use them to implement a 'second chance' cache
for these evicted page cache pages by compressing and storing them in memory
itself.

We only keep pages that compress to PAGE_SIZE/2 or less. Compressed chunks are
stored using xvmalloc memory allocator which is already being used by zram
driver for the same purpose. Zero-filled pages are checked and no memory is
allocated for them.

A separate "pool" is created for each mount instance for a cleancache-aware
filesystem. Each incoming page is identified with <pool_id, inode_no, index>
where inode_no identifies file within the filesystem corresponding to pool_id
and index is offset of the page within this inode. Within a pool, inodes are
maintained in an rb-tree and each of its nodes points to a separate radix-tree
which maintains list of pages within that inode.

While compression reduces disk I/O, it also reduces the space available for
normal (uncompressed) page cache. This can result in more frequent page cache
reclaim and thus higher CPU overhead. Thus, it's important to maintain good hit
rate for compressed cache or increased CPU overhead can nullify any other
benefits. This requires adaptive (compressed) cache resizing and page
replacement policies that can maintain optimal cache size and quickly reclaim
unused compressed chunks. This work is yet to be done. However, in the current
state, it allows manually resizing cache size using (per-pool) sysfs node
'memlimit' which in turn frees any excess pages *sigh* randomly.

Finally, it uses percpu stats and compression buffers to allow better
performance on multi-cores. Still, there are known bottlenecks like a single
xvmalloc mempool per zcache pool and few others. I will work on this when I
start with profiling.

 * Performance numbers:
   - Tested using iozone filesystem benchmark
   - 4 CPUs, 1G RAM
   - Read performance gain: ~2.5X
   - Random read performance gain: ~3X
   - In general, performance gains for every kind of I/O

Test details with graphs can be found here:
http://code.google.com/p/compcache/wiki/zcacheIOzone

If I can get some help with testing, it would be intersting to find its
effect in more real-life workloads. In particular, I'm intersted in finding
out its effect in KVM virtualization case where it can potentially allow
running more number of VMs per-host for a given amount of RAM. With zcache
enabled, VMs can be assigned much smaller amount of memory since host can now
hold bulk of page-cache pages, allowing VMs to maintain similar level of
performance while a greater number of them can be hosted.

 * How to test:
All patches are against 2.6.35-rc5:

 - First, apply all prerequisite patches here:
http://compcache.googlecode.com/hg/sub-projects/zcache_base_patches

 - Then apply this patch series; also uploaded here:
http://compcache.googlecode.com/hg/sub-projects/zcache_patches


Nitin Gupta (8):
  Allow sharing xvmalloc for zram and zcache
  Basic zcache functionality
  Create sysfs nodes and export basic statistics
  Shrink zcache based on memlimit
  Eliminate zero-filled pages
  Compress pages using LZO
  Use xvmalloc to store compressed chunks
  Document sysfs entries

 Documentation/ABI/testing/sysfs-kernel-mm-zcache |   53 +
 drivers/staging/Makefile                         |    2 +
 drivers/staging/zram/Kconfig                     |   22 +
 drivers/staging/zram/Makefile                    |    5 +-
 drivers/staging/zram/xvmalloc.c                  |    8 +
 drivers/staging/zram/zcache_drv.c                | 1312 ++++++++++++++++++++++
 drivers/staging/zram/zcache_drv.h                |   90 ++
 7 files changed, 1491 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-mm-zcache
 create mode 100644 drivers/staging/zram/zcache_drv.c
 create mode 100644 drivers/staging/zram/zcache_drv.h
