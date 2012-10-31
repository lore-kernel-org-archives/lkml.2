Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab2JaLwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:52:30 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:46571 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab2JaLw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:52:27 -0400
Date: Wed, 31 Oct 2012 04:51:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Shan Wei <shanwei88@gmail.com>
Cc: dipankar@in.ibm.com, Kernel-Maillist <linux-kernel@vger.kernel.org>,
        cl@linux-foundation.org
Subject: Re: [PATCH 7/9] rcu:  use this_cpu_ptr per-cpu helper instead of
 per_cpu_ptr(p, raw_smp_processor_id())
Message-ID: <20121031115140.GX3027@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <50910A17.1090600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50910A17.1090600@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103111-5518-0000-0000-000008DBF353
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 07:23:03PM +0800, Shan Wei wrote:
> From: Shan Wei <davidshan@tencent.com>
> 
> smp_processor_id is defined as raw_smp_processor_id.
> replace per_cpu_ptr(p, raw_smp_processor_id()) is also ok.
> 
> Signed-off-by: Shan Wei <davidshan@tencent.com>

Hello, Shan Wei,

There are several definitions of this_cpu_ptr():

0 percpu.h 63 #define this_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, my_cpu_offset)
1 percpu.h 65 #define this_cpu_ptr(ptr) __this_cpu_ptr(ptr)
2 percpu.h 85 #define this_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)

The first uses my_cpu_offset, which is further defined in two ways:

0 percpu.h 33 #define my_cpu_offset per_cpu_offset(smp_processor_id())
1 percpu.h 35 #define my_cpu_offset __my_cpu_offset

The first uses smp_processor_id(), which will complain if
force_quiescent_state() is called with preemption disabled, which it
sometimes is.

So what am I missing here?

							Thanx, Paul

> ---
>  kernel/rcutree.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 74df86b..3a21fcf 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1960,7 +1960,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
>  	struct rcu_node *rnp_old = NULL;
> 
>  	/* Funnel through hierarchy to reduce memory contention. */
> -	rnp = per_cpu_ptr(rsp->rda, raw_smp_processor_id())->mynode;
> +	rnp = this_cpu_ptr(rsp->rda)->mynode;
>  	for (; rnp != NULL; rnp = rnp->parent) {
>  		ret = (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) ||
>  		      !raw_spin_trylock(&rnp->fqslock);
> -- 
> 1.7.1
> 

