Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab0JOTTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:19:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:53496 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077Ab0JOTTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:19:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,337,1283756400"; 
   d="scan'208";a="847584619"
Message-ID: <4CB8A944.8090904@linux.intel.com>
Date: Fri, 15 Oct 2010 12:19:32 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100922 Thunderbird/3.1.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Louis Rilling <louis.rilling@kerlabs.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        =?ISO-8859-15?Q?Matthieu_Fertr=E9?= <matthieu.fertre@kerlabs.com>,
        Darren Hart <darren@dvhart.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RESEND PATCH] futex: fix key reference counter in case of requeue.
References: <1287055805-18233-1-git-send-email-louis.rilling@kerlabs.com> <alpine.LFD.2.00.1010151228130.2496@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010151228130.2496@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2010 05:16 AM, Thomas Gleixner wrote:
> On Thu, 14 Oct 2010, Louis Rilling wrote:

...

>> Once process P is woken up, it should unqueue, drop reference to 'key2'
>> (the one referring to the futex_q, this is done in unqueue_me())
>> and to 'key1' (the one referring to futex_wait operation). Without this
>> patch it drops reference to 'key2' instead of 'key1'.
>
> I can see the bug, but while the patch fixes it I don't think it is
> the proper solution. Aside of that we might have a similar problem in
> the futex_wait_requeue_pi() code.


We do, and it's a bit more tangled. No surprises there.


> The real underlying problem is, that futex_wait_setup() returns with
> two references held in the case of success. That's what needs to be
> fixed in the first place.
>
> The futex_wait() case can be fixed with the patch below, still looking
> into the futex_wait_requeue_pi() maze.
>
> Darren, this whole key refcounting needs to be simplified _AND_
> documented.


Agreed. We'll get this and futex_wait_requeue_pi fixed now, and then 
I'll spend some time cleaning this mess up after LPC.

I'll test the following along with a wait_requeue_pi fix and report back.

--
Darren

>
> Thanks,
>
> 	tglx
> ---
> Index: linux-2.6-tip/kernel/futex.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/futex.c
> +++ linux-2.6-tip/kernel/futex.c
> @@ -1786,8 +1786,14 @@ retry_private:
>   	}
>
>   out:
> -	if (ret)
> -		put_futex_key(fshared,&q->key);
> +	/*
> +	 * On success we hold here two references acquired in
> +	 * get_futex_key() and queue_lock(). Drop one.
> +	 *
> +	 * On failure we hold one reference acquired in
> +	 * get_futex_key(). Drop it.
> +	 */
> +	put_futex_key(fshared,&q->key);
>   	return ret;
>   }
>
> @@ -1819,7 +1825,7 @@ static int futex_wait(u32 __user *uaddr,
>   	}
>
>   retry:
> -	/* Prepare to wait on uaddr. */
> +	/* Prepare to wait on uaddr. Hold hb lock and  q.key ref on success */
>   	ret = futex_wait_setup(uaddr, val, fshared,&q,&hb);
>   	if (ret)
>   		goto out;
> @@ -1829,24 +1835,23 @@ retry:
>
>   	/* If we were woken (and unqueued), we succeeded, whatever. */
>   	ret = 0;
> +	/* unqueue_me() drops q.key ref */
>   	if (!unqueue_me(&q))
> -		goto out_put_key;
> +		goto out;
>   	ret = -ETIMEDOUT;
>   	if (to&&  !to->task)
> -		goto out_put_key;
> +		goto out;
>
>   	/*
>   	 * We expect signal_pending(current), but we might be the
>   	 * victim of a spurious wakeup as well.
>   	 */
> -	if (!signal_pending(current)) {
> -		put_futex_key(fshared,&q.key);
> +	if (!signal_pending(current))
>   		goto retry;
> -	}
>
>   	ret = -ERESTARTSYS;
>   	if (!abs_time)
> -		goto out_put_key;
> +		goto out;
>
>   	restart =&current_thread_info()->restart_block;
>   	restart->fn = futex_wait_restart;
> @@ -1863,8 +1868,6 @@ retry:
>
>   	ret = -ERESTART_RESTARTBLOCK;
>
> -out_put_key:
> -	put_futex_key(fshared,&q.key);
>   out:
>   	if (to) {
>   		hrtimer_cancel(&to->timer);


-- 
Darren Hart
Embedded Linux Kernel
