Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab2GVVYH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 17:24:07 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:51000 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab2GVVYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 17:24:04 -0400
Date: Sun, 22 Jul 2012 14:23:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de, linux-pm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] workqueue: fix spurious CPU locality WARN from
 process_one_work()
Message-ID: <20120722212358.GT2435@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
 <1342545149-3515-2-git-send-email-tj@kernel.org>
 <20120720215207.GA18841@linux.vnet.ibm.com>
 <20120720215835.GB6823@google.com>
 <20120721213656.GA7783@linux.vnet.ibm.com>
 <20120722164327.GA5144@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120722164327.GA5144@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072221-4242-0000-0000-0000026656AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2012 at 09:43:27AM -0700, Tejun Heo wrote:
> 25511a4776 "workqueue: reimplement CPU online rebinding to handle idle
> workers" added CPU locality sanity check in process_one_work().  It
> triggers if a worker is executing on a different CPU without UNBOUND
> or REBIND set.
> 
> This works for all normal workers but rescuers can trigger this
> spuriously when they're serving the unbound or a disassociated
> global_cwq - rescuers don't have either flag set and thus its
> gcwq->cpu can be a different value including %WORK_CPU_UNBOUND.
> 
> Fix it by additionally testing %GCWQ_DISASSOCIATED.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> LKML-Refence: <20120721213656.GA7783@linux.vnet.ibm.com>
> ---
> This should fix it.  Will queue it on wq/for-3.6.

I am running my tests on it, will let you know how it goes.

							Thanx, Paul

> Thanks!
> 
>  kernel/workqueue.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1949,7 +1949,13 @@ __acquires(&gcwq->lock)
> 
>  	lockdep_copy_map(&lockdep_map, &work->lockdep_map);
>  #endif
> +	/*
> +	 * Ensure we're on the correct CPU.  DISASSOCIATED test is
> +	 * necessary to avoid spurious warnings from rescuers servicing the
> +	 * unbound or a disassociated gcwq.
> +	 */
>  	WARN_ON_ONCE(!(worker->flags & (WORKER_UNBOUND | WORKER_REBIND)) &&
> +		     !(gcwq->flags & GCWQ_DISASSOCIATED) &&
>  		     raw_smp_processor_id() != gcwq->cpu);
> 
>  	/*
> 

