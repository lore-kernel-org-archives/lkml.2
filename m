Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab2FMUhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 16:37:25 -0400
Received: from tru75-7-88-161-131-83.fbx.proxad.net ([88.161.131.83]:50276
	"EHLO next.fork.zz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752231Ab2FMUhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 16:37:23 -0400
Message-ID: <4FD8F9F1.2000205@free.fr>
Date: Wed, 13 Jun 2012 22:37:05 +0200
From: Wallak <wallak@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120604 Firefox/12.0 SeaMonkey/2.9.1
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-kernel@vger.kernel.org, jweiner@redhat.com
Subject: Re: File copy is very slow on linux-3.4.2 (or linux-3.3x) on a specific
 hardware: AMD FX-8150 + 990FX (solved?)
References: <1108815600.134531433.1339443818361.JavaMail.root@zimbra44-e7.priv.proxad.net> <437497008.134549481.1339444456294.JavaMail.root@zimbra44-e7.priv.proxad.net> <20120612165357.GI6021@quack.suse.cz> <4FD78CE4.4000209@free.fr> <20120612210947.GB20007@quack.suse.cz> <4FD7C595.202@free.fr> <20120613065313.GA25425@quack.suse.cz>
In-Reply-To: <20120613065313.GA25425@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
> On Wed 13-06-12 00:41:25, Wallak wrote:
>> Jan Kara wrote:
>>> On Tue 12-06-12 20:39:32, Wallak wrote:
>>>> Jan Kara wrote:
>>>>> On Mon 11-06-12 21:54:16, wallak@free.fr wrote:
>>>>>> I've a very annoying issue on recent kernel (linux-3.4.2-SMP) with my main motherboard (AMD FX-8150 + 990FX - 8 cores 4.1GHz), file copy is very slow (see below). The same kernel works flawlessly on an AMD E450 2 cores motherboard.
>>>>>>
>>>>>> Linux-3.2.20 works properly on this hardware.
>>>>>> hdparm -t gives good results on both kernels.
>>>>>>
>>>>>> I've no idea where this bug come from. Do you have this issue on your hardware ? A patch is available ?
>>>>>>
>>>>>>
>>>>>> *linux-3.4.2
>>>>>> dd if=../in/file_8gb.tmp of=tmp.tmp bs=1024k count=100
>>>>>> 100+0 records in
>>>>>> 100+0 records out
>>>>>> 104857600 bytes (105 MB) copied, 132.884 s, 789 kB/s
>>>>>>
>>>>>>
>>>>>> *linux-3.2.20
>>>>>> dd if=../in/file_8gb.tmp of=tmp.tmp bs=1024k count=100
>>>>>> 100+0 records in
>>>>>> 100+0 records out
>>>>>> 104857600 bytes (105 MB) copied, 3.30793 s, 31.7 MB/s
>>>>>    So let's separate reading and writing part first. What is the speed of
>>>>> dd if=../in/file_8gb.tmp of=/dev/null bs=1M count=100
>>>>>    on both kernels?
>>>>> And what is the speed of:
>>>>> dd if=/dev/zero of=tmp.tm bs=1M count=100
>>>> You're right, the issue is only while writing. The results are below:
>>>>
>>>> #linux-3.4.2
>>>> dd if=/dev/zero of=tmp.tm bs=1M count=100
>>>> 100+0 records in
>>>> 100+0 records out
>>>> 104857600 bytes (105 MB) copied, 151.347 s, 693 kB/s
>>>> dd if=../in/file_8gb.tmp of=/dev/null bs=1M count=100
>>>> 100+0 records in
>>>> 100+0 records out
>>>> 104857600 bytes (105 MB) copied, 1.26228 s, 83.1 MB/s
>>>>
>>>> #linux-3.2.20
>>>> dd if=/dev/zero of=tmp.tm bs=1M count=100
>>>> 100+0 records in
>>>> 100+0 records out
>>>> 104857600 bytes (105 MB) copied, 1.00838 s, 104 MB/s
>>>> dd if=../in/file_8gb.tmp of=/dev/null bs=1M count=100
>>>> 100+0 records in
>>>> 100+0 records out
>>>> 104857600 bytes (105 MB) copied, 1.26947 s, 82.6 MB/s
>>>>
>>>>
>>>>>    Also what filesystems are you using?
>>>> This is an ext2 file system:
>>>>
>>>> /dev/sda6      ext2    464463364 323380956 141082408  70% /backup
>>>    OK, I'm surprised by one thing - how come the writes do no end up cached
>>> in memory (thus you should get much higher throughput). Is the filesystem
>>> mounted with -o sync option by any chance?
>>>
>>> 								Honza
>>      I've tried with an nfs mounted drive, the issue is still there,
>> it seems to be global. With sync enabled, the output is quite
>> faster, that's quite unexpected.
>> On my AMD E450 motherboard this kernel works fine - Are you able to
>> reproduce this behavior ?
>>
>>
>> #/dev/sda6 /backup ext2 rw,relatime,errors=continue 0 0
>> (/proc/mount)
>> 100+0 records in
>> 100+0 records out
>> 104857600 bytes (105 MB) copied, 155.407 s, 675 kB/s
>>
>> #/dev/sda6 /backup ext2 rw,sync,relatime,errors=continue 0 0
>> 100+0 records in
>> 100+0 records out
>> 104857600 bytes (105 MB) copied, 69.7868 s, 1.5 MB/s
>>
>> #nfs drive - same issue:
>> 100+0 records in
>> 100+0 records out
>> 104857600 bytes (105 MB) copied, 221.572 s, 473 kB/s
>    That's really curious. I have not seen your issue although I use current
> kernels for development&  testing a lot. Also if it was some generic issue
> with 3.4 I'm pretty sure we would have heard *much* more complaints from
> other users as well. So I think it must be something specific to your setup
> / kernel config.

I've bisected the linux kernel, and I've found the commit that is 
related to this issue:
commit ab8fabd46f811d5153d8a0cd2fac9a0d41fb593d
Author: Johannes Weiner <jweiner@redhat.com>
Date:   Tue Jan 10 15:07:42 2012 -0800

     mm: exclude reserved pages from dirtyable memory

     Per-zone dirty limits try to distribute page cache pages allocated for
     writing across zones in proportion to the individual zone sizes, to 
reduce
     the likelihood of reclaim having to write back individual pages 
from the
     LRU lists in order to make progress.

     This patch:

     The amount of dirtyable pages should not include the full number of 
free
     pages: there is a number of reserved pages that the page allocator and
     kswapd always try to keep free.

     The closer (reclaimable pages - dirty pages) is to the number of 
reserved
     pages, the more likely it becomes for reclaim to run into dirty pages:

            +----------+ ---
            |   anon   |  |
            +----------+  |
            |          |  |
            |          |  -- dirty limit new    -- flusher new
            |   file   |  |                     |
            |          |  |                     |
            |          |  -- dirty limit old    -- flusher old
            |          |                        |
            +----------+                       --- reclaim
            | reserved |
            +----------+
            |  kernel  |
            +----------+

     This patch introduces a per-zone dirty reserve that takes both the 
lowmem
     reserve as well as the high watermark of the zone into account, and a
     global sum of those per-zone values that is subtracted from the global
     amount of dirtyable pages.  The lowmem reserve is unavailable to page
     cache allocations and kswapd tries to keep the high watermark free.  We
     don't want to end up in a situation where reclaim has to clean pages in
     order to balance zones.

     Not treating reserved pages as dirtyable on a global level is only a
     conceptual fix.  In reality, dirty pages are not distributed equally
     across zones and reclaim runs into dirty pages on a regular basis.

     But it is important to get this right before tackling the problem on a
     per-zone level, where the distance between reclaim and the dirty 
pages is
     mostly much smaller in absolute numbers.

     [akpm@linux-foundation.org: fix highmem build]
     Signed-off-by: Johannes Weiner <jweiner@redhat.com>
     Reviewed-by: Rik van Riel <riel@redhat.com>
     Reviewed-by: Michal Hocko <mhocko@suse.cz>
     Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
     Acked-by: Mel Gorman <mgorman@suse.de>
     Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
     Cc: Christoph Hellwig <hch@infradead.org>
     Cc: Wu Fengguang <fengguang.wu@intel.com>
     Cc: Dave Chinner <david@fromorbit.com>
     Cc: Jan Kara <jack@suse.cz>
     Cc: Shaohua Li <shaohua.li@intel.com>
     Cc: Chris Mason <chris.mason@oracle.com>
     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Reversing this patch solve my problem. But, I don't know, at this time, 
why it only affect one of my motherboard:
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ca6ca92..3ac040f 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -317,12 +317,6 @@ struct zone {
       */
      unsigned long        lowmem_reserve[MAX_NR_ZONES];

-    /*
-     * This is a per-zone reserve of pages that should not be
-     * considered dirtyable memory.
-     */
-    unsigned long        dirty_balance_reserve;
-
  #ifdef CONFIG_NUMA
      int node;
      /*
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 06061a7..1e22e12 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -207,7 +207,6 @@ struct swap_list_t {
  /* linux/mm/page_alloc.c */
  extern unsigned long totalram_pages;
  extern unsigned long totalreserve_pages;
-extern unsigned long dirty_balance_reserve;
  extern unsigned int nr_free_buffer_pages(void);
  extern unsigned int nr_free_pagecache_pages(void);

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 9ab6de8..c081bf6 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -157,7 +157,7 @@ static unsigned long 
highmem_dirtyable_memory(unsigned long total)
&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];

          x += zone_page_state(z, NR_FREE_PAGES) +
-             zone_reclaimable_pages(z) - z->dirty_balance_reserve;
+             zone_reclaimable_pages(z);
      }
      /*
       * Make sure that the number of highmem pages is never larger
@@ -181,8 +181,7 @@ static unsigned long determine_dirtyable_memory(void)
  {
      unsigned long x;

-    x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages() -
-        dirty_balance_reserve;
+    x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();

      if (!vm_highmem_is_dirtyable)
          x -= highmem_dirtyable_memory(x);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2cb9eb7..93baebc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -97,14 +97,6 @@ EXPORT_SYMBOL(node_states);

  unsigned long totalram_pages __read_mostly;
  unsigned long totalreserve_pages __read_mostly;
-/*
- * When calculating the number of globally allowed dirty pages, there
- * is a certain number of per-zone reserves that should not be
- * considered dirtyable memory.  This is the sum of those reserves
- * over all existing zones that contribute dirtyable memory.
- */
-unsigned long dirty_balance_reserve __read_mostly;
-
  int percpu_pagelist_fraction;
  gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;

