Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab1BFWpO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 17:45:14 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63228 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab1BFWpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 17:45:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ksplice.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Tfnyaw8UZinxHTL3P4dK6+tYPaQQfOVRlo0o973K0xe9Q9FpEHu1oVnjKJQklIw+U0
         NQg3hFi90g/OBVX1aE9j8e4r6Ddz7AnlVFnJe+l9nzoRq4RTEk5aCBzzjtoq++kVnKrn
         LPBetJS72CSqHQA4z4uoKQpHQGOlDv4MIGR4k=
Date: Sun, 6 Feb 2011 17:45:08 -0500
From: Nelson Elhage <nelhage@ksplice.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        security@kernel.org
Subject: Re: [PATCH] epoll: Prevent deadlock through unsafe ->f_op->poll()
 calls.
Message-ID: <20110206224508.GA13579@ksplice.com>
References: <1296954535-29495-1-git-send-email-nelhage@ksplice.com>
 <alpine.DEB.2.00.1102051916170.22851@localhost6.localdomain6>
 <alpine.DEB.2.00.1102061248420.3189@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102061248420.3189@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suppose thread A does epoll_ctl(e1, EPOLL_CTL_ADD, e2, evt) concurrently with
thread B doing epoll_ctl(e2, EPOLL_CTL_ADD, e1, evt).

Since you do the recursive scan before grabbing ep->mtx, I think there is
nothing to prevent the two scans from both succeeding, followed by the two
inserts, so you end up with a cycle anyways.

Of course, if you move the scan after acquiring ep->mtx, then the threads would
be grabbing them in opposite orders, and you'd have an AB/BA deadlock.

One possibility is grabbing epmutex, or another global mutex, for both the scan
and the duration of inserting one epoll fd onto another. That's really
heavyweight, but maybe inserting an epoll fd onto another epoll fd is rare
enough that it's Ok.

- Nelson

