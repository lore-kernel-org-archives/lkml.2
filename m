Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab0ELP1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:27:51 -0400
Received: from mail.openrapids.net ([64.15.138.104]:46096 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752801Ab0ELP1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:27:50 -0400
Date: Wed, 12 May 2010 11:27:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH -tip 4/5] kprobes/x86: Use text_poke_smp_batch
Message-ID: <20100512152747.GA12326@Krystal>
References: <20100510175313.27396.34605.stgit@localhost6.localdomain6> <20100510175340.27396.7222.stgit@localhost6.localdomain6> <20100511144013.GA17656@Krystal> <4BE9F952.3060505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE9F952.3060505@redhat.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:25:55 up 109 days, 18:03,  8 users,  load average: 0.21, 0.14,
	0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Mathieu Desnoyers wrote:
> > * Masami Hiramatsu (mhiramat@redhat.com) wrote:
> >> Use text_poke_smp_batch() in optimization path for reducing
> >> the number of stop_machine() issues.
> >>
> >> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> >> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> >> Cc: Ingo Molnar <mingo@elte.hu>
> >> Cc: Jim Keniston <jkenisto@us.ibm.com>
> >> Cc: Jason Baron <jbaron@redhat.com>
> >> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> >> ---
> >>
> >>  arch/x86/kernel/kprobes.c |   37 ++++++++++++++++++++++++++++++-------
> >>  include/linux/kprobes.h   |    2 +-
> >>  kernel/kprobes.c          |   13 +------------
> >>  3 files changed, 32 insertions(+), 20 deletions(-)
> >>
> >> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> >> index 345a4b1..63a5c24 100644
> >> --- a/arch/x86/kernel/kprobes.c
> >> +++ b/arch/x86/kernel/kprobes.c
> >> @@ -1385,10 +1385,14 @@ int __kprobes arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
> >>  	return 0;
> >>  }
> >>  
> >> -/* Replace a breakpoint (int3) with a relative jump.  */
> >> -int __kprobes arch_optimize_kprobe(struct optimized_kprobe *op)
> >> +#define MAX_OPTIMIZE_PROBES 256
> > 
> > So what kind of interrupt latency does a 256-probes batch generate on the
> > system ?  Are we talking about a few milliseconds, a few seconds ?
> 
> From my experiment on kvm/4cpu, it took about 3 seconds in average.

That's 3 seconds for multiple calls to stop_machine(). So we can expect
latencies in the area of few microseconds for each call, right ?

> With this patch, it went down to 30ms. (x100 faster :))

This is beefing up the latency from few microseconds to 30ms. It sounds like a
regression rather than a gain to me.

Thanks,

Mathieu

> 
> Thank you,
> -- 
> Masami Hiramatsu
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
