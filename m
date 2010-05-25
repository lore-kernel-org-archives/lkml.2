Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab0EYJoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:44:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33435 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756283Ab0EYJoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:44:08 -0400
Date: Tue, 25 May 2010 11:43:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: piotr@hosowicz.com, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Divyesh Shah <dpshah@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 icedove-bin/5449
Message-ID: <20100525094347.GA7881@elte.hu>
References: <4BF9EC69.5030709@example.com>
 <1274777422.5882.591.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274777422.5882.591.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2010-05-24 at 05:03 +0200, Piotr Hosowicz wrote:
> > [  720.313607] BUG: using smp_processor_id() in preemptible [00000000] code: icedove-bin/5449
> > [  720.313612] caller is native_sched_clock+0x3c/0x68
> > [  720.313616] Pid: 5449, comm: icedove-bin Tainted: P            2.6.34-20100524-0407 #1
> > [  720.313618] Call Trace:
> > [  720.313624]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
> > [  720.313629]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
> > [  720.313634]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
> > [  720.313637]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
> > [  720.313641]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
> > [  720.313646]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d 
> 
> This comes from wreckage in the blk tree..
> 
> ---
> commit 9195291e5f05e01d67f9a09c756b8aca8f009089
> Author: Divyesh Shah <dpshah@google.com>
> Date:   Thu Apr 1 15:01:41 2010 -0700
> 
>     blkio: Increment the blkio cgroup stats for real now
>     
>     We also add start_time_ns and io_start_time_ns fields to struct request
>     here to record the time when a request is created and when it is
>     dispatched to device. We use ns uints here as ms and jiffies are
>     not very useful for non-rotational media.
>     
>     Signed-off-by: Divyesh Shah<dpshah@google.com>
>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
> 
> +#ifdef CONFIG_BLK_CGROUP
> +static inline void set_start_time_ns(struct request *req)
> +{
> +	req->start_time_ns = sched_clock();
> +}
> +
> +static inline void set_io_start_time_ns(struct request *req)
> +{
> +	req->io_start_time_ns = sched_clock();
> +}
> +#else
> +static inline void set_start_time_ns(struct request *req) {}
> +static inline void set_io_start_time_ns(struct request *req) {}
> +#endif
> 
> ---
> 
> Clearly nobody tested this, and its terribly broken to boot.
> 
> I guess they want something like:
> 
> ---
> Subject: sched_clock: Add local_clock()
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue May 25 10:48:51 CEST 2010
> 
> For people who otherwise get to write: cpu_clock(smp_processor_id()),
> there is now: local_clock().

This doesnt fix the whole issue. cpu_clock() is local, while the measurements 
done in the blk code are global ...

While the warning is fixed this way, the far more serious issue is still 
there: time can go backwards if two points of time measurement are on 
different CPUs and can mess up the statistics with negative values, etc...

	Ingo
