Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab2AIPn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:43:58 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60109 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932170Ab2AIPn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:43:56 -0500
X-Sasl-enc: isf63vVl0Ting0K+gm8Jlhsld5W6shd/jI2QSwtm2ltE 1326123835
Date: Mon, 9 Jan 2012 07:42:59 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20120109154259.GD9329@kroah.com>
References: <20120105190405.1e3191fb5a43b2a0f1655e1f@canb.auug.org.au>
 <20120105160448.dc482ef6.akpm@linux-foundation.org>
 <20120109165950.53933c3050416bd242acff76@canb.auug.org.au>
 <20120109172016.2496b94ce207c5f7f750a1ea@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109172016.2496b94ce207c5f7f750a1ea@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 05:20:16PM +1100, Stephen Rothwell wrote:
> On Mon, 9 Jan 2012 16:59:50 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > On Thu, 5 Jan 2012 16:04:48 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > On Thu, 5 Jan 2012 19:04:05 +1100
> > > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > 
> > > > After merging the final tree, today's linux-next build (sparc64 defconfig)
> > > > failed like this:
> > > > 
> > > > In file included from include/trace/ftrace.h:567:0,
> > > >                  from include/trace/define_trace.h:86,
> > > >                  from include/trace/events/power.h:240,
> > > >                  from kernel/trace/power-traces.c:14:
> > > > include/trace/events/kmem.h: In function 'ftrace_test_probe_kmalloc':
> > > > include/trace/events/kmem.h:45:1: error: implicit declaration of function 'check_trace_callback_type_kmalloc' [-Werror=implicit-function-declaration]
> > > > include/trace/events/kmem.h: In function 'ftrace_test_probe_kmem_cache_alloc':
> > > >
> > > > ...
> > > >
> > > > include/trace/events/kmem.h:267:1: error: implicit declaration of function 'check_trace_callback_type_mm_page_alloc_extfrag' [-Werror=implicit-function-declaration]
> > > > In file included from include/trace/ftrace.h:774:0,
> > > >                  from include/trace/define_trace.h:86,
> > > >                  from include/trace/events/power.h:240,
> > > >                  from kernel/trace/power-traces.c:14:
> > > > include/trace/events/kmem.h: In function 'perf_test_probe_mm_page_pcpu_drain':
> > > > include/trace/events/kmem.h:256:1: error: implicit declaration of function 'check_trace_callback_type_mm_page_pcpu_drain' [-Werror=implicit-function-declaration]
> > > > 
> > > > I have no idea what has gone wrong here, but I did not get this error
> > > > yesterday.  The only thing that touched include/trace/events/kmem.h is
> > > > patch "mm-tracepoint: rename page-free events" from the akpm tree, but
> > > > that was there yesterday as well and doesn't look suspicious.
> > > 
> > > Yes, it's not due to anything in the akpm tree.  Tracing stuff blew up.
> > > 
> > > > I just have to leave things broken for today in the hope that someone
> > > > figures something out.  This does not affect my X86_64 allmodconfig build
> > > > or my PowerPC builds (including an allyesconfig build).
> > > 
> > > It fails with sparc64 defconfig but succeeds with sparc64 allmodconfig.
> > > Some config-dependent thing.  3.2 is OK, so it's something in -next.
> > > 
> > > It could be that some far-off sparc64 Kconfig change is newly
> > > triggering this.  
> > > 
> > > I suppose I could get off my ass and actually work out why it broke,
> > > but the tracing code is too icky.
> > 
> > This failure is now in Linus' tree.  I am not sure when it got there.
> 
> Bisected down to:
> 
> 8a25a2fd126c621f44f3aeaef80d51f00fc11639 is the first bad commit
> commit 8a25a2fd126c621f44f3aeaef80d51f00fc11639
> Author: Kay Sievers <kay.sievers@vrfy.org>
> Date:   Wed Dec 21 14:29:42 2011 -0800
> 
>     cpu: convert 'cpu' and 'machinecheck' sysdev_class to a regular subsystem

How is this triggering this build problem?  I didn't see this happen
before, and it wasn't showing up in linux-next in the past, right?

This patch has nothing to to with tracing, perhaps it is an #include
file problem?  Or is the build error a different one (remember the
-Werror problem in linux-next that I fixed up for PPC?)

confused,

greg k-h
