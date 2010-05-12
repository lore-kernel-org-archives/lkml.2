Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab0ELLEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 07:04:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535Ab0ELLEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 07:04:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1273634462-2672-3-git-send-email-walken@google.com>
References: <1273634462-2672-3-git-send-email-walken@google.com> <1273634462-2672-1-git-send-email-walken@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 02/12] rwsem: use single atomic update for sem count when waking up readers.
Date: Wed, 12 May 2010 12:01:10 +0100
Message-ID: <28032.1273662070@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

> - *   - there must be someone on the queue
> + * - there must be someone on the queue

Why did you change this comment?  This is still a guarantee up_xxxx() must
make about the state of the rwsem.

> +	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
> +	if (!(waiter->flags & RWSEM_WAITING_FOR_WRITE))
> +		goto readers_only;
> +
>  	if (downgrading)
> -		goto dont_wake_writers;
> +		/* Caller's lock is still active, so we can't possibly
> +		 * succeed waking writers.
> +		 */
> +		goto out;

It's a nice idea to do it this way round - it puts the wake-up-reader path
first and puts the downgrader on the slower path.

> -	/* if we came through an up_xxxx() call, we only only wake someone up
> +	/* There's a writer at the front of the queue - try to grant it the
> +	 * write lock. However, we only only wake someone up
>  	 * if we can transition the active part of the count from 0 -> 1
>  	 */

Two spaces after a full stop, please, and can you please adjust the comment so
that it fills out to 80 chars.  E.g:

	/* There's a writer at the front of the queue - try to grant it the
	 * write lock.  However, we only only wake someone up if we can
	 * transition the active part of the count from 0 -> 1
	 */

instead of:

	/* There's a writer at the front of the queue - try to grant it the
	 * write lock. However, we only only wake someone up
	 * if we can transition the active part of the count from 0 -> 1
	 */

> + retry_readers:
> +	oldcount = rwsem_atomic_update(woken, sem) - woken;
> +	if (!downgrading && (oldcount & RWSEM_ACTIVE_MASK))

The problem with doing this here is that you may just have wasted all the work
you did working out what woken is going to be.  That may have been quite slow
as the CPU may have had to get hold of a bunch of cachelines that weren't in
its cache.  Furthermore, you are doing this under a spinlock, so you may have
lost your right to wake anyone up, and you'll be blocking the CPU that will be
allowed to perform the wakeup.

Incrementing the count first nets you a guarantee that you have the right to
wake things up.

You may point out that if there's no contention, then what your revised code
does doesn't slow anything down.  That's true, but on modern CPU's, neither
does the old code as the exclusively held cache line will lurk in the CPU's
cache until there's contention on it.

David
