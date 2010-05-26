Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab0EZXDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:03:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753367Ab0EZXDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:03:10 -0400
Date: Wed, 26 May 2010 16:02:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: piotr@hosowicz.com, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Divyesh Shah <dpshah@google.com>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 icedove-bin/5449
Message-Id: <20100526160252.325f8357.akpm@linux-foundation.org>
In-Reply-To: <1274777422.5882.591.camel@twins>
References: <4BF9EC69.5030709@example.com>
	<1274777422.5882.591.camel@twins>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010 10:50:22 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

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
>
>
>
> +unsigned long long local_clock(void)
> +{
> +	unsigned long long clock;
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	clock = sched_clock_cpu(smp_processor_id());
> +	local_irq_restore(flags);
> +
> +	return clock;
> +}
> +

NAK NAK NAK NAK!  QAK!  HAK!  Crap code!  Stop adding undocumented
interfaces.  Just stop it.  Now.  Geeze.

How is anyone supposed to use this?  What are the semantics of this
thing?  What are the units of its return value?  What is the base value
of its return value?  Does it return different times on different CPUs?
I assume so, otherwise why does sched_clock_cpu() exist?  <looks at
the sched_clock_cpu() documentation, collapses in giggles>

Because if it does return different times on different CPUs then any
and all of the sites which use it are going to need to cope with
time-going-backwards and I'm not at all confident that they get this
right.


Also, all these interfaces use a random mixture of `u64' and `unsigned
long long', but that's a far less serious problem.

