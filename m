Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab2FLGGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 02:06:47 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:53562 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab2FLGGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 02:06:46 -0400
Date: Tue, 12 Jun 2012 11:36:26 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: Re: [Patch][perf] Invoke __perf_event_disable without an IPI
Message-ID: <20120612060626.GB2538@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20120611060242.GA2538@in.ibm.com>
 <1339413213.30462.11.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339413213.30462.11.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061206-2194-0000-0000-0000021F79FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 01:13:33PM +0200, Peter Zijlstra wrote:
> On Mon, 2012-06-11 at 11:32 +0530, K.Prasad wrote:
> 
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index fd126f8..0e2c1eb 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -1302,6 +1302,7 @@ static int __perf_event_disable(void *info)
> >   */
> >  void perf_event_disable(struct perf_event *event)
> >  {
> > +	int ret;
> >  	struct perf_event_context *ctx = event->ctx;
> >  	struct task_struct *task = ctx->task;
> >  
> > @@ -1314,6 +1315,17 @@ void perf_event_disable(struct perf_event *event)
> >  	}
> >  
> >  retry:
> > +	/*
> > +	 * perf_event_disable may be called when interrupts are disabled.
> > +	 * For e.g. hw_breakpoint_handler exception in PowerPC. Hence using
> > +	 * IPIs to invoke __perf_event_disable is not always suitable. When
> > +	 * possible invoke __perf_event_disable directly.
> > +	 */
> > +	if ((task_cpu(task) == smp_processor_id()) && irqs_disabled()) {
> 
> Urgh.. 
> 
> So what's the callchain for the ppc->hw_bp->perf that triggers this?

Hardware breakpoints for user-space have traditionally operated in a
one-shot mode i.e. breakpoint is disabled after the first hit by
invoking perf_event_disable from hw_breakpoint_handler.

PowerPC server class processors follow 'trigger-before-execute', wherein
the breakpoint exception is triggered before the instruction performing
the memory access is executed. So the one-shot mode prevents the
processor from entering an infinite loop and the debugging tools like
GDB re-enable the breakpoints explicitly after a SIGTRAP.

Thanks,
K.Prasad

