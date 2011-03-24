Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915Ab1CXRTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:19:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57749 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab1CXRTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:19:53 -0400
Date: Thu, 24 Mar 2011 18:19:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: Borislav Petkov <bp@amd64.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Jack Steiner <steiner@sgi.com>,
        tee@sgi.com, Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in test_and_set_bit_lock
 if possible
Message-ID: <20110324171924.GC2414@elte.hu>
References: <201103241026.01624.knikanth@suse.de>
 <20110324085647.GI30812@elte.hu>
 <20110324145221.GC31194@aftab>
 <4D8B83DA02000078000381DE@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8B83DA02000078000381DE@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_00,URIBL_RHS_DOB autolearn=no SpamAssassin version=3.3.1
	1.5 URIBL_RHS_DOB          Contains an URI of a new domain (Day Old Bread)
	[URIs: novell.com]
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> >>> On 24.03.11 at 15:52, Borislav Petkov <bp@amd64.org> wrote:
> 
> (haven't seen Ingo's original reply, so responding here)
> 
> > On Thu, Mar 24, 2011 at 04:56:47AM -0400, Ingo Molnar wrote:
> >> 
> >> * Nikanth Karthikesan <knikanth@suse.de> wrote:
> >> 
> >> > On x86_64 SMP with lots of CPU atomic instructions which assert the LOCK #
> >> > signal can stall other CPUs. And as the number of cores increase this 
> > penalty
> >> > scales proportionately. So it is best to try and avoid atomic instructions
> >> > wherever possible. test_and_set_bit_lock() can avoid using LOCK_PREFIX if 
> > it
> >> > finds the bit set already.
> >> > 
> >> > Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> > 
> > [..]
> > 
> >> > + * test_and_set_bit_lock - Set a bit and return its old value for lock
> >> > + * @nr: Bit to set
> >> > + * @addr: Address to count from
> >> > + *
> >> > + * This is the same as test_and_set_bit on x86. But atomic operation is
> >> > + * avoided, if the bit was already set.
> >> > + */
> >> > +static __always_inline int
> >> > +test_and_set_bit_lock(int nr, volatile unsigned long *addr)
> >> > +{
> >> > +#ifdef CONFIG_SMP
> >> > +	barrier();
> >> > +	if (test_bit(nr, addr))
> >> > +		return 1;
> >> > +#endif
> >> > +	return test_and_set_bit(nr, addr);
> >> > +}
> >>
> >> On modern x86 CPUs there's no "#LOCK signal" anymore - it's replaced
> >> by a M[O]ESI cache coherency bus. I'd expect modern x86 CPUs to be
> >> pretty fast when the cacheline is local and the bit is set already.
> 
> Are you certain? Iirc the lock prefix implies minimally a read-for-
> ownership (if CPUs are really smart enough to optimize away the
> write - I wonder whether that would be correct at all when it
> comes to locked operations), which means a cacheline can still be
> bouncing heavily.

Yeah. On what workload was this?

Generally you use test_and_set_bit() if you expect it to be 'owned' by whoever 
calls it, and released by someone else.

It would be really useful to run perf top on an affected box and see which 
kernel function causes this. It might be better to add a test_bit() to the 
affected codepath - instead of bloating all test_and_set_bit() users.

Note that the patch can also cause overhead: the test_bit() can miss the cache, 
it will bring in the cacheline shared, and the subsequent test_and_set() call 
will then dirty the cacheline - so the CPU might miss again and has to wait for 
other CPUs to first flush this cacheline.

So we really need more details here.

Thanks,

	Ingo
