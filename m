Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab1GQOhv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 10:37:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:59267 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab1GQOhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 10:37:50 -0400
Subject: Re: [PATCH 1/1] Fixup write permission of TLB on powerpc e500 core
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Shan Hai <haishan.bai@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        paulus@samba.org, tglx@linutronix.de, walken@google.com,
        dhowells@redhat.com, cmetcalf@tilera.com, tony.luck@intel.com,
        akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4b337921-d430-4b63-bc36-ad31753cf800@email.android.com>
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>
	 <1310725418.2586.309.camel@twins> <4E21A526.8010904@gmail.com>
	 <1310860194.25044.17.camel@pasglop>
	 <4b337921-d430-4b63-bc36-ad31753cf800@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 00:29:50 +1000
Message-ID: <1310912990.25044.203.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-17 at 11:38 +0200, Peter Zijlstra wrote:

> Whats this talk about interrup context? There is non of that involved.

Ok, let's not mix things here. I was going to fast and may have murkied
the waters. First let's get back to the futex code issue with gup:

> Furthermore, I still dont see the problem. The futex code is
> optimistically trying to poke at user memory while holding spinlocks.
> 
> We fully expect that to fail, hence the error path that drops all
> locks and does the gup(.write=1) to fix up the mapping after which we
> try again.

See below

> This has worked for years, its by no means new code. Nor do I see how
> its broken.

No it hasn't worked for years, it's been broken for years on some archs
but nobody noticed :-)

The problem I see is that gup doesn't set dirty (or young) itself. It
requires the caller to set dirty before releasing the pages basically
and there's no provision for young. Afaik, callers set it directly in
the struct page and not the PTE too (which means a spurrious fault on
subsequent access for archs that do dirty tracking).

On archs where dirty and young are SW tracked, pages that don't have
them set in the PTE will fault on access. The lack of dirty means the
page is effectively going to be read-only and the lack of young means
the page will be inaccessible.

gup itself isn't mean to fix those, at least the way it's been used so
far, the caller of gup is.

Thus the only "proper" way to fix that is to have the futex code itself
perform dirty and accessed updates, which sucks (means going back down
the page tables, taking the PTL and doing the deed).

Having the actual fault handlers do the fixup even when in atomic isn't
a good option for us:

I don't know what other archs that rely on that SW tracking do, but in
the case of powerpc, that would be problematic due to the fact that
those archs have been written with the assumption that all changes to
PTEs are done under the PTL (which allows to simplify code and thus make
things faster).

Among others, that also means no changes at interrupt time. Enabling our
fault handlers to update the dirty & young bits even while in "atomic"
context would potentially open the door to things like interrupt-time
perf backtraces to cause PTE updates, etc... (in addition to generally
breaking the locking rules for PTE modifications).

Now, I suppose we -could- differentiate preempt disabled from real
interrupt time in the fault handlers, tho that's somewhat sucky. It
might require moving the dirty/young updates from generic code to arch
code, I suppose.

I'm also not sure how risky it would be to take the PTL in that case...
code doing user accesses within pagefault_disable() might be written
with the assumption that the PTL won't be taken (it might be already
held ? I don't know what all the users are at this point, too late to
grep, I can have a look tomorrow). It makes me a bit nervous too.

A better approach might be a flag to pass to gup (via the "write"
argument ? top bits ?) to tell it to immediately perform dirty/young
updates.

Cheers,
Ben.


