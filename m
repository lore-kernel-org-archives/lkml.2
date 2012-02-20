Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab2BTMOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 07:14:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52086 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2BTMOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 07:14:52 -0500
Message-ID: <1329740076.2293.330.camel@twins>
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
From: Peter Zijlstra <peterz@infradead.org>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, bharata@linux.vnet.ibm.com
Date: Mon, 20 Feb 2012 13:14:36 +0100
In-Reply-To: <20120220120159.GA2350@linux.vnet.ibm.com>
References: <87mxa3zqm1.fsf@abhimanyu.in.ibm.com>
	 <4F046536.5080207@redhat.com> <4F048295.1050907@redhat.com>
	 <4F04898B.1080600@redhat.com> <1325712710.3084.10.camel@laptop>
	 <4F04C789.40209@redhat.com> <20120105091059.GA3249@elte.hu>
	 <87fwe6ork3.fsf@abhimanyu.in.ibm.com> <1329735073.2293.305.camel@twins>
	 <877gzhpvpv.fsf@abhimanyu.in.ibm.com>
	 <20120220120159.GA2350@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 17:32 +0530, Srivatsa Vaddagiri wrote:
> * Nikunj A Dadhania <nikunj@linux.vnet.ibm.com> [2012-02-20 17:23:16]:
> 
> > On Mon, 20 Feb 2012 11:51:13 +0100, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Mon, 2012-02-20 at 13:38 +0530, Nikunj A Dadhania wrote:
> > > > +#ifdef CONFIG_PARAVIRT_FLUSH_TLB
> > > > +               while (!cpumask_empty(to_cpumask(f->flush_cpumask)) && --loop)
> > > > +                       cpu_relax();
> > > > +               if (!loop && !cpumask_empty(to_cpumask(f->flush_cpumask)))
> > > > +                       halt();
> > > 
> > > 
> > > That's just vile, you don't need to wait for it, all you need to make
> > > sure is that when that vcpu wakes up it does the flush.
> > >
> > Yes, but we are not sure the vcpu will be sleeping or running. In the
> > case where vcpus are running, it might be beneficial to wait a while.
> 
> I guess one possibility is for host scheduler to export run/preempt
> information to guest OS, as was discussed in the context of this thread
> as well:
> 
> http://lkml.org/lkml/2010/4/6/223

Doesn't need to be the host scheduler, KVM itself can do that just fine
on guest entry/exit.

> Essentially guest OS will know (using such exported information) which of its 
> vcpus are currently running and thus do a busy-wait for them.

Right, do something like:

again:
  for_each_cpu_in_mask(cpu, flush_cpumask) {
    if !vcpu-running {
      set_flush-on-enter(cpu)
      if !vcpu-running
        cpumask_clear(flush_cpumask, cpu); // vm-enter will do  
  }
  wait-a-while-for-mask-to-clear
  if (!cpumask_empty)
    goto again;    

with the appropriate memory barriers and atomic instructions, that way
you can skip waiting for vcpus that are not in guest mode and vm-enter
will fixup.
