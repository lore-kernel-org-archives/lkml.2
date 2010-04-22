Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab0DVUbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:31:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757912Ab0DVUbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:31:32 -0400
Date: Thu, 22 Apr 2010 16:31:23 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       Suresh Jayaraman <sjayaraman@suse.de>
Subject: Re: CFQ read performance regression
Message-ID: <20100422203123.GF3228@redhat.com>
References: <1271420878.24780.145.camel@tucsk.pomaz.szeredi.hu> <h2m4e5e476b1004170546z8997cd90h98ecfb9cc5aad8cf@mail.gmail.com> <1271677562.24780.184.camel@tucsk.pomaz.szeredi.hu> <j2t4e5e476b1004201350xbd08a002l3329fbdd4fb1b8db@mail.gmail.com> <1271856324.24780.285.camel@tucsk.pomaz.szeredi.hu> <1271865911.24780.292.camel@tucsk.pomaz.szeredi.hu> <p2t4e5e476b1004220059u2263832atf36ee33ae83463fa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p2t4e5e476b1004220059u2263832atf36ee33ae83463fa@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 09:59:14AM +0200, Corrado Zoccolo wrote:
> Hi Miklos,
> On Wed, Apr 21, 2010 at 6:05 PM, Miklos Szeredi <mszeredi@suse.cz> wrote:
> > Jens, Corrado,
> >
> > Here's a graph showing the number of issued but not yet completed
> > requests versus time for CFQ and NOOP schedulers running the tiobench
> > benchmark with 8 threads:
> >
> > http://www.kernel.org/pub/linux/kernel/people/mszeredi/blktrace/queue-depth.jpg
> >
> > It shows pretty clearly the performance problem is because CFQ is not
> > issuing enough request to fill the bandwidth.
> >
> > Is this the correct behavior of CFQ or is this a bug?
>  This is the expected behavior from CFQ, even if it is not optimal,
> since we aren't able to identify multi-splindle disks yet.

In the past we were of the opinion that for sequential workload multi spindle
disks will not matter much as readahead logic (in OS and possibly in
hardware also) will help. For random workload we anyway don't idle on the
single cfqq so it is fine. But my tests now seem to be telling a different
story.

I also have one FC link to one of the HP EVA and I am running increasing 
number of sequential readers to see if throughput goes up as number of
readers go up. The results are with noop and cfq. I do flush OS caches
across the runs but I have no control on caching on HP EVA.

Kernel=2.6.34-rc5 
DIR=/mnt/iostestmnt/fio        DEV=/dev/mapper/mpathe        
Workload=bsr      iosched=cfq     Filesz=2G   bs=4K   
=========================================================================
job       Set NR  ReadBW(KB/s)   MaxClat(us)    WriteBW(KB/s)  MaxClat(us)    
---       --- --  ------------   -----------    -------------  -----------    
bsr       1   1   135366         59024          0              0              
bsr       1   2   124256         126808         0              0              
bsr       1   4   132921         341436         0              0              
bsr       1   8   129807         392904         0              0              
bsr       1   16  129988         773991         0              0              

Kernel=2.6.34-rc5             
DIR=/mnt/iostestmnt/fio        DEV=/dev/mapper/mpathe        
Workload=bsr      iosched=noop    Filesz=2G   bs=4K   
=========================================================================
job       Set NR  ReadBW(KB/s)   MaxClat(us)    WriteBW(KB/s)  MaxClat(us)    
---       --- --  ------------   -----------    -------------  -----------    
bsr       1   1   126187         95272          0              0              
bsr       1   2   185154         72908          0              0              
bsr       1   4   224622         88037          0              0              
bsr       1   8   285416         115592         0              0              
bsr       1   16  348564         156846         0              0              

So in case of NOOP, throughput shotup to 348MB/s but CFQ reamains more or
less constat, about 130MB/s.

