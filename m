Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187Ab0DGR2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 13:28:30 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47880 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab0DGR22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 13:28:28 -0400
Date: Wed, 7 Apr 2010 10:28:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: eric.dumazet@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RCU: Better explain the condition parameter of
 rcu_dereference_check()
Message-ID: <20100407172824.GG2481@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100407171500.27710.88994.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100407171500.27710.88994.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 06:15:00PM +0100, David Howells wrote:
> Better explain the condition parameter of rcu_dereference_check() that
> describes the conditions under which the dereference is permitted to take
> place.  This condition is only checked under lockdep proving.

Very good, I have queued this.  Thank you!

							Thanx, Paul

> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  include/linux/rcupdate.h |   28 +++++++++++++++++++++++-----
>  1 files changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 872a98e..acf9958 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -195,12 +195,30 @@ static inline int rcu_read_lock_sched_held(void)
> 
>  /**
>   * rcu_dereference_check - rcu_dereference with debug checking
> + * @p: The pointer to read, prior to dereferencing
> + * @c: The conditions under which the dereference will take place
>   *
> - * Do an rcu_dereference(), but check that the context is correct.
> - * For example, rcu_dereference_check(gp, rcu_read_lock_held()) to
> - * ensure that the rcu_dereference_check() executes within an RCU
> - * read-side critical section.  It is also possible to check for
> - * locks being held, for example, by using lockdep_is_held().
> + * Do an rcu_dereference(), but check that the conditions under which the
> + * dereference will take place are correct.  Typically the conditions indicate
> + * the various locking conditions that should be held at that point.  The check
> + * should return true if the conditions are satisfied.
> + *
> + * For example:
> + *
> + *	bar = rcu_dereference_check(foo->bar, rcu_read_lock_held() ||
> + *					      lockdep_is_held(&foo->lock));
> + *
> + * could be used to indicate to lockdep that foo->bar may only be dereferenced
> + * if either the RCU read lock is held, or that the lock required to replace
> + * the bar struct at foo->bar is held.
> + *
> + * Note that the list of conditions may also include indications of when a lock
> + * need not be held, for example during initialisation or destruction of the
> + * target struct:
> + *
> + *	bar = rcu_dereference_check(foo->bar, rcu_read_lock_held() ||
> + *					      lockdep_is_held(&foo->lock),
> + *					      atomic_read(&foo->usage) == 0);
>   */
>  #define rcu_dereference_check(p, c) \
>  	({ \
> 
