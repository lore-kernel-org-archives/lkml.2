Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab0CWP2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:28:23 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:62797 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab0CWP2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:28:22 -0400
Date: Tue, 23 Mar 2010 08:26:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: 2.6.33 GP fault only when built with tracing
Message-Id: <20100323082643.dbf77c46.randy.dunlap@oracle.com>
In-Reply-To: <20100319184610.GA29161@Krystal>
References: <4BA2B69D.3000309@oracle.com>
	<1268956555.758.18.camel@gandalf.stny.rr.com>
	<20100319005901.GB23020@Krystal>
	<4BA3C0CF.6070005@oracle.com>
	<20100319184610.GA29161@Krystal>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4BA8DE08.0055:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Mar 2010 14:46:10 -0400 Mathieu Desnoyers wrote:

> * Randy Dunlap (randy.dunlap@oracle.com) wrote:
> > On 03/18/10 17:59, Mathieu Desnoyers wrote:
> > > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > >> On Thu, 2010-03-18 at 16:26 -0700, Randy Dunlap wrote:
> > >>> I can build/boot 2.6.33 with CONFIG_TRACE/TRACING disabled successfully,
> > >>> but when I enable lots of tracing config options and then boot with
> > >>> ftrace=nop on the kernel command line, I see a GP fault when the parport &
> > >>> parport_pc modules are loading/initializing.
> > >>
> > >> Do you see it without adding the "ftrace=nop"? The only thing that
> > >> should do is expand the ring buffer on boot up.
> > >>
> > >>>
> > >>> It happens in drivers/parport/share.c::parport_register_device(), when that
> > >>> function calls try_module_get().
> > >>>
> > >>> If I comment out the trace_module_get() calls in include/linux/module.h,
> > >>> the kernel boots with no problems.
> > >>
> > >>
> > >> Interesting. Well, trace_module_get() is a TRACE_EVENT tracepoint. But
> > >> should be disabled here. It may be something to do with DEFINE_TRACE. 
> > >>
> > >> (added Mathieu to Cc since he wrote that code)
> > > 
> > > can you try replacing the "local_read(__module_ref_addr(module, cpu))" argument
> > > with "0" ?
> > 
> > Yes, that boots with no problems.
> 
> clickety-clicketa... git blame include/linux/module.h :
> 
> commit 7ead8b8313d92b3a69a1a61b0dcbc4cd66c960dc
> Author: Li Zefan <lizf@cn.fujitsu.com>
> Date:   Mon Aug 17 16:56:28 2009 +0800
> 
>     tracing/events: Add module tracepoints
> 
> (Adding Li Zefan in CC)
> 
> Two things:
> 
> 1) In this commit, most of the tracepoints contain argument with side-effects.
>    These do not belong there; they should be moved into TRACE_EVENT macros.
> 
> 2) There seem to be a null-pointer bug with
>    local_read(__module_ref_addr(module, cpu)) in try_module_get(). This should
>    be investigated even if we move the argument to TRACE_EVENT.

Hi Li,

Fix this, please?


> Thanks,
> 
> Mathieu
> 
> > 
> > > Arguments with side-effects are not skipped by the jump over disabled
> > > instrumentation. This is why we should do that part within the probe declaration
> > > in the TRACE_EVENT macros.
> > > 
> > > But if we find out that the problem really is this argument, then it should be
> > > fixed, because something would be wrong with it (just moving it to TRACE_EVENT
> > > is not a proper solution).
> > > 
> > > Thanks,
> > > 
> > > Mathieu


---
~Randy
