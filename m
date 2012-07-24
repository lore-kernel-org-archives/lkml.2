Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab2GXWbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 18:31:18 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:45623 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754774Ab2GXWbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 18:31:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoFAAMhD1B5LMut/2dsb2JhbABFhQq0eYEIgiABAQQBJxMcIwULCAMOCi4UJQMhE4gHBbsuFIs3HIZYA5VIiSyGYoJxgUU
Date: Wed, 25 Jul 2012 08:31:10 +1000
From: Dave Chinner <david@fromorbit.com>
To: Ankit Jain <jankit@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, bcrl@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Make io_submit non-blocking
Message-ID: <20120724223110.GQ23387@dastard>
References: <500E89D1.9010303@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500E89D1.9010303@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 05:11:05PM +0530, Ankit Jain wrote:
> 
> Currently, io_submit tries to execute the io requests on the
> same thread, which could block because of various reaons (eg.
> allocation of disk blocks). So, essentially, io_submit ends
> up being a blocking call.
> 
> With this patch, io_submit prepares all the kiocbs and then
> adds (kicks) them to ctx->run_list (kicked) in one go and then
> schedules the workqueue. The actual operations are not executed
> on io_submit's process context, so it can return very quickly.
> 
> This run_list is processed either on a workqueue or in response to
> an io_getevents call. This utilizes the existing retry infrastructure.
> 
> It uses override_creds/revert_creds to use the submitting process'
> credentials when processing the iocb request from the workqueue. This
> is required for proper support of quota and reserved block access.
> 
> Currently, we use block plugging in io_submit, since most of the IO
> was being done there itself. This patch moves it to aio_kick_handler
> and aio_run_all_iocbs, where the IO gets submitted.
> 
> All the tests were run with ext4.
> 
> I tested the patch with fio
>  (fio rand-rw-disk.fio --max-jobs=2 --latency-log
>  --bandwidth-log)
> 
> **Unpatched**
> read : io=102120KB, bw=618740 B/s, iops=151 , runt=169006msec
> slat (usec): min=275 , max=87560 , avg=6571.88, stdev=2799.57

Hmmm, I had to check the numbers twice - that's only 600KB/s.

Perhaps you need to test on something more than a single piece of
spinning rust. Optimising AIO for SSD rates (say 100k 4k write IOPS)
is probably more relevant to the majority of AIO users....

> write: io=102680KB, bw=622133 B/s, iops=151 , runt=169006msec
> slat (usec): min=2 , max=196 , avg=24.66, stdev=20.35
> 
> **Patched**
> read : io=102864KB, bw=504885 B/s, iops=123 , runt=208627msec
> slat (usec): min=0 , max=120 , avg= 1.65, stdev= 3.46 
> 
> write: io=101936KB, bw=500330 B/s, iops=122 , runt=208627msec
> slat (usec): min=0 , max=131 , avg= 1.85, stdev= 3.27 

So you made ext4 20% slower at random 4k writes with worst case
latencies only improving by about 30%. That, I think, is a
non-starter....

Also, you added a memory allocation in the io submit code. Worse
case latency will still be effectively undefined - what happens to
latencies if you generate memory pressure while the test is running?

FWIW, if you are going to change generic code, you need to present
results for other filesystems as well (xfs, btrfs are typical), as
they may not have the same problems as ext4 or react the same way to
your change. The result might simply be "it is 20% slower"....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
