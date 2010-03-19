Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab0CSSqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 14:46:14 -0400
Received: from mail.openrapids.net ([64.15.138.104]:38203 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751346Ab0CSSqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 14:46:12 -0400
Date: Fri, 19 Mar 2010 14:46:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Randy Dunlap <randy.dunlap@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: 2.6.33 GP fault only when built with tracing
Message-ID: <20100319184610.GA29161@Krystal>
References: <4BA2B69D.3000309@oracle.com> <1268956555.758.18.camel@gandalf.stny.rr.com> <20100319005901.GB23020@Krystal> <4BA3C0CF.6070005@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA3C0CF.6070005@oracle.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:38:49 up 55 days, 21:15,  9 users,  load average: 1.00, 1.02,
	1.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (randy.dunlap@oracle.com) wrote:
> On 03/18/10 17:59, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> >> On Thu, 2010-03-18 at 16:26 -0700, Randy Dunlap wrote:
> >>> I can build/boot 2.6.33 with CONFIG_TRACE/TRACING disabled successfully,
> >>> but when I enable lots of tracing config options and then boot with
> >>> ftrace=nop on the kernel command line, I see a GP fault when the parport &
> >>> parport_pc modules are loading/initializing.
> >>
> >> Do you see it without adding the "ftrace=nop"? The only thing that
> >> should do is expand the ring buffer on boot up.
> >>
> >>>
> >>> It happens in drivers/parport/share.c::parport_register_device(), when that
> >>> function calls try_module_get().
> >>>
> >>> If I comment out the trace_module_get() calls in include/linux/module.h,
> >>> the kernel boots with no problems.
> >>
> >>
> >> Interesting. Well, trace_module_get() is a TRACE_EVENT tracepoint. But
> >> should be disabled here. It may be something to do with DEFINE_TRACE. 
> >>
> >> (added Mathieu to Cc since he wrote that code)
> > 
> > can you try replacing the "local_read(__module_ref_addr(module, cpu))" argument
> > with "0" ?
> 
> Yes, that boots with no problems.

clickety-clicketa... git blame include/linux/module.h :

commit 7ead8b8313d92b3a69a1a61b0dcbc4cd66c960dc
Author: Li Zefan <lizf@cn.fujitsu.com>
Date:   Mon Aug 17 16:56:28 2009 +0800

    tracing/events: Add module tracepoints

(Adding Li Zefan in CC)

Two things:

1) In this commit, most of the tracepoints contain argument with side-effects.
   These do not belong there; they should be moved into TRACE_EVENT macros.

2) There seem to be a null-pointer bug with
   local_read(__module_ref_addr(module, cpu)) in try_module_get(). This should
   be investigated even if we move the argument to TRACE_EVENT.

Thanks,

Mathieu

> 
> > Arguments with side-effects are not skipped by the jump over disabled
> > instrumentation. This is why we should do that part within the probe declaration
> > in the TRACE_EVENT macros.
> > 
> > But if we find out that the problem really is this argument, then it should be
> > fixed, because something would be wrong with it (just moving it to TRACE_EVENT
> > is not a proper solution).
> > 
> > Thanks,
> > 
> > Mathieu
> 
> 
> -- 
> ~Randy

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
