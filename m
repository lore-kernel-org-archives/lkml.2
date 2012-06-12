Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab2FLJM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 05:12:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36404 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab2FLJM1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 05:12:27 -0400
Message-ID: <1339492335.31548.50.camel@twins>
Subject: Re: [Patch][perf] Invoke __perf_event_disable without an IPI
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: prasad@linux.vnet.ibm.com
Cc: Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Date: Tue, 12 Jun 2012 11:12:15 +0200
In-Reply-To: <20120612060626.GB2538@in.ibm.com>
References: <20120611060242.GA2538@in.ibm.com>
	 <1339413213.30462.11.camel@twins> <20120612060626.GB2538@in.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 11:36 +0530, K.Prasad wrote:
> On Mon, Jun 11, 2012 at 01:13:33PM +0200, Peter Zijlstra wrote:
> > On Mon, 2012-06-11 at 11:32 +0530, K.Prasad wrote:
> > 
> > > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > > index fd126f8..0e2c1eb 100644
> > > --- a/kernel/events/core.c
> > > +++ b/kernel/events/core.c
> > > @@ -1302,6 +1302,7 @@ static int __perf_event_disable(void *info)
> > >   */
> > >  void perf_event_disable(struct perf_event *event)
> > >  {
> > > +	int ret;
> > >  	struct perf_event_context *ctx = event->ctx;
> > >  	struct task_struct *task = ctx->task;
> > >  
> > > @@ -1314,6 +1315,17 @@ void perf_event_disable(struct perf_event *event)
> > >  	}
> > >  
> > >  retry:
> > > +	/*
> > > +	 * perf_event_disable may be called when interrupts are disabled.
> > > +	 * For e.g. hw_breakpoint_handler exception in PowerPC. Hence using
> > > +	 * IPIs to invoke __perf_event_disable is not always suitable. When
> > > +	 * possible invoke __perf_event_disable directly.
> > > +	 */
> > > +	if ((task_cpu(task) == smp_processor_id()) && irqs_disabled()) {
> > 
> > Urgh.. 
> > 
> > So what's the callchain for the ppc->hw_bp->perf that triggers this?
> 
> Hardware breakpoints for user-space have traditionally operated in a
> one-shot mode i.e. breakpoint is disabled after the first hit by
> invoking perf_event_disable from hw_breakpoint_handler.

I take it this is the same across architectures? So basically everybody
suffers this?

Hmm,. x86 doesn't seem to do this.. are you saying breakpoint semantics
differ across architectures? Really?

Oh man how I do hate this breakpoint crap.. I guess you might as well
use __perf_event_disable() directly, no point in butchering
perf_event_disable() or even task_function_call().
