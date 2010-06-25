Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0FYJbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 05:31:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:59943 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab0FYJbQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 05:31:16 -0400
Subject: Re: [RFC][PATCH] irq_work
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H.PeterA" <"nvin hpa"@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1277457439.3947.184.camel@yhuang-dev.sh.intel.com>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
	 <1277361352.1875.838.camel@laptop>
	 <1277431963.3947.140.camel@yhuang-dev.sh.intel.com>
	 <1277452110.22715.2116.camel@twins>
	 <1277457439.3947.184.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 25 Jun 2010 11:30:45 +0200
Message-ID: <1277458245.32034.96.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-25 at 17:17 +0800, Huang Ying wrote:
> On Fri, 2010-06-25 at 15:48 +0800, Peter Zijlstra wrote:
> > On Fri, 2010-06-25 at 10:12 +0800, Huang Ying wrote:
> > > 
> > > It is better to add "void *data" field in this struct to allow same
> > > function can be used for multiple struct irq_work. 
> > 
> > No, simply do:
> > 
> > struct my_foo {
> >   struct irq_work work;
> >   /* my extra data */
> > }
> > 
> > void my_func(struct irq_work *work)
> > {
> >   struct my_foo *foo = container_of(work, struct my_foo, work);
> > 
> >   /* tada! */
> > }
> 
> Yes. This works too. But Adding "void *data" field is helpful if you do
> not embed struct irq_work into another struct.

No, embedding is the normal way we do this in the kernel.

> > > And I think IRQ is the implementation detail here, so irq_work is
> > > probably not a good name. nmi_return_notifier or nmi_callback is better?
> > 
> > Well, its ran in hard-irq context, so its an irq work. There's nothing
> > that says it can only be used from NMI context.
> 
> It may be run in other contexts on some system (without APIC). 

I would consider that a BUG. Use a random IRQ source to process the
callbacks on these broken platforms.

> And I
> don't think it is useful to others except NMI handler. I think this is a
> choice between naming after implementation and purpose.

There is, although I'm sure people will yell at me for even proposing
this. You can raise the IPI from an IRQ disabled section to get
something done right after it.

> We can use another flag to signify whether it is executing. For example
> the bit 0 of entry->next.

There's no point.

> > I think clearing after the function is done executing is the only sane
> > semantics (and yes, I should fix the current perf code).
> > 
> > You can always miss an NMI since it can always happen before the
> > callback gets done, and allowing another enqueue before the callback is
> > complete is asking for trouble.
> 
> If we move entry->next = NULL before entry->func(entry), we will not
> miss the NMI. Can you show how to miss it in this way?

<NMI>
  ...
  irq_work_queue(&my_work, func);
  ...
<EOI>
<IPI>
  irq_work_run()

  <NMI>
    irq_work_queue(&my_work, func); <FAIL>
  <EOI>

   my_func.next = NULL;
<EOI>

Really not that hard. Now imagine wrapping irq_work in some state and
you reusing the state while the function is still running..
