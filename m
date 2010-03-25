Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab0CYIvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 04:51:50 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:40462 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab0CYIvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 04:51:48 -0400
Date: Thu, 25 Mar 2010 14:11:52 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@redhat.com>, Tom Tromey <tromey@redhat.com>
Subject: Re: [PATCH v1 7/10] Uprobes Implementation
Message-ID: <20100325084152.GB26371@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
 <20100320142617.11427.23852.sendpatchset@localhost6.localdomain6>
 <1269342115.5279.1620.camel@twins>
 <20100323122335.GB26762@linux.vnet.ibm.com>
 <1269352012.5109.22.camel@twins>
 <20100324075815.GC26762@linux.vnet.ibm.com>
 <1269435604.5109.235.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1269435604.5109.235.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I'm not sure, currently all the tracing bits require root. One of the
> complications is that dynamic trace events (kprobes and uprobes) share a
> global namespace, so making that accessible to users might be
> interesting.
> 
> So one thing we can do to avoid some of the trap overhead is to
> de-couple the trace event creation from trace event enable (pretty much
> already so for existing implementations), so while you define a dynamic
> trace event as dso:sym, you provide ways to enable it globally and per
> task.
> 
> We'd basically need a global and per-task refcount on enable and make
> sure the breakpoint is installed properly for (global || task).

Yes, when we allow two or more probes to co-exist at a probepoint, we
will be able to do this.

> 
> That way a perf per-cpu event will do the global enable, and a perf
> per-task event will do the task enable.
> 

> 
> A double scribble will be an issue for the current generation of
> debuggers anyway, right?
> 

double scribble as in two apps writing to the same address? Uprobes
handles this by failing into insert probes at location where there is a
breakpoint already inserted. So if both apps were to use the uprobes
interface, then they could co-operate and co-exist. (This would need the
feature in uprobes to have multiple probes per probepoint which is
excluded in this RFC).

> But yes, I suppose if you want to use uprobes for debuggers then yes it
> makes sense to allow to put the task to sleep. One way would be to
> provide means for the handler to detect the context and simply always
> return -EFAULT from the trap context.
> 

Yes, thats certainly possible. However lets consider the case when we
allow multiple probes per probepoint and one handler faults (handler
detects it could be sleeping) while the other handler may or may not
fault (handler could be doing a copy_from_user). 
When the thread switches to task context and runs the first handler but
it has no state information about the second handler having run in the
interrupt context. So here we may be unable to decide if we should run
the second handler or not.

--
Thanks and Regards
Srikar
