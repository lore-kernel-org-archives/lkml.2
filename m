Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab0DGP7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 11:59:36 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42947 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932581Ab0DGP7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 11:59:35 -0400
Date: Wed, 7 Apr 2010 08:59:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Trond.Myklebust@netapp.com,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] rcu: add rcu_access_pointer and
 rcu_dereference_protect
Message-ID: <20100407155929.GB2481@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100407135732.12414.16416.stgit@warthog.procyon.org.uk>
 <1270652210.8141.9.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1270652210.8141.9.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 04:56:50PM +0200, Eric Dumazet wrote:
> Le mercredi 07 avril 2010 à 14:57 +0100, David Howells a écrit :
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > This patch adds variants of rcu_dereference() that handle situations
> > where the RCU-protected data structure cannot change, perhaps due to
> > our holding the update-side lock, or where the RCU-protected pointer is
> > only to be fetched, not dereferenced.
> > 
> > The new rcu_access_pointer() primitive is for the case where the pointer
> > is be fetch and not dereferenced.  This primitive may be used without
> > protection, RCU or otherwise, due to the fact that it uses ACCESS_ONCE().
> > 
> > The new rcu_dereference_protect() primitive is for the case where updates
> > are prevented, for example, due to holding the update-side lock.  This
> > primitive does neither ACCESS_ONCE() nor smp_read_barrier_depends(), so
> > can only be used when updates are somehow prevented.
> > 
> > Suggested-by: David Howells <dhowells@redhat.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > ---
> > 
> >  include/linux/rcupdate.h |   34 ++++++++++++++++++++++++++++++++++
> >  1 files changed, 34 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > index 872a98e..a1b14b6 100644
> > --- a/include/linux/rcupdate.h
> > +++ b/include/linux/rcupdate.h
> > @@ -209,9 +209,43 @@ static inline int rcu_read_lock_sched_held(void)
> >  		rcu_dereference_raw(p); \
> >  	})
> >  
> > +/**
> > + * rcu_access_pointer - fetch RCU pointer with no dereferencing
> > + *
> > + * Return the value of the specified RCU-protected pointer, but omit the
> > + * smp_read_barrier_depends() and keep the ACCESS_ONCE().  This is useful
> > + * when the value of this pointer is accessed, but the pointer is not
> > + * dereferenced, for example, when testing an RCU-protected pointer against
> > + * NULL.  This may also be used in cases where update-side locks prevent
> > + * the value of the pointer from changing, but rcu_dereference_protect()
> > + * is a lighter-weight primitive for this use case.
> > + */
> > +#define rcu_access_pointer(p) \
> > +	({ \
> > +		ACCESS_ONCE(p); \
> > +	})
> > +
> > +/**
> > + * rcu_dereference_protected - fetch RCU pointer when updates prevented
> > + *
> > + * Return the value of the specified RCU-protected pointer, but omit
> > + * both the smp_read_barrier_depends() and the ACCESS_ONCE().  This
> > + * is useful in cases where update-side locks prevent the value of the
> > + * pointer from changing.  Please note that this primitive does -not-
> > + * prevent the compiler from repeating this reference or combining it
> > + * with other references, so it should not be used without protection
> > + * of appropriate locks.
> > + */
> > +#define rcu_dereference_protected(p) \
> > +	({ \
> > +		(p); \
> > +	})
> > +
> >  #else /* #ifdef CONFIG_PROVE_RCU */
> >  
> >  #define rcu_dereference_check(p, c)	rcu_dereference_raw(p)
> > +#define rcu_access_pointer(p)		ACCESS_ONCE(p)
> > +#define rcu_dereference_protect(p)	(p)
> >  
> >  #endif /* #else #ifdef CONFIG_PROVE_RCU */
> >  
> > 
> > --
> 
> This is not the version Paul posted. 

I blew the name -- rcu_dereference_protected() is in fact a better name.

> Removing checks just to shutup warnings ?
> 
> All the point is to get lockdep assistance, and you throw it away.
> 
> We want to explicit the condition, so that RCU users can explicitly
> state what protects their data.

What Eric said!!!  ;-)

							Thanx, Paul
