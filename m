Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab2HPK5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 06:57:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45149 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755929Ab2HPK5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 06:57:17 -0400
Date: Thu, 16 Aug 2012 11:57:09 +0100
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: Re: [PATCH v2 26/31] arm64: Miscellaneous library functions
Message-ID: <20120816105709.GK31784@mudshark.cambridge.arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-27-git-send-email-catalin.marinas@arm.com>
 <201208151521.14663.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208151521.14663.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 04:21:14PM +0100, Arnd Bergmann wrote:
> On Tuesday 14 August 2012, Catalin Marinas wrote:
> 
> > +
> > +/*
> > + * Use compiler builtins for simple inline operations.
> > + */
> > +static inline unsigned long __ffs(unsigned long word)
> > +{
> > +	return __builtin_ffsl(word) - 1;
> > +}
> > +
> > +static inline int ffs(int x)
> > +{
> > +	return __builtin_ffs(x);
> > +}
> > +
> > +static inline unsigned long __fls(unsigned long word)
> > +{
> > +	return BITS_PER_LONG - 1 - __builtin_clzl(word);
> > +}
> > +
> > +static inline int fls(int x)
> > +{
> > +	return x ? sizeof(x) * BITS_PER_BYTE - __builtin_clz(x) : 0;
> > +}
> 
> These are all great, but I think whether to use them or not should
> depend on the compiler version rather than the architecture in
> general. Do we know a minimum gcc version that supports all of the
> above? Then we could put that code into the generic files.

I imagine that the version of GCC that supports these builtins varies for
each architecture. For aarch64, the compile will always support these
builtins and these particular ones are guaranteed to be inlined.

> If that's not possible, we could still make the implementation
> available for other architectures by moving it to
> 
> asm-generic/bitops/builtin-__ffs.h
> asm-generic/bitops/builtin-ffs.h
> asm-generic/bitops/builtin-__fls.h
> asm-generic/bitops/builtin-fls.h

Yeah, that might be an idea. The architecture can then decide to use them if
it knows they are available and usable.

> > --- /dev/null
> > +++ b/arch/arm64/lib/bitops.c
> > @@ -0,0 +1,25 @@
> > +/*
> > + * Copyright (C) 2012 ARM Limited
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/spinlock.h>
> > +#include <linux/atomic.h>
> > +
> > +#ifdef CONFIG_SMP
> > +arch_spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] __lock_aligned = {
> > +       [0 ... (ATOMIC_HASH_SIZE-1)]  = __ARCH_SPIN_LOCK_UNLOCKED
> > +};
> > +#endif
> 
> What?
> 
> I suppose this is a leftover from an earlier version using the
> generic bitops, right?

We currently use the generic atomic bitops (asm-generic/bitops/atomic.h)
which contains:

#  define ATOMIC_HASH(a) (&(__atomic_hash[ (((unsigned long) a)/L1_CACHE_BYTES) & (ATOMIC_HASH_SIZE-1) ]))

so we have to provide a definition for the array. We have additional patches
containing optimised assembly implementations of the atomic bitops which we
will push later, once we've got some hardware to benchmark with.

Will
