Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab2HPLpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 07:45:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:53286 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2HPLpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 07:45:15 -0400
Message-ID: <1345117498.29668.23.camel@twins>
Subject: Re: powerpc/perf: hw breakpoints return ENOSPC
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Neuling <mikey@neuling.org>
Cc: K Prasad <prasad@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@kernel.org>
Date: Thu, 16 Aug 2012 13:44:58 +0200
In-Reply-To: <20344.1345115849@neuling.org>
References: <28857.1345091034@neuling.org>
	 <1345102812.31459.114.camel@twins> <20344.1345115849@neuling.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 21:17 +1000, Michael Neuling wrote:
> Peter,
> 
> > > On this second syscall, fetch_bp_busy_slots() sets slots.pinned to be 1,
> > > despite there being no breakpoint on this CPU.  This is because the call
> > > the task_bp_pinned, checks all CPUs, rather than just the current CPU.
> > > POWER7 only has one hardware breakpoint per CPU (ie. HBP_NUM=1), so we
> > > return ENOSPC.
> > 
> > I think this comes from the ptrace legacy, we register a breakpoint on
> > all cpus because when we migrate a task it cannot fail to migrate the
> > breakpoint.
> > 
> > Its one of the things I hate most about the hwbp stuff as it relates to
> > perf.
> > 
> > Frederic knows more...
> 
> Maybe I should wait for Frederic to respond but I'm not sure I
> understand what you're saying.
> 
> I can see how using ptrace hw breakpoints and perf hw breakpoints at the
> same time could be a problem, but I'm not sure how this would stop it.

ptrace uses perf for hwbp support so we're stuck with all kinds of
stupid ptrace constraints.. or somesuch.

> Are you saying that we need to keep at least 1 slot free at all times,
> so that we can use it for ptrace?

No, I'm saying perf-hwbp is weird because of ptrace, maybe the ptrace
weirdness shouldn't live in perf-hwpb but in the ptrace-perf glue
however..

> Is "perf record -e mem:0x10000000 true" ever going to be able to work on
> POWER7 with only one hw breakpoint resource per CPU?  

I think it should work... but I'm fairly sure it currently doesn't
because of how things are done. 'perf record -ie mem:0x100... true'
might just work.

I always forget all the ptrace details but I am forever annoyed at the
mess that is perf-hwbp.. Frederic is there really nothing we can do
about this?

The fact that ptrace hwbp semantics are different per architecture
doesn't help of course.
