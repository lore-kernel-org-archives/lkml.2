Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab0CSMfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 08:35:30 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:47333 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab0CSMf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 08:35:29 -0400
Date: Fri, 19 Mar 2010 07:34:07 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] tree/tiny rcu: Add debug RCU head option (v2)
In-Reply-To: <4BA2FA01.30102@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1003190730440.9184@router.home>
References: <20100319013024.GA28456@Krystal> <4BA2FA01.30102@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Mar 2010, Lai Jiangshan wrote:

> but SLUB opposed me, so I did not post it.
>
> @ slub.c
> static void free_slab(struct kmem_cache *s, struct page *page)
> {
> 	if (unlikely(s->flags & SLAB_DESTROY_BY_RCU)) {
> 		/*
> 		 * RCU free overloads the RCU head over the LRU
> 		 */
> 		struct rcu_head *head = (void *)&page->lru;
>
> 		call_rcu(head, rcu_free_slab);
> 	} else
> 		__free_slab(s, page);
> }
>
> I think it is not your patch's fault, but the above code has
> already existed.
>
> In your patch, struct rcu_head::debug will share the same memory of
> the other field of struct page, (especially share the struct page::flags
> which I encountered)

Right. I like the smallness of the RCU structure but if you must
increase its size then we could:

A) put the rcu structure at the end of each page like SLOB
   but that will take away memory that could be used by objects.

B) Move the rcu object up by a word so that it overloads the index field
   in the page struct. That would give another exact fit but will cause
   trouble again if you bloat the structure some more.