On Sun, Feb 06, 2011 at 12:56:17PM -0800, Davide Libenzi wrote:
> On Sat, 5 Feb 2011, Davide Libenzi wrote:
> 
> > On Sat, 5 Feb 2011, Nelson Elhage wrote:
> > 
> > > In several places, an epoll fd can call another file's ->f_op->poll() method
> > > with ep->mtx held. This is in general unsafe, because that other file could
> > > itself be an epoll fd that contains the original epoll fd.
> > > 
> > > The code defends against this possibility in its own ->poll() method using
> > > ep_call_nested, but there are several other unsafe calls to ->poll elsewhere
> > > that can be made to deadlock. For example, the following simple program causes
> > > the call in ep_insert recursively call the original fd's ->poll, leading to
> > > deadlock:
> > > 
> > > ------------------------------8<------------------------------
> > >  #include <unistd.h>
> > >  #include <sys/epoll.h>
> > > 
> > >  int main(void) {
> > >      int e1, e2, p[2];
> > >      struct epoll_event evt = {
> > >          .events = EPOLLIN
> > >      };
> > > 
> > >      e1 = epoll_create(1);
> > >      e2 = epoll_create(2);
> > >      pipe(p);
> > > 
> > >      epoll_ctl(e2, EPOLL_CTL_ADD, e1, &evt);
> > >      epoll_ctl(e1, EPOLL_CTL_ADD, p[0], &evt);
> > >      write(p[1], p, sizeof p);
> > >      epoll_ctl(e1, EPOLL_CTL_ADD, e2, &evt);
> > > 
> > >      return 0;
> > >  }
> > > ------------------------------8<------------------------------
> > 
> > Yuck, true :|
> > The call nested function is heavy, and the patch below does it only if the 
> > file descriptor is an epoll one.
> > But, that does not fix the problem WRT the send-events proc, even if we 
> > call the new ep_poll_file().
> > At this point, we better remove the heavy checks from the fast path, and 
> > perform a check at insetion time, if the inserted fd is an epoll one.
> > That way, the price for the check is paid once, and only if the inserted 
> > fd is an epoll one.
> 
> Like the one below. I haven't tested it yet, but it should catch closed 
> loops attempts at insertion time (and only for epoll fds), and remove 
> heavy calls from the fast path.
> 
> 
> 
> - Davide
> 
> 
> ---
>  fs/eventpoll.c |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 74 insertions(+)
> 
> Index: linux-2.6.mod/fs/eventpoll.c
> ===================================================================
> --- linux-2.6.mod.orig/fs/eventpoll.c	2011-02-06 11:42:38.000000000 -0800
> +++ linux-2.6.mod/fs/eventpoll.c	2011-02-06 12:51:27.000000000 -0800
> @@ -224,6 +224,9 @@
>   */
>  static DEFINE_MUTEX(epmutex);
>  
> +/* Used to check for epoll file descriptor inclusion loops */
> +static struct nested_calls poll_loop_ncalls;
> +
>  /* Used for safe wake up implementation */
>  static struct nested_calls poll_safewake_ncalls;
>  
> @@ -1198,6 +1201,62 @@
>  	return res;
>  }
>  
> +/**
> + * ep_loop_check_proc - Callback function to be passed to the @ep_call_nested()
> + *                      API, to verify that adding an epoll file inside another
> + *                      epoll structure, does not violate the constraints, in
> + *                      terms of closed loops, or too deep chains (which can
> + *                      result in excessive stack usage).
> + *
> + * @priv: Pointer to the epoll file to be currently checked.
> + * @cookie: Original cookie for this call. This is the top-of-the-chain epoll
> + *          data structure pointer.
> + * @call_nests: Current dept of the @ep_call_nested() call stack.
> + *
> + * Returns: Returns zero if adding the epoll @file inside current epoll
> + *          structure @ep does not violate the constraints, or -1 otherwise.
> + */
> +static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
> +{
> +	int error = 0;
> +	struct file *file = priv;
> +	struct eventpoll *ep = file->private_data;
> +	struct rb_node *rbp;
> +	struct epitem *epi;
> +
> +	mutex_lock(&ep->mtx);
> +	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
> +		epi = rb_entry(rbp, struct epitem, rbn);
> +		if (unlikely(is_file_epoll(epi->ffd.file))) {
> +			error = ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
> +					       ep_loop_check_proc, epi->ffd.file,
> +					       ep, current);
> +			if (error != 0)
> +				break;
> +		}
> +	}
> +	mutex_unlock(&ep->mtx);
> +
> +	return error;
> +}
> +
> +/**
> + * ep_loop_check - Performs a check to verify that adding an epoll file (@file)
> + *                 another epoll file (represented by @ep) does not create
> + *                 closed loops or too deep chains.
> + *
> + * @ep: Pointer to the epoll private data structure.
> + * @file: Pointer to the epoll file to be checked.
> + *
> + * Returns: Returns zero if adding the epoll @file inside current epoll
> + *          structure @ep does not violate the constraints, or -1 otherwise.
> + */
> +static int ep_loop_check(struct eventpoll *ep, struct file *file)
> +{
> +	return ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
> +			      ep_loop_check_proc, file, ep, current);
> +}
> +
>  /*
>   * Open an eventpoll file descriptor.
>   */
> @@ -1287,6 +1346,15 @@
>  	 */
>  	ep = file->private_data;
>  
> +	/*
> +	 * When we insert an epoll file descriptor, inside another epoll file
> +	 * descriptor, there is the change of creating closed loops, which are
> +	 * better be handled here, than in more critical paths.
> +	 */
> +	if (unlikely(is_file_epoll(tfile) && op == EPOLL_CTL_ADD &&
> +		     ep_loop_check(ep, tfile) != 0))
> +		goto error_tgt_fput;
> +
>  	mutex_lock(&ep->mtx);
>  
>  	/*
> @@ -1441,6 +1509,12 @@
>  		EP_ITEM_COST;
>  	BUG_ON(max_user_watches < 0);
>  
> +	/*
> +	 * Initialize the structure used to perform epoll file descriptor
> +	 * inclusion loops checks.
> +	 */
> +	ep_nested_calls_init(&poll_loop_ncalls);
> +
>  	/* Initialize the structure used to perform safe poll wait head wake ups */
>  	ep_nested_calls_init(&poll_safewake_ncalls);
>  
