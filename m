Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab0JJTGC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 15:06:02 -0400
Received: from xenotime.net ([72.52.115.56]:37109 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751008Ab0JJTGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 15:06:00 -0400
Date: Sun, 10 Oct 2010 12:05:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Robin Holt <holt@sgi.com>, akpm <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Convert max_user_watches to long.
Message-Id: <20101010120553.21299e34.rdunlap@xenotime.net>
In-Reply-To: <20101009075002.GW14068@sgi.com>
References: <20101001200143.GR14064@sgi.com>
	<alpine.DEB.2.00.1010011335400.2305@ubuntu>
	<m1vd5ll2hl.fsf@fess.ebiederm.org>
	<alpine.DEB.2.00.1010020701320.1564@davide-laptop>
	<20101004194411.GT14068@sgi.com>
	<alpine.DEB.2.00.1010051841050.1941@ubuntu>
	<20101009075002.GW14068@sgi.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Oct 2010 02:50:02 -0500 Robin Holt wrote:

> On Tue, Oct 05, 2010 at 07:21:09PM -0700, Davide Libenzi wrote:
> > On Mon, 4 Oct 2010, Robin Holt wrote:
> > 
> > > On a 16TB machine, max_user_watches has an integer overflow.  Convert it
> > > to use a long and handle the associated fallout.
> > > 
> > > 
> > > Signed-off-by: Robin Holt <holt@sgi.com>
> > > To: "Eric W. Biederman" <ebiederm@xmission.com>
> > > To: Davide Libenzi <davidel@xmailserver.org>
> > > To: linux-kernel@vger.kernel.org
> > > To: Pekka Enberg <penberg@cs.helsinki.fi>
> > > 
> > > ---
> > > 
> > > Davide,  I changed the logic a bit in ep_insert.  It looked to me like
> > > there was a window between when the epoll_watches is checked and when it
> > > is incremented where multiple epoll_insert callers could be adding watches
> > > at the same time and allow epoll_watches to exceed max_user_watches.
> > > Not sure of the case where this could happen, but I assume something
> > > like that must be possible or we would not be using atomics.  If that
> > > is not to your liking, I will happily remove it.
> > 
> > The case can happen, but the effect is not something we should be too 
> > worried about.
> > You seem to be leaking a count in case kmem_cache_alloc() and following 
> > fail.
> > I'd rather not have that code there, and have the patch cover the 'long' 
> > conversion only.  Or you need a proper cleanup goto target.
> 
> Bah.  Too rushed when I made that.  Here is the conversion only patch.  If
> this is acceptable, what is the normal submission path for fs/eventpoll.c?

git log looks mostly like either thru Andrew or straight to Linus.

> Robin
> 
> ------------------------------------------------------------------------
> 
> On a 16TB machine, max_user_watches has an integer overflow.  Convert it
> to use a long and handle the associated fallout.
> 
> 
> Signed-off-by: Robin Holt <holt@sgi.com>
> To: "Eric W. Biederman" <ebiederm@xmission.com>
> To: Davide Libenzi <davidel@xmailserver.org>
> To: linux-kernel@vger.kernel.org
> To: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> ---
> 
>  fs/eventpoll.c        |   20 ++++++++++++--------
>  include/linux/sched.h |    2 +-
>  2 files changed, 13 insertions(+), 9 deletions(-)
> 
> Index: pv1010933/fs/eventpoll.c
> ===================================================================
> --- pv1010933.orig/fs/eventpoll.c	2010-10-04 14:41:59.000000000 -0500
> +++ pv1010933/fs/eventpoll.c	2010-10-09 02:40:07.360573988 -0500
> @@ -220,7 +220,7 @@ struct ep_send_events_data {
>   * Configuration options available inside /proc/sys/fs/epoll/
>   */
>  /* Maximum number of epoll watched descriptors, per user */
> -static int max_user_watches __read_mostly;
> +static long max_user_watches __read_mostly;
>  
>  /*
>   * This mutex is used to serialize ep_free() and eventpoll_release_file().
> @@ -243,16 +243,18 @@ static struct kmem_cache *pwq_cache __re
>  
>  #include <linux/sysctl.h>
>  
> -static int zero;
> +static long zero;
> +static long long_max = LONG_MAX;
>  
>  ctl_table epoll_table[] = {
>  	{
>  		.procname	= "max_user_watches",
>  		.data		= &max_user_watches,
> -		.maxlen		= sizeof(int),
> +		.maxlen		= sizeof(max_user_watches),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dointvec_minmax,
> +		.proc_handler	= proc_doulongvec_minmax,
>  		.extra1		= &zero,
> +		.extra2		= &long_max,
>  	},
>  	{ }
>  };
> @@ -564,7 +566,7 @@ static int ep_remove(struct eventpoll *e
>  	/* At this point it is safe to free the eventpoll item */
>  	kmem_cache_free(epi_cache, epi);
>  
> -	atomic_dec(&ep->user->epoll_watches);
> +	atomic_long_dec(&ep->user->epoll_watches);
>  
>  	return 0;
>  }
> @@ -900,11 +902,12 @@ static int ep_insert(struct eventpoll *e
>  {
>  	int error, revents, pwake = 0;
>  	unsigned long flags;
> +	long user_watches;
>  	struct epitem *epi;
>  	struct ep_pqueue epq;
>  
> -	if (unlikely(atomic_read(&ep->user->epoll_watches) >=
> -		     max_user_watches))
> +	user_watches = atomic_long_read(&ep->user->epoll_watches);
> +	if (user_watches >= max_user_watches)
>  		return -ENOSPC;
>  	if (!(epi = kmem_cache_alloc(epi_cache, GFP_KERNEL)))
>  		return -ENOMEM;
> @@ -968,7 +971,7 @@ static int ep_insert(struct eventpoll *e
>  
>  	spin_unlock_irqrestore(&ep->lock, flags);
>  
> -	atomic_inc(&ep->user->epoll_watches);
> +	atomic_long_inc(&ep->user->epoll_watches);
>  
>  	/* We have to call this outside the lock */
>  	if (pwake)
> @@ -1422,6 +1425,7 @@ static int __init eventpoll_init(void)
>  	 */
>  	max_user_watches = (((si.totalram - si.totalhigh) / 25) << PAGE_SHIFT) /
>  		EP_ITEM_COST;
> +	BUG_ON(max_user_watches < 0);
>  
>  	/* Initialize the structure used to perform safe poll wait head wake ups */
>  	ep_nested_calls_init(&poll_safewake_ncalls);
> Index: pv1010933/include/linux/sched.h
> ===================================================================
> --- pv1010933.orig/include/linux/sched.h	2010-10-04 14:41:59.000000000 -0500
> +++ pv1010933/include/linux/sched.h	2010-10-04 14:42:01.123824797 -0500
> @@ -666,7 +666,7 @@ struct user_struct {
>  	atomic_t inotify_devs;	/* How many inotify devs does this user have opened? */
>  #endif
>  #ifdef CONFIG_EPOLL
> -	atomic_t epoll_watches;	/* The number of file descriptors currently watched */
> +	atomic_long_t epoll_watches; /* The number of file descriptors currently watched */
>  #endif
>  #ifdef CONFIG_POSIX_MQUEUE
>  	/* protected by mq_lock	*/
> --

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
