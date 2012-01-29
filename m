Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab2A2L0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 06:26:51 -0500
Received: from mga14.intel.com ([143.182.124.37]:44926 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab2A2L0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 06:26:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100828033"
Date: Sun, 29 Jan 2012 19:16:45 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Bad SSD performance with recent kernels
Message-ID: <20120129111645.GA5839@localhost>
References: <20120127060034.GG29272@MAIL.13thfloor.at>
 <20120128125108.GA9661@localhost>
 <1327757611.7199.6.camel@edumazet-laptop>
 <20120129055917.GB8513@localhost>
 <1327831380.14602.6.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1327831380.14602.6.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 29, 2012 at 11:03:00AM +0100, Eric Dumazet wrote:
> Le dimanche 29 janvier 2012 à 13:59 +0800, Wu Fengguang a écrit :
> 
> > What's the block size? If it's < 4k, performance might be hurt.
> > 
> >         blockdev --getbsz /dev/sda
> > 
> 
> # blockdev --getbsz /dev/sda
> 4096

OK, it's normal value.

> > > FYI, I started a bisection.
> > 
> > Thank you! If the bisection would take much human time, it should be
> > easier to collect some blktrace data on reading /dev/sda for analyzes.
> > 
> 
> Very strange, my bissection ended on following commit :
> 
> commit 805f6b5e1cbfedfb9b3d354013e7f4b13a79270f
> Author: Tao Ma <boyu.mt@taobao.com>
> Date:   Fri Mar 11 20:11:59 2011 +0100
> 
>     blktrace: Use rq->cmd_flags directly in blk_add_trace_rq.
> 
> 
> 
> This makes no sense.

Yup.

> hdparm uses 2MB block reads, so read_ahead (128KB) is too small for best
> perf

Right. In another thread, we are considering raising the default
readahead size to 1MB.

Note that as long as buffered read(2) is used, it makes almost no
difference (well, at least for now) to do "dd bs=128k" or "dd bs=2MB":
the 128kb readahead size will be used underneath to submit read IO.

> # cat /sys/class/block/sda/queue/read_ahead_kb
> 128
> 
> # dd if=/dev/sda of=/dev/null bs=128k 
> ^C
> 63744+0 enregistrements lus
> 63743+0 enregistrements écrits
> 8354922496 octets (8,4 GB) copiés, 39,975 s, 209 MB/s
> 
> # hdparm -t /dev/sda
> 
> /dev/sda:
>  Timing buffered disk reads: 510 MB in  3.00 seconds = 169.75 MB/sec

Interesting, hdparm gets lower throughput than dd.

> # uname -a
> Linux edumazet-laptop 3.0.0-15-generic #26-Ubuntu SMP Fri Jan 20
> 17:23:00 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

Thanks,
Fengguang

