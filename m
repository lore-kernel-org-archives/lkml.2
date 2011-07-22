Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab1GVISo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 04:18:44 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:59197 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab1GVISm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 04:18:42 -0400
Date: Fri, 22 Jul 2011 10:19:03 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: agk@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: request baset device mapper in Linux
Message-ID: <20110722081903.GB7561@ics.muni.cz>
References: <20110720082640.GZ7561@ics.muni.cz>
 <4E280964.6070000@ct.jp.nec.com>
 <20110721132627.GY7561@ics.muni.cz>
 <4E291F28.2040609@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E291F28.2040609@ct.jp.nec.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Muni-Spam-TestIP: 147.251.17.147
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 22 Jul 2011 10:18:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 03:56:40PM +0900, Kiyoshi Ueda wrote:
> > in total, it seems that *whole* bio list is traversed again and again as some parts
> > are done and some not which leads to comlexity O(n^2) with respect to number
> > of bio and segments. But this is just wild guess. The real problem could be
> > elsewhere.
> > 
> > However, oprofile or sysprof show that ksoftirq spends most time in
> > __blk_recalc_rq_segments().
> 
> Thank you very much for the detailed explanation.
> Now, I understand what you mentioned except below:
> 
> > ksoftirqd eats 100% CPU as soon as all available memory is used for buffers.
> 
> If the slow down is caused only by lack of CPU power, memory usage
> should not matter here.
> Don't you see 100% CPU of ksoftirqd (nor the slow down) if you use
> a fewer size than memory size? (e.g. 500[MB] for each dd)

if data transfered by dd fits into memory (e.g., I transfer those 500MB in
each dd), I have no problem. ksoftirqd mostly sleeps.

The problem arises as soon as there is no more free memory for buffers. (those
buffers reported by 'top' for instance)

> > The problem with overloading ksoftirqd has roots in request based
> > stuff in dm layer, in particular in dm_softirq_done() call. 
> 
> Is that your actual trace result?
> end_clone_bio(), which seems taking much time, is called
> in the context of SCSI's softirq.
> So if you really see that dm_softirq_done() is taking a time,
> there may be other problems, too.

the real trace is hard to catch. I have traces using oprofile or sysprof, but
the call sequence is randomized as the calls are too fast for sample based
profilers.

this is trace from sysprof but it is not in exact order: (and percetage is not
accurate and is across whole system, ksoftirqd runs at 100% CPU according to
top).

  [ksoftirqd/0]                        0.00%  33.45%
    - - kernel - -                     0.00%  33.45%
      __blk_recalc_rq_segments        16.61%  16.61%
      _spin_unlock_irqrestore          6.17%   6.17%
      kmem_cache_free                  2.21%   2.21%
      blk_update_request               1.78%   1.80%
      end_buffer_async_read            1.40%   1.40%
      mempool_free                     0.85%   0.91%
      end_clone_bio                    0.80%   0.82%
      end_bio_bh_io_sync               0.07%   0.79%
      req_bio_endio                    0.41%   0.41%
      bio_put                          0.32%   0.33%
      bio_free                         0.31%   0.31%
      unlock_page                      0.20%   0.21%
      bio_endio                        0.14%   0.20%
      disk_map_sector_rcu              0.19%   0.19%
      __wake_up_bit                    0.15%   0.15%
      dm_rq_bio_destructor             0.09%   0.11%
      __wake_page_waiters              0.10%   0.10%
      blk_recalc_rq_segments           0.09%   0.10%
      child_rip                        0.00%   0.08%
      mempool_free_slab                0.03%   0.07%
      page_waitqueue                   0.06%   0.06%
      bio_fs_destructor                0.05%   0.05%
      multipath_end_io                 0.05%   0.05%
      scsi_finish_command              0.04%   0.04%
      dm_softirq_done                  0.03%   0.04%
      blk_done_softirq                 0.02%   0.03%
      scsi_softirq_done                0.03%   0.03%
      add_disk_randomness              0.03%   0.03%
      __wake_up                        0.03%   0.03%
      blk_rq_unprep_clone              0.02%   0.02%
      blk_end_request_all              0.02%   0.02%
      __sg_free_table                  0.02%   0.02%
      scsi_handle_queue_ramp_up        0.01%   0.01%
      kref_get                         0.01%   0.01%
      scsi_decide_disposition          0.01%   0.01%
      scsi_next_command                0.01%   0.01%
      rq_completed                     0.01%   0.01%
      blk_end_bidi_request             0.01%   0.01%
      kobject_get                      0.01%   0.01%
      __inet_lookup_established        0.01%   0.01%
      kref_put                         0.01%   0.01%
      scsi_pool_free_command           0.01%   0.01%
      scsi_run_queue                   0.01%   0.01%
      sd_done                          0.01%   0.01%
      add_timer_randomness             0.01%   0.01%
 
> >>     - each request contains more then 100 bios which makes serious
> >>       troubles for ksoftirqd call backs.
> >>         * What do you mean the "serious troubles for ksoftirqd call backs"?
> > 
> > serious troubles means that ksoftirqd eats 100% CPU and slows down I/O
> > significantly (from 2.8GB/s to 500MB/s).
> 
> OK, at least, request-based device-mapper eats more CPU/memory resources
> than bio-based device-mapper due to the design which clones bio, too,
> not only request.
> So I think you need more CPUs on such environments which have lots of devices,
> or you may be able to work around by splitting each request to shorter size
> as you mentioned.
> (How many CPUs do you have and how fast are those CPUs?
>  I just tried, but no such phenomenon can be seen on the environment
>  of 10 (FC) devices and 1 CPU (Xeon(R) E5205 1.86[GHz]).)

I have E5640  @ 2.67GHz with 16 cores (8 real cores with HT).

10 devices is not enough. I cannot preproduce it with just 10 devices. At
least 20 is necessary. 
 
-- 
Luká¹ Hejtmánek
