Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab1CYMIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 08:08:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:42699 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab1CYMIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 08:08:05 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in test_and_set_bit_lock if possible
Date: Fri, 25 Mar 2011 17:34:54 +0530
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-desktop; KDE/4.4.4; x86_64; ; )
Cc: Jan Beulich <JBeulich@novell.com>, Jack Steiner <steiner@sgi.com>,
        Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <201103241026.01624.knikanth@suse.de> <4D8C772202000078000384E1@vpn.id2.novell.com> <20110325111013.GA29521@elte.hu>
In-Reply-To: <20110325111013.GA29521@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103251734.55239.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 25, 2011 04:40:13 pm Ingo Molnar wrote:
> * Jan Beulich <JBeulich@novell.com> wrote:
> > >>> On 24.03.11 at 18:19, Ingo Molnar <mingo@elte.hu> wrote:
> > > * Jan Beulich <JBeulich@novell.com> wrote:
> > >> Are you certain? Iirc the lock prefix implies minimally a read-for-
> > >> ownership (if CPUs are really smart enough to optimize away the
> > >> write - I wonder whether that would be correct at all when it
> > >> comes to locked operations), which means a cacheline can still be
> > >> bouncing heavily.
> > > 
> > > Yeah. On what workload was this?
> > > 
> > > Generally you use test_and_set_bit() if you expect it to be 'owned' by
> > > whoever calls it, and released by someone else.
> > > 
> > > It would be really useful to run perf top on an affected box and see
> > > which kernel function causes this. It might be better to add a
> > > test_bit() to the affected codepath - instead of bloating all
> > > test_and_set_bit() users.
> > 
> > Indeed, I agree with you and Linus in this aspect.
> > 
> > > Note that the patch can also cause overhead: the test_bit() can miss
> > > the cache, it will bring in the cacheline shared, and the subsequent
> > > test_and_set() call will then dirty the cacheline - so the CPU might
> > > miss again and has to wait for other CPUs to first flush this
> > > cacheline.
> > > 
> > > So we really need more details here.
> > 
> > The problem was observed with __lock_page() (in a variant not
> > upstream for reasons not known to me), and prefixing e.g.
> > trylock_page() with an extra PageLocked() check yielded the
> > below quoted improvements.
> 
> The page lock flag is indeed one of those (rather rare) exceptions to
> typical object locking patterns. So in that particular case adding the
> PageLocked() test to trylock_page() would be the right approach to
> improving performance.
> 
> In the common case this change actively hurts for various reasons:
> 
>  - can turn a cache miss into two cache misses
>  - adds an often unnecessary branch instruction
>  - adds often unnecessary bloat
>  - leaks a barrier
> 

Yes, I think I am observing these ill-effects when testing the code copied to 
user-space.

Thanks
Nikanth
