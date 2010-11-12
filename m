Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab0KLS4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:56:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998Ab0KLS4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:56:06 -0500
Date: Fri, 12 Nov 2010 19:49:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Q: perf_event && event->owner
Message-ID: <20101112184937.GA12014@redhat.com>
References: <20101109155714.GA1903@redhat.com> <1289321804.2191.57.camel@laptop> <20101109165805.GA6971@redhat.com> <1289322469.2191.59.camel@laptop> <20101109174219.GA8279@redhat.com> <1289325703.2191.60.camel@laptop> <20101109185748.GA12138@redhat.com> <1289402233.2084.5.camel@laptop> <20101110154430.GA1454@redhat.com> <1289576883.2084.286.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289576883.2084.286.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12, Peter Zijlstra wrote:
>
> Utter paranoia took over and I'm still not sure its solid...

Thanks Peter!

I believe this all is correct.

> Subject: perf: Fix owner-list vs exit
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue, 09 Nov 2010 19:01:43 +0100
> 
> Reported-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <1289325703.2191.60.camel@laptop>
> ---
>  kernel/perf_event.c |   63 ++++++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 51 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6/kernel/perf_event.c
> ===================================================================
> --- linux-2.6.orig/kernel/perf_event.c
> +++ linux-2.6/kernel/perf_event.c
> @@ -2234,11 +2234,6 @@ int perf_event_release_kernel(struct per
>  	raw_spin_unlock_irq(&ctx->lock);
>  	mutex_unlock(&ctx->mutex);
>  
> -	mutex_lock(&event->owner->perf_event_mutex);
> -	list_del_init(&event->owner_entry);
> -	mutex_unlock(&event->owner->perf_event_mutex);
> -	put_task_struct(event->owner);
> -
>  	free_event(event);
>  
>  	return 0;
> @@ -2251,9 +2246,43 @@ EXPORT_SYMBOL_GPL(perf_event_release_ker
>  static int perf_release(struct inode *inode, struct file *file)
>  {
>  	struct perf_event *event = file->private_data;
> +	struct task_struct *owner;
>  
>  	file->private_data = NULL;
>  
> +	rcu_read_lock();
> +	owner = ACCESS_ONCE(event->owner);
> +	/*
> +	 * Matches the smp_wmb() in perf_event_exit_task(). If we observe
> +	 * !owner it means the list deletion is complete and we can indeed
> +	 * free this event, otherwise we need to serialize on
> +	 * owner->perf_event_mutex.
> +	 */
> +	smp_read_barrier_depends();
> +	if (owner) {
> +		/*
> +		 * Since delayed_put_task_struct() also drops the last
> +		 * task reference we can safely take a new reference
> +		 * while holding the rcu_read_lock().
> +		 */
> +		get_task_struct(owner);
> +	}
> +	rcu_read_unlock();
> +
> +	if (owner) {
> +		mutex_lock(&owner->perf_event_mutex);
> +		/*
> +		 * We have to re-check the event->owner field, if it is cleared
> +		 * we raced with perf_event_exit_task(), acquiring the mutex
> +		 * ensured they're done, and we can proceed with freeing the
> +		 * event.
> +		 */
> +		if (event->owner)
> +			list_del_init(&event->owner_entry);
> +		mutex_unlock(&owner->perf_event_mutex);
> +		put_task_struct(owner);
> +	}
> +
>  	return perf_event_release_kernel(event);
>  }
>  
> @@ -5677,7 +5706,7 @@ SYSCALL_DEFINE5(perf_event_open,
>  	mutex_unlock(&ctx->mutex);
>  
>  	event->owner = current;
> -	get_task_struct(current);
> +
>  	mutex_lock(&current->perf_event_mutex);
>  	list_add_tail(&event->owner_entry, &current->perf_event_list);
>  	mutex_unlock(&current->perf_event_mutex);
> @@ -5745,12 +5774,6 @@ perf_event_create_kernel_counter(struct
>  	++ctx->generation;
>  	mutex_unlock(&ctx->mutex);
>  
> -	event->owner = current;
> -	get_task_struct(current);
> -	mutex_lock(&current->perf_event_mutex);
> -	list_add_tail(&event->owner_entry, &current->perf_event_list);
> -	mutex_unlock(&current->perf_event_mutex);
> -
>  	return event;
>  
>  err_free:
> @@ -5901,8 +5924,24 @@ static void perf_event_exit_task_context
>   */
>  void perf_event_exit_task(struct task_struct *child)
>  {
> +	struct perf_event *event, *tmp;
>  	int ctxn;
>  
> +	mutex_lock(&child->perf_event_mutex);
> +	list_for_each_entry_safe(event, tmp, &child->perf_event_list,
> +				 owner_entry) {
> +		list_del_init(&event->owner_entry);
> +
> +		/*
> +		 * Ensure the list deletion is visible before we clear
> +		 * the owner, closes a race against perf_release() where
> +		 * we need to serialize on the owner->perf_event_mutex.
> +		 */
> +		smp_wmb();
> +		event->owner = NULL;
> +	}
> +	mutex_unlock(&child->perf_event_mutex);
> +
>  	for_each_task_context_nr(ctxn)
>  		perf_event_exit_task_context(child, ctxn);
>  }
> 

