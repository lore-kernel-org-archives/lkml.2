Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab0KHLq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 06:46:58 -0500
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:5664 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754712Ab0KHLq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 06:46:57 -0500
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Nov 2010 06:46:57 EST
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: =?iso-8859-1?q?S=F8ren_Sandmann_Pedersen?= <ssp@redhat.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] x86: Eliminate bp argument from the stack tracing routines
References: <ye8ljj3mlj5.fsf@camel16.daimi.au.dk>
	<1288955674-2744-1-git-send-email-ssp@redhat.com>
	<20101107212412.GB11134@nowhere>
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 08 Nov 2010 12:38:22 +0100
In-Reply-To: <20101107212412.GB11134@nowhere>
Message-ID: <ye87hgorqoh.fsf@camel17.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-NFIT-ADSL: 0
X-NFIT-RelayAddr: 130.225.16.136
X-Sim: 1ad06880742ac38d89e209d1b9ba03db254b3b224bf2e2c627762c80f561ab8f 1680
X-NFIT-Solido-Score: 0.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> > (FWIW, this
> > 
> > diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> > index 461a85d..d977d26 100644
> > --- a/arch/x86/kernel/cpu/perf_event.c
> > +++ b/arch/x86/kernel/cpu/perf_event.c
> > @@ -1653,7 +1653,7 @@ static const struct stacktrace_ops backtrace_ops = {
> >  	.warning_symbol		= backtrace_warning_symbol,
> >  	.stack			= backtrace_stack,
> >  	.address		= backtrace_address,
> > -	.walk_stack		= print_context_stack_bp,
> > +	.walk_stack		= print_context_stack,
> >  };
> > 
> > makes it produce correct kernel callchains. And yes, I did compile the
> > kernel with CONFIG_FRAME_POINTER).
> 
> 
> 
> What do you see is broken in 64 bits perf callchains? Can you please provide
> me more details so that I can fix the issue?

Apparently, the problem only happens when using the hrtimer based
events. I don't think there is a way to make perf use those from the
command line, but if you apply this:

--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -294,6 +294,12 @@ static void create_counter(int counter, int cpu)
                attr->enable_on_exec = 1;
        }
 
+       if (attr->config == PERF_COUNT_HW_CPU_CYCLES && attr->type ==
PERF_TYPE_HARDWARE)
+       {
+           attr->type = PERF_TYPE_SOFTWARE;
+           attr->config = PERF_COUNT_SW_CPU_CLOCK;
+       }
+       
        for (thread_index = 0; thread_index < thread_num; thread_index++) {
 try_again:
                fd[nr_cpu][counter][thread_index] = sys_perf_event_open(attr,

you should be able to see the problem.  You can also try sysprof; it
always uses the software counters.


Soren
