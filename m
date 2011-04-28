Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab1D1Qz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 12:55:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63501 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab1D1Qz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 12:55:26 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=wom5GMh1gUkA:10 a=0i_OOtiXEx8A:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=eAWTIsOZi86Vnn5xZOjC/w==:17 a=cm27Pg_UAAAA:8 a=cJGFgd0kuGIBxLUAJZgA:9 a=svxu1sEiL3x8Hx_U3IsA:7 a=CjuIK1q_8ugA:10 a=zv9_9hqRWm8A:10 a=KANGNepFTs5CcHKz:21 a=iqRyXygO-4yWHEXF:21 a=eAWTIsOZi86Vnn5xZOjC/w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.154.172
Date: Thu, 28 Apr 2011 11:55:25 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com, eparis@redhat.com,
        agl@chromium.org, mingo@elte.hu, jmorris@namei.org,
        rostedt@goodmis.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Slaby <jslaby@suse.cz>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/7] seccomp_filter: Enable ftrace-based system call
 filtering
Message-ID: <20110428165525.GB1927@hallyn.com>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
 <1303960136-14298-2-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303960136-14298-2-git-send-email-wad@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Will Drewry (wad@chromium.org):

Thanks very much for going through with this, Will.  I really hope to see
this go upstream soon.

