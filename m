Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab0GLBTL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 21:19:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755405Ab0GLBTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 21:19:07 -0400
MIME-Version: 1.0
In-Reply-To: <1278885797.6740.18.camel@localhost>
References: <4C3A06E3.50402@kernel.org>
	<AANLkTik8EHarsrnAisuj9SKbeXddlA6Dz-KzDOPsmBxh@mail.gmail.com>
	<1278885797.6740.18.camel@localhost>
Date: Sun, 11 Jul 2010 18:18:30 -0700
Message-ID: <AANLkTim5a4OxT518REsmNow-wo3T2qdkUORv876Adcqj@mail.gmail.com>
Subject: Re: [RFC PATCH] x86-64: software IRQ masking and handling
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 11, 2010 at 3:03 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> I have seen some hits with cli-sti. I was considering swapping all
> preempt_disable() with local_irq_save() in ftrace, but hackbench showed
> a 30% performance degradation when I did that.

Yeah, but in that case you almost certainly keep the per-cpu cacheline
hot in the D$ L1 cache, and the stack tracer is presumably also not
taking any extra I$ L1 misses. So you're not seeing any of the
downsides. The upside of plain cli/sti is that they're small, and have
no D$ footprint.

And it's possible that the interrupt flag - at least if/when
positioned right - wouldn't have any additional D$ footprint under
normal load either. IOW, if there is an existing per-cpu cacheline
that is effectively always already dirty and in the cache,
But that's something that really needs macro-benchmarks - exactly
because microbenchmarks don't show those effects since they are always
basically hot-cache.

Also, the preempt code is pretty optimized and uses "add". Tejun uses
"btrl" at least in some places, which is generally not a fast
instruction.  So there's a few caveats there too. Which is why I'd
want numbers.

                   Linus
