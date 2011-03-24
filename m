Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab1CXOwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 10:52:44 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35954 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab1CXOwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 10:52:43 -0400
Date: Thu, 24 Mar 2011 15:52:21 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nikanth Karthikesan <knikanth@suse.de>, Ingo Molnar <mingo@redhat.com>,
        Nick Piggin <npiggin@kernel.dk>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Beulich <JBeulich@novell.com>, Jack Steiner <steiner@sgi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in
 test_and_set_bit_lock if possible
Message-ID: <20110324145221.GC31194@aftab>
References: <201103241026.01624.knikanth@suse.de>
 <20110324085647.GI30812@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324085647.GI30812@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 04:56:47AM -0400, Ingo Molnar wrote:
> 
> * Nikanth Karthikesan <knikanth@suse.de> wrote:
> 
> > On x86_64 SMP with lots of CPU atomic instructions which assert the LOCK #
> > signal can stall other CPUs. And as the number of cores increase this penalty
> > scales proportionately. So it is best to try and avoid atomic instructions
> > wherever possible. test_and_set_bit_lock() can avoid using LOCK_PREFIX if it
> > finds the bit set already.
> > 
> > Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

[..]

> > + * test_and_set_bit_lock - Set a bit and return its old value for lock
> > + * @nr: Bit to set
> > + * @addr: Address to count from
> > + *
> > + * This is the same as test_and_set_bit on x86. But atomic operation is
> > + * avoided, if the bit was already set.
> > + */
> > +static __always_inline int
> > +test_and_set_bit_lock(int nr, volatile unsigned long *addr)
> > +{
> > +#ifdef CONFIG_SMP
> > +	barrier();
> > +	if (test_bit(nr, addr))
> > +		return 1;
> > +#endif
> > +	return test_and_set_bit(nr, addr);
> > +}
>
> On modern x86 CPUs there's no "#LOCK signal" anymore - it's replaced
> by a M[O]ESI cache coherency bus. I'd expect modern x86 CPUs to be
> pretty fast when the cacheline is local and the bit is set already.

Correct. However, LOCK still could have some overhead associated with it
and avoiding it by using only an non-atomic op (test_bit()) could bring
some miniscule speedup...

> So you really need to back up your patch with actual hard numbers.
> Putting this code into user-space and using pthreads to loop on
> the same global variable and testing the before/after effect would
> be sufficient i think. You can use 'perf stat --repeat 10' kind of
> measurements to see whether there's any improvement larger than the
> noise of the measurement.

and Ingo's question is right on the money - is this speedup noticeable
or does it simply disappear in the noise?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
