Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab0CXBU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 21:20:57 -0400
Received: from mail.openrapids.net ([64.15.138.104]:34890 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753449Ab0CXBU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 21:20:56 -0400
Date: Tue, 23 Mar 2010 21:20:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: 2.6.33 GP fault only when built with tracing
Message-ID: <20100324012053.GA17187@Krystal>
References: <4BA2B69D.3000309@oracle.com> <1268956555.758.18.camel@gandalf.stny.rr.com> <20100319005901.GB23020@Krystal> <4BA3C0CF.6070005@oracle.com> <20100319184610.GA29161@Krystal> <20100323082643.dbf77c46.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323082643.dbf77c46.randy.dunlap@oracle.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 20:52:35 up 60 days,  3:29,  7 users,  load average: 1.05, 1.04,
	1.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (randy.dunlap@oracle.com) wrote:
> On Fri, 19 Mar 2010 14:46:10 -0400 Mathieu Desnoyers wrote:
> 
> > * Randy Dunlap (randy.dunlap@oracle.com) wrote:
> > > On 03/18/10 17:59, Mathieu Desnoyers wrote:
> > > > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > >> On Thu, 2010-03-18 at 16:26 -0700, Randy Dunlap wrote:
> > > >>> I can build/boot 2.6.33 with CONFIG_TRACE/TRACING disabled successfully,
> > > >>> but when I enable lots of tracing config options and then boot with
> > > >>> ftrace=nop on the kernel command line, I see a GP fault when the parport &
> > > >>> parport_pc modules are loading/initializing.
> > > >>
> > > >> Do you see it without adding the "ftrace=nop"? The only thing that
> > > >> should do is expand the ring buffer on boot up.
> > > >>
> > > >>>
> > > >>> It happens in drivers/parport/share.c::parport_register_device(), when that
> > > >>> function calls try_module_get().
> > > >>>
> > > >>> If I comment out the trace_module_get() calls in include/linux/module.h,
> > > >>> the kernel boots with no problems.
> > > >>
> > > >>
> > > >> Interesting. Well, trace_module_get() is a TRACE_EVENT tracepoint. But
> > > >> should be disabled here. It may be something to do with DEFINE_TRACE. 
> > > >>
> > > >> (added Mathieu to Cc since he wrote that code)
> > > > 
> > > > can you try replacing the "local_read(__module_ref_addr(module, cpu))" argument
> > > > with "0" ?
> > > 
> > > Yes, that boots with no problems.
> > 
> > clickety-clicketa... git blame include/linux/module.h :
> > 
> > commit 7ead8b8313d92b3a69a1a61b0dcbc4cd66c960dc
> > Author: Li Zefan <lizf@cn.fujitsu.com>
> > Date:   Mon Aug 17 16:56:28 2009 +0800
> > 
> >     tracing/events: Add module tracepoints
> > 
> > (Adding Li Zefan in CC)
> > 
> > Two things:
> > 
> > 1) In this commit, most of the tracepoints contain argument with side-effects.
> >    These do not belong there; they should be moved into TRACE_EVENT macros.
> > 
> > 2) There seem to be a null-pointer bug with
> >    local_read(__module_ref_addr(module, cpu)) in try_module_get(). This should
> >    be investigated even if we move the argument to TRACE_EVENT.
> 
> Hi Li,
> 
> Fix this, please?
> 

While we wait for the sun to move to other time zones, can you check if the
following patch fixes your problem ?


module: fix __module_ref_addr()

__module_ref_addr() should use per_cpu_ptr() to obfuscate the pointer
(RELOC_HIDE is needed for per cpu pointers).

This non-standard per-cpu pointer use has been introduced by commit
720eba31f47aeade8ec130ca7f4353223c49170f

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Eric Dumazet <dada1@cosmosbay.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/module.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/include/linux/module.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/module.h	2010-03-23 18:11:14.000000000 -0400
+++ linux-2.6-lttng/include/linux/module.h	2010-03-23 18:14:07.000000000 -0400
@@ -467,7 +467,7 @@ void symbol_put_addr(void *addr);
 static inline local_t *__module_ref_addr(struct module *mod, int cpu)
 {
 #ifdef CONFIG_SMP
-	return (local_t *) (mod->refptr + per_cpu_offset(cpu));
+	return (local_t *) per_cpu_ptr(mod->refptr, cpu);
 #else
 	return &mod->ref;
 #endif


> 
> > Thanks,
> > 
> > Mathieu
> > 
> > > 
> > > > Arguments with side-effects are not skipped by the jump over disabled
> > > > instrumentation. This is why we should do that part within the probe declaration
> > > > in the TRACE_EVENT macros.
> > > > 
> > > > But if we find out that the problem really is this argument, then it should be
> > > > fixed, because something would be wrong with it (just moving it to TRACE_EVENT
> > > > is not a proper solution).
> > > > 
> > > > Thanks,
> > > > 
> > > > Mathieu
> 
> 
> ---
> ~Randy

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
