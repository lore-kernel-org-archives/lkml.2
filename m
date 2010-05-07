Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab0EGPaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:30:39 -0400
Received: from mail.openrapids.net ([64.15.138.104]:56615 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755080Ab0EGPah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:30:37 -0400
Date: Fri, 7 May 2010 11:30:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/9 - v2][RFC] tracing: Let tracepoints have
	data?passed to tracepoint callbacks
Message-ID: <20100507153035.GA15267@Krystal>
References: <7a22ce9b-4c74-4818-9521-7fbccd1b8b1d@email.android.com> <20100507143901.GA18408@Krystal> <1273244123.22438.140.camel@gandalf.stny.rr.com> <20100507150838.GB30356@Krystal> <1273245338.22438.168.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273245338.22438.168.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:23:25 up 104 days, 18:00,  7 users,  load average: 0.05, 0.09,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Fri, 2010-05-07 at 11:08 -0400, Mathieu Desnoyers wrote:
> 
> > > > Can you show me where the C standard says it is safe to do so ?
> > > 
> > > No, but it seems safe in the kernel ;-)
> > 
> > The use of "seems" here does not give me a warm feeling of safety. ;)
> 
> Right, which is why I added the below.
> 
> > 
> > > 
> > > But that said. There is another option that will conform to this, and
> > > that is to add flags to registering tracepoints. I already wrote a patch
> > > for this in trying to do some other work (that I threw away).
> > > 
> > > 
> > > So here's the proposal.
> > > 
> > > Change struct tracepoint_func to...
> > > 
> > > struct tracepoint_func {
> > > 	void *func;
> > > 	void *data;
> > > 	unsigned int flags;
> > > };
> > > 
> > > 
> > > The flags is set when registered. If a function is registered with data,
> > > then the flags field will be set. Then the calling of the function can
> > > be:
> > > 
> > > 	if ((it_func_ptr)->flags & TP_FL_DATA)
> > > 		((void(*)(proto, void *))(it_func)(args, __data);
> > > 	else
> > > 		((void(*)(proto))(it_func)(args);
> > > 
> > > This would comply with the C standard.
> > 
> > This would also add a branch on the tracing fast path, which I would like to
> > avoid. Why can't we simply change all prototypes to take an extra void *__data
> > parameter instead ?
> 
> I'm fine with making the data parameter mandatory with all tracers. Thus
> the call back must require it. I would then move the data parameter from
> the end to the beginning.
> 
> So a tracepoint with proto, will have a callback:
> 
> 	void callback(void *data, proto);
> 
> I'm fine with forcing all callbacks to include a data parameter if you
> are. This would also make the changes simpler.

Yes, I am all for it.

As for the extra type checking, it is basically just trying to force you to
generate matching caller-callee prototypes in your CPP macros. The goal is
really to check that the data parameter type match in both the caller and
callee. I see that as a mean to make sure nobody is going to try to take
shortcuts by playing with the callback types in the "undefined behavior" zone of
the C standard in future TRACE_EVENT() modifications.

Thanks,

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
