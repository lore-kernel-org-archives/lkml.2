Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034Ab1LFIWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 03:22:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49530 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984Ab1LFIWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 03:22:48 -0500
Date: Tue, 6 Dec 2011 00:22:33 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Quick bcache benchmark
Message-ID: <20111206082233.GA19390@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been very remiss in posting benchmarks; this isn't much, but if
anyone has suggestions for what they want I'll see if I can run it.

This is on an old corsair nova - bcache can go something like 10x faster
but this is what I have at home. The profile is still interesting,
though.

The benchmark is 4k random O_DIRECT reads on a 16 gb file, all in cache
- the idea is to push the b+tree.

Also, the backing device is a md raid10 - so that's working, provided
you format your cache with buckets not greater than 1 mb.

root@utumno:/mnt# perf record -afg fio ~/rw4k
randwrite: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=64
fio 1.59
Starting 1 process
Jobs: 1 (f=1): [r] [100.0% done] [69914K/0K /s] [17.7K/0  iops] [eta 00m:00s]
randwrite: (groupid=0, jobs=1): err= 0: pid=1247
  read : io=16384MB, bw=68713KB/s, iops=17178 , runt=244169msec
  cpu          : usr=5.66%, sys=22.93%, ctx=4198688, majf=0, minf=85
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued r/w/d: total=4194367/0/0, short=0/0/0



Run status group 0 (all jobs):
   READ: io=16384MB, aggrb=68712KB/s, minb=70361KB/s, maxb=70361KB/s, mint=244169msec, maxt=244169msec

Disk stats (read/write):
  bcache0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

7.74%             fio  fio                 [.] 0x1d2ed
5.26%         swapper  [kernel.kallsyms]   [k] ahci_interrupt
3.02%         swapper  [kernel.kallsyms]   [k] mwait_idle
2.52%         swapper  [kernel.kallsyms]   [k] _raw_spin_lock_irqsave
1.82%         swapper  [kernel.kallsyms]   [k] ahci_scr_read
1.68%             fio  [kernel.kallsyms]   [k] __bset_search		<- first bcache function
1.37%             fio  [kernel.kallsyms]   [k] __blockdev_direct_IO
1.36%         swapper  [kernel.kallsyms]   [k] irq_entries_start
1.25%         swapper  [kernel.kallsyms]   [k] mix_pool_bytes_extract
1.06%         swapper  [kernel.kallsyms]   [k] kmem_cache_free
0.94%             fio  [kernel.kallsyms]   [k] __switch_to
0.92%             fio  [kernel.kallsyms]   [k] system_call
0.87%         swapper  [kernel.kallsyms]   [k] _raw_spin_unlock_irqrestore
0.84%         swapper  [kernel.kallsyms]   [k] ata_qc_new_init
0.80%             fio  [kernel.kallsyms]   [k] __schedule
0.76%             fio  [kernel.kallsyms]   [k] do_io_submit
0.74%             fio  [kernel.kallsyms]   [k] _raw_spin_lock_irq
0.74%         swapper  [kernel.kallsyms]   [k] _raw_spin_lock
0.73%             fio  [kernel.kallsyms]   [k] ext4_ext_find_extent
0.71%             fio  [kernel.kallsyms]   [k] kmem_cache_alloc
0.70%             fio  [kernel.kallsyms]   [k] read_events
0.65%             fio  libaio.so.1.0.1     [.] 0x665
0.64%         swapper  [kernel.kallsyms]   [k] __schedule
0.63%         swapper  [kernel.kallsyms]   [k] native_sched_clock
0.63%             fio  [kernel.kallsyms]   [k] btree_search_leaf	<- second bcache function
0.62%             fio  [kernel.kallsyms]   [k] bcache_make_request
0.59%         swapper  [kernel.kallsyms]   [k] read_tsc
0.58%             fio  [kernel.kallsyms]   [k] aio_read_evt
0.58%         swapper  [kernel.kallsyms]   [k] select_task_rq_fair
0.57%         swapper  [kernel.kallsyms]   [k] tick_nohz_stop_sched_tick
0.57%             fio  [kernel.kallsyms]   [k] __request_read
0.57%             fio  [kernel.kallsyms]   [k] generic_make_request
0.56%         swapper  [kernel.kallsyms]   [k] sd_prep_fn
0.53%             fio  [kernel.kallsyms]   [k] _raw_spin_lock
0.51%         swapper  [kernel.kallsyms]   [k] __hrtimer_start_range_ns
0.50%             fio  [kernel.kallsyms]   [k] __math_state_restore

Some of the calls to kmem_cache_(free|alloc) are of course from bcache
but it looks to be under 25%.