> This change adds a new seccomp mode based on the work by
> agl@chromium.org. This mode comes with a bitmask of NR_syscalls size and
> an optional linked list of seccomp_filter objects. When in mode 2, all
> system calls are first checked against the bitmask to determine if they
> are allowed or denied.  If allowed, the list of filters is checked for
> the given syscall number. If all filter predicates for the system call
> match or the system call was allowed without restriction, the process
> continues. Otherwise, it is killed and a KERN_INFO notification is
> posted.
> 
> The filter language itself is provided by the ftrace filter engine.
> Related patches tweak to the perf filter trace and free allow the calls
> to be shared. Filters inherit their understanding of types and arguments
> for each system call from the CONFIG_FTRACE_SYSCALLS subsystem which
> predefines this information in syscall_metadata associated enter_event
> (and exit_event) structures.
> 
> The result is that a process may reduce its available interfaces to
> the kernel through prctl() without knowing the appropriate system call
> number a priori and with the flexibility of filtering based on
> register-stored arguments.  (String checks suffer from TOCTOU issues and
> should be left to LSMs to provide policy for! Don't get greedy :)
> 
> A sample filterset for a process that only needs to interact over stdin
> and stdout and exit cleanly is shown below:
>   sys_read: fd == 0
>   sys_write: fd == 1
>   sys_exit_group: 1
> 
> The filters may be specified once prior to entering the reduced access
> state:
>   prctl(PR_SET_SECCOMP, 2, filters);
> If prctl() is in the allowed bitmask, the process may futher reduce
> privileges by dropping system calls from the allowed set.
> 
> The only other twist is that it is possible to delay enforcement by one
> system call by supplying a "on_next_syscall: 1" 'filter'.  This allows
> for a launcher process to fork(), prctl(), then execve() leaving the
> launched binary in a filtered state.
> 
> Implementation-wise, seccomp.c now uses seccomp_state struct which is
> managed using RCU primitives.  It contains the system call bitmask and
> a linked list of seccomp_filters (which are also managed as an RCU
> list).  All mutations (barring one optional bit flip) to the
> seccomp_state are always done on a duplicate of the current state value
> which is swapped on prior to use.
> 
> Signed-off-by: Will Drewry <wad@chromium.org>

...

>  void __secure_computing(int this_syscall)
>  {
> -	int mode = current->seccomp.mode;
> +	int mode = -1;
>  	int * syscall;
> -
> +	/* Do we need an RCU read lock to access current's state? */

Nope.

...

> +struct seccomp_state *get_seccomp_state(struct seccomp_state *orig)
> +{
> +	if (!orig)
> +		return NULL;
> +	atomic_inc(&orig->usage);
> +	return orig;
> +}
> +
> +static void __put_seccomp_state(struct seccomp_state *orig)
> +{
> +	WARN_ON(atomic_read(&orig->usage));
> +	seccomp_drop_all_filters(orig);
> +	kfree(orig);
> +}
> +
> +/* put_seccomp_state - decrements the reference count of @orig and may free. */
> +void put_seccomp_state(struct seccomp_state *orig)
> +{
> +	if (!orig)
> +		return;
> +
> +	if (atomic_dec_and_test(&orig->usage))
> +		__put_seccomp_state(orig);
> +}
> +
>  long prctl_get_seccomp(void)
>  {
> -	return current->seccomp.mode;
> +	if (!current->seccomp.state)
> +		return 0;
> +	return current->seccomp.state->mode;
>  }
>  
> -long prctl_set_seccomp(unsigned long seccomp_mode)
> +long prctl_set_seccomp(unsigned long seccomp_mode, char *filters)
>  {
>  	long ret;
> +	struct seccomp_state *state, *orig_state;
>  
> -	/* can set it only once to be even more secure */
> +	rcu_read_lock();
> +	orig_state = get_seccomp_state(rcu_dereference(current->seccomp.state));
> +	rcu_read_unlock();
> +
> +	/* mode 1 can only be set once, but mode 2 may have access reduced. */
>  	ret = -EPERM;
> -	if (unlikely(current->seccomp.mode))
> +	if (orig_state && orig_state->mode != 2 && seccomp_mode != 2)
>  		goto out;
>  
>  	ret = -EINVAL;
> -	if (seccomp_mode && seccomp_mode <= NR_SECCOMP_MODES) {
> -		current->seccomp.mode = seccomp_mode;
> -		set_thread_flag(TIF_SECCOMP);
> +	if (!seccomp_mode || seccomp_mode > NR_SECCOMP_MODES)
> +		goto out;
> +
> +	/* Prepare to modify the seccomp state by dropping the shared
> +	 * reference after duplicating it.
> +	 */
> +	state = (orig_state ? seccomp_state_dup(orig_state) :
> +			      seccomp_state_new());
> +	if (!state) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	ret = 0;
> +	switch (seccomp_mode) {
> +	case 1:
>  #ifdef TIF_NOTSC
>  		disable_TSC();
>  #endif
> +		state->mode = seccomp_mode;
> +		set_thread_flag(TIF_SECCOMP);
>  		ret = 0;
> +		break;
> +	case 2:
> +		if (filters) {
> +			ret = seccomp_parse_filters(state, filters);
> +			/* No partial applications. */
> +			if (ret)
> +				goto free_state;
> +		}
> +
> +		if (!state->mode) {
> +			state->mode = seccomp_mode;
> +			set_thread_flag(TIF_SECCOMP);
> +		}
> +		break;
> +	default:
> +		ret = -EINVAL;
>  	}
>  
> - out:
> +	rcu_assign_pointer(current->seccomp.state, state);
> +	synchronize_rcu();
> +	put_seccomp_state(orig_state);  /* for the get */
> +
> +out:
> +	put_seccomp_state(orig_state);  /* for the task */
> +	return ret;
> +
> +free_state:
> +	put_seccomp_state(orig_state);  /* for the get */
> +	put_seccomp_state(state);  /* drop the dup */
>  	return ret;
>  }

This looks exactly right.  The only case where put_seccomp_state()
might actually lead to freeing the state is where the current's
state gets reassigned.  So you need to synchronize_rcu() before
that (as you do).  The other cases will only decrement the usage
counter, can race with a reader doing (inc; get) but not with a
final free, which can only be done here.

(Rambling above is just me pursuading myself)

> diff --git a/kernel/seccomp_filter.c b/kernel/seccomp_filter.c

Unfortunately your use of filters doesn't seem exactly right.

> +/* seccomp_copy_all_filters - copies all filters from src to dst.
> + *
> + * @dst: the list_head for seccomp_filters to populate.
> + * @src: the list_head for seccomp_filters to copy from.
> + * Returns non-zero on failure.
> + */
> +int seccomp_copy_all_filters(struct list_head *dst,
> +			     const struct list_head *src)
> +{
> +	struct seccomp_filter *filter;
> +	int ret = 0;
> +	BUG_ON(!dst || !src);
> +	if (list_empty(src))
> +		goto done;
> +	rcu_read_lock();
> +	list_for_each_entry(filter, src, list) {
> +		struct seccomp_filter *new_filter = copy_seccomp_filter(filter);

copy_seccomp_filter() causes kzalloc to be called.  You can't do that under
rcu_read_lock().

I actually thought you were going to be more extreme about the seccomp
state than you are:  I thought you were going to tie a filter list to
seccomp state.  So adding or removing a filter would have required
duping the seccomp state, duping all the filters, making the change in
the copy, and then swapping the new state into place.  Slow in the
hopefully rare update case, but safe.

You don't have to do that, but then I'm pretty sure you'll need to add
reference counts to each filter and use rcu cycles to a reader from
having the filter disappear mid-read.

-serge