So atleast in this case, a single sequential CFQ queue is not keeing the
disk busy enough.

I am wondering why my testing results were different in the past. May be
it was a different piece of hardware and behavior various across hardware?

Anyway, if that's the case, then we probably need to allow IO from
multiple sequential readers and keep a watch on throughput. If throughput
drops then reduce the number of parallel sequential readers. Not sure how
much of code that is but with multiple cfqq going in parallel, ioprio
logic will more or less stop working in CFQ (on multi-spindle hardware).

FWIW, I also ran tiobench on same HP EVA with NOOP and CFQ. And indeed
Read throughput is bad with CFQ.

With NOOP
=========
# /usr/bin/tiotest -t 8 -f 2000 -r 4000 -b 4096 -d /mnt/mpathe
Tiotest results for 8 concurrent io threads:
,----------------------------------------------------------------------.
| Item                  | Time     | Rate         | Usr CPU  | Sys CPU |
+-----------------------+----------+--------------+----------+---------+
| Write       16000 MBs |   44.1 s | 362.410 MB/s |  25.3 %  | 1239.4 % |
| Random Write  125 MBs |    0.8 s | 156.182 MB/s |  19.7 %  | 484.8 % |
| Read        16000 MBs |   59.9 s | 267.008 MB/s |  12.4 %  | 197.1 % |
| Random Read   125 MBs |   16.7 s |   7.478 MB/s |   1.0 %  |  23.7 % |
`----------------------------------------------------------------------'
Tiotest latency results:
,-------------------------------------------------------------------------.
| Item         | Average latency | Maximum latency | % >2 sec | % >10 sec |
+--------------+-----------------+-----------------+----------+-----------+
| Write        |        0.083 ms |      834.092 ms |  0.00000 |   0.00000 |
| Random Write |        0.021 ms |       21.024 ms |  0.00000 |   0.00000 |
| Read         |        0.115 ms |      105.830 ms |  0.00000 |   0.00000 |
| Random Read  |        4.088 ms |      295.605 ms |  0.00000 |   0.00000 |
|--------------+-----------------+-----------------+----------+-----------|
| Total        |        0.114 ms |      834.092 ms |  0.00000 |   0.00000 |
`--------------+-----------------+-----------------+----------+-----------'

With CFQ
========
# /usr/bin/tiotest -t 8 -f 2000 -r 4000 -b 4096 -d /mnt/mpathe
Tiotest results for 8 concurrent io threads:
,----------------------------------------------------------------------.
| Item                  | Time     | Rate         | Usr CPU  | Sys CPU |
+-----------------------+----------+--------------+----------+---------+
| Write       16000 MBs |   49.5 s | 323.086 MB/s |  21.7 %  | 1175.6 % |
| Random Write  125 MBs |    2.2 s |  57.148 MB/s |   5.0 %  | 188.1 % |
| Read        16000 MBs |  162.7 s |  98.311 MB/s |   4.7 %  |  71.0 % |
| Random Read   125 MBs |   17.0 s |   7.344 MB/s |   0.8 %  |  26.5 % |
`----------------------------------------------------------------------'
Tiotest latency results:
,-------------------------------------------------------------------------.
| Item         | Average latency | Maximum latency | % >2 sec | % >10 sec |
+--------------+-----------------+-----------------+----------+-----------+
| Write        |        0.093 ms |      832.680 ms |  0.00000 |   0.00000 |
| Random Write |        0.017 ms |       12.031 ms |  0.00000 |   0.00000 |
| Read         |        0.316 ms |      561.623 ms |  0.00000 |   0.00000 |
| Random Read  |        4.126 ms |      273.156 ms |  0.00000 |   0.00000 |
|--------------+-----------------+-----------------+----------+-----------|
| Total        |        0.219 ms |      832.680 ms |  0.00000 |   0.00000 |
`--------------+-----------------+-----------------+----------+-----------'

Thanks
Vivek
