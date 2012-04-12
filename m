Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417Ab2DLAaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:30:52 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:37377 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2DLAau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 20:30:50 -0400
Date: Wed, 11 Apr 2012 17:30:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michel Machado <michel@digirati.com.br>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] rculist: Replaced list_first_entry_rcu() with
 list_first_or_null_rcu()
Message-ID: <20120412003044.GE2473@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1334081260.2342.20.camel@Thor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334081260.2342.20.camel@Thor>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041200-6148-0000-0000-000004F9A694
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 02:07:40PM -0400, Michel Machado wrote:
> Replaced list_first_entry_rcu() with list_first_or_null_rcu() because
> list_first_entry_rcu() is not safe as one can find in the comment that
> this patch also adds.
> 
> This patch incorporated Paul's suggestions to the previous version of
> this patch available here:
> 
> https://lkml.org/lkml/2012/4/2/536
> 
> This patch cannot break any upstream code because list_first_entry_rcu
> is not being used anywhere in the kernel (tested with grep(1)), and
> external code that uses it is probably broken already.

Thank you, Michel, I have queued this.

However, in the future, could you please configure your email client to
avoid breaking lines and could you please also run scripts/checkpatch.pl
on future patches?  Applying your patch took some hand-editing to merge
the broken lines and to remove trailing spaces on lines.

							Thanx, Paul

> Signed-off-by: Michel Machado <michel@digirati.com.br>
> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> CC: Dipankar Sarma <dipankar@in.ibm.com>
> ---
> 
> diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> index d079290..ef5da30 100644
> --- a/include/linux/rculist.h
> +++ b/include/linux/rculist.h
> @@ -228,18 +228,43 @@ static inline void list_splice_init_rcu(struct
> list_head *list,
>  	})
> 
>  /**
> - * list_first_entry_rcu - get the first element from a list
> + * Where are list_empty_rcu() and list_first_entry_rcu()?
> + *
> + * Implementing those functions following their counterparts
> list_empty() and
> + * list_first_entry() is not advisable because they lead to subtle race
> + * conditions as the following snippet shows:
> + * 
> + * if (!list_empty_rcu(mylist)) {
> + * 	struct foo *bar = list_first_entry_rcu(mylist, struct foo,
> list_member);
> + * 	do_something(bar);
> + * }
> + *
> + * The list may not be empty when list_empty_rcu checks it, but it may
> be when
> + * list_first_entry_rcu rereads the ->next pointer.
> + *
> + * Rereading the ->next pointer is not a problem for list_empty() and
> + * list_first_entry() because they would be protected by a lock that
> blocks
> + * writers.
> + *
> + * See list_first_or_null_rcu for an alternative.
> + */
> +
> +/**
> + * list_first_or_null_rcu - get the first element from a list
>   * @ptr:        the list head to take the element from.
>   * @type:       the type of the struct this is embedded in.
>   * @member:     the name of the list_struct within the struct.
>   *
> - * Note, that list is expected to be not empty.
> + * Note that if the list is empty, it returns NULL.
>   *
>   * This primitive may safely run concurrently with the _rcu
> list-mutation
>   * primitives such as list_add_rcu() as long as it's guarded by
> rcu_read_lock().
>   */
> -#define list_first_entry_rcu(ptr, type, member) \
> -	list_entry_rcu((ptr)->next, type, member)
> +#define list_first_or_null_rcu(ptr, type, member) \
> +	({struct list_head *__ptr = (ptr); \
> +	  struct list_head __rcu *__next = list_next_rcu(__ptr); \
> +	  likely(__ptr != __next) ? container_of(__next, type, member) : NULL;
> \
> +	})
> 
>  /**
>   * list_for_each_entry_rcu	-	iterate over rcu list of given type
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

