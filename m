Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab0KESks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 14:40:48 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42228 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab0KESkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 14:40:45 -0400
Date: Fri, 5 Nov 2010 11:40:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH] atomic: add atomic_inc_not_zero_hint()
Message-ID: <20101105184034.GG2850@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1288975980.2882.877.camel@edumazet-laptop>
 <20101105102038.53e36f9e.akpm@linux-foundation.org>
 <1288980046.2882.1054.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1288980046.2882.1054.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 07:00:46PM +0100, Eric Dumazet wrote:
> Le vendredi 05 novembre 2010 à 10:20 -0700, Andrew Morton a écrit :
> 
> > It totally makes sense to add include/linu/atomic.h for common things. 
> > Perhaps there's already code in arch/*/include/asm/atomic.h which
> > should be hoisted up there.  But that can't reliably be done until a
> > million files have had their #includes switched :(
> > 
> 
> Maybe including <linux/atomic.h> only from the end of various
> 
> arch/*/include/asm/atomic.h  ?
> 
> In this case, I remove the include <asm/atomic.h> from linux/atomic.h
> 
> > It's quite unobvious *why* `hint' cannot be zero.  Can you please add
> > the reasoning to the comment?  Also, the local `hint' should be
> > referred to as "@hint" in a kerneldoc comment.
> 
> Well ;)
> 
> We want to increment the counter if its not zero.
> Typically used for refcounts, of RCU protected structures.
> 
> Giving a zero hint would be curious dont you think ?
> 
> I see no usage for this, and using atomic_inc_not_zero() in this case is
> the only choice, since we dont ever want to cmpxchg(v, 0, 1) (or risk
> double free and crazy things)
> 
> Hmm... maybe I can add a test (compiler should optimize it anyway, since
> all usages I can foresee will use a constant hint)
> 
> > 
> > > +static inline int atomic_inc_not_zero_hint(atomic_t *v, int hint)
> > > +{
> > > +	int val, c = hint;
> > > +
> > > + 	do {
> > > +		val = atomic_cmpxchg(v, c, c + 1);
> > > +		if (val == c)
> > > +			return 1;
> > > +		c = val;
> > > +	} while (c);
> > > +
> > > +	return 0;
> > > +}
> > 
> > Should/could this have implemented a more general
> > atomic_add_not_zero_hint() and made atomic_inc_not_zero_hint() a
> > wrapper around that?
> 
> Well, I see no practical use for this, but yes, this could be done.
> 
> As atomic_add_not_zero() doesnt exist, I am not sure we need an
> atomic_add_not_zero_hint() yet ?
> 
> > 
> > Also, it might make sense to add "#ifndef atomic_inc_not_zero_hint"
> > wrappers around this function so that the arch can implement an
> > overriding custom version.  And that becomes a general rule as more
> > functions are added to include/linux/atomic.h.
> 
> Ah yes, thats right !
> 
> Thanks !
> 
> [PATCH v2] atomic: add atomic_inc_not_zero_hint()
> 
> Followup of perf tools session in Netfilter WorkShop 2010
> 
> In network stack we make high usage of atomic_inc_not_zero() in contexts
> we know the probable value of atomic before increment (2 for udp sockets
> for example)
> 
> Using a special version of atomic_inc_not_zero() giving this hint can
> help processor to use less bus transactions.
> 
> On x86 (MESI protocol) for example, this avoids entering Shared state,
> because "lock cmpxchg" issues an RFO (Read For Ownership)
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
> Cc: David Miller <davem@davemloft.net>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: Nick Piggin <npiggin@kernel.dk>
> ---
> V2: add #ifndef atomic_inc_not_zero_hint
>     kerneldoc changes
>     test that hint is not null
>     Meant to be included at end of arch/*/asm/atomic.h files
> 
>  include/linux/atomic.h |   36 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 36 insertions(+)
> 
> diff --git a/include/linux/atomic.h b/include/linux/atomic.h
> new file mode 100644
> index 0000000..0897bdd
> --- /dev/null
> +++ b/include/linux/atomic.h
> @@ -0,0 +1,36 @@
> +#ifndef _LINUX_ATOMIC_H
> +#define _LINUX_ATOMIC_H
> +
> +/**
> + * atomic_inc_not_zero_hint - increment if not null
> + * @v: pointer of type atomic_t
> + * @hint: probable value of the atomic before the increment
> + *
> + * This version of atomic_inc_not_zero() gives a hint of probable
> + * value of the atomic. This helps processor to not read memory
> + * before doing the atomic read/modify/write cycle, lowering
> + * number of bus transactions on some arches.
> + * Note: @hint MUST not be 0, or increment is not done.
> + * Returns: 0 if increment was not done, 1 otherwise.
> + */
> +#ifndef atomic_inc_not_zero_hint
> +static inline int atomic_inc_not_zero_hint(atomic_t *v, int hint)
> +{
> +	int val, c = hint;
> +
> +	/* sanity test, should be removed by compiler if hint is a constant */
> +	if (!hint)
> +		return 0;

OK, so I cannot resist the challenge...  ;-)

Suppose that the atomic_inc_not_zero_hint() is in common code that might
be invoked from a cleanup path.  On the cleanup path, perhaps within an
RCU callback, if the reference is zero, we have the only reference and
thus don't need to increment the reference count.  On the other hand,
if the reference is non-zero, we want to obtain a reference in order
to safely attempt to encourage the other reference holder to let go
more quickly.

Perhaps a bit of a stretch, but why not just replace the above
"return 0" with "atomic_inc_not_zero(v)"?  It will usually be
compiled out, right?

							Thanx, Paul

> + 	do {
> +		val = atomic_cmpxchg(v, c, c + 1);
> +		if (val == c)
> +			return 1;
> +		c = val;
> +	} while (c);
> +
> +	return 0;
> +}
> +#endif
> +
> +#endif /* _LINUX_ATOMIC_H */
> 
> 
