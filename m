Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab1CYLKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:10:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48790 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363Ab1CYLKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:10:45 -0400
Date: Fri, 25 Mar 2011 12:10:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: Jack Steiner <steiner@sgi.com>, Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in test_and_set_bit_lock
 if possible
Message-ID: <20110325111013.GA29521@elte.hu>
References: <201103241026.01624.knikanth@suse.de>
 <20110324085647.GI30812@elte.hu>
 <20110324145221.GC31194@aftab>
 <4D8B83DA02000078000381DE@vpn.id2.novell.com>
 <20110324171924.GC2414@elte.hu>
 <4D8C772202000078000384E1@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8C772202000078000384E1@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> >>> On 24.03.11 at 18:19, Ingo Molnar <mingo@elte.hu> wrote:
> > * Jan Beulich <JBeulich@novell.com> wrote:
> >> Are you certain? Iirc the lock prefix implies minimally a read-for-
> >> ownership (if CPUs are really smart enough to optimize away the
> >> write - I wonder whether that would be correct at all when it
> >> comes to locked operations), which means a cacheline can still be
> >> bouncing heavily.
> > 
> > Yeah. On what workload was this?
> > 
> > Generally you use test_and_set_bit() if you expect it to be 'owned' by 
> > whoever calls it, and released by someone else.
> > 
> > It would be really useful to run perf top on an affected box and see which 
> > kernel function causes this. It might be better to add a test_bit() to the 
> > affected codepath - instead of bloating all test_and_set_bit() users.
> 
> Indeed, I agree with you and Linus in this aspect.
> 
> > Note that the patch can also cause overhead: the test_bit() can miss the 
> > cache, it will bring in the cacheline shared, and the subsequent test_and_set() 
> > call will then dirty the cacheline - so the CPU might miss again and has to wait 
> > for other CPUs to first flush this cacheline.
> > 
> > So we really need more details here.
> 
> The problem was observed with __lock_page() (in a variant not
> upstream for reasons not known to me), and prefixing e.g.
> trylock_page() with an extra PageLocked() check yielded the
> below quoted improvements.

The page lock flag is indeed one of those (rather rare) exceptions to typical 
object locking patterns. So in that particular case adding the PageLocked() 
test to trylock_page() would be the right approach to improving performance.

In the common case this change actively hurts for various reasons:

 - can turn a cache miss into two cache misses
 - adds an often unnecessary branch instruction
 - adds often unnecessary bloat
 - leaks a barrier

Thanks,

	Ingo
