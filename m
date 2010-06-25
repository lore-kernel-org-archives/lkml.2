Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab0FYJRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 05:17:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:26724 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab0FYJRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 05:17:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,480,1272870000"; 
   d="scan'208";a="579801444"
Subject: Re: [RFC][PATCH] irq_work
From: Huang Ying <ying.huang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H.PeterA" <"nvin hpa"@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1277452110.22715.2116.camel@twins>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
	 <1277361352.1875.838.camel@laptop>
	 <1277431963.3947.140.camel@yhuang-dev.sh.intel.com>
	 <1277452110.22715.2116.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Jun 2010 17:17:19 +0800
Message-ID: <1277457439.3947.184.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-25 at 15:48 +0800, Peter Zijlstra wrote:
> On Fri, 2010-06-25 at 10:12 +0800, Huang Ying wrote:
> > 
> > It is better to add "void *data" field in this struct to allow same
> > function can be used for multiple struct irq_work. 
> 
> No, simply do:
> 
> struct my_foo {
>   struct irq_work work;
>   /* my extra data */
> }
> 
> void my_func(struct irq_work *work)
> {
>   struct my_foo *foo = container_of(work, struct my_foo, work);
> 
>   /* tada! */
> }

Yes. This works too. But Adding "void *data" field is helpful if you do
not embed struct irq_work into another struct.

> > And I think IRQ is the implementation detail here, so irq_work is
> > probably not a good name. nmi_return_notifier or nmi_callback is better?
> 
> Well, its ran in hard-irq context, so its an irq work. There's nothing
> that says it can only be used from NMI context.

It may be run in other contexts on some system (without APIC). And I
don't think it is useful to others except NMI handler. I think this is a
choice between naming after implementation and purpose.

> > > +void irq_work_run(void)
> > > +{
> > > +     struct irq_work *list;
> > > +
> > > +     list = xchg(&__get_cpu_var(irq_work_list), CALLBACK_TAIL);
> > > +     while (list != CALLBACK_TAIL) {
> > > +             struct irq_work *entry = list;
> > > +
> > > +             list = list->next;
> > > +             entry->func(entry);
> > > +
> > > +             entry->next = NULL;
> > 
> > entry->next = NULL should be put before entry->func(entry), so that we
> > will not lose a notification from NMI. And maybe check irq_work_list for
> > several times to make sure nothing is lost.
> 
> But then _sync() will return before its done executing.

We can use another flag to signify whether it is executing. For example
the bit 0 of entry->next.

> I think clearing after the function is done executing is the only sane
> semantics (and yes, I should fix the current perf code).
> 
> You can always miss an NMI since it can always happen before the
> callback gets done, and allowing another enqueue before the callback is
> complete is asking for trouble.

If we move entry->next = NULL before entry->func(entry), we will not
miss the NMI. Can you show how to miss it in this way?

> > > +             /*
> > > +              * matches the mb in cmpxchg() in irq_work_queue()
> > > +              */
> > > +             smp_wmb();
> > > +     }
> > > +}
> > 
> > I don't know why we need smp_wmb() here and smp_rmb() in
> > irq_work_pending(). The smp_<x>mb() in original perf_pending_xxx code is
> > not necessary too. Because smp_<x>mb is invoked in wake_up_process() and
> > __wait_event() already.
> 
> The smp_wmb() wants to be before ->next = NULL; so that all writes are
> completed before we release the entry. To that same effect _sync() and
> _queue need the (r)mb.

It is reasonable in this way.

Best Regards,
Huang Ying


