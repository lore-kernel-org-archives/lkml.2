Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab1GVQWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 12:22:20 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44706 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab1GVQWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 12:22:19 -0400
Date: Fri, 22 Jul 2011 09:21:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jan =?iso-8859-1?Q?H=2E_Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/3] rcu: More rcu-variants for list manipulation
Message-ID: <20110722162149.GE2382@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAPM31RLqq0hgdhoh3GA-38petKeE1zxcL=uJYba9o3yd+_7jjw@mail.gmail.com>
 <1311254423-25484-1-git-send-email-schnhrr@cs.tu-berlin.de>
 <1311254423-25484-3-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1311254423-25484-3-git-send-email-schnhrr@cs.tu-berlin.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 03:20:22PM +0200, Jan H. Schönherr wrote:
> From: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
> 
> This commit introduces some more *_rcu variants of some list
> manipulation functions:
> 
> __list_link_rcu()
> __list_splice_rcu()
> list_splice_tail_init_rcu()
> 
> An important difference of the new rcu-splice functions
> compared to the existing function is that they require
> that there are either no concurrent readers on the list to
> be spliced or that these readers are still from the list
> where the list is spliced into.

Please see below for some comments on issues you are probably already
well aware of -- just commenting, the code itself looks OK.  Once this
patch is in good shape, it should probably go with the following patch
(which uses it) rather than up -rcu.

						Thanx, Paul

> Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
> 
> ---
> TODO:
> - add comments
> - rephrase existing splice function using __list_splice_rcu()
>   and probably add "_sync" to the name
> ---
>  include/linux/rculist.h |   26 ++++++++++++++++++++++++++
>  1 files changed, 26 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> index 748401b..56385c8 100644
> --- a/include/linux/rculist.h
> +++ b/include/linux/rculist.h
> @@ -24,6 +24,15 @@
>   */
>  #define list_next_rcu(list)	(*((struct list_head __rcu **)(&(list)->next)))
> 

Badly need a header comment here!!!  This needs to include locking
constraints and RCU reader constraints.

Including why you have "prev" then "next" rather than the other
way around.  (Which I believe I figured out below.)

> +static inline void __list_link_rcu(struct list_head *prev,
> +					struct list_head *next)
> +{
> +	rcu_assign_pointer(list_next_rcu(prev), next);
> +	next->prev = prev;
> +}

OK, so this one links a single list element to another single list
element.  You therefore need two calls to this to splice a pair of list
together, right?  If so, there will be a time when you have a "6" shaped
list, so that readers from one of the list heads will never come back
to that list head.  This is probably what you are getting at with your
"require that there are either no concurrent readers on the list to be
spliced or that these readers are still from the list where the list is
spliced into".

However, this is quite subtle and needs to be spelled out carefully.

As I understand it, when you splice together a list A and a list B,
then list A cannot have any concurrent readers, but list B can.
And then you have to do the __list_link_rcu() operations (along maybe
with __list_link() operations) in a particular order.  These constraints
need to be carefully documented, and uses need to be commented.

> +
> +
>  /*
>   * Insert a new entry between two known consecutive entries.
>   *
> @@ -158,6 +167,23 @@ static inline void list_replace_rcu(struct list_head *old,
>  	old->prev = LIST_POISON2;
>  }

Really badly need a header comment here!!!  Which of these lists can
tolerate concurrent readers?  Why are there three arguments?  My guess
from the code is that "list" is the list being spliced, and it cannot
tolerate concurrent readers, while "prev" is one end of the place to
splice into the list and "next" is the other.  I believe that both "prev"
and "next" can tolerate concurrent readers.

Did I get it right?

Of course, if I got it wrong, that just proves how important the
documentation is!  ;-)

And I still don't understand why the argument order isn't list, next,
then prev -- after all, isn't that the order that the elements will
appear on the spliced list?  Ah, you are worried about the local order
at the splice point...  OK, then please include this in the comment.

Yeah, I know, the include/linux/list.h comments aren't all that detailed.
On the other hand, the include/linux/list.h primitives don't have to
worry about concurrent readers.  So please add detailed comments.  ;-)

> +static inline void __list_splice_rcu(struct list_head *list,
> +					struct list_head *prev,
> +					struct list_head *next)
> +{
> +	__list_link(list->prev, next);

At this point, RCU readers traversing the list containing "prev" and
"next" see no change, which is why it is OK to use __list_link() rather
than __list_link_rcu().  If there are readers traversing "list", they
will loop infinitely failing to find the old list header.

> +	__list_link_rcu(prev, list->next);

At this point, new RCU readers traversing the list containing
"next" and "prev" suddenly see the new elements from "list".  The
rcu_assign_pointer() in __lists_link_rcu() should force proper ordering.

OK, so looks reasonable.  Assuming that my guesses about what this is
supposed to do are correct, anyway.

> +}

And badly need a comment here, especially regarding which list is
being spliced into which.  The usual convention would be that
list is being spliced into head.

> +static inline void list_splice_tail_init_rcu(struct list_head *list,
> +						struct list_head *head)
> +{
> +	if (!list_empty(list)) {
> +		__list_splice_rcu(list, head->prev, head);
> +		INIT_LIST_HEAD(list);
> +	}
> +}

OK, so if "list" is non-empty, we splice its elements to precede
"head".

							Thanx, Paul

>  /**
>   * list_splice_init_rcu - splice an RCU-protected list into an existing list.
>   * @list:	the RCU-protected list to splice
> -- 
> 1.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
