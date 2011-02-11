Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab1BKBcC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 20:32:02 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:41825 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1BKBcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 20:32:00 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 10 Feb 2011 17:27:55 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@localhost6.localdomain6
To: Nelson Elhage <nelhage@ksplice.com>
cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        security@kernel.org
Subject: Re: [PATCH] epoll: Prevent deadlock through unsafe ->f_op->poll()
 calls.
In-Reply-To: <20110207231540.GL8040@ksplice.com>
Message-ID: <alpine.DEB.2.00.1102101700430.19682@localhost6.localdomain6>
References: <1296954535-29495-1-git-send-email-nelhage@ksplice.com> <alpine.DEB.2.00.1102051916170.22851@localhost6.localdomain6> <alpine.DEB.2.00.1102061248420.3189@localhost6.localdomain6> <20110206224508.GA13579@ksplice.com>
 <alpine.DEB.2.00.1102061517370.3189@localhost6.localdomain6> <20110207231540.GL8040@ksplice.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Feb 2011, Nelson Elhage wrote:

> The point of grabbing epmutex is to make sure that the loop-check and the insert
> happen atomically with respect to any other such pair of operations, so you need
> to hold epmutex across both the check and the insert. Something like the
> following. It's not particularly pretty, but it seems to work.

Right we need to hold epmutex, and this is getting uglier than I though :|


> I also had to change the "cookie" value in ep_loop_check_proc from 'ep' to
> 'epi->ffd.file->private_data'; I think this is correct -- you want to avoid
> visiting the same _containing_ 'struct eventpoll' more than once. Without that
> fix, it doesn't detect the loop in my test case.

Also, an 'unlikely' on that 'if (did_lock_epmutex)' is due.
It probably deserves a few lines of comment at the top comment, where we 
describe the locking.
Do you mind posting a revised patch, while I go buying a brownbag to help 
me getting over those hacks?
having said NO to the 'epoll inside epoll' thing would have saved us a lot 
of headaches.



> This is minimally tested.
> 
> ---
>  fs/eventpoll.c |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 88 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index cc8a9b7..8a05f33 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -224,6 +224,9 @@ static long max_user_watches __read_mostly;
>   */
>  static DEFINE_MUTEX(epmutex);
> 
> +/* Used to check for epoll file descriptor inclusion loops */
> +static struct nested_calls poll_loop_ncalls;
> +
>  /* Used for safe wake up implementation */
>  static struct nested_calls poll_safewake_ncalls;
> 
> @@ -1188,6 +1191,62 @@ retry:
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
> +					       epi->ffd.file->private_data, current);
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
> @@ -1236,6 +1295,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
>  		struct epoll_event __user *, event)
>  {
>  	int error;
> +	int did_lock_epmutex = 0;
>  	struct file *file, *tfile;
>  	struct eventpoll *ep;
>  	struct epitem *epi;
> @@ -1277,6 +1337,25 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
>  	 */
>  	ep = file->private_data;
> 
> +	/*
> +	 * When we insert an epoll file descriptor, inside another epoll file
> +	 * descriptor, there is the change of creating closed loops, which are
> +	 * better be handled here, than in more critical paths.
> +	 *
> +	 * We hold epmutex across the loop check and the insert in this case, in
> +	 * order to prevent two separate inserts from racing and each doing the
> +	 * insert "at the same time" such that ep_loop_check passes on both
> +	 * before either one does the insert, thereby creating a cycle.
> +	 */
> +	if (unlikely(is_file_epoll(tfile) && op == EPOLL_CTL_ADD)) {
> +		mutex_lock(&epmutex);
> +		did_lock_epmutex = 1;
> +		error = -ELOOP;
> +		if (ep_loop_check(ep, tfile) != 0)
> +			goto error_tgt_fput;
> +	}
> +
> +
>  	mutex_lock(&ep->mtx);
> 
>  	/*
> @@ -1312,6 +1391,9 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
>  	mutex_unlock(&ep->mtx);
> 
>  error_tgt_fput:
> +	if (did_lock_epmutex)
> +		mutex_unlock(&epmutex);
> +
>  	fput(tfile);
>  error_fput:
>  	fput(file);
> @@ -1431,6 +1513,12 @@ static int __init eventpoll_init(void)
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
> --
> 1.7.2.43.g68ef4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


- Davide