@@ -4830,19 +4822,8 @@ static void calculate_totalreserve_pages(void)
              if (max > zone->present_pages)
                  max = zone->present_pages;
              reserve_pages += max;
-            /*
-             * Lowmem reserves are not available to
-             * GFP_HIGHUSER page cache allocations and
-             * kswapd tries to balance zones to their high
-             * watermark.  As a result, neither should be
-             * regarded as dirtyable memory, to prevent a
-             * situation where reclaim has to clean pages
-             * in order to balance the zones.
-             */
-            zone->dirty_balance_reserve = max;
          }
      }
-    dirty_balance_reserve = reserve_pages;
      totalreserve_pages = reserve_pages;
  }

--- a/mm/page-writeback.c.orig    2012-06-13 21:38:14.000000000 +0200
+++ b/mm/page-writeback.c    2012-06-13 21:44:01.000000000 +0200
@@ -276,8 +276,8 @@
       * care about vm_highmem_is_dirtyable here.
       */
      return zone_page_state(zone, NR_FREE_PAGES) +
-           zone_reclaimable_pages(zone) -
-           zone->dirty_balance_reserve;
+           zone_reclaimable_pages(zone) /* -
+                           zone->dirty_balance_reserve */;
  }

  /**


/proc/meminfo & /proc/vmstat while dd running - Dirty remains 0 while 
using the buggy kernel.
bad                                                                                                       
ok
----                                                                    
                                    -----
nr_free_pages 2042201                                         | 
nr_free_pages 1733212
nr_inactive_anon 0                                            | 
nr_inactive_anon 116
nr_active_anon 6436                                           | 
nr_active_anon 8273
nr_inactive_file 9861                                         | 
nr_inactive_file 307823
nr_active_file 3112                                           | 
nr_active_file 3922
nr_unevictable 0                                                
nr_unevictable 0
nr_mlock 0                                                      nr_mlock 0
nr_anon_pages 6436                                            | 
nr_anon_pages 8277
nr_mapped 1845                                                | 
nr_mapped 4679
nr_file_pages 13057                                           | 
nr_file_pages 311928
nr_dirty 38                                                   | nr_dirty 
4131
nr_writeback 155                                              | 
nr_writeback 2821
nr_slab_reclaimable 1058                                      | 
nr_slab_reclaimable 5986
nr_slab_unreclaimable 3598                                    | 
nr_slab_unreclaimable 4038
nr_page_table_pages 149                                       | 
nr_page_table_pages 211
nr_kernel_stack 127                                           | 
nr_kernel_stack 135
nr_unstable 0                                                   
nr_unstable 0
nr_bounce 110                                                 | 
nr_bounce 2691
nr_vmscan_write 0                                               
nr_vmscan_write 0
nr_vmscan_immediate_reclaim 0                                   
nr_vmscan_immediate_reclaim 0
nr_writeback_temp 0                                             
nr_writeback_temp 0
nr_isolated_anon 0                                              
nr_isolated_anon 0
nr_isolated_file 0                                              
nr_isolated_file 0
nr_shmem 0                                                    | nr_shmem 116
nr_dirtied 17912                                              | 
nr_dirtied 300319
nr_written 18606                                              | 
nr_written 293452
nr_anon_transparent_hugepages 0                                 
nr_anon_transparent_hugepages 0
nr_dirty_threshold 0                                          | 
nr_dirty_threshold 8335
nr_dirty_background_threshold 0                               | 
nr_dirty_background_threshold 4167
pgpgin 41736                                                  | pgpgin 69995
pgpgout 67533                                                 | pgpgout 
1183424
pswpin 0                                                        pswpin 0
pswpout 0                                                       pswpout 0
pgalloc_dma 1                                                   
pgalloc_dma 1
pgalloc_normal 140044                                         | 
pgalloc_normal 445472
pgalloc_high 149275                                           | 
pgalloc_high 454258
pgalloc_movable 0                                               
pgalloc_movable 0
pgfree 2332411                                                | pgfree 
2633864
pgactivate 3141                                               | 
pgactivate 3959
pgdeactivate 0                                                  
pgdeactivate 0
pgfault 741532                                                | pgfault 
761639
pgmajfault 327                                                | 
pgmajfault 543
pgrefill_dma 0                                                  
pgrefill_dma 0
pgrefill_normal 0                                               
pgrefill_normal 0
pgrefill_high 0                                                 
pgrefill_high 0
pgrefill_movable 0                                              
pgrefill_movable 0
pgsteal_kswapd_dma 0                                            
pgsteal_kswapd_dma 0
pgsteal_kswapd_normal 0                                         
pgsteal_kswapd_normal 0
pgsteal_kswapd_high 0                                           
pgsteal_kswapd_high 0
pgsteal_kswapd_movable 0                                        
pgsteal_kswapd_movable 0
pgsteal_direct_dma 0                                            
pgsteal_direct_dma 0
pgsteal_direct_normal 0                                         
pgsteal_direct_normal 0
pgsteal_direct_high 0                                           
pgsteal_direct_high 0
pgsteal_direct_movable 0                                        
pgsteal_direct_movable 0
pgscan_kswapd_dma 0                                             
pgscan_kswapd_dma 0
pgscan_kswapd_normal 0                                          
pgscan_kswapd_normal 0
pgscan_kswapd_high 0                                            
pgscan_kswapd_high 0
pgscan_kswapd_movable 0                                         
pgscan_kswapd_movable 0
pgscan_direct_dma 0                                             
pgscan_direct_dma 0
pgscan_direct_normal 0                                          
pgscan_direct_normal 0
pgscan_direct_high 0                                            
pgscan_direct_high 0
pgscan_direct_movable 0                                         
pgscan_direct_movable 0
pginodesteal 0                                                  
pginodesteal 0
slabs_scanned 0                                                 
slabs_scanned 0
kswapd_inodesteal 0                                             
kswapd_inodesteal 0
kswapd_low_wmark_hit_quickly 0                                  
kswapd_low_wmark_hit_quickly 0
kswapd_high_wmark_hit_quickly 0                                 
kswapd_high_wmark_hit_quickly 0
kswapd_skip_congestion_wait 0                                   
kswapd_skip_congestion_wait 0
pageoutrun 1                                                    pageoutrun 1
allocstall 0                                                    allocstall 0
pgrotated 0                                                     pgrotated 0
unevictable_pgs_culled 0                                        
unevictable_pgs_culled 0
unevictable_pgs_scanned 0                                       
unevictable_pgs_scanned 0
unevictable_pgs_rescued 0                                       
unevictable_pgs_rescued 0
unevictable_pgs_mlocked 0                                       
unevictable_pgs_mlocked 0
unevictable_pgs_munlocked 0                                     
unevictable_pgs_munlocked 0
unevictable_pgs_cleared 0                                       
unevictable_pgs_cleared 0
unevictable_pgs_stranded 0                                      
unevictable_pgs_stranded 0
unevictable_pgs_mlockfreed 0                                    
unevictable_pgs_mlockfreed 0
MemTotal:        8282200 kB                                     
MemTotal:        8282200 kB
MemFree:         8174468 kB                                   | 
MemFree:         6376360 kB
Buffers:            4316 kB                                   | 
Buffers:            7440 kB
Cached:            42732 kB                                   | 
Cached:          1786284 kB
SwapCached:            0 kB                                     
SwapCached:            0 kB
Active:            38192 kB                                   | 
Active:            49332 kB
Inactive:          34376 kB                                   | 
Inactive:        1777372 kB
Active(anon):      25744 kB                                   | 
Active(anon):      33100 kB
Inactive(anon):        0 kB                                   | 
Inactive(anon):      464 kB
Active(file):      12448 kB                                   | 
Active(file):      16232 kB
Inactive(file):    34376 kB                                   | 
Inactive(file):  1776908 kB
Unevictable:           0 kB                                     
Unevictable:           0 kB
Mlocked:               0 kB                                     
Mlocked:               0 kB
HighTotal:       8052692 kB                                     
HighTotal:       8052692 kB
HighFree:        7978664 kB                                   | 
HighFree:        6227412 kB
LowTotal:         229508 kB                                     
LowTotal:         229508 kB
LowFree:          195804 kB                                   | 
LowFree:          148948 kB
SwapTotal:        530140 kB                                     
SwapTotal:        530140 kB
SwapFree:         530140 kB                                     
SwapFree:         530140 kB
Dirty:                 0 kB                                   | 
Dirty:             11544 kB
Writeback:           668 kB                                   | 
Writeback:         12856 kB
AnonPages:         25744 kB                                   | 
AnonPages:         33108 kB
Mapped:             7380 kB                                   | 
Mapped:            18716 kB
Shmem:                 0 kB                                   | 
Shmem:               464 kB
Slab:              18552 kB                                   | 
Slab:              49036 kB
SReclaimable:       4152 kB                                   | 
SReclaimable:      32812 kB
SUnreclaim:        14400 kB                                   | 
SUnreclaim:        16224 kB
KernelStack:        1016 kB                                   | 
KernelStack:        1080 kB
PageTables:          596 kB                                   | 
PageTables:          844 kB
NFS_Unstable:          0 kB                                     
NFS_Unstable:          0 kB
Bounce:              156 kB                                   | 
Bounce:            12072 kB
WritebackTmp:          0 kB                                     
WritebackTmp:          0 kB
CommitLimit:     4671240 kB                                     
CommitLimit:     4671240 kB
Committed_AS:     124688 kB                                   | 
Committed_AS:     136864 kB
VmallocTotal:     720896 kB                                     
VmallocTotal:     720896 kB
VmallocUsed:       31288 kB                                     
VmallocUsed:       31288 kB
VmallocChunk:     685044 kB                                     
VmallocChunk:     685044 kB
DirectMap4k:        6136 kB                                     
DirectMap4k:        6136 kB
DirectMap2M:      309248 kB                                     
DirectMap2M:      309248 kB

> Can you run:
> while true; do
>    cat /proc/vmstat
>    echo "---"
>    cat /proc/meminfo
>    echo "------------------"
>    sleep 5
> done>/tmp/vmstat.out

I hope the previous dump will be meaningful by itself.

                                                                         
                                             Wallak.

> while the dd is running and send the output please? Also does the problem
> go away if you run a 64-bit kernel on the machine?
>
> 								Honza

