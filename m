Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab2JWJuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:50:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:42925 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab2JWJuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:50:23 -0400
Date: Tue, 23 Oct 2012 11:50:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
cc: peterz@infradead.org, mingo@redhat.com, devel@openvz.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        xemul@parallels.com
Subject: Re: [PATCH v5] posix timers: allocate timer id per process
In-Reply-To: <20121023073913.23514.87934.stgit@localhost.localdomain>
Message-ID: <alpine.LFD.2.02.1210231047270.2756@ionos>
References: <20121023073913.23514.87934.stgit@localhost.localdomain>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2601;0cOn Tue, 23 Oct 2012, Stanislav Kinsbursky wrote:
> Patch replaces global idr with global hash table for posix timers and
> makes timer ids unique not globally, but per process. Next free timer id is
> type of integer and stored on signal struct (posix_timer_id). If free timer id
> reaches negative value on timer creation, it will be dropped to zero and
> -EAGAIN will be returned to user.

That's the theory ...
 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 0dd42a0..dce1651 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -51,6 +51,7 @@ struct sched_param {
>  #include <linux/cred.h>
>  #include <linux/llist.h>
>  #include <linux/uidgid.h>
> +#include <linux/idr.h>

Why ?

> +static int posix_timer_add(struct k_itimer *timer)
> +{
> +	struct signal_struct *sig = current->signal;
> +	int next_free_id = sig->posix_timer_id;
> +	struct hlist_head *head;
> +	int ret = -ENOENT;
> +
> +	do {
> +		spin_lock(&hash_lock);
> +		head = &posix_timers_hashtable[hash(sig, sig->posix_timer_id)];
> +		if (!__posix_timers_find(head, sig, sig->posix_timer_id)) {
> +			hlist_add_head_rcu(&timer->t_hash, head);
> +			ret = sig->posix_timer_id++;

Let's assume a program, which creates timers and destroys them in a
loop.

	while (1) {
	      id = timer_create();
	      if (id < 0)
	      	 continue;
	      timer_delete(id);
	}

After 2^31 iterations sig->posix_timer_id contains 0x80000000.

__posix_timer_find() will return NULL as there is no timer with this
id and you happily add the new timer to the hash list and return
0x80000000, which translates to -INT_MAX.

Now this will return a totally useless error code to user space and
what's worse it will free that timer without removing it from the hash
bucket. The next access to that bucket will explode nicely.

> +		} else {
> +			if (++sig->posix_timer_id < 0)
> +				sig->posix_timer_id = 0;
> +			if (sig->posix_timer_id == next_free_id)
> +				ret = -EAGAIN;

This code path has obvioulsy never been executed.

> +		}
> +		spin_unlock(&hash_lock);
> +	} while (ret == -ENOENT);
> +	return ret;
> +}

Thanks,

	tglx
