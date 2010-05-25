Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab0EYPAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:00:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32822 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338Ab0EYPAE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:00:04 -0400
Subject: Re: [PATCH 1/2] perf: Add persistent events
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100525073246.GA6085@liondog.tnic>
References: <1274554806-28216-1-git-send-email-bp@alien8.de>
	 <1274554806-28216-2-git-send-email-bp@alien8.de>
	 <1274638513.1674.1727.camel@laptop> <20100523183353.GB1408@liondog.tnic>
	 <1274640047.1674.1731.camel@laptop> <20100523185411.GA5608@liondog.tnic>
	 <1274642601.1674.1755.camel@laptop>  <20100525073246.GA6085@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 May 2010 16:59:48 +0200
Message-ID: <1274799588.5882.1572.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 09:32 +0200, Borislav Petkov wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Sun, May 23, 2010 at 09:23:21PM +0200
> 
> > Either we add some notifier thing, or we simply add an explicit call in
> > the init sequence after the perf_event subsystem is running. I would
> > suggest we start with some explicit call, and take it from there.
> 
> Ok, this couldn't be more straightforward. So I looked at the init
> sequence we do when booting wrt to perf/ftrace initialization:
> 
> start_kernel
> ...
> |-> sched_init
>     |-> perf_event_init
> ...
> |-> ftrace_init
> rest_init
> kernel_init
> |-> do_pre_smp_initcalls
> |...
> |-> smp_int
> |-> do_basic_setup
>     |-> do_initcalls
> 
> and one of the convenient places after both perf is initialized and
> ftrace has enumerated the tracepoints is do_initcalls() (It cannot be an
> early_initcall since at that time we're not running SMP yet and we want
> the MCE event per cpu.)
> 
> So I added a core_initcall that registers the mce perf event. This makes
> it more or less a persistent event without any changes to the perf_event
> subsystem. I guess this should work - at least it builds here, will give
> it a run later.
> 
> As a further enhancement, the init-function should read out all the
> logged mce events which survived the warm reboot and those which happen
> between mce init and the actual event registration so that perf can
> postprocess those too at a more convenient time.

Right, so that looks good. Now the interesting part is twofold:

 1) expose these perf_events to userspace, since they're now created
    in kernel, there is no user-space access point to them. One way
    way would be to extend the perf syscall to allow attaching to an
    existing instance (but that would limit us to a single instance per
    'attr'), or create some /debug or /sys iteration of all such events.


 2) get these things a buffer, perf_events as created don't actually
    have an output buffer, normally that is created at mmap() time, but
    since you cannot mmap() a kernel side event, it doesn't get to have
    a buffer. This could be done by extracting perf_mmap_data_alloc()
    into a sensible interface.


