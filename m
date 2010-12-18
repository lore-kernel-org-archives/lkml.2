Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab0LRUOa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 15:14:30 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46831 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932126Ab0LRUO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 15:14:29 -0500
Date: Sat, 18 Dec 2010 12:14:19 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com
Subject: Re: [PATCH RFC tip/core/rcu 13/20] rcu: increase
 synchronize_sched_expedited() batching
Message-ID: <20101218201419.GD2143@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101217205433.GA10199@linux.vnet.ibm.com>
 <1292619291-2468-13-git-send-email-paulmck@linux.vnet.ibm.com>
 <4D0CDD93.7040907@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0CDD93.7040907@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 05:13:07PM +0100, Tejun Heo wrote:
> Hello,
> 
> On 12/17/2010 09:54 PM, Paul E. McKenney wrote:
> > From: Tejun Heo <tj@kernel.org>
> > 
> > The fix in commit #6a0cc49 requires more than three concurrent instances
> > of synchronize_sched_expedited() before batching is possible.  This
> > patch uses a ticket-counter-like approach that is also not unrelated to
> > Lai Jiangshan's Ring RCU to allow sharing of expedited grace periods even
> > when there are only two concurrent instances of synchronize_sched_expedited().
> > 
> > This commit builds on Tejun's original posting, which may be found at
> > http://lkml.org/lkml/2010/11/9/204, adding memory barriers, avoiding
> > overflow of signed integers (other than via atomic_t), and fixing the
> > detection of batching.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Acked-by: Tejun Heo <tj@kernel.org>

Thank you again!

> Some comments on the sequence testing tho.
> 
> > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > index 49e8e16..af56148 100644
> > --- a/include/linux/rcupdate.h
> > +++ b/include/linux/rcupdate.h
> > @@ -47,6 +47,8 @@
> >  extern int rcutorture_runnable; /* for sysctl */
> >  #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
> >  
> > +#define UINT_CMP_GE(a, b)	(UINT_MAX / 2 >= (a) - (b))
> > +#define UINT_CMP_LT(a, b)	(UINT_MAX / 2 < (a) - (b))
> >  #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
> >  #define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
> 
> I don't think the original comparison had overflow problem.  (a) < (b)
> gives the wrong result on overflow but (int)((a) - (b)) < 0 is
> correct.

You are right that it does give the correct result now, but the C
standard never has defined overflow for signed integers, as noted in
Section 6.3.1.3p3 of the N1494 Working Draft of the C standard:

	Otherwise, the new type is signed and the value cannot be
	represented in it; either the result is implementation-defined
	or an implementation-defined signal is raised.

I have heard too many compiler guys gleefully discussing optimizations
that they could use if they took full advantage of this clause, so I
am not comfortable relying on the intuitive semantics for signed
arithmetic.  (Now atomic_t is another story -- both C and C++ will
be requiring twos-complement semantics, thankfully.)

> I find the latter approach cleaner and that way the constant in the
> instruction can be avoided too although if the compiler might generate
> the same code regardless.

I would like your way better if it was defined in the C standard.
But it unfortunately is not.  :-(

> Also, I think the names are misleading.  They aren't testing whether
> one is greater or less than the other.  They're testing whether one is
> before or after the other where the counters are used as monotonically
> incrementing (with wrapping) sequence, so wouldn't something like the
> following be better?

They are comparing the twos-complement difference between the two
numbers against zero.

> #define SEQ_TEST(a, b, test_op)	({					\
> 	typeof(a) __seq_a = (a);					\
> 	typeof(b) __seq_b = (b);					\
> 	bool __ret;							\
> 	(void)(&__seq_a == &__seq_b);					\
> 	switch (sizeof(__seq_a)) {					\
> 		case sizeof(char):					\
> 			__ret = (char)(__seq_a - __seq_b) test_op 0;	\
> 			break;						\
> 		case sizeof(int):					\
> 			__ret = (int)(__seq_a - __seq_b) test_op 0;	\
> 			break;						\
> 		case sizeof(long):					\
> 			__ret = (long)(__seq_a - __seq_b) test_op 0;	\
> 			break;						\
> 		case sizeof(long long):					\
> 			__ret = (long long)(__seq_a - __seq_b) test_op 0; \
> 			break;						\
> 		default:						\
> 			__make_build_fail;				\
> 	}								\
> 	__ret;								\
> })
> 
> #define SEQ_BEFORE(a, b)	SEQ_TEST((a), (b), <)
>  and so on...
> 
> Please note that the above macro is completely untested.

If you make something similar to these macros, but in a way that avoids
overflowing signed integers, I would be happy to use it.  Might be a
good addition to compiler.h, for example.

							Thanx, Paul

> Thanks.
> 
> -- 
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
