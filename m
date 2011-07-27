Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab1G0EcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 00:32:23 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51456 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab1G0EcT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 00:32:19 -0400
MIME-Version: 1.0
In-Reply-To: <1311265730-5324-1-git-send-email-mgorman@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
Date: Wed, 27 Jul 2011 13:32:17 +0900
Message-ID: <CAEwNFnA_OGUYfCQrLCMt9NuU0O0ftWWBB4_Si8NypKyaeuRg2A@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] Reduce filesystem writeback from page reclaim v2
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Fri, Jul 22, 2011 at 1:28 AM, Mel Gorman <mgorman@suse.de> wrote:
> Warning: Long post with lots of figures. If you normally drink coffee
> and you don't have a cup, get one or you may end up with a case of
> keyboard face.
>
> Changelog since v1
>  o Drop prio-inode patch. There is now a dependency that the flusher
>    threads find these dirty pages quickly.
>  o Drop nr_vmscan_throttled counter
>  o SetPageReclaim instead of deactivate_page which was wrong
>  o Add warning to main filesystems if called from direct reclaim context
>  o Add patch to completely disable filesystem writeback from reclaim
>
> Testing from the XFS folk revealed that there is still too much
> I/O from the end of the LRU in kswapd. Previously it was considered
> acceptable by VM people for a small number of pages to be written
> back from reclaim with testing generally showing about 0.3% of pages
> reclaimed were written back (higher if memory was low). That writing
> back a small number of pages is ok has been heavily disputed for
> quite some time and Dave Chinner explained it well;
>
>        It doesn't have to be a very high number to be a problem. IO
>        is orders of magnitude slower than the CPU time it takes to
>        flush a page, so the cost of making a bad flush decision is
>        very high. And single page writeback from the LRU is almost
>        always a bad flush decision.
>
> To complicate matters, filesystems respond very differently to requests
> from reclaim according to Christoph Hellwig;
>
>        xfs tries to write it back if the requester is kswapd
>        ext4 ignores the request if it's a delayed allocation
>        btrfs ignores the request
>
> As a result, each filesystem has different performance characteristics
> when under memory pressure and there are many pages being dirties. In
> some cases, the request is ignored entirely so the VM cannot depend
> on the IO being dispatched.
>
> The objective of this series to to reduce writing of filesystem-backed
> pages from reclaim, play nicely with writeback that is already in
> progress and throttle reclaim appropriately when dirty pages are
> encountered. The assumption is that the flushers will always write
> pages faster than if reclaim issues the IO. The new problem is that
> reclaim has very little control over how long before a page in a
> particular zone or container is cleaned which is discussed later. A
> secondary goal is to avoid the problem whereby direct reclaim splices
> two potentially deep call stacks together.
>
> Patch 1 disables writeback of filesystem pages from direct reclaim
>        entirely. Anonymous pages are still written.
>
> Patches 2-4 add warnings to XFS, ext4 and btrfs if called from
>        direct reclaim. With patch 1, this "never happens" and
>        is intended to catch regressions in this logic in the
>        future.
>
> Patch 5 disables writeback of filesystem pages from kswapd unless
>        the priority is raised to the point where kswapd is considered
>        to be in trouble.
>
> Patch 6 throttles reclaimers if too many dirty pages are being
>        encountered and the zones or backing devices are congested.
>
> Patch 7 invalidates dirty pages found at the end of the LRU so they
>        are reclaimed quickly after being written back rather than
>        waiting for a reclaimer to find them
>
> Patch 8 disables writeback of filesystem pages from kswapd and
>        depends entirely on the flusher threads for cleaning pages.
>        This is potentially a problem if the flusher threads take a
>        long time to wake or are not discovering the pages we need
>        cleaned. By placing the patch last, it's more likely that
>        bisection can catch if this situation occurs and can be
>        easily reverted.
>
> I consider this series to be orthogonal to the writeback work but
> it is worth noting that the writeback work affects the viability of
> patch 8 in particular.
>
> I tested this on ext4 and xfs using fs_mark and a micro benchmark
> that does a streaming write to a large mapping (exercises use-once
> LRU logic) followed by streaming writes to a mix of anonymous and
> file-backed mappings. The command line for fs_mark when botted with
> 512M looked something like
>
> ./fs_mark  -d  /tmp/fsmark-2676  -D  100  -N  150  -n  150  -L  25  -t  1  -S0  -s  10485760
>
> The number of files was adjusted depending on the amount of available
> memory so that the files created was about 3xRAM. For multiple threads,
> the -d switch is specified multiple times.
>
> 3 kernels are tested.
>
> vanilla 3.0-rc6
> kswapdwb-v2r5           patches 1-7
> nokswapdwb-v2r5         patches 1-8
>
> The test machine is x86-64 with an older generation of AMD processor
> with 4 cores. The underlying storage was 4 disks configured as RAID-0
> as this was the best configuration of storage I had available. Swap
> is on a separate disk. Dirty ratio was tuned to 40% instead of the
> default of 20%.
>
> Testing was run with and without monitors to both verify that the
> patches were operating as expected and that any performance gain was
> real and not due to interference from monitors.
>
> I've posted the raw reports for each filesystem at
>
> http://www.csn.ul.ie/~mel/postings/reclaim-20110721
>
> Unfortunately, the volume of data is excessive but here is a partial
> summary of what was interesting for XFS.

Could you clarify the notation?
1P :  1 Processor?
512M: system memory size?
2X , 4X, 16X: the size of files created during test

>
> 512M1P-xfs           Files/s  mean         32.99 ( 0.00%)       35.16 ( 6.18%)       35.08 ( 5.94%)
> 512M1P-xfs           Elapsed Time fsmark           122.54               115.54               115.21
> 512M1P-xfs           Elapsed Time mmap-strm        105.09               104.44               106.12
> 512M-xfs             Files/s  mean         30.50 ( 0.00%)       33.30 ( 8.40%)       34.68 (12.06%)
> 512M-xfs             Elapsed Time fsmark           136.14               124.26               120.33
> 512M-xfs             Elapsed Time mmap-strm        154.68               145.91               138.83
> 512M-2X-xfs          Files/s  mean         28.48 ( 0.00%)       32.90 (13.45%)       32.83 (13.26%)
> 512M-2X-xfs          Elapsed Time fsmark           145.64               128.67               128.67
> 512M-2X-xfs          Elapsed Time mmap-strm        145.92               136.65               137.67
> 512M-4X-xfs          Files/s  mean         29.06 ( 0.00%)       32.82 (11.46%)       33.32 (12.81%)
> 512M-4X-xfs          Elapsed Time fsmark           153.69               136.74               135.11
> 512M-4X-xfs          Elapsed Time mmap-strm        159.47               128.64               132.59
> 512M-16X-xfs         Files/s  mean         48.80 ( 0.00%)       41.80 (-16.77%)       56.61 (13.79%)
> 512M-16X-xfs         Elapsed Time fsmark           161.48               144.61               141.19
> 512M-16X-xfs         Elapsed Time mmap-strm        167.04               150.62               147.83
>



-- 
Kind regards,
Minchan Kim
