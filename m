Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab0ETWXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 18:23:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57060 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296Ab0ETWXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 18:23:14 -0400
Date: Thu, 20 May 2010 18:21:54 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] reduce runqueue lock contention
Message-ID: <20100520222154.GC20946@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	axboe@kernel.dk, linux-kernel@vger.kernel.org
References: <20100520204810.GA19188@think>
 <1274389786.1674.1653.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274389786.1674.1653.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090209.4BF5B62A.00D1:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 11:09:46PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-05-20 at 16:48 -0400, Chris Mason wrote:
> > 
> > This is more of a starting point than a patch, but it is something I've
> > been meaning to look at for a long time.  Many different workloads end
> > up hammering very hard on try_to_wake_up, to the point where the
> > runqueue locks dominate CPU profiles.
> 
> Right, so one of the things that I considered was to make p->state an
> atomic_t and replace the initial stage of try_to_wake_up() with
> something like:
> 
> int try_to_wake_up(struct task *p, unsigned int mask, wake_flags)
> {
>   int state = atomic_read(&p->state);
> 
>   do {
>     if (!(state & mask))
>       return 0;
> 
>     state = atomic_cmpxchg(&p->state, state, TASK_WAKING);
>   } while (state != TASK_WAKING);
> 
>   /* do this pending queue + ipi thing */
> 
>   return 1;
> }
> 
> Also, I think we might want to put that atomic single linked list thing
> into some header (using atomic_long_t or so), because I have a similar
> thing living in kernel/perf_event.c, that needs to queue things from NMI
> context.

So I've done three of these cmpxchg lists recently...but they have all
been a little different.  I went back and forth a bunch of times about
using a list_head based thing instead to avoid the walk for list append.
I really don't like the walk.

But, what makes this one unique is that I'm using a cmpxchg on the list
pointer in the in task struct to take ownership of this task struct.
It is how I avoid concurrent lockless enqueues.

Your fiddling with the p->state above would let me avoid that.

-chris
