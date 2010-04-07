Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab0DGQAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 12:00:45 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:59178 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab0DGQAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 12:00:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eKjMGPXF50s4+2XD8K1l3X7ruMBa5dvbjn8IvTOBk3dTDlCYxkSa0vrwZBkvumqI96
         I0WXEiTPJP8vTISUTV0LEv2B1weMPgLD9EpqlAejz37ZlxQMhDJ+ZdFMPPPGAhwULOb4
         mniFNNHOlYgj/DEJy3OC1J4qKMiZAmC80N4XM=
Subject: Re: [PATCH 1/2] rcu: add rcu_access_pointer and
 rcu_dereference_protect
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: paulmck@linux.vnet.ibm.com, Trond.Myklebust@netapp.com,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <25990.1270654809@redhat.com>
References: <1270652210.8141.9.camel@edumazet-laptop>
	 <20100407135732.12414.16416.stgit@warthog.procyon.org.uk>
	 <25990.1270654809@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 18:00:35 +0200
Message-ID: <1270656035.8141.23.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 07 avril 2010 à 16:40 +0100, David Howells a écrit :
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> > This is not the version Paul posted. 
> > 
> > Removing checks just to shutup warnings ?
> 
> No.  I don't see the point in the condition.
> 
> > All the point is to get lockdep assistance, and you throw it away.
> > 
> > We want to explicit the condition, so that RCU users can explicitly
> > state what protects their data.
> 
> You've missed the point.
> 

You already claimed I dont understand RCU. I find this claim funny.


> For rcu_access_pointer(), _nothing_ protects the data, not only that, we don't
> care: we're only checking the pointer.

How can you state this ?

Thats pretty simple, "always true" is a fine condition.

What's the problem with this ?

> 
> For rcu_dereference_protect[ed](), I don't see that the check helps.  You
> don't need to be holding the RCU lock to call it, but you do need to hold all
> the requisite locks required to exclude others modifying it.  That's a
> precondition for calling this function, so is there any point in testing it
> again?
> 

If you dont see how the check can help, why dont you unset
CONFIG_PROVE_RCU ?


> For instance, consider the following pseudocode:
> 
> 	do_something(struct foo *p)
> 	{
> 		struct bar *b;
> 		spin_lock(&foo->lock);
> 		b = rcu_dereference_protected(
> 			foo->bar, lockdep_is_held(&foo->lock));
> 		do_something_to_bar(b);
> 		spin_unlock(&foo->lock);
> 	}
> 
> is there any need for the condition? 

Yes, this is what is needed to help to catch when a condition is not
met.

Of course, on trivial code like this one, its pretty obvious condition
will be always true.

In many cases, smp_processor_id() checks are obvious too, yet we perform
them. It can help us sometimes, because many developers forget the
obvious things.

>  Does lockdep_is_held() have any side
> effects beyond those listed in the Documentation directory or on its attached
> banner comments?
> 
> 
> Furthermore, I think the condition in rcu_dereference_check() may well be
> misused.  For instance, Paul suggested:
> 
> 	cred = rcu_dereference_check(delegation->cred,
> 				     delegation->inode == NULL);
> 
> but if 'c' is supposed to be the locks that protect the data, is this a valid
> check?

'c' is not a lock. Its a condition.

You as the author of this code, decide of the condition to check.

You therefore can answer yourself to this question.

Example of non trivial check :

static void __sk_free(struct sock *sk)
{
...
filter = rcu_dereference_check(sk->sk_filter,
			       atomic_read(&sk->sk_wmem_alloc) == 0);
...
}

In this check, there is no lock held.


commit a898def29e4119bc01ebe7ca97423181f4c0ea2d
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Mon Feb 22 17:04:49 2010 -0800

    net: Add checking to rcu_dereference() primitives
    
    Update rcu_dereference() primitives to use new lockdep-based
    checking. The rcu_dereference() in __in6_dev_get() may be
    protected either by rcu_read_lock() or RTNL, per Eric Dumazet.
    The rcu_dereference() in __sk_free() is protected by the fact
    that it is never reached if an update could change it.  Check
    for this by using rcu_dereference_check() to verify that the
    struct sock's ->sk_wmem_alloc counter is zero.
    
    Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
    Acked-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    Cc: laijs@cn.fujitsu.com
    Cc: dipankar@in.ibm.com
    Cc: mathieu.desnoyers@polymtl.ca
    Cc: josh@joshtriplett.org
    Cc: dvhltc@us.ibm.com
    Cc: niv@us.ibm.com
    Cc: peterz@infradead.org
    Cc: rostedt@goodmis.org
    Cc: Valdis.Kletnieks@vt.edu
    Cc: dhowells@redhat.com
    LKML-Reference:
<1266887105-1528-5-git-send-email-paulmck@linux.vnet.ibm.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

...
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1073,7 +1073,8 @@ static void __sk_free(struct sock *sk)
        if (sk->sk_destruct)
                sk->sk_destruct(sk);
 
-       filter = rcu_dereference(sk->sk_filter);
+       filter = rcu_dereference_check(sk->sk_filter,
+                                      atomic_read(&sk->sk_wmem_alloc) == 0);
        if (filter) {
                sk_filter_uncharge(sk, filter);
                rcu_assign_pointer(sk->sk_filter, NULL);



