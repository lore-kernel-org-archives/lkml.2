Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab0DGQfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 12:35:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932753Ab0DGQfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 12:35:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100407155729.GA2481@linux.vnet.ibm.com>
References: <20100407155729.GA2481@linux.vnet.ibm.com> <2440.1269967151@redhat.com> <21972.1269993064@redhat.com> <10818.1270044273@redhat.com> <15371.1270057054@redhat.com> <19556.1270076008@redhat.com> <14003.1270122314@redhat.com> <4161.1270133211@redhat.com> <23331.1270570443@redhat.com> <26510.1270582446@redhat.com> <24225.1270646561@redhat.com> 
To: paulmck@linux.vnet.ibm.com
Cc: dhowells@redhat.com, Eric Dumazet <eric.dumazet@gmail.com>,
       Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: RCU condition checks
Date: Wed, 07 Apr 2010 17:35:30 +0100
Message-ID: <26884.1270658130@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> > Why is there a need for 'c'?
> 
> An example use is where rcu_access_pointer() is legal because we are
> either initializing or cleaning up, so that no other CPU has access
> to the pointer.  In these cases, you might do something like:
> 
> 	q = rcu_access_pointer(p->a, p->refcnt == 0);

I think the main problem I have with this is that the fact that p->refcnt
should be 0 here is unrelated to the fact that we're wanting to look at the
value of p->a.  I'd say that this should be two separate statements, for
example:

	ASSERT(p->refcnt == 0);
	q = rcu_access_pointer(p->a);

I could see using a lockdep-managed ASSERT here would work, though.

The other problem I have with this is that I'm assuming rcu_access_pointer()
is simply for looking at the value of the pointer without dereferencing it -
in which case, is there any need for the lock-describing condition?


I agree, though, that:

	q = rcu_dereference_check(p->a,
				  rcu_read_lock_held() || (
				   lockdep_is_held(p->lock) &&
				   lockdep_is_held(q->lock)));

is a reasonable way of keeping the dereference and the lock checks together,
though that could equally well be written, say:

	LOCKDEP_ASSERT(rcu_read_lock_held() || (
		        lockdep_is_held(p->lock) &&
			lockdep_is_held(q->lock)));
	q = rcu_dereference_protected(p->a);

but combining those makes it easier to ensure people to write lock checking.

Davod
