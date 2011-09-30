Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab1I3VXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 17:23:12 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38461 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab1I3VXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 17:23:08 -0400
Date: Fri, 30 Sep 2011 14:23:04 -0700
From: Andrew Morton <akpm00@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <htejun@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH RFC] stop_machine: make stop_machine safe and efficient
 to call early
Message-Id: <20110930142304.c455799e.akpm00@gmail.com>
In-Reply-To: <1317400496.4588.54.camel@gandalf.stny.rr.com>
References: <4E85EE1F.7050508@goop.org>
	<1317400496.4588.54.camel@gandalf.stny.rr.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Sep 2011 12:34:54 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 2011-09-30 at 09:28 -0700, Jeremy Fitzhardinge wrote:
> > Make stop_machine() safe to call early in boot, before SMP has been
> > set up, by simply calling the callback function directly if there's
> > only one CPU online.
> > 
> > Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: H. Peter Anvin <hpa@linux.intel.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > 
> > diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
> > index ba5070c..2df15ca 100644
> > --- a/kernel/stop_machine.c
> > +++ b/kernel/stop_machine.c
> > @@ -485,6 +485,9 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
> >  					    .num_threads = num_online_cpus(),
> >  					    .active_cpus = cpus };
> >  
> > +	if (smdata.num_threads == 1)
> > +		return (*fn)(data);
> 
> Doesn't interrupts need to be disabled here too? As stop machine
> functions also guarantee that they will not be interrupted by
> interrupts.
> 

If we wish to truly emulate the stop_machine_cpu_stop() callback
environment then we should run hard_irq_disable() as well?

