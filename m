Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab1G1RBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 13:01:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45885 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755807Ab1G1RBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 13:01:00 -0400
Date: Thu, 28 Jul 2011 13:00:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Chris <chris@2net.co.uk>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, <mingo@redhat.com>
Subject: Re: [RFC] [PATCH] Lightweight kernel condition variables: faster
 code, fewer bugs
In-Reply-To: <4E2FE47F.1080406@2net.co.uk>
Message-ID: <Pine.LNX.4.44L0.1107281256240.1990-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011, Chris Simmonds wrote:

> Hi,
> 
> This patch adds lightweight condition variables to the kernel to reduce 
> complexity and improve the efficiency of some synchronisation tasks. 
> They are very similar to POSIX condition variables.

...

> To wake up a thread sleeping on a condition variable you just use the 
> normal wakeup calls, nothing new there. Except of course that you need 
> to consider the locking round the variables (condition) that was just 
> modified, but that should be in place already. There are many other 
> examples in the code which could be improved in this way.
> 
> The patch that follows implements condition variables using mutexes and 
> various sorts of spinlock as the locking primitive. I am aware that I 
> have not covered all possibilities and that the code could be neater. At 
> this point I just want to show the idea and get feedback.

It seems like a reasonable sort of thing to do, as far as I can see.

> diff --git a/include/linux/wait.h b/include/linux/wait.h
> index 3efc9f3..76f9c25 100644
> --- a/include/linux/wait.h
> +++ b/include/linux/wait.h
> @@ -662,7 +662,89 @@ static inline int wait_on_bit_lock(void *word, int bit,
>   		return 0;
>   	return out_of_line_wait_on_bit_lock(word, bit, action, mode);
>   }
> -	
> +
> +/**
> + * cond_wait - wait for a condition variable
> + * @wq: the wait queue to wait on
> + * @mutex: a locked mutex
> + *
> + * Safely put the calling task into a non-interruptible sleep on the
> + * wait queue then unlock the mutex. Re-acquire the mutex after waking up
> + */
> +void cond_wait (wait_queue_head_t *wq, struct mutex *mutex)
> +{
> +	DEFINE_WAIT(__wait);
> +
> +	prepare_to_wait(wq, &__wait, TASK_UNINTERRUPTIBLE);
> +	mutex_unlock (mutex);
> +	schedule();
> +	mutex_lock (mutex);
> +	finish_wait(wq, &__wait);
> +}

One little problem here.  These routines may well be large enough
that it's inefficient to inline them.  In that case they should be 
declared in wait.h but defined somewhere else, such as kernel/wait.c.  
Conversely, if you do think they deserve to be inlined then they should 
be marked as such.

Alan Stern

P.S.: Does this come through checkpatch.pl unscathed?

