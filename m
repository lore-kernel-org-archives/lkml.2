Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab0DVKXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 06:23:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab0DVKX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:23:29 -0400
Subject: Re: CFQ read performance regression
From: Miklos Szeredi <mszeredi@suse.cz>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       Suresh Jayaraman <sjayaraman@suse.de>
In-Reply-To: <p2t4e5e476b1004220059u2263832atf36ee33ae83463fa@mail.gmail.com>
References: <1271420878.24780.145.camel@tucsk.pomaz.szeredi.hu>
	 <h2m4e5e476b1004170546z8997cd90h98ecfb9cc5aad8cf@mail.gmail.com>
	 <1271677562.24780.184.camel@tucsk.pomaz.szeredi.hu>
	 <j2t4e5e476b1004201350xbd08a002l3329fbdd4fb1b8db@mail.gmail.com>
	 <1271856324.24780.285.camel@tucsk.pomaz.szeredi.hu>
	 <1271865911.24780.292.camel@tucsk.pomaz.szeredi.hu>
	 <p2t4e5e476b1004220059u2263832atf36ee33ae83463fa@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Apr 2010 12:23:29 +0200
Message-ID: <1271931809.24780.387.camel@tucsk.pomaz.szeredi.hu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-22 at 09:59 +0200, Corrado Zoccolo wrote:
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
> since we aren't able to identify multi-splindle disks yet. Can you
> post the result of "grep -r . ." in your /sys/block/*/queue directory,
> to see if we can find some parameter that can help identifying your
> hardware as a multi-spindle disk.

./iosched/quantum:8
./iosched/fifo_expire_sync:124
./iosched/fifo_expire_async:248
./iosched/back_seek_max:16384
./iosched/back_seek_penalty:2
./iosched/slice_sync:100
./iosched/slice_async:40
./iosched/slice_async_rq:2
./iosched/slice_idle:8
./iosched/low_latency:0
./iosched/group_isolation:0
./nr_requests:128
./read_ahead_kb:512
./max_hw_sectors_kb:32767
./max_sectors_kb:512
./max_segments:64
./max_segment_size:65536
./scheduler:noop deadline [cfq]
./hw_sector_size:512
./logical_block_size:512
./physical_block_size:512
./minimum_io_size:512
./optimal_io_size:0
./discard_granularity:0
./discard_max_bytes:0
./discard_zeroes_data:0
./rotational:1
./nomerges:0
./rq_affinity:1

> >
> > This is on a vanilla 2.6.34-rc4 kernel with two tunables modified:
> >
> > read_ahead_kb=512
> > low_latency=0 (for CFQ)
> You should get much better throughput by setting
> /sys/block/_your_disk_/queue/iosched/slice_idle to 0, or
> /sys/block/_your_disk_/queue/rotational to 0.

slice_idle=0 definitely helps.  rotational=0 seems to help on 2.6.34-rc
but not on 2.6.32.

As far as I understand setting slice_idle to zero is just a workaround
to make cfq look at all the other queues instead of serving one
exclusively for a long time.

I have very little understanding of I/O scheduling but my idea of what's
really needed here is to realize that one queue is not able to saturate
the device and there's a large backlog of requests on other queues that
are waiting to be served.  Is something like that implementable?

Thanks,
Miklos

