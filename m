Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab0EFSrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:47:31 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:42748 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab0EFSra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:47:30 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 6 May 2010 11:47:27 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Changli Gao <xiaosuo@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Takashi Iwai <tiwai@suse.de>,
       David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] epoll: use wrapper functions
In-Reply-To: <1273111054-10141-1-git-send-email-xiaosuo@gmail.com>
Message-ID: <alpine.DEB.2.00.1005061140100.2642@makko.or.mcafeemobile.com>
References: <1273111054-10141-1-git-send-email-xiaosuo@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010, Changli Gao wrote:

> use wrapper functions.
> 
> epoll should not touch flags in wait_queue_t. This patch introduces a new
> function add_wait_queue_head_exclusive_locked(), for the users, who use
> wait queue as a LIFO queue.

Since we already have __add_wait_queue(), __add_wait_queue_tail() and 
__remove_wait_queue() (which all means "locked"), and while I agree in 
having the exclusive-add wrapped into a function, I much better prefer a:

static inline void __add_wait_queue_excl(wait_queue_head_t *head, 
					 wait_queue_t *new)
{
	new->flags |= WQ_FLAG_EXCLUSIVE;
	__add_wait_queue(head, new);
}

The patch you posted introduces a different naming, which leaves all the 
other __*() untouched, and wraps the already one-liner __remove_wait_queue() 
with yet another one-liner.





> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> ----
>  fs/eventpoll.c       |    5 ++---
>  include/linux/wait.h |   15 +++++++++++++--
>  2 files changed, 15 insertions(+), 5 deletions(-)
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index bd056a5..8137f6e 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1140,8 +1140,7 @@ retry:
>  		 * ep_poll_callback() when events will become available.
>  		 */
>  		init_waitqueue_entry(&wait, current);
> -		wait.flags |= WQ_FLAG_EXCLUSIVE;
> -		__add_wait_queue(&ep->wq, &wait);
> +		add_wait_queue_head_exclusive_locked(&ep->wq, &wait);
>  
>  		for (;;) {
>  			/*
> @@ -1161,7 +1160,7 @@ retry:
>  			jtimeout = schedule_timeout(jtimeout);
>  			spin_lock_irqsave(&ep->lock, flags);
>  		}
> -		__remove_wait_queue(&ep->wq, &wait);
> +		remove_wait_queue_locked(&ep->wq, &wait);
>  
>  		set_current_state(TASK_RUNNING);
>  	}
> diff --git a/include/linux/wait.h b/include/linux/wait.h
> index a48e16b..de2566d 100644
> --- a/include/linux/wait.h
> +++ b/include/linux/wait.h
> @@ -407,17 +407,28 @@ do {									\
>   * Must be called with the spinlock in the wait_queue_head_t held.
>   */
>  static inline void add_wait_queue_exclusive_locked(wait_queue_head_t *q,
> -						   wait_queue_t * wait)
> +						   wait_queue_t *wait)
>  {
>  	wait->flags |= WQ_FLAG_EXCLUSIVE;
>  	__add_wait_queue_tail(q,  wait);
>  }
>  
>  /*
> + * Must be called with the spinlock in the wait_queue_head_t held, and
> + * q must be for exclusive wait only.
> + */
> +static inline void add_wait_queue_head_exclusive_locked(wait_queue_head_t *q,
> +							wait_queue_t *wait)
> +{
> +	wait->flags |= WQ_FLAG_EXCLUSIVE;
> +	__add_wait_queue(q,  wait);
> +}
> +
> +/*
>   * Must be called with the spinlock in the wait_queue_head_t held.
>   */
>  static inline void remove_wait_queue_locked(wait_queue_head_t *q,
> -					    wait_queue_t * wait)
> +					    wait_queue_t *wait)
>  {
>  	__remove_wait_queue(q,  wait);
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


- Davide


