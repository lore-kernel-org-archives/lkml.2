Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab1GOXr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 19:47:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:53640 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab1GOXr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 19:47:58 -0400
Subject: RE: [PATCH 0/1] Fixup write permission of TLB on powerpc e500 core
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Shan Hai <haishan.bai@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        tony.luck@intel.com, linux-kernel@vger.kernel.org, cmetcalf@tilera.com,
        dhowells@redhat.com, paulus@samba.org, tglx@linutronix.de,
        walken@google.com, linuxppc-dev@lists.ozlabs.org,
        akpm@linux-foundation.org
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8ADFC@saturn3.aculab.com>
References: <AE90C24D6B3A694183C094C60CF0A2F6D8ADFC@saturn3.aculab.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Jul 2011 09:47:09 +1000
Message-ID: <1310773629.25044.2.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 11:32 +0100, David Laight wrote:
> > The fault causing futex_atomic_cmpxchg_inatomic() is
> > protected by pagefault_disable(), so the page fault handler has
> > no chance to toggle the SW dirty/young tracking.
> 
> Perhaps that is the bug!
> Whatever pagefault_disable() does, it shouldn't disable the
> SW dirty/young tracking - which should only needs bits moving
> in the page table itself (and TLB update??) rather than any
> operations on the rest of the data areas.
> 
> It looks to me as though this could happen any time a page
> is marked inaccessible by the dirty/young tracking.
> Not just as a result of COW.

Except that for many architectures, there's a hard wired assumption that
the state of the PTEs won't change at interrupt time.

If we allow the "atomic" user accesses, we'll break that rule (think
about perf backtraces for example), and so would have to at -least-
disable interrupts around all the PTE accessors, or use atomic ops,
which will slow things down all over the place.

Cheers,
Ben.


