Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab0HTOil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 10:38:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:47834 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab0HTOig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 10:38:36 -0400
Subject: Re: [RFC][PATCH 0/6] mm, highmem: kmap_atomic rework
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Russell King <rmk@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>, David Miller <davem@davemloft.net>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org
In-Reply-To: <20100819143129.81274c03.akpm@linux-foundation.org>
References: <20100819201317.673172547@chello.nl>
	 <20100819143129.81274c03.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 20 Aug 2010 16:38:12 +0200
Message-ID: <1282315092.2605.1134.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 14:31 -0700, Andrew Morton wrote:
> On Thu, 19 Aug 2010 22:13:17 +0200
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > 
> > This patch-set reworks the kmap_atomic API to be a stack based, instead of
> > static slot based. Some might remember this from last year, some not ;-)
> > 
> > The advantage is that you no longer need to worry about KM_foo, the
> > disadvantage is that kmap_atomic/kunmap_atomic now needs to be strictly
> > nested (CONFIG_HIGHMEM_DEBUG should complain in case its not) -- and of
> > course its a big massive patch changing a widely used API.
> 
> Nice.  That fixes the "use of irq-only slots from interrupts-on
> context" bugs which people keep adding.

Ah, I should add a:

  WARN_ON_ONCE(in_irq() && !irqs_disabled());

like check to ensure people don't use kmap_atomic() in nestable IRQ
contexts (nestable IRQ context is bad anyway) the old debug code I
deleted did something similar.

> We don't have any checks in there for the stack overflowing?

+#ifdef CONFIG_DEBUG_HIGHMEM
+       BUG_ON(idx > KM_TYPE_NR);
+#endif

Seems to be that.

> Did you add every runtime check you could possibly think of? 
> kmap_atomic_idx_push() and pop() don't have much in there.  It'd be
> good to lard it up with runtime checks for at least a few weeks.

Right, so I currently have:

 - stack size check in push/pop
 - proper nesting check in pop (verifies that the vaddr you try to
   unmap is indeed the top most on the stack)

Aside from the proposed no irq-nesting thing to avoid unbounded
recursion I can't really come up with more creative abuse.

> Well, there's that monster conversion patch.  How's about you
> temporarily do
> 
> #define kmap_atomic(x, arg...)  __kmap_atomic(x)
> 
> so for a while, both kmap_atomic(a, KM_foo) and kmap_atomic(a) are
> turned into __kmap_atomic(a).  Once all the dust has settled, pull that
> out again?

Ah, that's a nifty trick, let me try that. 
