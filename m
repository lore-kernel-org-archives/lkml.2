Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab0FONys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:54:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48439 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab0FONyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:54:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z2CR3XjPj/1ACIvin2ebRchj9UHPal8PqxF70xbcNdxBmqLXGDVjlf8q0H/GX9YdrB
         56DqcYVEkwOCV8+zIXRUaxSaAEoST3nqEdpqdHmisuvZlBKLW4iQ985puibBuXJPKOfy
         SPDvsaROouubVeE43df9H8WvBMUvQa+mdm7sI=
Date: Tue, 15 Jun 2010 15:54:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk,
       Anton Blanchard <anton@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 27/30] workqueue: implement DEBUGFS/workqueue
Message-ID: <20100615135432.GF5342@nowhere>
References: <1276551467-21246-1-git-send-email-tj@kernel.org> <1276551467-21246-28-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276551467-21246-28-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 11:37:44PM +0200, Tejun Heo wrote:
> Implement DEBUGFS/workqueue which lists all workers and works for
> debugging.  Workqueues can also have ->show_work() callback which
> describes a pending or running work in custom way.  If ->show_work()
> is missing or returns %false, wchan is printed.
> 
> # cat /sys/kernel/debug/workqueue
> 
> CPU  ID   PID   WORK ADDR        WORKQUEUE    TIME  DESC
> ==== ==== ===== ================ ============ ===== ============================
>    0    0    15 ffffffffa0004708 test-wq-04     1 s test_work_fn+0x469/0x690 [test_wq]
>    0    2  4146                  <IDLE>         0us
>    0    1    21                  <IDLE>         4 s
>    0 DELA       ffffffffa00047b0 test-wq-04     1 s test work 2
>    1    1   418                  <IDLE>       780ms
>    1    0    16                  <IDLE>        40 s
>    1    2   443                  <IDLE>        40 s
> 
> Workqueue debugfs support is suggested by David Howells and
> implementation mostly mimics that of slow-work.
> 
> * Anton Blanchard spotted that ITER_* constants are overflowing w/
>   high cpu configuration.  This was caused by using
>   powerup_power_of_two() where order_base_2() should have been used.
>   Fixed.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Anton Blanchard <anton@samba.org>
> ---
>  include/linux/workqueue.h |   12 ++
>  kernel/workqueue.c        |  369 ++++++++++++++++++++++++++++++++++++++++++++-
>  lib/Kconfig.debug         |    7 +
>  3 files changed, 384 insertions(+), 4 deletions(-)



I don't like this. This adds 300 lines of ad hoc in-kernel instrumentation code while
we now have a nice kernel tracing API (trace events) coupled with easy userspace
tools to post-process that (perf trace scripting). And this is going to provide
a much more powerful view of your new workqueue implementation runtime behaviour.

We already have kernel/trace/trace_workqueue.c that has been obsolated for these
very reasons and we are even going to remove it soon, probably for .36

Please work with us for that, if everybody makes his own corner instrumentation, we
are not going to make any progress in having a powerful and unified tracing/profiling.

The first step is to pinpoint the important places that need tracepoints,
and then just write a perf trace script to use the provided informations by these
tracepoints.

I can help about that if needed.

