Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab0E1OdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 10:33:21 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:60162 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0E1OdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 10:33:20 -0400
Date: Fri, 28 May 2010 16:33:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: Add persistent events
Message-ID: <20100528143311.GB9710@elte.hu>
References: <1274554806-28216-1-git-send-email-bp@alien8.de>
 <1274554806-28216-2-git-send-email-bp@alien8.de>
 <1274638513.1674.1727.camel@laptop>
 <20100523183353.GB1408@liondog.tnic>
 <1274640047.1674.1731.camel@laptop>
 <20100523185411.GA5608@liondog.tnic>
 <1274642601.1674.1755.camel@laptop>
 <20100525073246.GA6085@liondog.tnic>
 <1274799588.5882.1572.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274799588.5882.1572.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2010-05-25 at 09:32 +0200, Borislav Petkov wrote:
> > From: Peter Zijlstra <peterz@infradead.org>
> > Date: Sun, May 23, 2010 at 09:23:21PM +0200
> > 
> > > Either we add some notifier thing, or we simply add an explicit call in
> > > the init sequence after the perf_event subsystem is running. I would
> > > suggest we start with some explicit call, and take it from there.
> > 
> > Ok, this couldn't be more straightforward. So I looked at the init
> > sequence we do when booting wrt to perf/ftrace initialization:
> > 
> > start_kernel
> > ...
> > |-> sched_init
> >     |-> perf_event_init
> > ...
> > |-> ftrace_init
> > rest_init
> > kernel_init
> > |-> do_pre_smp_initcalls
> > |...
> > |-> smp_int
> > |-> do_basic_setup
> >     |-> do_initcalls
> > 
> > and one of the convenient places after both perf is initialized and
> > ftrace has enumerated the tracepoints is do_initcalls() (It cannot be an
> > early_initcall since at that time we're not running SMP yet and we want
> > the MCE event per cpu.)
> > 
> > So I added a core_initcall that registers the mce perf event. This makes
> > it more or less a persistent event without any changes to the perf_event
> > subsystem. I guess this should work - at least it builds here, will give
> > it a run later.
> > 
> > As a further enhancement, the init-function should read out all the
> > logged mce events which survived the warm reboot and those which happen
> > between mce init and the actual event registration so that perf can
> > postprocess those too at a more convenient time.
> 
> Right, so that looks good. Now the interesting part is twofold:
> 
>  1) expose these perf_events to userspace, since they're now created
>     in kernel, there is no user-space access point to them. One way
>     way would be to extend the perf syscall to allow attaching to an
>     existing instance (but that would limit us to a single instance per
>     'attr'), or create some /debug or /sys iteration of all such events.

Yeah.

>  2) get these things a buffer, perf_events as created don't actually
>     have an output buffer, normally that is created at mmap() time, but
>     since you cannot mmap() a kernel side event, it doesn't get to have
>     a buffer. This could be done by extracting perf_mmap_data_alloc()
>     into a sensible interface.

#2 could be a new syscall: sys_create_ring_buffer or so?

	Ingo
