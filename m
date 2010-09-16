Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab0IPGPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:15:21 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40889 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab0IPGPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:15:19 -0400
Date: Wed, 15 Sep 2010 23:15:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Neil Brown <neilb@suse.de>, Jens Axboe <jaxboe@fusionio.com>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
Message-ID: <20100916061514.GD2463@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1283711539-7123-1-git-send-email-segooon@gmail.com>
 <20100910034603.GA2612@linux.vnet.ibm.com>
 <20100914003351.GA8300@linux.vnet.ibm.com>
 <201009151428.32348.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009151428.32348.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 02:28:32PM +0200, Arnd Bergmann wrote:
> On Tuesday 14 September 2010, Paul E. McKenney wrote:
> >    The current version of the __rcu_access_pointer(),
> > __rcu_dereference_check(), and __rcu_dereference_protected() macros
> > evaluate their "p" argument three times, not counting typeof()s.  This is
> > bad news if that argument contains a side effect.  This commit therefore
> > evaluates this argument only once in normal kernel builds.  However, the
> > straightforward approach defeats sparse's RCU-pointer checking, so this
> > commit also adds a KBUILD_CHECKSRC symbol defined when running a checker. 
> > Therefore, when this new KBUILD_CHECKSRC symbol is defined, the additional
> > pair of evaluations of the "p" argument are performed in order to permit
> > sparse to detect misuse of RCU-protected pointers.
> 
> In general, I don't like the idea much because that means we're passing
> semantically different code into sparse and gcc. Of course if my other
> patch doesn't work, we might need to do it after all.

Agreed in principle, but please see below.

> > diff --git a/Makefile b/Makefile
> > index f3bdff8..1c4984d 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -330,7 +330,7 @@ PERL                = perl
> >  CHECK          = sparse
> >  
> >  CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
> > -                 -Wbitwise -Wno-return-void $(CF)
> > +                 -Wbitwise -Wno-return-void -DKBUILD_CHECKSRC $(CF)
> >  CFLAGS_MODULE   =
> >  AFLAGS_MODULE   =
> >  LDFLAGS_MODULE  =
> 
> sparse already define __CHECKER__ itself, no need to define another symbol.

Good point, will fix if we are in fact sticking with this solution.

> > +#ifdef KBUILD_CHECKSRC
> > +#define rcu_dereference_sparse(p, space) \
> > +       ((void)(((typeof(*p) space *)p) == p))
> > +#else /* #ifdef KBUILD_CHECKSRC */
> > +#define rcu_dereference_sparse(p, space)
> > +#endif /* #else #ifdef KBUILD_CHECKSRC */
> 
> Did you see a problem with my macro?
> 
> #define rcu_dereference_sparse(p, space) \
>        ((void)(((typeof(*p) space *)NULL) == ((typeof(p))NULL)))

I don't see a specific problem with it.  However, I am not sure that
it really does what we want, and you indicated some doubts when you
posted it.  So I opted for something that very obviously will work.
If you can assure me that sparse will interpret the typeof()s and
space casts properly, I have no problem going with your version.

> I think this should warn in all the cases we want it to, but have no side-effects.

I still note a tone of uncertainty in the above sentence.  ;-)

> >  #define __rcu_access_pointer(p, space) \
> >         ({ \
> >                 typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
> > -               (void) (((typeof (*p) space *)p) == p); \
> > +               rcu_dereference_sparse(p, space); \
> >                 ((typeof(*p) __force __kernel *)(_________p1)); \
> >         })
> >  #define __rcu_dereference_check(p, c, space) \
> >         ({ \
> >                 typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
> >                 rcu_lockdep_assert(c); \
> > -               (void) (((typeof (*p) space *)p) == p); \
> > +               rcu_dereference_sparse(p, space); \
> >                 smp_read_barrier_depends(); \
> >                 ((typeof(*p) __force __kernel *)(_________p1)); \
> >         })
> >  #define __rcu_dereference_protected(p, c, space) \
> >         ({ \
> >                 rcu_lockdep_assert(c); \
> > -               (void) (((typeof (*p) space *)p) == p); \
> > +               rcu_dereference_sparse(p, space); \
> >                 ((typeof(*p) __force __kernel *)(p)); \
> >         })
> >  
> 
> This part might be useful in any case, to better document what the cast and
> compare does, and to prevent the three users from diverging.

And it would probably make sense to pull the rcu_dereference_sparse()
into the macro, for that matter.

> >diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> >index 439ddab..adb09cb 100644
> >--- a/kernel/rcutorture.c
> >+++ b/kernel/rcutorture.c
> 
> This didn't seem to belong here.

Yep, I really should put this in a separate commit.

							Thanx, Paul
