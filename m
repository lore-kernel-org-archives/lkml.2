Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab2A1M4Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 07:56:16 -0500
Received: from mga14.intel.com ([143.182.124.37]:10525 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913Ab2A1M4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 07:56:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100648774"
Date: Sat, 28 Jan 2012 20:51:08 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: Herbert Poetzl <herbert@13thfloor.at>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Bad SSD performance with recent kernels
Message-ID: <20120128125108.GA9661@localhost>
References: <20120127060034.GG29272@MAIL.13thfloor.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120127060034.GG29272@MAIL.13thfloor.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Herbert,

On Fri, Jan 27, 2012 at 07:00:34AM +0100, Herbert Poetzl wrote:
> 
> Dear Community!
> 
> Recently I decided to update the kernel on a Dell Laptop to
> a more recent version than 2.6.38.x, but experienced bad
> I/O performance with the new kernel, so I started to dig
> a little deeper and ended up with the following test:
> 
>   1) download and extract kernel (on 2.6.38.8)
>   2) make defconfig
>   3) make localmodconfig
>   4) make
>   5) make modules_install install
> 
> Then I booted each kernel in single user and ran the following
> test script:
> 
>   echo noop >/sys/class/block/sda/queue/scheduler
>   for n in 1 2 3; do sync; echo $n > /proc/sys/vm/drop_caches; done
>   /usr/bin/time -f "real = %e, user = %U, sys = %S, %P cpu" \
>         ionice -c0 nice -20 \
>         dd if=/dev/sda of=/dev/null bs=1M count=20480
> 
>   echo deadline >/sys/class/block/sda/queue/scheduler
>   for n in 1 2 3; do sync; echo $n > /proc/sys/vm/drop_caches; done
>   /usr/bin/time -f "real = %e, user = %U, sys = %S, %P cpu" \
>         ionice -c0 nice -20 \
>         dd if=/dev/sda of=/dev/null bs=1M count=20480
> 
>   echo cfq >/sys/class/block/sda/queue/scheduler
>   for n in 1 2 3; do sync; echo $n > /proc/sys/vm/drop_caches; done
>   /usr/bin/time -f "real = %e, user = %U, sys = %S, %P cpu" \
>         ionice -c0 nice -20 \
>         dd if=/dev/sda of=/dev/null bs=1M count=20480
> 
> 
> note that the Laptop is a relatively modern Latitude E6400
> with a Samsung 830 Series 256GB SSD
> 
> here are the surprising results:
> 
> @ linux 2.6.38.8
>   248 MB/s  real = 86.74, user = 0.01, sys = 21.65, 24% cpu
>   248 MB/s  real = 86.81, user = 0.02, sys = 21.75, 25% cpu
>   251 MB/s  real = 85.63, user = 0.01, sys = 22.24, 25% cpu
> 
> @ linux 2.6.39.4
>  49.0 MB/s  real = 438.79, user = 0.01, sys = 19.79, 4% cpu
>  25.7 MB/s  real = 836.70, user = 0.02, sys = 18.39, 2% cpu
>  27.7 MB/s  real = 776.53, user = 0.01, sys = 16.03, 2% cpu
> 
> @ linux 3.0.18
>  48.9 MB/s  real = 439.07, user = 0.01, sys = 17.55, 4% cpu
>  25.0 MB/s  real = 859.03, user = 0.01, sys = 16.97, 1% cpu
>  49.8 MB/s  real = 431.61, user = 0.01, sys = 16.68, 3% cpu
> 
> @ linux 3.1.10
>  54.0 MB/s  real = 398.23, user = 0.01, sys = 17.36, 4% cpu
>  29.4 MB/s  real = 731.47, user = 0.01, sys = 17.14, 2% cpu
>  25.0 MB/s  real = 859.35, user = 0.01, sys = 14.51, 1% cpu
> 
> @ linux 3.2.2
>  45.8 MB/s  real = 468.85, user = 0.01, sys = 17.11, 3% cpu
>  44.8 MB/s  real = 478.92, user = 0.01, sys = 17.02, 3% cpu
>  45.0 MB/s  real = 476.91, user = 0.01, sys = 16.14, 3% cpu

Thanks for the through tests! However I cannot reproduce the regressions,
but see slightly better performance in 3.2:

Linux lkp-nex04 3.2.0-rc7-shli+ #121 SMP Thu Jan 19 18:10:45 CST 2012 x86_64 x86_64 x86_64 GNU/Linux

21474836480 bytes (21 GB) copied, 90.9307 s, 236 MB/s real = 91.03, user = 0.01, sys = 25.80, 28% cpu
21474836480 bytes (21 GB) copied, 90.8864 s, 236 MB/s real = 90.90, user = 0.01, sys = 25.54, 28% cpu
21474836480 bytes (21 GB) copied, 93.4684 s, 230 MB/s real = 93.47, user = 0.02, sys = 25.12, 26% cpu


Linux lkp-nex04 2.6.38 #334 SMP Sat Jan 28 20:16:25 CST 2012 x86_64 GNU/Linux

21474836480 bytes (21 GB) copied, 96.2382 s, 223 MB/s real = 96.29, user = 0.01, sys = 57.64, 59% cpu
21474836480 bytes (21 GB) copied, 96.5796 s, 222 MB/s real = 96.60, user = 0.02, sys = 58.08, 60% cpu
21474836480 bytes (21 GB) copied, 95.486  s, 225 MB/s real = 95.51, user = 0.00, sys = 58.20, 60% cpu

My test box has 64GB memory and a dozen 80GB INTEL SSDSA2M080G2GN SSD drives attached to

87:00.0 Serial Attached SCSI controller: LSI Logic / Symbios Logic SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 02)

> I have no idea why the I/O performance is that bad on any
> kernel newer than 2.6.38.x, but I'm happy to test and/or
> try various configurations as time permits ...

Would you please create a filesystem and large file on sda and run the
tests on the file? There was some performance bug on reading the raw
/dev/sda device file..

> The detailed test results as well as the dmesg and config
> of each kernel can be found here:
> http://vserver.13thfloor.at/Stuff/SSD

It would be better for such files be attached in future.
(For one thing I get timeout when trying to open the link...)

Thanks,
Fengguang

> here some technical information:
> 
> http://www.dell.com/us/dfb/p/latitude-e6400/pd
> SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03)
> 
> http://www.samsung.com/uk/consumer/memory-cards-hdd-odd/ssd/ssd/MZ-7PC256N/EU-spec
> Model=SAMSUNG SSD 830 Series, FwRev=CXM03B1Q
> supposed 520MB/s seq. read, 320MB/s seq. write, 75K IOPS
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
