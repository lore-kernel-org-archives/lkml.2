Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab2A3FcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 00:32:06 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33759 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2A3FcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 00:32:04 -0500
Message-ID: <1327901519.2891.4.camel@edumazet-laptop>
Subject: Re: Bad SSD performance with recent kernels
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Wu Fengguang <wfg@linux.intel.com>, Herbert Poetzl <herbert@13thfloor.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Date: Mon, 30 Jan 2012 06:31:59 +0100
In-Reply-To: <CANejiEW86b7btiOcVFF3qVhqU1t6FRosvgfiydWwU5zgeDFOqw@mail.gmail.com>
References: <20120127060034.GG29272@MAIL.13thfloor.at>
	 <20120128125108.GA9661@localhost> <1327757611.7199.6.camel@edumazet-laptop>
	 <20120129055917.GB8513@localhost>
	 <1327831380.14602.6.camel@edumazet-laptop>
	 <20120129111645.GA5839@localhost> <1327842831.2718.2.camel@edumazet-laptop>
	 <20120129161058.GA13156@localhost>
	 <CANejiEW86b7btiOcVFF3qVhqU1t6FRosvgfiydWwU5zgeDFOqw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 30 janvier 2012 à 11:17 +0800, Shaohua Li a écrit :

> 1M block size is slow, I guess it's CPU related.
> 
> And as for the big regression with newer kernel than 2.6.38, please
> check if idle=poll
> helps. CPU idle dramatically impacts disk performance and even latest
> cpuidle governor
> doesn't help for some CPUs.
> 

No change with idle=poll

# echo 3 >/proc/sys/vm/drop_caches ;perf record dd if=/dev/sda
of=/dev/null bs=2M count=2048
2048+0 enregistrements lus
2048+0 enregistrements écrits
4294967296 octets (4,3 GB) copiés, 27,6942 s, 155 MB/s
[ perf record: Woken up 3 times to write data ]
[ perf record: Captured and wrote 0.884 MB perf.data (~38630 samples) ]

# perf report
Events: 22K
cycles                                                              
 40,14%  dd  [kernel.kallsyms]  [k] copy_user_generic_string
  3,12%  dd  [kernel.kallsyms]  [k] native_read_tsc
  3,00%  dd  [kernel.kallsyms]  [k] put_page
  2,98%  dd  [kernel.kallsyms]  [k] iowrite8
  2,04%  dd  [kernel.kallsyms]  [k] get_page_from_freelist
  1,87%  dd  [kernel.kallsyms]  [k] delay_tsc
  1,77%  dd  [kernel.kallsyms]  [k] kmem_cache_alloc
  1,69%  dd  [kernel.kallsyms]  [k] __mem_cgroup_commit_charge
  1,52%  dd  [kernel.kallsyms]  [k] submit_bh
  1,38%  dd  [kernel.kallsyms]  [k] ioread8
  1,32%  dd  [kernel.kallsyms]  [k] __rmqueue
  1,29%  dd  [kernel.kallsyms]  [k] block_read_full_page
  1,28%  dd  [kernel.kallsyms]  [k] __ticket_spin_lock
  1,23%  dd  [kernel.kallsyms]  [k] __slab_alloc
  1,15%  dd  [kernel.kallsyms]  [k] file_read_actor
  0,85%  dd  [kernel.kallsyms]  [k] generic_make_request.part.51
  0,84%  dd  [kernel.kallsyms]  [k] __alloc_pages_nodemask
  0,82%  dd  [kernel.kallsyms]  [k] create_empty_buffers
  0,81%  dd  [kernel.kallsyms]  [k] get_partial_node
  0,81%  dd  [kernel.kallsyms]  [k] lookup_page_cgroup
  0,78%  dd  [kernel.kallsyms]  [k] mem_cgroup_add_lru_list.part.45
  0,72%  dd  [kernel.kallsyms]  [k] ____pagevec_lru_add_fn

# echo 3 >/proc/sys/vm/drop_caches ;perf record dd if=/dev/sda
of=/dev/null bs=1M count=4096
4096+0 enregistrements lus
4096+0 enregistrements écrits
4294967296 octets (4,3 GB) copiés, 25,8117 s, 166 MB/s
[ perf record: Woken up 3 times to write data ]
[ perf record: Captured and wrote 0.810 MB perf.data (~35398 samples) ]

