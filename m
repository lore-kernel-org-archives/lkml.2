Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab0F1Wru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 18:47:50 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:39652 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab0F1Wrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 18:47:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JMCW6FT8RKvVvj2fQXDv4lOlCgqbii4LkwAE2ZJ46ZDEqSxtD4rQo1Y/i0qc6hcWFG
         f45pVa+NqO8CE1jAmcMd/oDXRgbjYp6d04KDWWFy9nACm8WPz95G+c1e776s1Xc51+3k
         XK4p7wpdXTw/iaanxhOjXcSVlx7udY5ajwFpo=
Date: Tue, 29 Jun 2010 00:47:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, dwalker@codeaurora.org,
       stefanr@s5r6.in-berlin.de, florian@mickler.org, andi@firstfloor.org,
       mst@redhat.com, randy.dunlap@oracle.com
Subject: Re: [PATCH 12/35] workqueue: update cwq alignement
Message-ID: <20100628224755.GA10104@nowhere>
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-13-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277759063-24607-13-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 11:04:00PM +0200, Tejun Heo wrote:
> work->data field is used for two purposes.  It points to cwq it's
> queued on and the lower bits are used for flags.  Currently, two bits
> are reserved which is always safe as 4 byte alignment is guaranteed on
> every architecture.  However, future changes will need more flag bits.
> 
> On SMP, the percpu allocator is capable of honoring larger alignment
> (there are other users which depend on it) and larger alignment works
> just fine.  On UP, percpu allocator is a thin wrapper around
> kzalloc/kfree() and don't honor alignment request.
> 
> This patch introduces WORK_STRUCT_FLAG_BITS and implements
> alloc/free_cwqs() which guarantees (1 << WORK_STRUCT_FLAG_BITS)
> alignment both on SMP and UP.  On SMP, simply wrapping percpu
> allocator is enouhg.  On UP, extra space is allocated so that cwq can
> be aligned and the original pointer can be stored after it which is
> used in the free path.
> 
> While at it, as cwqs are now forced aligned, make sure the resulting
> alignment is at least equal to or larger than that of long long.
> 
> Alignment problem on UP is reported by Michal Simek.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Reported-by: Michal Simek <michal.simek@petalogix.com>
> ---
>  include/linux/workqueue.h |    5 +++-
>  kernel/workqueue.c        |   62 +++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 61 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> index d60c570..b90958a 100644
> --- a/include/linux/workqueue.h
> +++ b/include/linux/workqueue.h
> @@ -26,6 +26,9 @@ enum {
>  	WORK_STRUCT_PENDING_BIT	= 0,	/* work item is pending execution */
>  #ifdef CONFIG_DEBUG_OBJECTS_WORK
>  	WORK_STRUCT_STATIC_BIT	= 1,	/* static initializer (debugobjects) */
> +	WORK_STRUCT_FLAG_BITS	= 2,
> +#else
> +	WORK_STRUCT_FLAG_BITS	= 1,
>  #endif
>  
>  	WORK_STRUCT_PENDING	= 1 << WORK_STRUCT_PENDING_BIT,
> @@ -35,7 +38,7 @@ enum {
>  	WORK_STRUCT_STATIC	= 0,
>  #endif
>  
> -	WORK_STRUCT_FLAG_MASK	= 3UL,
> +	WORK_STRUCT_FLAG_MASK	= (1UL << WORK_STRUCT_FLAG_BITS) - 1,
>  	WORK_STRUCT_WQ_DATA_MASK = ~WORK_STRUCT_FLAG_MASK,
>  };
>  
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index dc78956..878546e 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -46,7 +46,9 @@
>  
>  /*
>   * The per-CPU workqueue (if single thread, we always use the first
> - * possible cpu).
> + * possible cpu).  The lower WORK_STRUCT_FLAG_BITS of
> + * work_struct->data are used for flags and thus cwqs need to be
> + * aligned at two's power of the number of flag bits.
>   */
>  struct cpu_workqueue_struct {
>  
> @@ -59,7 +61,7 @@ struct cpu_workqueue_struct {
>  
>  	struct workqueue_struct *wq;		/* I: the owning workqueue */
>  	struct task_struct	*thread;
> -} ____cacheline_aligned;
> +};
>  
>  /*
>   * The externally visible workqueue abstraction is an array of
> @@ -967,6 +969,47 @@ int current_is_keventd(void)
>  
>  }
>  
> +static struct cpu_workqueue_struct *alloc_cwqs(void)
> +{
> +	const size_t size = sizeof(struct cpu_workqueue_struct);
> +	const size_t align = 1 << WORK_STRUCT_FLAG_BITS;
> +	struct cpu_workqueue_struct *cwqs;
> +#ifndef CONFIG_SMP
> +	void *ptr;
> +
> +	/*
> +	 * On UP, percpu allocator doesn't honor alignment parameter
> +	 * and simply uses arch-dependent default.  Allocate enough
> +	 * room to align cwq and put an extra pointer at the end
> +	 * pointing back to the originally allocated pointer which
> +	 * will be used for free.
> +	 *
> +	 * FIXME: This really belongs to UP percpu code.  Update UP
> +	 * percpu code to honor alignment and remove this ugliness.
> +	 */
> +	ptr = __alloc_percpu(size + align + sizeof(void *), 1);
> +	cwqs = PTR_ALIGN(ptr, align);
> +	*(void **)per_cpu_ptr(cwqs + 1, 0) = ptr;
> +#else
> +	/* On SMP, percpu allocator can do it itself */
> +	cwqs = __alloc_percpu(size, align);
> +#endif
> +	/* just in case, make sure it's actually aligned */
> +	BUG_ON(!IS_ALIGNED((unsigned long)cwqs, align));
> +	return cwqs;
> +}
> +
> +static void free_cwqs(struct cpu_workqueue_struct *cwqs)
> +{
> +#ifndef CONFIG_SMP
> +	/* on UP, the pointer to free is stored right after the cwq */
> +	if (cwqs)
> +		free_percpu(*(void **)per_cpu_ptr(cwqs + 1, 0));
> +#else
> +	free_percpu(cwqs);
> +#endif
> +}
> +
>  static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
>  {
>  	struct workqueue_struct *wq = cwq->wq;
> @@ -1012,7 +1055,7 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
>  	if (!wq)
>  		goto err;
>  
> -	wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);
> +	wq->cpu_wq = alloc_cwqs();
>  	if (!wq->cpu_wq)
>  		goto err;
>  
> @@ -1031,6 +1074,7 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
>  	for_each_possible_cpu(cpu) {
>  		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
>  
> +		BUG_ON((unsigned long)cwq & WORK_STRUCT_FLAG_MASK);
>  		cwq->wq = wq;
>  		cwq->cpu = cpu;
>  		spin_lock_init(&cwq->lock);
> @@ -1059,7 +1103,7 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
>  	return wq;
>  err:
>  	if (wq) {
> -		free_percpu(wq->cpu_wq);
> +		free_cwqs(wq->cpu_wq);
>  		kfree(wq);
>  	}
>  	return NULL;
> @@ -1112,7 +1156,7 @@ void destroy_workqueue(struct workqueue_struct *wq)
>  	for_each_possible_cpu(cpu)
>  		cleanup_workqueue_thread(get_cwq(cpu, wq));
>  
> -	free_percpu(wq->cpu_wq);
> +	free_cwqs(wq->cpu_wq);
>  	kfree(wq);
>  }
>  EXPORT_SYMBOL_GPL(destroy_workqueue);
> @@ -1194,6 +1238,14 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
>  
>  void __init init_workqueues(void)
>  {
> +	/*
> +	 * cwqs are forced aligned according to WORK_STRUCT_FLAG_BITS.
> +	 * Make sure that the alignment isn't lower than that of
> +	 * unsigned long long.
> +	 */
> +	BUILD_BUG_ON(__alignof__(struct cpu_workqueue_struct) <
> +		     __alignof__(unsigned long long));
> +


But they are not allocated contiguously as we use the per cpu offsets.
So why does the struct itself need to be aligned? Only the base pointer
of its dynamic allocation needs to be aligned. Or am I missing something?


This is crashing my build in x86-32, unless I force an alignment to 8, or
I just remove this build check.

