Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab2JRNUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:20:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10923 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab2JRNUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:20:23 -0400
X-Authority-Analysis: v=2.0 cv=IZ4FqBWa c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=c7QpnVTx6xIA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=_Pjek1p4V8oA:10 a=VnNF1IyMAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=NufY4J3AAAAA:8 a=ag1SF4gXAAAA:8 a=W0vUJOdyAAAA:8 a=Fgajo8psAAAA:8 a=30nCDrfltcldjtiiX9QA:9 a=CjuIK1q_8ugA:10 a=EXPbJd8Fa2wA:10 a=x8gzFH9gYPwA:10 a=3Rfx1nUSh_UA:10 a=LI9Vle30uBYA:10 a=re9sYKne76oA:10 a=1TSTQ8KKaH4A:10 a=ZdVzcpHlD7wA:10 a=dxTCgB9KUcBtlMmt:21 a=Y5iwXQRrA43iUoVS:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Date: Thu, 18 Oct 2012 09:20:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Christoph Lameter <cl@linux.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [ 004/120] slab: fix the DEADLOCK issue on l3 alien lock
Message-ID: <20121018132020.GB7282@home.goodmis.org>
References: <20121011005825.364610894@linuxfoundation.org>
 <20121011005826.156478516@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011005826.156478516@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 09:59:16AM +0900, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Michael Wang <wangyun@linux.vnet.ibm.com>
> 
> commit 947ca1856a7e60aa6d20536785e6a42dff25aa6e upstream.
> 
> DEADLOCK will be report while running a kernel with NUMA and LOCKDEP enabled,
> the process of this fake report is:
> 
> 	   kmem_cache_free()	//free obj in cachep
> 	-> cache_free_alien()	//acquire cachep's l3 alien lock
> 	-> __drain_alien_cache()
> 	-> free_block()
> 	-> slab_destroy()
> 	-> kmem_cache_free()	//free slab in cachep->slabp_cache
> 	-> cache_free_alien()	//acquire cachep->slabp_cache's l3 alien lock
> 
> Since the cachep and cachep->slabp_cache's l3 alien are in the same lock class,
> fake report generated.
> 
> This should not happen since we already have init_lock_keys() which will
> reassign the lock class for both l3 list and l3 alien.
> 
> However, init_lock_keys() was invoked at a wrong position which is before we
> invoke enable_cpucache() on each cache.
> 
> Since until set slab_state to be FULL, we won't invoke enable_cpucache()
> on caches to build their l3 alien while creating them, so although we invoked
> init_lock_keys(), the l3 alien lock class won't change since we don't have
> them until invoked enable_cpucache() later.
> 
> This patch will invoke init_lock_keys() after we done enable_cpucache()
> instead of before to avoid the fake DEADLOCK report.
> 
> Michael traced the problem back to a commit in release 3.0.0:

I don't see this fix in the last 3.0 stable release. Shouldn't it go
there too?

-- Steve

> 
> commit 30765b92ada267c5395fc788623cb15233276f5c
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Thu Jul 28 23:22:56 2011 +0200
> 
>     slab, lockdep: Annotate the locks before using them
> 
>     Fernando found we hit the regular OFF_SLAB 'recursion' before we
>     annotate the locks, cure this.
> 
>     The relevant portion of the stack-trace:
> 
>     > [    0.000000]  [<c085e24f>] rt_spin_lock+0x50/0x56
>     > [    0.000000]  [<c04fb406>] __cache_free+0x43/0xc3
>     > [    0.000000]  [<c04fb23f>] kmem_cache_free+0x6c/0xdc
>     > [    0.000000]  [<c04fb2fe>] slab_destroy+0x4f/0x53
>     > [    0.000000]  [<c04fb396>] free_block+0x94/0xc1
>     > [    0.000000]  [<c04fc551>] do_tune_cpucache+0x10b/0x2bb
>     > [    0.000000]  [<c04fc8dc>] enable_cpucache+0x7b/0xa7
>     > [    0.000000]  [<c0bd9d3c>] kmem_cache_init_late+0x1f/0x61
>     > [    0.000000]  [<c0bba687>] start_kernel+0x24c/0x363
>     > [    0.000000]  [<c0bba0ba>] i386_start_kernel+0xa9/0xaf
> 
>     Reported-by: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
>     Acked-by: Pekka Enberg <penberg@kernel.org>
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Link: http://lkml.kernel.org/r/1311888176.2617.379.camel@laptop
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> The commit moved init_lock_keys() before we build up the alien, so we
> failed to reclass it.
> 
> Acked-by: Christoph Lameter <cl@linux.com>
> Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> Signed-off-by: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  mm/slab.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -1685,9 +1685,6 @@ void __init kmem_cache_init_late(void)
>  
>  	g_cpucache_up = LATE;
>  
> -	/* Annotate slab for lockdep -- annotate the malloc caches */
> -	init_lock_keys();
> -
>  	/* 6) resize the head arrays to their final sizes */
>  	mutex_lock(&cache_chain_mutex);
>  	list_for_each_entry(cachep, &cache_chain, next)
> @@ -1695,6 +1692,9 @@ void __init kmem_cache_init_late(void)
>  			BUG();
>  	mutex_unlock(&cache_chain_mutex);
>  
> +	/* Annotate slab for lockdep -- annotate the malloc caches */
> +	init_lock_keys();
> +
>  	/* Done! */
>  	g_cpucache_up = FULL;
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
