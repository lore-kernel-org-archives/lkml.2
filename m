Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab2LVQye (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 11:54:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab2LVQyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 11:54:32 -0500
Date: Sat, 22 Dec 2012 17:54:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH review 2/3] pidns: Stop pid allocation when init dies
Message-ID: <20121222165438.GA19680@redhat.com>
References: <87d2y2elbi.fsf@xmission.com> <871ueiel9d.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871ueiel9d.fsf@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21, Eric W. Biederman wrote:
>
> --- a/include/linux/pid_namespace.h
> +++ b/include/linux/pid_namespace.h
> @@ -21,7 +21,7 @@ struct pid_namespace {
>  	struct kref kref;
>  	struct pidmap pidmap[PIDMAP_ENTRIES];
>  	int last_pid;
> -	int nr_hashed;
> +	unsigned int nr_hashed;
>  	struct task_struct *child_reaper;
>  	struct kmem_cache *pid_cachep;
>  	unsigned int level;
> @@ -42,6 +42,8 @@ struct pid_namespace {
>
>  extern struct pid_namespace init_pid_ns;
>
> +#define PIDNS_HASH_ADDING (1U << 31)

Yes, agreed. We can't rely on PF_EXITING/whatever, we need the explicit
flag.

1/2 looks fine too. Only one nit about init_pid_ns below...


> @@ -319,7 +318,7 @@ struct pid *alloc_pid(struct pid_namespace *ns)
>
>  	upid = pid->numbers + ns->level;
>  	spin_lock_irq(&pidmap_lock);
> -	if (ns->nr_hashed < 0)
> +	if (ns->nr_hashed < PIDNS_HASH_ADDING)

I won't insist, but perhaps if "(!(nr_hashed & PIDNS_HASH_ADDING))"
looks more understandable.

> +void disable_pid_allocation(struct pid_namespace *ns)
> +{
> +	spin_lock_irq(&pidmap_lock);
> +	if (ns->nr_hashed >= PIDNS_HASH_ADDING)

Do we really need this check? It seems that PIDNS_HASH_ADDING
bit must be always set when disable_pid_allocation() is called.

> +		ns->nr_hashed -= PIDNS_HASH_ADDING;

Anyway, nr_hashed &= ~PIDNS_HASH_ADDING looks simpler and doesn't
need a check.

But again, I won't insist this is minor and subjective.

>  struct pid *find_pid_ns(int nr, struct pid_namespace *ns)
>  {
>  	struct hlist_node *elem;
> @@ -584,7 +591,7 @@ void __init pidmap_init(void)
>  	/* Reserve PID 0. We never call free_pidmap(0) */
>  	set_bit(0, init_pid_ns.pidmap[0].page);
>  	atomic_dec(&init_pid_ns.pidmap[0].nr_free);
> -	init_pid_ns.nr_hashed = 1;
> +	init_pid_ns.nr_hashed = 1 + PIDNS_HASH_ADDING;

The obly chunk which doesn't look exactly correct to me, although this
doesn't really matter. Hmm, actually the code was already wrong before
this patch.

I think init_pid_ns.nr_hashed should be PIDNS_HASH_ADDING, we should not
add 1 to account the unused zero pid, and kernel_thread(kernel_init) was
not called yet.

Oleg.

