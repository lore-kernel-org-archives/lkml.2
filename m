Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab0IPLz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 07:55:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461Ab0IPLzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 07:55:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <E1Ovt6F-0005CS-RU@pomaz-ex.szeredi.hu>
References: <E1Ovt6F-0005CS-RU@pomaz-ex.szeredi.hu>
To: Miklos Szeredi <miklos@szeredi.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: memory barrier question
Date: Thu, 16 Sep 2010 12:55:36 +0100
Message-ID: <3777.1284638136@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Consider the following example:
> 
> Start:
> 	p = NULL;
> 	x = 0;
> 
> CPU1:
> 	atomic_inc(&x);
> 	p = &x;
> 
> CPU2:
> 	if (p)
> 		z = atomic_read(p);
> 
> Is it possible to end up with z == 0?

I think so.  I'm not sure that you can assume that CPU1 does its two
'operations' in the same order.  You can guarantee that the read of x,
increment, and write of x will be done in an order, and that no one else will
see an intermediate state, but you can't guarantee that CPU2 will see x
changed before p is changed.

In Documentation/memory-barriers.txt, it says:

	The following also do _not_ imply memory barriers, and so may require
	explicit memory barriers under some circumstances
	(smp_mb__before_atomic_dec() for instance):

		atomic_add();
		atomic_sub();
		atomic_inc();
		atomic_dec();

so you need _two_ memory barriers, e.g.:

	CPU1:
		atomic_inc(&x);
		smp_mb__after_atomic_inc()
		p = &x;

	CPU2:
		q = p;
		smp_rmb();
		if (q)
			z = atomic_read(q);

Note that atomic_inc() may imply a suitable memory barrier on some arches, and
so has special variant barrier functions of its own.

> What if there's a lock/unlock before setting "p"?

If there's a lock+unlock between, then this counts as a full memory barrier:

	CPU1:
		atomic_inc(&x);
		spin_lock(&foo);
		spin_unlock(&foo);
		p = &x;

but you still need the matching smp_rmb() on CPU2.

> What if there's a write barrier before setting "p"?

That's fine, but you still need the matching smp_rmb() on CPU2.

David
