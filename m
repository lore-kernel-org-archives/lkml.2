Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab2HPNAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:00:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52947 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab2HPNAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:00:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 26/31] arm64: Miscellaneous library functions
Date: Thu, 16 Aug 2012 13:00:32 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <201208151521.14663.arnd@arndb.de> <20120816105709.GK31784@mudshark.cambridge.arm.com>
In-Reply-To: <20120816105709.GK31784@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208161300.32830.arnd@arndb.de>
X-Provags-ID: V02:K0:RhwUSoSH6n1x6qaIYo/MGjb9Ae6IcjthNOIkOOa02+Q
 MJX937b34+KEmvHMaiDdsgD7+rr9hLgYV+1zkA4nFjKHoU2KjV
 MGtQFzb5SMyNUVv7rztf5+NsQNy8QUaO6aj+f9xJrY3NiSqSKY
 G1X9pt1Q7R9XWLAyd5/u/uGQZ/1uo+dqDmRw6lERtRfDslx4pG
 UzS9lgqMbNBhsJmMeSc/O0lykoylJQY9rCJZ+imiknEpK4+iec
 1TZkRndecGf4uzV01b+vGSAgnWfvKZhF2I+blAbudGUpgZImdj
 LagTBZ829PaKzCQ1/qRKy4NYQQDFyh2E91FT9iPK4HcurlESYM
 wt/tjnjb6uGBTNJzFOLM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 August 2012, Will Deacon wrote:
> > > +
> > > +#include <linux/kernel.h>
> > > +#include <linux/spinlock.h>
> > > +#include <linux/atomic.h>
> > > +
> > > +#ifdef CONFIG_SMP
> > > +arch_spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] __lock_aligned = {
> > > +       [0 ... (ATOMIC_HASH_SIZE-1)]  = __ARCH_SPIN_LOCK_UNLOCKED
> > > +};
> > > +#endif
> > 
> > What?
> > 
> > I suppose this is a leftover from an earlier version using the
> > generic bitops, right?
> 
> We currently use the generic atomic bitops (asm-generic/bitops/atomic.h)
> which contains:
> 
> #  define ATOMIC_HASH(a) (&(__atomic_hash[ (((unsigned long) a)/L1_CACHE_BYTES) & (ATOMIC_HASH_SIZE-1) ]))
> 
> so we have to provide a definition for the array. We have additional patches
> containing optimised assembly implementations of the atomic bitops which we
> will push later, once we've got some hardware to benchmark with.
> 

Ah, I was confusing this with the asm/atomic.h stuff, for which you already
provide an optimized version.

The generic atomic bitops are really horrible in performance and I would
expect that there is just one obvious way to implement bitops using ldaxr/stlxr,
so I recommend just doing that even if you have no hardware for benchmarking.

The s390 version should be fairly easy to adapt.

	Arnd
