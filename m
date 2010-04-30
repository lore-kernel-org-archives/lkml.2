Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285Ab0D3R0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:26:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61217 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933016Ab0D3R0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:26:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hll3sMr6S82IDU6iNcb7ErU5FUVIkK4CnX7rXB0BLxnu7A9M80osYMslV0JBBvizJm
         bcL3KNaGvMUZt7dBCsR9aqfdIhjY11GFErKWGxl9XcRdVavm3Oa2TVmJUMKHOYk4LXd1
         PoYORP+oXmf9IRuWH15nTYk09CC/SjGpo3WcA=
Date: Fri, 30 Apr 2010 08:26:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] list: add singly-linked list and singly-linked tail list
Message-ID: <20100430062559.GB21078@nowhere>
References: <1272605795-15765-1-git-send-email-xiaosuo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272605795-15765-1-git-send-email-xiaosuo@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 01:36:35PM +0800, Changli Gao wrote:
> add singly-linked list and singly-linked tail list.
> 
> these two lists are also used widely in the kernel as doubly-linked list, so I
> am trying to add some APIs for these two lists to eliminate the duplicate code.



What callsites do you have in mind?



 
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> ----
>  include/linux/list.h |  186 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 186 insertions(+)
> diff --git a/include/linux/list.h b/include/linux/list.h
> index 8392884..048a579 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -706,4 +706,190 @@ static inline void hlist_move_list(struct hlist_head *old,
>  		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
>  	     pos = n)
>  
> +/* singly-linked list */
> +
> +struct slist_head {
> +	struct slist_head *next;
> +};



I would rather call that a stack and change the prefix:

struct stack_top {
	struct stack_top *next;
}

And have helpers named like stack_push(), stack_pop(), etc...



> +
> +#define slist_entry(ptr, type, member) \
> +	container_of(ptr, type, member)
> +
> +#define SLIST_HEAD_INIT { .next = NULL }
> +#define SLIST_HEAD(name) struct slist_head name = SLIST_HEAD_INIT
> +
> +static inline void INIT_SLIST_HEAD(struct slist_head *h)
> +{
> +	h->next = NULL;
> +}
> +
> +static inline bool slist_empty(struct slist_head *h)
> +{
> +	return h->next == NULL;
> +}
> +
> +static inline void slist_push(struct slist_head *n, struct slist_head *h)
> +{
> +	n->next = h->next;
> +	h->next = n;
> +}
> +
> +static inline struct slist_head *slist_pop(struct slist_head *h)
> +{
> +	struct slist_head *n;
> +
> +	n = h->next;
> +	if (n)
> +		h->next = n->next;
> +
> +	return n;
> +}
> +
> +static inline struct slist_head *slist_pop_init(struct slist_head *h)
> +{
> +	struct slist_head *n = slist_pop(h);
> +
> +	if (n)
> +		INIT_SLIST_HEAD(n);
> +
> +	return n;
> +}
> +
> +static inline void __slist_splice(struct slist_head *first,
> +				  struct slist_head *to)
> +{
> +	struct slist_head **ptail;
> +
> +	for (ptail = &to->next; *ptail; ptail = &(*ptail)->next)
> +		;
> +	*ptail = first;
> +}
> +
> +static inline void slist_splice_init(struct slist_head *from,
> +				     struct slist_head *to)
> +{
> +
> +	if (from->next != NULL) {
> +		__slist_splice(from->next, to);
> +		INIT_SLIST_HEAD(from);
> +	}
> +}
> +
> +#define slist_for_each(pos, head) \
> +	for (pos = (head)->next; pos && ({ prefetch(pos->next); 1; }); \
> +	     pos = pos->next)
> +
> +#define slist_for_each_entry(tpos, pos, head, member) \
> +	for (pos = (head)->next; \
> +	     pos && ({ prefetch(pos->next); 1; }) && \
> +		 ({ tpos = slist_entry(pos, typeof(*tpos), member); 1; }); \
> +	     pos = pos->next)
> +
> +#define slist_del(pos, n, ppos) \
> +	do { \
> +		*ppos = pos->next; \
> +		n = container_of(ppos, struct slist_head, next); \
> +	} while (0)
> +
> +#define slist_for_each_safe(pos, n, ppos, head) \
> +	for (ppos = &(head)->next; (n = pos = *ppos); ppos = &n->next)
> +
> +#define slist_for_each_entry_safe(tpos, pos, n, ppos, head, member) \
> +	for (ppos = &(head)->next; \
> +	     (n = pos = *ppos) && \
> +		  ({ tpos = slist_entry(pos, typeof(*tpos), member); 1; }); \
> +	     ppos = &n->next)
> +
> +/* singly-linked tail list */
> +
> +struct tlist_head {
> +	struct slist_head *next;
> +	struct slist_head **ptail;
> +};



Well. It's like list_head with a lowered memory footprint but
the loss of beeing able to insert elements in the middle.

Why not, but it depends on which callsites waiting to be converted
you have in mind.

Thanks.