# perf report
Events: 20K
cycles                                                              
 31,91%  dd  [kernel.kallsyms]  [k] copy_user_generic_string
  3,87%  dd  [kernel.kallsyms]  [k] native_read_tsc
  3,58%  dd  [kernel.kallsyms]  [k] iowrite8
  2,43%  dd  [kernel.kallsyms]  [k] put_page
  2,30%  dd  [kernel.kallsyms]  [k] delay_tsc
  2,09%  dd  [kernel.kallsyms]  [k] get_page_from_freelist
  1,96%  dd  [kernel.kallsyms]  [k] __mem_cgroup_commit_charge
  1,79%  dd  [kernel.kallsyms]  [k] submit_bh
  1,75%  dd  [kernel.kallsyms]  [k] kmem_cache_alloc
  1,74%  dd  [kernel.kallsyms]  [k] ioread8
  1,68%  dd  [kernel.kallsyms]  [k] block_read_full_page
  1,62%  dd  [kernel.kallsyms]  [k] __ticket_spin_lock
  1,38%  dd  [kernel.kallsyms]  [k] __rmqueue
  1,12%  dd  [kernel.kallsyms]  [k] create_empty_buffers
  1,08%  dd  [kernel.kallsyms]  [k] __slab_alloc
  1,07%  dd  [kernel.kallsyms]  [k] file_read_actor
  1,06%  dd  [kernel.kallsyms]  [k] generic_make_request.part.51
  0,94%  dd  [kernel.kallsyms]  [k] lookup_page_cgroup
  0,85%  dd  [kernel.kallsyms]  [k] __alloc_pages_nodemask
  0,85%  dd  [kernel.kallsyms]  [k] find_get_page
  0,83%  dd  [kernel.kallsyms]  [k] __lru_cache_add
  0,81%  dd  [kernel.kallsyms]  [k] add_to_page_cache_locked.part.29


# echo 3 >/proc/sys/vm/drop_caches ;perf record dd if=/dev/sda
of=/dev/null bs=128k count=32768
32768+0 enregistrements lus
32768+0 enregistrements écrits
4294967296 octets (4,3 GB) copiés, 19,6924 s, 218 MB/s
[ perf record: Woken up 3 times to write data ]
[ perf record: Captured and wrote 0.961 MB perf.data (~41992 samples) ]

# perf report
 29,85%  dd  [kernel.kallsyms]  [k] copy_user_generic_string
  2,61%  dd  [kernel.kallsyms]  [k] __mem_cgroup_commit_charge
  2,53%  dd  [kernel.kallsyms]  [k] get_page_from_freelist
  2,27%  dd  [kernel.kallsyms]  [k] block_read_full_page
  1,99%  dd  [kernel.kallsyms]  [k] __ticket_spin_lock
  1,81%  dd  [kernel.kallsyms]  [k] kmem_cache_alloc
  1,65%  dd  [kernel.kallsyms]  [k] file_read_actor
  1,60%  dd  [kernel.kallsyms]  [k] __rmqueue
  1,58%  dd  [kernel.kallsyms]  [k] put_page
  1,51%  dd  [kernel.kallsyms]  [k] submit_bh
  1,37%  dd  [kernel.kallsyms]  [k] create_empty_buffers
  1,30%  dd  [kernel.kallsyms]  [k] generic_make_request.part.51
  1,09%  dd  [kernel.kallsyms]  [k] __alloc_pages_nodemask
  1,06%  dd  [kernel.kallsyms]  [k] do_generic_file_read.constprop.35
  1,01%  dd  [kernel.kallsyms]  [k] lookup_page_cgroup
  1,00%  dd  [kernel.kallsyms]  [k] add_to_page_cache_locked.part.29
  0,93%  dd  [kernel.kallsyms]  [k] find_get_page
  0,92%  dd  [kernel.kallsyms]  [k] blk_rq_map_sg
  0,92%  dd  [kernel.kallsyms]  [k] radix_tree_insert
  0,89%  dd  [kernel.kallsyms]  [k] alloc_pages_current
  0,88%  dd  [kernel.kallsyms]  [k] mem_cgroup_add_lru_list.part.45
  0,88%  dd  [kernel.kallsyms]  [k] radix_tree_lookup_element



