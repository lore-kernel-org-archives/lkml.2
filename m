Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab1L0Cub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 21:50:31 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:40848 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab1L0CuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 21:50:25 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 80.237.6.56
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1++mZz5cp5k8pn8bygOqoLyA/w2Uq0DC2I=
Message-ID: <1324954208.4634.2.camel@hakkenden.homenet>
Subject: Re: Kswapd in 3.2.0-rc5 is a CPU hog
From: "Nikolay S." <nowhere@hakkenden.ath.cx>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Dave Chinner <david@fromorbit.com>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Tue, 27 Dec 2011 06:50:08 +0400
In-Reply-To: <20111227111543.5e486eb7.kamezawa.hiroyu@jp.fujitsu.com>
References: <1324437036.4677.5.camel@hakkenden.homenet>
	 <20111221095249.GA28474@tiehlicka.suse.cz> <20111221225512.GG23662@dastard>
	 <1324630880.562.6.camel@rybalov.eng.ttk.net>
	 <20111223102027.GB12731@dastard>
	 <1324638242.562.15.camel@rybalov.eng.ttk.net>
	 <20111223204503.GC12731@dastard>
	 <20111227111543.5e486eb7.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Вт., 27/12/2011 в 11:15 +0900, KAMEZAWA Hiroyuki пишет:
> On Sat, 24 Dec 2011 07:45:03 +1100
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Fri, Dec 23, 2011 at 03:04:02PM +0400, nowhere wrote:
> > > В Пт., 23/12/2011 в 21:20 +1100, Dave Chinner пишет:
> > > > On Fri, Dec 23, 2011 at 01:01:20PM +0400, nowhere wrote:
> > > > > В Чт., 22/12/2011 в 09:55 +1100, Dave Chinner пишет:
> > > > > > On Wed, Dec 21, 2011 at 10:52:49AM +0100, Michal Hocko wrote:
> 
> > > Here is the report of trace-cmd while dd'ing
> > > https://80.237.6.56/report-dd.xz
> > 
> > Ok, it's not a shrink_slab() problem - it's just being called ~100uS
> > by kswapd. The pattern is:
> > 
> > 	- reclaim 94 (batches of 32,32,30) pages from iinactive list
> > 	  of zone 1, node 0, prio 12
> > 	- call shrink_slab
> > 		- scan all caches
> > 		- all shrinkers return 0 saying nothing to shrink
> > 	- 40us gap
> > 	- reclaim 10-30 pages from inactive list of zone 2, node 0, prio 12
> > 	- call shrink_slab
> > 		- scan all caches
> > 		- all shrinkers return 0 saying nothing to shrink
> > 	- 40us gap
> > 	- isolate 9 pages from LRU zone ?, node ?, none isolated, none freed
> > 	- isolate 22 pages from LRU zone ?, node ?, none isolated, none freed
> > 	- call shrink_slab
> > 		- scan all caches
> > 		- all shrinkers return 0 saying nothing to shrink
> > 	40us gap
> > 
> > And it just repeats over and over again. After a while, nid=0,zone=1
> > drops out of the traces, so reclaim only comes in batches of 10-30
> > pages from zone 2 between each shrink_slab() call.
> > 
> > The trace starts at 111209.881s, with 944776 pages on the LRUs. It
> > finishes at 111216.1 with kswapd going to sleep on node 0 with
> > 930067 pages on the LRU. So 7 seconds to free 15,000 pages (call it
> > 2,000 pages/s) which is awfully slow....
> > 
> > vmscan gurus - time for you to step in now...
> >
>  
> Can you show /proc/zoneinfo ? I want to know each zone's size.

$ cat /proc/zoneinfo 
Node 0, zone      DMA
  pages free     3980
        min      64
        low      80
        high     96
        scanned  0
        spanned  4080
        present  3916
    nr_free_pages 3980
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 0
    nr_active_file 0
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    0
    nr_file_pages 0
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 0
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_vmscan_immediate_reclaim 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     0
    nr_dirtied   0
    nr_written   0
    nr_anon_transparent_hugepages 0
        protection: (0, 3503, 4007, 4007)
  pagesets
    cpu: 0
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
    cpu: 1
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
  all_unreclaimable: 1
  start_pfn:         16
  inactive_ratio:    1
Node 0, zone    DMA32
  pages free     19620
        min      14715
        low      18393
        high     22072
        scanned  0
        spanned  1044480
        present  896960
    nr_free_pages 19620
    nr_inactive_anon 43203
    nr_active_anon 206577
    nr_inactive_file 412249
    nr_active_file 126151
    nr_unevictable 7
    nr_mlock     7
    nr_anon_pages 108557
    nr_mapped    6683
    nr_file_pages 540415
    nr_dirty     5
    nr_writeback 0
    nr_slab_reclaimable 58887
    nr_slab_unreclaimable 12145
    nr_page_table_pages 1389
    nr_kernel_stack 100
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 1021
    nr_vmscan_immediate_reclaim 69337
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     1861
    nr_dirtied   1586363
    nr_written   1245872
    nr_anon_transparent_hugepages 272
        protection: (0, 0, 504, 504)
  pagesets
    cpu: 0
              count: 4
              high:  186
              batch: 31
  vm stats threshold: 24
    cpu: 1
              count: 0
              high:  186
              batch: 31
  vm stats threshold: 24
  all_unreclaimable: 0
  start_pfn:         4096
  inactive_ratio:    5
Node 0, zone   Normal
  pages free     2854
        min      2116
        low      2645
        high     3174
        scanned  0
        spanned  131072
        present  129024
    nr_free_pages 2854
    nr_inactive_anon 20682
    nr_active_anon 10262
    nr_inactive_file 47083
    nr_active_file 11292
    nr_unevictable 518
    nr_mlock     518
    nr_anon_pages 22801
    nr_mapped    1798
    nr_file_pages 58853
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 4347
    nr_slab_unreclaimable 5955
    nr_page_table_pages 769
    nr_kernel_stack 128
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 5285
    nr_vmscan_immediate_reclaim 51475
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     28
    nr_dirtied   251597
    nr_written   191561
    nr_anon_transparent_hugepages 16
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 30
              high:  186
              batch: 31
  vm stats threshold: 12
    cpu: 1
              count: 0
              high:  186
              batch: 31
  vm stats threshold: 12
  all_unreclaimable: 0
  start_pfn:         1048576
  inactive_ratio:

> 
> Below is my memo.
> 
> In trace log, priority = 11 or 12. Then, I think kswapd can reclaim memory
> to satisfy "sc.nr_reclaimed >= SWAP_CLUSTER_MAX" condition and loops again.
> 
> Seeing balance_pgdat() and trace log, I guess it does
> 
> 	wake up
> 
> 	shrink_zone(zone=0(DMA?))     => nothing to reclaim.
> 		shrink_slab()
> 	shrink_zone(zone=1(DMA32?))   => reclaim 32,32,31 pages 
> 		shrink_slab()
> 	shrink_zone(zone=2(NORMAL?))  => reclaim 13 pages. 
> 		srhink_slab()
> 
> 	sleep or retry.
> 
> Why shrink_slab() need to be called frequently like this ?
> 
> BTW. I'm sorry if I miss something ...Why only kswapd reclaims memory
> while 'dd' operation ? (no direct relcaim by dd.)
> Is this log record cpu hog after 'dd' ?

report-dd.xz is while_ dd.
report-normal.xz - some time after

> Thanks,
> -Kame
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 


